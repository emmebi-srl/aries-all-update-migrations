ALTER TABLE `commessa_articoli`
	ADD COLUMN `portati` DECIMAL(11,2) NULL DEFAULT '0.00' AFTER `preventivati`;
