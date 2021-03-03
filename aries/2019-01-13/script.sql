ALTER TABLE `fornfattura`
	CHANGE COLUMN `codice_destinatario` `codice_destinatario` VARCHAR(7) NULL DEFAULT NULL AFTER `formato_trasmissione`,
	CHANGE COLUMN `pec_destinatario` `pec_destinatario` VARCHAR(50) NULL DEFAULT NULL AFTER `codice_destinatario`,
	CHANGE COLUMN `progressivo_invio` `progressivo_invio` VARCHAR(20) NULL DEFAULT NULL AFTER `pec_destinatario`,
	CHANGE COLUMN `sorgente_documento` `sorgente_documento` VARCHAR(15) NULL DEFAULT 'manuale' AFTER `tipo_fattura_elettronica`;
