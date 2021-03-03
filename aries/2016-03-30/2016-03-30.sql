ALTER TABLE `mail_gruppo_inviate_fornitore`
	ALTER `id_mail` DROP DEFAULT;
ALTER TABLE `mail_gruppo_inviate_fornitore`
	CHANGE COLUMN `id_mail` `id_mail` INT NOT NULL FIRST,
	DROP FOREIGN KEY `mail_id`;

ALTER TABLE `mail_gruppo_inviate`
	ALTER `id_mail` DROP DEFAULT;
ALTER TABLE `mail_gruppo_inviate`
	CHANGE COLUMN `id_mail` `id_mail` INT NOT NULL FIRST,
	DROP FOREIGN KEY `FK_mail_gruppo_inviate_2`;

ALTER TABLE `mail_scheduler`
	ALTER `id_schedulazione` DROP DEFAULT;
ALTER TABLE `mail_scheduler`
	CHANGE COLUMN `id_schedulazione` `id_schedulazione` INT NOT NULL FIRST,
	DROP FOREIGN KEY `mail`;

Update mail set  ID_utente = 10 WHERE id_utente IS NULL; 
ALTER TABLE `mail`
	DROP FOREIGN KEY `FK_mail_3`,
	DROP FOREIGN KEY `GRUPPO`,
	DROP FOREIGN KEY `mitt`;
ALTER TABLE `mail`
	ALTER `mittente` DROP DEFAULT,
	ALTER `Oggetto` DROP DEFAULT,
	ALTER `data_ora_sped` DROP DEFAULT,
	ALTER `id_utente` DROP DEFAULT;
ALTER TABLE `mail`
	CHANGE COLUMN `id_mail` `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	CHANGE COLUMN `mittente` `Id_mittente` INT(11) NOT NULL COMMENT 'Corrisponde all\'id_utente con cui viene fatto l invio della email' AFTER `Id`,
	CHANGE COLUMN `destinatari_cc` `Destinatari_cc` VARCHAR(500) NULL AFTER `Id_mittente`,
	CHANGE COLUMN `destinatario` `Destinatari_ccn` VARCHAR(500) NULL AFTER `Destinatari_cc`,
	CHANGE COLUMN `Oggetto` `Oggetto` VARCHAR(100) NOT NULL AFTER `Destinatari_ccn`,
	CHANGE COLUMN `stato` `Id_stato` INT(11) NULL DEFAULT NULL AFTER `Corpo`,
	CHANGE COLUMN `id_risposta` `Id_risposta` INT NULL DEFAULT NULL AFTER `Id_stato`,
	CHANGE COLUMN `gruppo` `Id_gruppo` INT(11) NULL DEFAULT NULL AFTER `Id_risposta`,
	CHANGE COLUMN `tipo` `Tipo` VARCHAR(15) NULL DEFAULT '1' AFTER `Id_gruppo`,
	CHANGE COLUMN `id_doc` `Id_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `Tipo`,
	CHANGE COLUMN `anno_doc` `Anno_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `Id_documento`,
	CHANGE COLUMN `rev_doc` `Revisione_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `Anno_documento`,
	CHANGE COLUMN `tipo_doc` `Tipo_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `Revisione_documento`,
	CHANGE COLUMN `tentativo` `Tentativo` TINYINT NOT NULL DEFAULT '0' AFTER `Tipo_documento`,
	CHANGE COLUMN `data_ora_sped` `Data_invio` DATETIME NOT NULL AFTER `Tentativo`,
	CHANGE COLUMN `letto` `Letto` TINYINT(1) UNSIGNED NULL DEFAULT '0' AFTER `Data_invio`,
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `Letto`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	CHANGE COLUMN `id_utente` `Utente_ins` SMALLINT UNSIGNED NOT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT UNSIGNED NULL DEFAULT NULL AFTER `Utente_ins`,
	ADD CONSTRAINT `FK_mail_mail_stato` FOREIGN KEY (`Id_stato`) REFERENCES `mail_stato` (`id_Stato`) ON UPDATE CASCADE ON DELETE NO ACTION,
	ADD CONSTRAINT `FK_mail_mail_gruppo` FOREIGN KEY (`Id_gruppo`) REFERENCES `mail_gruppo` (`id_gruppo`) ON UPDATE CASCADE ON DELETE NO ACTION,
	ADD CONSTRAINT `FK_mail_id_mittente_utente` FOREIGN KEY (`Id_mittente`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE NO ACTION;


Update mail set  Corpo= "" WHERE Corpo IS NULL; 

ALTER TABLE `mail`
	ALTER `Id_stato` DROP DEFAULT;
ALTER TABLE `mail`
	CHANGE COLUMN `Corpo` `Corpo` TEXT NOT NULL AFTER `Oggetto`,
	CHANGE COLUMN `Id_stato` `Id_stato` INT(11) NOT NULL AFTER `Corpo`,
	CHANGE COLUMN `Letto` `Letto` BIT NOT NULL DEFAULT b'0' AFTER `Data_invio`;
	
ALTER TABLE `mail`
	ADD COLUMN `Pec` BIT NOT NULL DEFAULT b'0' AFTER `Corpo`;

ALTER TABLE `mail`
	ADD COLUMN `Id_stato_errore` MEDIUMINT NULL AFTER `Letto`,
	ADD COLUMN `Messaggio_errore` MEDIUMINT NULL AFTER `Id_stato_errore`;
	
ALTER TABLE `mail`
	CHANGE COLUMN `Messaggio_errore` `Messaggio_errore` VARCHAR(500) NULL DEFAULT NULL AFTER `Id_stato_errore`;

ALTER TABLE `mail`
	CHANGE COLUMN `Tipo_documento` `Tipo_documento` VARCHAR(30) NULL DEFAULT NULL AFTER `Revisione_documento`;
