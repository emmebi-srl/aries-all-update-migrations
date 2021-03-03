CREATE TABLE `rapporto_allegati` (
	`id` INT(11) NOT NULL,
	`id_rapporto` BIGINT(20) NOT NULL,
	`anno_rapporto` INT(11) NOT NULL,
	`file_path` VARCHAR(500) NOT NULL,
	`file_name` VARCHAR(150) NOT NULL,
	`timestamp` TIMESTAMP NULL DEFAULT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `file_path` (`file_path`),
	INDEX `fk_rapporto_rapporto_allegati` (`id_rapporto`, `anno_rapporto`),
	CONSTRAINT `fk_rapporto_rapporto_allegati` FOREIGN KEY (`id_rapporto`, `anno_rapporto`) REFERENCES `rapporto` (`Id_rapporto`, `Anno`)
)
ENGINE=InnoDB
;