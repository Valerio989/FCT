## Telemetry Fields v0

I campi minimi di telemetria e stato osservabile del MVP sono definiti per supportare:

- fleet overview
- drone detail view
- command validation minima
- health sintetica
- event correlation

### Campi v0

- `position`: posizione corrente sintetica del drone
- `battery_percent`: livello batteria corrente
- `current_mode`: modalità operativa corrente del drone
- `armed`: stato arm/disarm del drone

### Campi applicativi correlati

I seguenti campi sono correlati alla telemetria, ma rappresentano uno stato applicativo o derivato:

- `mission_status`: stato corrente della missione associata, se presente
- `health_status`: stato health sintetico derivato da connessione e stato osservabile

### Note

Il set v0 è volutamente minimale.

In questa fase non vengono ancora dettagliati formalmente:

- struttura esatta di `position`
- frequenza di aggiornamento
- distinzione tra stream live e persistenza
- campi avanzati come velocità, heading, quota relativa, GPS fix o home position

Questi aspetti verranno definiti successivamente in funzione di:

- adapter PX4
- telemetry service
- backend API
- frontend detail view
- esigenze di replay e observability