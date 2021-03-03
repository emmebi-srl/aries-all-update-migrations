ALTER TABLE `clienti`
	CHANGE COLUMN `Partita_iva` `Partita_iva` VARCHAR(12) NULL DEFAULT NULL AFTER `Ragione_sociale2`;


ALTER TABLE `checklist`
	ADD COLUMN `numero_visita` TINYINT NOT NULL AFTER `timestamp_creazione`,
	ADD COLUMN `controllo_periodico` TINYINT NULL AFTER `numero_visita`,
	ADD COLUMN `altro` TEXT NULL AFTER `controllo_periodico`,
	ADD COLUMN `responsabile_lavoro` VARCHAR(150) NULL AFTER `altro`,
	ADD COLUMN `appunti` MEDIUMTEXT NULL AFTER `responsabile_lavoro`;
