ALTER TABLE `impianto`
	CHANGE COLUMN `centrale` `centrale` VARCHAR(11) NULL DEFAULT NULL AFTER `checklist`,
	CHANGE COLUMN `gsm` `gsm` VARCHAR(11) NULL DEFAULT NULL AFTER `centrale`,
	CHANGE COLUMN `combinatore_telefonico` `combinatore_telefonico` VARCHAR(11) NULL DEFAULT NULL AFTER `gsm`,
	ADD CONSTRAINT `Fk_impianto_combinatore_telefonico` FOREIGN KEY (`combinatore_telefonico`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE `impianto`
	ADD CONSTRAINT `Fk_impianto_gsm` FOREIGN KEY (`gsm`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE SET NULL ON DELETE SET NULL,
	ADD CONSTRAINT `Fk_impianto_centrale` FOREIGN KEY (`centrale`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE SET NULL ON DELETE SET NULL;

	
	INSERT INTO `configurazione_percorsi` VALUES (defaultPATH +CHECKLIST\\{checklist_id}\\FIRME\\', 'CHECKLIST_FIRME');

	ALTER TABLE `checklist`
	ADD COLUMN `filename_firma_cliente` VARCHAR(50) NULL AFTER `appunti`,
	ADD COLUMN `filename_firma_tecnico` VARCHAR(50) NULL AFTER `filename_firma_cliente`;
		
ALTER TABLE `checklist`
	ADD COLUMN `visionata` BIT NOT NULL DEFAULT b'0' AFTER `filename_firma_tecnico`,
	ADD COLUMN `stampata` BIT NOT NULL DEFAULT b'0' AFTER `visionata`,
	ADD COLUMN `inviata` BIT NOT NULL DEFAULT b'0' AFTER `stampata`;

	

	