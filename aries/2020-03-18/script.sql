ALTER TABLE `magazzino`
	ADD COLUMN `data_ultimo_movimento` DATETIME NOT NULL AFTER `tipo_magazzino`;

UPDATE magazzino SET data_ultimo_movimento = Data_mod;