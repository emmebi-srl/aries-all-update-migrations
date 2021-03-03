DROP TABLE IF EXISTS evento_file_associati_caldav;
CREATE TABLE `evento_file_associati_caldav` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`file_name` VARCHAR(150) NOT NULL DEFAULT '0',
	`id_evento` INT NOT NULL DEFAULT '0',
	`id_operaio` INT NOT NULL DEFAULT '0',
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`utente_ins` INT NOT NULL DEFAULT '0',
	`utente_mod` INT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	INDEX `file_name` (`file_name`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
