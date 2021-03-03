START TRANSACTION; 
UPDATE checklist SET checklist.Descrizione = "" WHERE Descrizione IS NULL; 
UPDATE checklist SET checklist.Note = "" WHERE Note IS NULL; 

ALTER TABLE `checklist`
	ALTER `nome` DROP DEFAULT,
	ALTER `tipo_impianto` DROP DEFAULT,
	ALTER `data_creazione` DROP DEFAULT,
	ALTER `id_utente` DROP DEFAULT,
	ALTER `id_checkprinc` DROP DEFAULT;
ALTER TABLE `checklist`
	CHANGE COLUMN `id_checkprinc` `Id_check_parent` INT(11) NULL AFTER `id_check`,
	CHANGE COLUMN `nome` `nome` VARCHAR(45) NOT NULL AFTER `Id_check_parent`,
	CHANGE COLUMN `descrizione` `descrizione` VARCHAR(300) NOT NULL AFTER `nome`,
	CHANGE COLUMN `note` `note` VARCHAR(200) NOT NULL AFTER `descrizione`,
	CHANGE COLUMN `tipo_impianto` `tipo_impianto` SMALLINT NULL AFTER `note`,
	CHANGE COLUMN `data_creazione` `Data_ins` DATETIME NULL AFTER `tipo_impianto`,
	CHANGE COLUMN `data_ultimo` `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	CHANGE COLUMN `id_utente` `Utente_ins` INT(11) NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` INT(11) NULL DEFAULT NULL AFTER `Utente_ins`,
	DROP INDEX `Index_2`,
	DROP FOREIGN KEY `FK_checklist_1`;

ALTER TABLE `checklist`
	CHANGE COLUMN `Utente_ins` `Utente_ins` SMALLINT NULL DEFAULT NULL AFTER `Data_mod`,
	CHANGE COLUMN `Utente_mod` `Utente_mod` SMALLINT NULL DEFAULT NULL AFTER `Utente_ins`;


ALTER TABLE `checklist_impianto`
	ALTER `id_checklist` DROP DEFAULT;
ALTER TABLE `checklist_impianto`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `id_checklist` `id_checklist` INT(11) NOT NULL AFTER `Id`,
	DROP PRIMARY KEY,
	DROP INDEX `FK_checklist_impianto_1`,
	ADD UNIQUE INDEX `id_checklist_id_impianto` (`id_checklist`, `id_impianto`),
	ADD PRIMARY KEY (`Id`),
	DROP FOREIGN KEY `FK_checklist_impianto_2`,
	DROP FOREIGN KEY `FK_checklist_impianto_1`;

ALTER TABLE `checklist_impianto`
	ADD COLUMN `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `id_impianto`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Data_ins`;

ALTER TABLE `checklist_elemento`
	ALTER `id_paragrafo` DROP DEFAULT,
	ALTER `id_checklist` DROP DEFAULT,
	ALTER `id_elemento` DROP DEFAULT,
	ALTER `posizione` DROP DEFAULT;
ALTER TABLE `checklist_elemento`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `id_paragrafo` `Id_paragrafo` INT(11) NOT NULL AFTER `Id`,
	CHANGE COLUMN `id_checklist` `Id_checklist` INT(11) NOT NULL AFTER `Id_paragrafo`,
	CHANGE COLUMN `id_elemento` `Id_elemento` INT(11) NOT NULL AFTER `Id_checklist`,
	CHANGE COLUMN `posizione` `Posizione` INT(11) NOT NULL AFTER `Id_elemento`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `Posizione`,
	ADD COLUMN `Data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`,
	DROP PRIMARY KEY,
	DROP INDEX `FK_checklist_elemento_1`,
	DROP INDEX `Index_2`,
	ADD PRIMARY KEY (`Id`),
	ADD UNIQUE INDEX `Id_paragrafo_Id_checklist_Id_elemento_Posizione` (`Id_paragrafo`, `Id_checklist`, `Id_elemento`, `Posizione`),
	DROP FOREIGN KEY `FK_checklist_elemento_1`,
	DROP FOREIGN KEY `FK_checklist_elemento_2`;

DROP TABLE IF EXISTS `Tipo_checklist_elemento` ; 
CREATE TABLE `Tipo_checklist_elemento` (
	`Id` TINYINT NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(50) NOT NULL,
	`Descrizione` VARCHAR(100) NULL,
	`RifApplicazioni` VARCHAR(25) NOT NULL,
	INDEX `Id` (`Id`),
	UNIQUE INDEX `Nome` (`Nome`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO Tipo_checklist_elemento (Id, Nome, Descrizione, RifApplicazioni )
VALUES
(1, "NOTA", NULL, "note"), 
(2, "SI-NO-NOTE", NULL, "yes_no"), 
(3, "SI-NO-NA-NOTE", NULL, "yes_no_undefined"), 
(4, "NOTA (NON STAMPABILE)", NULL, "note_not_printable"),
(5, "SUGGERIMENTO", NULL, "suggestion"),
(6, "SI-NO-NA-QTA-TSTD-NOTE", NULL, "yes_no_undefined_qt");




ALTER TABLE `checklist_elemento_generico`
	CHANGE COLUMN `tipo_elemento` `tipo_elemento` INT(11) NOT NULL DEFAULT '1' AFTER `id_elemento`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `indicazioni`,
	ADD COLUMN `Data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`;
	

ALTER TABLE `checklist_elemento_generico`
	ADD UNIQUE INDEX `tipo_elemento_nome_indicazioni` (`tipo_elemento`, `nome`, `indicazioni`);


UPDATE `checklist_paragrafo` SET Ordine = 0 Where Ordine IS NULL;
ALTER TABLE `checklist_paragrafo`
	ALTER `id_paragrafo` DROP DEFAULT,
	ALTER `ordine` DROP DEFAULT;
ALTER TABLE `checklist_paragrafo`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `id_paragrafo` `id_paragrafo` INT(11) NOT NULL AFTER `Id`,
	CHANGE COLUMN `ordine` `ordine` INT(11) NOT NULL AFTER `descrizione`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `ordine`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`,
	DROP PRIMARY KEY,
	DROP INDEX `FK_checklist_paragrafo_1`,
	ADD UNIQUE INDEX `id_paragrafo_id_checklist` (`id_paragrafo`, `id_checklist`),
	ADD PRIMARY KEY (`Id`),
	DROP FOREIGN KEY `FK_checklist_paragrafo_1`;

RENAME TABLE `checklist` TO `checklist_model`;
RENAME TABLE `checklist_paragrafo` TO `checklist_model_paragrafo`;
RENAME TABLE `checklist_impianto` TO `checklist_model_impianto`;
RENAME TABLE `checklist_elemento_generico` TO `checklist_model_elemento_generico`;
RENAME TABLE `checklist_elemento` TO `checklist_model_elemento`;

ALTER TABLE `checklist_model_paragrafo`
	DROP COLUMN `id_paragrafo`,
	DROP INDEX `id_paragrafo_id_checklist`;
	
ALTER TABLE `checklist_model`
	ADD COLUMN `Stato` TINYINT NULL DEFAULT '1' COMMENT '1 = attiva, 2 = modificata, 3 = storicizzata' AFTER `tipo_impianto`;

	
ALTER TABLE `checklist_model_elemento`
	ALTER `Posizione` DROP DEFAULT;
ALTER TABLE `checklist_model_elemento`
	CHANGE COLUMN `Posizione` `Posizione` SMALLINT NOT NULL AFTER `Id_elemento`;
	
	ALTER TABLE `checklist_model_paragrafo`
	ALTER `ordine` DROP DEFAULT;
ALTER TABLE `checklist_model_paragrafo`
	CHANGE COLUMN `ordine` `ordine` SMALLINT NOT NULL AFTER `descrizione`;


COMMIT; 


ALTER TABLE `tipo_impianto`
	CHANGE COLUMN `descrizione` `descrizione` VARCHAR(150) NULL AFTER `nome`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `descrizione`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Utente_mod`;

	
ALTER TABLE `checklist_model`
	ADD INDEX `nome` (`nome`);
	
ALTER TABLE `checklist_model_paragrafo`
	ALTER `nome` DROP DEFAULT;
ALTER TABLE `checklist_model_paragrafo`
	CHANGE COLUMN `nome` `nome` VARCHAR(100) NOT NULL AFTER `id_checklist`;


UPDATE Tipo_iva SET Messaggio = NULL;


ALTER TABLE `dichiarazione_conformita`
	CHANGE COLUMN `copia_e` `copia_e` VARCHAR(90) NULL DEFAULT NULL AFTER `copia`,
	CHANGE COLUMN `schema_e` `schema_e` VARCHAR(100) NULL DEFAULT NULL AFTER `copia_e`;
