## Drone

Rappresenta un drone noto al sistema e visibile nella control tower.

### Campi v0

- `id`: identificativo univoco del drone nel sistema
- `display_name`: nome leggibile mostrato nella UI
- `connection_status`: stato di connessione del drone
- `current_mode`: modalità operativa corrente del drone
- `armed`: indica se il drone è armato
- `battery_percent`: livello batteria sintetico
- `position`: posizione corrente sintetica del drone
- `current_mission_id`: eventuale missione attualmente associata
- `health_status`: stato health sintetico derivato

### Note

Il modello `Drone` v0 è volutamente minimale.  
Campi aggiuntivi potranno essere introdotti successivamente quando emergeranno esigenze concrete da:

- adapter PX4
- telemetry service
- fleet overview
- drone detail view
- replay e observability