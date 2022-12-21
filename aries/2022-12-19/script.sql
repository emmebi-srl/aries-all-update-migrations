DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE system_id INT(11);
	DECLARE curA CURSOR FOR SELECT Id_impianto FROM impianto;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	
	OPEN curA;
	loopA: LOOP
		SET done = 0;
		FETCH curA INTO system_id;
		IF done THEN
			LEAVE loopA;
		END IF;
		

		CALL sp_ariesSystemCurrentSubscriptionRefresh(system_id);
	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;


CREATE TABLE `stato_invio_abbonamento` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`colore` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`data_mod` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `colore` (`colore`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2
;

INSERT INTO `stato_invio_abbonamento` (`nome`, `colore`, `data_mod`) VALUES ('ACCETTATO', 'cllime', '2022-12-20 09:15:12');
INSERT INTO `stato_invio_abbonamento` (`nome`, `colore`, `data_mod`) VALUES ('DA GESTIRE', 'clblue', '2022-12-20 09:15:13');
INSERT INTO `stato_invio_abbonamento` (`nome`, `colore`, `data_mod`) VALUES ('IN ATTESA DI CONFERMA', 'clyellow', '2022-12-20 09:15:14');
INSERT INTO `stato_invio_abbonamento` (`nome`, `colore`, `data_mod`) VALUES ('NON ACCETTATO', 'clred', '2022-12-20 09:15:15');


ALTER TABLE `impianto`
	ADD CONSTRAINT `impianto_stato_invio_abbonamento` FOREIGN KEY (`stato_invio_doc`) REFERENCES `stato_invio_abbonamento` (`colore`) ON UPDATE CASCADE ON DELETE NO ACTION;
