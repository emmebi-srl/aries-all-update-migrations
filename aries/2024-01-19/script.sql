INSERT INTO stato_dpi (`id_stato`, `descrizione`, `nome`) VALUES ('3', 'Non più in uso', 'DISUSO');

ALTER TABLE `operaio_dpi`
	ADD COLUMN `data_scadenza` DATE NULL DEFAULT NULL AFTER `firma`,
	ADD COLUMN `id_evento_scadenza` INT(10) UNSIGNED NULL DEFAULT NULL AFTER `data_scadenza`,
	ADD COLUMN `data_promemoria` DATE NULL DEFAULT NULL AFTER `id_evento_scadenza`,
	ADD COLUMN `id_evento_promemoria` INT(10) UNSIGNED NULL DEFAULT NULL AFTER `data_promemoria`,
	ADD CONSTRAINT `FK_operatio_dpi_evento_scadenza` FOREIGN KEY (`id_evento_scadenza`) REFERENCES `evento` (`Id`) ON UPDATE NO ACTION ON DELETE SET NULL,
	ADD CONSTRAINT `FK_operatio_dpi_evento_promemoria` FOREIGN KEY (`id_evento_promemoria`) REFERENCES `evento` (`Id`) ON UPDATE NO ACTION ON DELETE SET NULL;

INSERT INTO `tipo_evento` (id_tipo, `nome`, `colore`, `Id_tipologia`, `Timestamp`) VALUES (70, 'PROMEMORIA DPI', '$009BFF87', '4', '2024-01-12 07:11:57');
