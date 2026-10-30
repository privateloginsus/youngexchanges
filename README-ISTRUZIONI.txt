YOUNGEXCHANGE V4 — GUIDA DI INSTALLAZIONE

1. Estrai lo ZIP in una cartella. Non caricare lo ZIP intero su GitHub Pages.
2. Apri config.js con Blocco note. Inserisci URL progetto Supabase e chiave PUBLISHABLE (non service_role).
3. NON inserire segreti Twilio o SMTP nei file del sito.
4. Supabase: Authentication > Sign In / Providers > Email, Confirm email ON.
5. Supabase: Authentication > Email Templates > Confirm sign up: usa {{ .Token }} e verifica che il codice arrivi.
6. Configura SMTP personalizzato per invio email a utenti reali.
7. Supabase: Authentication > Phone: configura Twilio Account SID, Auth Token e Messaging Service SID MG; conferme telefono ON.
8. In Twilio, il Messaging Service deve avere un mittente SMS idoneo all'Italia e permessi geografici.
9. In Supabase: Authentication > URL Configuration: Site URL https://TUO_USERNAME.github.io/youngexchange-platform/ e Redirect URLs per login.html e reset.html.
10. Se il repository GitHub e' vuoto, crea un README direttamente su GitHub e prova Upload files con pochi file. In alternativa usa GitHub Desktop o git locale; non pubblicare finche' non funziona.
11. Copia i file della cartella youngexchange-v4 nella ROOT del repository, NON nella sottocartella.
12. GitHub > Settings > Pages > Deploy from a branch > main > /(root) > Save.
13. Esegui test: homepage, markets.html, registrazione email OTP, accesso, associazione telefono SMS, portafoglio, admin.
14. Prima di usare dati veri: verifica RLS e policy; valuta privacy, termini, cookie, requisiti KYC e autorizzazioni regolatorie.

NOTA: La pagina legal.html e' un segnaposto, non una informativa privacy valida.
NOTA: CoinGecko free API puo' applicare limiti di richiesta. Il grafico puo' risultare non disponibile.
NOTA: I piccoli grafici decorativi sulla homepage non rappresentano serie storiche reali. Prezzi e variazioni vengono richiesti a CoinGecko.
NOTA: L'OTP email richiede il template con token; se il provider invia link, la UI va adeguata.
NOTA: SMS associato tramite updateUser + verifyOtp(type phone_change). Verifica sul tuo progetto prima di aprire agli utenti.
NOTA: Un sito GitHub Pages e' pubblico. L'autorizzazione vera e' nelle policy Supabase, non nell'HTML.
NOTA: I dati di portafoglio e le richieste sono interni e NON fondi o trasferimenti effettivi.
