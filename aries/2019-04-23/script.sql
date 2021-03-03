

UPDATE configurazione_percorsi SET Percorso = REPLACE(Percorso, '{checklist_id}', '{system_id}\\{checklist_id}') WHERE Tipo_percorso = 'CHECKLIST_FIRME';

ALTER TABLE `fattura_totali_iva`
	DROP FOREIGN KEY `fk_fattura_totali_fattura`;
ALTER TABLE `fattura_totali_iva`
	ADD CONSTRAINT `fk_fattura_totali_fattura` FOREIGN KEY (`id_fattura`, `anno`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE;
