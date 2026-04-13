# Local Development Runbook v0

## Scopo

Questo documento descrive il workflow locale minimo di sviluppo per il progetto FCT.

L’obiettivo del workflow v0 è permettere l’avvio e lo sviluppo del solo application stack iniziale:

- backend application layer
- frontend webapp

## Perimetro del workflow v0

Questo runbook copre:

- bootstrap ambiente backend
- bootstrap ambiente frontend
- avvio backend locale
- avvio frontend locale

Questo runbook **non** copre ancora:

- PX4 SITL
- adapter C++
- ROS2 runtime completo
- PostgreSQL obbligatorio
- orchestration full stack del sistema completo

## Architettura di riferimento

Il workflow locale v0 è coerente con la baseline architetturale del progetto:

- backend application layer in Python + FastAPI
- frontend in React + TypeScript + Vite
- ROS2 come middleware interno backend
- adapter PX4 separato in C++ / MAVSDK
- WebSocket come canale live verso la UI
- PostgreSQL come persistence layer previsto

Nel workflow locale v0 vengono avviati solo backend e frontend.  
Le parti robotics e persistence completa verranno integrate progressivamente nelle fasi successive. :contentReference[oaicite:2]{index=2}

## Prerequisiti

Ambiente richiesto per il workflow v0:

- `python3`
- `venv`
- `pip`
- `node`
- `npm`

## Struttura attesa

Il workflow assume la seguente struttura repository:

- `backend/`
- `frontend/webapp/`
- `scripts/bootstrap/`
- `scripts/run/`

## Bootstrap backend

Script previsto:

`./scripts/bootstrap/bootstrap_backend.sh`

Responsabilità dello script:

- verifica disponibilità di `python3`
- crea la virtual environment in `backend/.venv` se assente
- aggiorna `pip`
- installa dipendenze da `backend/requirements.txt` se presente

## Bootstrap frontend

Script previsto:

`./scripts/bootstrap/bootstrap_frontend.sh`

Responsabilità dello script:

- verifica disponibilità di `node` e `npm`
- installa le dipendenze del frontend in `frontend/webapp` se `package.json` è presente

## Avvio backend

Script previsto:

`./scripts/run/run_backend.sh`

Responsabilità dello script:

- verifica che il backend sia stato bootstrapato
- attiva la virtual environment
- avvia il server di sviluppo backend

## Avvio frontend

Script previsto:

`./scripts/run/run_frontend.sh`

Responsabilità dello script:

- verifica che il frontend sia stato bootstrapato
- avvia il frontend in modalità development

## Avvio sviluppo locale

Script previsto:

`./scripts/run/run_dev.sh`

Nel workflow v0 questo script ha ruolo di entrypoint operativo e guida lo sviluppatore nel flusso corretto di esecuzione.

Ordine consigliato:

1. bootstrap backend
2. bootstrap frontend
3. avvio backend
4. avvio frontend

## Limiti attuali

Nel workflow v0 non sono ancora inclusi:

- launch automatico della simulazione
- gestione dei processi multi-servizio
- cleanup strutturato
- avvio di adapter e middleware robotics
- integrazione completa con persistence layer

## Prossimi step previsti

Dopo il consolidamento del workflow locale v0, i prossimi step saranno:

- congelamento del dominio MVP
- setup della simulazione PX4 SITL
- orchestration multi-drone
- introduzione dell’adapter PX4