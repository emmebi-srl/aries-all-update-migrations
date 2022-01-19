ALTER TABLE `stato_rapporto`
	ADD COLUMN `fatturato` BIT NULL DEFAULT b'0' AFTER `bloccato`;

UPDATE stato_rapporto
SET fatturato = 0;

UPDATE stato_rapporto
SET fatturato = 1
WHERE Nome IN ('ET', 'FATTURATO');