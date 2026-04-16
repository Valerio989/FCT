## Event

Rappresenta un evento rilevante accaduto nel sistema durante una sessione operativa.

### Campi v0

- `id`: identificativo univoco dell’evento
- `timestamp`: istante in cui l’evento è stato registrato
- `type`: tipo di evento
- `session_id`: identificativo della sessione a cui l’evento appartiene
- `drone_id`: identificativo del drone associato, se presente
- `mission_id`: identificativo della missione associata, se presente
- `payload`: contenuto sintetico dell’evento

### Note

Il modello `Event` v0 è pensato per supportare:

- event logging centralizzato
- correlazione con drone, missione e sessione
- timeline degli eventi
- replay delle sessioni

Il campo `payload` resta volutamente generico in v0.  
La sua struttura concreta verrà raffinata successivamente in funzione di:

- backend API
- persistence layer
- esigenze di replay
- bisogni della UI timeline

### Esempi di tipi evento

Esempi di eventi rilevanti nel MVP:

- drone_connected
- drone_disconnected
- telemetry_updated
- command_sent
- command_succeeded
- command_failed
- mission_assigned
- mission_started
- mission_completed
- mission_failed
- warning_raised