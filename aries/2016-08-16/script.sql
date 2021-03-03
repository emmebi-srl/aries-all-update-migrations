ALTER TABLE `resoconto`
	ALTER `Descrizione` DROP DEFAULT;
ALTER TABLE `resoconto`
	CHANGE COLUMN `Descrizione` `Descrizione` VARCHAR(150) NOT NULL AFTER `data`;

	
DELETE FROM impianto_abbonamenti WHERE anno < 1970; 

UPDATE Impianto_abbonamenti
SET impianto_abbonamenti.data_ultima_modifica = STR_TO_DATE(CONCAT(anno, '-01-01'), '%Y-%m-%d')
WHERE impianto_abbonamenti.data_ultima_modifica = STR_TO_DATE('0000-00-00 00:00:00', '%Y-%m-%d %H:%i:%s');