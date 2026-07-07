SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'conto_bancario'
	AND `COLUMN_NAME` = 'predefinito_pagamenti';

SET @sql = IF(
	@column_exists = 0,
	'ALTER TABLE `conto_bancario` ADD COLUMN `predefinito_pagamenti` TINYINT(1) NOT NULL DEFAULT 0 AFTER `attivo`',
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
	AND `INDEX_NAME` = 'idx_conto_bancario_predefinito_pagamenti';

SET @sql = IF(
	@index_exists = 0,
	'ALTER TABLE `conto_bancario` ADD INDEX `idx_conto_bancario_predefinito_pagamenti` (`predefinito_pagamenti`)',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
