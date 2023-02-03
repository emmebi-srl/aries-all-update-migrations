UPDATE revisione_preventivo
LEFT JOIN abbonamento ON revisione_preventivo.tariffa = abbonamento.Id_abbonamento
SET tariffa = (SELECT id_abbonamento FROM abbonamento WHERE revisione_preventivo.anno = abbonamento.anno LIMIT 1)
WHERE abbonamento.id_abbonamento IS NULL;


ALTER TABLE `revisione_preventivo`
	CHANGE COLUMN `tariffa` `tariffa` INT(11) NULL COMMENT 'Id abbonamento' AFTER `nota`,
	ADD CONSTRAINT `FK_revisione_preventivo_abbonamento` FOREIGN KEY (`tariffa`) REFERENCES `abbonamento` (`Id_abbonamento`) ON UPDATE CASCADE ON DELETE RESTRICT;