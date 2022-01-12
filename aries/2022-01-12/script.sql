ALTER TABLE `stato_impianto`
	ADD COLUMN `non_abbonato` BIT NULL DEFAULT b'0' AFTER `bloccato`;

UPDATE stato_impianto
SET non_abbonato = 1
WHERE nome  <> 'MANUTENZIONE';

UPDATE stato_impianto
SET non_abbonato = 0
WHERE nome  = 'MANUTENZIONE';