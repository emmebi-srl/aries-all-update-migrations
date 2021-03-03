ALTER TABLE `ddt`
	CHANGE COLUMN `Causale` `Causale` VARCHAR(8) NULL DEFAULT NULL AFTER `trasport_a_cura`;

ALTER TABLE `ddt_ricevuti`
	CHANGE COLUMN `Causale` `Causale` VARCHAR(8) NULL DEFAULT NULL AFTER `trasport_a_cura`;


ALTER TABLE `rapporto_mobile_collaudo`
	ADD COLUMN `Email_responsabile` VARCHAR(35) NULL DEFAULT NULL AFTER `Email`;