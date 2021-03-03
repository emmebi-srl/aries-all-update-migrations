DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DELETE FROM configurazione_percorsi WHERE Tipo_percorso = 'JOBS_REPORTS';
	INSERT INTO configurazione_percorsi 
	SELECT 
		CONCAT(percorso, 'JOBS_REPORTS\\'),
		'JOBS_REPORTS'
	FROM configurazione_percorsi 
	WHERE Tipo_percorso = 'DEFAULT';

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 


DROP TABLE IF EXISTS servizio_alert_esecuzione;
DROP TABLE IF EXISTS servizio_alert_ricevente;
DROP TABLE IF EXISTS servizio_alert_configurazione;
CREATE TABLE `servizio_alert_configurazione` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(50) NOT NULL,
	`Cartella` VARCHAR(100) NOT NULL,
	`Tipo_intervallo` SMALLINT(6) NOT NULL COMMENT '1 = Giorno del mese,  2 = Intervallo giorni',
	`Valore` INT(11) NOT NULL,
	`Numero_mesi` SMALLINT(6) NOT NULL,
	`Data_ultima_esecuzione` DATETIME NOT NULL,
	`Oggetto_email` VARCHAR(150) NOT NULL,
	`Corpo_email` TEXT NOT NULL,
	`Data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_mod` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Nome` (`Nome`)
)
ENGINE=InnoDB
;
CREATE TABLE `servizio_alert_esecuzione` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_servizio` INT(11) NOT NULL,
	`Data_esecuzione` DATETIME NOT NULL,
	`Filename` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`Id`),
	INDEX `FK__servizio_alert_configurazione` (`Id_servizio`),
	CONSTRAINT `FK__servizio_alert_configurazione` FOREIGN KEY (`Id_servizio`) REFERENCES `servizio_alert_configurazione` (`Id`)
)
ENGINE=InnoDB
;


INSERT INTO servizio_alert_configurazione VALUES 
	(1, "Scadenze componenti impianto", "SCADENZE COMPONENTI IMPIANTO", 1, 20, 2, DATE_ADD(NOW(), INTERVAL -1 MONTH), 
		"[ARIES] SCADENZE COMPONENTI IMPIANTO", "Mail automaticamente creata. Non rispondere a questa email.", NOW(), (SELECT Id_utente from utente WHERE utente.nome = "admin")), 
	(2, "Verifica sim impianto", "VERIFICA SIM IMPIANTO", 1, 20, 2, DATE_ADD(NOW(), INTERVAL -1 MONTH), 
		"[ARIES] VERIFICA SIM IMPIANTO", "Mail automaticamente creata. Non rispondere a questa email.", NOW(), (SELECT Id_utente from utente WHERE utente.nome = "admin")), 
	(3, "Fornitori con anomalie", "FORNITORI CON ANOMALIE", 2, 7, 2, DATE_ADD(NOW(), INTERVAL -1 MONTH), 
		"[ARIES] FORNITORI CON ANOMALIE", "Mail automaticamente creata. Non rispondere a questa email.", NOW(), (SELECT Id_utente from utente WHERE utente.nome = "admin"));



INSERT INTO servizio_alert_configurazione VALUES 
	(4, "Scadenze ticket", "SCADENZE TICKET", 1, 20, 2, DATE_ADD(NOW(), INTERVAL -1 MONTH), 
		"[ARIES] SCADENZE TICKET", "Mail automaticamente creata. Non rispondere a questa email.", NOW(), (SELECT Id_utente from utente WHERE utente.nome = "admin"));

		
DROP TABLE IF EXISTS servizio_alert_configurazione_generale;
CREATE TABLE `servizio_alert_configurazione_generale` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Email_host` VARCHAR(50) NOT NULL,
	`Email_username` VARCHAR(50) NOT NULL,
	`Email_password` VARCHAR(50) NOT NULL,
	`Email_port` INT(11) NOT NULL DEFAULT '0',
	`Email_ssl` BIT(1) NOT NULL DEFAULT b'0',
	`Email_from` VARCHAR(50) NOT NULL DEFAULT '0',
	`Data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_ins` INT(11) NOT NULL,
	PRIMARY KEY (`Id`)
)
ENGINE=InnoDB
;


CREATE TABLE `servizio_alert_ricevente` (
	`Id` INT NOT NULL AUTO_INCREMENT,
	`Id_servizio` INT NOT NULL,
	`Email` VARCHAR(50) NOT NULL,
	`Data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_ins` INT NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Id_servizio_Email` (`Id_servizio`, `Email`),
	CONSTRAINT `t` FOREIGN KEY (`Id_servizio`) REFERENCES `servizio_alert_configurazione` (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
