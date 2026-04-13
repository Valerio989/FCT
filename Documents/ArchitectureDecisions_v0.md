# Architecture Decisions v0

## Progetto

**Fleet Control Tower for PX4 Simulation**

## Scopo

Congelare le principali decisioni architetturali del MVP in modo coerente con:

- impostazione **sim-first**
- focus su **monitoraggio live, mission dispatch, event logging e replay**
- sviluppo **incrementale**, sostenibile per un side project
- separazione chiara tra **adapter robotics**, **core applicativo**, **persistence** e **frontend**

Questo documento rappresenta la baseline tecnica per il Task **1.1 — Definizione dello stack tecnico**.

---

## 1. Decisioni congelate

### 1.1 Backend architecture

Il backend viene strutturato come insieme di sottosistemi separati per responsabilità.

La logica architetturale di riferimento è:

- **adapter layer** per integrazione con PX4
- **middleware interno** per comunicazione tra sottosistemi backend
- **application/API layer** per esposizione verso frontend e persistenza
- **persistence layer** per eventi, missioni e sessioni

Non viene adottato un backend monolitico full-C++.

Si sceglie invece una struttura ibrida con:

- componenti **C++** dove servono integrazione e prestazioni
- componenti **Python** dove servono rapidità di sviluppo ed esposizione API

### 1.2 Frontend

Il frontend del MVP sarà una web dashboard basata su:

- **React**
- **TypeScript**
- **Vite**

### 1.3 Database

Il database iniziale del progetto sarà:

- **PostgreSQL**

### 1.4 Real-time channel verso frontend

Il canale real-time tra backend e dashboard sarà:

- **WebSocket**

### 1.5 Middleware interno backend

La comunicazione tra sottosistemi interni del backend sarà basata su:

- **ROS2**

### 1.6 Tecnologia adapter PX4

L’adapter PX4 sarà implementato con:

- **C++**
- **MAVSDK C++**

---

## 2. Motivazioni delle scelte

### 2.1 Perché C++ per l’adapter PX4

L’integrazione con i droni simulati è il tratto più sensibile lato:

- discovery
- connessione
- telemetria live
- invio comandi
- traduzione degli stati PX4

Per questo motivo si sceglie di collocare l’adapter nel layer più vicino al sistema vehicle in:

- **C++** per controllo più stretto, prestazioni e robustezza
- **MAVSDK C++** come libreria di integrazione principale

Questa scelta evita di introdurre overhead non necessario nel tratto più operativo del sistema.

### 2.2 Perché ROS2 nel backend

ROS2 viene adottato come middleware interno per la comunicazione tra sottosistemi del backend.

L’obiettivo non è usare ROS2 come tecnologia universale del prodotto, ma come bus interno per:

- eventi live provenienti dall’adapter
- scambio di stato tra servizi backend
- richieste e risposte operative tra sottosistemi
- integrazione naturale tra componenti C++ e Python

Questa scelta permette di mantenere separati:

- il layer robotics e vehicle-facing
- il layer applicativo e product-facing

### 2.3 Perché Python nel layer applicativo

Il layer applicativo non è il punto più performance-critical del MVP.

Qui servono soprattutto:

- velocità di sviluppo
- esposizione API
- gestione WebSocket verso UI
- orchestrazione applicativa
- integrazione con persistence e query lato replay

Per questo motivo si accetta l’uso di **Python** nel livello applicativo.

La tecnologia prevista per l’esposizione HTTP/WebSocket è:

- **FastAPI**

FastAPI è considerato parte del layer applicativo, non il centro dell’architettura.

### 2.4 Perché React + TypeScript + Vite

Il frontend MVP è una dashboard operativa, non un prodotto orientato a SSR, SEO o rendering complesso lato server.

Per questo si sceglie uno stack semplice e diffuso:

- React per la UI
- TypeScript per contratti più robusti
- Vite per avvio rapido e bassa complessità

La scelta privilegia semplicità, velocità di iterazione e facilità di sviluppo assistito.

### 2.5 Perché PostgreSQL

Il dominio del progetto è chiaramente strutturato attorno a entità correlate come:

- droni
- missioni
- eventi
- sessioni

Serve inoltre supportare:

- query cronologiche
- timeline di replay
- correlazioni tra eventi, missioni e droni

Per questo si sceglie un database relazionale robusto.

### 2.6 Perché WebSocket per la dashboard live

La dashboard deve ricevere aggiornamenti live su:

- stato flotta
- telemetria sintetica
- eventi recenti
- cambi di stato operativi

Per questo il canale UI live viene separato dal middleware interno e realizzato con:

- **WebSocket backend-to-frontend**

Questo evita di esporre ROS2 direttamente al browser e mantiene chiaro il confine tra backend e frontend.

---

## 3. Architettura logica v0

### 3.1 Strati principali

#### A. Simulation Layer

Contiene:

- PX4 SITL
- scenario simulato
- istanze multiple di droni

#### B. Vehicle Adapter Layer

Contiene:

- adapter PX4 in C++
- integrazione MAVSDK C++
- discovery droni
- telemetria base
- comandi base
- traduzione degli stati PX4

#### C. Internal Middleware Layer

Contiene:

- ROS2 come bus di comunicazione tra sottosistemi backend

Qui transitano i messaggi live utili all’operatività interna del sistema.

#### D. Application Layer

Contiene:

- servizi di backend applicativo
- fleet registry
- telemetry service
- mission orchestration
- event aggregation
- session handling
- esposizione API REST
- esposizione WebSocket per UI

Questo layer è previsto principalmente in Python.

#### E. Persistence Layer

Contiene:

- PostgreSQL
- schema iniziale per missioni, eventi, sessioni
- query di replay

#### F. Frontend Layer

Contiene:

- dashboard React
- viste fleet overview e drone detail
- mission panel
- timeline eventi
- replay view

---

## 4. Regole architetturali operative

### 4.1 Regola 1 — ROS2 non è il layer universale

ROS2 è il middleware interno del backend.

Non deve diventare il punto di passaggio obbligato per:

- query al database
- logica di replay lato query
- esposizione frontend
- tutto ciò che è puramente CRUD o persistence-facing

### 4.2 Regola 2 — WebSocket solo per UI live

Il canale WebSocket è dedicato alla dashboard e al flusso live verso il frontend.

Non sostituisce:

- ROS2 per comunicazione interna
- REST API per operazioni applicative

### 4.3 Regola 3 — Adapter isolato dal dominio applicativo

L’adapter PX4 deve rimanere isolato dai dettagli del dominio applicativo.

Il suo compito è:

- parlare con PX4
- raccogliere telemetria
- inviare comandi
- emettere eventi e stato verso il backend

Non deve incorporare logica di mission orchestration, replay o persistence.

### 4.4 Regola 4 — Dominio applicativo separato dalla tecnologia vehicle

Il core applicativo non deve dipendere direttamente da dettagli MAVSDK o PX4.

Le traduzioni vehicle-specific devono essere contenute nel layer adapter.

---

## 5. Decisioni esplicitamente escluse per ora

Per il MVP non vengono adottate come scelte centrali:

- backend full-C++ con Drogon
- esposizione frontend basata direttamente su ROS2
- ROS2 come sostituto del database o delle API
- MongoDB
- stack frontend full-stack o SSR-oriented
- multi-autopilot support

Queste opzioni non sono escluse in assoluto per il futuro, ma non fanno parte della baseline tecnica corrente.

---

## 6. Stack tecnico v0

### Backend / Application Layer

- Python
- FastAPI
- WebSocket

### Adapter Layer

- C++
- MAVSDK C++

### Internal Middleware

- ROS2

### Database

- PostgreSQL

### Frontend

- React
- TypeScript
- Vite

---

## 7. Impatto sul workflow del progetto

Queste decisioni abilitano i task successivi del backlog in questo ordine logico:

### Foundation

- 1.1 Definizione dello stack tecnico
- 1.2 Strutturazione del repository
- 1.3 Setup del workflow locale
- 1.4 Congelamento del dominio MVP

### Vehicle Integration

- 3.1 Definizione dell’interfaccia `VehicleAdapter`
- 3.2 Discovery dei droni
- 3.3 Ingestione telemetria base
- 3.4 Traduzione stati PX4
- 3.5 Comandi base

### Core Backend

- 4.1 Fleet registry
- 4.2 Telemetry service
- 4.4 Mission model
- 4.5 Mission dispatcher
- 4.6 Mission tracking

### API e Frontend

- 6.1 API elenco flotta
- 6.2 API dettaglio drone
- 6.3 API invio comandi
- 6.4 API creazione missione
- 6.6 Real-time updates
- 7.1 App shell
- 7.2 Fleet overview
- 7.3 Drone detail view
- 7.4 Mission panel

---

## 8. Decisione finale congelata

La baseline architetturale v0 del progetto è:

- **PX4 adapter in C++ con MAVSDK C++**
- **ROS2 come middleware interno del backend**
- **Python/FastAPI per application layer e API exposure**
- **PostgreSQL come persistence layer**
- **React + TypeScript + Vite per la dashboard**
- **WebSocket per aggiornamenti live verso il frontend**

Questa è la configurazione di riferimento per il primo ciclo di implementazione del MVP.

