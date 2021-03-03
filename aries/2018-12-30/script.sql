ALTER TABLE `fornfattura`
	ADD COLUMN `sorgente_documento` VARCHAR(50) NULL DEFAULT 'manuale' AFTER `tipo_fattura_elettronica`;
