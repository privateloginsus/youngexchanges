const cfg=window.YEX_CONFIG||{};const ready=typeof cfg.supabaseUrl==='string'&&/^https:\/\/[a-z0-9-]+\.supabase\.co\/?$/i.test(cfg.supabaseUrl)&&typeof cfg.supabaseAnonKey==='string'&&cfg.supabaseAnonKey.startsWith('sb_publishable_')||typeof cfg.supabaseUrl==='string'&&/^https:\/\/[a-z0-9-]+\.supabase\.co\/?$/i.test(cfg.supabaseUrl)&&typeof cfg.supabaseAnonKey==='string'&&cfg.supabaseAnonKey.startsWith('eyJ');
const db=ready&&window.supabase?window.supabase.createClient(cfg.supabaseUrl,cfg.supabaseAnonKey):null;
const $=id=>document.getElementById(id);const money=n=>new Intl.NumberFormat('it-IT',{style:'currency',currency:'EUR'}).format(Number(n)||0);const num=n=>new Intl.NumberFormat('it-IT',{maximumFractionDigits:8}).format(Number(n)||0);const safe=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
function notice(msg,id='notice'){const el=$(id);if(el)el.textContent=msg}
function connected(){if(!db){notice('Collegamento non configurato: apri config.js e inserisci URL e chiave pubblica Supabase.');return false}return true}
async function current(){if(!db)return null;const {data}=await db.auth.getUser();return data.user}
async function signout(){await db?.auth.signOut();location.href='login.html'}
function chat(){(function(D){function f(){function n(n,e){e=D.createElement('script');e.src='https://image.providesupport.com/'+n;D.body.appendChild(e)}n('js/1jldikk2h1dv50s087l7unb9e3/safe-standard-sync.js?ps_h=8f7p&ps_t='+Date.now());n('sjs/static.js')}D.readyState==='complete'?f():window.addEventListener('load',f)})(document)}chat();
async function market(){try{const r=await fetch('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana,tether&vs_currencies=eur&include_24hr_change=true');if(!r.ok)throw Error('API non disponibile');return await r.json()}catch(e){return null}}
const coins={BTC:'bitcoin',ETH:'ethereum',SOL:'solana',USDT:'tether'};
