INSERT IGNORE INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES ('3', '1', '2', NOW());

UPDATE `stampante_moduli` SET `modulo`='LISTA DDT' WHERE  `id_documento`=1 AND `Id_modulo`=3;