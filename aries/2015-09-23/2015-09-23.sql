INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`) VALUES (25, 'INSOLVENTI', 3);

ALTER TABLE `rapporto_mobile_materiale`
	CHANGE COLUMN `descrizione` `descrizione` VARCHAR(50) NOT NULL DEFAULT '' AFTER `codice_articolo`;
