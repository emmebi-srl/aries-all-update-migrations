ALTER TABLE `stato_ddt`
	ADD COLUMN `Colore` VARCHAR(15) NOT NULL DEFAULT '1' AFTER `Descrizione`;
ALTER TABLE `stato_ddt`
	ALTER `Colore` DROP DEFAULT;
ALTER TABLE `stato_ddt`
	CHANGE COLUMN `Colore` `Colore` VARCHAR(15) NOT NULL AFTER `Descrizione`;

UPDATE Stato_ddt 
SET Colore = 'ClYellow'
WHERE Id_stato = 1;

UPDATE Stato_ddt 
SET Colore = 'ClBlue'
WHERE Id_stato = 2;

UPDATE Stato_ddt 
SET Colore = 'ClLime'
WHERE Id_stato = 3;

INSERT INTO Stato_ddt 
SET Id_Stato = 4,
	Nome = "In commessa", 
	Descrizione = "Ddt in commessa",
	Colore = 'ClPurple'; 