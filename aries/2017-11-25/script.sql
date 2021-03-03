CREATE TABLE `rapporto_giornaliero_attivita_posizione` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_rapporto_giornaliero` INT(11) NOT NULL,
	`Id_rapporto_giornaliero_attivita` INT(11) NOT NULL,
	`id_operaio` INT(11) NOT NULL,
	`latitudine` DECIMAL(10,2) NOT NULL,
	`longitudine` DECIMAL(10,2) NOT NULL,
	`sorgente_rilevamento` INT(11) NOT NULL,
	`tipo_posizione` INT(11) NOT NULL,
	`data_ins` DATETIME NOT NULL,
	`utente_ins` MEDIUMINT(9) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `Fk_rapportino_giornaliero_attivita` (`Id_rapporto_giornaliero`),
	INDEX `FK_rapporto_giornaliero_att_pos_rapporto_giornaliero_att` (`Id_rapporto_giornaliero_attivita`),
	CONSTRAINT `FK_rapporto_giornaliero_att_pos_rapporto_giornaliero_att` FOREIGN KEY (`Id_rapporto_giornaliero_attivita`) REFERENCES `rapporto_giornaliero_attivita` (`id`),
	CONSTRAINT `rapporto_giornaliero_attivita_posizione_ibfk_1` FOREIGN KEY (`Id_rapporto_giornaliero`) REFERENCES `rapporto_giornaliero` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
ROW_FORMAT=COMPACT
;
CREATE TABLE `rapporto_giornaliero_attivita_rapporto` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_rapporto_giornaliero` INT(11) NOT NULL,
	`Id_rapporto_giornaliero_attivita` INT(11) NOT NULL,
	`Id_rapporto` INT(11) NOT NULL,
	`Anno_rapporto` INT(11) NOT NULL,
	`data_ins` DATETIME NOT NULL,
	`utente_ins` MEDIUMINT(9) NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `Fk_rapportino_giornaliero_attivita` (`Id_rapporto_giornaliero`),
	INDEX `FK_rapporto_giornaliero_att_rapp_rapporto_giornaliero_att` (`Id_rapporto_giornaliero_attivita`),
	CONSTRAINT `FK_rapporto_giornaliero_att_rapp_rapporto_giornaliero_att` FOREIGN KEY (`Id_rapporto_giornaliero_attivita`) REFERENCES `rapporto_giornaliero_attivita` (`id`),
	CONSTRAINT `rapporto_giornaliero_attivita_rapporto_ibfk_1` FOREIGN KEY (`Id_rapporto_giornaliero`) REFERENCES `rapporto_giornaliero` (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
ROW_FORMAT=COMPACT
;
