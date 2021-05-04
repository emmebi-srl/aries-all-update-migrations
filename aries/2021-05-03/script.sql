ALTER TABLE `ordine_fornitore`
	ADD COLUMN `segna_come_evaso` BIT(1) NOT NULL DEFAULT b'0' AFTER `stato`,
	ADD COLUMN `stato_pre_evasione` INT NULL DEFAULT '0' AFTER `segna_come_evaso`,
	ADD COLUMN `utente_evasione` INT(11) NULL DEFAULT NULL AFTER `stato_pre_evasione`,
	CHANGE COLUMN `id_utente` `id_utente` INT(11) NULL DEFAULT NULL AFTER `stampato`,
	CHANGE COLUMN `data_ultima_modifica` `data_ultima_modifica` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `id_utente`;


ALTER TABLE `ordine_fornitore`
	CHANGE COLUMN `segna_come_evaso` `segna_come_evaso` BIT(1) NOT NULL DEFAULT b'1' AFTER `stato`,
	CHANGE COLUMN `stato_pre_evasione` `stato_pre_evasione` INT(11) NULL DEFAULT NULL AFTER `segna_come_evaso`;

ALTER TABLE `ordine_fornitore`
	ADD CONSTRAINT `FK_ordine_fornitore_9` FOREIGN KEY (`utente_evasione`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL;
