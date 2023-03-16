ALTER TABLE `tipo_titolo`
	CHANGE COLUMN `nome` `nome` VARCHAR(20) NOT NULL COLLATE 'latin1_swedish_ci' AFTER `id_titolo`;
