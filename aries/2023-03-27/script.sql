ALTER TABLE `rapporto_totali`
	ADD COLUMN `prezzo_manutenzione` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `anno`,
	ADD COLUMN `prezzo_diritto_chiamata` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `prezzo_manutenzione`;
ALTER TABLE `rapporto_totali`
	ADD COLUMN `costo_diritto_chiamata` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `prezzo_manutenzione`;


ALTER TABLE `resoconto_totali`
	ADD COLUMN `prezzo_manutenzione` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `anno`,
	ADD COLUMN `prezzo_diritto_chiamata` DECIMAL(10,2) NOT NULL DEFAULT '0' AFTER `prezzo_manutenzione`;
ALTER TABLE `resoconto_totali`
	ADD COLUMN `costo_diritto_chiamata` DECIMAL(10,2) NOT NULL DEFAULT '0.00' AFTER `prezzo_manutenzione`;


truncate table resoconto_totali;
truncate table rapporto_totali;
-- ############################# REPORT TOTALS  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportTotalsInsert; 

DROP TRIGGER IF EXISTS trg_afterReportTotalsUpdate; 
 
DROP TRIGGER IF EXISTS trg_afterReportTotalsDelete; 


-- ############################# REPORT GROUP REPORT LINK  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkInsert; 

DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkUpdate; 
 

DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkDelete; 



-- ############################# REPORTS GROUPS ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportGroupInsert; 


DROP FUNCTION IF EXISTS  fnc_reportIsRightOfCallChargeableTmp;
DELIMITER // 
CREATE FUNCTION fnc_reportIsRightOfCallChargeableTmp(report_id INT(11), year INT(11)) RETURNS BIT(1)
BEGIN
	DECLARE is_right_of_call_chargeble BIT(1);
	DECLARE included_roc INT(11);
	DECLARE subscription_id INT(11);
	DECLARE used_roc INT(11);
    DECLARE system_id INT(11);
    DECLARE report_has_right_of_call BIT(1);
    DECLARE is_extra_ordinary BIT(1);
	DECLARE report_date DATE;

    SELECT
        id_impianto, tipo_diritto_chiamata = 2, diritto_chiamata = 1 AND tipo_diritto_chiamata <> 0, abbonamento, data
    INTO system_id, is_extra_ordinary, report_has_right_of_call, subscription_id, report_date
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
			AND data <= report_date
            AND IF(is_extra_ordinary, 2, 1) = tipo_diritto_chiamata;

        SET is_right_of_call_chargeble = IFNULL(included_roc, 0) <= IFNULL(used_roc, 0);
    END IF;

    IF is_right_of_call_chargeble IS NULL THEN
        SET is_right_of_call_chargeble = 0;
    END IF;
	
	RETURN  is_right_of_call_chargeble;
	
END // 
DELIMITER ;



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE report_id BIGINT(20);
	DECLARE report_year INT(11);
	DECLARE default_hourly_price DECIMAL(11, 2);
	DECLARE default_hourly_cost DECIMAL(11, 2);
	DECLARE default_hourly_cost_extra DECIMAL(11, 2);
	DECLARE default_km_cost DECIMAL(11,2);
	DECLARE total_trip_price DECIMAL(11,2);
	DECLARE total_trip_cost DECIMAL(11,2);
	DECLARE total_work_price DECIMAL(11,2);
	DECLARE total_work_cost DECIMAL(11,2);
	DECLARE total_products_price DECIMAL(11,2);
	DECLARE total_products_cost DECIMAL(11,2);
	DECLARE total_price DECIMAL(11,2);
	DECLARE total_cost DECIMAL(11,2);
	DECLARE total_maintenance_price DECIMAL(11,2);
	
	DECLARE right_of_call_chargeable BIT(1);
	DECLARE right_of_call_cost DECIMAL(11,2);
	DECLARE right_of_call_price DECIMAL(11,2);
	DECLARE curA CURSOR FOR SELECT Id_rapporto, anno FROM rapporto ORDER BY anno asc, data asc, id_rapporto ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	

	SELECT costo_h, straordinario_c, costo_km, prezzo
		INTO default_hourly_cost, default_hourly_cost_extra, default_km_cost, default_hourly_price
	FROM tariffario
	ORDER BY normale DESC
	LIMIT 1;
	
	OPEN curA;
	loopA: LOOP
		SET done = 0;
		FETCH curA INTO report_id, report_year;
		IF done THEN
			LEAVE loopA;
		END IF;
		
		SET total_work_cost = 0;
		SET total_work_price = 0;
		SET total_trip_cost = 0;
		SET total_trip_price = 0;
		SET total_products_cost = 0;
		SET total_products_price = 0;
		SET total_cost = 0;
		SET total_price = 0;
		SET right_of_call_price = 0;
		SET right_of_call_cost = 0;
		SET total_maintenance_price = 0;


	SELECT fnc_reportIsRightOfCallChargeableTmp(report_id, report_year) INTO right_of_call_chargeable;

	IF right_of_call_chargeable THEN
		SELECT
			CAST(
				IFNULL(IF(rapporto.tipo_diritto_chiamata = 1, abbonamento.diritto_chiamata, abbonamento.diritto_chiamata_straordinario), 0)
			AS DECIMAL(10, 2)),
			CAST(
				ROUND(IFNULL(IF(rapporto.tipo_diritto_chiamata = 1, abbonamento.diritto_chiamata, abbonamento.diritto_chiamata_straordinario), 0) / 2, 2)
			AS DECIMAL(10, 2))
		INTO right_of_call_price,
			right_of_call_cost
		FROM rapporto
			LEFT JOIN abbonamento ON id_abbonamento=abbonamento
		WHERE rapporto.id_rapporto = report_id AND rapporto.anno = report_year ;
	ELSE
		SET right_of_call_cost = 0;
		SET right_of_call_price = 0;
	END IF;

		SELECT SUM(CAST(ROUND(IFNULL(ora_normale, 0) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'prezzo_lavoro',
			SUM(CAST(ROUND(IF(straordinario = 1, IFNULL(straordinario_c, default_hourly_cost_extra), IFNULL(costo_h, default_hourly_cost)) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'costo_lavoro'
			INTO total_work_price, total_work_cost
		FROM rapporto_tecnico_lavoro
			INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico_lavoro.tecnico
			LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
		WHERE id_rapporto = report_id AND anno = report_year
		GROUP BY id_rapporto, anno;


		SELECT SUM(CAST(ROUND((km * IFNULL(costo_km, default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (Tempo_viaggio/ 60 * IFNULL(costo_h, default_hourly_cost)), 2) AS DECIMAL(11,2))) as costo_viaggio,
			SUM(CAST(ROUND((km * IFNULL(IFNULL(prezzo_strada, costo_km), default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (Tempo_viaggio/ 60 *  IFNULL(IFNULL(abbonamento.ora_normale, prezzo), default_hourly_price)), 2) AS DECIMAL(11,2))) as prezzo_viaggio
			INTO total_trip_cost, total_trip_price
		FROM rapporto_tecnico
			INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico.tecnico
			LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
			INNER JOIN rapporto ON rapporto.id_rapporto=rapporto_tecnico.id_rapporto AND rapporto.anno=rapporto_tecnico.anno
			LEFT JOIN abbonamento ON id_abbonamento=abbonamento
		WHERE rapporto_tecnico.id_rapporto = report_id AND rapporto_tecnico.anno = report_year
		GROUP BY rapporto_tecnico.id_rapporto, rapporto_tecnico.anno;

		SELECT SUM(CAST(ROUND(ROUND(IFNULL(prezzo, 0) * (100 - IFNULL(sconto, 0)) / 100, 2) * IFNULL(quantità, 0), 2)  AS DECIMAL(11, 2))) as Prezzo_materiale,
			SUM(CAST(ROUND(ROUND(IFNULL(costo, 0), 2) * IFNULL(quantità, 0), 2)  AS DECIMAL(11, 2))) as Costo_materiale
			INTO total_products_price,
			total_products_cost
		FROM rapporto_materiale
		WHERE id_rapporto = report_id AND anno = report_year
		GROUP BY id_rapporto, anno;

		
		SELECT controllo_periodico
		INTO total_maintenance_price
		FROM rapporto
		WHERE id_rapporto = report_id AND anno = report_year;


		SET total_work_cost = IFNULL(total_work_cost, 0);
		SET total_work_price = IFNULL(total_work_price, 0);
		SET total_trip_cost = IFNULL(total_trip_cost, 0);
		SET total_trip_price = IFNULL(total_trip_price, 0);
		SET total_products_cost = IFNULL(total_products_cost, 0);
		SET total_products_price = IFNULL(total_products_price, 0);
		SET right_of_call_cost = IFNULL(right_of_call_cost, 0);
		SET right_of_call_price = IFNULL(right_of_call_price, 0);
		SET total_maintenance_price = IFNULL(total_maintenance_price, 0);
		SET total_cost = total_work_cost + total_trip_cost + total_products_cost + right_of_call_cost;
		SET total_price = total_work_price + total_trip_price + total_products_price + right_of_call_price + total_maintenance_price;


		INSERT INTO  rapporto_totali (id_rapporto, anno, prezzo_manutenzione, costo_diritto_chiamata, prezzo_diritto_chiamata, costo_lavoro, prezzo_lavoro, costo_viaggio, prezzo_viaggio, costo_materiale, prezzo_materiale, costo_totale, prezzo_totale)
		VALUES (report_id, report_year, total_maintenance_price, right_of_call_cost, right_of_call_price, total_work_cost, total_work_price, total_trip_cost, total_trip_price, total_products_cost, total_products_price, total_cost, total_price ) 
		ON DUPLICATE KEY UPDATE costo_lavoro = total_work_cost,
				prezzo_lavoro = total_work_price,
				costo_viaggio = total_trip_cost,
				prezzo_viaggio = total_trip_price,
				costo_materiale = total_products_cost,
				prezzo_materiale = total_products_price,
				costo_totale = total_cost,
				prezzo_totale = total_price,
				prezzo_manutenzione = total_maintenance_price,
				costo_diritto_chiamata = right_of_call_cost,
				prezzo_diritto_chiamata = right_of_call_price;
		
	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;



DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	INSERT INTO resoconto_totali (id_resoconto, anno, prezzo_manutenzione, costo_diritto_chiamata, prezzo_diritto_chiamata, costo_lavoro, prezzo_lavoro, costo_viaggio, prezzo_viaggio, costo_materiale, prezzo_materiale, costo_totale, prezzo_totale)
	SELECT  resoconto.id_resoconto,
		resoconto.anno,
		IFNULL(SUM(prezzo_manutenzione), 0),
		IFNULL(SUM(costo_diritto_chiamata), 0),
		IFNULL(SUM(prezzo_diritto_chiamata), 0),
		IFNULL(SUM(costo_lavoro), 0),
		IFNULL(SUM(prezzo_lavoro), 0),
		IFNULL(SUM(costo_viaggio), 0),
		IFNULL(SUM(prezzo_viaggio), 0),
		IFNULL(SUM(costo_materiale), 0),
		IFNULL(SUM(prezzo_materiale), 0),
		IFNULL(SUM(costo_totale), 0),
		IFNULL(SUM(prezzo_totale), 0)
	FROM resoconto
		LEFT JOIN resoconto_rapporto ON resoconto.id_resoconto = resoconto_rapporto.id_resoconto AND resoconto.anno = anno_reso
		LEFT JOIN rapporto_totali ON resoconto_rapporto.id_rapporto = rapporto_totali.id_rapporto and resoconto_rapporto.anno = rapporto_totali.anno
	GROUP BY id_resoconto, anno;


END $$
DELIMITER ;
CALL tmp;




delimiter //
CREATE TRIGGER `trg_afterReportTotalsInsert` AFTER INSERT ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 
delimiter //
CREATE TRIGGER `trg_afterReportTotalsUpdate` AFTER UPDATE ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(NEW.id_rapporto, NEW.anno);
END
//
delimiter ;
delimiter //
CREATE TRIGGER `trg_afterReportTotalsDelete` AFTER DELETE ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(OLD.id_rapporto, OLD.anno);
END
//
delimiter ; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkInsert` AFTER INSERT ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(NEW.id_resoconto, NEW.anno_reso);
END
//
delimiter ; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkUpdate` AFTER UPDATE ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(NEW.id_resoconto, NEW.anno_reso);
	
	IF (OLD.id_resoconto <> NEW.id_resoconto OR OLD.anno_reso <> NEW.anno_reso) THEN
		CALL sp_ariesReportGroupTotalsRefresh(OLD.id_resoconto, OLD.anno_reso);
	END IF;
END
//
delimiter ;

delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkDelete` AFTER DELETE ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(OLD.id_resoconto, OLD.anno_reso);
END
//
delimiter ; 

delimiter //
CREATE TRIGGER `trg_afterReportGroupInsert` AFTER INSERT ON `resoconto` FOR EACH ROW 
BEGIN	
	INSERT INTO  resoconto_totali (id_resoconto, anno, prezzo_manutenzione, costo_diritto_chiamata, prezzo_diritto_chiamata, costo_lavoro, prezzo_lavoro, costo_viaggio, prezzo_viaggio, costo_materiale, prezzo_materiale, costo_totale, prezzo_totale)
	VALUES (NEW.id_resoconto, NEW.anno, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
END

//
delimiter ; 


DROP FUNCTION IF EXISTS  fnc_reportIsRightOfCallChargeableTmp;

ALTER TABLE `azienda`
	DROP COLUMN `fattura_pa_api_key`;


INSERT INTO `configurazione_loghi` (`nome`, `tipo`) VALUES ('PREVENTIVO', 'FIRMA PRIVACY');