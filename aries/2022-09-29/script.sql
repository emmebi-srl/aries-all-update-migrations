INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Aries Administrator', 'Questa role da la possibilità di impostare un utente con i privilegi di admin', 'aries_admin');

ALTER TABLE `utente_roles`
	ALTER `nome` DROP DEFAULT,
	ALTER `app_name` DROP DEFAULT;
ALTER TABLE `utente_roles`
	CHANGE COLUMN `nome` `nome` VARCHAR(50) NOT NULL AFTER `id`,
	CHANGE COLUMN `descrizione` `descrizione` TEXT NOT NULL AFTER `nome`,
	CHANGE COLUMN `app_name` `app_name` VARCHAR(50) NOT NULL AFTER `descrizione`,
	ADD COLUMN `max_utenti_assegnabili` INT(10) NOT NULL DEFAULT '1' AFTER `app_name`;

ALTER TABLE `utente_roles`
	ADD COLUMN `min_utenti_assegnabili` INT(10) NOT NULL DEFAULT '1' AFTER `max_utenti_assegnabili`;

UPDATE `utente_roles` SET `max_utenti_assegnabili`=10 WHERE  `app_name`='aries_mobile_admin';


CREATE TABLE `utente_servizio` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(60) NOT NULL,
	`app_name` VARCHAR(60) NOT NULL,
	`email` VARCHAR(100) NULL DEFAULT NULL,
	`firma` TEXT NULL,
	`smtp` VARCHAR(45) NULL DEFAULT NULL,
	`porta` SMALLINT(6) NULL DEFAULT NULL,
	`mssl` BIT(1) NULL DEFAULT NULL,
	`email_username` VARCHAR(45) NULL DEFAULT NULL,
	`email_password` VARCHAR(45) NULL DEFAULT NULL,
	`display_name` VARCHAR(45) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `nome` (`nome`),
	UNIQUE INDEX `app_name` (`app_name`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


INSERT INTO utente_servizio (nome, app_name, email, firma, smtp, porta, mssl, email_username, email_password, display_name)
SELECT 'Aries Activities Notifications',
	'aries_activities_notifications',
	`mail`,
	'',
	`host`,
	porta,
	1,
	username,
	password,
	`display_name`
FROM tablet_configurazione
ORDER BY id_tablet DESC
LIMIT 1;