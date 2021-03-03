DROP TABLE IF EXISTS rapporto_giornaliero;
CREATE TABLE `rapporto_giornaliero` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_operaio` INT(11) NOT NULL,
	`data_rapporto` DATE NOT NULL,
	`stampato` BIT NOT NULL DEFAULT b'0',
	`visionato` BIT NOT NULL DEFAULT b'0',
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`utente_ins` MEDIUMINT(9) NOT NULL,
	`utente_mod` MEDIUMINT(9) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `Fk_rapportino_giornaliero_operaio` (`id_operaio`),
	CONSTRAINT `Fk_rapportino_giornaliero_operaio` FOREIGN KEY (`id_operaio`) REFERENCES `operaio` (`Id_operaio`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `rapporto_giornaliero`
	ADD COLUMN `note` TEXT NULL DEFAULT NULL AFTER `visionato`;


DROP TABLE IF EXISTS rapporto_giornaliero_attivita;
CREATE TABLE `rapporto_giornaliero_attivita` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_rapporto_giornaliero` INT(11) NOT NULL,
	`tipo_lavoro` INT(11) NOT NULL,
	`descrizione_lavoro` VARCHAR(200) NULL DEFAULT NULL,
	`ora_inizio` TIME NOT NULL,
	`ora_fine` TIME NOT NULL,
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`utente_ins` MEDIUMINT(9) NOT NULL,
	`utente_mod` MEDIUMINT(9) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `Fk_rapportino_giornaliero_attivita` (`Id_rapporto_giornaliero`),
	CONSTRAINT `Fk_rapportino_giornaliero_attivita` FOREIGN KEY (`Id_rapporto_giornaliero`) REFERENCES `rapporto_giornaliero` (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
ALTER TABLE `rapporto_giornaliero_attivita`
	ADD COLUMN `note` TEXT NULL DEFAULT NULL AFTER `ora_fine`;


DROP TABLE IF EXISTS rapporto_giornaliero_tipo_attivita;
CREATE TABLE `rapporto_giornaliero_tipo_attivita` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`Id`)
)
ENGINE=InnoDB
;

INSERT INTO rapporto_giornaliero_tipo_attivita VALUES 
	(1, 'Viaggio'), 
	(2, 'Lavoro'), 
	(3, 'Pranzo (casa)'), 
	(4, 'Pranzo (ristorante)'), 
	(5, 'Permesso'),
	(6, 'Ferie'),
	(7, 'Malattia'),
	(8, 'Altro'); 




INSERT INTO `tipo_documento` (`Nome`) VALUES ('RAPPORTO GIORNALIERO');
INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `fax`, `Data_mod`) VALUES (27, 'DOCUMENTO', 0, b'0', b'0', '2017-05-16 07:13:46');
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`) VALUES (0, 27, 1);