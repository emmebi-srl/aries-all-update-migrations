ALTER TABLE `fornfattura`
	ADD COLUMN `formato_trasmissione` VARCHAR(10) NULL DEFAULT NULL AFTER `aliquota_iva_BTI`,
	ADD COLUMN `progressivo_invio` VARCHAR(10) NULL DEFAULT NULL AFTER `formato_trasmissione`,
	ADD COLUMN `codice_destintario` VARCHAR(10) NULL DEFAULT NULL AFTER `progressivo_invio`,
	ADD COLUMN `pec_destintario` VARCHAR(100) NULL DEFAULT NULL AFTER `codice_destintario`;
ALTER TABLE `tipo_fattura`
	CHANGE COLUMN `tipo_PA` `tipo_PA` VARCHAR(5) NULL DEFAULT NULL COMMENT 'Tipo di fattura elettronica.' AFTER `Descrizione`;
ALTER TABLE `tipo_fattura`
	ADD INDEX `tipo_PA` (`tipo_PA`);
ALTER TABLE `fornfattura`
	ADD COLUMN `tipo_fattura_elettronica` VARCHAR(5) NULL DEFAULT NULL AFTER `pec_destintario`;
	
	
CREATE TABLE `fornfattura_allegati` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_fattura` INT(11) NOT NULL,
	`Anno_fattura` INT(11) NOT NULL,
	`Nome` VARCHAR(150) NOT NULL,
	`Algoritmo` VARCHAR(10) NULL DEFAULT NULL,
	`Formato` VARCHAR(10) NOT NULL,
	`Descrizione` MEDIUMTEXT NULL,
	`File_path` VARCHAR(250) NOT NULL,
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	INDEX `FK_fornfattura_allegati` (`Id_fattura`, `Anno_fattura`),
	CONSTRAINT `FK_fornfattura_allegati` FOREIGN KEY (`Id_fattura`, `Anno_fattura`) REFERENCES `fornfattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE
)
ENGINE=InnoDB
;

