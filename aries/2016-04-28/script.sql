ALTER TABLE `stampante_moduli`
	CHANGE COLUMN `mail` `mail` BIT NOT NULL DEFAULT b'1' AFTER `Id_modulo`,
	CHANGE COLUMN `pdf` `pdf` BIT NOT NULL DEFAULT b'1' AFTER `mail`,
	CHANGE COLUMN `fax` `fax` BIT NOT NULL DEFAULT b'1' AFTER `pdf`,
	CHANGE COLUMN `stampa` `stampa` BIT NOT NULL DEFAULT b'1' AFTER `fax`,
	CHANGE COLUMN `anteprima` `anteprima` BIT NOT NULL DEFAULT b'1' AFTER `stampa`,
	ADD COLUMN `File_name` VARCHAR(30) NULL DEFAULT NULL AFTER `anteprima`,
	ADD COLUMN `Report_name` VARCHAR(35) NULL DEFAULT NULL AFTER `File_name`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Report_name`;

	
	ALTER TABLE `stampante_moduli`
	ADD COLUMN `Attivo` BIT(1) NOT NULL DEFAULT b'1' AFTER `Report_name`;

	
DROP PROCEDURE IF EXISTS sp_tmpAllineamentoStpModuli;
DELIMITER $$
CREATE PROCEDURE `sp_tmpAllineamentoStpModuli`()
BEGIN
	INSERT INTO Stampante_moduli 
	(
		`id_documento`,
		`modulo`,
		`Id_modulo`,
		`mail`,
		`pdf`,
		`fax`,
		`stampa`,
		`anteprima`,
		File_name,
		Report_name,
		`Attivo`
	)
	SELECT tipo_documento.Id_tipo, 
		'DOCUMENTO', 
		'0', 
		true,
		true, 
		true, 
		true, 
		true,
		NULL,
		NULL, 
		true
	FROM tipo_documento; 
			
END $$
DELIMITER ;

CALL sp_tmpAllineamentoStpModuli(); 

DROP PROCEDURE IF EXISTS sp_tmpAllineamentoStpModuli;



INSERT INTO Mail_stato VALUES (6, 'ELIMINATA');

ALTER TABLE `commessa`
	ADD COLUMN `Data_ins` DATETIME NOT NULL AFTER `stamp_com`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`;
	
	
ALTER TABLE `commessa`
	ALTER `Utente_mod` DROP DEFAULT;
ALTER TABLE `commessa`
	CHANGE COLUMN `Utente_mod` `Utente_mod` SMALLINT(6) NULL AFTER `Utente_ins`;

UPDATE Commessa
SET Data_ins = NOW(); 
	
ALTER TABLE `commessa`
	CHANGE COLUMN `inv_com` `inv_com` BIT NULL DEFAULT b'0' AFTER `id_utente`,
	CHANGE COLUMN `stamp_com` `stamp_com` BIT NULL DEFAULT b'0' AFTER `inv_com`;
ALTER TABLE `commessa`
	ADD COLUMN `Id` INT(11) NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `Id` (`Id`);



UPDATE `stampante_moduli` SET `File_name`='Commessa.rav' WHERE  `id_documento`=5 AND `Id_modulo`=0;
UPDATE `stampante_moduli` SET `File_name`='Commessa.rav' WHERE  `id_documento`=5 AND `Id_modulo`=2;
UPDATE `stampante_moduli` SET `File_name`='Commessa.rav' WHERE  `id_documento`=5 AND `Id_modulo`=1;
UPDATE `stampante_moduli` SET `Report_name`='JobInternal_generic' WHERE  `id_documento`=5 AND `Id_modulo`=0;
UPDATE `stampante_moduli` SET `Report_name`='JobRequirements_generic' WHERE  `id_documento`=5 AND `Id_modulo`=1;
UPDATE `stampante_moduli` SET `Report_name`='JobCustomer_generic' WHERE  `id_documento`=5 AND `Id_modulo`=2;