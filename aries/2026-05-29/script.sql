CREATE TABLE IF NOT EXISTS `fornfattura_configurazione_periodica` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`id_fornitore` INT NOT NULL,
	`importo_default` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
	`usa_importo_ultima_fattura` TINYINT(1) NOT NULL DEFAULT 0,
	`descrizione_riga` TEXT NULL,
	`data_inizio` DATE NOT NULL,
	`data_fine` DATE NULL,
	`periodo_unita` VARCHAR(16) NOT NULL,
	`periodo_intervallo` INT NOT NULL DEFAULT 1,
	`abilitata` TINYINT(1) NOT NULL DEFAULT 1,
	`data_ins` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`utente_ins` INT NULL,
	`data_mod` DATETIME NULL,
	`utente_mod` INT NULL,
	PRIMARY KEY (`id`),
	KEY `idx_fornfattura_config_periodica_fornitore` (`id_fornitore`),
	KEY `idx_fornfattura_config_periodica_enabled` (`abilitata`),
	CONSTRAINT `fk_fornfattura_config_periodica_fornitore`
		FOREIGN KEY (`id_fornitore`) REFERENCES `fornitore` (`Id_fornitore`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT COUNT(*)
INTO @column_exists
FROM `information_schema`.`COLUMNS`
WHERE `TABLE_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura'
	AND `COLUMN_NAME` = 'id_configurazione_periodica';

SET @sql = IF(
	@column_exists = 0,
	'ALTER TABLE `fornfattura` ADD COLUMN `id_configurazione_periodica` INT NULL AFTER `e_fattura_filename`',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @index_exists
FROM `information_schema`.`STATISTICS`
WHERE `TABLE_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura'
	AND `INDEX_NAME` = 'idx_fornfattura_configurazione_periodica';

SET @sql = IF(
	@index_exists = 0,
	'ALTER TABLE `fornfattura` ADD INDEX `idx_fornfattura_configurazione_periodica` (`id_configurazione_periodica`)',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*)
INTO @constraint_exists
FROM `information_schema`.`TABLE_CONSTRAINTS`
WHERE `CONSTRAINT_SCHEMA` = DATABASE()
	AND `TABLE_NAME` = 'fornfattura'
	AND `CONSTRAINT_NAME` = 'fk_fornfattura_configurazione_periodica';

SET @sql = IF(
	@constraint_exists = 0,
	'ALTER TABLE `fornfattura` ADD CONSTRAINT `fk_fornfattura_configurazione_periodica` FOREIGN KEY (`id_configurazione_periodica`) REFERENCES `fornfattura_configurazione_periodica` (`id`)',
	'SET @migration_noop = 0'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
