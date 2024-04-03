ALTER TABLE `fornfattura`
	ADD COLUMN `movimenta_magazzino` BIT NULL DEFAULT 0;

ALTER TABLE `fattura`
	ADD COLUMN `movimenta_magazzino` BIT NULL DEFAULT 0;

UPDATE fornfattura 
SET `movimenta_magazzino` = 1
WHERE tipo_fattura = 5;

UPDATE fattura 
SET `movimenta_magazzino` = 1
WHERE tipo_fattura = 5;

ALTER TABLE `tipo_fattura`
	ADD COLUMN `movimenta_magazzino` BIT NULL DEFAULT 0;

UPDATE tipo_fattura
SET movimenta_magazzino = 1
WHERE id_tipo = 5;

UPDATE `tipo_fattura` SET `nome`='NOTA DI ADDEBITO IVA' WHERE  `id_tipo`=4;