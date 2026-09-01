DROP PROCEDURE IF EXISTS sp_ariesReportTotalsRefresh;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportTotalsRefresh`(
	IN report_id INT(11),
	IN report_year INT(11)
)
BEGIN
	DECLARE total_maintenance_price DECIMAL(11,2);
	DECLARE total_maintenance_cost DECIMAL(11,2);
	DECLARE total_trip_price DECIMAL(11,2);
	DECLARE total_trip_cost DECIMAL(11,2);
	DECLARE total_work_price DECIMAL(11,2);
	DECLARE total_work_cost DECIMAL(11,2);
	DECLARE total_products_price DECIMAL(11,2);
	DECLARE total_products_cost DECIMAL(11,2);
	DECLARE total_price DECIMAL(11,2);
	DECLARE total_cost DECIMAL(11,2);
	DECLARE default_hourly_price DECIMAL(11, 2);
	DECLARE default_hourly_cost DECIMAL(11, 2);
	DECLARE default_hourly_cost_extra DECIMAL(11, 2);
	DECLARE default_km_cost DECIMAL(11,2);
	DECLARE right_of_call_chargeable BIT(1);
	DECLARE right_of_call_cost DECIMAL(11,2);
	DECLARE right_of_call_price DECIMAL(11,2);
	DECLARE is_under_warranty BIT(1);
	DECLARE is_price_predefined BIT(1);
	DECLARE materials_are_included BIT(1);

	SELECT costo_h, straordinario_c, costo_km, prezzo
		INTO default_hourly_cost, default_hourly_cost_extra, default_km_cost, default_hourly_price
	FROM tariffario
	ORDER BY normale DESC
	LIMIT 1;

	SELECT fnc_reportIsRightOfCallChargeable(report_id, report_year) INTO right_of_call_chargeable;

	-- In the legacy subscription model, materiali_fatt = 1 means that materials are included.
	SELECT IF(IFNULL(abbonamento.materiali_fatt, 0) = 1, b'1', b'0')
		INTO materials_are_included
	FROM rapporto
		LEFT JOIN abbonamento ON rapporto.abbonamento = abbonamento.id_abbonamento
	WHERE rapporto.id_rapporto = report_id AND rapporto.anno = report_year;

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

	SELECT
		controllo_periodico * controllo_periodico_quantita,
		controllo_periodico_costo * controllo_periodico_quantita
	INTO
		total_maintenance_price,
		total_maintenance_cost
	FROM rapporto
	WHERE id_rapporto = report_id AND anno = report_year;

	SELECT SUM(CAST(ROUND(IFNULL(ora_normale, 0) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'prezzo_lavoro',
		SUM(CAST(ROUND(IF(straordinario = 1, IFNULL(straordinario_c, default_hourly_cost_extra), IFNULL(costo_h, default_hourly_cost)) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'costo_lavoro'
		INTO total_work_price, total_work_cost
	FROM rapporto_tecnico_lavoro
		INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico_lavoro.tecnico
		LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
	WHERE id_rapporto = report_id AND anno = report_year
	GROUP BY id_rapporto, anno;

	SELECT SUM(CAST(ROUND((km * IFNULL(costo_km, default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (CAST(Tempo_viaggio/ 60 AS DECIMAL(11,2)) * IFNULL(costo_h, default_hourly_cost)), 2) AS DECIMAL(11,2))) as costo_viaggio,
		SUM(CAST(ROUND((km * IFNULL(IFNULL(prezzo_strada, costo_km), default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (CAST(Tempo_viaggio/ 60 AS DECIMAL(11,2)) *  IFNULL(IFNULL(abbonamento.ora_normale, prezzo), default_hourly_price)), 2) AS DECIMAL(11,2))) as prezzo_viaggio
		INTO total_trip_cost, total_trip_price
	FROM rapporto_tecnico
		INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico.tecnico
		LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
		INNER JOIN rapporto ON rapporto.id_rapporto=rapporto_tecnico.id_rapporto AND rapporto.anno=rapporto_tecnico.anno
		LEFT JOIN abbonamento ON id_abbonamento=abbonamento
	WHERE rapporto_tecnico.id_rapporto = report_id AND rapporto_tecnico.anno = report_year
	GROUP BY rapporto_tecnico.id_rapporto, rapporto_tecnico.anno;

	SELECT SUM(CAST(ROUND(ROUND(IFNULL(prezzo, 0) * (100 - IFNULL(sconto, 0)) / 100, 2) * IFNULL(quantità, 0), 2) AS DECIMAL(11, 2))) as Prezzo_materiale,
		SUM(CAST(ROUND(ROUND(IFNULL(costo, 0), 2) * IFNULL(quantità, 0), 2) AS DECIMAL(11, 2))) as Costo_materiale
		INTO total_products_price,
		total_products_cost
	FROM rapporto_materiale
	WHERE id_rapporto = report_id AND anno = report_year
	GROUP BY id_rapporto, anno;

	SET total_work_cost = IFNULL(total_work_cost, 0);
	SET total_work_price = IFNULL(total_work_price, 0);
	SET total_trip_cost = IFNULL(total_trip_cost, 0);
	SET total_trip_price = IFNULL(total_trip_price, 0);
	SET total_products_cost = IFNULL(total_products_cost, 0);
	SET total_products_price = IF(materials_are_included, 0, IFNULL(total_products_price, 0));
	SET right_of_call_cost = IFNULL(right_of_call_cost, 0);
	SET right_of_call_price = IFNULL(right_of_call_price, 0);
	SET total_maintenance_price = IFNULL(total_maintenance_price, 0);
	SET total_maintenance_cost = IFNULL(total_maintenance_cost, 0);

	-- A fixed maintenance price absorbs work, trip and call-right prices.
	-- Their real costs remain available for profitability reporting.
	IF total_maintenance_price > 0 THEN
		SET total_work_price = 0;
		SET total_trip_price = 0;
		SET right_of_call_price = 0;
	END IF;

	SET total_cost = total_products_cost + IF(total_maintenance_cost > 0 AND total_work_cost + total_trip_cost = 0, total_maintenance_cost, total_work_cost + total_trip_cost + right_of_call_cost);
	SET total_price = total_products_price + IF(total_maintenance_price > 0, total_maintenance_price, total_trip_price + total_work_price + right_of_call_price);

	UPDATE rapporto_totali
	SET
		prezzo_manutenzione = total_maintenance_price,
		costo_manutenzione = total_maintenance_cost,
		prezzo_diritto_chiamata = right_of_call_price,
		costo_diritto_chiamata = right_of_call_cost,
		costo_lavoro = total_work_cost,
		prezzo_lavoro = total_work_price,
		costo_viaggio = total_trip_cost,
		prezzo_viaggio = total_trip_price,
		costo_materiale = total_products_cost,
		prezzo_materiale = total_products_price,
		costo_totale = total_cost,
		prezzo_totale = total_price
	WHERE id_rapporto = report_id AND anno = report_year;
END //
DELIMITER ;

UPDATE rapporto_totali
INNER JOIN rapporto
	ON rapporto.id_rapporto = rapporto_totali.id_rapporto
	AND rapporto.anno = rapporto_totali.anno
INNER JOIN abbonamento
	ON abbonamento.id_abbonamento = rapporto.abbonamento
SET rapporto_totali.prezzo_totale = rapporto_totali.prezzo_totale - rapporto_totali.prezzo_materiale,
	rapporto_totali.prezzo_materiale = 0
WHERE IFNULL(abbonamento.materiali_fatt, 0) = 1
	AND rapporto_totali.prezzo_materiale <> 0;

UPDATE rapporto_totali
SET prezzo_viaggio = 0,
	prezzo_lavoro = 0,
	prezzo_diritto_chiamata = 0
WHERE prezzo_manutenzione > 0
	AND (
		prezzo_viaggio <> 0
		OR prezzo_lavoro <> 0
		OR prezzo_diritto_chiamata <> 0
	);

-- Recalculate periodic-check reports executed from 20 July 2026 through today.
-- Updating rapporto_totali also refreshes every linked resoconto_totali through
-- trg_afterReportTotalsUpdate and sp_ariesReportGroupTotalsRefreshByReport.
DROP PROCEDURE IF EXISTS sp_tempRefreshPeriodicReportTotalsFrom20260720;
DELIMITER //
CREATE PROCEDURE sp_tempRefreshPeriodicReportTotalsFrom20260720()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE current_report_id INT(11);
	DECLARE current_report_year INT(11);
	DECLARE periodic_reports CURSOR FOR
		SELECT rapporto.id_rapporto, rapporto.anno
		FROM rapporto
		WHERE rapporto.tipo_intervento = 6
			AND rapporto.data_esecuzione >= '2026-01-01'
			AND rapporto.data_esecuzione <= CURDATE();
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN periodic_reports;
	refresh_loop: LOOP
		FETCH periodic_reports INTO current_report_id, current_report_year;
		IF done = 1 THEN
			LEAVE refresh_loop;
		END IF;

		CALL sp_ariesReportTotalsRefresh(current_report_id, current_report_year);
	END LOOP;
	CLOSE periodic_reports;
END //
DELIMITER ;

CALL sp_tempRefreshPeriodicReportTotalsFrom20260720();
DROP PROCEDURE IF EXISTS sp_tempRefreshPeriodicReportTotalsFrom20260720;
