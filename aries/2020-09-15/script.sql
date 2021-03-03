ALTER TABLE `articoli_ddt`
	ADD COLUMN `id_commessa` INT(11) NULL DEFAULT NULL AFTER `economia`,
	ADD COLUMN `anno_commessa` INT(11) NULL DEFAULT NULL AFTER `id_commessa`,
	ADD COLUMN `id_sottocommessa` INT(11) NULL DEFAULT NULL AFTER `anno_commessa`,
	ADD COLUMN `id_lotto_commessa` INT(11) NULL DEFAULT NULL AFTER `id_sottocommessa`,
	ADD COLUMN `id_tab_commessa` INT(11) NULL DEFAULT NULL AFTER `id_lotto_commessa`,
	ADD COLUMN `sostituzione` BIT NULL DEFAULT NULL AFTER `id_tab_commessa`,
	ADD COLUMN `codice_articolo_sostituzione` VARCHAR(11) NULL DEFAULT NULL AFTER `sostituzione`,
	ADD COLUMN `id_tab_sostituzione` INT(11) NULL DEFAULT NULL AFTER `codice_articolo_sostituzione`,
	ADD CONSTRAINT `articoli_articoli_comm_sostuzione` FOREIGN KEY (`id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto_commessa`, `id_tab_commessa`) REFERENCES `commessa_articoli` (`id_commessa`, `anno`, `id_sottocommessa`,  `id_lotto`, `id_tab`) ON UPDATE CASCADE ON DELETE SET NULL;

