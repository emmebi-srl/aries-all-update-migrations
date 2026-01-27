INSERT INTO nota (nome, note, prezz, cost, temp, nota_stato) VALUES ('SMALTIMENTO MATERIALE', 'SMALTIMENTO MATERIALE', 0, 0, 0, 1);

INSERT INTO environment_variables VALUES ('MATERIAL_DISPOSAL_NOTE_ID', LAST_INSERT_ID(), NOW());

ALTER TABLE `rapporto_mobile_materiale`
	ADD COLUMN `id_nota` INT NULL DEFAULT NULL AFTER `codice_articolo`,
	ADD CONSTRAINT `FK_rapporto_mobile_materiale_nota` FOREIGN KEY (`id_nota`) REFERENCES `nota` (`id_nota`) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE `rapporto_mobile_materiale`
	ADD COLUMN `prezzo` DECIMAL(11,2) NOT NULL DEFAULT '0.00' AFTER `quantita`;

ALTER TABLE `rapporto_materiale`
	ADD COLUMN `Id_nota` INT NULL DEFAULT NULL AFTER `Id_materiale`,
	ADD CONSTRAINT `FK_rapporto_materiale_nota` FOREIGN KEY (`Id_nota`) REFERENCES `nota` (`id_nota`) ON UPDATE RESTRICT ON DELETE RESTRICT;
