-- Report export: independent detail aggregates, totals and linked report groups.
DROP PROCEDURE IF EXISTS sp_printReportsListByInvoiceBody; 
DELIMITER $$
CREATE PROCEDURE `sp_printReportsListByInvoiceBody`(
	IN start_date DATE, 
	IN end_date DATE, 
	IN employee_id INT(11), 
	IN customer_id INT(11), 
	IN system_id INT(11),
	IN invoiced_status INT(11)
)
BEGIN
	DECLARE previous_concat_limit BIGINT UNSIGNED DEFAULT NULL;
	DECLARE required_concat_limit BIGINT UNSIGNED DEFAULT 0;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		IF previous_concat_limit IS NOT NULL THEN
			SET SESSION group_concat_max_len = previous_concat_limit;
		END IF;
		DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_work;
		DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_trip;
		DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_material;
		DROP TEMPORARY TABLE IF EXISTS tmp_reportsList;
		RESIGNAL;
	END;

	SET previous_concat_limit = @@session.group_concat_max_len;

	DROP TEMPORARY TABLE IF EXISTS tmp_reportsList;
	DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_work;
	DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_trip;
	DROP TEMPORARY TABLE IF EXISTS tmp_reportsList_material;

	CREATE TEMPORARY TABLE tmp_reportsList
	SELECT 
		rapporto.id_rapporto,
		rapporto.anno, 
		rapporto.id_cliente, 
		rapporto.Id_Impianto,
		rapporto.stato,
		fattura,
		anno_fattura
	FROM rapporto 
	WHERE data_esecuzione >= start_date AND data_esecuzione <= end_date;

	ALTER TABLE tmp_reportsList ADD PRIMARY KEY (id_rapporto, anno);

	IF employee_id IS NOT NULL AND employee_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE NOT EXISTS (
			SELECT 1 FROM rapporto_tecnico AS tecnico_filtro
			WHERE tecnico_filtro.id_rapporto = tmp_reportsList.id_rapporto
				AND tecnico_filtro.anno = tmp_reportsList.anno
				AND tecnico_filtro.tecnico = employee_id
		);
	END IF; 

	IF customer_id IS NOT NULL AND customer_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_cliente <> customer_id; 
	END IF; 

	IF system_id IS NOT NULL AND system_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_impianto <> system_id; 
	END IF;
	
	IF invoiced_status IS NOT NULL AND invoiced_status = 2 THEN -- NON FATTURATI
		DELETE FROM tmp_reportsList
		WHERE stato IN (2, 6, 8, 11)
			OR (fattura IS NOT NULL OR (anno_fattura IS NOT NULL AND anno_fattura <> 0));
	END IF; 

	IF invoiced_status IS NOT NULL AND invoiced_status = 1 THEN -- FATTURATI
		DELETE FROM tmp_reportsList
		WHERE stato NOT IN (2, 6, 8, 11)
			AND (
				fattura IS NULL
				OR anno_fattura IS NULL
				OR anno_fattura = 0
			);
	END IF; 
	
	-- Aggregate details independently and only for the filtered reports.
	-- Separate statements avoid reopening a temporary table on MySQL 5.5.
	CREATE TEMPORARY TABLE tmp_reportsList_work
	SELECT l.id_rapporto, l.anno, SUM(IFNULL(l.totale, 0)) AS tempo_lavoro
	FROM tmp_reportsList AS selezione
		INNER JOIN rapporto_tecnico_lavoro AS l
			ON l.id_rapporto = selezione.id_rapporto AND l.anno = selezione.anno
	GROUP BY l.id_rapporto, l.anno;
	ALTER TABLE tmp_reportsList_work ADD PRIMARY KEY (id_rapporto, anno);

	CREATE TEMPORARY TABLE tmp_reportsList_trip
	SELECT t.id_rapporto, t.anno, SUM(IFNULL(t.Tempo_viaggio, 0)) AS tempo_viaggio
	FROM tmp_reportsList AS selezione
		INNER JOIN rapporto_tecnico AS t
			ON t.id_rapporto = selezione.id_rapporto AND t.anno = selezione.anno
	GROUP BY t.id_rapporto, t.anno;
	ALTER TABLE tmp_reportsList_trip ADD PRIMARY KEY (id_rapporto, anno);

	-- Size GROUP_CONCAT for the actual material text, avoiding the default 1024-byte cut.
	SELECT IFNULL(MAX(material_lengths.bytes_needed), 0) INTO required_concat_limit
	FROM (
		SELECT SUM(LENGTH(CONCAT(m.`quantità`, ' x ', m.descrizione)))
			+ GREATEST(COUNT(CONCAT(m.`quantità`, ' x ', m.descrizione)) - 1, 0) AS bytes_needed
		FROM tmp_reportsList AS selezione
			INNER JOIN rapporto_materiale AS m
				ON m.id_rapporto = selezione.id_rapporto AND m.anno = selezione.anno
		GROUP BY m.id_rapporto, m.anno
	) AS material_lengths;
	SET SESSION group_concat_max_len = GREATEST(previous_concat_limit, required_concat_limit);

	CREATE TEMPORARY TABLE tmp_reportsList_material
	SELECT m.id_rapporto, m.anno,
		GROUP_CONCAT(CONCAT(m.`quantità`, ' x ', m.descrizione)
			ORDER BY m.id_tab SEPARATOR '|') AS Materiale
	FROM tmp_reportsList AS selezione
		INNER JOIN rapporto_materiale AS m
			ON m.id_rapporto = selezione.id_rapporto AND m.anno = selezione.anno
	GROUP BY m.id_rapporto, m.anno;
	ALTER TABLE tmp_reportsList_material ADD PRIMARY KEY (id_rapporto, anno);

	SELECT rapporto.numero AS "ID",
		data_esecuzione AS "data", 
		a.ragione_sociale, 
		b.descrizione, 
		tipo_intervento.nome,
		rapporto.relazione,
		rapporto.fattura, 
		rapporto.anno_fattura, 
		res.id_resoconto AS id_resoconto,
		res.anno AS anno_resoconto,
		res.data_invio AS data_invio_resoconto,
		stato_rapporto.Nome AS stato,
		IFNULL(lavoro.tempo_lavoro, 0) AS "Tempo_lavoro",
		IFNULL(viaggio.tempo_viaggio, 0) AS "Tempo_viaggio",
		IFNULL(lavoro.tempo_lavoro, 0) + IFNULL(viaggio.tempo_viaggio, 0) AS "Tempo_totale",
		IFNULL(rt.costo_lavoro, rapporto.cost_lav) AS cost_lav,
		IFNULL(rt.prezzo_lavoro, rapporto.prez_lav) AS prez_lav,
		IFNULL(rt.costo_materiale, 0) AS costo_materiale,
		IFNULL(rt.prezzo_materiale, 0) AS prezzo_materiale,
		IFNULL(rt.costo_totale, rapporto.Costo) AS Costo,
		IFNULL(rt.prezzo_totale, rapporto.Totale) AS Totale,
		DATE_FORMAT(data_esecuzione, '%m %Y') AS titolo_gruppo,
		DATE_FORMAT(data_esecuzione, '%Y-%m') AS id_gruppo,
		materiali.Materiale AS Materiale,
		IFNULL(rt.prezzo_manutenzione, 0) AS prezzo_manutenzione,
		IFNULL(rt.costo_manutenzione, 0) AS costo_manutenzione,
		IFNULL(rt.prezzo_diritto_chiamata, 0) AS prezzo_diritto_chiamata,
		IFNULL(rt.costo_diritto_chiamata, 0) AS costo_diritto_chiamata
	FROM tmp_reportsList AS tmp_reports 
		INNER jOIN Rapporto 
			ON Rapporto.Id_rapporto = tmp_reports.Id_Rapporto AND Rapporto.Anno = tmp_reports.Anno
		LEFT JOIN rapporto_totali AS rt
			ON rt.id_rapporto = rapporto.id_rapporto AND rt.anno = rapporto.anno
		LEFT JOIN resoconto_rapporto AS rr
			ON rr.id_rapporto = rapporto.id_rapporto AND rr.anno = rapporto.anno
		LEFT JOIN resoconto AS res
			ON res.id_resoconto = rr.id_resoconto AND res.anno = rr.anno_reso
		INNER JOIN tipo_intervento ON id_tipo=tipo_intervento 
		INNER JOIN clienti AS a ON a.id_cliente=rapporto.id_cliente 
		LEFT JOIN impianto AS b ON b.id_impianto=rapporto.id_impianto 
		LEFT JOIN stato_rapporto ON rapporto.stato = stato_rapporto.id_stato 
		LEFT JOIN tmp_reportsList_trip AS viaggio
			ON viaggio.id_rapporto = rapporto.id_rapporto AND viaggio.anno = rapporto.anno
		LEFT JOIN tmp_reportsList_work AS lavoro
			ON lavoro.id_rapporto = rapporto.id_rapporto AND lavoro.anno = rapporto.anno
		LEFT JOIN tmp_reportsList_material AS materiali
			ON materiali.id_rapporto = rapporto.id_rapporto AND materiali.anno = rapporto.anno
	ORDER BY  data_esecuzione DESC, a.ragione_sociale ASC;	

		
	DROP TEMPORARY TABLE tmp_reportsList_work;
	DROP TEMPORARY TABLE tmp_reportsList_trip;
	DROP TEMPORARY TABLE tmp_reportsList_material;
	DROP TEMPORARY TABLE tmp_reportsList;
	SET SESSION group_concat_max_len = previous_concat_limit;
END $$
DELIMITER ;
