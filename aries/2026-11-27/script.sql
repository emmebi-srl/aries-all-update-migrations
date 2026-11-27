-- SDICoop state of the invoices sent through the Sistema di Interscambio (SdICoopService).
-- sdi_stato values: see Emmebi.Aries.Shared.Invoice.Bol.Enums.InvoiceSdIStatus (dotnet-server-solution).
-- Updating these columns must not change data_ultima_modifica: it is not an edit of the invoice.

SET @sdi_stato_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_stato'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_stato` TINYINT UNSIGNED NULL DEFAULT NULL COMMENT ''Stato SDICoop (InvoiceSdIStatus): NULL = mai inviata tramite SDICoop'' AFTER `movimenta_magazzino`'
);
PREPARE sdi_stato_statement FROM @sdi_stato_sql;
EXECUTE sdi_stato_statement;
DEALLOCATE PREPARE sdi_stato_statement;

SET @sdi_identificativo_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_identificativo'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_identificativo` VARCHAR(20) NULL DEFAULT NULL COMMENT ''IdentificativoSdI restituito da SdIRiceviFile'' AFTER `sdi_stato`'
);
PREPARE sdi_identificativo_statement FROM @sdi_identificativo_sql;
EXECUTE sdi_identificativo_statement;
DEALLOCATE PREPARE sdi_identificativo_statement;

SET @sdi_nome_file_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_nome_file'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_nome_file` VARCHAR(60) NULL DEFAULT NULL COMMENT ''Nome del file inviato al SdI'' AFTER `sdi_identificativo`'
);
PREPARE sdi_nome_file_statement FROM @sdi_nome_file_sql;
EXECUTE sdi_nome_file_statement;
DEALLOCATE PREPARE sdi_nome_file_statement;

SET @sdi_data_stato_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_data_stato'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_data_stato` DATETIME NULL DEFAULT NULL COMMENT ''Data dell''''ultimo cambio di stato SDICoop'' AFTER `sdi_nome_file`'
);
PREPARE sdi_data_stato_statement FROM @sdi_data_stato_sql;
EXECUTE sdi_data_stato_statement;
DEALLOCATE PREPARE sdi_data_stato_statement;

SET @sdi_messaggio_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_messaggio'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_messaggio` TEXT NULL DEFAULT NULL COMMENT ''Spiegazione leggibile dello stato, con gli errori dello scarto'' AFTER `sdi_data_stato`'
);
PREPARE sdi_messaggio_statement FROM @sdi_messaggio_sql;
EXECUTE sdi_messaggio_statement;
DEALLOCATE PREPARE sdi_messaggio_statement;

SET @sdi_ricevuta_path_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_ricevuta_path'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_ricevuta_path` VARCHAR(500) NULL DEFAULT NULL COMMENT ''Percorso dell''''ultima ricevuta/notifica SdI'' AFTER `sdi_messaggio`'
);
PREPARE sdi_ricevuta_path_statement FROM @sdi_ricevuta_path_sql;
EXECUTE sdi_ricevuta_path_statement;
DEALLOCATE PREPARE sdi_ricevuta_path_statement;

-- The SdICoopService finds the invoice of a notification by its IdentificativoSdI.
SET @sdi_identificativo_index_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND INDEX_NAME = 'idx_fattura_sdi_identificativo'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD INDEX `idx_fattura_sdi_identificativo` (`sdi_identificativo`)'
);
PREPARE sdi_identificativo_index_statement FROM @sdi_identificativo_index_sql;
EXECUTE sdi_identificativo_index_statement;
DEALLOCATE PREPARE sdi_identificativo_index_statement;

-- Copy of the XML sent to the SdI, kept by the SdICoopService (read by the rejection analysis agent).
SET @sdi_file_path_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_file_path'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_file_path` VARCHAR(500) NULL DEFAULT NULL COMMENT ''Percorso della copia del file inviato al SdI'' AFTER `sdi_ricevuta_path`'
);
PREPARE sdi_file_path_statement FROM @sdi_file_path_sql;
EXECUTE sdi_file_path_statement;
DEALLOCATE PREPARE sdi_file_path_statement;

-- JSON produced by the analista-scarti-sdi agent for a rejection: message, what to fix, who can fix it.
SET @sdi_diagnosi_json_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_diagnosi_json'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_diagnosi_json` TEXT NULL DEFAULT NULL COMMENT ''Diagnosi dell''''agente AI sull''''ultimo scarto/rifiuto SdI'' AFTER `sdi_file_path`'
);
PREPARE sdi_diagnosi_json_statement FROM @sdi_diagnosi_json_sql;
EXECUTE sdi_diagnosi_json_statement;
DEALLOCATE PREPARE sdi_diagnosi_json_statement;

SET @sdi_diagnosi_data_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fattura' AND COLUMN_NAME = 'sdi_diagnosi_data'
  ),
  'SELECT 1',
  'ALTER TABLE `fattura` ADD COLUMN `sdi_diagnosi_data` DATETIME NULL DEFAULT NULL COMMENT ''Data della diagnosi AI'' AFTER `sdi_diagnosi_json`'
);
PREPARE sdi_diagnosi_data_statement FROM @sdi_diagnosi_data_sql;
EXECUTE sdi_diagnosi_data_statement;
DEALLOCATE PREPARE sdi_diagnosi_data_statement;

-- Emmebi only: OpenClaw agent analista-scarti-sdi, reached through the backend API bridge with its own key
-- (client aries-sdi). Inserted disabled: set credenziali_json and attivo after the OpenClaw deploy
-- (dotnet-server-solution/docs/sdicoop-deploy.md).
DROP PROCEDURE IF EXISTS `sp_tmp_agente_ai_configurazione_sdi`;

DELIMITER //

CREATE PROCEDURE `sp_tmp_agente_ai_configurazione_sdi`()
BEGIN
	DECLARE is_emmebi BIT(1) DEFAULT b'0';

	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM `azienda`
	WHERE `partita_iva` = '04371390263';

	IF is_emmebi THEN
		INSERT INTO `agente_ai_configurazione` (
			`uuid`,
			`codice`,
			`descrizione`,
			`rif_applicazione`,
			`provider`,
			`tipo_configurazione`,
			`endpoint`,
			`modello`,
			`agente`,
			`configurazione_json`,
			`credenziali_json`,
			`email_notifiche_json`,
			`timeout_secondi`,
			`elimina_sessione_dopo_esito`,
			`attivo`,
			`data_ins`
		)
		VALUES (
			UUID(),
			'analista_scarti_sdi',
			'Diagnosi degli scarti e dei rifiuti SdI tramite agente AI',
			'sdi',
			'openclaw',
			'openai_responses',
			'http://192.168.12.239:18890/v1/responses',
			'openclaw/analista-scarti-sdi',
			'analista-scarti-sdi',
			'{"schema_version":"1.0","require_request_id":true,"retry_base_seconds":5,"request_options":{"stream":false}}',
			'{}',
			'["amministrazione@emmebi.tv.it"]',
			300,
			b'1',
			b'0',
			NOW()
		)
		ON DUPLICATE KEY UPDATE
			`descrizione` = VALUES(`descrizione`),
			`rif_applicazione` = VALUES(`rif_applicazione`),
			`provider` = VALUES(`provider`),
			`tipo_configurazione` = VALUES(`tipo_configurazione`),
			`endpoint` = VALUES(`endpoint`),
			`modello` = VALUES(`modello`),
			`agente` = VALUES(`agente`),
			`configurazione_json` = VALUES(`configurazione_json`),
			`timeout_secondi` = VALUES(`timeout_secondi`),
			`elimina_sessione_dopo_esito` = VALUES(`elimina_sessione_dopo_esito`);
	END IF;
END//

DELIMITER ;

CALL `sp_tmp_agente_ai_configurazione_sdi`();

DROP PROCEDURE IF EXISTS `sp_tmp_agente_ai_configurazione_sdi`;
