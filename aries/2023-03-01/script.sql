ALTER TABLE `articolo`
	ADD COLUMN `scaffaliera_magazzino` VARCHAR(50) NULL DEFAULT NULL AFTER `is_kit`,
	ADD COLUMN `ripiano_magazzino` VARCHAR(50) NULL DEFAULT NULL AFTER `scaffaliera_magazzino`,
	ADD COLUMN `descrizione_posizione_magazzino` VARCHAR(255) NULL DEFAULT NULL AFTER `ripiano_magazzino`;
