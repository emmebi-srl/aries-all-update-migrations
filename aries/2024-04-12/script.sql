DELETE fattura_studi FROM fattura_studi
LEFT JOIN fattura ON fattura_studi.id_fattura = fattura.Id_fattura AND fattura_studi.anno = fattura.anno
WHERE fattura.id IS NULL;

DELETE fattura_studi FROM fattura_studi
LEFT JOIN tipo_fattura ON fattura_studi.tipo_fattura = tipo_fattura.id_tipo
WHERE tipo_fattura.id_tipo IS NULL;

DELETE fattura_studi FROM fattura_studi
LEFT JOIN tipo_impianto ON fattura_studi.tipo_impianto = tipo_impianto.id_tipo
WHERE tipo_impianto.id_tipo IS NULL;

ALTER TABLE `fattura_studi`
	ADD CONSTRAINT `FK_fattura_studi_fattura` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fattura_studi_tipo_fattura` FOREIGN KEY (`tipo_fattura`) REFERENCES `tipo_fattura` (`id_tipo`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fattura_studi_tipo_impianto` FOREIGN KEY (`tipo_impianto`) REFERENCES `tipo_impianto` (`id_tipo`) ON UPDATE CASCADE ON DELETE RESTRICT;
