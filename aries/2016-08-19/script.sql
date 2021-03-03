RENAME TABLE `impianto_cliente` TO `impianto_cliente_storico`;

CREATE TABLE `impianto_cliente` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Id_impianto` INT NOT NULL,
	`Id_cliente` INT NOT NULL,
	`Id_impianto_figura` INT NOT NULL,
	`Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_ins` INT NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_impianto_Id_cliente_Id_impianto_figura` (`Id_impianto`, `Id_cliente`, `Id_impianto_figura`),
	CONSTRAINT `fk-impianto_cliente-clienti` FOREIGN KEY (`Id_cliente`) REFERENCES `clienti` (`Id_cliente`),
	CONSTRAINT `fk-impianto_cliente-impianto` FOREIGN KEY (`Id_impianto`) REFERENCES `impianto` (`Id_impianto`),
	CONSTRAINT `fk-impainto_cliente-impianto_figura` FOREIGN KEY (`Id_impianto_figura`) REFERENCES `impianto_figura` (`Id_figura`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
