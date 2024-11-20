
DROP PROCEDURE IF EXISTS sp_ariesReportGroupTotalsRefresh;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportGroupTotalsRefresh`(
	IN report_group_id INT(11),
	IN report_group_year INT(11)
)
BEGIN

	DECLARE total_trip_price DECIMAL(11,2);
	DECLARE total_trip_cost DECIMAL(11,2);
	DECLARE total_work_price DECIMAL(11,2);
	DECLARE total_work_cost DECIMAL(11,2);
	DECLARE total_products_price DECIMAL(11,2);
	DECLARE total_products_cost DECIMAL(11,2);
	DECLARE total_price DECIMAL(11,2);
	DECLARE total_cost DECIMAL(11,2);
	DECLARE total_maintenance_price DECIMAL(11,2);
	DECLARE total_maintenance_cost DECIMAL(11,2);
	DECLARE right_of_call_cost DECIMAL(11,2);
	DECLARE right_of_call_price DECIMAL(11,2);
	DECLARE total_extra_price DECIMAL(11,2);
	DECLARE total_extra_cost DECIMAL(11,2);
	DECLARE include_trips BIT(1);

	
	SELECT
		SUM(prezzo_manutenzione),
		SUM(costo_manutenzione),
		SUM(costo_diritto_chiamata),
		SUM(prezzo_diritto_chiamata),
		SUM(costo_lavoro),
		SUM(prezzo_lavoro),
		SUM(costo_viaggio),
		SUM(prezzo_viaggio),
		SUM(costo_materiale),
		SUM(prezzo_materiale),
		SUM(costo_totale),
		SUM(prezzo_totale)
	INTO
		total_maintenance_price,
		total_maintenance_cost,
		right_of_call_cost,
		right_of_call_price,
		total_work_cost,
		total_work_price,
		total_trip_cost,
		total_trip_price,
		total_products_cost,
		total_products_price,
		total_cost,
		total_price
	FROM resoconto_rapporto
		LEFT JOIN rapporto_totali ON resoconto_rapporto.id_rapporto = rapporto_totali.id_rapporto and resoconto_rapporto.anno = rapporto_totali.anno
	WHERE resoconto_rapporto.id_resoconto = report_group_id AND anno_reso = report_group_year;

	SELECT 
		costo_extra,
		prezzo_extra,
		IF(fat_SpeseRap = 0, 0, 1)
	INTO 
		total_extra_cost,
		total_extra_price,
		include_trips
	FROM resoconto
	WHERE id_resoconto = report_group_id AND anno = report_group_year;



	SET total_maintenance_price = IFNULL(total_maintenance_price, 0);
	SET total_maintenance_cost = IFNULL(total_maintenance_cost, 0);
	SET right_of_call_cost = IFNULL(right_of_call_cost, 0);
	SET right_of_call_price = IFNULL(right_of_call_price, 0);
	SET total_work_cost = IFNULL(total_work_cost, 0);
	SET total_work_price = IFNULL(total_work_price, 0);
	SET total_trip_cost = IFNULL(total_trip_cost, 0);
	SET total_trip_price = IFNULL(total_trip_price, 0);
	SET total_products_cost = IFNULL(total_products_cost, 0);
	SET total_products_price = IFNULL(total_products_price, 0);
	SET total_cost = IFNULL(total_cost, 0);
	SET total_price = IFNULL(total_price, 0);

	UPDATE resoconto_totali
	SET 
		prezzo_manutenzione = total_maintenance_price,
		costo_manutenzione = total_maintenance_cost,
		costo_diritto_chiamata = right_of_call_cost,
		prezzo_diritto_chiamata = right_of_call_price,
		costo_lavoro = total_work_cost,
		prezzo_lavoro = total_work_price,
		costo_viaggio = total_trip_cost,
		prezzo_viaggio = IF(include_trips, total_trip_price, 0),
		costo_materiale = total_products_cost,
		prezzo_materiale = total_products_price,
		costo_extra = total_extra_cost,
		prezzo_extra = total_extra_price,
		costo_totale = total_cost + total_extra_cost,
		prezzo_totale = total_price + total_extra_price - IF(include_trips, 0, total_trip_price)
	WHERE resoconto_totali.id_resoconto = report_group_id AND resoconto_totali.anno = report_group_year;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE report_group_id INT(11);
	DECLARE report_group_year INT(11);
	DECLARE curA CURSOR FOR SELECT DISTINCT id_resoconto, anno FROM resoconto ORDER BY anno asc, data asc, id_resoconto ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN curA;
	loopA: LOOP
		SET done = 0;
		FETCH curA INTO report_group_id, report_group_year;
		IF done THEN
			LEAVE loopA;
		END IF;
		CALL sp_ariesReportGroupTotalsRefresh(report_group_id, report_group_year);
	END LOOP;
	CLOSE curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;
