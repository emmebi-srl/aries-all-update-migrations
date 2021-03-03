
ALTER TABLE `impianto_componenti`
	ADD COLUMN `id_versione` INT(11) NULL DEFAULT NULL AFTER `tipo_evento`;


ALTER TABLE `impianto_componenti_versione`
	CHANGE COLUMN `id_versione` `id_versione` INT(11) NOT NULL AUTO_INCREMENT FIRST;

ALTER TABLE `impianto_componenti`
	ADD CONSTRAINT `fk_impianto_componenti_versione` FOREIGN KEY (`id_versione`) REFERENCES `impianto_componenti_versione` (`id_versione`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `impianto_componenti`
	DROP FOREIGN KEY `fk_impianto_componenti_versione`;
ALTER TABLE `impianto_componenti`
	ADD CONSTRAINT `fk_impianto_componenti_versione` FOREIGN KEY (`id_versione`) REFERENCES `impianto_componenti_versione` (`id_versione`) ON UPDATE CASCADE ON DELETE NO ACTION;
