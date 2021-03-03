ALTER TABLE categoria_merciologica
	ADD COLUMN `Movimenta_magazzino` BIT NULL DEFAULT b'1' AFTER `Descrizione`,
	ADD COLUMN `Movimenta_impianto` BIT NULL DEFAULT b'1' AFTER `Movimenta_magazzino`,
	ADD COLUMN `Data_ins` DATETIME NULL AFTER `Movimenta_impianto`,
	ADD COLUMN `Data_mod` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Data_ins`,
	ADD COLUMN `Utente_ins` SMALLINT NULL AFTER `Data_mod`,
	ADD COLUMN `Utente_mod` SMALLINT NOT NULL AFTER `Utente_ins`;
	
ALTER TABLE categoria_merciologica
	CHANGE COLUMN Descrizione Descrizione TEXT NULL AFTER `Nome`;
	
INSERT IGNORE INTO tipo_impianto VALUES (58, "ANTITACHEGGIO", NULL); 
INSERT IGNORE INTO tipo_impianto VALUES (72, "D. Lgs 81/08", NULL); 

RENAME TABLE `rapporto_mobile_rif_tipo_intervento` TO `rapporto_mobile_intervento_rif_tipo_intervento`;



CREATE TABLE `rapporto_mobile_collaudo_rif_tipo_intervento` (
	`Id` SMALLINT(6) NOT NULL AUTO_INCREMENT,
	`Posizione` SMALLINT(6) NOT NULL,
	`Id_tipo_intervento` SMALLINT(6) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Posizione_Id_tipo_intervento` (`Posizione`, `Id_tipo_intervento`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO `rapporto_mobile_collaudo_rif_tipo_intervento` (Posizione, Id_tipo_intervento)
VALUES
(0, 6), 
(1, 12), 
(2, 7); 

CREATE TABLE `rapporto_mobile_collaudo_rif_tipo_impianto` (
	`Id` SMALLINT(6) NOT NULL AUTO_INCREMENT,
	`Posizione` SMALLINT(6) NOT NULL,
	`Id_tipo_impianto` SMALLINT(6) NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Posizione_Id_tipo_impianto` (`Posizione`, `Id_tipo_impianto`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO `rapporto_mobile_collaudo_rif_tipo_impianto` (Posizione, Id_tipo_impianto)
VALUES
(0, 4), 
(1, 5), 
(2, 7), 
(3, 8),
(4, 9), 
(5, 58),
(6, 72); 