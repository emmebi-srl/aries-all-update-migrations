ALTER TABLE `magazzino`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	ADD COLUMN `Utente_ins` SMALLINT NULL AFTER `tipo_magazzino`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`,
	ADD COLUMN `Data_ins` DATETIME NULL AFTER `Utente_mod`,
	CHANGE COLUMN `ora_modifica` `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	DROP COLUMN `posto`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`),
	ADD UNIQUE INDEX `Id_articolo__tipo_magazzino` (`Id_articolo`, `tipo_magazzino`);

ALTER TABLE `magazzino`
	CHANGE COLUMN `giacenza` `giacenza` DECIMAL(11,2) NOT NULL DEFAULT '0' AFTER `Id_articolo`;


ALTER TABLE `magazzino_azzera`
	ADD COLUMN `Id_utente` INT NOT NULL AFTER `data_azzeramento`,
	ADD COLUMN `Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Id_utente`,
	ADD COLUMN `Id_tipo_magazzino` INT NOT NULL AFTER `id`;
	
ALTER TABLE `magazzino_stored`
	ALTER `id_articolo` DROP DEFAULT,
	ALTER `giacenza` DROP DEFAULT,
	ALTER `id_magazzino` DROP DEFAULT;
ALTER TABLE `magazzino_stored`
	CHANGE COLUMN `id_articolo` `id_articolo` VARCHAR(11) NOT NULL AFTER `id_stored`,
	CHANGE COLUMN `giacenza` `giacenza` DECIMAL(11,2) NOT NULL AFTER `id_articolo`,
	CHANGE COLUMN `id_magazzino` `tipo_magazzino` INT(11) NOT NULL AFTER `giacenza`;

ALTER TABLE `magazzino_stored`
	DROP FOREIGN KEY `FK_magazzino_stored_1_stor`;

ALTER TABLE `magazzino_stored`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	ADD COLUMN `Utente_ins` SMALLINT NULL AFTER `tipo_magazzino`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`,
	ADD COLUMN `Data_ins` DATETIME NULL AFTER `Utente_mod`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`),
	ADD UNIQUE INDEX `Id_articolo__tipo_magazzino__id_stored` (`Id_articolo`, `tipo_magazzino`, Id_stored);
	
ALTER TABLE `magazzino_stored`
	ADD CONSTRAINT `Fk_id_stored` FOREIGN KEY (`id_stored`) REFERENCES `magazzino_arch` (`id_arch`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `magazzino_arch`
	ADD COLUMN `Utente_ins` SMALLINT NULL AFTER `descrizione`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`,
	ADD COLUMN `Data_ins` DATETIME NULL AFTER `Utente_mod`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`;

ALTER TABLE `magazzino_arch`
	ALTER `anno` DROP DEFAULT;
ALTER TABLE `magazzino_arch`
	CHANGE COLUMN `anno` `anno` SMALLINT NOT NULL AFTER `id_arch`;

	
ALTER TABLE `evento`
	CHANGE COLUMN `Stato_notifica` `Stato_notifica` TINYINT(4) NULL DEFAULT '3' AFTER `Data_sveglia`;


ALTER TABLE `evento`
	ADD INDEX `Data_esecuzione` (`Data_esecuzione`);


