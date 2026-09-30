-- Campaign types flagged with 0 do not get the automatic unsubscribe footer
-- (e.g. transactional/service reminders). Default 1 keeps the current behaviour.
SET @campaign_type_unsubscription_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'tipo_campagna_aries'
      AND COLUMN_NAME = 'disiscrizione_abilitata'
  ),
  'SELECT 1',
  'ALTER TABLE `tipo_campagna_aries` ADD COLUMN `disiscrizione_abilitata` TINYINT(1) NOT NULL DEFAULT 1 AFTER `avviso_disiscrizione`'
);
PREPARE campaign_type_unsubscription_statement FROM @campaign_type_unsubscription_sql;
EXECUTE campaign_type_unsubscription_statement;
DEALLOCATE PREPARE campaign_type_unsubscription_statement;

-- Report group reminders are service communications: no unsubscribe footer.
UPDATE `tipo_campagna_aries`
SET `disiscrizione_abilitata` = 0
WHERE `rif_applicazione` = 'report_group_reminders';
