
ALTER TABLE `fornfattura`
	CHANGE COLUMN `pec_destinatario` `pec_destinatario` VARCHAR(100) NULL DEFAULT NULL AFTER `codice_destinatario`;