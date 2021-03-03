DROP TABLE IF EXISTS Tecnico_evento; 
DROP TABLE IF EXISTS impianto_evento; 
DROP TABLE IF EXISTS Automezzo_evento; 
DROP TABLE IF EXISTS operaio_evento; 
DROP TABLE IF EXISTS tecnico_evento; 
DROP TABLE IF EXISTS evento_tecnici;
DROP TABLE IF EXISTS ticket_evento; 
DROP TABLE IF EXISTS Automezzo_evento; 
DROP TABLE IF EXISTS utente_evento; 
DROP TABLE IF EXISTS preventivo_evento; 
DROP TABLE IF EXISTS preventivo_visita;
DROP TABLE IF EXISTS evento_agente_checked;
DROP TABLE IF EXISTS evento_agente;
DROP TABLE IF EXISTS evento_ricorrenza;  
DROP TABLE IF EXISTS evento; 

CREATE TABLE IF NOT EXISTS `Evento` (
	`Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Oggetto` VARCHAR(50) NOT NULL,
	`Descrizione` TEXT NOT NULL,
	`Id_riferimento` SMALLINT NULL,
	`Id_tipo_evento` TINYINT UNSIGNED NOT NULL,
	`Eseguito` BIT NOT NULL DEFAULT 0,
	`Ricorrente` BIT NOT NULL DEFAULT 0,
	`Giorni_ricorrenza` INT DEFAULT 0,
	`Data_esecuzione` DATE NOT NULL,
	`Ora_inizio_esecuzione` TIME NOT NULL,
	`Ora_fine_esecuzione` TIME NOT NULL,
	`Sveglia` BIT NOT NULL DEFAULT 0,
	`Data_sveglia` TIMESTAMP DEFAULT 0,
	`Data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`Data_mod` TIMESTAMP NOT NULL,
	`Utente_ins` MEDIUMINT NOT NULL DEFAULT 0,
	`Utente_mod` MEDIUMINT NOT NULL DEFAULT 0,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS Evento_Operaio; 
CREATE TABLE IF NOT EXISTS `Evento_Operaio` (
	`Id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Id_evento` INT UNSIGNED  NOT NULL,
	`Id_operaio` INT UNSIGNED  NOT NULL,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `operaio`
	CHANGE COLUMN `d_nas` `d_nas` DATE NOT NULL DEFAULT '1970-01-01' AFTER `l_nas`,
	ADD COLUMN `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER `sigla_operaio`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NULL AFTER `Utente_ins`;


ALTER TABLE `rapporto_mobile_lavoro`
	CHANGE COLUMN `materiale_uso` `materiale_uso` DECIMAL(10,2) NULL DEFAULT NULL AFTER `controllo_periodico`,
	CHANGE COLUMN `spese` `spese` DECIMAL(10,2) NULL DEFAULT NULL AFTER `spese_consuntivo`,
	CHANGE COLUMN `tecnici` `tecnici` VARCHAR(150) NULL DEFAULT NULL AFTER `ora_fine_secondo_periodo`,
	CHANGE COLUMN `totale_ore` `totale_ore` VARCHAR(45) NULL DEFAULT NULL AFTER `tecnici`,
	CHANGE COLUMN `extra` `extra` DECIMAL(10,2) NULL DEFAULT NULL AFTER `extra_testo`,
ADD COLUMN `numero_furgoni` TINYINT NULL DEFAULT NULL AFTER `extra`;
