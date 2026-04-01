# Backlog Operativo v0

## Progetto

**Fleet Control Tower for PX4 Simulation**

## Obiettivo

Realizzare una control tower sim-first per la gestione centralizzata di una flotta di droni PX4 in simulazione, con monitoraggio live, dispatch di missioni semplici, event logging e replay di sessione.

---

## Epic 1 — Foundation & Setup

### Task 1.1 — Definizione dello stack tecnico

**Output**

* Scelta del backend
* Scelta del frontend
* Scelta del database
* Scelta del bus o event channel
* Scelta della libreria adapter per PX4

**Definition of Done**

* Decisioni annotate in un file `architecture-decisions.md`

**Priorità**

* P0

### Task 1.2 — Strutturazione del repository

**Output**

* Cartelle backend, frontend, docs, scripts
* Convenzioni di naming
* Base README

**Definition of Done**

* Repository inizializzato con struttura stabile

**Priorità**

* P0

### Task 1.3 — Setup del workflow locale

**Output**

* Script bootstrap
* Script run backend
* Script run frontend
* Script run full stack

**Definition of Done**

* Un nuovo ambiente locale parte con una sequenza chiara e documentata

**Priorità**

* P0

### Task 1.4 — Congelamento del dominio MVP

**Output**

* Modelli `Drone`, `Mission`, `Event`, `Session`
* Stati missione
* Campi minimi di telemetria

**Definition of Done**

* Data model v0 documentato

**Priorità**

* P0

---

## Epic 2 — Multi-Drone Simulation

### Task 2.1 — Avvio di un drone PX4 in SITL

**Output**

* Singola istanza funzionante

**Definition of Done**

* Un drone parte in simulazione in modo ripetibile

**Priorità**

* P0

### Task 2.2 — Avvio di 2 droni simultanei

**Output**

* Due istanze con ID coerenti

**Definition of Done**

* Due droni sono avviabili e distinguibili

**Priorità**

* P0

### Task 2.3 — Avvio di 3 droni simultanei

**Output**

* Tre istanze stabili

**Definition of Done**

* Tre droni partono senza conflitti di namespace o porte

**Priorità**

* P0

### Task 2.4 — Creazione di uno script unico di launch

**Output**

* Comando unico per lo startup della simulazione

**Definition of Done**

* Con un solo comando parte lo scenario multi-drone

**Priorità**

* P0

### Task 2.5 — Implementazione di stop e cleanup robusti

**Output**

* Cleanup dei processi e reset ambiente

**Definition of Done**

* Lo shutdown non lascia processi o risorse sporche

**Priorità**

* P1

---

## Epic 3 — PX4 Adapter

### Task 3.1 — Definizione dell’interfaccia `VehicleAdapter`

**Output**

* Metodi per connect, discover, read telemetry, send command

**Definition of Done**

* Interfaccia astratta definita e approvata

**Priorità**

* P0

### Task 3.2 — Implementazione del discovery dei droni

**Output**

* Rilevamento automatico delle istanze attive

**Definition of Done**

* Il backend vede 3 droni con ID univoci

**Priorità**

* P0

### Task 3.3 — Implementazione dell’ingestione della telemetria base

**Output**

* Posizione
* Batteria
* Armed
* Mode

**Definition of Done**

* Il backend riceve e aggiorna i campi minimi per ogni drone

**Priorità**

* P0

### Task 3.4 — Traduzione degli stati PX4 nel dominio interno

**Output**

* Mapping mode o state PX4 verso stato applicativo

**Definition of Done**

* Il frontend e il backend usano un vocabolario di stato coerente

**Priorità**

* P0

### Task 3.5 — Implementazione dei comandi base

**Output**

* Arm
* Takeoff
* Land
* RTL

**Definition of Done**

* I comandi sono inviabili e il backend riceve esito o errore

**Priorità**

* P0

### Task 3.6 — Gestione di timeout ed errori base

**Output**

* Timeout comando
* Failure handling minimo

**Definition of Done**

* Errore e timeout non compromettono il sistema

**Priorità**

* P1

---

## Epic 4 — Core Backend

### Task 4.1 — Implementazione del fleet registry

**Output**

* Registrazione dei droni attivi
* Stato connessione

**Definition of Done**

* Il sistema mantiene una lista consistente dei droni noti

**Priorità**

* P0

### Task 4.2 — Implementazione del telemetry service

**Output**

* Snapshot live dello stato del drone

**Definition of Done**

* Il backend espone uno stato corrente aggiornato

**Priorità**

* P0

### Task 4.3 — Implementazione della health sintetica

**Output**

* Stato health derivato da connessione e telemetria minima

**Definition of Done**

* Ogni drone ha uno stato health semplice

**Priorità**

* P1

### Task 4.4 — Definizione del modello `Mission`

**Output**

* Schema della missione semplice a waypoint

**Definition of Done**

* È possibile creare una missione valida lato backend

**Priorità**

* P0

### Task 4.5 — Implementazione del mission dispatcher manuale

**Output**

* Assegnazione di una missione a un drone selezionato

**Definition of Done**

* Una missione viene inviata e tracciata

**Priorità**

* P0

### Task 4.6 — Implementazione del tracking dello stato missione

**Output**

* Pending
* Running
* Completed
* Failed
* Aborted

**Definition of Done**

* Ogni missione cambia stato in modo coerente

**Priorità**

* P0

### Task 4.7 — Implementazione del session manager

**Output**

* Start session
* Stop session
* Associazione eventi-sessione

**Definition of Done**

* Ogni run applicativo può essere registrato come sessione

**Priorità**

* P1

---

## Epic 5 — Persistence & Replay

### Task 5.1 — Definizione dell’event model

**Output**

* Tipi evento
* Payload minimo
* Timestamp
* Correlazioni

**Definition of Done**

* Schema evento v0 congelato

**Priorità**

* P0

### Task 5.2 — Implementazione dell’event logger

**Output**

* Persistenza di comandi, cambi stato ed eventi missione

**Definition of Done**

* Gli eventi principali sono salvati nello storage

**Priorità**

* P0

### Task 5.3 — Definizione dello schema DB iniziale

**Output**

* Tabelle sessioni, eventi, missioni

**Definition of Done**

* Migration iniziale pronta

**Priorità**

* P0

### Task 5.4 — Implementazione delle query per la timeline di sessione

**Output**

* Recupero degli eventi ordinati

**Definition of Done**

* Una sessione può essere letta cronologicamente

**Priorità**

* P0

### Task 5.5 — Implementazione del replay service base

**Output**

* Playback logico della timeline

**Definition of Done**

* Il sistema restituisce una sequenza replay navigabile

**Priorità**

* P1

---

## Epic 6 — API Layer

### Task 6.1 — API elenco flotta

**Output**

* Endpoint lista droni

**Definition of Done**

* Il frontend può leggere la flotta

**Priorità**

* P0

### Task 6.2 — API dettaglio drone

**Output**

* Endpoint dettaglio stato drone

**Definition of Done**

* Il frontend può leggere il dettaglio di un drone

**Priorità**

* P0

### Task 6.3 — API invio comandi

**Output**

* Endpoint per arm, takeoff, land, RTL

**Definition of Done**

* I comandi sono inviabili via API

**Priorità**

* P0

### Task 6.4 — API creazione missione

**Output**

* Endpoint mission dispatch

**Definition of Done**

* Una missione può essere inviata via UI o API

**Priorità**

* P0

### Task 6.5 — API sessioni e replay

**Output**

* Elenco sessioni
* Dettaglio timeline

**Definition of Done**

* Il frontend può recuperare le sessioni registrate

**Priorità**

* P1

### Task 6.6 — Real-time updates

**Output**

* Canale live per stato ed eventi

**Definition of Done**

* Il frontend riceve aggiornamenti senza refresh manuale

**Priorità**

* P1

---

## Epic 7 — Frontend MVP

### Task 7.1 — Creazione della app shell

**Output**

* Layout base
* Routing minimo
* Gestione loading ed errori

**Definition of Done**

* Frontend avviabile con struttura stabile

**Priorità**

* P0

### Task 7.2 — Implementazione della fleet overview

**Output**

* Lista droni
* Battery
* Mode
* Health
* Missione corrente

**Definition of Done**

* L’utente vede la flotta live

**Priorità**

* P0

### Task 7.3 — Implementazione della drone detail view

**Output**

* Dettaglio telemetria
* Stato drone
* Pulsanti comando

**Definition of Done**

* L’utente può ispezionare e comandare un drone

**Priorità**

* P0

### Task 7.4 — Implementazione del mission panel

**Output**

* Form missione semplice
* Selezione drone
* Invio missione

**Definition of Done**

* Una missione semplice è inviabile da UI

**Priorità**

* P0

### Task 7.5 — Implementazione della event timeline live

**Output**

* Stream degli eventi recenti

**Definition of Done**

* Gli eventi sono visibili dalla dashboard

**Priorità**

* P1

### Task 7.6 — Implementazione della replay view

**Output**

* Selezione sessione
* Playback timeline

**Definition of Done**

* Una sessione registrata è rieseguibile lato UI

**Priorità**

* P1

---

## Epic 8 — Robustness & Observability

### Task 8.1 — Logging strutturato backend

**Output**

* Log coerenti per startup, errori, comandi, adapter

**Definition of Done**

* I principali flussi sono tracciati in log leggibili

**Priorità**

* P1

### Task 8.2 — Gestione drone disconnesso

**Output**

* Stato connessione degradato
* Warning UI e backend

**Definition of Done**

* La perdita di un drone non compromette l’applicazione

**Priorità**

* P1

### Task 8.3 — Gestione telemetria stale

**Output**

* Rilevazione dei dati obsoleti

**Definition of Done**

* Il sistema segnala telemetria non aggiornata

**Priorità**

* P1

### Task 8.4 — Gestione comando fallito

**Output**

* Esito errore propagato fino alla UI

**Definition of Done**

* Il fallimento è visibile all’utente

**Priorità**

* P1

---

## Epic 9 — Demo & Documentation

### Task 9.1 — Scrittura del README principale

**Output**

* Overview del progetto
* Setup
* Run
* Limiti MVP

**Definition of Done**

* Un altro sviluppatore può capire e avviare il progetto

**Priorità**

* P1

### Task 9.2 — Preparazione del demo scenario standard

**Output**

* Sequenza demo ripetibile
* Missioni demo

**Definition of Done**

* Esiste una demo guidata sempre ripetibile

**Priorità**

* P1

### Task 9.3 — Preparazione degli asset portfolio

**Output**

* Screenshot
* Diagramma architettura
* Pitch breve del progetto

**Definition of Done**

* Il progetto è presentabile esternamente

**Priorità**

* P2

---

## Ordine di Esecuzione Consigliato

### Wave 1

* 1.1
* 1.2
* 1.3
* 1.4
* 2.1
* 2.2
* 2.3
* 2.4

### Wave 2

* 3.1
* 3.2
* 3.3
* 3.4
* 4.1
* 4.2
* 6.1
* 6.2
* 7.1
* 7.2

### Wave 3

* 3.5
* 6.3
* 7.3
* 8.1
* 8.2

### Wave 4

* 4.4
* 4.5
* 4.6
* 6.4
* 7.4

### Wave 5

* 5.1
* 5.2
* 5.3
* 4.7
* 5.4
* 5.5
* 6.5
* 7.5
* 7.6

### Wave 6

* 8.3
* 8.4
* 9.1
* 9.2
* 9.3

---

## Backlog MVP Minimo Assoluto

* 2.3
* 2.4
* 3.1
* 3.2
* 3.3
* 3.5
* 4.1
* 4.2
* 4.4
* 4.5
* 4.6
* 5.1
* 5.2
* 5.3
* 5.4
* 6.1
* 6.2
* 6.3
* 6.4
* 7.1
* 7.2
* 7.3
* 7.4
