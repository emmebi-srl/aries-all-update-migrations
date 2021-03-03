DROP TABLE IF EXISTS rapporto_mobile_destinatario;
CREATE TABLE `rapporto_mobile_destinatario` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_rapporto` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	`email` VARCHAR(100) NOT NULL,
	`tipo_email` TINYINT(4) NOT NULL COMMENT '1 = MAIN, 2 = RESPONSIBLE, 3 = MANUAL, 4 = FROM CONTACTS',
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS rapporto_mobile_evento;
CREATE TABLE `rapporto_mobile_evento` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_rapporto` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	`id_evento` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


ALTER TABLE `rapporto_mobile`
	CHANGE COLUMN `id_tecnico` `id_tecnico` MEDIUMINT(9) NULL DEFAULT NULL AFTER `da_reperibilita_telefonica`;

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `timestamp_reperibilita` DATETIME NULL,
	ADD COLUMN `timestamp_creazione` DATETIME NULL,
	ADD COLUMN `timestamp_invio` DATETIME NULL;
	
ALTER TABLE `rapporto_mobile_collaudo`
	ADD COLUMN `timestamp_creazione` DATETIME NULL, 
	ADD COLUMN `timestamp_invio` DATETIME NULL;


