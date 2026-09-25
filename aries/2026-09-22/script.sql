-- Optional per-campaign Reply-To. Existing campaigns keep the account default.
SET @campaign_reply_to_sql = IF(
  EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'campagna_aries'
      AND COLUMN_NAME = 'reply_to_address'
  ),
  'SELECT 1',
  'ALTER TABLE `campagna_aries` ADD COLUMN `reply_to_address` VARCHAR(254) NULL DEFAULT NULL'
);
PREPARE campaign_reply_to_statement FROM @campaign_reply_to_sql;
EXECUTE campaign_reply_to_statement;
DEALLOCATE PREPARE campaign_reply_to_statement;

-- Quote validity is measured from the original quote send date.
INSERT INTO `environment_variables` (`var_key`, `var_value`)
SELECT 'QUOTE_EXPIRATION_DAYS', '60'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `environment_variables` WHERE `var_key` = 'QUOTE_EXPIRATION_DAYS'
);

INSERT INTO `cliente_promemoria_segnaposto`
  (`id_cliente_promemoria_configurazione`, `nome`, `descrizione`)
SELECT 9, '{quote_expiration_date}', 'Scadenza preventivo: data invio + QUOTE_EXPIRATION_DAYS (default 60 giorni)'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `cliente_promemoria_segnaposto`
  WHERE `id_cliente_promemoria_configurazione` = 9 AND `nome` = '{quote_expiration_date}'
);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
SELECT '7ee24bc2-4f3f-4536-9b76-65c560aec009', t.`id`, 'quote_expiration_date',
  'Scadenza preventivo: data invio + QUOTE_EXPIRATION_DAYS (default 60 giorni)', ''
FROM `tipo_campagna_aries` t
WHERE t.`rif_applicazione` = 'quotes_monitoring'
  AND NOT EXISTS (
    SELECT 1 FROM `campagna_aries_segnaposto` p
    WHERE p.`id_tipo_campagna` = t.`id` AND p.`nome` = 'quote_expiration_date'
  );
