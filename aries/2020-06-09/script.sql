ALTER TABLE `clienti`
	ALTER `Ragione_Sociale` DROP DEFAULT;
ALTER TABLE `clienti`
	CHANGE COLUMN `Ragione_Sociale` `Ragione_Sociale` VARCHAR(100) NOT NULL AFTER `Id_cliente`;
