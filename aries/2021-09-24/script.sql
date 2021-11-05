CREATE TABLE `tag` (
	`id_tag` INT(11) NOT NULL AUTO_INCREMENT,
	`tag` VARCHAR(50) NOT NULL DEFAULT '',
	`tipo_documento` INT(11) NOT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	`utente_mod` INT(11) NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_tag`),
	INDEX `FK_tag_utente_mod` (`utente_mod`),
	INDEX `FK_tag_utente_ins` (`utente_ins`),
	INDEX `fk_tag_tipo_documento` (`tipo_documento`),
	CONSTRAINT `fk_tag_tipo_documento` FOREIGN KEY (`tipo_documento`) REFERENCES `tipo_documento` (`Id_tipo`),
	CONSTRAINT `FK_tag_utente_ins` FOREIGN KEY (`utente_ins`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT `FK_tag_utente_mod` FOREIGN KEY (`utente_mod`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE `ticket_tag` (
	`id_ticket` INT(11) NOT NULL,
	`anno_ticket` INT(11) NOT NULL,
	`id_tag` INT(11) NOT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_ticket`, `anno_ticket`, `id_tag`),
	INDEX `FK_ticket_tag_tag` (`id_tag`),
	INDEX `FK_ticket_tag_ticket` (`id_ticket`, `anno_ticket`),
	INDEX `FK_tag_utente_ins` (`utente_ins`),
	CONSTRAINT `FK_ticket_tag_tag` FOREIGN KEY (`id_tag`) REFERENCES `tag` (`id_tag`) ON UPDATE CASCADE,
	CONSTRAINT `FK_ticket_tag_ticket` FOREIGN KEY (`id_ticket`, `anno_ticket`) REFERENCES `ticket` (`Id_ticket`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_ticket_tag_utente_ins` FOREIGN KEY (`utente_ins`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE `fattura_tag` (
	`id_fattura` INT(11) NOT NULL,
	`anno_fattura` INT(11) NOT NULL,
	`id_tag` INT(11) NOT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_fattura`, `anno_fattura`, `id_tag`),
	INDEX `FK_fattura_tag_tag` (`id_tag`),
	INDEX `FK_fattura_tag_fattura` (`id_fattura`, `anno_fattura`),
	INDEX `FK_fattura_tag_utente_ins` (`utente_ins`),
	CONSTRAINT `FK_fattura_tag_tag` FOREIGN KEY (`id_tag`) REFERENCES `tag` (`id_tag`) ON UPDATE CASCADE,
	CONSTRAINT `FK_fattura_tag_fattura` FOREIGN KEY (`id_fattura`, `anno_fattura`) REFERENCES `fattura` (`id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_fattura_tag_utente_ins` FOREIGN KEY (`utente_ins`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


CREATE TABLE `cliente_tag` (
	`id_cliente` INT(11) NOT NULL,
	`id_tag` INT(11) NOT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id_cliente`, `id_tag`),
	INDEX `FK_cliente_tag_tag` (`id_tag`),
	INDEX `FK_cliente_tag_cliente` (`id_cliente`),
	INDEX `FK_cliente_tag_utente_ins` (`utente_ins`),
	CONSTRAINT `FK_cliente_tag_tag` FOREIGN KEY (`id_tag`) REFERENCES `tag` (`id_tag`) ON UPDATE CASCADE,
	CONSTRAINT `FK_cliente_tag_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clienti` (`id_cliente`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_cliente_tag_utente_ins` FOREIGN KEY (`utente_ins`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


ALTER TABLE `tag`
	ADD UNIQUE INDEX `tag_tipo_documento` (`tag`, `tipo_documento`);
