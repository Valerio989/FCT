# VehicleAdapter Interface v0

## Progetto

**Fleet Control Tower for PX4 Simulation**

## Scopo

Questo documento definisce l’interfaccia concettuale `VehicleAdapter` per il primo ciclo MVP del progetto FCT.

`VehicleAdapter` rappresenta il boundary tecnico tra il sistema FCT e il layer vehicle-facing.

Il suo obiettivo è isolare il core applicativo dai dettagli specifici di:

* PX4
* MAVSDK
* PX4 SITL
* Gazebo
* eventuale HITL futuro
* eventuali droni reali futuri
* eventuali altre architetture di controllore

L’interfaccia descritta in questo documento non è ancora una specifica implementativa C++ completa. È il contratto funzionale minimo da usare come riferimento per i task successivi del Vehicle Integration Layer.

---

## 1. Boundary architetturale

### 1.1 Ruolo del Vehicle Adapter Layer

Il Vehicle Adapter Layer è responsabile di parlare con i veicoli e normalizzare le informazioni tecniche provenienti dal controllore.

Nel primo MVP, l’implementazione concreta prevista è:

* adapter PX4 in C++
* MAVSDK C++ come libreria vehicle-facing
* nodo ROS2 dedicato come runtime dell’adapter

Il contratto `VehicleAdapter` deve però rimanere agnostico rispetto a PX4/MAVSDK.

### 1.2 Responsabilità del Vehicle Adapter Layer

`VehicleAdapter` è responsabile di:

* gestire il lifecycle logico dell’adapter
* scoprire veicoli disponibili
* connettere e disconnettere veicoli esplicitamente
* leggere telemetria normalizzata
* emettere aggiornamenti di telemetria come stream interno
* inviare comandi base vehicle-level
* restituire l’esito tecnico dei comandi
* emettere eventi tecnici adapter-level
* tradurre dettagli vehicle-specific in modelli adapter-level

### 1.3 Responsabilità del Core Application Layer

Il core applicativo FCT consuma gli output dell’adapter e costruisce il dominio applicativo.

Il core è responsabile di:

* fleet registry
* stato applicativo dei droni
* health sintetica
* mission dispatch
* mission tracking
* session management
* event logging applicativo
* persistence
* replay
* API REST
* WebSocket verso frontend
* payload specifici della dashboard

### 1.4 Separazione tra `Vehicle` e `Drone`

Nel contesto dell’adapter, un veicolo è rappresentato da modelli adapter-level come:

* `VehicleDescriptor`
* `VehicleTelemetry`
* `VehicleCommandResult`

Nel core applicativo, il drone è invece rappresentato da entità dominio come:

* `Drone`
* `FleetState`
* `MissionAssignment`
* `Event`
* `Session`

Quindi:

```text
VehicleTelemetry = dato tecnico normalizzato proveniente dal vehicle layer
Drone = entità applicativa gestita dalla control tower
```

`VehicleAdapter` non deve costruire direttamente oggetti di dominio applicativo.

---

## 2. Decisioni congelate

### 2.1 Decisione 3.1-A — Boundary tecnico dell’adapter

`VehicleAdapter` è il boundary tecnico verso il veicolo.

Il suo scopo è rendere il resto del sistema agnostico rispetto al controllore sottostante.

Il core FCT non deve sapere se il vehicle layer usa:

* PX4 SITL
* PX4 HITL
* MAVSDK
* drone reale
* simulatore alternativo
* mock adapter
* altro autopilota futuro

Il core deve consumare sempre lo stesso contratto adapter-level.

### 2.2 Decisione 3.1-B — Telemetria ibrida

La telemetria viene gestita con approccio ibrido:

* snapshot pull tramite ultimo stato noto
* stream push tramite aggiornamenti emessi dall’adapter

Questo permette:

* semplicità di debug
* supporto alla dashboard live
* integrazione naturale con ROS2 come middleware interno
* disaccoppiamento tra frequenza vehicle-facing e consumo applicativo

### 2.3 Decisione 3.1-C — Connect esplicito

La discovery non implica connessione automatica.

```text
discover_vehicles() non implica connect_vehicle(vehicle_id)
```

La discovery rileva i veicoli disponibili.

La connessione viene richiesta esplicitamente.

Questa scelta rende il comportamento più controllabile durante sviluppo, debug e test multi-drone.

### 2.4 Decisione 3.1-D — Modelli adapter-level

`VehicleAdapter` usa modelli separati dal dominio applicativo:

* `VehicleDescriptor`
* `VehicleTelemetry`
* `VehicleCommand`
* `VehicleCommandResult`
* `AdapterEvent`

Questi modelli rappresentano solo dati tecnici normalizzati provenienti dal vehicle layer o diretti al vehicle layer.

Non rappresentano entità applicative come `Drone`, `Mission`, `Session` o `Event` persistito.

### 2.5 Decisione 3.1-E — Out-of-scope esplicito

`VehicleAdapter` v0 non include:

* mission dispatch completo
* operazioni fleet-level
* health applicativa
* persistence
* replay
* API/WebSocket/UI payload
* tipi PX4/MAVSDK nel contratto pubblico
* retry policy avanzata
* plugin system multi-autopilot

### 2.6 Decisione 3.1-F — Documento di riferimento

Questo documento è il riferimento v0 per:

* responsabilità dell’adapter
* metodi minimi dell’interfaccia
* modelli adapter-level
* enum e stati minimi
* confini rispetto al core applicativo
* task successivi 3.2, 3.3, 3.4, 3.5

---

## 3. Interfaccia concettuale v0

### 3.1 Lifecycle

Operazioni minime:

```text
start()
stop()
get_adapter_status()
```

Significato:

* `start()` avvia il lifecycle logico dell’adapter
* `stop()` ferma l’adapter in modo pulito
* `get_adapter_status()` restituisce lo stato tecnico dell’adapter

Stati previsti:

```text
STOPPED
STARTING
RUNNING
DEGRADED
ERROR
```

### 3.2 Discovery e connection

Operazioni minime:

```text
discover_vehicles()
get_known_vehicles()
connect_vehicle(vehicle_id)
disconnect_vehicle(vehicle_id)
get_vehicle_connection_status(vehicle_id)
```

Significato:

* `discover_vehicles()` esegue una discovery attiva dei veicoli disponibili
* `get_known_vehicles()` restituisce i veicoli già noti all’adapter
* `connect_vehicle(vehicle_id)` tenta la connessione logica a un veicolo specifico
* `disconnect_vehicle(vehicle_id)` disconnette logicamente un veicolo
* `get_vehicle_connection_status(vehicle_id)` restituisce lo stato di connessione del veicolo

La separazione discovery/connection è intenzionale.

### 3.3 Telemetry

Operazioni minime:

```text
get_latest_telemetry(vehicle_id)
emit telemetry updates as stream events
```

Significato:

* `get_latest_telemetry(vehicle_id)` restituisce l’ultimo snapshot noto
* gli aggiornamenti di telemetria vengono emessi come stream adapter-level

Il documento non vincola ancora la forma concreta dello stream.

Nel runtime MVP lo stream potrà essere realizzato tramite ROS2 topic.

### 3.4 Commands

Operazione minima:

```text
send_command(vehicle_id, command)
```

Comandi v0:

```text
ARM
DISARM
TAKEOFF
LAND
RETURN_TO_LAUNCH
```

La scelta è usare un metodo generico `send_command(...)`, non metodi specifici come:

```text
arm()
takeoff()
land()
return_to_launch()
```

Gli endpoint applicativi o UI potranno essere specifici, ma il boundary adapter resta compatto.

### 3.5 Adapter events

L’adapter emette eventi tecnici adapter-level.

Eventi minimi:

```text
VEHICLE_DISCOVERED
VEHICLE_CONNECTED
VEHICLE_DISCONNECTED
TELEMETRY_UPDATED
VEHICLE_STATUS_CHANGED
COMMAND_ACKNOWLEDGED
COMMAND_FAILED
ADAPTER_ERROR
```

Questi eventi non sono ancora eventi applicativi persistiti.

Il core applicativo può trasformare un `AdapterEvent` in un `Event` applicativo, associarlo a una sessione e salvarlo nel persistence layer.

---

## 4. Modelli adapter-level

## 4.1 `VehicleDescriptor`

Rappresenta un veicolo scoperto dall’adapter.

Campi minimi:

```text
vehicle_id
controller_type
system_id
instance_id
connection_uri
discovered_at
connection_status
```

Descrizione campi:

* `vehicle_id`: identificativo stabile usato sopra il boundary adapter
* `controller_type`: tipo di controllore o integrazione, per esempio `PX4`
* `system_id`: identificativo tecnico del veicolo, se disponibile
* `instance_id`: istanza simulata locale, utile in SITL multi-drone
* `connection_uri`: endpoint tecnico o URI logico usato dall’adapter
* `discovered_at`: timestamp di discovery
* `connection_status`: stato corrente della connessione

Nota:

`VehicleDescriptor` non è `Drone`.

`Drone` appartiene al core applicativo.

---

## 4.2 `VehicleTelemetry`

Rappresenta l’ultimo stato tecnico noto del veicolo.

Campi obbligatori:

```text
vehicle_id
timestamp
position
attitude
battery_percent
armed
flight_mode
connection_status
```

### Position

Campi minimi:

```text
latitude_deg
longitude_deg
altitude_m
relative_altitude_m
```

### Attitude

Campi minimi:

```text
roll_deg
pitch_deg
yaw_deg
```

`attitude` è obbligatoria in v0.

Motivazione:

* è telemetria vehicle-level pura
* è utile per observability e debug
* valorizza la componente robotics/control del progetto
* non introduce logica applicativa nel layer adapter

### Flight mode

`flight_mode` deve essere normalizzato a livello adapter.

Esempi possibili:

```text
UNKNOWN
HOLD
TAKEOFF
MISSION
LAND
RETURN_TO_LAUNCH
OFFBOARD
MANUAL
```

La mappatura precisa PX4/MAVSDK verso stati normalizzati verrà raffinata nel Task 3.4.

---

## 4.3 `VehicleCommand`

Rappresenta una richiesta operativa diretta a un veicolo.

Campi minimi:

```text
command_id
vehicle_id
command_type
params
requested_at
timeout_ms
```

Comandi v0:

```text
ARM
DISARM
TAKEOFF
LAND
RETURN_TO_LAUNCH
```

Parametri minimi:

```text
TAKEOFF:
- target_altitude_m

ARM:
- no params

DISARM:
- no params

LAND:
- no params

RETURN_TO_LAUNCH:
- no params
```

Mission dispatch non entra in `VehicleCommand` v0.

Eventuali comandi come upload mission, start mission o abort mission verranno valutati nei task dedicati al mission dispatcher.

---

## 4.4 `VehicleCommandResult`

Rappresenta l’esito tecnico di un comando.

Campi minimi:

```text
command_id
vehicle_id
command_type
status
error_code
message
started_at
completed_at
```

Status previsti:

```text
ACCEPTED
REJECTED
SUCCEEDED
FAILED
TIMEOUT
```

Distinzione importante:

```text
ACCEPTED = comando preso in carico o inviato al vehicle layer
SUCCEEDED = comando completato con esito positivo confermato dal vehicle layer
```

Questa distinzione permette di gestire meglio comandi asincroni o comandi che richiedono tempo.

---

## 4.5 `AdapterEvent`

Rappresenta un evento tecnico emesso dall’adapter.

Campi minimi:

```text
event_id
timestamp
event_type
vehicle_id optional
severity
payload
```

Eventi v0:

```text
VEHICLE_DISCOVERED
VEHICLE_CONNECTED
VEHICLE_DISCONNECTED
TELEMETRY_UPDATED
VEHICLE_STATUS_CHANGED
COMMAND_ACKNOWLEDGED
COMMAND_FAILED
ADAPTER_ERROR
```

Severity v0:

```text
INFO
WARNING
ERROR
```

Nota:

`AdapterEvent` non è l’`Event` persistito del dominio applicativo.

Il core applicativo può trasformare eventi adapter-level in eventi applicativi persistibili.

---

## 5. Enum e stati minimi

### 5.1 `AdapterStatus`

```text
STOPPED
STARTING
RUNNING
DEGRADED
ERROR
```

### 5.2 `VehicleConnectionStatus`

```text
UNKNOWN
DISCOVERED
CONNECTING
CONNECTED
DISCONNECTED
STALE
ERROR
```

Significato operativo:

* `UNKNOWN`: stato non noto o non inizializzato
* `DISCOVERED`: veicolo rilevato ma non ancora connesso logicamente
* `CONNECTING`: connessione in corso
* `CONNECTED`: connessione attiva
* `DISCONNECTED`: veicolo non connesso
* `STALE`: veicolo precedentemente attivo ma telemetria/link non aggiornati
* `ERROR`: errore tecnico di connessione o comunicazione

### 5.3 `VehicleCommandType`

```text
ARM
DISARM
TAKEOFF
LAND
RETURN_TO_LAUNCH
```

### 5.4 `VehicleCommandStatus`

```text
ACCEPTED
REJECTED
SUCCEEDED
FAILED
TIMEOUT
```

### 5.5 `AdapterEventType`

```text
VEHICLE_DISCOVERED
VEHICLE_CONNECTED
VEHICLE_DISCONNECTED
TELEMETRY_UPDATED
VEHICLE_STATUS_CHANGED
COMMAND_ACKNOWLEDGED
COMMAND_FAILED
ADAPTER_ERROR
```

### 5.6 `AdapterEventSeverity`

```text
INFO
WARNING
ERROR
```

---

## 6. Out-of-scope v0

`VehicleAdapter` v0 non include le seguenti responsabilità.

### 6.1 Mission dispatch completo

Fuori scope:

```text
upload_mission(...)
start_mission(...)
pause_mission(...)
resume_mission(...)
abort_mission(...)
get_mission_progress(...)
```

Queste operazioni appartengono ai task successivi sul mission domain e mission dispatcher.

### 6.2 Fleet-level operations

Fuori scope:

```text
connect_all()
disconnect_all()
arm_all()
land_all()
broadcast_command()
get_fleet_state()
```

L’adapter lavora su singolo veicolo.

Le policy di flotta appartengono al core applicativo.

### 6.3 Health applicativa

Fuori scope:

```text
compute_health_status(vehicle_id)
get_drone_health(vehicle_id)
```

L’adapter fornisce segnali tecnici come:

* connection status
* battery percent
* telemetry freshness
* command failure
* adapter error

Il core applicativo decide la health sintetica.

### 6.4 Persistence ed event logging applicativo

Fuori scope:

```text
save_event(...)
save_telemetry(...)
save_command_result(...)
open_session(...)
close_session(...)
```

L’adapter emette eventi tecnici.

Il core decide cosa persistere.

### 6.5 API, WebSocket e UI payload

Fuori scope:

```text
to_api_response()
to_websocket_payload()
publish_to_frontend()
```

L’adapter non conosce frontend, FastAPI o WebSocket.

### 6.6 Tipi PX4/MAVSDK nel contratto pubblico

Fuori dal contratto pubblico:

```text
mavsdk::System
mavsdk::Telemetry
mavsdk::Action
MAVLink raw messages
PX4 custom mode raw
Gazebo entity name
```

Questi dettagli appartengono solo all’implementazione concreta.

### 6.7 Retry policy avanzata

Fuori scope:

```text
retry_count configurable
exponential_backoff
command queue
priority command scheduling
dead-letter queue
```

In v0 bastano:

```text
timeout_ms
VehicleCommandStatus.TIMEOUT
VehicleCommandStatus.FAILED
```

### 6.8 Plugin system multi-autopilot

Fuori scope:

```text
ArduPilotAdapter
GenericMavlinkAdapter
AdapterFactory complessa
plugin system runtime
```

Il contratto resta estendibile, ma la sola implementazione prevista nel primo ciclo è PX4/MAVSDK.

---

## 7. Mapping verso task successivi

### Task 3.2 — Discovery dei droni

Usa:

```text
discover_vehicles()
get_known_vehicles()
VehicleDescriptor
VehicleConnectionStatus
VEHICLE_DISCOVERED
```

Output atteso:

* rilevamento automatico delle istanze attive
* identificazione univoca dei veicoli
* backend in grado di vedere i 3 droni simulati

### Task 3.3 — Ingestione telemetria base

Usa:

```text
get_latest_telemetry(vehicle_id)
telemetry stream
VehicleTelemetry
TELEMETRY_UPDATED
```

Output atteso:

* posizione
* attitude
* batteria
* armed
* flight mode
* stato connessione

### Task 3.4 — Traduzione stati PX4

Usa:

```text
flight_mode
connection_status
VehicleConnectionStatus
AdapterEvent
VEHICLE_STATUS_CHANGED
```

Output atteso:

* mapping PX4/MAVSDK verso stati adapter-level normalizzati
* vocabolario coerente consumabile dal backend e poi dal frontend

### Task 3.5 — Comandi base

Usa:

```text
send_command(vehicle_id, command)
VehicleCommand
VehicleCommandResult
VehicleCommandType
VehicleCommandStatus
COMMAND_ACKNOWLEDGED
COMMAND_FAILED
```

Output atteso:

* arm
* disarm
* takeoff
* land
* return to launch
* esito tecnico comando
* propagazione errore base

---

## 8. Note implementative non vincolanti

Queste note descrivono la direzione implementativa attesa, ma non fanno parte del contratto astratto dell’interfaccia.

Implementazione prevista per il primo MVP:

```text
Px4VehicleAdapter
- C++
- MAVSDK C++
- nodo ROS2 dedicato
```

Nome runtime atteso:

```text
px4_adapter_node
```

Possibili canali ROS2 da definire nei task successivi:

```text
/fleet/telemetry
/fleet/events
/fleet/command
```

La definizione precisa di topic, service, action, QoS e messaggi ROS2 è rimandata ai task implementativi successivi.

---

## 9. Regola finale

Ogni modifica futura a `VehicleAdapter` deve rispettare questa regola:

```text
Se una responsabilità richiede conoscenza di missioni, sessioni, replay, persistence, API o UI, allora non appartiene a VehicleAdapter.

Se una responsabilità riguarda comunicazione tecnica con il veicolo, normalizzazione vehicle-level, telemetria o comandi base, allora può appartenere a VehicleAdapter.
```

---

## 10. Stato del documento

Versione: `v0`

Stato: bozza da validare

Task di riferimento: `3.1 — Definizione dell’interfaccia VehicleAdapter`

Output atteso dopo validazione:

* documento salvabile in repo
* base per Task 3.2, 3.3, 3.4, 3.5
* riferimento per successiva interfaccia C++ concreta
