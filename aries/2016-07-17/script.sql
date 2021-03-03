ALTER TABLE `rapporto`
	CHANGE COLUMN `Richiesto` `Richiesto` VARCHAR(30) NULL DEFAULT NULL COMMENT 'Testo libero per inserire il nome del richiedente dell\'intervento' AFTER `Id_cliente`,
	CHANGE COLUMN `Mansione` `Mansione` VARCHAR(20) NULL DEFAULT NULL COMMENT 'Mansione del responabile' AFTER `Richiesto`;
ALTER TABLE `rapporto`
	CHANGE COLUMN `Note_Generali` `Note_Generali` VARCHAR(1000) NULL DEFAULT NULL COMMENT 'Note generali (o in evidenza)' AFTER `Stato`,
	CHANGE COLUMN `prima` `prima` INT(10) UNSIGNED NULL DEFAULT '0' COMMENT 'Identifica se il rapporto prevede la prima ora' AFTER `controllo_periodico`;

ALTER TABLE `rapporto`
	CHANGE COLUMN `scan` `scan` BIT NULL DEFAULT b'0' AFTER `materiale`,
	CHANGE COLUMN `firma1` `firma1` BIT NULL DEFAULT NULL AFTER `appunti`,
	CHANGE COLUMN `firma2` `firma2` BIT NULL DEFAULT NULL AFTER `firma1`,
	CHANGE COLUMN `firma3` `firma3` BIT NULL DEFAULT NULL AFTER `firma2`;
	
ALTER TABLE `rapporto`
	CHANGE COLUMN `scan` `scan` BIT(1) NULL DEFAULT b'0' COMMENT 'Identifica se il rapporto è stato scanerizzato o meno ' AFTER `materiale`;

ALTER TABLE `rapporto`
	CHANGE COLUMN `Diritto_chiamata` `Diritto_chiamata` BIT NOT NULL DEFAULT b'0' AFTER `Tipo_intervento`,
	CHANGE COLUMN `dir_ric_fatturato` `dir_ric_fatturato` BIT NOT NULL DEFAULT b'0' AFTER `Diritto_chiamata`,
	CHANGE COLUMN `prima` `prima` BIT(1) NULL DEFAULT b'0' COMMENT 'Identifica se il rapporto prevede la prima ora' AFTER `controllo_periodico`;

	
ALTER TABLE `rapporto`
	ALTER `Id_rapporto` DROP DEFAULT;
ALTER TABLE `rapporto`
	CHANGE COLUMN `Id_rapporto` `Id_rapporto` BIGINT NOT NULL FIRST,
	CHANGE COLUMN `Totale` `Totale` DECIMAL(11,2) NULL DEFAULT '0.0000' AFTER `Numero_ordine`,
	CHANGE COLUMN `Costo` `Costo` DECIMAL(10,2) NULL DEFAULT '0.0000' AFTER `Data_esecuzione`,
	CHANGE COLUMN `materiale` `materiale` DECIMAL(10,2) NULL DEFAULT '0.0000' AFTER `Costo`,
	CHANGE COLUMN `controllo_periodico` `controllo_periodico` DECIMAL(10,2) NULL DEFAULT '0.0000' AFTER `anno_fattura`,
	CHANGE COLUMN `cost_lav` `cost_lav` DECIMAL(10,2) NULL DEFAULT '0' AFTER `id_utente`,
	CHANGE COLUMN `prez_lav` `prez_lav` DECIMAL(10,2) NULL DEFAULT '0' AFTER `cost_lav`,
	CHANGE COLUMN `economia` `economia` DECIMAL(10,2) NULL DEFAULT '0.00' AFTER `firma3`;

	
	
ALTER TABLE `rapporto`
	ADD COLUMN `Id` INT NULL AUTO_INCREMENT FIRST,
	ADD COLUMN `Id_tipo_sorgente` TINYINT NOT NULL DEFAULT '1' COMMENT 'TIPO SORGENTE DI ARRIVO DEL RAPPORTO ( 1 = cartaceo, 2 = telematico)' AFTER `economia`,
	ADD UNIQUE INDEX `Id` (`Id`);
	
	
	
UPDATE rapporto
INNER JOIN rapporto_mobile_lavoro 
	 ON rapporto_mobile_lavoro.id_rapporto=rapporto.id_rapporto AND rapporto_mobile_lavoro.anno_rapporto=rapporto.anno
SET rapporto.Id_tipo_sorgente = 2;


ALTER TABLE `rapporto_mobile`
	ADD COLUMN `Id` INT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `Id` (`Id`);

