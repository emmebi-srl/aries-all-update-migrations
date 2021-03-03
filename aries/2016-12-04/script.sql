DROP TABLE IF Exists evento_rapporto; 
CREATE TABLE `evento_rapporto`(
	`Id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	`Id_evento` INT(10) UNSIGNED NOT NULL,
	`Id_rapporto` INT NOT NULL,
	`Anno_rapporto` INT NOT NULL,
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_evento_Id_rapporto` (`Id_evento`, `Id_rapporto`, `Anno_rapporto`),
	CONSTRAINT `Fk_evento_rapporto_Id_evento` FOREIGN KEY (`Id_evento`) REFERENCES `evento` (`Id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

DROP PROCEDURE IF EXISTS tmpProc; 
DELIMITER //
CREATE PROCEDURE tmpProc()
BEGIN
  DECLARE bDone INT;

  DECLARE invoice_id INT;  
  DECLARE invoice_year INT;
  
  DECLARE curs CURSOR FOR  SELECT Id_fattura, anno FROM fattura; 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET bDone = 1;

  OPEN curs;

  SET bDone = 0;
  REPEAT
    FETCH curs INTO invoice_id, invoice_year;
    
		CALL sp_ariesInvoiceEvaluateStatus(invoice_id, Invoice_year);
    
  UNTIL bDone END REPEAT;

  CLOSE curs;
END
//
DELIMITER ;

CALL tmpProc();
DROP PROCEDURE IF EXISTS tmpProc; 


ALTER TABLE `fattura`
	ADD COLUMN `Id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	ADD UNIQUE INDEX `Id` (`Id`);


CREATE TABLE `stampante_formati` (
	`Id` TINYINT NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(20) NOT NULL,
	`Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO stampante_formati VALUES (1, 'PDF', NOW());
INSERT INTO stampante_formati VALUES (2, 'CSV', NOW()); 

CREATE TABLE `stampante_moduli_formati` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_modulo` INT(11) NOT NULL,
	`Id_documento` INT(11) NOT NULL,
	`Id_formato` TINYINT(4) NOT NULL,
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	INDEX `Fk_stampante_moduli_formati_stampante_moduli1` (`Id_modulo`, `Id_documento`),
	INDEX `Fk_stampante_moduli_formati_stampante_formati1` (`Id_formato`),

	CONSTRAINT `Fk_stampante_moduli_formati_stampante_moduli` FOREIGN KEY (`Id_documento`, `Id_modulo`) REFERENCES `stampante_moduli` (`id_documento`, `Id_modulo`),
	CONSTRAINT `Fk_stampante_moduli_formati_stampante_formati` FOREIGN KEY (`Id_formato`) REFERENCES `stampante_formati` (`Id`)
)
ENGINE=InnoDB
;

INSERT INTO stampante_moduli_formati (Id_modulo, Id_documento, Id_formato) 
SELECT 
	Id_modulo, 
	Id_documento, 
	1
FROM stampante_moduli; 

