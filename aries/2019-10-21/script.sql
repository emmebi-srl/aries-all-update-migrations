ALTER TABLE `ordine_dettaglio`
	ADD COLUMN `id_sottocommessa` INT(11) NULL DEFAULT NULL AFTER `anno_commessa`,
	DROP INDEX `FK_ordine_COM`,
	DROP INDEX `com_ord`;

UPDATE ordine_dettaglio SET id_sottocommessa = 1;