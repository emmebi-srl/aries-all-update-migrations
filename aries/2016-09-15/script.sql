ALTER TABLE `riferimento_clienti`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `Id` (`Id`);

	
ALTER TABLE `mail_gruppo_inviate`
	ADD COLUMN `Codice_errore` INT(11) NULL DEFAULT NULL AFTER `stato`,
	ADD COLUMN `Messaggio_errore` VARCHAR(250) NULL DEFAULT NULL AFTER `Codice_errore`,
	ADD COLUMN `Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Messaggio_errore`;
	
UPDATE mail_gruppo_inviate
SET Timestamp = NOW();


