YOUNGEXCHANGE V5 - ISTRUZIONI

1. Estrai lo ZIP.
2. Apri config.js e inserisci il Project URL e la chiave PUBLISHABLE Supabase. NON inserire service_role, Twilio Auth Token o altre chiavi segrete.
3. Per la prima prova apri index.html nel browser; il caricamento delle API potrebbe richiedere pubblicazione HTTPS.
4. Su GitHub carica tutti i file nella root del repository (non la cartella e non lo ZIP). Commit su main; Settings > Pages > Deploy from branch > main > /(root).
5. Testa dashboard.html, markets.html, trading.html, portfolio.html, wallet.html, activity.html, security.html, support.html.
6. I dati CoinGecko si aggiornano ogni 60 secondi, non tick-by-tick. L'API gratuita puo' applicare limiti di richiesta. Il grafico e' storico a 7 giorni.
7. Questa versione NON esegue ordini, depositi o prelievi. I relativi pulsanti sono disabilitati. Non presentarla come exchange con operativita' reale.
8. Prima di consentire registrazioni pubbliche, rivedi le policy RLS Supabase, i permessi admin, i flussi OTP e gli obblighi normativi.
9. La chat ProvideSupport e' integrata nel sito e nella pagina Assistenza.
10. home.html e' la vecchia homepage pubblica, exchange.html e' la vecchia pagina di richieste, mantenute come riferimento e non collegate al nuovo menu.
