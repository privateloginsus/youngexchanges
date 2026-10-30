-- YoungExchange: esegui una sola volta in Supabase SQL Editor.
-- ATTENZIONE: dati di conti e saldi interni, NON fondi reali.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 account_code text not null unique default ('YEX-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,12))),
 display_name text not null default '', email text not null default '', contact_phone text not null default '',
 role text not null default 'client' check (role in ('client','admin')),
 created_at timestamptz not null default now()
);
create table if not exists public.wallets (
 user_id uuid primary key references public.profiles(id) on delete cascade,
 eur_balance numeric(18,2) not null default 0 check (eur_balance>=0),
 updated_at timestamptz not null default now()
);
create table if not exists public.requests (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.profiles(id) on delete cascade,
 kind text not null check(kind in ('swap','transfer')),
 amount numeric(24,8) not null check(amount>0),
 asset_from text,asset_to text,quoted_amount numeric(24,8),
 description text not null check(length(description)<=500),
 status text not null default 'ricevuta' check(status in ('ricevuta','in_revisione','chiusa','annullata')),
 created_at timestamptz not null default now()
);
create table if not exists public.audit_log (
 id bigint generated always as identity primary key,
 actor_id uuid references auth.users(id),target_user_id uuid references public.profiles(id),
 action text not null, details jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.profiles where id=(select auth.uid()) and role='admin');
$$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;
create or replace function public.on_signup() returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.profiles(id,display_name,email,contact_phone)
 values(new.id,left(coalesce(new.raw_user_meta_data->>'display_name',''),80),coalesce(new.email,''),left(coalesce(new.raw_user_meta_data->>'contact_phone',''),24));
 insert into public.wallets(user_id) values(new.id);
 return new;
end;$$;
drop trigger if exists youngexchange_user_created on auth.users;
create trigger youngexchange_user_created after insert on auth.users for each row execute function public.on_signup();
alter table public.profiles enable row level security;
alter table public.wallets enable row level security;
alter table public.requests enable row level security;
alter table public.audit_log enable row level security;
drop policy if exists profiles_read on public.profiles;
create policy profiles_read on public.profiles for select to authenticated using(id=(select auth.uid()) or (select public.is_admin()));
drop policy if exists wallets_read on public.wallets;
create policy wallets_read on public.wallets for select to authenticated using(user_id=(select auth.uid()) or (select public.is_admin()));
drop policy if exists requests_read on public.requests;
create policy requests_read on public.requests for select to authenticated using(user_id=(select auth.uid()) or (select public.is_admin()));
drop policy if exists requests_create on public.requests;
create policy requests_create on public.requests for insert to authenticated with check(user_id=(select auth.uid()) and status='ricevuta');
drop policy if exists requests_admin_update on public.requests;
create policy requests_admin_update on public.requests for update to authenticated using((select public.is_admin())) with check((select public.is_admin()));
drop policy if exists audit_admin_read on public.audit_log;
create policy audit_admin_read on public.audit_log for select to authenticated using((select public.is_admin()));
-- Non ci sono policy di modifica diretta per profiles, wallets e audit_log.
create or replace function public.admin_set_balance(target_id uuid,new_amount numeric,change_reason text)
returns void language plpgsql security definer set search_path='' as $$
declare old_amount numeric;
begin
 if not public.is_admin() then raise exception 'Non autorizzato'; end if;
 if new_amount is null or new_amount<0 or new_amount>1000000000000 then raise exception 'Importo non valido'; end if;
 if change_reason is null or length(trim(change_reason))<3 then raise exception 'Motivo obbligatorio'; end if;
 select eur_balance into old_amount from public.wallets where user_id=target_id for update;
 if not found then raise exception 'Conto non trovato'; end if;
 update public.wallets set eur_balance=round(new_amount,2),updated_at=now() where user_id=target_id;
 insert into public.audit_log(actor_id,target_user_id,action,details) values(auth.uid(),target_id,'balance_updated',jsonb_build_object('previous',old_amount,'current',round(new_amount,2),'reason',left(change_reason,250)));
end;$$;
revoke all on function public.admin_set_balance(uuid,numeric,text) from public;
grant execute on function public.admin_set_balance(uuid,numeric,text) to authenticated;
-- Abilita Realtime, evitando errore se le tabelle sono gia presenti nella publication.
do $$ begin
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='wallets') then alter publication supabase_realtime add table public.wallets; end if;
 if not exists(select 1 from pg_publication_tables where pubname='supabase_realtime' and schemaname='public' and tablename='requests') then alter publication supabase_realtime add table public.requests; end if;
end $$;
-- DOPO la tua registrazione, assegna il ruolo admin SOLO al tuo indirizzo email:
-- update public.profiles set role='admin' where id=(select id from auth.users where email='TUA_EMAIL@ESEMPIO.IT');
-- Verifica che la query abbia modificato esattamente 1 riga.
