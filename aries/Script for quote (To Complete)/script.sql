UPDATE PREVENTIVO 
SET Id_utente = 1 
WHERE ID_utente IS NULL; 

ALTER TABLE `preventivo`
	DROP INDEX `Index_7_ut`,
	DROP FOREIGN KEY `FK_preventivo_4_ut`;


ALTER TABLE `preventivo`
	ALTER `id_utente` DROP DEFAULT;
ALTER TABLE `preventivo`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `id_utente` `Utente_ins` SMALLINT NOT NULL AFTER `secondo_sollecito`,
	ADD COLUMN `Utente_mod` SMALLINT NULL AFTER `Utente_ins`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `Utente_mod`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD UNIQUE INDEX `Id` (`Id`);


ALTER TABLE `preventivo`
	DROP INDEX `Index_8_per`,
	DROP INDEX `Index_9_da`,
	DROP FOREIGN KEY `FK_preventivo_5_per`,
	DROP FOREIGN KEY `FK_preventivo_6_da`;
ALTER TABLE `preventivo`
	CHANGE COLUMN `Note` `Note` TEXT NULL AFTER `Stato`,
	CHANGE COLUMN `data_invio` `data_invio` DATETIME NULL DEFAULT NULL AFTER `agente`,
	CHANGE COLUMN `controllo_promemoria` `controllo_promemoria` BIT NULL DEFAULT b'1' AFTER `data_invio`,
	CHANGE COLUMN `primo_sollecito` `primo_sollecito` DATETIME NULL DEFAULT NULL AFTER `controllo_promemoria`,
	CHANGE COLUMN `secondo_sollecito` `secondo_sollecito` DATETIME NULL DEFAULT NULL AFTER `primo_sollecito`,
	DROP COLUMN `data_creazione`,
	DROP COLUMN `per`,
	DROP COLUMN `da`,
	DROP COLUMN `segnalato`;
	
	
ALTER TABLE `preventivo`
	CHANGE COLUMN `anno` `anno` INT(11) NOT NULL DEFAULT '0' AFTER `Id_preventivo`,
	CHANGE COLUMN `Note` `Note` TEXT NULL AFTER `agente`;

	
ALTER TABLE `revisione_preventivo`
	ALTER `Id_preventivo` DROP DEFAULT,
	ALTER `data_creazione` DROP DEFAULT;
ALTER TABLE `revisione_preventivo`
	ADD COLUMN `Id` INT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `Id_preventivo` `Id_preventivo` INT(11) NOT NULL AFTER `Id`,
	CHANGE COLUMN `Anno` `Anno` INT(11) NOT NULL DEFAULT '0' AFTER `Id_preventivo`,
	CHANGE COLUMN `Stampato` `Stampato` BIT NULL DEFAULT b'0' AFTER `Id_revisione`,
	CHANGE COLUMN `Inviato` `Inviato` BIT NULL DEFAULT b'0' AFTER `Stampato`,
	CHANGE COLUMN `data` `data_documento` DATE NULL DEFAULT NULL AFTER `Inviato`,
	CHANGE COLUMN `Sconto_perc` `Sconto_perc` DECIMAL(11,2) NOT NULL DEFAULT '0.00' AFTER `Listino`,
	CHANGE COLUMN `Prezzo_ora` `Prezzo_ora` DECIMAL(11,2) NOT NULL DEFAULT '0.00' AFTER `Sconto_perc`,
	CHANGE COLUMN `costo_ora` `costo_ora` DECIMAL(11,2) NOT NULL DEFAULT '0.00' AFTER `Prezzo_ora`,
	CHANGE COLUMN `corpo` `corpo` TEXT NOT NULL AFTER `aliquota`,
	CHANGE COLUMN `ric_perc` `ric_perc` DECIMAL(11,2) NULL DEFAULT '0' AFTER `ric_tip`,
	CHANGE COLUMN `corpo_rtf` `corpo_rtf` TEXT NULL AFTER `ric_perc`,
	CHANGE COLUMN `data_creazione` `Data_ins` DATETIME NOT NULL AFTER `corpo_rtf`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT ZEROFILL NOT NULL DEFAULT '1' AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NULL DEFAULT NULL AFTER `Utente_ins`,
	ADD UNIQUE INDEX `Id` (`Id`);
	
	
ALTER TABLE `revisione_preventivo`
	CHANGE COLUMN `Utente_ins` `Utente_ins` SMALLINT(6) NOT NULL AFTER `Data_mod`;
	
ALTER TABLE `revisione_preventivo`
	CHANGE COLUMN `sitoin` `sitoin` VARCHAR(150) NULL AFTER `tariffa`;

ALTER TABLE `revisione_preventivo`
	CHANGE COLUMN `oggetto` `oggetto` TEXT NOT NULL AFTER `aliquota`,
	CHANGE COLUMN `corpo_rtf` `corpo_rtf` TEXT NULL AFTER `corpo`;


