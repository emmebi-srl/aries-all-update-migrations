CREATE TABLE `magazzino_rapporto_materiale` (
	`id_magazzino_rapporto` BIGINT(11) NOT NULL AUTO_INCREMENT,
	`id_operazione` BIGINT(11) NOT NULL,
	`id_rapporto` BIGINT(11) NOT NULL,
	`anno_rapporto` INT(11) NOT NULL,
	`id_tab` INT(11) NOT NULL,
	PRIMARY KEY (`id_magazzino_rapporto`),
	CONSTRAINT `FK_magazzino_rapporto_rapporto` FOREIGN KEY (`id_rapporto`, `anno_rapporto`, `id_tab`) REFERENCES `rapporto_materiale` (`Id_rapporto`, `anno`, `id_tab`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_magazzino_rapporto_magazzino_operazione` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `magazzino_rapporto_materiale`
	ADD UNIQUE INDEX `id_rapporto_anno_rapporto_id_tab` (`id_rapporto`, `anno_rapporto`, `id_tab`),
	ADD UNIQUE INDEX `id_operazione` (`id_operazione`);

ALTER TABLE `magazzino_operazione`
	ADD COLUMN `sorgente` SMALLINT NULL DEFAULT '1' COMMENT '1 = manuale | 2 = rapporto  | 3 = ddt | 4 = traferimento magazzini' AFTER `id_magazzino`;
ALTER TABLE `magazzino_operazione`
	CHANGE COLUMN `sorgente` `sorgente` SMALLINT(6) NULL DEFAULT '1' COMMENT '1 = manuale | 2 = rapporto  | 3 = ddt | 4 = traferimento magazzini | 5 = manuale da mobile' AFTER `id_magazzino`;
ALTER TABLE `magazzino_operazione`
	CHANGE COLUMN `sorgente` `sorgente` SMALLINT(6) NULL DEFAULT '1' COMMENT '1 = manuale | 2 = rapporto  | 3 = ddt | 4 = traferimento magazzini | 5 = manuale da mobile | 6 fatt forn | 7 fattura | 8 ddt ricevuto | 9 lista prelievo' AFTER `id_magazzino`;
 
ALTER TABLE `magazzino_ddt_ricevuti`
	DROP FOREIGN KEY `ope_mag`;
ALTER TABLE `magazzino_ddt_ricevuti`
	ADD CONSTRAINT `ope_mag` FOREIGN KEY (`id_reso`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `magazzino_ddt_emessi`
	CHANGE COLUMN `id_reso` `id_reso` BIGINT(11) NULL DEFAULT NULL AFTER `id_tab`;

ALTER TABLE `magazzino_ddt_emessi`
	DROP FOREIGN KEY `mas`,
	DROP FOREIGN KEY `ope`;
ALTER TABLE `magazzino_ddt_emessi`
	CHANGE COLUMN `id_reso` `id_reso` BIGINT(11) NULL DEFAULT NULL AFTER `id_tab`,
	ADD CONSTRAINT `FK_id_operazione_magazzino_operazione` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE NO ACTION ON DELETE CASCADE,
	ADD CONSTRAINT `FK_id_reso_magazzino_operazione` FOREIGN KEY (`id_reso`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `magazzino_fattura`
	CHANGE COLUMN `id_operazione` `id_operazione` BIGINT NOT NULL AUTO_INCREMENT FIRST,
	ADD CONSTRAINT `FK_magazzino_fattura_operazione` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `magazzino_ddt_emessi`
	DROP FOREIGN KEY `FK_id_operazione_magazzino_operazione`,
	DROP FOREIGN KEY `FK_id_reso_magazzino_operazione`;
ALTER TABLE `magazzino_ddt_emessi`
	ADD CONSTRAINT `FK_id_operazione_magazzino_operazione` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE NO ACTION ON DELETE CASCADE,
	ADD CONSTRAINT `FK_id_reso_magazzino_operazione` FOREIGN KEY (`id_reso`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `magazzino_ddt_emessi`
	DROP FOREIGN KEY `FK_id_reso_magazzino_operazione`;
ALTER TABLE `magazzino_ddt_emessi`
	ADD CONSTRAINT `FK_id_reso_magazzino_operazione` FOREIGN KEY (`id_reso`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE CASCADE ON DELETE SET NULL;


ALTER TABLE `magazzino_ddt_ricevuti`
	DROP FOREIGN KEY `ope_mag`,
	DROP FOREIGN KEY `maga_ope`;
ALTER TABLE `magazzino_ddt_ricevuti`
	ADD CONSTRAINT `ope_mag` FOREIGN KEY (`id_reso`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE SET NULL ON DELETE CASCADE,
	ADD CONSTRAINT `maga_ope` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE NO ACTION ON DELETE CASCADE;

ALTER TABLE `magazzino_fornfattura`
	DROP FOREIGN KEY `FK_magazzino_fornfattura_1`;

ALTER TABLE `magazzino_fornfattura`
	CHANGE COLUMN `id_operazione` `id_operazione` BIGINT NOT NULL AUTO_INCREMENT FIRST,
	ADD CONSTRAINT `FK_magazzino_fornfattura_operazione` FOREIGN KEY (`id_operazione`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `magazzino_fornfattura`
	ADD CONSTRAINT `FK_magazzino_fornfattura_fornfatt` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fornfattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE;



SELECT id_utente INTO @USER_ID FROM utente where nome = 'admin';

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	UPDATE magazzino_operazione
	INNER JOIN   magazzino_ddt_emessi ON
		magazzino_ddt_emessi.id_operazione = magazzino_operazione.id_operazione
		OR 
		magazzino_ddt_emessi.id_reso = magazzino_operazione.id_operazione
	SET sorgente = 3;
	
	
	UPDATE magazzino_operazione
	INNER JOIN   magazzino_ddt_ricevuti ON
		magazzino_ddt_ricevuti.id_operazione = magazzino_operazione.id_operazione
		OR 
		magazzino_ddt_ricevuti.id_reso = magazzino_operazione.id_operazione
	SET sorgente = 8;

	UPDATE magazzino_operazione
	INNER JOIN   magazzino_fornfattura ON
		magazzino_fornfattura.id_operazione = magazzino_operazione.id_operazione
	SET sorgente = 6;

	
	UPDATE magazzino_operazione
	INNER JOIN   magazzino_fattura ON
		magazzino_fattura.id_operazione = magazzino_operazione.id_operazione
	SET sorgente = 7;

		
	UPDATE magazzino_operazione
	SET sorgente = 1
	WHERE sorgente IS NULL;

END $$
DELIMITER ;
CALL tmp;
