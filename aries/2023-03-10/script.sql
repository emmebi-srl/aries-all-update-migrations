ALTER TABLE `articolo_operazione`
	DROP FOREIGN KEY `oper_art`;
ALTER TABLE `articolo_operazione`
	ADD CONSTRAINT `FK_articolo_operazione_articolo` FOREIGN KEY (`id_articolo`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE `riferimento_kit_articoli`
	ADD CONSTRAINT `FK_referimento_kit_articoli_kit` FOREIGN KEY (`id_kit`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_referimento_kit_articoli_componente` FOREIGN KEY (`id_articolo`) REFERENCES `articolo` (`Codice_articolo`) ON UPDATE CASCADE ON DELETE RESTRICT;
