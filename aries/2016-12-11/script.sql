DROP TABLE IF EXISTS evento_gruppo; 
DROP TABLE IF EXISTS Stato_evento_gruppo; 
DROP TABLE IF EXISTS Evento_gruppo_evento; 

CREATE TABLE `stato_evento_gruppo` (
	`Id` TINYINT(4) NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(20) NOT NULL,
	`Colore` VARCHAR(9) NOT NULL,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


INSERT INTO Stato_evento_gruppo (Nome, Colore) VALUES
('Aperto', 'ClYellow'), 
('Parziale', 'ClBlue'), 
('Chiuso', 'ClGreen');

CREATE TABLE `evento_gruppo` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Oggetto` VARCHAR(50) NOT NULL,
	`Descrizione` TEXT NOT NULL,
	`Id_cliente` INT(11) NULL DEFAULT NULL,
	`Id_impianto` INT(11) NULL DEFAULT NULL,
	`Id_stato` TINYINT(4) NOT NULL DEFAULT '0',
	`Stato_notifica` TINYINT(4) NULL DEFAULT '3',
	`Data_notifica` DATETIME NULL DEFAULT NULL,
	`Eliminato` BIT(1) NULL DEFAULT b'0',
	`Data_ora_inizio` DATETIME NULL DEFAULT NULL,
	`Data_ora_fine` DATETIME NULL DEFAULT NULL,
	`Data_ins` DATETIME NOT NULL,
	`Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_ins` SMALLINT(6) NOT NULL,
	`Utente_mod` SMALLINT(6) NULL DEFAULT NULL,
	PRIMARY KEY (`Id`),
	INDEX `Fk_gruppo_evento_clienti` (`Id_cliente`),
	INDEX `Fk_gruppo_evento_impianto` (`Id_impianto`),
	INDEX `Fk_gruppo_evento_stato_evento_gruppo` (`Id_stato`),
	CONSTRAINT `Fk_gruppo_evento_clienti` FOREIGN KEY (`Id_cliente`) REFERENCES `clienti` (`Id_cliente`) ON UPDATE SET NULL ON DELETE SET NULL,
	CONSTRAINT `Fk_gruppo_evento_impianto` FOREIGN KEY (`Id_impianto`) REFERENCES `impianto` (`Id_impianto`) ON UPDATE SET NULL ON DELETE SET NULL,
	CONSTRAINT `Fk_gruppo_evento_stato_evento_gruppo` FOREIGN KEY (`Id_stato`) REFERENCES `stato_evento_gruppo` (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


CREATE TABLE `evento_gruppo_evento` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_evento` INT(11) NOT NULL,
	`Id_gruppo_evento` INT(11) NOT NULL,
	`Tipo_associazione` TINYINT NOT NULL DEFAULT '1',
	`Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_evento_Id_gruppo_evento` (`Id_evento`, `Id_gruppo_evento`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;



INSERT INTO evento_gruppo 
SELECT 
	evento.Id,
	evento.Oggetto,
	evento.Descrizione, 
	
	IF( tipologia_tipo_evento.Rif_applicazione = "customer", IF(evento.Id_riferimento = 0, NULL, evento.id_riferimento), 
	IF( tipologia_tipo_evento.Rif_applicazione = "system", 
		IF(evento.Id_tipo_evento = 1,  NULL, (SELECT Id_cliente FROM impianto WHERE impianto.Id_impianto = evento.id_riferimento)), 
	IF( tipologia_tipo_evento.Rif_applicazione = "ticket", (SELECT Id_cliente FROM ticket WHERE Ticket.Id= evento.id_riferimento), NULL))) AS "Id_cliente",
	
	IF( tipologia_tipo_evento.Rif_applicazione = "customer", NULL, 
	IF( tipologia_tipo_evento.Rif_applicazione = "system", 
		IF(evento.Id_tipo_evento = 1, (SELECT impianto FROm impianto_abbonamenti_mesi WHERE impianto_abbonamenti_mesi.Id = evento.Id_riferimento), IF(evento.id_riferimento = 0, NULL, 
			IFNULL((SELECT Id_impianto FROM impianto WHERE impianto.id_impianto = evento.id_riferimento), 
					 (SELECT impianto FROm impianto_abbonamenti_mesi WHERE impianto_abbonamenti_mesi.Id = evento.Id_riferimento)))), 
	IF( tipologia_tipo_evento.Rif_applicazione = "ticket", (SELECT Id_impianto FROM ticket WHERE Ticket.Id = evento.id_riferimento), NULL))) AS "Id_impianto",
	
	IF(eseguito = 1, 3, 1) AS `Id_stato`,
	`Stato_notifica`,
	`Data_notifica`,
	`Eliminato`,
	STR_TO_DATE(CONCAT(Data_esecuzione, ' ', ora_inizio_esecuzione), '%Y-%m-%d %H:%i:%s') AS "fine", 
	STR_TO_DATE(CONCAT(Data_esecuzione, ' ', ora_fine_esecuzione), '%Y-%m-%d %H:%i:%s') AS "inizio",
	`Data_ins`,
	`Data_mod`,
	`Utente_ins`,
	`Utente_mod`
FROM Evento
	INNER JOIN Tipo_evento ON
	Tipo_evento.Id_tipo = evento.Id_tipo_evento
	INNER JOIN tipologia_tipo_evento ON
	tipo_evento.Id_tipologia = tipologia_tipo_evento.id; 


UPDATE evento_gruppo
	INNER JOIN impianto ON impianto.id_impianto = evento_gruppo.id_impianto
SET evento_gruppo.Id_cliente = impianto.Id_cliente
WHERE evento_gruppo.id_cliente IS NULL AND evento_gruppo.ID_impianto IS NOT NULL; 

INSERT INTO evento_gruppo_evento
SELECT Id, 
	Id, 
	Id,
	1, 
	Data_mod
FROM evento; 



ALTER TABLE `impianto_note_descrizione`
	ALTER `Nome` DROP DEFAULT;
ALTER TABLE `impianto_note_descrizione`
	CHANGE COLUMN `Nome` `Nome` VARCHAR(100) NOT NULL AFTER `Id_descrizione`;
ALTER TABLE `operazioni_articoli`
	ALTER `nome` DROP DEFAULT;
ALTER TABLE `operazioni_articoli`
	CHANGE COLUMN `nome` `nome` VARCHAR(100) NOT NULL AFTER `id_operazione`;



ALTER TABLE `evento_gruppo_evento`
	ALTER `Id_evento` DROP DEFAULT;
ALTER TABLE `evento_gruppo_evento`
	CHANGE COLUMN `Id_evento` `Id_evento` INT(10) UNSIGNED NOT NULL AFTER `Id`,
	ADD CONSTRAINT `FK_evento_id` FOREIGN KEY (`Id_evento`) REFERENCES `evento` (`Id`) ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT `FK_event_gruppo_id` FOREIGN KEY (`Id_gruppo_evento`) REFERENCES `evento_gruppo` (`Id`);

