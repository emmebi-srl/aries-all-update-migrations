-- WhatsApp free text replies written by the operators from the web app. Meta accepts them only
-- within 24 hours from the last message of the customer (customer service window); outside of it
-- only approved templates can be sent. The conversation is the phone number: received messages
-- (campagna_aries_whatsapp_messaggio_ricevuto.telefono_mittente) and these replies share the
-- digits-only format of the Meta "from" field (e.g. 393331234567).
CREATE TABLE IF NOT EXISTS `campagna_aries_whatsapp_messaggio_inviato` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`id_campagna_aries_whatsapp` INT(11) NULL DEFAULT NULL COMMENT 'Campagna della conversazione, NULL se non riconducibile',
	`telefono_destinatario` VARCHAR(20) NOT NULL COMMENT 'Solo cifre, come telefono_mittente dei messaggi ricevuti',
	`id_messaggio_whatsapp` VARCHAR(128) NULL DEFAULT NULL COMMENT 'NULL se Meta ha rifiutato l invio',
	`testo` TEXT NOT NULL,
	`stato` VARCHAR(20) NOT NULL COMMENT 'sent, delivered, read, failed',
	`errore` MEDIUMTEXT NULL DEFAULT NULL,
	`data_invio` DATETIME NOT NULL,
	`data_consegna` DATETIME NULL DEFAULT NULL,
	`data_lettura` DATETIME NULL DEFAULT NULL,
	`id_utente` INT(11) NULL DEFAULT NULL COMMENT 'Operatore che ha scritto la risposta',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_messaggio_inviato_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_messaggio_inviato_wamid` (`id_messaggio_whatsapp`) USING BTREE,
	INDEX `idx_campagna_aries_whatsapp_messaggio_inviato_telefono` (`telefono_destinatario`, `data_invio`) USING BTREE,
	INDEX `FK_campagna_aries_whatsapp_messaggio_inviato_whatsapp` (`id_campagna_aries_whatsapp`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_whatsapp_messaggio_inviato_whatsapp` FOREIGN KEY (`id_campagna_aries_whatsapp`) REFERENCES `campagna_aries_whatsapp` (`id`) ON UPDATE CASCADE ON DELETE SET NULL
)
DEFAULT CHARSET=utf8mb4
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

-- The conversation reads the received messages of one number, newest first.
SET @index_exists = (
	SELECT COUNT(*) FROM information_schema.statistics
	WHERE table_schema = DATABASE()
		AND table_name = 'campagna_aries_whatsapp_messaggio_ricevuto'
		AND index_name = 'idx_campagna_aries_whatsapp_messaggio_ricevuto_telefono'
);
SET @sql = IF(@index_exists = 0,
	'ALTER TABLE `campagna_aries_whatsapp_messaggio_ricevuto` ADD INDEX `idx_campagna_aries_whatsapp_messaggio_ricevuto_telefono` (`telefono_mittente`, `data_ricezione`)',
	'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Quote reminders: sending the current revision of a quote (also a new revision of a quote
-- already sent) restarts primo/secondo sollecito and data_invio. Same procedure as 2026-09-16
-- except the "prev" branch.
DROP PROCEDURE IF EXISTS sp_ariesEmailSetDocumentStatus;
DELIMITER //
CREATE PROCEDURE `sp_ariesEmailSetDocumentStatus`(
  IN `email_id` INT(11)
)
BEGIN
  DECLARE DocumentType VARCHAR(30);
  DECLARE DocumentId VARCHAR(10);
  DECLARE DocumentYear VARCHAR(10);
  DECLARE DocumentReview VARCHAR(10);
  DECLARE StatusId INT(11);
  DECLARE EmailSendDate DATETIME;
  DECLARE SystemId INT(11);
  DECLARE ReminderNumber TINYINT;

  SELECT
    mail.Tipo_documento,
    mail.Id_documento,
    mail.Anno_documento,
    mail.Revisione_documento,
    mail.Id_stato,
    mail.Data_invio
  INTO
    DocumentType,
    DocumentId,
    DocumentYear,
    DocumentReview,
    StatusId,
    EmailSendDate
  FROM mail
  WHERE Id = email_id;

  IF (DocumentType IS NOT NULL)
    AND (StatusId = 1
      OR DocumentType = 'rapporto_mobile_intervento'
      OR DocumentType = 'rapporto_mobile_collaudo') THEN

    IF DocumentType = 'prev' THEN
      UPDATE revisione_preventivo
      SET inviato = 1
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND id_revisione = DocumentReview;

      UPDATE preventivo
      SET stato = 3,
          data_invio = CURDATE()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND stato IN (5, 6);

      -- Sending the current revision restarts the reminders from today. A new revision is
      -- sent while the quote is already "inviato" (3): the update above skips it and the
      -- status trigger doesn't clear the reminders, so the job kept counting from the first send.
      UPDATE preventivo
      SET data_invio = CURDATE(),
          primo_sollecito = NULL,
          secondo_sollecito = NULL
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND revisione = DocumentReview
        AND stato = 3;
    END IF;

    IF DocumentType = 'sollecito_preventivo'
      AND DocumentId IS NOT NULL
      AND NOT EXISTS (
        SELECT 1
        FROM campagna_aries_mail
        WHERE id_mail = email_id
      ) THEN
      UPDATE preventivo
      SET secondo_sollecito = NOW()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND primo_sollecito IS NOT NULL;

      UPDATE preventivo
      SET primo_sollecito = NOW()
      WHERE id_preventivo = DocumentId
        AND anno = DocumentYear
        AND primo_sollecito IS NULL;
    END IF;

    IF DocumentType = 'fatt' THEN
      UPDATE fattura
      SET inviato = 1
      WHERE id_fattura = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'tk' THEN
      SELECT IFNULL(Id_impianto, -1)
      INTO SystemId
      FROM Ticket
      WHERE Id = DocumentId;

      UPDATE ticket
      SET Stato_ticket = 2,
          inviato = 1
      WHERE id_impianto = SystemId;
    END IF;

    IF DocumentType = 'COMMESSA' THEN
      UPDATE commessa
      SET inv_com = 1
      WHERE id_commessa = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'reso' THEN
      UPDATE resoconto
      SET inviato = 1,
          data_invio = COALESCE(EmailSendDate, NOW())
      WHERE id_resoconto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'ordine' THEN
      UPDATE ordine_fornitore
      SET inviato = 1
      WHERE id_Ordine = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'fatt1' THEN
      UPDATE fattura
      SET inviato = 1
      WHERE id_fattura = DocumentId
        AND anno = DocumentYear;

      UPDATE clienti
      SET rc = 1
      WHERE id_cliente = (
        SELECT id_cliente
        FROM fattura
        WHERE id_fattura = DocumentId
          AND anno = DocumentYear
      );
    END IF;

    IF DocumentType = 'rapporto_mobile_intervento' THEN
      UPDATE rapporto_mobile
      SET inviato = 1
      WHERE Id_rapporto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'rapporto_mobile_collaudo' THEN
      UPDATE rapporto_mobile_collaudo
      SET inviato = 1
      WHERE Id_rapporto = DocumentId
        AND anno = DocumentYear;
    END IF;

    IF DocumentType = 'cliente_estratto_conto' AND DocumentId IS NOT NULL THEN
      CALL sp_ariesCustomerInvoicesStatementInsert(email_id, DocumentId);
    END IF;
  END IF;
END//
DELIMITER ;

-- Passkeys (WebAuthn) of the users, to log in to the web app without a password. The public key is
-- stored as returned by the authenticator (COSE); the private key never leaves the user's device.
-- credential_id is the base64url credential id (unique per authenticator), user_handle is the random
-- id the authenticator keeps for the user (the same for all the passkeys of a user).
CREATE TABLE IF NOT EXISTS `utente_passkey` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_utente` INT(11) NOT NULL,
	`credential_id` VARCHAR(512) NOT NULL COMMENT 'base64url',
	`public_key` BLOB NOT NULL COMMENT 'Chiave pubblica COSE',
	`user_handle` VARBINARY(64) NOT NULL,
	`sign_count` INT(10) UNSIGNED NOT NULL DEFAULT '0',
	`transports` VARCHAR(100) NULL DEFAULT NULL COMMENT 'internal, hybrid, usb, nfc, ble separati da virgola',
	`aaguid` VARCHAR(36) NULL DEFAULT NULL COMMENT 'Modello dell autenticatore',
	`backup_eligible` TINYINT(1) NOT NULL DEFAULT '0',
	`backed_up` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Sincronizzata (iCloud, Google, ...)',
	`nome` VARCHAR(100) NOT NULL,
	`data_creazione` DATETIME NOT NULL,
	`data_ultimo_utilizzo` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE KEY `UK_utente_passkey_credential_id` (`credential_id`),
	KEY `FK_utente_passkey_utente` (`id_utente`),
	CONSTRAINT `FK_utente_passkey_utente` FOREIGN KEY (`id_utente`) REFERENCES `utente` (`Id_utente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
