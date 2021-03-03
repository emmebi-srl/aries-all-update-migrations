ALTER TABLE `rapporto_materiale`
	ADD COLUMN `unita_misura` VARCHAR(5) NULL DEFAULT NULL AFTER `anno`,
	ADD CONSTRAINT `rapporto_materiale_um` FOREIGN KEY (`unita_misura`) REFERENCES `unita_misura` (`sigla`);

UPDATE rapporto_materiale 
INNER JOIN articolo ON rapporto_materiale.Id_materiale = articolo.Codice_articolo
	SET unita_misura = articolo.`unità_misura`
WHERE rapporto_materiale.tipo = '';

INSERT INTO `stampante_moduli` VALUES (4, 'FATTURA PA', 6, b'1', b'0', b'0', b'1', b'1', NULL, NULL, b'1', '2018-08-09 07:13:46');
INSERT INTO `stampante_formati` (`Nome`) VALUES ('XML');
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`) VALUES (6, 4, 5);

ALTER TABLE `configurazione_resoconto`
	ADD COLUMN `stampa_desc_estesa` BIT NOT NULL DEFAULT b'0' AFTER `spese`;