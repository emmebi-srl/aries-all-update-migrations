INSERT INTO `tipo_documento` (`Id_tipo`, `Nome`) VALUES (28, 'ABBONAMENTO');
INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `fax`, `Data_mod`) VALUES (28, 'DOCUMENTO', 0, b'0', b'0',  NOW());
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (0, 28, 1, NOW());


INSERT INTO .`stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `fax`, `Data_mod`) VALUES (6, 'IN SCADENZA', 5, b'0', b'0', NOW());
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (5, 6, 2,  NOW());