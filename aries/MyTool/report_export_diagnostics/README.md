# Diagnostica export rapporti

Selezionare il database Aries nel client SQL. Le istruzioni di connessione locale sono in `AGENTS.md`.

1. Eseguire `01_indici_e_piano.sql` per leggere versione server, indici e piano della SELECT originale lenta. Lo script conserva la query precedente alla correzione per confronto; non esegue l'export e non modifica dati o indici.
2. Eseguire `02_moltiplicazione_righe.sql` per misurare su 100 rapporti il prodotto delle righe delle join originali. Questa parte legge dati reali e beneficia degli indici sulle chiavi dei rapporti. Il campione usa ID decrescenti, non necessariamente le date piu recenti.

Il database deve avere le colonne richieste dall'export, inclusa `resoconto.data_invio` (migrazione 2026-09-15).

## Lettura dei risultati

- `INDICI`: verificare che `(id_rapporto, anno)` sia un prefisso di un indice delle tabelle figlie; anche PRIMARY e indici piu lunghi possono soddisfare la join. Per uguaglianze su entrambe le colonne e valido anche l'ordine inverso.
- `PIANO_QUERY_ORIGINALE`: `possible_keys` sono gli indici candidati, `key` quello scelto e `rows` una stima per accesso. `Using temporary` e `Using filesort` non provano da soli la mancanza di un indice. La query completa non ha filtro date.
- I fattori di duplicazione del campione mostrano quanto le join originali ripetono i tempi e i materiali prima del raggruppamento. `DISTINCT` non corregge le somme, e `SUM(DISTINCT totale)` eliminerebbe anche durate uguali appartenenti a righe diverse.

## Correzione e verifica locale

La migrazione `aries/2026-09-21/script.sql` elimina DISTINCT e aggrega separatamente lavoro, viaggio e materiali sui rapporti selezionati, con tabelle temporanee indicizzate. Mantiene i 28 campi di output e i collegamenti ai resoconti.

Verificata su localhost/emmebi, MySQL 5.5.62: 25.189 righe in circa 2,2 secondi di tempo server profilato. Il rapporto 14674/2013 restituisce 408 minuti di lavoro, 120 minuti di viaggio e 8 materiali; le join originali producevano 6.528 minuti di lavoro. Verificati anche filtri, risultato vuoto, chiamate ripetute e rapporti senza dettagli. I tempi dipendono da dati e carico del server.

Il limite di GROUP_CONCAT viene dimensionato sui materiali selezionati e ripristinato a fine chiamata, anche in caso di errore. Non sono stati aggiunti indici alle tabelle permanenti.

Usare EXPLAIN semplice: MySQL 5.5 non supporta EXPLAIN ANALYZE. Riferimento ufficiale: [EXPLAIN](https://dev.mysql.com/doc/refman/8.0/en/explain.html).
