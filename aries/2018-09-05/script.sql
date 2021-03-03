CREATE TABLE `utente_roles` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(50) NULL DEFAULT NULL,
	`descrizione` TEXT NULL,
	`app_name` VARCHAR(50) NULL DEFAULT NULL,
	`timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`)
)
ENGINE=InnoDB
;
INSERT INTO `utente_roles` (id, `nome`, `descrizione`, `app_name`) VALUES (1, 'Mobile Administrator', 'Questa role da la possibilità all\'utente di accedere all area admin di Aries Mobile senza dover inserire la password.', 'aries_mobile_admin');

CREATE TABLE `utente_utente_roles` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_utente` INT(11) NOT NULL DEFAULT '0',
	`id_utente_roles` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_utente_id_utente_roles` (`id_utente`, `id_utente_roles`),
	INDEX `FK_utente_utente_roles_id_ut_ro` (`id_utente_roles`),
	CONSTRAINT `FK_utente_utente_roles_id_ut` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_utente_utente_roles_id_ut_ro` FOREIGN KEY (`id_utente_roles`) REFERENCES `utente_roles` (`id`)
)
ENGINE=InnoDB
;
