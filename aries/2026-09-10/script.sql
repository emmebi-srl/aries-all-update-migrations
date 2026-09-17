SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `CONSTRAINT_NAME` = 'fk_campagna_aries_mail_richiesta_abbonamento';

SET @sql = IF(
  @constraint_exists > 0,
  'ALTER TABLE `campagna_aries_mail` DROP FOREIGN KEY `fk_campagna_aries_mail_richiesta_abbonamento`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `INDEX_NAME` = 'uq_campagna_aries_mail_richiesta_abbonamento';

SET @sql = IF(
  @index_exists > 0,
  'ALTER TABLE `campagna_aries_mail` DROP INDEX `uq_campagna_aries_mail_richiesta_abbonamento`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `COLUMN_NAME` = 'id_richiesta_campagna_abbonamento';

SET @sql = IF(
  @column_exists > 0,
  'ALTER TABLE `campagna_aries_mail` DROP COLUMN `id_richiesta_campagna_abbonamento`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `CONSTRAINT_NAME` = 'fk_richiesta_campagna_abbonamento_promemoria';

SET @sql = IF(
  @constraint_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP FOREIGN KEY `fk_richiesta_campagna_abbonamento_promemoria`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `INDEX_NAME` = 'idx_richiesta_campagna_abbonamento_promemoria';

SET @sql = IF(
  @index_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP INDEX `idx_richiesta_campagna_abbonamento_promemoria`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `COLUMN_NAME` = 'id_cliente_promemoria_configurazione';

SET @sql = IF(
  @column_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP COLUMN `id_cliente_promemoria_configurazione`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `COLUMN_NAME` = 'tentativi_creazione_mail';

SET @sql = IF(
  @column_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP COLUMN `tentativi_creazione_mail`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `COLUMN_NAME` = 'errore_creazione_mail';

SET @sql = IF(
  @column_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP COLUMN `errore_creazione_mail`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'richiesta_campagna_abbonamento'
  AND `COLUMN_NAME` = 'data_ultimo_tentativo';

SET @sql = IF(
  @column_exists > 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` DROP COLUMN `data_ultimo_tentativo`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigUpdateV2;

DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigUpdate;
DELIMITER //
CREATE PROCEDURE `sp_ariesCustomerReminderConfigUpdate`(
  IN service_id INT(11),
  IN interval_type SMALLINT(6),
  IN interval_value INT(11),
  IN email_subject VARCHAR(150),
  IN email_body TEXT,
  IN sms_text TEXT,
  IN sms_enabled BIT(1),
  IN email_enabled BIT(1),
  IN delivery_mode TINYINT,
  IN campaign_id INT(11),
  OUT result INTEGER
)
BEGIN
  UPDATE cliente_promemoria_configurazione
  SET `Tipo_intervallo` = interval_type,
      `Valore` = interval_value,
      `Oggetto_email` = email_subject,
      `Corpo_email` = email_body,
      `Testo_sms` = sms_text,
      `abilita_sms` = sms_enabled,
      `abilita_email` = email_enabled,
      `modalita_consegna` = delivery_mode,
      `id_campagna_aries` = campaign_id
  WHERE `Id` = service_id;

  SET result = 1;
END//
DELIMITER ;

INSERT IGNORE INTO `cliente_promemoria_configurazione`
  (`Id`, `Nome`, `Tipo_intervallo`, `Valore`, `Data_ultima_esecuzione`,
   `Oggetto_email`, `Corpo_email`, `Testo_sms`, `abilita_sms`, `abilita_email`,
   `modalita_consegna`, `id_campagna_aries`, `Data_mod`, `Utente_mod`)
VALUES (
  9,
  'PROMEMORIA PREVENTIVI INVIATI',
  7,
  30,
  CURRENT_TIMESTAMP,
  'Promemoria preventivo {quote_id}/{quote_year}',
  'Gentile {contact_name},\r\n\r\nla contattiamo in merito al preventivo {quote_id}/{quote_year} inviato il {quote_send_date}.',
  'Promemoria preventivo {quote_id}/{quote_year} inviato il {quote_send_date}.',
  b'0',
  b'0',
  0,
  NULL,
  CURRENT_TIMESTAMP,
  1
);

INSERT IGNORE INTO `cliente_promemoria_segnaposto`
  (`id_cliente_promemoria_configurazione`, `nome`, `descrizione`)
VALUES
  (9, '{company_name}', 'Ragione sociale nostra azienda'),
  (9, '{title}', 'Titolo contatto cliente (Sig, Dott, ...)'),
  (9, '{contact_name}', 'Nome contatto cliente o ragione sociale'),
  (9, '{customer_name}', 'Ragione sociale cliente'),
  (9, '{quote_id}', 'ID preventivo'),
  (9, '{quote_year}', 'Anno preventivo'),
  (9, '{quote_date}', 'Data preventivo'),
  (9, '{quote_send_date}', 'Data invio preventivo'),
  (9, '{reminder_number}', 'Numero progressivo reminder'),
  (9, '{full_address}', 'Indirizzo destinazione preventivo'),
  (9, '{municipality}', 'Comune destinazione preventivo');

INSERT INTO `tipo_campagna_aries`
  (`uuid`, `nome`, `rif_applicazione`)
VALUES
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e01', 'Promemoria resoconti', 'report_group_reminders')
ON DUPLICATE KEY UPDATE
  `nome` = VALUES(`nome`);

INSERT INTO `tipo_campagna_aries`
  (`uuid`, `nome`, `rif_applicazione`)
VALUES
  ('7ee24bc2-4f3f-4536-9b76-65c560aec001', 'Monitoraggio Preventivi', 'quotes_monitoring')
ON DUPLICATE KEY UPDATE
  `nome` = VALUES(`nome`);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
VALUES
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e02', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'customer_name', 'Ragione sociale cliente', ''),
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e03', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'report_group_id', 'ID resoconto', ''),
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e04', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'report_group_year', 'Anno resoconto', ''),
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e05', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'report_group_date', 'Data resoconto', ''),
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e06', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'report_group_email_send_date', 'Data invio resoconto', ''),
  ('9f0b92fa-58dc-4b65-a6c0-df38f7bc4e07', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'report_group_reminders' LIMIT 1), 'reminder_number', 'Numero progressivo reminder', '')
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

INSERT INTO `campagna_aries_segnaposto`
  (`uuid`, `id_tipo_campagna`, `nome`, `descrizione`, `valore_predefinito`)
VALUES
  ('7ee24bc2-4f3f-4536-9b76-65c560aec002', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'customer_name', 'Ragione sociale cliente', ''),
  ('7ee24bc2-4f3f-4536-9b76-65c560aec003', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'quote_id', 'ID preventivo', ''),
  ('7ee24bc2-4f3f-4536-9b76-65c560aec004', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'quote_year', 'Anno preventivo', ''),
  ('7ee24bc2-4f3f-4536-9b76-65c560aec005', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'quote_date', 'Data preventivo', ''),
  ('7ee24bc2-4f3f-4536-9b76-65c560aec006', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'quote_send_date', 'Data invio preventivo', ''),
  ('7ee24bc2-4f3f-4536-9b76-65c560aec007', (SELECT `id` FROM `tipo_campagna_aries` WHERE `rif_applicazione` = 'quotes_monitoring' LIMIT 1), 'reminder_number', 'Numero progressivo reminder', '')
ON DUPLICATE KEY UPDATE
  `descrizione` = VALUES(`descrizione`);

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'resoconto'
  AND `COLUMN_NAME` = 'numero_promemoria_inviati';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `resoconto` ADD COLUMN `numero_promemoria_inviati` INT NOT NULL DEFAULT 0 AFTER `promemoria_inviato`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `resoconto`
SET `numero_promemoria_inviati` = 1
WHERE COALESCE(`promemoria_inviato`, 0) = 1
  AND `numero_promemoria_inviati` = 0;

DROP PROCEDURE IF EXISTS sp_apiReportGroupGetToRemind;
DELIMITER //
CREATE PROCEDURE `sp_apiReportGroupGetToRemind`(
  IN maximum_reminder_count INT(11),
  IN reminder_window_days INT(11)
)
BEGIN
  SELECT
    resoconto.`id_resoconto`,
    resoconto.`anno`,
    `data`,
    resoconto.`Descrizione`,
    `Numero_ordine`,
    `Id_cliente`,
    stato_resoconto.Id_stato AS id_stato_resoconto,
    stato_resoconto.nome AS stato_resoconto,
    `Nota`,
    `fattura`,
    `anno_fattura`,
    `id_utente`,
    tipo_resoconto.id_tipo AS id_tipo_resoconto,
    tipo_resoconto.nome AS tipo_resoconto,
    IFNULL(inviato, 0) AS inviato,
    `nota_fine`,
    IFNULL(stm, 0) AS stm,
    `fat_SpeseRap`,
    `prezzo_manutenzione`,
    `resoconto_totali`.costo_manutenzione,
    `costo_diritto_chiamata`,
    `prezzo_diritto_chiamata`,
    `costo_lavoro`,
    `prezzo_lavoro`,
    `costo_viaggio`,
    `prezzo_viaggio`,
    `costo_materiale`,
    `prezzo_materiale`,
    `costo_totale`,
    `prezzo_totale`,
    promemoria_inviato,
    data_invio_promemoria,
    COALESCE(numero_promemoria_inviati, 0) AS numero_promemoria_inviati
  FROM resoconto
    INNER JOIN resoconto_totali
      ON resoconto.id_resoconto = resoconto_totali.id_resoconto
      AND resoconto.anno = resoconto_totali.anno
    INNER JOIN stato_resoconto ON resoconto.stato = stato_resoconto.id_stato
    INNER JOIN tipo_resoconto ON resoconto.tipo_resoconto = tipo_resoconto.id_tipo
    INNER JOIN (
      SELECT CAST(id_documento AS UNSIGNED) AS id_resoconto,
        CAST(anno_documento AS UNSIGNED) AS anno_resoconto,
        MAX(DATA_invio) AS data_invio_resoconto
      FROM mail
      WHERE tipo_documento = 'reso'
        AND id_documento IS NOT NULL
        AND anno_documento IS NOT NULL
        AND Id_stato = 1
      GROUP BY CAST(id_documento AS UNSIGNED), CAST(anno_documento AS UNSIGNED)
    ) AS tmp_reso_email
      ON tmp_reso_email.id_resoconto = resoconto.id_resoconto
      AND tmp_reso_email.anno_resoconto = resoconto.anno
  WHERE resoconto.inviato = 1
    AND resoconto.stato NOT IN (2, 3, 5, 6, 7)
    AND COALESCE(resoconto.numero_promemoria_inviati, 0) < maximum_reminder_count
    AND CURRENT_DATE BETWEEN
      DATE(TIMESTAMPADD(
        MONTH,
        COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
        tmp_reso_email.data_invio_resoconto
      ))
      AND DATE(TIMESTAMPADD(
        DAY,
        reminder_window_days,
        TIMESTAMPADD(
          MONTH,
          COALESCE(resoconto.numero_promemoria_inviati, 0) + 1,
          tmp_reso_email.data_invio_resoconto
        )
      ));
END//
DELIMITER ;
