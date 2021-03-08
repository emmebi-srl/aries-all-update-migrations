ALTER TABLE `tipo_magazzino`
	ADD COLUMN `disabilitato` BIT NOT NULL DEFAULT b'0' AFTER `reso`;

ALTER TABLE `fornitore_listino`
	DROP FOREIGN KEY `fornitore_listino_ibfk_3`,
	DROP FOREIGN KEY `fornitore_listino_ibfk_4`;
ALTER TABLE `fornitore_listino`
	ADD CONSTRAINT `FK_fornitore_listino_acquisto` FOREIGN KEY (`acquisto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_netto` FOREIGN KEY (`netto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_speciale` FOREIGN KEY (`Speciale`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_fornitore_listino_ultimo` FOREIGN KEY (`ultimo`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE `fornitore_listino`
	DROP FOREIGN KEY `FK_fornitore_listino_acquisto`,
	DROP FOREIGN KEY `FK_fornitore_listino_netto`,
	DROP FOREIGN KEY `FK_fornitore_listino_speciale`,
	DROP FOREIGN KEY `FK_fornitore_listino_ultimo`;
ALTER TABLE `fornitore_listino`
	ADD CONSTRAINT `FK_fornitore_listino_acquisto` FOREIGN KEY (`acquisto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_netto` FOREIGN KEY (`netto`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_speciale` FOREIGN KEY (`Speciale`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_fornitore_listino_ultimo` FOREIGN KEY (`ultimo`) REFERENCES `listino` (`Id_listino`) ON UPDATE CASCADE ON DELETE RESTRICT;
