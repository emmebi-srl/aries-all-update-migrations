INSERT INTO `tipo_fattura` (`id_tipo`, `nome`, `Descrizione`) VALUES (6, 'ACCONTO/ANTICIPO FATTURA', 'ACCONTO/ANTICIPO SU FATTURA');
UPDATE `tipo_fattura` SET tipo_PA = 'TD01' WHERE nome = 'FATTURA' AND id_tipo = 1;
UPDATE `tipo_fattura` SET tipo_PA = 'TD04' WHERE nome = 'NOTA DI ACCREDITO' AND id_tipo = 2;
UPDATE `tipo_fattura` SET tipo_PA = 'TD05' WHERE nome = 'NOTA DI ADDEBITO' AND id_tipo = 3;
UPDATE `tipo_fattura` SET tipo_PA = 'TD05' WHERE nome = 'NOTA DI ADDEBITO'  AND id_tipo = 4;
UPDATE `tipo_fattura` SET tipo_PA = 'TD01' WHERE nome = 'FATTURA ACCOMPAGNATORIA'  AND id_tipo = 5;
UPDATE `tipo_fattura` SET tipo_PA = 'TD02' WHERE nome = 'ACCONTO/ANTICIPO FATTURA'  AND id_tipo = 6;