CREATE TABLE `stato_ddt` (
	`Id_stato` INT(11) NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(30) NOT NULL,
	`Descrizione` VARCHAR(200) NULL DEFAULT NULL,
	PRIMARY KEY (`Id_stato`),
	UNIQUE INDEX `Nome` (`Nome`)
) ENGINE = InnoDB;
