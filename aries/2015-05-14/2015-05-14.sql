ALTER TABLE `ddt`
ADD COLUMN `stato` INT NOT NULL  DEFAULT 0,
	ADD INDEX `stato` (`stato`);

UPDATE ddt
	INNER JOIN (
		SELECT id, anno, IF(stato IS NULL, 1, IF(stato = 0, 2, 3)) AS "newstato" FROM (
			SELECT DISTINCT ddt.id_ddt AS "ID", ddt.anno, IF(anno_fattura IS NOT NULL AND fattura IS NOT NULL, fattura, NULL) AS "Stato"
			FROM ddt
				LEFT JOIN causale_trasporto ON ddt.causale = id_causale
				INNER JOIN clienti ON clienti.id_cliente = ddt.id_cliente
				LEFT JOIN destinazione_cliente AS b ON b.id_cliente = ddt.id_cliente
					AND b.id_destinazione = ddt.id_destinazione
				LEFT JOIN comune AS b1 ON b1.id_comune = b.comune
				LEFT JOIN impianto ON id_impianto = impianto
			UNION ALL
			SELECT DISTINCT ddt.id_ddt AS "ID", ddt.anno, IF(id_e IS NULL, IF(ddt.fatturaf IS NULL OR ddt.anno_fatturaf IS NULL, "0", "1"), "1") AS "Stato"
			FROM ddt
				INNER JOIN causale_trasporto ON ddt.causale = id_causale
				INNER JOIN fornitore ON fornitore.id_fornitore = ddt.id_fornitore
				INNER JOIN destinazione_fornitore AS b ON b.id_fornitore = ddt.id_fornitore
					AND b.id_destinazione = ddt.destinazione_forn
				LEFT JOIN comune AS b1 ON b1.id_comune = b.comune
				LEFT JOIN ddt_ricevuti_emessi ON ddt.id_ddt = ddt_ricevuti_emessi.id_e
				AND ddt.anno = ddt_ricevuti_emessi.anno_e
		) AS oldstatuses
	) AS a ON ddt.id_ddt = a.id AND ddt.anno = a.anno
SET ddt.stato = a.newstato
WHERE TRUE;

