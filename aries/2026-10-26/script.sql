-- Campaign dispatch split: a campaign "dispatch" (the proposal sent to a customer for a system) is now
-- separated from the channels used to deliver it.
--
--   campagna_aries_dispatch        <- former campagna_aries_mail (same ids: landing links, data,
--                                     attachments, acceptances and requests keep pointing to it)
--   stato_campagna_aries_dispatch  <- former stato_campagna_aries_mail (outcome/funnel status)
--   campagna_aries_mail            <- NEW: email channel of a dispatch (address, mail id, delivery status)
--   campagna_aries_whatsapp        <- NEW: WhatsApp channel of a dispatch
--   stato_campagna_aries_canale    <- NEW: delivery status shared by the channels
--
-- NOT idempotent: run it exactly once.

-- 1. The old BEFORE UPDATE trigger writes columns that are moving to the channel table.
DROP TRIGGER IF EXISTS `trg_beforeCampaignMailUpdate`;

-- 2. Rename: ids, data and the foreign keys pointing to these tables are preserved.
RENAME TABLE
	`campagna_aries_mail` TO `campagna_aries_dispatch`,
	`stato_campagna_aries_mail` TO `stato_campagna_aries_dispatch`;

-- Some colors were saved with a leading TAB.
UPDATE `stato_campagna_aries_dispatch`
SET `colore` = TRIM(REPLACE(`colore`, CHAR(9), ''));

-- 3. Constraint names are unique per schema: free the old names for the new channel table.
ALTER TABLE `campagna_aries_dispatch`
	DROP FOREIGN KEY `FK_campagna_aries_mail_campagna_aries`,
	DROP FOREIGN KEY `FK_campagna_aries_mail_clienti`,
	DROP FOREIGN KEY `FK_campagna_aries_mail_impianto`,
	DROP FOREIGN KEY `FK_campagna_aries_mail_mail`,
	DROP FOREIGN KEY `FK_campagna_aries_mail_stato`;

ALTER TABLE `campagna_aries_dispatch`
	ADD CONSTRAINT `FK_campagna_aries_dispatch_campagna_aries` FOREIGN KEY (`id_campagna_aries`) REFERENCES `campagna_aries` (`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_campagna_aries_dispatch_clienti` FOREIGN KEY (`id_cliente`) REFERENCES `clienti` (`Id_cliente`) ON UPDATE CASCADE ON DELETE RESTRICT,
	ADD CONSTRAINT `FK_campagna_aries_dispatch_impianto` FOREIGN KEY (`id_impianto`) REFERENCES `impianto` (`Id_impianto`) ON UPDATE NO ACTION ON DELETE NO ACTION,
	ADD CONSTRAINT `FK_campagna_aries_dispatch_stato` FOREIGN KEY (`id_stato`) REFERENCES `stato_campagna_aries_dispatch` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;

-- 4. Channel delivery status (id 1 = waiting_for_send is the column default, as for the dispatch).
CREATE TABLE `stato_campagna_aries_canale` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL COLLATE 'latin1_swedish_ci',
	`nome` VARCHAR(30) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`rif_applicazione` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`descrizione` VARCHAR(100) NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`finale` BIT(1) NOT NULL DEFAULT b'0',
	`colore` VARCHAR(30) NOT NULL DEFAULT '0' COLLATE 'latin1_swedish_ci',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_stato_campagna_aries_canale_rif` (`rif_applicazione`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO `stato_campagna_aries_canale` (`id`, `uuid`, `nome`, `rif_applicazione`, `descrizione`, `finale`, `colore`, `data_ins`) VALUES
	(1, UUID(), 'IN ATTESA DI INVIO', 'waiting_for_send', '', b'0', '$00FFFF', NOW()),
	(2, UUID(), 'INVIATO', 'sent', '', b'0', '$E6D8AD', NOW()),
	(3, UUID(), 'CONSEGNATO', 'delivered', 'Consegna confermata dal provider (WhatsApp)', b'0', '$FFFFE0', NOW()),
	(4, UUID(), 'LETTO', 'read', '', b'1', '$90EE90', NOW()),
	(5, UUID(), 'CONSEGNA FALLITA', 'failed', 'Consegna rifiutata dal provider (WhatsApp)', b'1', '$0000FF', NOW()),
	(6, UUID(), 'ERRORE DI PROCESSAMENTO', 'processing_error', '', b'1', '$0000FF', NOW()),
	(7, UUID(), 'ANNULLATO - DISISCRITTO', 'sending_skipped_unsubscribed', 'Destinatario disiscritto dal tipo campagna', b'1', '$C0C0C0', NOW());

-- 5. Email channel.
CREATE TABLE `campagna_aries_mail` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL COLLATE 'latin1_swedish_ci',
	`id_campagna_aries_dispatch` INT(11) NOT NULL,
	`id_mail` INT(11) NULL DEFAULT NULL,
	`mail` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`id_stato` INT(11) NOT NULL DEFAULT '1',
	`processato` BIT(1) NOT NULL DEFAULT b'0',
	`data_invio` DATETIME NULL DEFAULT NULL,
	`letto` BIT(1) NOT NULL DEFAULT b'0',
	`disiscritto` BIT(1) NOT NULL DEFAULT b'0',
	`errore_processamento` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_mail_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_mail_dispatch` (`id_campagna_aries_dispatch`) USING BTREE,
	INDEX `FK_campagna_aries_mail_mail` (`id_mail`) USING BTREE,
	INDEX `FK_campagna_aries_mail_stato` (`id_stato`) USING BTREE,
	INDEX `idx_campagna_aries_mail_processato` (`processato`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_mail_dispatch` FOREIGN KEY (`id_campagna_aries_dispatch`) REFERENCES `campagna_aries_dispatch` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_campagna_aries_mail_mail` FOREIGN KEY (`id_mail`) REFERENCES `mail` (`Id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT `FK_campagna_aries_mail_stato` FOREIGN KEY (`id_stato`) REFERENCES `stato_campagna_aries_canale` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

-- 6. Move the email data of the existing dispatches into the email channel.
INSERT INTO `campagna_aries_mail`
	(`uuid`, `id_campagna_aries_dispatch`, `id_mail`, `mail`, `id_stato`, `processato`, `data_invio`,
	 `letto`, `disiscritto`, `errore_processamento`, `data_ins`)
SELECT
	UUID(),
	dispatch.`id`,
	dispatch.`id_mail`,
	dispatch.`mail`,
	channelStatus.`id`,
	dispatch.`processato`,
	dispatch.`data_invio`,
	dispatch.`letto`,
	dispatch.`disiscritto`,
	dispatch.`errore_processamento`,
	dispatch.`data_ins`
FROM `campagna_aries_dispatch` dispatch
LEFT JOIN `stato_campagna_aries_dispatch` dispatchStatus
	ON dispatchStatus.`id` = dispatch.`id_stato`
INNER JOIN `stato_campagna_aries_canale` channelStatus
	ON channelStatus.`rif_applicazione` = CASE
		WHEN dispatch.`processato` = 0 THEN 'waiting_for_send'
		WHEN dispatch.`errore_processamento` LIKE 'Invio annullato:%' THEN 'sending_skipped_unsubscribed'
		WHEN dispatchStatus.`rif_applicazione` = 'processing_error'
			OR dispatch.`errore_processamento` IS NOT NULL THEN 'processing_error'
		WHEN dispatch.`letto` = 1 THEN 'read'
		ELSE 'sent'
	END;

-- 7. Drop the email specific columns from the dispatch.
ALTER TABLE `campagna_aries_dispatch`
	DROP INDEX `FK_campagna_aries_mail_mail`,
	DROP COLUMN `id_mail`,
	DROP COLUMN `mail`,
	DROP COLUMN `data_invio`,
	DROP COLUMN `processato`,
	DROP COLUMN `letto`,
	DROP COLUMN `disiscritto`,
	DROP COLUMN `errore_processamento`;

-- 8. WhatsApp channel (WhatsApp Business Cloud API). Template data is a snapshot of what was sent.
CREATE TABLE `campagna_aries_whatsapp` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`id_campagna_aries_dispatch` INT(11) NOT NULL,
	`telefono` VARCHAR(20) NOT NULL COMMENT 'E.164, es. +393331234567',
	`nome_template` VARCHAR(100) NOT NULL,
	`lingua_template` VARCHAR(10) NOT NULL DEFAULT 'it',
	`id_messaggio_whatsapp` VARCHAR(128) NULL DEFAULT NULL COMMENT 'wamid restituito dalle API Meta',
	`id_stato` INT(11) NOT NULL DEFAULT '1',
	`processato` BIT(1) NOT NULL DEFAULT b'0',
	`data_invio` DATETIME NULL DEFAULT NULL,
	`data_consegna` DATETIME NULL DEFAULT NULL,
	`data_lettura` DATETIME NULL DEFAULT NULL,
	`letto` BIT(1) NOT NULL DEFAULT b'0',
	`disiscritto` BIT(1) NOT NULL DEFAULT b'0',
	`codice_errore` VARCHAR(20) NULL DEFAULT NULL,
	`errore_processamento` MEDIUMTEXT NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_dispatch` (`id_campagna_aries_dispatch`) USING BTREE,
	INDEX `idx_campagna_aries_whatsapp_messaggio` (`id_messaggio_whatsapp`) USING BTREE,
	INDEX `idx_campagna_aries_whatsapp_processato` (`processato`) USING BTREE,
	INDEX `FK_campagna_aries_whatsapp_stato` (`id_stato`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_whatsapp_dispatch` FOREIGN KEY (`id_campagna_aries_dispatch`) REFERENCES `campagna_aries_dispatch` (`id`) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT `FK_campagna_aries_whatsapp_stato` FOREIGN KEY (`id_stato`) REFERENCES `stato_campagna_aries_canale` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
DEFAULT CHARSET=utf8mb4
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

-- 9. Triggers.
DROP TRIGGER IF EXISTS `trg_afterSubscriptionProposalAcceptanceInsert`;
DROP TRIGGER IF EXISTS `trg_afterMailUpdate`;
DROP TRIGGER IF EXISTS `trg_beforeCampaignDispatchUpdate`;

DELIMITER $$

CREATE TRIGGER `trg_afterSubscriptionProposalAcceptanceInsert`
AFTER INSERT ON `impianto_accettazione_proposta_abbonamento`
FOR EACH ROW
BEGIN
	IF NEW.`id_campagna_aries_mail` IS NOT NULL THEN
		UPDATE `campagna_aries_dispatch` `campagnaDispatch`
		INNER JOIN `stato_campagna_aries_dispatch` `statoCampagnaDispatch`
			ON `statoCampagnaDispatch`.`rif_applicazione` = 'positive_outcome'
		SET `campagnaDispatch`.`id_stato` = `statoCampagnaDispatch`.`id`
		WHERE `campagnaDispatch`.`id` = NEW.`id_campagna_aries_mail`;
	END IF;
END$$

-- Email opened (tracking pixel): the email channel becomes "read" and the dispatch "viewed",
-- unless the dispatch has already moved further (landing opened, outcome, ...).
CREATE TRIGGER `trg_afterMailUpdate`
AFTER UPDATE ON `mail`
FOR EACH ROW
BEGIN
	IF CAST(OLD.`Letto` AS UNSIGNED) <> CAST(NEW.`Letto` AS UNSIGNED)
		AND CAST(NEW.`Letto` AS UNSIGNED) = 1 THEN
		UPDATE `campagna_aries_mail` `campagnaMail`
		INNER JOIN `stato_campagna_aries_canale` `statoCanale`
			ON `statoCanale`.`rif_applicazione` = 'read'
		SET
			`campagnaMail`.`letto` = b'1',
			`campagnaMail`.`id_stato` = `statoCanale`.`id`
		WHERE `campagnaMail`.`id_mail` = NEW.`Id`;

		UPDATE `campagna_aries_dispatch` `campagnaDispatch`
		INNER JOIN `campagna_aries_mail` `campagnaMail`
			ON `campagnaMail`.`id_campagna_aries_dispatch` = `campagnaDispatch`.`id`
		INNER JOIN `stato_campagna_aries_dispatch` `statoAttuale`
			ON `statoAttuale`.`id` = `campagnaDispatch`.`id_stato`
		INNER JOIN `stato_campagna_aries_dispatch` `statoVisionata`
			ON `statoVisionata`.`rif_applicazione` = 'viewed'
		SET `campagnaDispatch`.`id_stato` = `statoVisionata`.`id`
		WHERE `campagnaMail`.`id_mail` = NEW.`Id`
			AND `statoAttuale`.`rif_applicazione` IN ('waiting_for_send', 'sent');
	END IF;
END$$

CREATE TRIGGER `trg_beforeCampaignDispatchUpdate`
BEFORE UPDATE ON `campagna_aries_dispatch`
FOR EACH ROW
BEGIN
	DECLARE landing_page_opened_status_id INT(11) DEFAULT NULL;

	SELECT `id`
	INTO landing_page_opened_status_id
	FROM `stato_campagna_aries_dispatch`
	WHERE `rif_applicazione` = 'landing_page_opened'
	LIMIT 1;

	IF IFNULL(OLD.`id_stato`, 0) <> IFNULL(NEW.`id_stato`, 0)
		AND NEW.`id_stato` = landing_page_opened_status_id THEN
		SET NEW.`interagito` = b'1';
	END IF;
END$$

DELIMITER ;

-- sp_ariesEmailSetDocumentStatus keeps working unchanged: it checks campagna_aries_mail.id_mail,
-- which still exists on the email channel table.
