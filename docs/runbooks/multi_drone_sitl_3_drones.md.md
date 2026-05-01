# Multi-Drone SITL 3 Drones Runbook v0

## Scopo

Documentare il flusso operativo per avviare lo scenario PX4 SITL multi-drone MVP con 3 istanze simultanee.

L’obiettivo è rendere ripetibile l’avvio della simulazione multi-drone tramite uno script unico di launch.

## Perimetro

Questo runbook copre:

* 3 droni PX4 SITL
* avvio tramite script unico
* layout terminale con kitty
* logging delle istanze PX4
* stop e cleanup base della sessione

Questo runbook non copre ancora:

* parametrizzazione dinamica del numero di droni
* integrazione con adapter PX4
* integrazione backend FCT
* integrazione ROS2 runtime completa
* mission dispatch
* replay applicativo

## Simulatore scelto

Per il v0 si adotta:

* PX4 SITL
* Gazebo gz
* runtime `gz-harmonic`

Gazebo Classic non è il ramo operativo di riferimento per questo ambiente.

## Prerequisiti

Ambiente richiesto:

* Ubuntu 24.04
* PX4-Autopilot disponibile localmente
* PX4 SITL già buildato
* Gazebo gz / `gz-harmonic`
* kitty installato
* kitty remote control abilitato

Configurazione kitty richiesta:

```text
allow_remote_control yes
```

Struttura locale attesa:

```text
FCT_PROJECT/
├── FCT/
└── PX4-Autopilot/
```

Binario PX4 atteso:

```text
../PX4-Autopilot/build/px4_sitl_default/bin/px4
```

## Script di launch

Script previsto:

```bash
./scripts/run/launch_px4_sitl_3_drones.sh
```

Responsabilità dello script:

* eseguire cleanup iniziale dei processi residui
* avviare 3 istanze PX4 SITL
* aprire 3 pannelli splittati nella stessa tab kitty
* assegnare pose diverse ai droni
* salvare log separati per istanza
* fornire comando di stop tramite `--stop`

## Avvio simulazione

Dalla root della repository `FCT`, dentro kitty:

```bash
./scripts/run/launch_px4_sitl_3_drones.sh
```

Comportamento atteso:

* il terminale corrente diventa il drone 1
* drone 2 e drone 3 vengono aperti come split nella stessa tab kitty
* Gazebo mostra 3 modelli `gz_x500` separati
* ogni istanza PX4 dispone della propria shell

## Istanze attese

Configurazione MVP attesa:

| Drone   | instance_id | MAV_SYS_ID atteso | Pose    |
| ------- | ----------: | ----------------: | ------- |
| drone_1 |           0 |                 1 | default |
| drone_2 |           1 |                 2 | `0,1`   |
| drone_3 |           2 |                 3 | `0,2`   |

Per le istanze successive alla prima viene usato:

```bash
PX4_GZ_STANDALONE=1
```

## Log

I log vengono salvati sotto:

```text
logs/px4_sitl_3_drones/<timestamp>/
```

File attesi:

```text
drone_1.log
drone_2.log
drone_3.log
```

## Stop simulazione

Per fermare la simulazione e fare cleanup base:

```bash
./scripts/run/launch_px4_sitl_3_drones.sh --stop
```

Il comando può essere usato anche prima di un nuovo launch per ripulire eventuali processi residui.

## Help

```bash
./scripts/run/launch_px4_sitl_3_drones.sh --help
./scripts/run/launch_px4_sitl_3_drones.sh -h
```

## Verifiche minime

La prova è considerata riuscita se:

* lo script parte con un solo comando
* vengono avviate 3 istanze PX4
* Gazebo mostra 3 droni separati
* i droni sono distinguibili tramite `instance_id`, `MAV_SYS_ID`, pose e porte locali
* i log vengono creati per tutte e 3 le istanze
* `--stop` ferma la sessione senza lasciare processi bloccanti
* un secondo launch dopo `--stop` parte correttamente

## Troubleshooting

### Kitty remote control non disponibile

Errore tipico:

```text
Errore: kitty remote control non disponibile.
```

Verificare che in `kitty.conf` sia presente:

```text
allow_remote_control yes
```

Poi riavviare kitty.

### Script lanciato fuori da kitty

Lo script deve essere lanciato da dentro kitty perché usa i comandi `kitten @` per creare gli split.

### Binario PX4 non trovato

Verificare che il binario esista e sia eseguibile:

```text
../PX4-Autopilot/build/px4_sitl_default/bin/px4
```

rispetto alla root della repository `FCT`.

### Simulazione sporca

Eseguire:

```bash
./scripts/run/launch_px4_sitl_3_drones.sh --stop
```

poi rilanciare lo script.

## Limiti attuali

Lo script è intenzionalmente focalizzato sullo scenario MVP a 3 droni.

Non è ancora previsto:

* numero di droni configurabile da CLI
* gestione PID file per cleanup selettivo
* orchestrazione full-stack con backend, adapter e frontend
* discovery applicativo dei droni lato FCT

## Prossimi step previsti

Dopo il consolidamento dello scenario multi-drone SITL, i prossimi step saranno:

* definizione dell’interfaccia `VehicleAdapter`
* discovery dei droni attivi
* ingestione della telemetria base
* integrazione progressiva con backend FCT
