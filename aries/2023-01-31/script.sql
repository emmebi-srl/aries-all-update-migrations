DROP PROCEDURE IF EXISTS sp_ariesDepotsScaleByReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsScaleByReport(
	report_id INT, report_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_id_materiale INT;
	DECLARE allow_insert BIT(1);
	DECLARE V_curA CURSOR FOR SELECT Id_tab, id_materiale
		FROM rapporto_materiale
		WHERE id_rapporto = report_id AND anno = report_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab, V_id_materiale;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF V_id_materiale IS NOT NULL THEN
			SELECT  fnc_productAllowDepotsScale(V_id_materiale)
				INTO allow_insert;

			IF allow_insert THEN
				CALL sp_ariesDepotsScaleByReportProduct(report_id, report_year, V_id_tab);
			END IF;
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsReportProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReportProductInsert(
	report_id INT,
	report_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE causal_id INT(11);
	DECLARE report_execution_date DATE;

	SELECT data_esecuzione
	INTO report_execution_date
	FROM rapporto
	WHERE id_rapporto = report_id AND anno = report_year;

	SELECT id_causale
	INTO causal_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = 2;

	CALL sp_ariesDepotOperationsInsert(
		quantity * -1,
		product_code,
		depot_id,
		report_execution_date,
		2,
		causal_id,
		operation_id
	); 

	SET operation_id = LAST_INSERT_ID(); 

	INSERT INTO magazzino_rapporto_materiale (id_operazione, id_rapporto, anno_rapporto, id_tab)
		VALUES (operation_id, report_id, report_year, tab_id);

END $$
DELIMITER ;

SET @USER_ID = 1;



DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_siantel BIT(1) DEFAULT 0;
	DECLARE report_filename VARCHAR(150);

	SELECT COUNT(*)
	INTO is_siantel
	FROM azienda 
	WHERE partita_iva = '03173480967';

	UPDATE magazzino_operazione mo
	INNER JOIN magazzino_rapporto_materiale mrm ON mo.id_operazione = mrm.id_operazione
	INNER JOIN rapporto ON rapporto.id_rapporto = mrm.id_rapporto AND rapporto.anno = mrm.anno_rapporto
	SET mo.data = rapporto.data_esecuzione;

	DELETE FROM magazzino_operazione  WHERE DATA >= CAST('2023-01-01' AS DATE) AND sorgente NOT IN (1,5,4); 


	DROP TEMPORARY TABLE IF EXISTS tmp_depots_operations;
	CREATE TEMPORARY TABLE tmp_depots_operations 
	SELECT * FROM magazzino_operazione WHERE DATA >= CAST('2023-01-01' AS DATE);

	DELETE FROM magazzino_operazione WHERE DATA >= CAST('2023-01-01' AS DATE);

	
	IF is_siantel = 0 THEN
		CALL sp_ariesDepotProductResetStocksBy(NULL, @RESULT);
	END IF;


	INSERT INTO magazzino_operazione
	SELECT * FROM tmp_depots_operations;

	DROP TEMPORARY TABLE IF EXISTS tmp_depots_operations;

END
$$

DELIMITER ;

CALL sp_tmp();



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN


	DECLARE done INT DEFAULT FALSE;
	DECLARE allow_depots_movement BIT;
	DECLARE ddtId INT;
	DECLARE ddtYear INT;
	DECLARE tabNumber INT;
	DECLARE causaleScarico INT;
	DECLARE quantity DECIMAL(11,2);
	DECLARE productCode VARCHAR(50);
	DECLARE curA CURSOR FOR SELECT ddt.Id_ddt, ddt.anno, articoli_ddt.numero_tab, causale_scarico, id_articolo, quantità FROM articoli_ddt INNER JOIN ddt
		ON articoli_ddt.id_ddt = ddt.id_ddt AND articoli_ddt.anno = ddt.anno WHERE data_documento  >= CAST('2023-01-01' AS DATE);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	OPEN curA;
	loopA: LOOP
		FETCH curA INTO ddtId, ddtYear, tabNumber, causaleScarico, productCode, quantity;
		IF done THEN
			LEAVE loopA;
		END IF;
		CALL sp_ariesDepotsDdtProductDelete(ddtId, ddtYear, tabNumber);

		IF productCode IS NOT NULL THEN
			
			SELECT  fnc_productAllowDepotsScale(productCode)
				INTO allow_depots_movement;


			IF (allow_depots_movement = 1) AND (causaleScarico IS NOT NULL) THEN
				CALL sp_ariesDepotsDdtProductInsert( ddtId, ddtYear, tabNumber,quantity,
						productCode, causaleScarico);
			END IF;
		END IF; 

	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN


	DECLARE done INT DEFAULT FALSE;
	DECLARE allow_depots_movement BIT;
	DECLARE ddtId INT;
	DECLARE ddtYear INT;
	DECLARE tabNumber INT;
	DECLARE causaleScarico INT;
	DECLARE quantity DECIMAL(11,2);
	DECLARE productCode VARCHAR(50);
	DECLARE curA CURSOR FOR SELECT ddt_ricevuti.Id_ddt, ddt_ricevuti.anno, numero_tab, causale_scarico, id_articolo, quantità FROM articoli_ddt_ricevuti INNER JOIN ddt_ricevuti
		ON articoli_ddt_ricevuti.id_ddt = ddt_ricevuti.id_ddt AND articoli_ddt_ricevuti.anno = ddt_ricevuti.anno WHERE data_documento  >= CAST('2023-01-01' AS DATE);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	OPEN curA;
	loopA: LOOP
		FETCH curA INTO ddtId, ddtYear, tabNumber, causaleScarico, productCode, quantity;
		IF done THEN
			LEAVE loopA;
		END IF;
		CALL sp_ariesDepotsReceivedDdtProductDelete(ddtId, ddtYear, tabNumber);

		IF productCode IS NOT NULL THEN
			
			SELECT  fnc_productAllowDepotsScale(productCode)
				INTO allow_depots_movement;


			IF (allow_depots_movement = 1) AND (causaleScarico IS NOT NULL) THEN
				CALL sp_ariesDepotsReceivedDdtProductInsert( ddtId, ddtYear, tabNumber,quantity,
						productCode, causaleScarico);
			END IF;
		END IF; 

	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;