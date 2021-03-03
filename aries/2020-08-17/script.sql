CREATE TABLE `preventivo_lotto_pdf` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_preventivo` INT(11) NOT NULL,
	`id_revisione` INT(11) NOT NULL,
	`anno` INT(11) NOT NULL,
	`posizione_lotto` INT(11) NOT NULL,
	`posizione` INT(11) NOT NULL,
	`filepath` MEDIUMTEXT NOT NULL,
	`filename` VARCHAR(250) NOT NULL,
	`utente_mod` INT(11) NULL DEFAULT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_preventivo_id_revisione_anno_posizione_lotto_posizione` (`id_preventivo`, `id_revisione`, `anno`, `posizione_lotto`, `posizione`),
	INDEX `FK_preventivo_lotto_pdf_utente` (`utente_mod`),
	CONSTRAINT `FK_preventivo_lotto_pdf_utente` FOREIGN KEY (`utente_mod`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT `FK_preventivo_lotto_preventivo_lotto_preventivo_lotto_pdf` FOREIGN KEY (`id_preventivo`, `id_revisione`, `anno`, `posizione_lotto`) REFERENCES `preventivo_lotto` (`id_preventivo`, `id_revisione`, `anno`, `posizione`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE `preventivo_lotto_pdf_posizione` (
	`id_posizione` INT(11) NOT NULL,
	`nome` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id_posizione`),
	UNIQUE INDEX `nome` (`nome`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


INSERT INTO preventivo_lotto_pdf_posizione VALUES
	(1, 'Inizio'),
	(2, 'Fine');
