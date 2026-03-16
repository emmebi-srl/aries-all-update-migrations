CREATE TABLE `resource_access_code` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`tipo_risorsa` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`id_risorsa` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`hash_codice` VARCHAR(255) NOT NULL COLLATE 'latin1_swedish_ci',
	`attivo` BIT(1) NOT NULL DEFAULT b'1',
	`data_scadenza` DATETIME NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	`data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `UX_resource_access_code_hash_codice` (`hash_codice`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

ALTER TABLE `campagna_aries_mail`
	ADD COLUMN `letto` BIT(1) NOT NULL DEFAULT b'0' AFTER `processato`,
	ADD COLUMN `interagito` BIT(1) NOT NULL DEFAULT b'0' AFTER `letto`,
	ADD COLUMN `campagna_aries_mail` VARCHAR(150) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `interagito`;
