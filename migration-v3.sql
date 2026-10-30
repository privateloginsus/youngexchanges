-- YoungExchange V3: MIGRAZIONE OPZIONALE (eseguire dopo schema.sql V2)
-- Registra i cambiamenti di stato delle richieste effettuati dall'amministratore.
create or replace function public.audit_request_status() returns trigger
language plpgsql security definer set search_path='' as $$
begin
  if new.status is distinct from old.status then
    insert into public.audit_log(actor_id,target_user_id,action,details)
    values(auth.uid(),new.user_id,'request_status_updated',
      jsonb_build_object('request_id',new.id,'previous',old.status,'current',new.status));
  end if;
  return new;
end;$$;
drop trigger if exists yex_audit_request_status on public.requests;
create trigger yex_audit_request_status after update of status on public.requests
for each row execute function public.audit_request_status();
