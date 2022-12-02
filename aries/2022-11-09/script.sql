INSERT INTO `tipo_documento` (Id_tipo, `Nome`) VALUES (29, 'CLIENTE DASHBOARD');
INSERT INTO `stampante_moduli` (`id_documento`, Id_modulo, `modulo`, `mail`, `fax`, `Data_mod`) VALUES (29,0, 'DOCUMENTO', b'0', b'0', '2022-04-20 03:35:48');
UPDATE `stampante_moduli` SET `File_name`='customer_dashboard.fr3' WHERE  `id_documento`=29 AND `Id_modulo`=0;

INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (0, 29, 1, '2022-04-20 03:35:48');