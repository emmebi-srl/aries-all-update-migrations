ALTER TABLE `tariffario`
	ALTER `descrizione` DROP DEFAULT;
ALTER TABLE `tariffario`
	CHANGE COLUMN `descrizione` `descrizione` VARCHAR(200) NULL AFTER `Nome`;