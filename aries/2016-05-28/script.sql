ALTER TABLE `unita_misura`
	ADD COLUMN `Id` SMALLINT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `Id` (`Id`);
ALTER TABLE `articolo_listino`
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `data_inizio`;
UPDATE `articolo_listino`
	SET `Data_mod` = data_inizio; 
	
	
ALTER TABLE `nota`
	CHANGE COLUMN `prezz` `prezz` DECIMAL(10,2) NULL DEFAULT NULL AFTER `note`,
	CHANGE COLUMN `cost` `cost` DECIMAL(10,2) NULL DEFAULT NULL AFTER `prezz`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `nota_stato`;
	
UPDATE `nota`
	SET `Data_mod` = NOW();
	
ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `scontoriga` `scontoriga` DECIMAL(10,2) NULL DEFAULT '0.00' AFTER `iva`,
	CHANGE COLUMN `scontolav` `scontolav` DECIMAL(10,2) NULL DEFAULT '0.00' AFTER `scontoriga`;

	
	
ALTER TABLE `articolo_lotto`
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(22) NULL DEFAULT NULL AFTER `Id_lotto`,
	CHANGE COLUMN `quantità` `quantità` DECIMAL(10,2) NULL DEFAULT NULL AFTER `codice_fornitore`,
	CHANGE COLUMN `montato` `montato` BIT NULL DEFAULT b'0' AFTER `id_tab`,
	CHANGE COLUMN `prezzo` `prezzo` DECIMAL(10,2) NULL DEFAULT '0' AFTER `tipo`,
	CHANGE COLUMN `costo` `costo` DECIMAL(10,2) NULL DEFAULT '0' AFTER `prezzo`,
	CHANGE COLUMN `prezzo_h` `prezzo_h` DECIMAL(10,2) NULL DEFAULT '0' AFTER `costo`,
	CHANGE COLUMN `costo_h` `costo_h` DECIMAL(10,2) NULL DEFAULT '0' AFTER `prezzo_h`;
	
	
ALTER TABLE `articolo_lotto`
	ALTER `tipo` DROP DEFAULT;
ALTER TABLE `articolo_lotto`
	CHANGE COLUMN `tipo` `tipo` VARCHAR(5) NOT NULL AFTER `montato`,
	CHANGE COLUMN `prezzo` `prezzo` DECIMAL(10,2) NULL DEFAULT '0.00' AFTER `tipo`;

