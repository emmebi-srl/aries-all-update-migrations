ALTER TABLE `commessa_impostazioni_default`
	ALTER `valore` DROP DEFAULT;
ALTER TABLE `commessa_impostazioni_default`
	CHANGE COLUMN `valore` `valore` TINYINT NOT NULL AFTER `tipo`;


ALTER TABLE `commessa_articoli`
	CHANGE COLUMN `economia` `economia` DECIMAL(11,2) NULL DEFAULT '0' AFTER `id_tab`;


DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE V_id_commessa INT;
	DECLARE V_anno INT;
	DECLARE V_curA CURSOR FOR SELECT Id_commessa, anno
		FROM commessa;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_id_commessa, V_anno;
		
		INSERT IGNORE INTO commessa_impostazioni
		SELECT V_id_commessa,
			V_anno,
			tipo,
			valore
		FROM commessa_impostazioni_default;
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;


UPDATE commessa_articoli
SET economia = 0, portati = 0;

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE V_id_commessa INT;
	DECLARE V_anno INT;
	DECLARE V_id_sottocommessa INT;
	DECLARE V_id_lotto INT;
	DECLARE V_id_rapporto INT;
	DECLARE V_anno_rapporto INT;
	DECLARE V_curA CURSOR FOR SELECT cr.Id_commessa,
		cr.anno_commessa,
		cr.id_sottocommessa,
		cr.id_lotto,
		cr.id_rapporto,
		cr.anno_rapporto
	FROM commessa_rapporto AS cr
	LEFT JOIN ddt_rapporto 
		ON ddt_rapporto.id_rapporto = cr.id_rapporto 
		AND ddt_rapporto.anno_rapporto = cr.anno_rapporto
	WHERE id_ddt IS NULL
	ORDER BY cr.anno_rapporto asc, cr.id_rapporto asc;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_id_commessa, V_anno, V_id_sottocommessa, V_id_lotto, V_id_rapporto, V_anno_rapporto;
		
		CALL sp_ariesJobScaleReport(V_id_commessa, V_anno, V_id_sottocommessa, V_id_lotto, V_id_rapporto, V_anno_rapporto);
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE V_id_commessa INT;
	DECLARE V_anno INT;
	DECLARE V_id_sottocommessa INT;
	DECLARE V_id_lotto INT;
	DECLARE V_id_ddt INT;
	DECLARE V_anno_ddt INT;
	DECLARE V_curA CURSOR FOR SELECT cr.Id_commessa,
		cr.anno_commessa,
		cr.id_sottocommessa,
		cr.id_lotto,
		cr.id_ddt,
		cr.anno_ddt
	FROM commessa_ddt AS cr
	ORDER BY cr.anno_ddt asc, cr.id_ddt asc;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	

	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_id_commessa, V_anno, V_id_sottocommessa, V_id_lotto, V_id_ddt, V_anno_ddt;
		
		CALL sp_ariesJobScaleDdt(V_id_commessa, V_anno, V_id_sottocommessa, V_id_lotto, V_id_ddt, V_anno_ddt);
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;
