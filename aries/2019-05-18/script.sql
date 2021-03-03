ALTER TABLE `stampante_moduli_formati`
	ADD UNIQUE INDEX `Id_modulo_Id_documento_Id_formato` (`Id_modulo`, `Id_documento`, `Id_formato`);
	
INSERT IGNORE INTO stampante_moduli_formati
SET
	`Id_modulo` = 0,
	`Id_documento` = 25,
	`Id_formato` = 2;
	
INSERT IGNORE INTO stampante_moduli_formati
SET
	`Id_modulo` = 1,
	`Id_documento` = 25,
	`Id_formato` = 2;


UPDATE `stampante_moduli` SET `mail`=b'0', `fax`=b'0' WHERE  `id_documento`=25 AND `Id_modulo`=0;