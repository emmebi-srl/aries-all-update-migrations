ALTER TABLE `fornitore`
	CHANGE COLUMN `Ragione_Sociale` `Ragione_Sociale` VARCHAR(100) NULL DEFAULT NULL AFTER `Id_fornitore`,
	CHANGE COLUMN `Ragione_Sociale2` `Ragione_Sociale2` VARCHAR(100) NULL DEFAULT NULL AFTER `Ragione_Sociale`;

