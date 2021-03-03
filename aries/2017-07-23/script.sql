ALTER TABLE `tipo_checklist_elemento`
	DROP INDEX `Id`,
	ADD PRIMARY KEY (`Id`);


	
DELETE FROM checklist_model_elemento_generico;
DELETE FROM checklist_model_elemento; 
DELETE FROM tipo_checklist_elemento; 
INSERT INTO tipo_checklist_elemento (Id, nome, RifApplicazioni) VALUEs
(1, "SI-NO", "toggle_confirm"), 
(2, "SI-NO-NA", "toggle_null_confirm"), 
(3, "NOTE", "notes"), 
(4, "TITOLO SOTTOPARAGRAFO", "header"), 
(5, "INFO CENTRALE", "central_info"), 
(6, "MASTER SLAVE", "master_slave"), 
(7, "SPECIFICHE BATTERIA", "battery_spec"), 
(8, "MISURE STRUMENTALI", "instrumental_measures"), 
(9, "ALIMENTATORE", "power_supply"),  
(10, "SISTEMA ASPIRAZIONE", "suction_system"), 
(11, "DATA e NOTE", "date_notes"),  
(12, "INFO REGISTRATORE", "recorder_info"); 


DELETE FROM checklist_model_elemento_generico;
DELETE FROM checklist_model_elemento;
DELETE FROM checklist_model_paragrafo; 
DELETE FROM checklist_model;

ALTER TABLE `checklist_model_elemento`
ALTER `Id_elemento` DROP DEFAULT;
ALTER TABLE `checklist_model_elemento`
	ADD COLUMN `tipo_elemento` TINYINT(4) NOT NULL AFTER `Posizione`,
	ADD COLUMN `nome` VARCHAR(45) NOT NULL AFTER `tipo_elemento`,
	ADD COLUMN `descrizione` TEXT NOT NULL AFTER `nome`,
	ADD COLUMN `indicazioni` VARCHAR(500) NOT NULL AFTER `descrizione`,
	CHANGE COLUMN `Id_elemento` `Id_elemento` INT(11) NULL AFTER `indicazioni`,
	DROP INDEX `Id_paragrafo_Id_checklist_Id_elemento_Posizione`,
	ADD UNIQUE INDEX `Id_paragrafo_Id_checklist_Id_elemento_Posizione` (`Id_paragrafo`, `Id_checklist`, `Posizione`),
	ADD CONSTRAINT `FK_checklist_model_elemento_tipo` FOREIGN KEY (`tipo_elemento`) REFERENCES `tipo_checklist_elemento` (`Id`),
	ADD CONSTRAINT `FK_cjecklist_model_elemento_elemento_generico` FOREIGN KEY (`Id_elemento`) REFERENCES `checklist_model_elemento_generico` (`id_elemento`);
 