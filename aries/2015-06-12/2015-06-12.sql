DROP PROCEDURE IF EXISTS sp_quoteCreateJob;
DELIMITER $$
CREATE PROCEDURE sp_quoteCreateJob(
	QuoteId INT, QuoteYear INT, QuoteRevision INT,
	OUT JobId INT, OUT JobYear INT
)
BEGIN

	DECLARE CurrentDate DATE DEFAULT CURRENT_DATE;
	DECLARE CurrentYear INT DEFAULT YEAR(CurrentDate);
	
	SET JobYear = CurrentYear;
	
	SELECT IFNULL(MAX(id_commessa), 0) + 1
	INTO JobId
	FROM commessa 
	WHERE anno = CurrentYear;

	INSERT INTO commessa(id_utente, id_commessa, anno, id_cliente, data_inizio, stato_commessa, tipo_commessa, descrizione) 
	SELECT @USER_ID, JobId, JobYear, rp.id_cliente, CurrentDate, 1, 1, note 
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo 
			AND rp.anno = p.anno 
			AND rp.id_revisione = p.revisione 
	WHERE p.id_preventivo = QuoteId 
		AND p.anno = QuoteYear;
		
	INSERT INTO commessa_sotto(id_commessa, anno, id_sotto, stato, nome, destinazione, inizio) 
	SELECT JobId, JobYear, 1, 1, "SOTTOCOMMESSA PRINCIPALE", destinazione, CURRENT_DATE 
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo
			AND p.anno = rp.anno 
			AND p.revisione = rp.id_revisione 
	WHERE p.id_preventivo = QuoteId
		AND p.anno = QuoteYear;

	INSERT INTO commessa_lotto(id_commessa, anno, id_sottocommessa, stato, descrizione, data_inizio, id_lotto, impianto, csora, prora, sc) 
	SELECT JobId, JobYear, 1, 1, l.nome, CurrentDate, posizione, id_impianto, ora_p, ora_c, scon 
	FROM preventivo_lotto pl
		INNER JOIN lotto l ON l.id_lotto = pl.id_lotto 
	WHERE pl.id_preventivo = QuoteId 
		AND pl.anno = QuoteYear 
		AND id_revisione = QuoteRevision;

	INSERT INTO commessa_articoli(preventivati, id_commessa, anno, descrizione, id_lotto, quantità, codice_articolo, codice_fornitore, 
		um, id_tab, prezzo, tempo, costo_ora, costo, prezzo_ora, sconto, iva) 
	SELECT SUM(ap.quantità), JobId, JobYear, IFNULL(a.desc_brev, ap.desc_brev), 
		lotto, quantità, id_articolo, ap.codice_fornitore, ap.unità_misura, id_tab, 
		ROUND(prezzo-prezzo * IF(pl.tipo_ricar = 1, 0, sconto)/100, 2), IF(montato, ap.tempo_installazione, "0"), 
		costo_h, costo, (prezzo_h-prezzo_h * scontolav/100), scontoriga, iva 
	FROM articolo_preventivo ap
		LEFT JOIN articolo a ON id_articolo = codice_articolo 
		LEFT JOIN preventivo_lotto pl ON pl.posizione = ap.lotto 
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND pl.id_preventivo = ap.id_preventivo 
	WHERE ap.id_preventivo = QuoteId 
		AND ap.anno = QuoteYear 
		AND ap.id_revisione = QuoteRevision 
		AND tipo IN("A", "AL") 
		AND id_articolo IS NOT NULL 
	GROUP BY id_articolo, lotto 
	UNION ALL 
	SELECT ap.quantità, JobId, JobYear, IFNULL(a.desc_brev, ap.desc_brev), lotto, 
		quantità, id_articolo, ap.codice_fornitore, ap.unità_misura, id_tab, 
		ROUND(prezzo-prezzo * IF(pl.tipo_ricar = 1, 0, sconto)/100, 2), IF(montato, ap.tempo_installazione, "0"), 
		costo_h, costo, (prezzo_h-prezzo_h * scontolav/100), scontoriga, iva 
	FROM articolo_preventivo ap
		LEFT JOIN articolo a ON id_articolo = codice_articolo 
		LEFT JOIN preventivo_lotto pl ON pl.posizione = ap.lotto 
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND pl.id_preventivo = ap.id_preventivo 
	WHERE ap.id_preventivo = QuoteId 
		AND ap.anno = QuoteYear 
		AND ap.id_revisione = QuoteRevision 
		AND tipo IN("A", "AL") 
		AND id_articolo IS NULL;

	INSERT INTO commessa_preventivo(id_commessa, anno, preventivo, anno_prev, rev, lotto, pidlotto) 
	SELECT JobId, JobYear, id_preventivo, anno, id_revisione, posizione, posizione AS "1" 
	FROM preventivo_lotto pl
	WHERE id_preventivo = QuoteId 
		AND anno = QuoteYear 
		AND id_revisione = QuoteRevision;

	UPDATE preventivo SET 
		stato = 7 
	WHERE anno = QuoteYear 
		AND id_preventivo = QuoteId;
	
END $$
DELIMITER ;