# VERIFICA 

## Obiettivo
Sviluppare la parte server in modo che sia in grado di rispondere ai servizi successivamente esposti, quindi completare il client in modo che l'utente finale possa accedere alle risorse.

### Servizi da rendere disponibili
- login (POST) : verifica la correttezza delle credenziali 
- getImmobili (GET): ritorna gli immobili associati all'utente loggato (lato client non viene mandato nulla)
- modificaImmobile (POST): permette la modifica della categoria catastale, la rendita e la superficie
- inviaAvvisoPagamento (POST): verifica la rendita, la categoria catastale, l'IMU da pagare e ritorna quanto deve essere pagato per l'immobile selezionato (è necessario aggiornare il campo imu_da_pagare se è diverso da quello calcolato).

#### NOTE sulle Mappe catastali 
NOTA. Le mappe catastali visualizzate sono state scelte in base alla dimensione della superficie: 
-  gli immobili con superficie minore di 50 hanno la mappa piccola
-  gli immobili con superficie minore di 90 hanno la mappa media
-  gli immobili con superficie uguale o maggiore di 90 hanno la mappa grande

## Funzioni dei bottoni a fine pagina
1. La prima funzione apre una finestra con alcuni campi input che permettono di modificare i seguenti campi dell' immobile selezionato: categoria catastale, rendita e superficie.
2. Non è da gestire
3. Il terzo bottone richiede al server quanto è l'ammontare di IMU da far pagare e simula un'avviso di pagamento (interfaccia libera: devono vedersi i dati principali dell'immobile e la cifra da pagare)

## Gestione di fine sessione
Dopo l'accesso l'utente può lavorare per un tempo di circa 15 minuti poi deve effettuare nuovamente l'accesso ricaricando la pagina mediante il comando window.location.reload(). Il controllo deve essere effettuato lato server e appena il client effettua una richiesta oltre il tempo deve ricevere un messaggio di azione non consentita, a quel punto avviene il reload.

## Per chi ha accesso al tempo aggiuntivo
E' esonerato dalla gestione del reload della pagina e la modifica dell'immobile.

#### COME CALCOLARE l'IMU
L'IMU si calcola basandosi sulla rendita catastale, la categoria catastale e l'aliquota comunale. Di seguito lascio una funzione per il calcolo:

```
$moltiplicatoriIMU = [
    "A/1" => 160, "A/2" => 160, "A/3" => 160, "A/4" => 160,
    "A/5" => 160, "A/6" => 160, "A/7" => 160, "A/8" => 160, "A/9" => 160,
    "A/10" => 80,
    "B/1" => 140, "B/2" => 140, "B/3" => 140, "B/4" => 140, "B/5" => 140, "B/6" => 140, "B/7" => 140,
    "C/1" => 55,
    "C/2" => 160, "C/6" => 160, "C/7" => 160,
    "C/3" => 140, "C/4" => 140, "C/5" => 140,
    "D/1" => 65, "D/2" => 65, "D/3" => 65, "D/4" => 65,
    "D/5" => 80, // banche
    "D/6" => 65, "D/7" => 65, "D/8" => 65, "D/9" => 65, "D/10" => 65,
    "E/1" => 55, "E/2" => 55, "E/3" => 55, "E/4" => 55, "E/5" => 55, "E/6" => 55,
    "E/7" => 55, "E/8" => 55, "E/9" => 55
];

function calcolaIMU($rendita, $categoria) {
    $rendita_rivalutata = $rendita * 1.05;
    $moltiplicatore = $moltiplicatoriIMU[$categoria] ?? 160;
    $valore_catastale = $rendita_rivalutata * $moltiplicatoriIMU;
    $imu = $valore_catastale * (0.96 / 100);
    return round($imu, 2);
}
```
