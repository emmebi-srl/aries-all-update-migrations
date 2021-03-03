ALTER TABLE `rapporto_mobile`
	ALTER `luogo_lavoro` DROP DEFAULT;
ALTER TABLE `rapporto_mobile`
	CHANGE COLUMN `luogo_lavoro` `luogo_lavoro` VARCHAR(255) NOT NULL AFTER `citta`;
	
	ALTER TABLE `evento`
	ADD COLUMN `Eliminato` BIT NULL DEFAULT b'0' AFTER `Data_notifica`;
