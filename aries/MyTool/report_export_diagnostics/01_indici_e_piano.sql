-- Diagnostic of the original slow query, retained for before/after comparison.
-- Select the Aries database first. Read-only: EXPLAIN does not execute the export.
SELECT DATABASE() AS database_corrente, VERSION() AS versione,
       @@sql_mode AS sql_mode, @@group_concat_max_len AS group_concat_max_len;
SELECT 'INDICI' AS sezione, TABLE_NAME, INDEX_NAME, NON_UNIQUE,
       SEQ_IN_INDEX, COLUMN_NAME, SUB_PART, CARDINALITY, INDEX_TYPE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('rapporto', 'rapporto_totali', 'resoconto_rapporto',
    'resoconto', 'tipo_intervento', 'clienti', 'impianto', 'stato_rapporto',
    'rapporto_tecnico', 'rapporto_tecnico_lavoro', 'rapporto_materiale')
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
SELECT 'PIANO_QUERY_ORIGINALE' AS sezione;
EXPLAIN
SELECT DISTINCT rapporto.numero AS "ID", 
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
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) AS "Tempo_lavoro",
		IFNULL(SUM(IFNULL(Tempo_viaggio,0)), 0) AS "Tempo_viaggio",
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) + IFNULL(SUM(IFNULL(Tempo_viaggio,0)), 0) AS "Tempo_totale",
		IFNULL(rt.costo_lavoro, rapporto.cost_lav) AS cost_lav,
		IFNULL(rt.prezzo_lavoro, rapporto.prez_lav) AS prez_lav,
		IFNULL(rt.costo_materiale, 0) AS costo_materiale,
		IFNULL(rt.prezzo_materiale, 0) AS prezzo_materiale,
		IFNULL(rt.costo_totale, rapporto.Costo) AS Costo,
		IFNULL(rt.prezzo_totale, rapporto.Totale) AS Totale,
		DATE_FORMAT(data_esecuzione, '%m %Y') AS titolo_gruppo,
		DATE_FORMAT(data_esecuzione, '%Y-%m') AS id_gruppo,
		GROUP_CONCAT(CONCAT(rm.`quantità`, ' x ', rm.descrizione) SEPARATOR '|') AS Materiale,
		IFNULL(rt.prezzo_manutenzione, 0) AS prezzo_manutenzione,
		IFNULL(rt.costo_manutenzione, 0) AS costo_manutenzione,
		IFNULL(rt.prezzo_diritto_chiamata, 0) AS prezzo_diritto_chiamata,
		IFNULL(rt.costo_diritto_chiamata, 0) AS costo_diritto_chiamata
	FROM rapporto
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
		LEFT JOIN rapporto_tecnico AS t 
			ON t.id_rapporto=rapporto.id_rapporto AND t.anno=rapporto.anno 
		LEFT JOIN rapporto_tecnico_lavoro  
			ON rapporto_tecnico_lavoro.id_rapporto=rapporto.id_rapporto 
			AND rapporto_tecnico_lavoro.anno=rapporto.anno 
		LEFT JOIN rapporto_materiale rm ON rapporto.id_rapporto = rm.id_rapporto AND rapporto.Anno = rm.Anno
	GROUP BY rapporto.id_rapporto, rapporto.anno, res.id_resoconto, res.anno
	ORDER BY  data_esecuzione DESC, a.ragione_sociale ASC;