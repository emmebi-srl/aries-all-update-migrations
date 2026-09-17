SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'cliente_promemoria_configurazione'
  AND `COLUMN_NAME` = 'modalita_consegna';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `cliente_promemoria_configurazione` ADD COLUMN `modalita_consegna` TINYINT NOT NULL DEFAULT 0 AFTER `abilita_email`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'cliente_promemoria_configurazione'
  AND `COLUMN_NAME` = 'id_campagna_aries';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `cliente_promemoria_configurazione` ADD COLUMN `id_campagna_aries` INT(11) NULL AFTER `modalita_consegna`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'cliente_promemoria_configurazione'
  AND `INDEX_NAME` = 'idx_cliente_promemoria_campagna';

SET @sql = IF(
  @index_exists = 0,
  'ALTER TABLE `cliente_promemoria_configurazione` ADD INDEX `idx_cliente_promemoria_campagna` (`id_campagna_aries`)',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'cliente_promemoria_configurazione'
  AND `CONSTRAINT_NAME` = 'fk_cliente_promemoria_campagna';

SET @sql = IF(
  @constraint_exists = 0,
  'ALTER TABLE `cliente_promemoria_configurazione` ADD CONSTRAINT `fk_cliente_promemoria_campagna` FOREIGN KEY (`id_campagna_aries`) REFERENCES `campagna_aries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE',
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
  @column_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD COLUMN `id_cliente_promemoria_configurazione` INT(11) NULL AFTER `id_impianto`',
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
  @column_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD COLUMN `tentativi_creazione_mail` INT NOT NULL DEFAULT 0 AFTER `data_notifica`',
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
  @column_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD COLUMN `errore_creazione_mail` TEXT NULL AFTER `tentativi_creazione_mail`',
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
  @column_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD COLUMN `data_ultimo_tentativo` DATETIME NULL AFTER `errore_creazione_mail`',
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
  @index_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD INDEX `idx_richiesta_campagna_abbonamento_promemoria` (`id_cliente_promemoria_configurazione`)',
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
  @constraint_exists = 0,
  'ALTER TABLE `richiesta_campagna_abbonamento` ADD CONSTRAINT `fk_richiesta_campagna_abbonamento_promemoria` FOREIGN KEY (`id_cliente_promemoria_configurazione`) REFERENCES `cliente_promemoria_configurazione` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE',
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
  @column_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD COLUMN `id_richiesta_campagna_abbonamento` INT(11) NULL AFTER `id_impianto`',
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
  @index_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD UNIQUE INDEX `uq_campagna_aries_mail_richiesta_abbonamento` (`id_richiesta_campagna_abbonamento`)',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `CONSTRAINT_NAME` = 'fk_campagna_aries_mail_richiesta_abbonamento';

SET @sql = IF(
  @constraint_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD CONSTRAINT `fk_campagna_aries_mail_richiesta_abbonamento` FOREIGN KEY (`id_richiesta_campagna_abbonamento`) REFERENCES `richiesta_campagna_abbonamento` (`id`) ON DELETE SET NULL ON UPDATE CASCADE',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigUpdateV2;
DELIMITER //
CREATE PROCEDURE `sp_ariesCustomerReminderConfigUpdateV2`(
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

DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigurationGet;
DELIMITER //
CREATE PROCEDURE `sp_ariesCustomerReminderConfigurationGet`()
BEGIN
  SELECT `Id`,
         `Nome`,
         `Tipo_intervallo`,
         `Valore`,
         `Oggetto_email`,
         `Corpo_email`,
         `Testo_sms`,
         `abilita_sms`,
         `abilita_email`,
         `modalita_consegna`,
         `id_campagna_aries`,
         `Data_ultima_esecuzione`,
         `Data_mod`,
         `Utente_mod`
  FROM cliente_promemoria_configurazione;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_apiCustomerReminderConfigGetById;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerReminderConfigGetById(
  IN service_id INT(11)
)
BEGIN
  SELECT `Id`,
         `Nome`,
         `Tipo_intervallo`,
         `Valore`,
         `Oggetto_email`,
         `Corpo_email`,
         `Testo_sms`,
         `abilita_sms`,
         `abilita_email`,
         `modalita_consegna`,
         `id_campagna_aries`,
         `Data_ultima_esecuzione`,
         `Data_mod`,
         `Utente_mod`
  FROM cliente_promemoria_configurazione
  WHERE `Id` = service_id;
END//
DELIMITER ;
