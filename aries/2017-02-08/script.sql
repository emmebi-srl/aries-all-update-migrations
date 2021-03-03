ALTER TABLE `rapporto_materiale`
	ALTER `tipo` DROP DEFAULT;
ALTER TABLE `rapporto_materiale`
	CHANGE COLUMN `tipo` `tipo` VARCHAR(2) NOT NULL AFTER `id_tab`;
