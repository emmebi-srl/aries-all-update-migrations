ALTER TABLE `articolo_preventivo`
	ALTER `Lotto` DROP DEFAULT,
	ALTER `anno` DROP DEFAULT;
ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `Id_preventivo` `Id_preventivo` INT(11) NOT NULL DEFAULT '0' FIRST,
	CHANGE COLUMN `anno` `anno` INT(11) NOT NULL AFTER `Id_preventivo`,
	CHANGE COLUMN `Id_revisione` `Id_revisione` INT(11) NOT NULL DEFAULT '0' AFTER `anno`,
	CHANGE COLUMN `Lotto` `Lotto` INT(11) NOT NULL AFTER `Id_revisione`,
	CHANGE COLUMN `id_tab` `id_tab` INT(11) NOT NULL DEFAULT '0' AFTER `Lotto`,
	CHANGE COLUMN `quantità` `quantità` DECIMAL(10,0) NULL DEFAULT NULL AFTER `Id_articolo`,
	CHANGE COLUMN `foto` `foto` VARCHAR(2) NOT NULL DEFAULT 'si' AFTER `unità_misura`,
	ADD COLUMN `Data_ins` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `idnota`, 
	ADD COLUMN `Utente_ins` SMALLINT NOT NULL DEFAULT '1' AFTER `Data_ins`;
	
	
UPDATE articolo_preventivo 
SET Data_ins = NOW(); 


ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `quantità` `quantità` DECIMAL(10,2) NULL DEFAULT NULL AFTER `Id_articolo`,
	CHANGE COLUMN `codice_fornitore` `codice_fornitore` VARCHAR(22) NULL DEFAULT NULL AFTER `quantità`,
	CHANGE COLUMN `prezzo` `prezzo` DECIMAL(10,2) NULL DEFAULT NULL AFTER `foto`,
	CHANGE COLUMN `costo` `costo` DECIMAL(10,2) NULL DEFAULT NULL AFTER `prezzo`,
	CHANGE COLUMN `Tempo_installazione` `Tempo_installazione` MEDIUMINT NULL DEFAULT NULL AFTER `costo`,
	CHANGE COLUMN `Prezzo_h` `Prezzo_h` DECIMAL(10,2) NULL DEFAULT NULL AFTER `Tempo_installazione`,
	CHANGE COLUMN `costo_h` `costo_h` DECIMAL(10,2) NULL DEFAULT NULL AFTER `Prezzo_h`,
	CHANGE COLUMN `bloccato` `bloccato` BIT NULL DEFAULT b'0' AFTER `Listino`,
	CHANGE COLUMN `montato` `montato` BIT NULL DEFAULT b'0' AFTER `bloccato`,
	CHANGE COLUMN `sconto` `sconto` DECIMAL(10,2) NULL DEFAULT NULL AFTER `tipo`,
	CHANGE COLUMN `scontoriga` `scontoriga` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `iva`,
	CHANGE COLUMN `scontolav` `scontolav` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `scontoriga`,
	CHANGE COLUMN `checked` `checked` BIT NULL DEFAULT NULL AFTER `scontolav`,
	CHANGE COLUMN `Utente_ins` `Utente_ins` SMALLINT NOT NULL DEFAULT '1' AFTER `Data_ins`;
	
	
ALTER TABLE `rapporto_tecnico_lavoro`
	CHANGE COLUMN `straordinario` `straordinario` TINYINT(1) NULL DEFAULT '0' COMMENT '(0,1) = ore normali    (3,4) = ore economia ' AFTER `nota`;
