## Session

Rappresenta una sessione operativa del sistema, utile per raggruppare eventi, missioni e contesto di esecuzione.

### Campi v0

- `id`: identificativo univoco della sessione
- `name`: nome della sessione
- `start_time`: timestamp di inizio sessione
- `end_time`: timestamp di fine sessione
- `scenario_name`: nome dello scenario associato alla sessione
- `notes`: note testuali opzionali sulla sessione

### Note

Il modello `Session` v0 è pensato per supportare:

- raggruppamento logico degli eventi
- ricostruzione della timeline operativa
- replay di una esecuzione passata
- identificazione di uno scenario demo o test

Il modello è volutamente minimale.  
Dettagli ulteriori, come stato della sessione, metadati tecnici di avvio, configurazioni di simulazione o riferimenti a build/versioni, potranno essere introdotti successivamente se emergerà un bisogno reale.