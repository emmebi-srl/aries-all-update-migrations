DROP TABLE IF EXISTS rapporto_mobile_rif_tipo_intervento; 

CREATE TABLE `rapporto_mobile_rif_tipo_intervento` (
	`Id` SMALLINT NOT NULL AUTO_INCREMENT,
	`Posizione` SMALLINT NOT NULL,
	`Id_tipo_intervento` SMALLINT NOT NULL,
	PRIMARY KEY (`Id`),
	UNIQUE INDEX `Posizione_Id_tipo_intervento` (`Posizione`, `Id_tipo_intervento`)
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;

INSERT INTO rapporto_mobile_rif_tipo_intervento (Posizione, Id_tipo_intervento)
VALUES 
(0 , 1), 
(1 , 2), 
(2 , 4), 
(3 , 5), 
(4 , 6),
(5 , 7); 
