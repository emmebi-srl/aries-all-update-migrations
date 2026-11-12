-- Customer reminder campaigns (report groups, quotes, invoices statement) can now also send
-- WhatsApp when the campaign has a template. Meta refuses template variables longer than 20
-- characters, so the longer placeholders get a short WhatsApp name (the email templates keep the
-- full name). Only names not already set by hand are filled.
UPDATE `campagna_aries_segnaposto` s
  INNER JOIN `tipo_campagna_aries` t ON t.`id` = s.`id_tipo_campagna`
SET s.`override_whatsapp_nome` = CASE s.`nome`
    WHEN 'statement_total_amount' THEN 'total_amount'
    WHEN 'statement_expired_amount' THEN 'expired_amount'
    WHEN 'statement_expiring_amount' THEN 'expiring_amount'
    WHEN 'quote_expiration_date' THEN 'expiration_date'
    WHEN 'report_group_email_send_date' THEN 'email_send_date'
    WHEN 'report_group_total_price' THEN 'total_price'
  END
WHERE (s.`override_whatsapp_nome` IS NULL OR s.`override_whatsapp_nome` = '')
  AND (
    (t.`rif_applicazione` = 'customer_invoices_statement'
      AND s.`nome` IN ('statement_total_amount', 'statement_expired_amount', 'statement_expiring_amount'))
    OR (t.`rif_applicazione` = 'quotes_monitoring' AND s.`nome` = 'quote_expiration_date')
    OR (t.`rif_applicazione` = 'report_group_reminders'
      AND s.`nome` IN ('report_group_email_send_date', 'report_group_total_price'))
  );
