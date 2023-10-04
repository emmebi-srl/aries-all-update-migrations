
INSERT INTO `tipo_documento` (`Nome`) VALUES ('CONTRATTO');

INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `pdf`, `fax`, `stampa`, `anteprima`, `Attivo`, `Data_mod`) VALUES (30, 'DOCUMENTO', 0, b'1', b'1', b'1', b'1', b'1', b'1', '2023-09-14 09:44:46');
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (0, 30, 1, '2023-09-14 09:44:46');
