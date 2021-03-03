ALTER TABLE `fornfattura`
	CHANGE COLUMN `codice_destintario` `codice_destinatario` VARCHAR(10) NULL DEFAULT NULL AFTER `formato_trasmissione`;

ALTER TABLE `fornfattura`
	CHANGE COLUMN `pec_destintario` `pec_destinatario` VARCHAR(10) NULL DEFAULT NULL AFTER `codice_destinatario`;


ALTER TABLE `fornfattura`
	ADD COLUMN `e_fattura_filename` TEXT NULL DEFAULT NULL AFTER `sorgente_documento`;

INSERT INTO `stampante_moduli` VALUES (14, 'FATTURA ELET.', 4, b'0', b'0', b'0', b'1', b'1', NULL, NULL, b'1', CURRENT_DATE);
INSERT INTO `stampante_moduli_formati` (Id_modulo, Id_documento, Id_formato, timestamp) VALUES (4, 14, 5, '2016-12-10 07:54:04');
