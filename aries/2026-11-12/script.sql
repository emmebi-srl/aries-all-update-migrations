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
