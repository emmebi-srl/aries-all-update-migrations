
ALTER TABLE `mail_gruppo_inviate`
	ADD CONSTRAINT `FK_mail_gruppo_inviate_mail` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`Id`) ON UPDATE RESTRICT ON DELETE RESTRICT;



INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `pdf`, `fax`, `stampa`, `anteprima`, `Attivo`, `Data_mod`) VALUES ('21', 'ARTICOLI VENDUTI', '3', b'0', b'1', b'0', b'1', b'1', b'1', '2023-02-15 08:44:30');

INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES ('3', '21', '2', NOW());
