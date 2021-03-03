ALTER TABLE `log_aries`
ALTER `id_utente` DROP DEFAULT;
ALTER TABLE `log_aries`
CHANGE COLUMN `id_utente` `id_utente` VARCHAR(5) NOT NULL AFTER `anno`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id_log`, `anno`) USING BTREE;

ALTER TABLE `commessa`
	CHANGE COLUMN `Descrizione` `Descrizione` LONGTEXT NULL DEFAULT NULL AFTER `stato_commessa`;


DROP TABLE IF EXISTS rapporto_mobile_materiale; 
DROP TABLE IF EXISTS rapporto_mobile_ticket; 
DROP TABLE IF EXISTS rapporto_materiali_mobile; 
DROP TABLE IF EXISTS rapporto_mobile_tecnico; 
DROP TABLE IF EXISTS rapporto_tecnico_mobile; 
DROP TABLE IF EXISTS rapporto_mobile_lavoro; 
DROP TABLE IF EXISTS rapporto_mobile; 
	
	
CREATE TABLE IF NOT EXISTS `rapporto_mobile_materiale` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`codice_articolo` VARCHAR(11) NOT NULL DEFAULT '0',
	`descrizione` VARCHAR(11) NOT NULL DEFAULT '0',
	`quantita` DECIMAL(11,2) NOT NULL DEFAULT '0.00',
	`posizione` TINYINT(4) NOT NULL DEFAULT '0',
	`id_rapporto` MEDIUMINT(9) NOT NULL DEFAULT '0',
	`anno_rapporto` SMALLINT(6) NOT NULL DEFAULT '0',
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `unique_index` (`id_rapporto`, `anno_rapporto`, `posizione`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

	

CREATE TABLE IF NOT EXISTS `rapporto_mobile_ticket` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_rapporto` MEDIUMINT(9) NULL DEFAULT NULL,
	`anno_rapporto` SMALLINT(6) NULL DEFAULT NULL,
	`id_ticket` MEDIUMINT(9) NULL DEFAULT NULL,
	`anno_ticket` SMALLINT(6) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_ticket` (`id_ticket`, `anno_ticket`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;


CREATE TABLE IF NOT EXISTS `rapporto_mobile_tecnico` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_rapporto` MEDIUMINT(9) NOT NULL DEFAULT '0',
	`anno_rapporto` SMALLINT(6) NOT NULL DEFAULT '0',
	`id_tecnico` SMALLINT(6) NOT NULL DEFAULT '0',
	`tempo_lavorato` SMALLINT(6) NOT NULL DEFAULT '0',
	`km` SMALLINT(6) NOT NULL,
	`tempo_viaggio` SMALLINT(6) NOT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `id_rapporto` (`id_rapporto`, `anno_rapporto`, `id_tecnico`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `rapporto_mobile_lavoro` (
	`Id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_rapporto` MEDIUMINT(9) UNSIGNED NOT NULL,
	`anno_rapporto` SMALLINT(6) UNSIGNED NOT NULL,
	`controllo_periodico` TINYINT NULL DEFAULT NULL,
	`materiale_uso` FLOAT NULL DEFAULT NULL,
	`diritto_chiamata` BIT DEFAULT NULL,
	`viaggio_consuntivo` BIT DEFAULT NULL,
	`spese_consuntivo` BIT DEFAULT NULL,
	`spese` VARCHAR(45) NULL DEFAULT NULL,
	`ora_inizio_primo_periodo` TIME NULL DEFAULT NULL,
	`ora_fine_primo_periodo` TIME NULL DEFAULT NULL,
	`ora_inizio_secondo_periodo` TIME NULL DEFAULT NULL,
	`ora_fine_secondo_periodo` TIME NULL DEFAULT NULL,
	`tecnici` VARCHAR(100) NULL DEFAULT NULL,	
	`totale_ore` VARCHAR(45) NULL DEFAULT NULL,
	`extra_consuntivo` BIT DEFAULT NULL,
	`extra_testo` VARCHAR(45) NULL DEFAULT NULL,
	`extra` VARCHAR(45) NULL DEFAULT NULL,
	PRIMARY KEY (`id`),
	UNIQUE INDEX `unique_index` (`id_rapporto`, anno_rapporto)
	
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

CREATE TABLE IF NOT EXISTS `rapporto_mobile` (
	`Id_rapporto` MEDIUMINT(9) NOT NULL,
	`Anno` SMALLINT(6) NOT NULL,
	`Id_Impianto` INT(11) NULL DEFAULT NULL,
	`id_destinazione` INT(11) NULL DEFAULT NULL,
	`Id_cliente` INT(11) NULL DEFAULT NULL,
	`Richiesto` VARCHAR(30) NULL DEFAULT NULL,
	`Mansione` VARCHAR(20) NULL DEFAULT NULL,
	`Responsabile` VARCHAR(30) NULL DEFAULT NULL,
	`Tipo_intervento` INT(11) NULL DEFAULT NULL,
	`Diritto_chiamata` TINYINT(1) NOT NULL DEFAULT '0',
	`dir_ric_fatturato` TINYINT(1) NOT NULL DEFAULT '0',
	`relazione` TEXT NULL,
	`Terminato` TINYINT(1) NULL DEFAULT NULL,
	`Funzionante` TINYINT(1) NULL DEFAULT NULL,
	`Stato` INT(11) NULL DEFAULT NULL,
	`Note_Generali` VARCHAR(1000) NULL DEFAULT NULL,
	`Fattura` INT(11) NULL DEFAULT NULL,
	`Data` DATE NULL DEFAULT NULL,
	`Commessa` INT(11) NULL DEFAULT NULL,
	`abbonamento` INT(11) NULL DEFAULT NULL,
	`Numero_ordine` VARCHAR(11) NULL DEFAULT NULL,
	`Totale` FLOAT(11,4) NULL DEFAULT '0.0000',
	`Nr_rapporto` VARCHAR(40) NULL DEFAULT ' ',
	`Data_esecuzione` DATE NULL DEFAULT NULL,
	`Costo` FLOAT(11,4) NULL DEFAULT '0.0000',
	`materiale` FLOAT(11,4) NULL DEFAULT '0.0000',
	`scan` INT(1) UNSIGNED NULL DEFAULT '0',
	`anno_fattura` INT(10) NULL DEFAULT '0',
	`controllo_periodico` FLOAT(11,4) NULL DEFAULT '0.0000',
	`prima` INT(10) UNSIGNED NULL DEFAULT '0',
	`numero` VARCHAR(45) NULL DEFAULT NULL,
	`id_utente` INT(11) NULL DEFAULT NULL,
	`cost_lav` DOUBLE NULL DEFAULT '0',
	`prez_lav` DOUBLE NULL DEFAULT '0',
	`dest_cli` INT(11) NULL DEFAULT NULL,
	`email_invio` VARCHAR(45) NULL DEFAULT NULL,
	`inviato` TINYINT(1) NULL DEFAULT '0',
	`visionato` TINYINT(1) NULL DEFAULT NULL,
	`id_ticket` VARCHAR(100) NULL DEFAULT NULL,
	`tecnici` VARCHAR(150) NULL DEFAULT NULL,
	`APPUNTI` TEXT NULL,
	`notturno` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
	`festivo` TINYINT(3) UNSIGNED NOT NULL,
	`su_chiamata` TINYINT(3) UNSIGNED NOT NULL,
	`eff_giorn` TINYINT(3) UNSIGNED NOT NULL,
	`sost` TINYINT(3) UNSIGNED NOT NULL,
	`ripar` TINYINT(3) UNSIGNED NOT NULL,
	`not` VARCHAR(45) NOT NULL,
	`c_not` TINYINT(3) UNSIGNED NOT NULL,
	`abbon` TINYINT(3) UNSIGNED NOT NULL,
	`garanz` TINYINT(3) UNSIGNED NOT NULL,
	`man_ordi` TINYINT(3) UNSIGNED NOT NULL,
	`fuorigaranz` TINYINT(3) UNSIGNED NOT NULL,
	`fuoriabbon` TINYINT(3) UNSIGNED NOT NULL,
	`man_straord` TINYINT(3) UNSIGNED NOT NULL,
	`tipo_impianto` VARCHAR(45) NOT NULL,
	`ragione_sociale` VARCHAR(60) NOT NULL,
	`indirizzo` VARCHAR(100) NOT NULL,
	`citta` VARCHAR(100) NOT NULL,
	`luogo_lavoro` VARCHAR(100) NOT NULL,
	`difetto` VARCHAR(100) NOT NULL,
	`id_riferimento` INT(10) UNSIGNED NULL DEFAULT NULL,
	`mail_responsabile` VARCHAR(100) NULL DEFAULT NULL,
	PRIMARY KEY (`Id_rapporto`, `Anno`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;


