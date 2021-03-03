ALTER TABLE `tipo_utente_permessi`
	CHANGE COLUMN `firme` `firme` TINYINT(4) NOT NULL DEFAULT '0' AFTER `totali`;
