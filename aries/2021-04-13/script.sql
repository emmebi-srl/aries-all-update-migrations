ALTER TABLE `impianto_componenti_codice`
	ALTER `seriale` DROP DEFAULT;
ALTER TABLE `impianto_componenti_codice`
	CHANGE COLUMN `seriale` `seriale` VARCHAR(150) NOT NULL AFTER `codice`;

SET @USER_ID = (SELECT id_utente FROM utente WHERE Nome = 'admin' LIMIT 1);

CREATE TABLE `magazzino_kit_riferimento` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_operazione_kit` BIGINT(11) NOT NULL,
	`Id_operazione_articolo` BIGINT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_operazione_kit_Id_operazione_articolo` (`Id_operazione_kit`, `Id_operazione_articolo`),
	CONSTRAINT `fk_magazzino_operazione_kit` FOREIGN KEY (`Id_operazione_kit`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `fk_magazzino_operazione_articolo` FOREIGN KEY (`Id_operazione_articolo`) REFERENCES `magazzino_operazione` (`Id_operazione`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
