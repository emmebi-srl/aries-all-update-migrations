CREATE TABLE `commessa_articoli_storico` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_commessa` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	`id_sottocommessa` INT(11) NOT NULL,
	`descrizione` TEXT NULL,
	`quantità` DECIMAL(11,2) NULL DEFAULT NULL,
	`codice_articolo` VARCHAR(16) NULL DEFAULT NULL,
	`codice_fornitore` VARCHAR(40) NULL DEFAULT NULL,
	`UM` VARCHAR(5) NULL DEFAULT NULL,
	`id_tab` INT(11) NOT NULL,
	`economia` DECIMAL(11,2) NULL DEFAULT '0.00',
	`id_lotto` INT(11) NOT NULL DEFAULT '0',
	`prezzo` DECIMAL(11,2) NULL DEFAULT '0.00',
	`costo` DECIMAL(11,2) NULL DEFAULT '0.00',
	`costo_ora` DECIMAL(11,2) NULL DEFAULT '0.00',
	`tempo` INT(11) NULL DEFAULT '0',
	`sconto` DECIMAL(11,2) NULL DEFAULT '0.00',
	`prezzo_ora` DECIMAL(11,2) NULL DEFAULT '0.00',
	`preventivati` DECIMAL(11,2) NULL DEFAULT '0.00',
	`portati` DECIMAL(11,2) NULL DEFAULT '0.00',
	`Lunghezza` INT(11) NULL DEFAULT NULL,
	`iva` INT(11) NULL DEFAULT NULL,
	`id_utente` INT(11) NOT NULL,
	`timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	INDEX `FK__commessa_articoli_storico__articolo` (`codice_articolo`),
	INDEX `FK__commessa_articoli_storico__commessa_articoli` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`, `id_tab`),
	CONSTRAINT `FK__commessa_articoli_storico__articolo` FOREIGN KEY (`codice_articolo`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE CASCADE ON DELETE NO ACTION,
	CONSTRAINT `FK__commessa_articoli_storico__commessa_articoli` FOREIGN KEY (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`, `id_tab`) REFERENCES `commessa_articoli` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`, `id_tab`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=3
;
