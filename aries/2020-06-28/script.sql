CREATE TABLE `cliente_promemoria_configurazione` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Nome` VARCHAR(50) NOT NULL,
	`Tipo_intervallo` SMALLINT(6) NOT NULL COMMENT '1 = Giorno del mese,  2 = Intervallo giorni',
	`Valore` INT(11) NOT NULL,
	`Data_ultima_esecuzione` DATETIME NOT NULL,
	`Oggetto_email` VARCHAR(150) NULL,
	`Corpo_email` TEXT NULL,
	`Testo_sms` TEXT NULL,
	`abilita_sms` BIT(1) NOT NULL,
	`abilita_email` BIT(1) NOT NULL,
	`Data_mod` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_mod` INT(11) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Nome` (`Nome`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE `cliente_promemoria_configurazione_generale` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Email_host` VARCHAR(50) NOT NULL,
	`Email_username` VARCHAR(50) NOT NULL,
	`Email_password` VARCHAR(50) NOT NULL,
	`Email_port` INT(11) NOT NULL DEFAULT '0',
	`Email_ssl` BIT(1) NOT NULL DEFAULT b'0',
	`Email_from` VARCHAR(50) NOT NULL DEFAULT '0',
	`Sms_host` VARCHAR(150) NOT NULL DEFAULT '0',
	`Data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`Utente_ins` INT(11) NOT NULL,
	PRIMARY KEY (`Id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


INSERT INTO `cliente_promemoria_configurazione_generale` (`Email_host`, `Email_username`, `Email_password`, `Email_port`, `Email_ssl`, `Email_from`, `Sms_host`, `Utente_ins`) VALUES ('example.smtp.it', 'example', 'example', 25, b'1', '', '192.168.0.101', 1);
INSERT INTO `cliente_promemoria_configurazione` VALUES (1, 'PROMEMORIA EVENTO', 4, 1, '2018-06-28 10:30:09', 'Visita di {event_type} - {date} {time}', '{company_name} le ricorda l’appuntamento del {date} alle ore {time} per la visita di {event_type} sull’impianto {system_type}\r\n\r\nPer modificare 029587597 orari ufficio oppure tecnico@siantel.com', 'Siantel le ricorda l’appuntamento del {date} alle ore {time} per la visita di {event_type} sull’impianto {system_type}. Per modificare 029587597 orari ufficio oppure tecnico@siantel.com', b'0', b'0', '2020-07-04 09:43:06', 1);

ALTER TABLE `riferimento_clienti`
	ADD COLUMN `Promemoria_cliente` BIT NULL DEFAULT b'0' AFTER `Fatturazione`;

ALTER TABLE `rapporto`
	DROP FOREIGN KEY `rap_dest`;
ALTER TABLE `rapporto`
	ADD CONSTRAINT `rap_dest` FOREIGN KEY (`dest_cli`, `id_destinazione`) REFERENCES `destinazione_cliente` (`id_cliente`, `Id_destinazione`) ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `evento`
	ADD COLUMN `Promemoria_inviato` BIT NOT NULL DEFAULT b'0' AFTER `Data_notifica`;
