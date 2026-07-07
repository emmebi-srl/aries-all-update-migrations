SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `COLUMN_NAME` = 'id_banca';

SET @sql = IF(
    @column_exists = 0,
    'ALTER TABLE `conto_bancario` ADD COLUMN `id_banca` BIGINT NULL AFTER `nome`',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `COLUMN_NAME` = 'banca';

SET @sql = IF(
    @column_exists = 1,
    'UPDATE `conto_bancario` cb
        INNER JOIN `banca` b ON b.`Nome` = cb.`banca`
        SET cb.`id_banca` = b.`Id_banca`
        WHERE cb.`id_banca` IS NULL',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `INDEX_NAME` = 'idx_conto_bancario_banca';

SET @sql = IF(
    @index_exists = 0,
    'ALTER TABLE `conto_bancario` ADD INDEX `idx_conto_bancario_banca` (`id_banca`)',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `CONSTRAINT_NAME` = 'fk_conto_bancario_banca';

SET @sql = IF(
    @constraint_exists = 0,
    'ALTER TABLE `conto_bancario` ADD CONSTRAINT `fk_conto_bancario_banca` FOREIGN KEY (`id_banca`) REFERENCES `banca` (`Id_banca`)',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `COLUMN_NAME` = 'banca';

SET @sql = IF(
    @column_exists = 1,
    'ALTER TABLE `conto_bancario` DROP COLUMN `banca`',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
    AND `TABLE_NAME` = 'conto_bancario'
    AND `COLUMN_NAME` = 'bic';

SET @sql = IF(
    @column_exists = 1,
    'ALTER TABLE `conto_bancario` DROP COLUMN `bic`',
    'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


ALTER TABLE `conto_bancario`
	CHANGE COLUMN `id_banca` `id_banca` BIGINT(20) NOT NULL AFTER `nome`;
