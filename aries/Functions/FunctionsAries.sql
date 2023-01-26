SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS  fnc_jobScaleProductsFromReports;
DELIMITER // 
CREATE FUNCTION fnc_jobscaleproductsfromreports(JobId INT, JobYear INT) RETURNS TINYINT
BEGIN

	DECLARE ScaleFromReports TINYINT;
	DECLARE typename VARCHAR(12);
	
	SET typename = "cont_mat_rap";
	
	SELECT valore
	INTO ScaleFromReports
	FROM commessa_impostazioni 
	WHERE id_commessa = JobId 
		AND anno = JobYear 
		AND tipo = typename;
	
	IF ScaleFromReports IS NULL THEN
		SELECT valore
		INTO ScaleFromReports
		FROM commessa_impostazioni_default
		WHERE tipo = typename;
	END IF;
	
	IF ScaleFromReports IS NULL THEN
		SET ScaleFromReports = 0;
	END IF;
	
	RETURN  ScaleFromReports ;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_jobGetNextIdTab;
DELIMITER // 
CREATE FUNCTION fnc_jobGetNextIdTab(job_id INT, job_year INT, sub_job_id INT, lot_id INT) RETURNS INT
BEGIN

	DECLARE tab_id INT;
	
    SELECT IFNULL(MAX(id_tab + 1), 1)
        INTO tab_id
    FROM commessa_articoli
    WHERE id_commessa = job_id AND anno = job_year
        AND id_sottocommessa = sub_job_id AND id_lotto = lot_id;

    RETURN tab_id;
	
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS  fnc_jobGetVatValueByJob;
DELIMITER // 
CREATE FUNCTION fnc_jobGetVatValueByJob(job_id INT, job_year INT,
    sub_job_id INT, lot_id INT) RETURNS INT
BEGIN

	DECLARE vat_value INT;

    SELECT DISTINCT iv_lot
        INTO vat_value
    FROM commessa_preventivo
        INNER JOIN preventivo_lotto
        ON id_preventivo = commessa_preventivo.preventivo 
            AND anno_prev = preventivo_lotto.anno
            AND Pidlotto = preventivo_lotto.posizione
            AND rev = preventivo_lotto.id_revisione
    WHERE commessa_preventivo.id_commessa = job_id AND commessa_preventivo.anno = job_year
        AND commessa_preventivo.id_sottocommessa = sub_job_id AND commessa_preventivo.lotto = lot_id
    LIMIT 1;

	
    IF vat_value IS NULL THEN
        SELECT MAX(iva)
            INTO vat_value
        FROM commessa_articoli
        WHERE id_commessa = job_id AND anno = job_year
            AND id_lotto = lot_id AND id_sottocommessa = sub_job_id;
    END IF;

    	
    IF vat_value IS NULL THEN
        SELECT aliquota
            INTO vat_value
        FROM tipo_iva
        WHERE normale = 1;
    END IF;
	
	RETURN  vat_value;
	
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS  fnc_jobGetPriceHourByJob;
DELIMITER // 
CREATE FUNCTION fnc_jobGetPriceHourByJob(job_id INT, job_year INT,
    sub_job_id INT, lot_id INT) RETURNS DECIMAL(11, 2)
BEGIN

	DECLARE hour_price DECIMAL(11, 2);

    SELECT DISTINCT ora_p
        INTO hour_price
    FROM commessa_preventivo
        INNER JOIN preventivo_lotto
        ON id_preventivo = commessa_preventivo.preventivo 
            AND anno_prev = preventivo_lotto.anno
            AND Pidlotto = preventivo_lotto.posizione
            AND rev = preventivo_lotto.id_revisione
    WHERE commessa_preventivo.id_commessa = job_id AND commessa_preventivo.anno = job_year
        AND commessa_preventivo.id_sottocommessa = sub_job_id AND commessa_preventivo.lotto = lot_id
    LIMIT 1;

	
    IF hour_price IS NULL THEN
        SELECT MAX(prezzo_ora)
            INTO hour_price
        FROM commessa_articoli
        WHERE id_commessa = job_id AND anno = job_year
            AND id_lotto = lot_id AND id_sottocommessa = sub_job_id;
    END IF;

    IF hour_price IS NULL THEN
        SELECT ora_normale
            INTO hour_price
        FROM abbonamento
        WHERE generale=1 ORDER BY generale desc, anno desc
        LIMIT 1;
    END IF;
	
	RETURN  hour_price;
	
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS  fnc_jobGetCostHourByJob;
DELIMITER // 
CREATE FUNCTION fnc_jobGetCostHourByJob(job_id INT, job_year INT,
    sub_job_id INT, lot_id INT) RETURNS DECIMAL(11, 2)
BEGIN

	DECLARE hour_cost DECIMAL(11, 2);

    SELECT DISTINCT ora_c
        INTO hour_cost
    FROM commessa_preventivo
        INNER JOIN preventivo_lotto
        ON id_preventivo = commessa_preventivo.preventivo 
            AND anno_prev = preventivo_lotto.anno
            AND Pidlotto = preventivo_lotto.posizione
            AND rev = preventivo_lotto.id_revisione
    WHERE commessa_preventivo.id_commessa = job_id AND commessa_preventivo.anno = job_year
        AND commessa_preventivo.id_sottocommessa = sub_job_id AND commessa_preventivo.lotto = lot_id
    LIMIT 1;

	
    IF hour_cost IS NULL THEN
        SELECT MAX(costo_ora)
            INTO hour_cost
        FROM commessa_articoli
        WHERE id_commessa = job_id AND anno = job_year
            AND id_lotto = lot_id AND id_sottocommessa = sub_job_id;
    END IF;

    IF hour_cost IS NULL THEN
        SELECT costo_h INTO hour_cost
        FROM tariffario
        WHERE normale=1
        LIMIT 1;
    END IF;
	
	RETURN  hour_cost;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_reportHasJobLink;
DELIMITER // 
CREATE FUNCTION fnc_reportHasJobLink(report_id INT, report_year INT) RETURNS BIT(1)
BEGIN

	DECLARE has_job_link BIT(1);

    SELECT COUNT(id_commessa) > 0
        INTO has_job_link
    FROM commessa_rapporto
    WHERE id_rapporto = report_id
        AND anno_rapporto = report_year;
	
	RETURN  has_job_link;
	
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS  fnc_ddtHasJobLink;
DELIMITER // 
CREATE FUNCTION fnc_ddtHasJobLink(ddt_id INT, ddt_year INT) RETURNS BIT(1)
BEGIN

	DECLARE has_job_link BIT(1);

    SELECT COUNT(id_commessa) > 0
        INTO has_job_link
    FROM commessa_ddt
    WHERE id_ddt = ddt_id
        AND anno_ddt = ddt_year;
	
	RETURN  has_job_link;
	
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS fnc_jobRemainingAmountForSpecificProduct;
DELIMITER // 
CREATE FUNCTION fnc_jobremainingamountforspecificproduct(JobId SMALLINT, JobYear SMALLINT, 
	SubJobId SMALLINT, JobLotId SMALLINT, productid VARCHAR (11)) RETURNS SMALLINT
BEGIN
	DECLARE outVal DECIMAL(11,2);
	
	SELECT SUM(qta_commessa - qta_utilizzata)
	INTO outVal
	FROM vw_jobbody
	WHERE Id_commessa = JobId 
		AND anno= JobYear 
		AND lotto = JobLotId
        AND id_sottocommessa=SubJobId
		AND codice_articolo=productid;
	
	IF outVal<=0 THEN 
		SET outVal = 0 ;
	END IF;
	
	IF outVal IS NULL THEN 
		SET outVal =-1;
	END IF;
	
	RETURN outVal;
END // 
DELIMITER ;

DROP FUNCTION IF EXISTS  fnc_reportHasDdtLink;
DELIMITER // 
CREATE FUNCTION fnc_reportHasDdtLink(report_id INT, report_year INT) RETURNS BIT(1)
BEGIN

	DECLARE has_ddt_link BIT(1);

    SELECT COUNT(id_rapporto) > 0
        INTO has_ddt_link
    FROM ddt_rapporto
    WHERE id_rapporto = report_id
        AND anno_rapporto = report_year;
	
	RETURN  has_ddt_link;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_reportProductHasDepotLink;
DELIMITER // 
CREATE FUNCTION fnc_reportProductHasDepotLink(
    report_id INT,
    report_year INT,
    tab_id INT
) RETURNS BIT(1)
BEGIN

	DECLARE has_depot_link BIT(1);

    SELECT COUNT(id_rapporto) > 0
        INTO has_depot_link
    FROM magazzino_rapporto_materiale
    WHERE id_rapporto = report_id
        AND anno_rapporto = report_year
        AND id_tab = tab_id;
	
	RETURN  has_depot_link;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_supplierInvoiceProductAllowDepotsScale;
DELIMITER // 
CREATE FUNCTION fnc_supplierInvoiceProductAllowDepotsScale(invoice_id INT, invoice_year INT, product_code VARCHAR(16)) RETURNS BIT(1)
BEGIN

	DECLARE allow_insert BIT(1);

	-- CONTROL IF INVOICE TYPE = 5 (FATTURA ACCOMPAGNATORIA)
	SELECT 	COUNT(id_fattura)
				INTO allow_insert
	FROM  	fornfattura 
	WHERE 	(tipo_fattura = 5 AND id_fattura=invoice_id AND anno=invoice_year); 
	
	-- CONTROL IF PRODUCT HAS CATEGORY THAT ALLOW DEPOSITS MOVEMENT
	IF (allow_insert = 1) THEN
		SELECT  fnc_productAllowDepotsScale(product_code)
			INTO allow_insert;
	END IF;
    
    IF allow_insert IS NULL THEN
        SET allow_insert = 0;
    END IF;
	
	RETURN  allow_insert;
	
END // 
DELIMITER ;



DROP FUNCTION IF EXISTS  fnc_invoiceProductAllowDepotsScale;
DELIMITER // 
CREATE FUNCTION fnc_invoiceProductAllowDepotsScale(invoice_id INT, invoice_year INT, product_code VARCHAR(16)) RETURNS BIT(1)
BEGIN

	DECLARE allow_insert BIT(1);

	-- CONTROL IF INVOICE TYPE = 5 (FATTURA ACCOMPAGNATORIA)
	SELECT 	COUNT(id_fattura)
				INTO allow_insert
	FROM  	fattura 
	WHERE 	(tipo_fattura = 5 AND id_fattura=invoice_id AND anno=invoice_year); 
	
	-- CONTROL IF PRODUCT HAS CATEGORY THAT ALLOW DEPOSITS MOVEMENT
	IF (allow_insert = 1) THEN
		SELECT  fnc_productAllowDepotsScale(product_code)
			INTO allow_insert; 
	END IF; 
    
    IF allow_insert IS NULL THEN
        SET allow_insert = 0;
    END IF;

	RETURN  allow_insert;
	
END // 
DELIMITER ;



DROP FUNCTION IF EXISTS  fnc_productAllowDepotsScale;
DELIMITER // 
CREATE FUNCTION fnc_productAllowDepotsScale(product_code VARCHAR(16)) RETURNS BIT(1)
BEGIN

	DECLARE allow_insert BIT(1);
	
	-- CONTROL IF PRODUCT HAS CATEGORY THAT ALLOW DEPOSITS MOVEMENT
    SELECT  IFNULL(categoria_merciologica.Movimenta_magazzino, 1)
                INTO allow_insert
    FROM  	articolo 
                LEFT JOIN categoria_merciologica 
                    ON articolo.Categoria = categoria_merciologica.Id_categoria 
    WHERE 	articolo.Codice_articolo = product_code;
    

    IF allow_insert IS NULL THEN
        SET allow_insert = 0;
    END IF;
	
	RETURN  allow_insert;
	
END // 
DELIMITER ;



DROP FUNCTION IF EXISTS  fnc_productAllowSystemScale;
DELIMITER // 
CREATE FUNCTION fnc_productAllowSystemScale(product_code VARCHAR(16)) RETURNS BIT(1)
BEGIN

	DECLARE allow_insert BIT(1);
	
	-- CHECK IF PRODUCT HAS CATEGORY THAT ALLOW DEPOSITS MOVEMENT
    SELECT  IFNULL(categoria_merciologica.Movimenta_impianto, 1)
                INTO allow_insert
    FROM  	articolo 
                LEFT JOIN categoria_merciologica 
                    ON articolo.Categoria = categoria_merciologica.Id_categoria 
    WHERE 	articolo.Codice_articolo = product_code;

    IF allow_insert IS NULL THEN
        SET allow_insert = 0;
    END IF;
	
	RETURN  allow_insert;
	
END // 
DELIMITER ;



DROP FUNCTION IF EXISTS  fnc_productIsKit;
DELIMITER // 
CREATE FUNCTION fnc_productIsKit(product_code VARCHAR(16)) RETURNS BIT(1)
BEGIN

	DECLARE is_kit BIT(1);
	
    SELECT  IFNULL(articolo.is_kit, 0)
                INTO is_kit
    FROM  	articolo
    WHERE 	Codice_articolo = product_code;

    IF is_kit IS NULL THEN
        SET is_kit = 0;
    END IF;
	
	RETURN  is_kit;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_reportIsRightOfCallChargeable;
DELIMITER // 
CREATE FUNCTION fnc_reportIsRightOfCallChargeable(report_id INT(11), year INT(11)) RETURNS BIT(1)
BEGIN
	DECLARE is_right_of_call_chargeble BIT(1);
	DECLARE included_roc INT(11);
	DECLARE subscription_id INT(11);
	DECLARE used_roc INT(11);
    DECLARE system_id INT(11);
    DECLARE report_has_right_of_call BIT(1);
    DECLARE is_extra_ordinary BIT(1);

    SELECT
        id_impianto, tipo_diritto_chiamata = 2, diritto_chiamata = 1 AND tipo_diritto_chiamata <> 0, abbonamento
    INTO system_id, is_extra_ordinary, report_has_right_of_call, subscription_id
    FROM rapporto
    WHERE id_rapporto = report_id AND anno = year;

    IF subscription_id IS NOT NULL AND report_has_right_of_call THEN
        SELECT IF(is_extra_ordinary, diritto_chiamata_straordinario_inclusa, diritto_chiamata_gratis) INTO included_roc
        FROM abbonamento
        WHERE id_abbonamento = subscription_id;

        SELECT COUNT(*) INTO used_roc
        FROM rapporto
        WHERE anno = year
            AND id_impianto = system_id
            AND diritto_chiamata = 1
            AND id_rapporto <> report_id
            AND IF(is_extra_ordinary, 2, 1) = tipo_diritto_chiamata;

        SET is_right_of_call_chargeble = IFNULL(included_roc, 0) <= IFNULL(used_roc, 0);
    END IF;

    IF is_right_of_call_chargeble IS NULL THEN
        SET is_right_of_call_chargeble = 0;
    END IF;
	
	RETURN  is_right_of_call_chargeble;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_systemIsRightOfCallChargeable;
DELIMITER // 
CREATE FUNCTION fnc_systemIsRightOfCallChargeable(system_id INT(11), year INT(11), is_extra_ordinary BIT(1)) RETURNS BIT(1)
BEGIN
	DECLARE is_right_of_call_chargeble BIT(1);
	DECLARE included_roc INT(11);
	DECLARE subscription_id INT(11);
	DECLARE used_roc INT(11);
	
    SELECT id_abbonamenti INTO subscription_id
    FROM impianto_abbonamenti
    WHERE id_impianto = system_id AND anno = year;

    IF subscription_id IS NOT NULL THEN
        SELECT IF(is_extra_ordinary, diritto_chiamata_straordinario_inclusa, diritto_chiamata_gratis) INTO included_roc
        FROM abbonamento
        WHERE id_abbonamento = subscription_id;

        SELECT COUNT(*) INTO used_roc
        FROM rapporto
        WHERE anno = year
            AND id_impianto = system_id
            AND diritto_chiamata = 1
            AND IF(is_extra_ordinary, 2, 1) = dir_ric_chiamata;

        SET is_right_of_call_chargeble = IFNULL(included_roc, 0) < IFNULL(used_roc, 0);
    END IF;

    IF is_right_of_call_chargeble IS NULL THEN
        SET is_right_of_call_chargeble = 0;
    END IF;
	
	RETURN  is_right_of_call_chargeble;
	
END // 
DELIMITER ;



DROP FUNCTION IF EXISTS  fnc_productInternalPriceId;
DELIMITER // 
CREATE FUNCTION fnc_productInternalPriceId() RETURNS INT(11)
BEGIN
	DECLARE val INT(11);
	SET val = 2;
	RETURN  val;
	
END // 
DELIMITER ;


DROP FUNCTION IF EXISTS  fnc_productInternalCostId;
DELIMITER // 
CREATE FUNCTION fnc_productInternalCostId() RETURNS INT(11)
BEGIN
	DECLARE val INT(11);
	SET val = 1;
	RETURN  val;
	
END // 
DELIMITER ;