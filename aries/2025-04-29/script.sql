ALTER TABLE `riferimento_figura`
	ADD COLUMN `Abbreviazione` VARCHAR(30) NOT NULL DEFAULT '' AFTER `Figura`;

UPDATE riferimento_figura
SET Abbreviazione = UPPER(TRIM(SUBSTRING(Figura, 1, 3)));

UPDATE riferimento_figura
SET Abbreviazione = 'RIF'
WHERE UPPER(Figura) = 'ALTRO RIF';

UPDATE riferimento_figura
SET Abbreviazione = 'SRL'
WHERE UPPER(Figura) IN ('SORELLA', 'SOR');

UPDATE riferimento_figura
SET Abbreviazione = 'FRL'
WHERE UPPER(Figura) IN ('FRATELLO', 'FRA');

UPDATE riferimento_figura
SET Abbreviazione = 'AMM'
WHERE UPPER(Figura) LIKE 'CONTABIL%';