-- WhatsApp Business Cloud API: account configuration, received messages and per campaign
-- recipients of the reply notifications.

-- 1. Who gets an email when a customer replies on WhatsApp to a campaign
--    (list of addresses separated by ";" or ","). Empty: reply_to_address of the campaign,
--    then reply_to of the email account.
SET @campaign_whatsapp_notification_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'campagna_aries'
      AND COLUMN_NAME = 'whatsapp_reply_notification_addresses'
  ),
  'SELECT 1',
  'ALTER TABLE `campagna_aries` ADD COLUMN `whatsapp_reply_notification_addresses` VARCHAR(500) NULL DEFAULT NULL AFTER `reply_to_address`'
);
PREPARE campaign_whatsapp_notification_statement FROM @campaign_whatsapp_notification_sql;
EXECUTE campaign_whatsapp_notification_statement;
DEALLOCATE PREPARE campaign_whatsapp_notification_statement;

-- 2. WhatsApp Business account (same idea as configurazione_account_email).
CREATE TABLE IF NOT EXISTS `configurazione_account_whatsapp` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`descrizione` VARCHAR(100) NOT NULL DEFAULT '',
	`rif_applicazione` VARCHAR(50) NOT NULL,
	`id_numero_telefono` VARCHAR(50) NOT NULL COMMENT 'Phone number id (Meta), non il numero',
	`id_account_business` VARCHAR(50) NULL DEFAULT NULL COMMENT 'WhatsApp Business Account id',
	`access_token` TEXT NOT NULL COMMENT 'Token permanente del System User',
	`app_secret` VARCHAR(100) NOT NULL COMMENT 'Verifica della firma X-Hub-Signature-256 del webhook',
	`verify_token` VARCHAR(100) NOT NULL COMMENT 'Token scelto da noi per la registrazione del webhook',
	`versione_api` VARCHAR(10) NULL DEFAULT NULL COMMENT 'Es. v25.0; NULL = default del proxy',
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_configurazione_account_whatsapp_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_configurazione_account_whatsapp_rif` (`rif_applicazione`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

-- 3. Messages written by the customers (replies, button presses). The unique wamid makes the
--    webhook idempotent: Meta can deliver the same notification more than once.
CREATE TABLE IF NOT EXISTS `campagna_aries_whatsapp_messaggio_ricevuto` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`id_campagna_aries_whatsapp` INT(11) NULL DEFAULT NULL COMMENT 'NULL se non riconducibile a una campagna',
	`id_messaggio_whatsapp` VARCHAR(128) NOT NULL,
	`telefono_mittente` VARCHAR(20) NOT NULL,
	`nome_mittente` VARCHAR(255) NULL DEFAULT NULL,
	`tipo` VARCHAR(30) NOT NULL,
	`testo` TEXT NULL DEFAULT NULL,
	`payload_bottone` VARCHAR(255) NULL DEFAULT NULL,
	`data_ricezione` DATETIME NOT NULL,
	`data_notifica` DATETIME NULL DEFAULT NULL,
	`tentativi_notifica` TINYINT(4) NOT NULL DEFAULT 0,
	`errore_notifica` MEDIUMTEXT NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_messaggio_ricevuto_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_campagna_aries_whatsapp_messaggio_ricevuto_wamid` (`id_messaggio_whatsapp`) USING BTREE,
	INDEX `idx_campagna_aries_whatsapp_messaggio_ricevuto_notifica` (`data_notifica`) USING BTREE,
	INDEX `FK_campagna_aries_whatsapp_messaggio_ricevuto_whatsapp` (`id_campagna_aries_whatsapp`) USING BTREE,
	CONSTRAINT `FK_campagna_aries_whatsapp_messaggio_ricevuto_whatsapp` FOREIGN KEY (`id_campagna_aries_whatsapp`) REFERENCES `campagna_aries_whatsapp` (`id`) ON UPDATE CASCADE ON DELETE SET NULL
)
DEFAULT CHARSET=utf8mb4
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

-- 4. WhatsApp templates approved in WhatsApp Manager, for any use (campaigns or not). Name, language,
--    category and status come from Meta (sync); description and "attivo" are managed in Aries.
CREATE TABLE IF NOT EXISTS `template_whatsapp` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`uuid` CHAR(36) NOT NULL,
	`nome` VARCHAR(100) NOT NULL COMMENT 'Nome del template in WhatsApp Manager',
	`lingua` VARCHAR(10) NOT NULL DEFAULT 'it',
	`descrizione` VARCHAR(500) NULL DEFAULT NULL,
	`categoria` VARCHAR(30) NULL DEFAULT NULL COMMENT 'MARKETING, UTILITY, AUTHENTICATION',
	`stato` VARCHAR(30) NULL DEFAULT NULL COMMENT 'Stato Meta: APPROVED, PENDING, REJECTED, PAUSED, DISABLED',
	`id_meta` VARCHAR(50) NULL DEFAULT NULL,
	`attivo` BIT(1) NOT NULL DEFAULT b'1',
	`data_sincronizzazione` DATETIME NULL DEFAULT NULL,
	`data_ins` DATETIME NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uq_template_whatsapp_uuid` (`uuid`) USING BTREE,
	UNIQUE INDEX `uq_template_whatsapp_nome_lingua` (`nome`, `lingua`) USING BTREE
)
DEFAULT CHARSET=utf8mb4
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;

-- 5. WhatsApp template of the campaign: when it is set the forms let the operator also send the
--    proposal on WhatsApp.
SET @campaign_whatsapp_template_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'campagna_aries'
      AND COLUMN_NAME = 'id_template_whatsapp'
  ),
  'SELECT 1',
  'ALTER TABLE `campagna_aries` ADD COLUMN `id_template_whatsapp` INT(11) NULL DEFAULT NULL AFTER `whatsapp_reply_notification_addresses`, ADD INDEX `FK_campagna_aries_template_whatsapp` (`id_template_whatsapp`), ADD CONSTRAINT `FK_campagna_aries_template_whatsapp` FOREIGN KEY (`id_template_whatsapp`) REFERENCES `template_whatsapp` (`id`) ON UPDATE CASCADE ON DELETE SET NULL'
);
PREPARE campaign_whatsapp_template_statement FROM @campaign_whatsapp_template_sql;
EXECUTE campaign_whatsapp_template_statement;
DEALLOCATE PREPARE campaign_whatsapp_template_statement;

-- 6. Typo in the name of the subscription placeholder. The saved values point to the placeholder id, so
--    they are kept; the email templates of the campaigns must use {{subscription_maintenance_number}}.
UPDATE `campagna_aries_segnaposto`
SET `nome` = 'subscription_maintenance_number'
WHERE `nome` = 'subscription_maintenace_number'
	AND `id_tipo_campagna` = (SELECT id FROM tipo_campagna_aries WHERE uuid = '83ddae04-d05b-4211-8df5-76791801a1e6');

-- Fill in the real values from Meta Business Manager / WhatsApp Manager before enabling the webhook:
-- INSERT INTO `configurazione_account_whatsapp`
-- 	(`uuid`, `descrizione`, `rif_applicazione`, `id_numero_telefono`, `id_account_business`, `access_token`, `app_secret`, `verify_token`, `versione_api`, `data_ins`)
-- VALUES
-- 	(UUID(), 'WhatsApp campagne Aries', 'campaign_aries', '<phone-number-id>', '<waba-id>', '<access-token>', '<app-secret>', '<verify-token>', NULL, NOW());
UPDATE `campagna_aries_segnaposto`
SET `nome` = 'subscription_maintenance_number'
WHERE `nome` = 'subscription_maintenace_number'
	AND `id_tipo_campagna` = (SELECT id FROM tipo_campagna_aries WHERE uuid = '83ddae04-d05b-4211-8df5-76791801a1e6');