SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
  AND `TABLE_NAME` = 'campagna_aries_mail'
  AND `COLUMN_NAME` = 'id_documento';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD COLUMN `id_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `id_impianto`',
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
  AND `COLUMN_NAME` = 'anno_documento';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD COLUMN `anno_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `id_documento`',
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
  AND `COLUMN_NAME` = 'revisione_documento';

SET @sql = IF(
  @column_exists = 0,
  'ALTER TABLE `campagna_aries_mail` ADD COLUMN `revisione_documento` VARCHAR(10) NULL DEFAULT NULL AFTER `anno_documento`',
  'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
