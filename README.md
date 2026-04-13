# Fleet Control Tower for PX4 Simulation

Control tower **sim-first** per la gestione centralizzata di una flotta di droni PX4 in simulazione.

Obiettivo del progetto:
- monitoraggio live della flotta
- mission dispatch semplice
- event logging centralizzato
- replay delle sessioni

Il progetto è pensato come piattaforma software operativa e di sviluppo, non come GCS general purpose o prodotto enterprise per operazioni reali.

## Stato attuale

Repository in fase iniziale di foundation.

Attualmente sono presenti:
- documenti di definizione prodotto
- documenti di architettura
- backlog operativo
- WBS
- struttura iniziale del repository

L’implementazione del sistema è in costruzione incrementale a partire dalla baseline architetturale v0.

## Baseline architetturale v0

Stack tecnico attualmente congelato:
- **Adapter PX4**: C++ + MAVSDK C++
- **Middleware interno backend**: ROS2
- **Application/API layer**: Python + FastAPI
- **Database**: PostgreSQL
- **Frontend**: React + TypeScript + Vite
- **Canale live verso UI**: WebSocket

## Development

Per il workflow locale iniziale vedere:

- `docs/runbooks/local_development.md`

## Obiettivo MVP

L’MVP iniziale mira a:
- gestire **3 droni PX4 simulati**
- visualizzare stato live e telemetria sintetica
- inviare comandi base
- assegnare missioni semplici
- registrare eventi
- permettere replay della sessione

## Struttura del repository

```text
FCT
├── backend
├── docs
│   ├── architecture
│   ├── product
│   ├── runbooks
│   └── workflow
├── frontend
│   └── webapp
├── scripts
├── tests
└── README.md