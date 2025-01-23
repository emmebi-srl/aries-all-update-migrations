
ALTER TABLE `articolo`
	CHANGE COLUMN `Codice_fornitore` `Codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Desc_brev`;

ALTER TABLE `articoli_ddt_ricevuti`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

ALTER TABLE `articolo_lotto`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Id_lotto`;

ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `quantità`;

ALTER TABLE `dichiarazione_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

ALTER TABLE `fattura_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Iva`;

ALTER TABLE `fornfattura_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Iva`;

ALTER TABLE `lista_articoli`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(45) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `anno`;

ALTER TABLE `articolo_codice`
	CHANGE COLUMN `codice` `codice` VARCHAR(45) NOT NULL COLLATE 'latin1_swedish_ci' AFTER `id_articolo`;



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE report_id BIGINT(20);
	DECLARE report_year INT(11);
	DECLARE curA CURSOR FOR SELECT DISTINCT Id_rapporto, anno FROM rapporto ORDER BY anno asc, data asc, id_rapporto ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN curA;
	loopA: LOOP
		SET done = 0;
		FETCH curA INTO report_id, report_year;
		IF done THEN
			LEAVE loopA;
		END IF;
		CALL sp_ariesReportTotalsRefresh(report_id, report_year);
	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;
