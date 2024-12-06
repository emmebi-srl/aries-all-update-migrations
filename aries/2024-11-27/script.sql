CREATE TABLE `tipo_costo_produzione` (
	`id_tipo` INT NOT NULL,
	`nome` VARCHAR(50) NOT NULL DEFAULT '',
	`descrizione` VARCHAR(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`id_tipo`),
	UNIQUE INDEX `nome` (`nome`)
)
COLLATE='latin1_swedish_ci'
;

INSERT INTO tipo_costo_produzione VALUES
(1, "MATERIE PRIME", "Materie prime"),
(2, "MATERIE SUSSIDIARIE", "Materie sussidiaries"),
(3, "MERCE", "Merce"),
(4, "USO E CONSUMO", "Uso e consumo");


INSERT INTO `tab_tipo` (`nome`, `descrizione`, `tipo_ins`) VALUES ('tipo_costo_produzione', 'Tipo costo di produzione', '0');

ALTER TABLE `articolo`
	ADD COLUMN `id_tipo_costo_produzione` INT NULL DEFAULT NULL AFTER `descrizione_posizione_magazzino`,
	ADD CONSTRAINT `FK_articolo_tipo_costo_produzione` FOREIGN KEY (`id_tipo_costo_produzione`) REFERENCES `tipo_costo_produzione` (`id_tipo`) ON UPDATE NO ACTION ON DELETE NO ACTION;

UPDATE articolo SET id_tipo_costo_produzione = 4 where uso_consumo = 1;

ALTER TABLE `fornfattura`
	DROP COLUMN `costo_cavi`,
	DROP COLUMN `uso_consumo`;

ALTER TABLE `articolo`
	DROP COLUMN `uso_consumo`;


DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_emmebi BIT(1) DEFAULT 0;


	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda 
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		insert into environment_variables VALUES ('ENABLE_PRODUCT_REQUIRED_PRODUCTION_COST_TYPE', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_PRODUCT_REQUIRED_PRODUCTION_COST_TYPE', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
