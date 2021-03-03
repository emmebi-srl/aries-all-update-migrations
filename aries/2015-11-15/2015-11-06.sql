
ALTER TABLE `evento`
	MODIFY COLUMN `Stato_notifica` TINYINT NULL DEFAULT '1' AFTER `Data_sveglia`;
	
ALTER TABLE `evento`
	ADD COLUMN `Data_notifica` DATETIME NULL AFTER `Stato_notifica`;
	
DROP TABLE IF EXISTS tipo_notifica; 
CREATE TABLE `tipo_notifica` (
	`id` SMALLINT PRIMARY KEY NULL,
	`descrizione` VARCHAR(50) NOT NULL,
	`abilitato` BIT NOT NULL,
	`id_traduzione` INT NOT NULL,
	rif_applicazioni VARCHAR(15) NOT NULL
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

DROP TABLE IF EXISTS stato_notifica; 
CREATE TABLE `stato_notifica` (
	`id` SMALLINT NOT NULL,
	`descrizione` VARCHAR(50) NOT NULL,
	`abilitato` BIT NOT NULL,
	rif_applicazioni VARCHAR(15) NOT NULL,
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

ALTER TABLE `stato_notifica`
	CHANGE COLUMN `id` `id` SMALLINT(6) NOT NULL AUTO_INCREMENT FIRST;

ALTER TABLE `tipo_notifica`
	CHANGE COLUMN `id` `id` SMALLINT(6) NOT NULL AUTO_INCREMENT FIRST;

INSERT INTO tipo_notifica 
SET 
	Descrizione = 'Sincronizzazione risorse',
	Abilitato = 1, 
	rif_applicazioni = 'sync_resources',
	id_traduzione = 1;
	
INSERT INTO stato_notifica
SET
	Descrizione = 'Da notificare',
	Abilitato = 1, 
	rif_applicazioni = 'to_notified';
	 
INSERT INTO stato_notifica
SET
	Descrizione = 'Notificato',
	Abilitato = 1, 
	rif_applicazioni = 'notified';
	
INSERT INTO stato_notifica
SET
	Descrizione = 'In attesa',
	Abilitato = 1, 
	rif_applicazioni = 'waiting';
	
	

