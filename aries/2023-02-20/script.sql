CREATE TABLE `rapporto_sorgente` (
	`id` INT NOT NULL,
	`nome` VARCHAR(100) NOT NULL DEFAULT '',
	`attivo` BIT NULL DEFAULT 1,
	`data_ins` TIMESTAMP NULL DEFAULT NOW(),
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
;


INSERT INTO rapporto_sorgente VALUES
(1, 'Cartaceo', 1, NOW()),
(2, 'Telematico', 1, NOW());


CREATE TABLE `tipo_rapporto` (
	`id` INT NOT NULL,
	`nome` VARCHAR(100) NOT NULL DEFAULT '',
	`attivo` BIT NULL DEFAULT 1,
	`data_ins` TIMESTAMP NULL DEFAULT NOW(),
	PRIMARY KEY (`id`)
)
COLLATE='latin1_swedish_ci'
;


INSERT INTO tipo_rapporto VALUES
(1, 'Interno', 1, NOW()),
(2, 'Cliente', 1, NOW()), 
(3, 'Collaudo', 1, NOW());



ALTER TABLE `rapporto`
	CHANGE COLUMN `Id_tipo_sorgente` `Id_tipo_sorgente` INT NOT NULL DEFAULT 1 COMMENT 'TIPO SORGENTE DI ARRIVO DEL RAPPORTO ( 1 = cartaceo, 2 = telematico)' AFTER `economia`,
	ADD COLUMN `id_tipo_rapporto` INT NULL DEFAULT NULL AFTER `Id_tipo_sorgente`;

ALTER TABLE `rapporto`
	ADD CONSTRAINT `FK_rapporto_tipo_sorgente` FOREIGN KEY (`Id_tipo_sorgente`) REFERENCES `rapporto_sorgente` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION,
	ADD CONSTRAINT `FK_rapporto_tipo_rapporto` FOREIGN KEY (`id_tipo_rapporto`) REFERENCES `tipo_rapporto` (`id`) ON UPDATE CASCADE ON DELETE NO ACTION;


ALTER TABLE `rapporto_mobile`
	CHANGE COLUMN `tipo_rapporto` `tipo_rapporto` INT NULL DEFAULT NULL COMMENT '2 Customer, 1  Internal' AFTER `usa_firma_su_ddt`,
	ADD CONSTRAINT `FK_rapporto_mobile_tipo_rapporto` FOREIGN KEY (`tipo_rapporto`) REFERENCES `tipo_rapporto` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION;



UPDATE rapporto_mobile rm
INNER JOIN rapporto_mobile_collaudo rc ON rm.id_rapporto = rc.id_rapporto and rm.anno = rc.anno
SET tipo_rapporto = 3;

UPDATE rapporto
INNER JOIN rapporto_mobile ON rapporto.id_rapporto = rapporto_mobile.id_rapporto and rapporto.anno = rapporto_mobile.anno
SET id_tipo_rapporto = tipo_rapporto;
