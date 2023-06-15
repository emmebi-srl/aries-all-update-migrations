
INSERT INTO `tipo_evento` (`id_tipo`, `nome`, `colore`, `Id_tipologia`, `Timestamp`) VALUES ('50', 'PROMEMORIA IMPIANTO', 'clSkyBlue', '3', '2020-02-12 07:11:57');

ALTER TABLE `evento`
	CHANGE COLUMN `Id_riferimento` `Id_riferimento` INT(11) NULL DEFAULT NULL AFTER `Descrizione`;

