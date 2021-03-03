DROP TABLE IF EXISTS checklist_rapporto;
DROP TABLE IF EXISTS checklist_tecnico;
DROP TABLE IF EXISTS checklist_paragrafo_riga;
DROP TABLE IF EXISTS checklist_paragrafo;
DROP TABLE IF EXISTS checklist;

CREATE TABLE `checklist` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_mobile` INT(11) NOT NULL,
	`data_esecuzione` DATE NOT NULL,
	`id_checklist_model` INT(11) NOT NULL,
	`id_operaio` INT(11) NOT NULL,
	`id_cliente` INT(11) NULL DEFAULT NULL,
	`id_responsabile` INT(11) NULL DEFAULT NULL,
	`id_impianto` INT(11) NULL DEFAULT NULL,
	`ragione_sociale` VARCHAR(150) NOT NULL,
	`indirizzo` VARCHAR(150) NOT NULL,
	`citta` VARCHAR(150) NOT NULL,
	`responsabile` VARCHAR(150) DEFAULT NULL,
	`impianto_luogo_installazione` VARCHAR(150) NOT NULL,
	`impianto_centrale` VARCHAR(150) NOT NULL,
	`impianto_data_installazione` DATE NULL DEFAULT NULL,
	`impianto_dipartimento` VARCHAR(150) NULL DEFAULT NULL,
	`timestamp_creazione` DATETIME NOT NULL,
	`utente_ins` INT(11) NOT NULL,
	`utente_mod` INT(11) NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	INDEX `fk_checklist_checklist_model` (`id_checklist_model`),
	INDEX `fk_checklist_operaio` (`id_operaio`),
	CONSTRAINT `fk_checklist_checklist_model` FOREIGN KEY (`id_checklist_model`) REFERENCES `checklist_model` (`id_check`),
	CONSTRAINT `fk_checklist_operaio` FOREIGN KEY (`id_operaio`) REFERENCES `operaio` (`Id_operaio`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;



CREATE TABLE `checklist_paragrafo` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_checklist` INT(11) NOT NULL,
	`id_checklist_model_paragrafo` INT(11) NOT NULL,
	`nome` VARCHAR(150) NOT NULL,
	`descrizione` TEXT NOT NULL,
	`ordine` INT(11) NOT NULL,
	`utente_mod` INT(11) NULL DEFAULT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX `FK_checklist_paragrafo_checklist` (`id_checklist`),
	CONSTRAINT `FK_checklist_paragrafo_checklist` FOREIGN KEY (`id_checklist`) REFERENCES `checklist` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
CREATE TABLE `checklist_paragrafo_riga` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_checklist` INT(11) NOT NULL,
	`id_paragrafo` INT(11) NOT NULL,
	`json_data` MEDIUMTEXT NOT NULL,
	`tipo_riga` TINYINT(4) NOT NULL,
	`id_checklist_model_elemento` INT(11) NOT NULL,
	`id_checklist_model_paragrafo` INT(11) NOT NULL,
	`id_checklist_model` INT(11) NOT NULL,
	`ordine` INT(11) NOT NULL,
	`nome` VARCHAR(150) NOT NULL,
	`descrizione` TEXT NULL,
	`indicazioni_tecnico` TEXT NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `fk_checklist_paragrafo_riga_checklist` (`id_checklist`),
	INDEX `fk_checklist_paragrafo_riga_checklist_paragrafo` (`id_paragrafo`),
	INDEX `fk_checklist_paragrafo_riga_checklist_tipo_riga` (`tipo_riga`),
	CONSTRAINT `fk_checklist_paragrafo_riga_checklist_tipo_riga` FOREIGN KEY (`tipo_riga`) REFERENCES `tipo_checklist_elemento` (`Id`),
	CONSTRAINT `fk_checklist_paragrafo_riga_checklist` FOREIGN KEY (`id_checklist`) REFERENCES `checklist` (`id`),
	CONSTRAINT `fk_checklist_paragrafo_riga_checklist_paragrafo` FOREIGN KEY (`id_paragrafo`) REFERENCES `checklist_paragrafo` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
CREATE TABLE `checklist_tecnico` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_checklist` INT(11) NOT NULL,
	`Id_tecnico` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_checklist_Id_tecnico` (`Id_checklist`, `Id_tecnico`),
	INDEX `fk_checklist_tecnico_operaio` (`Id_tecnico`),
	CONSTRAINT `fk_checklist_tecnico_checklist` FOREIGN KEY (`Id_checklist`) REFERENCES `checklist` (`id`),
	CONSTRAINT `fk_checklist_tecnico_operaio` FOREIGN KEY (`Id_tecnico`) REFERENCES `operaio` (`Id_operaio`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE `checklist_rapporto` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_checklist` INT(11) NOT NULL,
	`id_rapporto` INT(11) NOT NULL,
	`anno_rapporto` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	INDEX `fk_checklist_rapporto_checklist` (`Id_checklist`),
	CONSTRAINT `fk_checklist_rapporto_checklist` FOREIGN KEY (`Id_checklist`) REFERENCES `checklist` (`id`)
)
ENGINE=InnoDB
;

