-- Statuses flagged with 1 are excluded from statistics (report groups and quotes).
SET @report_group_status_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stato_resoconto'
      AND COLUMN_NAME = 'escludi_da_statistiche'
  ),
  'SELECT 1',
  'ALTER TABLE `stato_resoconto` ADD COLUMN `escludi_da_statistiche` TINYINT(1) NOT NULL DEFAULT 0'
);
PREPARE report_group_status_statement FROM @report_group_status_sql;
EXECUTE report_group_status_statement;
DEALLOCATE PREPARE report_group_status_statement;

SET @quote_status_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'stato_preventivo'
      AND COLUMN_NAME = 'escludi_da_statistiche'
  ),
  'SELECT 1',
  'ALTER TABLE `stato_preventivo` ADD COLUMN `escludi_da_statistiche` TINYINT(1) NOT NULL DEFAULT 0'
);
PREPARE quote_status_statement FROM @quote_status_sql;
EXECUTE quote_status_statement;
DEALLOCATE PREPARE quote_status_statement;
