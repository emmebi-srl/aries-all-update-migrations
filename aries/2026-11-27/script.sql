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
