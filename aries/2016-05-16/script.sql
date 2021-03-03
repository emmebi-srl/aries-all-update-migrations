DROP TABLE Tipologia_tipo_evento; 

CREATE TABLE `Tipologia_tipo_evento` (
	`Id` TINYINT NOT NULL AUTO_INCREMENT,
	`Descrizione` VARCHAR(25) NOT NULL DEFAULT '0',
	`Rif_applicazione` VARCHAR(20) NOT NULL DEFAULT '0',
	`Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`)
)
COMMENT='Tabella contenente le tipologie dei vari tipi evento. Per Esempio se per clinete, per impianto, per tecnico, nulla'
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
INSERT INTO tipologia_tipo_evento (Id, Descrizione, Rif_applicazione) VALUES
(1, "Generico", "none"), 
(2, "Cliente", "customer"), 
(3, "Impianto", "system"), 
(4, "Dipendente", "employee");

ALTER TABLE `tipo_evento`
	ADD COLUMN `Id_tipologia` TINYINT NULL DEFAULT '1' AFTER `colore`,
	ADD COLUMN `Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Id_tipologia`,
	ADD CONSTRAINT `FK_Tipologia_tipo_evento` FOREIGN KEY (`Id_tipologia`) REFERENCES `tipologia_tipo_evento` (`Id`);
	
	
	
INSERT IGNORE INTO Tipo_evento (Id_tipo, nome, colore, Id_tipologia)
VALUES
(8, 'SOPRALUOGO TECNICO', '$10FFC7A2', 3), 
(9, 'INTERVENTO A PAGAMENTO', '$01FFC7A2', 3),
(10, 'SOPRALUOGO COMMERCIALE', '$11FFC7A2', 2), 
(11, 'TECNICO EMERGENZE', '$00FFC7F3', 1),
(12, 'TECNICO DI TURNO', '$00FFC7F4', 1), 
(13, 'IN CORSIVO', '$00FF77A2', 1), 
(14, 'PRODUZIONE', '$00FFC8A2', 1), 
(15, 'FERIE', '$00FFC772', 4);

-- Controllo periodico
UPDATE Tipo_evento 
SET Id_tipologia = 3
WHERE Id_tipo = 1; 

-- Ticket
UPDATE Tipo_evento 
SET Id_tipologia = 3
WHERE Id_tipo = 2; 

-- Pagamento Fattura
UPDATE Tipo_evento 
SET Id_tipologia = 2
WHERE Id_tipo = 3; 

-- Dipendente
UPDATE Tipo_evento 
SET Id_tipologia = 4
WHERE Id_tipo = 4; 

-- Corso
UPDATE Tipo_evento 
SET Id_tipologia = 4
WHERE Id_tipo = 5; 

-- Automezzo
UPDATE Tipo_evento 
SET Id_tipologia = 1
WHERE Id_tipo = 6; 

-- Tecnico
UPDATE Tipo_evento 
SET Id_tipologia = 4
WHERE Id_tipo = 7; 





