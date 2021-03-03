
DROP TABLE IF EXISTS checklist_model_elemento_def_valore;
CREATE TABLE `checklist_model_elemento_def_valore` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_elemento` INT(11) NOT NULL,
	`Id_tipo_def_val` INT(11) NOT NULL,
	`Label` VARCHAR(100) NOT NULL,
	`Field` VARCHAR(100) NOT NULL,
	`Value` MEDIUMTEXT NOT NULL,
	`Data_mod` DATETIME NOT NULL,
	`Utente_mod` MEDIUMINT(9) NOT NULL,
	PRIMARY KEY (`Id`),
	INDEX `fk_checklist_model_elemento_valore` (`Id_elemento`),
	INDEX `fk_tipo_checklist_model_elemento_valore` (`Id_tipo_def_val`),
	CONSTRAINT `fk_tipo_checklist_model_elemento_valore` FOREIGN KEY (`Id_tipo_def_val`) REFERENCES `tipo_checklist_model_elemento_def_valore` (`id`),
	CONSTRAINT `fk_checklist_model_elemento_valore` FOREIGN KEY (`Id_elemento`) REFERENCES `checklist_model_elemento` (`Id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

DROP TABLE IF EXISTS tipo_checklist_model_elemento_def_valore;
CREATE TABLE `tipo_checklist_model_elemento_def_valore` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`Id_tipo` TINYINT(4) NOT NULL,
	`Nome` VARCHAR(100) NOT NULL,
	`Field` VARCHAR(100) NOT NULL,
	`Field_type` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`Id`),
	INDEX `id_tipo_checklist_model_valore` (`Id_tipo`),
	CONSTRAINT `id_tipo_checklist_model_valore` FOREIGN KEY (`Id_tipo`) REFERENCES `tipo_checklist_elemento` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


INSERT INTO tipo_checklist_model_elemento_def_valore (`Id_tipo`, `Nome`,`Field`, `Field_type`) VALUES (7, "Quantità", "quantity", "float"),  -- battery

(7, "Ampere", "ampere", "float"), 

(7, "Anno", "year", "integer"), 

(7, "Mese", "month", "integer"), 

(5, "Marca", "brand", "string"), -- central info

(5, "Modello", "model", "string"), 

(5, "Posizione", "position", "string"), 

(5, "Master Slave", "master_slave", "integer"), 

(5, "Slave ID", "slave_id", "integer"),

(8, "Tensione iniziale", "start_voltage", "float"),-- InstrumentalMeasures

(8, "Tensione dopo 1h", "next_voltage", "float"),

(8, "Assorbimento a riposo", "rest_absorption", "float"),

(8, "Assorbimento in allarme", "alarm_absorption", "float"),

(8, "Ore autonomia", "hour_autonomy", "float"),

(6, "Master Slave", "master_slave", "integer"), -- master-slave

(6, "Slave ID", "slave_id", "integer"),

(9, "Marca", "brand", "string"), -- power supply info

(9, "Modello", "model", "string"), 

(9, "Posizione", "position", "string"), 

(9, "Ampere", "ampere", "float"), 



(12, "Serial number", "serial_number", "string"), -- recorder info

(12, "IP interno", "internal_ip", "string"), 

(12, "IP esterno", "external_ip", "string"), 

(12, "Porte", "ports", "string"), 

(12, "Username", "username", "string"), 

(12, "Password", "password", "string"), 

(12, "P2P", "peer_to_peer", "boolean"), 

(12, "P2P note", "peer_to_peer_notes", "string"), 

(12, "SNMP versione", "snmp_version", "integer"), 

(12, "Ping", "ping", "string"), 

(12, "Server DDNS", "ddns_server", "string"), 

(12, "Username DDNS", "ddns_username", "string"), 

(12, "Password DDNS", "ddns_password", "string"), 





(10, "Marca", "brand", "string"),-- power supply info

(10, "Modello", "model", "string"), 

(10, "Posizione", "position", "string"), 

(10, "Numero sensore", "sensor_number", "string"), 

(10, "Tipo sistema", "suction_system_type", "integer"), 



(1, "Si No", "value", "integer"), 



(2, "Si No Na", "value", "integer"), 



(11, "Data", "value", "date"), 



(13, "Si No Na", "value", "integer"), 

(13, "Quantità", "quantity", "float");

