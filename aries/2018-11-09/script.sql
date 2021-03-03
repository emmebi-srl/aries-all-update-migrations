ALTER TABLE `clienti`
	ADD COLUMN `e_codice_destinatario` VARCHAR(7) NULL DEFAULT NULL COMMENT 'Codice identificativo per l\'invio delle fatture elettronica. 7 caratteri da richiedere al ente di trasmissione. Es: infocert' AFTER `codice_univoco`;

CREATE TABLE `certificato_importato` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(150) NOT NULL,
	`nome_emittente` VARCHAR(150) NOT NULL,
	`nome_rif` VARCHAR(150) NOT NULL COMMENT 'Nome del certificato per identificarlo. Questo nome puo essere scelto all importazione',
	`email` VARCHAR(150) NOT NULL,
	`data_inizio_validita` DATETIME NOT NULL,
	`data_fine_validita` DATETIME NOT NULL,
	`serial_number` VARCHAR(150) NOT NULL,
	`pin` VARCHAR(50) NULL DEFAULT NULL,
	`smart_device` BIT(1) NOT NULL,
	`attivo` BIT(1) NOT NULL,
	`data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`utente_mod` INT(11) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
AUTO_INCREMENT=7
;

ALTER TABLE `fattura_configurazione`
	ADD COLUMN `id_certificato_firma` TINYINT(1) UNSIGNED NULL DEFAULT NULL AFTER `impianto`,
	ADD COLUMN `utente_mod` MEDIUMINT UNSIGNED NOT NULL AFTER `id_certificato_firma`,
	ADD COLUMN `data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `utente_mod`;

ALTER TABLE `fattura_configurazione`
	CHANGE COLUMN `id_certificato_firma` `id_certificato_firma` INT(11) NULL DEFAULT NULL AFTER `impianto`,
	ADD CONSTRAINT `FK_fattura_cert_firma` FOREIGN KEY (`id_certificato_firma`) REFERENCES `certificato_importato` (`id`) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE `fattura_configurazione`
	ADD COLUMN `id` INT(11) NOT NULL AUTO_INCREMENT FIRST,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id`);
