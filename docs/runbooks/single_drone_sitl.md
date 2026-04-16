# Single Drone SITL Runbook v0

## Scopo

Documentare il flusso manuale di avvio di una singola istanza PX4 SITL in modo ripetibile.

## Perimetro

Questo runbook copre solo:

- 1 drone
- avvio manuale
- verifica base del corretto startup

Non copre ancora:

- multi-drone
- script di orchestration
- integrazione adapter
- integrazione backend FCT

## Simulatore scelto

Per il v0 si adotta Gazebo come simulatore di riferimento per SITL single-drone.

## Prerequisiti

- repository PX4 disponibile localmente
- toolchain PX4 installata
- dipendenze del simulatore installate
- ambiente Linux configurato correttamente

## Procedura

1. entrare nella repository PX4
2. eseguire il comando di avvio SITL scelto
3. attendere startup completo di PX4 e simulatore
4. verificare che il drone sia attivo

## Verifiche minime

La prova è considerata riuscita se:

- PX4 parte senza errori bloccanti
- il simulatore si avvia correttamente
- è disponibile la shell PX4 o equivalente evidenza di startup corretto
- il drone risulta pronto per interazione di base

## Note

Il comando preciso e gli eventuali target verranno congelati dopo la prima esecuzione riuscita sullo specifico ambiente di sviluppo.