ALTER TABLE `stato_impianto`
	ADD COLUMN `non_abbonato` BIT NULL DEFAULT b'0' AFTER `bloccato`;

UPDATE stato_impianto
SET non_abbonato = 1
WHERE nome  <> 'MANUTENZIONE';

UPDATE stato_impianto
SET non_abbonato = 0
WHERE nome  = 'MANUTENZIONE';



INSERT INTO `stampante_moduli` VALUES (15, 'SCAD. GARANZIA', 6, b'0', b'1', b'0', b'1', b'1', NULL, NULL, b'1', NOW());
INSERT INTO `stampante_moduli_formati` (id_modulo, id_documento, id_formato) VALUES (6, 15, 2);
