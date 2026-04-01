# Product Definition v0

## 1. Nome provvisorio

**Fleet Control Tower for PX4 Simulation**

## 2. One-liner

Una control tower **sim-first** per gestire flotte di droni PX4 in simulazione: monitoraggio live, dispatch missioni, event logging e replay delle sessioni.

## 3. Visione

Costruire una piattaforma software che permetta di:

* orchestrare più droni simulati in modo centralizzato
* testare scenari multi-drone in modo ripetibile
* osservare e debuggare il comportamento della flotta
* creare una base estendibile verso HITL o droni reali in futuro

La piattaforma non nasce come dashboard estetica, ma come **strumento operativo e di sviluppo**.

## 4. Problema che risolve

### Problema principale

Quando si lavora con più droni, manca presto una vista unificata e ordinata di:

* stato della flotta
* missioni attive
* eventi
* fault
* telemetria sintetica
* storico e replay

### Problema secondario

La simulazione multi-drone è utile, ma spesso rimane sparsa tra:

* terminali
* tool diversi
* log poco leggibili
* script ad hoc
* poca tracciabilità delle missioni

### Tesi

Il prodotto serve a trasformare una simulazione multi-drone da insieme di processi sparsi a **ambiente orchestrato e osservabile**.

## 5. Utente target iniziale

### Primary target

* sviluppatori robotics
* team R&D
* studenti e ricercatori avanzati
* piccoli team che lavorano con PX4 e scenari multi-drone

### Secondary target

* startup early-stage
* lab che vogliono testare logiche di assegnazione missioni
* team che vogliono mostrare demo multi-drone pulite

### Utente da non servire ora

* operatori enterprise reali
* clienti che chiedono compliance, BVLOS, regulatory ops, supporto di campo
* chi vuole già un prodotto pronto per flotte reali outdoor

## 6. Posizionamento

### Non è

* un autopilota
* un GCS completo general purpose
* un sistema enterprise per operazioni reali
* un framework di swarm intelligence avanzata

### È

* una **control tower software**
* un layer di **fleet orchestration**
* uno strumento di **observability e replay**
* una piattaforma **sim-first**

## 7. Use case iniziale

### Use case principale

Un utente lancia una simulazione con 3 droni PX4, apre la dashboard, vede la flotta, assegna missioni semplici, osserva l’evoluzione dello stato, registra gli eventi e poi rivede la sessione in replay.

### Use case secondari

* testing di regole di dispatch
* visualizzazione centralizzata della flotta
* debug di fault o anomalie
* demo portfolio multi-drone

## 8. MVP v1

### Obiettivo MVP

Gestire **3 droni simulati** in maniera centralizzata.

### Funzioni incluse

* discovery dei droni disponibili
* stato live per ogni drone
* telemetria base:

  * posizione
  * battery
  * flight mode
  * armed/disarmed
  * mission state
  * health sintetica
* comandi base:

  * arm
  * takeoff
  * land
  * return to launch
* assegnazione missione semplice
* event log centralizzato
* replay della sessione

### Missione semplice

Per l’MVP, una missione può essere:

* decollo
* raggiungi waypoint
* attesa breve
* rientro o atterraggio

### Cosa escludiamo dal MVP

* avoidance avanzato
* controllo distribuito tra droni
* allocazione ottima complessa
* supporto multi-autopilot
* supporto cloud enterprise
* auth e ruoli avanzati
* app mobile
* UI 3D sofisticata

## 9. Requisiti funzionali

### RF-1 — Fleet discovery

Il sistema deve rilevare i droni attivi e registrarli come entità gestibili.

### RF-2 — Fleet state

Il sistema deve mantenere uno stato aggiornato della flotta.

### RF-3 — Drone state detail

Per ogni drone devono essere disponibili:

* ID
* stato connessione
* modalità di volo
* batteria
* posizione
* missione corrente
* stato sintetico

### RF-4 — Command interface

L’utente deve poter inviare comandi base a un singolo drone.

### RF-5 — Mission dispatch

L’utente deve poter assegnare una missione semplice a un drone selezionato.

### RF-6 — Mission tracking

Il sistema deve tracciare lo stato della missione:

* pending
* running
* completed
* failed
* aborted

### RF-7 — Event logging

Ogni evento rilevante deve essere salvato:

* connessione drone
* cambio stato
* comando inviato
* missione assegnata
* missione completata o fallita
* allarme

### RF-8 — Replay

L’utente deve poter rivedere una sessione passata attraverso timeline ed eventi.

## 10. Requisiti non funzionali

### RNF-1 — Modularità

Adapter verso simulatori e protocolli separati dal core dominio.

### RNF-2 — Estendibilità

Il sistema deve poter supportare in futuro:

* HITL
* droni reali
* adapter aggiuntivi
* politiche di dispatch più avanzate

### RNF-3 — Ripetibilità

Le sessioni devono essere registrabili e riproducibili.

### RNF-4 — Semplicità

L’MVP deve essere sviluppabile da side hustle senza stack eccessivamente pesante.

### RNF-5 — Osservabilità

Log, eventi e stato devono essere facili da leggere e usare in debug.

## 11. Architettura logica v0

### A. Simulation Layer

Contiene:

* PX4 SITL
* istanze multiple di droni
* scenario simulato

### B. Vehicle Adapter Layer

Strato che parla con i droni simulati e traduce:

* telemetria
* stato
* comandi
* mission events

Qui conviene introdurre un adapter tipo:

* `VehicleAdapter`
* `PX4Adapter`

Così il resto del sistema non dipende direttamente dai dettagli del simulatore.

### C. Core Domain Layer

Entità principali:

* `Drone`
* `Fleet`
* `Mission`
* `MissionAssignment`
* `TelemetrySnapshot`
* `Event`
* `Alert`
* `Session`

Servizi principali:

* fleet registry
* telemetry service
* mission dispatcher
* event logger
* replay service

### D. Persistence Layer

Memorizza:

* sessioni
* eventi
* missioni
* snapshot sintetici

### E. Frontend Layer

Dashboard web con:

* lista droni
* dettaglio drone
* pannello missioni
* event timeline
* replay

## 12. Data model minimo

### Drone

* id
* display_name
* connection_status
* current_mode
* battery_percent
* armed
* position
* current_mission_id
* health_status

### Mission

* id
* type
* waypoints
* assigned_drone_id
* status
* created_at
* started_at
* ended_at

### Event

* id
* timestamp
* drone_id opzionale
* mission_id opzionale
* type
* payload sintetico

### Session

* id
* name
* start_time
* end_time
* scenario_name
* notes

## 13. Flusso operativo MVP

### Scenario base

1. L’utente avvia la simulazione.
2. Il backend scopre i droni.
3. La dashboard mostra la flotta.
4. L’utente seleziona un drone.
5. L’utente invia una missione.
6. Il sistema aggiorna stato e telemetria.
7. Gli eventi vengono registrati.
8. A fine sessione l’utente può vedere il replay.

## 14. Roadmap v0

### Fase 1 — Setup e architettura

**Output**

* repo iniziale
* struttura moduli
* simulazione multi-drone avviabile
* schema dominio v0

### Fase 2 — Adapter e telemetria

**Output**

* discovery droni
* ingestione telemetria
* stato sintetico drone

### Fase 3 — Dashboard base

**Output**

* vista flotta
* vista singolo drone
* comandi base

### Fase 4 — Mission dispatch

**Output**

* modello missione
* invio missioni semplici
* tracking stato missione

### Fase 5 — Event logging e replay

**Output**

* sessioni
* timeline eventi
* replay base

### Fase 6 — Demo hardening

**Output**

* demo pulita
* README forte
* video portfolio

## 15. Metriche di successo MVP

Per dire che l’MVP è riuscito, fissiamo queste metriche:

* gestione stabile di **3 droni simultanei**
* aggiornamento stato flotta in tempo quasi reale
* esecuzione di missioni semplici senza intervento manuale continuo
* event log completo di una sessione
* replay navigabile della sessione
* demo ripetibile più volte

## 16. Rischi principali

### R1 — Troppa dipendenza dallo stack robotics

**Rischio:** il prodotto diventa solo un insieme di bridge tecnici.

**Mitigazione:** tenere forte il dominio interno e adapter separati.

### R2 — Scope eccessivo

**Rischio:** provare a fare subito fleet intelligence complessa.

**Mitigazione:** MVP molto stretto.

### R3 — UI prematura

**Rischio:** perdere settimane in frontend.

**Mitigazione:** prima backend e telemetria, poi UI minima.

### R4 — Mission model troppo ambizioso

**Rischio:** inventare workflow complessi troppo presto.

**Mitigazione:** missione semplice a waypoint.

### R5 — Mancanza di identità prodotto

**Rischio:** sembrare solo un tool personale.

**Mitigazione:** spingere su sessioni, replay, observability, dispatch.

## 17. Strategia portfolio

Questo progetto deve poter essere raccontato così:

> Ho sviluppato una control tower sim-first per flotte PX4, capace di orchestrare più droni in simulazione, assegnare missioni, centralizzare la telemetria e fornire replay delle sessioni per debug e validazione.

## 18. Strategia business futura

Solo dopo il MVP potrai decidere una delle tre direzioni:

* tool per team R&D e lab
* simulation orchestration platform
* base per fleet ops software più serio

Per ora non serve decidere il business model.

## 19. Decisioni progettuali già congelate

* **sim-first**
* **PX4 come ecosistema iniziale**
* **multi-drone ma piccolo numero**
* **MVP focalizzato su dispatch + observability**
* **no swarm intelligence nel primo ciclo**
* **no hardware reale nel primo milestone**

## 20. Definizione della milestone 1

### Milestone 1

Entro il primo traguardo il sistema deve:

* vedere 3 droni simulati
* mostrare stato live
* inviare comandi base
* assegnare missioni semplici
* registrare eventi
* permettere replay della sessione

Questa è la prima vera meta.
