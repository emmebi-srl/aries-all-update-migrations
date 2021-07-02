CREATE TABLE `storico_download_file` (
	`id_storico_download_file` INT(11) NOT NULL AUTO_INCREMENT,
	`id_utente` INT(11) NOT NULL,
	`id_operaio` INT(11) NULL DEFAULT NULL,
	`rif_applicazione` VARCHAR(50) NOT NULL,
	`file_path` VARCHAR(500) NOT NULL,
	`file_name` VARCHAR(100) NOT NULL,
	`download_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_storico_download_file`),
	INDEX `FK__storico_download_file__utente` (`id_utente`),
	INDEX `FK__storico_download_file__operaio` (`id_operaio`),
	CONSTRAINT `FK__storico_download_file__utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE,
	CONSTRAINT `FK__storico_download_file__operaio` FOREIGN KEY (`id_operaio`) REFERENCES `operaio` (`Id_operaio`) ON UPDATE CASCADE
)
ENGINE=InnoDB
;
