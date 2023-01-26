ALTER TABLE `servizio_alert_esecuzione`
	ADD COLUMN `Errore` MEDIUMTEXT NULL AFTER `Filename`;


DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGetBySystemId;