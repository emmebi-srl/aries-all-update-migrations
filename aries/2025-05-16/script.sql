CREATE TABLE `ticket_allegati` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_ticket` INT(11) NOT NULL,
	`anno_ticket` INT(11) NOT NULL,
	`file_path` VARCHAR(500) NOT NULL COLLATE 'latin1_swedish_ci',
	`file_name` VARCHAR(150) NOT NULL COLLATE 'latin1_swedish_ci',
	`timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `file_path` (`file_path`) USING BTREE,
	INDEX `fk_ticket_ticket_allegati` (`id_ticket`, `anno_ticket`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


ALTER TABLE `ticket_allegati`
	DROP INDEX `fk_ticket_ticket_allegati`,
	ADD CONSTRAINT `FK_ticket_allegati_ticket` FOREIGN KEY (`id_ticket`, `anno_ticket`) REFERENCES `ticket` (`Id_ticket`, `anno`) ON UPDATE CASCADE ON DELETE NO ACTION;

INSERT INTO  `configurazione_percorsi` (`Percorso`, `Tipo_percorso`) VALUES ('C:\\Users\\MARIO\\Documents\\Default\\TICKET\\{ticket_year}\\{ticket_id}\\ALLEGATI\\', 'TICKET_ALLEGATI');
