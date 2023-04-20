ALTER TABLE `tipo_titolo`
	CHANGE COLUMN `nome` `nome` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci' AFTER `id_titolo`;

ALTER TABLE `riferimento_clienti`
	CHANGE COLUMN `titolo` `titolo` VARCHAR(20) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `Promemoria_cliente`;

ALTER TABLE `riferimento_fornitore`
	CHANGE COLUMN `titolo` `titolo` VARCHAR(20) NULL DEFAULT NULL COLLATE 'latin1_swedish_ci' AFTER `nota`;
