ALTER TABLE `province`
	CHANGE COLUMN `Sigla` `Sigla` VARCHAR(15) NOT NULL DEFAULT '' AFTER `id_provincia`;
ALTER TABLE `comune`
	ALTER `provincia` DROP DEFAULT;
ALTER TABLE `comune`
	CHANGE COLUMN `provincia` `provincia` VARCHAR(15) NOT NULL AFTER `Nome`;
ALTER TABLE `tipo_iva`
	ALTER `aliquota` DROP DEFAULT;
ALTER TABLE `tipo_iva`
	CHANGE COLUMN `aliquota` `aliquota` INT(11) NOT NULL AFTER `Descrizione`;
ALTER TABLE `ddt`
	ADD COLUMN `stampa_data_ora_ritiro` BIT NULL DEFAULT NULL AFTER `stampa_ora`;
