ALTER TABLE `impianto_componenti_ddt`
	DROP FOREIGN KEY `FK_impianto_componenti_ddt_1`;
ALTER TABLE `impianto_componenti_ddt`
	ADD CONSTRAINT `FK_impianto_componenti_ddt_1` FOREIGN KEY (`id_impianto`, `id_articolo`, `codice`) REFERENCES `impianto_componenti` (`Id_impianto`, `Id_articolo`, `id`) ON UPDATE CASCADE ON DELETE CASCADE;
