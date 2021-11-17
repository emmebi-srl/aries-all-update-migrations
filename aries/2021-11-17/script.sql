CREATE TABLE `fattura_allegati` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_fattura` INT(11) NOT NULL,
	`Anno_fattura` INT(11) NOT NULL,
	`Nome` VARCHAR(150) NOT NULL,
	`Formato` VARCHAR(10) NOT NULL,
	`Descrizione` MEDIUMTEXT NULL,
	`File_path` VARCHAR(250) NOT NULL,
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	INDEX `FK_fattura_allegati` (`Id_fattura`, `Anno_fattura`),
	CONSTRAINT `FK_fattura_allegati` FOREIGN KEY (`Id_fattura`, `Anno_fattura`) REFERENCES `fattura` (`Id_fattura`, `anno`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=2046
;



DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_emmebi BIT(1) DEFAULT 0;


	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda 
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		insert into environment_variables VALUES ('ENABLE_INVOICE_ATTACHMENTS_FEATURE', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_INVOICE_ATTACHMENTS_FEATURE', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 