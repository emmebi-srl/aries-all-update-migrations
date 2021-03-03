CREATE TABLE `proxies_configurazione` (
	`id` INT NULL,
	`tipo` VARCHAR(20) NULL,
	`base_host` VARCHAR(150) NULL,
	`basic_auth` VARCHAR(200) NULL,
	`timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `proxies_configurazione`
	ALTER `tipo` DROP DEFAULT,
	ALTER `base_host` DROP DEFAULT;
ALTER TABLE `proxies_configurazione`
	CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `tipo` `tipo` VARCHAR(20) NOT NULL AFTER `id`,
	CHANGE COLUMN `base_host` `base_host` VARCHAR(150) NOT NULL AFTER `tipo`,
	ADD PRIMARY KEY (`id`);

	
CREATE TABLE `fattura_ordine_acquisto` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Id_fattura` INT NOT NULL,
	`Anno_fattura` INT NOT NULL,
	`Id_documento` VARCHAR(20) NOT NULL,
	`Data` DATE NOT NULL,
	`Codice_cig` VARCHAR(15) NOT NULL,
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	CONSTRAINT `Fk_fattura_ordine_acquisto_ordine` FOREIGN KEY (`Id_fattura`, `Anno_fattura`) REFERENCES `fattura` (`Id_fattura`, `anno`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


ALTER TABLE `fattura_ordine_acquisto`
	DROP FOREIGN KEY `Fk_fattura_ordine_acquisto_ordine`;
ALTER TABLE `fattura_ordine_acquisto`
	ADD CONSTRAINT `Fk_fattura_ordine_acquisto_ordine` FOREIGN KEY (`Id_fattura`, `Anno_fattura`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE;
