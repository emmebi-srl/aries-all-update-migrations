
	
ALTER TABLE `commessa_fattura`
	ALTER `Id_fattura` DROP DEFAULT;
ALTER TABLE `commessa_fattura`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	ADD COLUMN `Id_fattura2` INT(11) NOT NULL AFTER `Id`,
	CHANGE COLUMN `Id_fattura` `Id_fattura` INT(11) NULL AFTER `id_lotto`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`),
	DROP FOREIGN KEY `fattt`;

	
ALTER TABLE `ddt`
	ADD COLUMN `Id_fattura2` INT(11) NULL DEFAULT NULL AFTER `Causale`,
	DROP FOREIGN KEY `fattur`;

ALTER TABLE `fattura_acconto`
	ADD COLUMN `Id_fattura2` INT(11) NOT NULL DEFAULT '0' AFTER `id_acconto`,
	DROP FOREIGN KEY `FK_fattura_acconto_1`;
	
	

ALTER TABLE `fattura_articoli`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	ADD COLUMN `Id_fattura2` INT(11) NOT NULL DEFAULT '0' AFTER `Id`,
	DROP PRIMARY KEY,
	ADD UNIQUE INDEX `id_fattura_Anno_n_tab` (`id_fattura`, `Anno`, `n_tab`),
	ADD PRIMARY KEY (`Id`),
	DROP FOREIGN KEY `fattura_articoli_ibfk_1`;

