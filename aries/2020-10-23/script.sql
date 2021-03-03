
ALTER TABLE `cliente_promemoria_configurazione_generale`
	ADD COLUMN `Sms_endpoint` VARCHAR(150) NOT NULL DEFAULT '' AFTER `Sms_host`,
	ADD COLUMN `Sms_password` VARCHAR(150) NOT NULL DEFAULT '' AFTER `Sms_endpoint`;
