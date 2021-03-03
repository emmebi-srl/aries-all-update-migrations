ALTER TABLE `commessa_articolo_comp`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL DEFAULT '1' AFTER `id_commessa`;
ALTER TABLE `commessa_articolo_comp`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id_forfait`, `id_dettaglio`, `anno`, `id_commessa`, `lotto`, `id_sottocommessa`) USING BTREE;

ALTER TABLE `commessa_articolo_comp`
	DROP FOREIGN KEY `forf<`;
ALTER TABLE `commessa_articolo_comp`
	DROP INDEX `det`,
	DROP INDEX `forf<`,
	DROP INDEX `forf`,
	DROP INDEX `com_lot`;


ALTER TABLE `commessa_articolo_comp`
	DROP INDEX `det`,
	DROP INDEX `forf`,
	DROP INDEX `com_lot`;

	
ALTER TABLE commessa_articolo_comp
	ADD CONSTRAINT `FK_commessa_articolo_comp_commessa_lotto` FOREIGN KEY (`id_commessa`, `id_sottocommessa`, `anno`, `lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `id_sottocommessa`, `anno`, `id_lotto`) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE commessa_articolo_comp
	ADD CONSTRAINT `FK_commessa_articolo_comp_commessa_articolo` FOREIGN KEY (`id_commessa`,`anno`,  `id_sottocommessa`, `id_dettaglio`, `lotto`) REFERENCES `commessa_articoli` (`id_commessa`, `anno`, `id_sottocommessa`, `id_tab`, `id_lotto`) ON UPDATE CASCADE ON DELETE CASCADE;
