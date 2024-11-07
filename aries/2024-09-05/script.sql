
ALTER TABLE `tipo_resoconto`
	ADD COLUMN `ghost` BIT NULL DEFAULT 0 AFTER `descrizione`;

ALTER TABLE `tipo_resoconto`
	ADD COLUMN `economia` BIT NULL DEFAULT 0 AFTER `descrizione`;

UPDATE tipo_resoconto SET ghost = 1 WHERE id_tipo = 3;
UPDATE tipo_resoconto SET economia = 1 WHERE id_tipo = 2;



ALTER TABLE `resoconto`
	ADD COLUMN `costo_extra` DECIMAL(10,2) NULL DEFAULT NULL AFTER `fat_SpeseRap`,
	ADD COLUMN `prezzo_extra` DECIMAL(10,2) NULL DEFAULT NULL AFTER `costo_extra`;

UPDATE `resoconto` SET costo_extra = 0, prezzo_extra = 0;

ALTER TABLE `resoconto_totali`
	CHANGE COLUMN `prezzo_diritto_chiamata` `prezzo_diritto_chiamata` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `costo_diritto_chiamata`,
	ADD COLUMN `costo_extra` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `prezzo_materiale`,
	ADD COLUMN `prezzo_extra` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `costo_extra`;

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
