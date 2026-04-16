## Mission States v0

Gli stati missione del MVP sono definiti come insieme minimo e coerente con il workflow iniziale di mission dispatch.

### Stati

- `pending`: missione creata o assegnata, ma non ancora avviata
- `running`: missione attualmente in esecuzione
- `completed`: missione completata con esito positivo
- `failed`: missione terminata con errore o esito negativo
- `aborted`: missione interrotta intenzionalmente prima del completamento

### Note

Questo set di stati è volutamente minimale.

Gli stati sono pensati per supportare:

- tracking della missione lato backend
- visualizzazione dello stato missione lato UI
- correlazione con eventi e replay
- gestione semplice del lifecycle missione nel MVP

Stati aggiuntivi potranno essere introdotti successivamente se emergerà un bisogno reale da:

- adapter PX4
- mission dispatcher
- UI mission panel
- replay e observability