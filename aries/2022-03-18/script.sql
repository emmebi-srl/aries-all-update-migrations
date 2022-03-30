ALTER TABLE `corso`
	ADD COLUMN `richiede_verifica` BIT NOT NULL DEFAULT b'0' AFTER `costo`,
	CHANGE COLUMN `verificato` `verificato` BIT NOT NULL DEFAULT b'0' AFTER `richiede_verifica`;
