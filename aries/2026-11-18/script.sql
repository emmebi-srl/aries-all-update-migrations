-- Sync of the tickets with an expiration date to an external task provider (Google Tasks for now).
-- One way, Aries -> provider, plus the "done" of the provider task, which closes the ticket.
-- The Windows service ExternalSyncService runs the sync; the web app (Impostazioni > Servizi)
-- edits the configuration.

-- 1. Configuration, one row per provider. credenziali is the service account JSON encrypted by the
--    backend (AES-GCM with the ExternalSync:CredentialsKey application setting): never read it here.
CREATE TABLE IF NOT EXISTS `sincronizzazione_esterna_configurazione` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`provider` VARCHAR(30) NOT NULL COMMENT 'google',
	`attivo` TINYINT(1) NOT NULL DEFAULT 0,
	`credenziali` TEXT NULL COMMENT 'JSON del service account, cifrato',
	`email_account_servizio` VARCHAR(255) NULL DEFAULT NULL COMMENT 'client_email del service account',
	`id_utente_predefinito` INT(11) NULL DEFAULT NULL COMMENT 'Utente che riceve i task: utente.mail = account Workspace',
	`id_stato_chiusura` INT(11) NULL DEFAULT NULL COMMENT 'Stato del ticket completato dal provider',
	`nome_lista` VARCHAR(100) NOT NULL DEFAULT 'Ticket Aries',
	`giorni_scadenza_passata` INT(11) NOT NULL DEFAULT 30 COMMENT 'Ticket gia scaduti da al massimo N giorni',
	`data_ultima_esecuzione` DATETIME NULL DEFAULT NULL,
	`data_ultima_esecuzione_riuscita` DATETIME NULL DEFAULT NULL,
	`ultimo_errore` TEXT NULL,
	`task_sincronizzati` INT(11) NOT NULL DEFAULT 0,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`data_mod` DATETIME NULL DEFAULT NULL,
	`utente_ins` INT(11) NULL DEFAULT NULL,
	`utente_mod` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `uq_sincronizzazione_esterna_configurazione_provider` (`provider`),
	CONSTRAINT `FK_sinc_esterna_configurazione_utente` FOREIGN KEY (`id_utente_predefinito`) REFERENCES `utente` (`Id_utente`) ON UPDATE CASCADE ON DELETE SET NULL,
	CONSTRAINT `FK_sinc_esterna_configurazione_stato` FOREIGN KEY (`id_stato_chiusura`) REFERENCES `stato_ticket` (`Id_stato`) ON UPDATE CASCADE ON DELETE SET NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

-- 2. Task list of the provider for each account (created by the sync). data_ultima_lettura is the
--    cursor of the "done" polling: the tasks updated after it are read again.
CREATE TABLE IF NOT EXISTS `sincronizzazione_esterna_lista` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`provider` VARCHAR(30) NOT NULL,
	`account_esterno` VARCHAR(255) NOT NULL COMMENT 'Email Workspace',
	`id_lista_esterna` VARCHAR(255) NOT NULL,
	`nome_lista` VARCHAR(100) NOT NULL,
	`data_ultima_lettura` DATETIME NULL DEFAULT NULL COMMENT 'UTC',
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `uq_sincronizzazione_esterna_lista_account` (`provider`, `account_esterno`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

-- 3. Link ticket -> provider task. No foreign key to ticket: when a ticket is deleted the link stays
--    until the sync deletes its task. hash = SHA-256 of what was last written (title, notes, due date,
--    completed): a different hash means the task must be updated.
CREATE TABLE IF NOT EXISTS `sincronizzazione_esterna_ticket` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`provider` VARCHAR(30) NOT NULL,
	`id_ticket` INT(11) NOT NULL COMMENT 'ticket.Id',
	`account_esterno` VARCHAR(255) NOT NULL,
	`id_lista_esterna` VARCHAR(255) NOT NULL,
	`id_task_esterno` VARCHAR(255) NOT NULL,
	`hash` CHAR(64) NOT NULL,
	`completato` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Stato scritto sul provider',
	`data_ultima_sincronizzazione` DATETIME NOT NULL,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `uq_sincronizzazione_esterna_ticket` (`provider`, `id_ticket`, `account_esterno`),
	INDEX `idx_sincronizzazione_esterna_ticket_task` (`provider`, `id_task_esterno`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

-- 4. Default configuration of Google, disabled. The closing status is the first closed one
--    (CONCLUSO), only set when the row is created: a rerun doesn't override the web app.
INSERT INTO `sincronizzazione_esterna_configurazione` (`provider`, `attivo`, `id_stato_chiusura`)
SELECT 'google', 0, (SELECT MIN(`Id_stato`) FROM `stato_ticket` WHERE `aperto` = b'0')
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sincronizzazione_esterna_configurazione` WHERE `provider` = 'google');

-- 5. The ticket expiration/reminder events follow stato_ticket.aperto instead of the fixed ids 3 and 4.
--    A closed ticket never gets its events back: before, any update of a closed ticket that didn't change
--    the status recreated them.
DROP TRIGGER IF EXISTS trg_beforeTicketUpdate;
DELIMITER //
CREATE TRIGGER `trg_beforeTicketUpdate` BEFORE UPDATE ON `ticket` FOR EACH ROW
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);
	DECLARE user_id INT(11);
	DECLARE is_open TINYINT(1);

	SET user_id = IFNULL(@USER_ID, NEW.id_utente);

	SELECT IFNULL(MAX(stato_ticket.aperto + 0), 1)
	INTO is_open
	FROM stato_ticket
	WHERE stato_ticket.Id_stato = NEW.stato_ticket;

	IF is_open = 0 THEN
		CALL sp_ariesTicketDeleteReminderEvent(NEW.id_ticket, NEW.anno, user_id);
		CALL sp_ariesTicketDeleteExpirationEvent(NEW.id_ticket, NEW.anno, user_id);

		SET NEW.id_evento_promemoria = NULL;
		SET NEW.id_evento_scadenza = NULL;
	ELSE
		IF NEW.data_promemoria IS NULL THEN
			CALL sp_ariesTicketDeleteReminderEvent(NEW.id_ticket, NEW.anno, user_id);
			SET NEW.id_evento_promemoria = NULL;
		ELSE
			CALL sp_ariesTicketEnsureReminderEvent(
				NEW.id_ticket,
				NEW.anno,
				NEW.id_impianto,
				NEW.id_cliente,
				NEW.urgenza,
				NEW.data_promemoria,
				NEW.id_evento_promemoria,
				NEW.scadenza,
				NEW.id_evento_scadenza,
				NEW.descrizione,
				user_id,
				reminder_event_id
			);
			SET NEW.id_evento_promemoria = reminder_event_id;
		END IF;

		IF NEW.scadenza IS NULL THEN
			CALL sp_ariesTicketDeleteExpirationEvent(NEW.id_ticket, NEW.anno, user_id);
			SET NEW.id_evento_scadenza = NULL;
		ELSE
			CALL sp_ariesTicketEnsureExpirationEvent(
				NEW.id_ticket,
				NEW.anno,
				NEW.id_impianto,
				NEW.id_cliente,
				NEW.urgenza,
				NEW.data_promemoria,
				NEW.id_evento_promemoria,
				NEW.scadenza,
				NEW.id_evento_scadenza,
				NEW.descrizione,
				user_id,
				expiration_event_id
			);
			SET NEW.id_evento_scadenza = expiration_event_id;
		END IF;
	END IF;
END
//
DELIMITER ;
