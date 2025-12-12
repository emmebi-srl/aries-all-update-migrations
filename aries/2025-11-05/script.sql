CREATE TABLE `tipo_campagna_aries` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(50) NOT NULL DEFAULT '',
	`rif_applicazione` VARCHAR(50) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	UNIQUE INDEX `rif_applicazione` (`rif_applicazione`)
)
COLLATE='latin1_swedish_ci'
;

CREATE TABLE `campagna_aries` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`nome` VARCHAR(150) NOT NULL DEFAULT '',
	`descrizione` TEXT NOT NULL,
	`data_attivazione` DATETIME NOT NULL,
	`data_disattivazione` DATETIME NOT NULL,
	`attiva` BIT NOT NULL DEFAULT 0,
	`id_tipo_campagna` INT NOT NULL DEFAULT 0,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	`utente_ins` INT(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`id`),
	CONSTRAINT `FK_campagna_aries_tipo_campagna` FOREIGN KEY (`id_tipo_campagna`) REFERENCES `tipo_campagna_aries` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
COLLATE='latin1_swedish_ci'
;


CREATE TABLE `campagna_aries_segnaposto` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_tipo_campagna` INT(11) NOT NULL,
	`nome` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`descrizione` TEXT NOT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`Id`) USING BTREE,
	UNIQUE INDEX `id_tipo_campagna_aries_nome` (`id_tipo_campagna`, `nome`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_segnaposto_tipo_campagna` FOREIGN KEY (`id_tipo_campagna`) REFERENCES `tipo_campagna_aries` (`id`) ON UPDATE RESTRICT ON DELETE RESTRICT
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;


INSERT INTO `tipo_campagna_aries` (`nome`, `rif_applicazione`) VALUES ('Auguri di Natale', 'happy_christmas');
INSERT INTO `tipo_campagna_aries` (`nome`, `rif_applicazione`) VALUES ('Monitoraggio Preventivi', 'quotes_monitoring');

ALTER TABLE `campagna_aries`
	ADD COLUMN `mail_template_path` TEXT NOT NULL AFTER `descrizione`;


CREATE TABLE `campagna_aries_mail` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_campagna_aries` INT(11) NOT NULL,
	`id_cliente` INT(11) NOT NULL,
	`id_impianto` INT(11) NULL DEFAULT NULL,
	`id_mail` INT(11) NULL DEFAULT NULL,
	`mail` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`data_invio` DATETIME NOT NULL,
	`processato` BIT(1) NOT NULL DEFAULT b'0',
	`errore_processamento` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `FK_campagna_aries_mail_campagna_aries` (`id_campagna_aries`) USING BTREE,
	INDEX `FK_campagna_aries_mail_clienti` (`id_cliente`) USING BTREE,
	INDEX `FK_campagna_aries_mail_impianto` (`id_impianto`) USING BTREE,
	INDEX `FK_campagna_aries_mail_mail` (`id_mail`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_mail_campagna_aries` FOREIGN KEY (`id_campagna_aries`) REFERENCES `campagna_aries` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_campagna_aries_mail_clienti` FOREIGN KEY (`id_cliente`) REFERENCES `clienti` (`Id_cliente`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_campagna_aries_mail_impianto` FOREIGN KEY (`id_impianto`) REFERENCES `impianto` (`Id_impianto`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT `FK_campagna_aries_mail_mail` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`Id`) ON UPDATE CASCADE ON DELETE RESTRICT
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


CREATE TABLE `campagna_aries_mail_dati` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_campagna_aries_mail` INT(11) NOT NULL,
	`id_campagna_aries_segnaposto` INT(11) NOT NULL,
	`valore` MEDIUMTEXT NOT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `FK_campagna_aries_mail_dati_campagna_aries_mail` (`id_campagna_aries_mail`) USING BTREE,
	INDEX `FK_campagna_aries_mail_dati_campagna_aries_segnaposto` (`id_campagna_aries_segnaposto`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_mail_dati_campagna_aries_mail` FOREIGN KEY (`id_campagna_aries_mail`) REFERENCES `campagna_aries_mail` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_campagna_aries_mail_dati_campagna_aries_segnaposto` FOREIGN KEY (`id_campagna_aries_segnaposto`) REFERENCES `campagna_aries_segnaposto` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `campagna_aries`
	CHANGE COLUMN `data_attivazione` `data_attivazione` DATETIME NULL AFTER `mail_template_path`,
	CHANGE COLUMN `data_disattivazione` `data_disattivazione` DATETIME NULL AFTER `data_attivazione`;

-- ==========================================================
-- STEP 1: Add uuid column (nullable) after `id`
-- ==========================================================

ALTER TABLE campagna_aries ADD COLUMN uuid CHAR(36) NULL AFTER id;
ALTER TABLE tipo_campagna_aries ADD COLUMN uuid CHAR(36) NULL AFTER id;
ALTER TABLE campagna_aries_segnaposto ADD COLUMN uuid CHAR(36) NULL AFTER id;
ALTER TABLE campagna_aries_mail ADD COLUMN uuid CHAR(36) NULL AFTER id;
ALTER TABLE campagna_aries_mail_dati ADD COLUMN uuid CHAR(36) NULL AFTER id;

-- ==========================================================
-- STEP 2: Populate existing rows with UUID values
-- (MySQL 5.5 supports UUID() but not as default column value)
-- ==========================================================

UPDATE campagna_aries SET uuid = UUID() WHERE uuid IS NULL;
UPDATE tipo_campagna_aries SET uuid = UUID() WHERE uuid IS NULL;
UPDATE campagna_aries_segnaposto SET uuid = UUID() WHERE uuid IS NULL;
UPDATE campagna_aries_mail SET uuid = UUID() WHERE uuid IS NULL;
UPDATE campagna_aries_mail_dati SET uuid = UUID() WHERE uuid IS NULL;

-- ==========================================================
-- STEP 3: Enforce NOT NULL and add indexes
-- ==========================================================

ALTER TABLE campagna_aries 
    MODIFY uuid CHAR(36) NOT NULL,
    ADD UNIQUE INDEX idx_campagna_aries_uuid (uuid);

ALTER TABLE tipo_campagna_aries 
    MODIFY uuid CHAR(36) NOT NULL,
    ADD UNIQUE INDEX idx_tipo_campagna_aries_uuid (uuid);

ALTER TABLE campagna_aries_segnaposto
    MODIFY uuid CHAR(36) NOT NULL,
    ADD UNIQUE INDEX idx_placeholder_campagna_aries_uuid (uuid);

ALTER TABLE campagna_aries_mail
    MODIFY uuid CHAR(36) NOT NULL,
    ADD UNIQUE INDEX idx_mail_campagna_aries_uuid (uuid);

ALTER TABLE campagna_aries_mail_dati
    MODIFY uuid CHAR(36) NOT NULL,
    ADD UNIQUE INDEX idx_mail_data_campagna_aries_uuid (uuid);


DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DELETE FROM configurazione_percorsi WHERE Tipo_percorso = 'CAMPAGNE';
	INSERT INTO configurazione_percorsi 
	SELECT 
		CONCAT(percorso, 'CAMPAGNE\\'),
		'CAMPAGNE'
	FROM configurazione_percorsi 
	WHERE Tipo_percorso = 'DEFAULT';

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 

ALTER TABLE `campagna_aries`
	ADD COLUMN `oggetto_mail` TEXT NULL AFTER `descrizione`;


UPDATE campagna_aries SET oggetto_mail = "test";


ALTER TABLE `campagna_aries`
	CHANGE COLUMN `descrizione` `descrizione` TEXT NOT NULL COLLATE 'latin1_swedish_ci' AFTER `nome`;


ALTER TABLE `mail`
	ADD COLUMN `Indirizzo_mittente` VARCHAR(150) NULL DEFAULT NULL AFTER `Corpo`,
	ADD COLUMN `Indirizzo_risposta` VARCHAR(150) NULL DEFAULT NULL AFTER `Indirizzo_mittente`,
	ADD COLUMN `Risposto` BIT(1) NOT NULL DEFAULT b'0' AFTER `Letto`;

UPDATE mail m
INNER JOIN utente ON m.Id_mittente = utente.Id_utente
 SET indirizzo_mittente = IFNULL(utente.mail, 'no-email-defined');
 
 
 ALTER TABLE `mail`
	CHANGE COLUMN `Indirizzo_mittente` `Indirizzo_mittente` VARCHAR(150) NOT NULL COLLATE 'latin1_swedish_ci' AFTER `Corpo`;

ALTER TABLE `fattura_configurazione`
	ADD COLUMN `estratto_conto_reply_to_email` VARCHAR(150) NULL DEFAULT NULL AFTER `estratto_conto_testo_mail`,
	ADD COLUMN `estratto_conto_id_mittente_default` INT NULL DEFAULT NULL AFTER `estratto_conto_reply_to_email`,
	ADD CONSTRAINT `FK_fattura_conf_estratto_conto_mittente` FOREIGN KEY (`estratto_conto_id_mittente_default`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL;


ALTER TABLE `fattura_configurazione`
	CHANGE COLUMN `estratto_conto_id_mittente_default` `estratto_conto_indirizzo_mittente` VARCHAR(150) NULL DEFAULT NULL AFTER `estratto_conto_reply_to_email`,
	DROP INDEX `FK_fattura_conf_estratto_conto_mittente`,
	DROP FOREIGN KEY `FK_fattura_conf_estratto_conto_mittente`;
	
ALTER TABLE `mail`
	ADD COLUMN `Conferma_lettura` BIT(1) NOT NULL DEFAULT b'0' AFTER `Risposto`;

UPDATE mail m
INNER JOIN utente ON m.Id_mittente = utente.Id_utente
 SET Conferma_lettura = utente.conferma;
