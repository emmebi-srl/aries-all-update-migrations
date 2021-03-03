ALTER TABLE `azienda_inizio`
	ALTER `ragione_sociale` DROP DEFAULT;
ALTER TABLE `azienda_inizio`
	CHANGE COLUMN `ragione_sociale` `ragione_sociale` VARCHAR(150) NOT NULL AFTER `Partita_iva`;
