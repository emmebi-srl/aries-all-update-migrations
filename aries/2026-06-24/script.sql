SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura_configurazione_periodica'
	AND `COLUMN_NAME` = 'id_condizione_pagamento';

SET @sql = IF(
	@column_exists = 0,
	'ALTER TABLE `fornfattura_configurazione_periodica` ADD COLUMN `id_condizione_pagamento` INT NULL AFTER `id_fornitore`',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `fornfattura_configurazione_periodica` c
INNER JOIN `fornitore` f ON c.`id_fornitore` = f.`Id_fornitore`
SET c.`id_condizione_pagamento` = f.`condizione_pagamento`
WHERE c.`id_condizione_pagamento` IS NULL
	AND f.`condizione_pagamento` IS NOT NULL;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura_configurazione_periodica'
	AND `INDEX_NAME` = 'idx_fornfattura_config_periodica_cond_pagamento';

SET @sql = IF(
	@index_exists = 0,
	'ALTER TABLE `fornfattura_configurazione_periodica` ADD INDEX `idx_fornfattura_config_periodica_cond_pagamento` (`id_condizione_pagamento`)',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura_configurazione_periodica'
	AND `CONSTRAINT_NAME` = 'fk_fornfattura_config_periodica_cond_pagamento';

SET @sql = IF(
	@constraint_exists = 0,
	'ALTER TABLE `fornfattura_configurazione_periodica` ADD CONSTRAINT `fk_fornfattura_config_periodica_cond_pagamento` FOREIGN KEY (`id_condizione_pagamento`) REFERENCES `condizione_pagamento` (`Id_condizione`) ON DELETE NO ACTION ON UPDATE CASCADE',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
