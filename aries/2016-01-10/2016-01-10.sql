UPDATE destinazione_cliente 
SET
	destinazione_cliente.longitudine = NULL,
	destinazione_cliente.latitudine = NULL
WHERE 
	destinazione_cliente.longitudine = '' OR
	destinazione_cliente.latitudine = ''; 
	
UPDATE destinazione_cliente 
SET
	destinazione_cliente.longitudine = 0,
	destinazione_cliente.latitudine = 0
WHERE 
	destinazione_cliente.longitudine IS NULL OR
	destinazione_cliente.latitudine IS NULL; 

UPDATE destinazione_cliente
SET 
	destinazione_cliente.longitudine = CONCAT(SUBSTRING_INDEX(longitudine,',',1), '.', 
		SUBSTRING(SUBSTRING_INDEX(longitudine,',',-1),1,8) ), 
		
	destinazione_cliente.latitudine = CONCAT(SUBSTRING_INDEX(latitudine,',',1), '.', 
		SUBSTRING(SUBSTRING_INDEX(latitudine,',',-1),1,8) )
		
WHERE longitudine LIKE '%,%' OR latitudine LIKE '%,%' ; 

ALTER TABLE `destinazione_cliente`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `numero_civico` `numero_civico` SMALLINT NULL DEFAULT NULL AFTER `Indirizzo`,
	CHANGE COLUMN `Km_sede` `Km_sede` SMALLINT NULL DEFAULT '0' AFTER `Altro`,
	CHANGE COLUMN `Pedaggio` `Pedaggio` DECIMAL(11,2) NULL DEFAULT '0.0000' AFTER `Km_sede`,
	CHANGE COLUMN `Tempo_strada` `Tempo_strada` SMALLINT NULL DEFAULT '0' AFTER `Pedaggio`,
	CHANGE COLUMN `piano` `piano` TINYINT NULL DEFAULT NULL AFTER `alle2`,
	CHANGE COLUMN `interno` `interno` TINYINT UNSIGNED NULL DEFAULT NULL AFTER `piano`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Latitudine`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Utente_mod`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `Utente_ins`,
	CHANGE COLUMN `data_ultima_modifica` `Data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `long` DECIMAL(11,2) NOT NULL DEFAULT 0,
	ADD COLUMN `lat` DECIMAL(11,2) NOT NULL DEFAULT 0,
	ADD UNIQUE INDEX `Id` (`Id`);
	
ALTER TABLE `destinazione_cliente`
	DROP COLUMN `long`,
	DROP COLUMN `lat`,
	ADD COLUMN `long` DECIMAL(8,8) NOT NULL DEFAULT 0,
	ADD COLUMN `lat` DECIMAL(8,8) NOT NULL DEFAULT 0;	
	
ALTER TABLE `destinazione_cliente`
	CHANGE COLUMN `long` `long` DECIMAL(11,8) NOT NULL DEFAULT '0.00000000' AFTER `Data_mod`,
	CHANGE COLUMN `lat` `lat` DECIMAL(11,8) NOT NULL DEFAULT '0.00000000' AFTER `long`;
	
UPDATE destinazione_cliente 
SET
	destinazione_cliente.long = CAST(longitudine AS DECIMAL(11,8)),
	destinazione_cliente.lat = CAST(latitudine AS DECIMAL(11,8));
	
ALTER TABLE `destinazione_cliente`
	DROP COLUMN `longitudine`,
	DROP COLUMN `latitudine`,
	CHANGE COLUMN `long` `longitudine` DECIMAL(11,8) NOT NULL DEFAULT '0.00000000' AFTER `Id_Autostrada`,
	CHANGE COLUMN `lat` `latitudine` DECIMAL(11,8) NOT NULL DEFAULT '0.00000000' AFTER `longitudine`;



ALTER TABLE `destinazione_cliente`
	CHANGE COLUMN `Pedaggio` `Pedaggio` DECIMAL(11,2) NULL DEFAULT '0.00' AFTER `Km_sede`,
	CHANGE COLUMN `attivo` `attivo` BIT NULL DEFAULT b'1' AFTER `Tempo_strada`,
	CHANGE COLUMN `ztl` `ztl` BIT NOT NULL DEFAULT b'0' AFTER `attivo`,
	CHANGE COLUMN `Autostrada` `Autostrada` BIT NOT NULL DEFAULT b'0' AFTER `Note`,
	CHANGE COLUMN `Sede_principale` `Sede_principale` BIT NOT NULL DEFAULT b'0' AFTER `Autostrada`;

ALTER TABLE `impianto_cliente`
	ALTER `Data_Inizio` DROP DEFAULT,
	ALTER `Data_fine` DROP DEFAULT;
ALTER TABLE `impianto_cliente`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `Data_Inizio` `Data_Inizio` DATETIME NOT NULL AFTER `Id_cliente`,
	CHANGE COLUMN `Data_fine` `Data_fine` DATETIME NOT NULL AFTER `Data_Inizio`,
	ADD COLUMN `Utente_ins` INT(11) NOT NULL AFTER `Figura`,
	ADD COLUMN `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Utente_ins`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`);


ALTER TABLE `impianto_cliente`
	ALTER `Utente_ins` DROP DEFAULT;
ALTER TABLE `impianto_cliente`
	CHANGE COLUMN `Utente_ins` `Utente_ins` INT(11) NOT NULL AFTER `Figura`,
	CHANGE COLUMN `Data_ins` `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Utente_ins`;


ALTER TABLE `impianto_descrizioni`
	ALTER `Data_inizio` DROP DEFAULT,
	ALTER `data_fine` DROP DEFAULT;
ALTER TABLE `impianto_descrizioni`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `Data_inizio` `Data_inizio` DATETIME NOT NULL AFTER `Descrizione`,
	CHANGE COLUMN `data_fine` `data_fine` DATETIME NOT NULL AFTER `Data_inizio`,
	ADD COLUMN `Utente_ins` INT NOT NULL AFTER `data_fine`,
	ADD COLUMN `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Utente_ins`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`);


CREATE TABLE `Operaio_spostamenti` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Id_operaio` INT NOT NULL DEFAULT '0' COMMENT 'id_operatio connesso al tablet',
	`Id_utente` INT NOT NULL DEFAULT '0' COMMENT 'id_utente connesso al tablet',
	`Latitudine` DECIMAL(11,8) NOT NULL DEFAULT '0',
	`Longitudine` DECIMAL(11,8) NOT NULL DEFAULT '0',
	`Data_rilevazione` DATETIME NOT NULL COMMENT 'Data rilevazione coordinate',
	`Sorgente_rilevazione` TINYINT NULL COMMENT 'Tipo di sorgente rilevazione. 1 = GPS | 2 = rete telefonica  | 3 = Altro',
	`Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;




