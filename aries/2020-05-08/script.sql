DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	DECLARE done INT DEFAULT 0;
	DECLARE V_id_rapporto INT;
	DECLARE V_anno INT;
    DECLARE V_intervention_type_id INT;
    DECLARE V_report_date DATE;
    DECLARE V_is_sunday INT;
    
    DECLARE V_system_id INT;
    DECLARE V_maintenance_cost DECIMAL(11,2);
	DECLARE V_has_subsctiption BIT;
	DECLARE V_has_warranty BIT;
    DECLARE V_technician_counter INT;
    DECLARE V_has_first_hour BIT;
    DECLARE V_first_hour_price DECIMAL(11,2);
	DECLARE V_extra_hour_price DECIMAL(11,2);
	DECLARE V_hour_price DECIMAL(11,2);
	DECLARE V_km_price DECIMAL(11,2);
    DECLARE V_right_call INT;
    DECLARE V_right_call_price INT;
    DECLARE V_right_call_price_extra INT;
    
	DECLARE V_trip_kms_total DECIMAL(11,2);
	DECLARE V_trip_kms_cost DECIMAL(11,2);
	DECLARE V_trip_hours_total DECIMAL(11,2);
	DECLARE V_trip_hours_cost DECIMAL(11,2);
	DECLARE V_trip_extra DECIMAL(11,2);

	DECLARE V_totale_lavoro DECIMAL(11,2);
	DECLARE V_costo_lavoro DECIMAL(11,2);

	DECLARE V_totale_mat DECIMAL(11,2);
	DECLARE V_costo_mat DECIMAL(11,2);


	DECLARE V_tmp_totale DECIMAL(11,2);
	DECLARE V_tmp_totale_fisrt_hour DECIMAL(11,2);
	DECLARE V_tmp_costo DECIMAL(11,2);

	DECLARE V_curA CURSOR FOR SELECT id_rapporto,
		anno,
        tipo_intervento,
        id_impianto,
        Data_esecuzione,
        IFNULL(diritto_chiamata, 0)
	FROM rapporto
    WHERE cost_lav = 0 AND anno >= 2013;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	

	OPEN V_curA;
	loopA: LOOP
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		FETCH V_curA INTO V_id_rapporto, V_anno, V_intervention_type_id, V_system_id, V_report_date, V_right_call;

        SELECT count(*)
            INTO V_technician_counter
        FROM rapporto_tecnico_lavoro
        WHERE id_rapporto = V_id_rapporto AND anno = V_anno;

        SET V_is_sunday = DAYOFWEEK(V_report_date) = 1;

        IF V_system_id IS NOT NULL THEN
            SELECT IF(scadenza_garanzia IS NOT NULL AND V_report_date < scadenza_garanzia, 1, 0), Costo_manutenzione
                INTO V_has_warranty, V_maintenance_cost
            from impianto
            WHERE id_impianto = V_system_id;

            
            SELECT IFNULL(prima_ora, 0), IFNULL(prezzo_prima_ora, 0), IFNULL(ora_straordinaria, 0), IFNULL(prezzo_strada, 0), IFNULL(ora_normale, 0),
                IFNULL(diritto_chiamata, 0), IFNULL(diritto_chiamata_straordinario, 0)
                INTO V_has_first_hour, V_first_hour_price, V_extra_hour_price, V_km_price, V_hour_price, V_right_call_price,
                    V_right_call_price_extra 
            FROM (SELECT prima_ora, prezzo_prima_ora, ora_straordinaria, prezzo_strada, ora_normale, diritto_chiamata_gratis, diritto_chiamata,
                    diritto_chiamata_straordinario, diritto_chiamata_straordinario_inclusa
                FROM impianto_abbonamenti
                    INNER JOIN abbonamento ON abbonamento.id_abbonamento = impianto_abbonamenti.Id_abbonamenti
                WHERE id_impianto = V_system_id AND impianto_abbonamenti.anno = V_anno
                UNION ALL
                SELECT * FROM (SELECT prima_ora, prezzo_prima_ora, ora_straordinaria, prezzo_strada, ora_normale, diritto_chiamata_gratis, diritto_chiamata,
                    diritto_chiamata_straordinario, diritto_chiamata_straordinario_inclusa
                FROM abbonamento
                WHERE generale = 1 AND anno <= V_anno
                ORDER BY anno desc
                LIMIT 1) as generale_abb
                UNION ALL
                SELECT 0, 0, 0,0,0,0,0,0,0
            ) as asd LIMIT 1;
        ELSE
            SET V_has_warranty = 0;
            SET V_maintenance_cost = 0;
            SET V_has_first_hour = 0;
            SET V_first_hour_price = 0;
        END IF;


        SELECT IFNULL(SUM(ROUND(IFNULL((prezzo / 100 * (100 - sconto)) * Quantità, 0), 2)), 0),
            IFNULL(SUM(ROUND(IFNULL(costo * Quantità, 2), 2)), 0)
        INTO
            v_totale_mat,
            v_costo_mat
        FROM rapporto_materiale
        WHERE id_rapporto = V_id_rapporto AND anno = V_anno;

        SET V_has_subsctiption = V_intervention_type_id = 6 OR V_intervention_type_id = 9;

        SET V_costo_lavoro = 0;
        SET V_totale_lavoro = 0;

        IF V_has_subsctiption = 1 THEN
            SET V_totale_lavoro = V_totale_lavoro + V_maintenance_cost;
            
            SELECT IFNULL(SUM(totale/60*ora_normale), 0) as "prezzo", 
                IFNULL(SUM(totale/60*costo_h), 0) as "costo"
            INTO
                V_tmp_totale,
                V_tmp_costo
            FROM rapporto_tecnico_lavoro
                INNER JOIN operaio ON tecnico=id_operaio 
                INNER JOIN tariffario ON id_tariffario=tariffario 
            WHERE straordinario > 1 AND id_Rapporto = V_id_rapporto AND anno = V_anno;

            SET V_costo_lavoro = V_costo_lavoro + V_tmp_costo;
            SET V_totale_lavoro = V_totale_lavoro + V_tmp_totale;
        ELSE 
            SET V_totale_lavoro = V_totale_lavoro + (V_first_hour_price * V_technician_counter);
        END IF;

        SELECT IFNULL(SUM(totale/60*ora_normale), 0) as "prezzo",
            IFNULL(SUM(IF(totale > 60, totale - 60, 0)/60*ora_normale), 0) as "prezzo_prima_ora",
            IFNULL(SUM(totale/60*costo_h), 0) as "costo"
        INTO
            V_tmp_totale,
            V_tmp_totale_fisrt_hour,
            V_tmp_costo
        FROM rapporto_tecnico_lavoro
            INNER JOIN operaio ON tecnico=id_operaio
            INNER JOIN tariffario ON id_tariffario=tariffario
        WHERE straordinario = "0" AND id_Rapporto = V_id_rapporto AND anno = V_anno;
        
        SET V_costo_lavoro = V_costo_lavoro + V_tmp_costo;

        IF V_has_subsctiption = 0 THEN
            IF V_has_first_hour = 1 THEN 
                SET V_totale_lavoro = V_totale_lavoro + V_tmp_totale_fisrt_hour;
            ELSE
                SET V_totale_lavoro = V_totale_lavoro + V_tmp_totale;
            END IF;
        END IF;


        SELECT IFNULL(SUM(totale/60*straordinario_c), 0) as "costo",
            IFNULL(SUM(IF(id_lavoro <> 10, totale/60*V_extra_hour_price, 0)), 0) as "prezzo",
            IFNULL(SUM(totale/60*V_extra_hour_price), 0) as "prezzo_prima_ora"
        INTO
            V_tmp_costo,
            V_tmp_totale,
            V_tmp_totale_fisrt_hour
        FROM rapporto_tecnico_lavoro
            INNER JOIN operaio ON tecnico=id_operaio
            INNER JOIN tariffario ON id_tariffario=tariffario
        WHERE straordinario="1" AND id_Rapporto = V_id_rapporto AND anno = V_anno;
                
        SET V_costo_lavoro = V_costo_lavoro + V_tmp_costo;

        IF V_has_subsctiption = 0 THEN
            IF V_has_first_hour = 1 THEN 
                SET V_totale_lavoro = V_totale_lavoro + V_tmp_totale_fisrt_hour;
            ELSE
                SET V_totale_lavoro = V_totale_lavoro + V_tmp_totale;
            END IF;
        END IF;


        SELECT IFNULL(SUM(km*costo_km), 0)  as "costo_strada", 
            IFNULL(SUM(km*V_km_price), 0)  as "prezzo_strada", 
            IFNULL(SUM(tempo_viaggio/60*costo_h), 0) as "costo_viaggio",
            IFNULL(SUM(tempo_viaggio/60*V_hour_price), 0)  as "prezzo_viaggio",
            IFNULL(SUM(spesa_trasferta+altro+parcheggio+autostrada), 0) "spese_extra"
        INTO
            V_trip_kms_cost,
            V_trip_kms_total,
            V_trip_hours_cost,
            V_trip_hours_total,
            V_trip_extra
        FROM rapporto_tecnico 
           INNER JOIN operaio ON tecnico=id_operaio
           INNER JOIN tariffario ON id_tariffario=tariffario
         WHERE id_Rapporto = V_id_rapporto AND anno = V_anno;
        
        SET V_costo_lavoro = V_costo_lavoro + V_trip_kms_cost + V_trip_hours_cost + V_trip_extra;

         
        IF V_has_subsctiption = 0 AND V_has_first_hour = 0 THEN 
            SET V_totale_lavoro = V_totale_lavoro + V_trip_kms_total + V_trip_hours_total + V_trip_extra;
        END IF;


        if V_right_call > 0 then
            IF V_has_subsctiption = 0 THEN
                if V_is_sunday then
                    SET V_totale_lavoro = V_totale_lavoro + V_right_call_price_extra;
                else
                    SET V_totale_lavoro = V_totale_lavoro + V_right_call_price;
                END IF;
            END IF;

            if V_is_sunday then
                SET V_costo_lavoro = V_costo_lavoro + V_right_call_price_extra/2;
            else
                SET V_costo_lavoro = V_costo_lavoro + V_right_call_price/2;
            END IF;
        end IF;


        IF V_has_warranty = 1 THEN
            SET V_totale_lavoro = 0;
            SET v_totale_mat = 0;
        END IF;

        UPDATE rapporto
        SET totale = IFNULL(v_totale_mat, 0) + IFNULL(V_totale_lavoro, 0),
            costo = IFNULL(v_costo_mat, 0) + IFNULL(V_costo_lavoro, 0),
            cost_lav =  IFNULL(V_costo_lavoro, 0),
            prez_lav = IFNULL(V_totale_lavoro, 0)
        WHERE id_rapporto = V_id_rapporto AND anno = V_anno;

	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;
CALL tmp;

DROP PROCEDURE IF EXISTS tmp;

ALTER TABLE `operaio`
	ADD UNIQUE INDEX `Ragione_sociale` (`Ragione_sociale`);
