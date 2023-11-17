ALTER TABLE `rapporto`
	CHANGE COLUMN `controllo_periodico` `controllo_periodico` DECIMAL(10,2) NULL DEFAULT '0.00' COMMENT 'Prezzo del controllo periodico' AFTER `anno_fattura`,
	ADD COLUMN `controllo_periodico_costo` DECIMAL(10,2) NULL DEFAULT '0.00' COMMENT 'Costo del controllo periodico' AFTER `controllo_periodico`;



ALTER TABLE `rapporto`
	ADD COLUMN `controllo_periodico_quantita` INT NULL DEFAULT '0' COMMENT 'Quantita del controllo periodico' AFTER `controllo_periodico_costo`;

ALTER TABLE `rapporto_totali`
	ADD COLUMN `costo_manutenzione` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `prezzo_manutenzione`;

ALTER TABLE `resoconto_totali`
	ADD COLUMN `costo_manutenzione` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `prezzo_manutenzione`;


UPDATE rapporto SET controllo_periodico_quantita = 1 WHERE tipo_intervento IN (6, 9);
