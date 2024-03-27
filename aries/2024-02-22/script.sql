ALTER TABLE `stato_preventivo`
	ADD COLUMN `reset_promemoria_invio` BIT NULL DEFAULT b'0' AFTER `bloccato`;

UPDATE stato_preventivo SET reset_promemoria_invio = 1 where id_stato in (1, 2, 7, 8);


UPDATE preventivo JOIN stato_preventivo ON stato_preventivo.id_stato = preventivo.stato
SET primo_sollecito = NULL,
	secondo_sollecito = NULL
WHERE stato_preventivo.reset_promemoria_invio = 1;

ALTER TABLE `fattura_pagamenti_comunicazione`
	DROP COLUMN `data_spostato`,
	DROP COLUMN `calendario`,
	DROP COLUMN `data_fine`,
	DROP COLUMN `ora_inizio`,
	DROP COLUMN `ora_fine`;


ALTER TABLE `fornfattura_pagamenti_comunicazione`
	DROP COLUMN `data_spostato`,
	DROP COLUMN `calendario`,
	DROP COLUMN `data_fine`,
	DROP COLUMN `ora_inizio`,
	DROP COLUMN `ora_fine`;

UPDATE impianto
SET stato_invio_doc="clred", stato = 12 
WHERE stato_invio_doc="clyellow" AND DATEDIFF(CURRENT_DATE, data_invio_doc)> 30;

ALTER TABLE `articolo`
	CHANGE COLUMN `Codice_fornitore` `Codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Desc_brev`;

ALTER TABLE `articoli_ddt_ricevuti`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

ALTER TABLE `articolo_lotto`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Id_lotto`;

ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `quantità`;

ALTER TABLE `dichiarazione_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

ALTER TABLE `fattura_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Iva`;

ALTER TABLE `fornfattura_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Iva`;

ALTER TABLE `lista_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(30) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

DROP TABLE note_mobile;
DROP TABLE note_mobile_old;
DROP TRIGGER del_note_mobile;
