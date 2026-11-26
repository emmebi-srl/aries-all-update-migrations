-- WhatsApp messages not linked to a campaign (or linked to a campaign without notification addresses):
-- CampaignWhatsappReplyNotificationJob forwards them by email to these fallback addresses
-- (";" or "," separated), set from the web app ("Impostazioni" of the WhatsApp messages). Empty = the
-- reply_to of the campaign email account, as before.
SET @whatsapp_fallback_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'configurazione_account_whatsapp'
      AND COLUMN_NAME = 'notifica_messaggi_fallback'
  ),
  'SELECT 1',
  'ALTER TABLE `configurazione_account_whatsapp` ADD COLUMN `notifica_messaggi_fallback` VARCHAR(1000) NULL DEFAULT NULL COMMENT ''Email per i messaggi ricevuti senza campagna (separate da ;)'''
);
PREPARE whatsapp_fallback_statement FROM @whatsapp_fallback_sql;
EXECUTE whatsapp_fallback_statement;
DEALLOCATE PREPARE whatsapp_fallback_statement;
