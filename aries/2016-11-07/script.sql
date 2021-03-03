ALTER TABLE `rapporto_mobile_collaudo`
	ALTER `Numero_viaggi` DROP DEFAULT,
	ALTER `Km_percorsi` DROP DEFAULT,
	ALTER `Km_complessivi` DROP DEFAULT;
ALTER TABLE `rapporto_mobile_collaudo`
	CHANGE COLUMN `Numero_viaggi` `Numero_viaggi` TINYINT NOT NULL AFTER `Note_viaggio`,
	CHANGE COLUMN `Km_percorsi` `Km_percorsi` SMALLINT NOT NULL AFTER `Numero_viaggi`,
	CHANGE COLUMN `Km_complessivi` `Km_complessivi` SMALLINT NOT NULL AFTER `Km_percorsi`;
