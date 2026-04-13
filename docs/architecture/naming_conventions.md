# Naming Conventions v0

## Scopo

Definire convenzioni minime di naming per mantenere coerenza nel repository durante le prime fasi di implementazione.

Queste convenzioni sono volutamente leggere e potranno essere estese nelle fasi successive.

## 1. Repository e directory

### 1.1 Directory

- nomi directory in **lowercase**
- usare parole semplici e descrittive
- usare `snake_case` solo quando serve separare più parole
- evitare abbreviazioni non ovvie

Esempi:
- `backend`
- `frontend`
- `webapp`
- `scripts`
- `runbooks`
- `px4_adapter`

## 2. File di documentazione

### 2.1 Documenti di progetto

Per i documenti versionati ad alto livello usare snake_case

### 2.2 README

Usare:
- `README.md` per documentazione introduttiva di cartella o modulo

## 3. Python

### 3.1 File Python

- file in `snake_case.py`

Esempi:
- `main.py`
- `fleet_registry.py`
- `telemetry_service.py`

### 3.2 Classi Python

- classi in `PascalCase`

Esempi:
- `Drone`
- `MissionDispatcher`
- `TelemetrySnapshot`

### 3.3 Funzioni e metodi Python

- funzioni e metodi in `snake_case`

Esempi:
- `get_fleet_state`
- `publish_telemetry_update`

### 3.4 Variabili Python

- variabili in `snake_case`

Esempi:
- `drone_id`
- `mission_status`

### 3.5 Costanti Python

- costanti in `UPPER_SNAKE_CASE`

Esempi:
- `DEFAULT_WS_PORT`
- `MAX_RETRY_COUNT`

## 4. C++

### 4.1 File C++

- file in `snake_case.cpp` / `snake_case.hpp`

Esempi:
- `px4_adapter_node.cpp`
- `vehicle_adapter.hpp`

### 4.2 Classi C++

- classi in `PascalCase`

Esempi:
- `VehicleAdapter`
- `Px4AdapterNode`

### 4.3 Metodi e funzioni C++

- metodi e funzioni in `snake_case`

Esempi:
- `connect_vehicle`
- `read_telemetry`

### 4.4 Variabili C++

- variabili in `snake_case`
- membri privati con suffisso finale `_`

Esempi:
- `drone_id`
- `connection_status_`

### 4.5 Costanti C++

- costanti in `kPascalCase` oppure `UPPER_SNAKE_CASE`

Per v0, preferenza:
- `kPascalCase` per costanti locali o statiche tipizzate
- `UPPER_SNAKE_CASE` solo per macro o valori globali legacy

## 5. TypeScript / React

### 5.1 File generici

- file non-component in `kebab-case.ts` o `kebab-case.tsx`

Esempi:
- `fleet-api.ts`
- `use-websocket.ts`

### 5.2 Componenti React

- componenti in `PascalCase.tsx`

Esempi:
- `FleetOverview.tsx`
- `DroneDetailCard.tsx`

### 5.3 Hook React

- hook con prefisso `use` e nome in `camelCase`

Esempi:
- `useFleetState.ts`
- `useDroneTelemetry.ts`

### 5.4 Variabili e funzioni TypeScript

- `camelCase`

Esempi:
- `droneId`
- `loadFleetState`

### 5.5 Tipi e interfacce TypeScript

- tipi in `PascalCase`
- interfacce con `PascalCase`, senza prefisso `I`

Esempi:
- `DroneState`
- `MissionStatus`

## 6. API e payload

### 6.1 JSON payload

- chiavi JSON in `snake_case`

Esempi:
- `drone_id`
- `battery_percent`
- `mission_status`

Motivazione:
- allineamento naturale con backend Python
- payload leggibili e consistenti

## 7. Database

### 7.1 Tabelle

- nomi tabella in `snake_case`
- preferenza per plurale semplice

Esempi:
- `drones`
- `missions`
- `events`
- `sessions`

### 7.2 Colonne

- nomi colonna in `snake_case`

Esempi:
- `drone_id`
- `created_at`
- `battery_percent`

## 8. ROS2

### 8.1 Nodi

- nomi nodo in `snake_case`

Esempi:
- `px4_adapter_node`

### 8.2 Topic e service

- nomi in lowercase con path chiaro e descrittivo
- evitare nomi troppo generici

Esempi:
- `/fleet/telemetry`
- `/fleet/events`
- `/fleet/command`

## 9. Regole pratiche

- preferire nomi espliciti a nomi brevi
- evitare abbreviazioni ambigue
- mantenere coerenza interna al modulo prima di introdurre nuove convenzioni
- non rinominare aggressivamente file o cartelle senza un motivo reale

## 10. Principio guida

Per il progetto FCT vale la regola:

**coerenza locale prima di perfezione globale**

Le convenzioni devono aiutare a implementare più velocemente, non rallentare il lavoro.

