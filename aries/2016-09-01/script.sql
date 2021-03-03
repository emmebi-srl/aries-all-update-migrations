ALTER TABLE `categoria_merciologica`
	ALTER `Utente_ins` DROP DEFAULT,
	ALTER `Utente_mod` DROP DEFAULT;
ALTER TABLE `categoria_merciologica`
	CHANGE COLUMN `Utente_ins` `Utente_ins` SMALLINT(6) NULL AFTER `Data_mod`,
	CHANGE COLUMN `Utente_mod` `Utente_mod` SMALLINT(6) NULL AFTER `Utente_ins`;


INSERT INTO Tipo_evento
SET
	Id_tipo = 25,
	Nome = "PROMEMORIA SCAD. ARTICOLI", 
	Colore = "$F0CAA6", 
	Id_tipologia = 3, 
	Timestamp = NOW();