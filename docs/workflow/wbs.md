# Work Breakdown Structure v0

## Progetto

**Fleet Control Tower for PX4 Simulation**

## Obiettivo

Realizzare una control tower sim-first per la gestione centralizzata di una flotta di droni PX4 in simulazione, con monitoraggio live, dispatch di missioni semplici, event logging e replay di sessione.

---

## 1. Project Foundation

### 1.1 Project Setup

* Definizione della struttura del repository
* Scelta dello stack tecnico
* Definizione delle convenzioni di naming
* Setup dell’ambiente locale di sviluppo
* Definizione della strategia di branching
* Predisposizione dei template per issue e task

### 1.2 Product and Domain Framing

* Congelamento degli obiettivi MVP
* Definizione dei casi d’uso MVP
* Definizione delle entità di dominio
* Definizione delle metriche di successo
* Definizione dell’out-of-scope

### 1.3 Development Workflow

* Configurazione lint e format
* Definizione della strategia minima di test
* Creazione degli script di bootstrap del progetto
* Creazione degli script di esecuzione locale

---

## 2. Simulation Environment

### 2.1 PX4 SITL Multi-Drone Setup

* Setup di PX4 SITL
* Setup dello scenario simulato
* Avvio di 2 droni
* Avvio di 3 droni
* Definizione di naming e ID coerenti
* Verifica della stabilità dello startup

### 2.2 Simulation Orchestration

* Creazione di uno script unico di launch
* Configurazione del numero di droni
* Reset della sessione
* Stop e cleanup robusti
* Documentazione del runbook operativo

### 2.3 Scenario Definition

* Definizione dello scenario base con area semplice
* Definizione dei waypoint di test
* Definizione della missione demo standard
* Definizione del fault scenario base

---

## 3. Vehicle Integration Layer

### 3.1 Adapter Architecture

* Definizione dell’interfaccia `VehicleAdapter`
* Definizione del modello eventi dell’adapter
* Definizione del modello telemetria dell’adapter
* Gestione del lifecycle dell’adapter

### 3.2 PX4 Adapter

* Discovery dei droni
* Connessione ai droni
* Identificazione univoca dei droni
* Polling o subscription della telemetria
* Traduzione degli stati PX4 nel dominio interno

### 3.3 Command Channel

* Comando arm
* Comando takeoff
* Comando land
* Comando RTL
* Gestione di acknowledgement ed errori
* Gestione di timeout e retry base

---

## 4. Core Domain Backend

### 4.1 Fleet Registry

* Registrazione dei droni attivi
* Aggiornamento dello stato di connessione
* Esposizione della vista stato flotta
* Heartbeat e staleness detection

### 4.2 Telemetry Service

* Ingestione della telemetria live
* Normalizzazione dei payload
* Aggiornamento dello snapshot di stato corrente
* Gestione dello storico sintetico opzionale

### 4.3 Mission Domain

* Definizione del modello `Mission`
* Definizione del modello `MissionAssignment`
* Definizione degli stati missione
* Validazione della missione semplice
* Associazione drone-missione

### 4.4 Mission Dispatcher

* Assegnazione manuale della missione
* Invio della missione al drone
* Tracking dell’esecuzione
* Gestione del completamento e del failure
* Gestione dell’abort mission base

### 4.5 Session Manager

* Inizio sessione
* Fine sessione
* Associazione degli eventi alla sessione
* Gestione dei metadati di scenario

---

## 5. Eventing and Persistence

### 5.1 Event Model

* Definizione dei tipi evento
* Definizione dello schema payload evento
* Timestamping coerente
* Correlazione con drone, missione e sessione

### 5.2 Event Logger

* Persistenza degli eventi
* Persistenza dei comandi
* Persistenza dei cambi di stato
* Persistenza del lifecycle missione

### 5.3 Database Layer

* Definizione dello schema DB iniziale
* Definizione della migration strategy
* Implementazione del repository o access layer
* Query base per replay

### 5.4 Replay Service

* Ricostruzione della timeline di sessione
* Playback ordinato degli eventi
* Query cronologica
* Filtri per drone e missione

---

## 6. API Layer

### 6.1 Backend API

* Endpoint elenco flotta
* Endpoint dettaglio drone
* Endpoint invio comandi
* Endpoint creazione missione
* Endpoint elenco sessioni
* Endpoint dettaglio replay

### 6.2 Real-Time Updates

* Canale live per stato flotta
* Push eventi live
* Gestione reconnect frontend

### 6.3 API Contracts

* Definizione dei payload request e response
* Versioning minimo
* Definizione dell’error model base

---

## 7. Frontend Dashboard

### 7.1 App Shell

* Layout base
* Navigazione minima
* Stato connessione backend
* Gestione loading ed errori

### 7.2 Fleet Overview

* Lista droni
* Stato sintetico
* Batteria
* Modalità di volo
* Missione corrente

### 7.3 Drone Detail View

* Dettaglio telemetria
* Posizione
* Stato missione
* Pulsanti dei comandi base
* Storico eventi recente

### 7.4 Mission Panel

* Form missione semplice
* Selezione drone
* Invio missione
* Stato missione

### 7.5 Event Timeline

* Feed eventi live
* Filtri minimi
* Evidenziazione errori e allarmi

### 7.6 Replay View

* Elenco sessioni
* Selezione sessione
* Timeline replay
* Playback step-by-step

---

## 8. Observability and Robustness

### 8.1 Technical Logging

* Log backend strutturati
* Log adapter
* Log errori comando
* Log startup e shutdown

### 8.2 Fault Handling

* Gestione drone disconnesso
* Gestione telemetria stale
* Gestione comando fallito
* Gestione mission failure
* Gestione sessione corrotta o incompleta

### 8.3 Health Model

* Health sintetica del drone
* Warning base
* Allarmi semplici

---

## 9. Demo and Documentation

### 9.1 Demo Scenario

* Script demo standard
* Sequenza operativa demo
* Missioni demo predefinite
* Sessione replay salvata

### 9.2 Documentation

* README principale
* Guida setup locale
* Guida avvio simulazione
* Documento architettura
* Documento limiti MVP

### 9.3 Portfolio Assets

* Screenshot UI
* Diagramma architettura
* Video demo
* Descrizione progetto per CV, GitHub e LinkedIn

---

## Milestone MVP

### M1 — Multi-Drone Visibility

* Simulazione avviabile
* 3 droni visibili
* Telemetria live
* Dashboard fleet overview

### M2 — Commandable Fleet

* Comandi base da UI
* Stato coerente post-comando
* Gestione errori minima

### M3 — Mission Orchestration

* Missione semplice
* Tracking missione
* Completamento e failure

### M4 — Session Intelligence

* Event logging
* Session storage
* Replay

### M5 — Demo Ready

* Documentazione
* Demo ripetibile
* UI pulita per presentazione

---

## Deliverable MVP

* Ambiente multi-drone PX4 SITL riproducibile
* Adapter PX4 funzionante
* Backend con fleet state live
* Dashboard web minima
* Command interface base
* Mission dispatch semplice
* Event logging persistente
* Replay di sessione
* Documentazione di setup e demo
