## Mission

Rappresenta una missione semplice assegnabile a un drone nel contesto del MVP.

### Campi v0

- `id`: identificativo univoco della missione
- `type`: tipo di missione
- `waypoints`: insieme ordinato dei waypoint della missione, se previsti
- `assigned_drone_id`: identificativo del drone a cui la missione è assegnata
- `status`: stato corrente della missione
- `created_at`: timestamp di creazione della missione
- `started_at`: timestamp di effettivo inizio missione
- `ended_at`: timestamp di completamento, fallimento o interruzione

### Note

Il modello `Mission` v0 è volutamente semplice e focalizzato sul caso d’uso MVP.

Per il primo ciclo implementativo, una missione può rappresentare una sequenza operativa semplice, ad esempio:

- decollo
- raggiungi waypoint
- attesa breve
- rientro
- atterraggio

Dettagli ulteriori, come vincoli avanzati, priorità, pianificazione complessa o allocazione multi-drone, sono fuori scope per il v0.