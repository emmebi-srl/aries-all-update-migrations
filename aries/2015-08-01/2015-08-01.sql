ALTER TABLE `tablet_configurazione`
	ADD COLUMN `display_name` VARCHAR(30) NULL AFTER `porta`,
	ADD COLUMN `data_ins` VARCHAR(30) NULL AFTER `display_name`,
	ADD COLUMN `data_mod` VARCHAR(30) NULL AFTER `data_ins`;
	
ALTER TABLE `tablet_configurazione`
	CHANGE COLUMN `data_ins` `data_ins` DATETIME NULL DEFAULT NULL AFTER `display_name`,
	CHANGE COLUMN `data_mod` `data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `data_ins`;
	
ALTER TABLE `tablet_configurazione`
ADD COLUMN `username` VARCHAR(50) NOT NULL AFTER `host`,
CHANGE COLUMN `data_mod` `data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `data_ins`;