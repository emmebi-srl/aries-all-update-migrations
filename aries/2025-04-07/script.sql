ALTER TABLE `tipo_natura_iva`
	ADD COLUMN `messaggio_fattura` TEXT NOT NULL AFTER `tipo_PA`;


INSERT INTO `tab_tipo` (`nome`, `descrizione`, `tipo_ins`) VALUES ('tipo_natura_iva', 'Tipologia Natura IVA', 25);
UPDATE `tab_tipo` SET `descrizione`='Tipologia Costo di Produzione' WHERE  `nome`='tipo_costo_produzione';

ALTER TABLE `tab_tipo`
	ADD UNIQUE INDEX `nome` (`nome`);
ALTER TABLE `tipo_natura_iva`
	CHANGE COLUMN `messaggio_fattura` `nota_fattura` TEXT NOT NULL COLLATE 'latin1_swedish_ci' AFTER `tipo_PA`;
