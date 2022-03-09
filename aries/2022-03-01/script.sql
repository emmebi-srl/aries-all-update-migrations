ALTER TABLE `corso`
	CHANGE COLUMN `stato` `stato` TINYINT(4) NOT NULL DEFAULT '1' AFTER `tipo_evento`,
	ADD COLUMN `id_evento_gruppo` INT(11) NULL DEFAULT NULL AFTER `stato`,
	ADD CONSTRAINT `FK_corso_evento_gruppo` FOREIGN KEY (`id_evento_gruppo`) REFERENCES `evento_gruppo` (`Id`) ON UPDATE CASCADE ON DELETE SET NULL;
