-- DDT

DROP PROCEDURE IF EXISTS sp_printDdtNotInvoiced;
DELIMITER $$
CREATE PROCEDURE sp_printDdtNotInvoiced(
	ddtYear SMALLINT, OUT ddtsNumbers MEDIUMINT, OUT ddtsTotalPrice DECIMAL(11,2), OUT ddtsTotalCost DECIMAL(11,2))
BEGIN

	SELECT * 
	FROM
	(
		-- ddt not closed
		SELECT 
			ddt.id_ddt AS "DdtId", 
			data_documento AS "Date", 
			clienti.ragione_sociale AS "CompanyName",
			causale_trasporto.causale AS "CausalTransport", 
			IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  
			IFNULL(ddt.fattura, "") AS "InvoiceId",
			IFNULL(impianto.descrizione, "") AS "SystemDescription", 
			CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 
			CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost,
			IF(commessa_ddt.Id_commessa IS NOT NULL, "in_job", "open") AS "Status"
		FROM ddt
			LEFT JOIN causale_trasporto ON ddt.causale=id_causale
			INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
			LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
			LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
			LEFT JOIN impianto ON id_impianto=impianto
			LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
			LEFT JOIN commessa_ddt ON commessa_ddt.Id_ddt=ddt.id_ddt AND commessa_ddt.Anno_ddt=ddt.anno 
		WHERE ddt.Stato IN (1,2,4)  AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno)
		GROUP BY ddt.Id_ddt, ddt.anno
		
		UNION 
		
		-- ddt in pre-invoiced
		SELECT
			ddt.id_ddt AS "DdtId", 
			data_documento AS "Date", 
			clienti.ragione_sociale AS "CompanyName",
			causale_trasporto.causale AS "CausalTransport", 
			IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  
			IFNULL(ddt.fattura, "") AS "InvoiceId",
			IFNULL(impianto.descrizione, "") AS "SystemDescription", 
			CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 
			CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost,
			"in_pre_invoice" AS "Status"
		FROM ddt
			LEFT JOIN causale_trasporto ON ddt.causale=id_causale
			INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
			LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
			LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
			LEFT JOIN impianto ON id_impianto=impianto
			LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
			INNER JOIN fattura ON fattura.Id_fattura = ddt.fattura AND fattura.anno = ddt.anno_fattura AND fattura.anno = 0
		WHERE ddt.anno = IF(ddtYear, ddtYear, ddt.anno) 
		GROUP BY ddt.Id_ddt, ddt.anno
	) AS a	
	ORDER BY YEAR(Date) DESC, DdtId;
	
	SELECT COUNT(ddt.id_ddt),
		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)), 
		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2))
		INTO 
		ddtsNumbers,
		ddtsTotalPrice,
		ddtsTotalCost
	FROM ddt
		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno);
			

END $$
DELIMITER ;

-- JOB

DROP PROCEDURE IF EXISTS sp_printJobLotsInfo; 
DELIMITER $$
CREATE PROCEDURE `sp_printJobLotsInfo`(
	IN `job_id` INT(11),
	IN `job_year` INT(11),
	IN `sub_job_id` INT(11),
	IN `job_lot_id` INT(11)
)
BEGIN
 	SELECT
		commessa_lotto.id_commessa,
		commessa_lotto.anno,
		commessa_lotto.id_sottocommessa,
		commessa_lotto.id_lotto,
		commessa_lotto.descrizione,
		IFNULL(SUM(Qta_preventivati*(Tempo_Installazione/60)), 0) AS "Da_fare",
		IFNULL(SUM(Qta_preventivati*(Tempo_Installazione/60)*(prezzo_ora-prezzo_ora/100*sconto)), 0) AS "prezzo_lav_tot",
		IFNULL(SUM(Qta_preventivati*(prezzo - prezzo/100*sconto)),0) AS "prezzo_mat_tot",
		IFNULL(SUM(Qta_preventivati*(Tempo_Installazione/60)*costo_ora), 0) AS "costo_lav_tot",
		IFNULL(SUM(Qta_preventivati*costo), 0) AS "costo_mat_tot" 
	FROM
		commessa_lotto 
	LEFT JOIN
		vw_jobbody AS a 
			ON a.id_commessa=commessa_lotto.id_commessa 
			AND a.anno=commessa_lotto.anno 
			AND a.id_sottocommessa = commessa_lotto.id_sottocommessa
			AND a.lotto=commessa_lotto.id_lotto  
	WHERE
		commessa_lotto.id_commessa = job_id
		AND commessa_lotto.anno = job_year
		AND commessa_lotto.id_sottocommessa = sub_job_id
		AND IF(job_lot_id = -1, -1, commessa_lotto.id_lotto) = job_lot_id
	
	GROUP BY
		commessa_lotto.id_lotto 
	HAVING COUNT(*) > 0;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printJobLotsHoursWorked; 
DELIMITER $$
CREATE PROCEDURE `sp_printJobLotsHoursWorked`(
	IN `job_id` INT(11),
	IN `job_year` INT(11),
	IN `sub_job_id` INT(11),
	IN `job_lot_id` INT(11), 
	IN `considers_trip_hours` BIT 
)
BEGIN

	DROP TABLE IF EXISTS tmp_Job_hours_worked; 
	CREATE TABLE tmp_Job_hours_worked(
		svolte DECIMAL(11,2), 
		Id_lotto INT(11)
	);

	INSERT INTO tmp_Job_hours_worked (svolte, Id_lotto)
	SELECT 
		IFNULL(SUM(rapporto_tecnico_lavoro.totale)/60, 0) AS "svolte", 
		commessa_rapporto.id_lotto 
	FROM commessa_rapporto 
		INNER JOIN rapporto_tecnico_lavoro 
			ON commessa_rapporto.id_rapporto=rapporto_tecnico_lavoro.id_rapporto 
			AND commessa_rapporto.anno_rapporto=rapporto_tecnico_lavoro.anno AND straordinario < 3
	WHERE id_commessa = job_id AND anno_commessa = job_year  AND id_sottocommessa = sub_job_id
	GROUP BY commessa_rapporto.id_lotto;
	
	IF considers_trip_hours THEN

		SELECT 
			IFNULL(SUM(tempo_viaggio)/60, 0) AS "svolte", 
			commessa_rapporto.id_lotto 
		FROM commessa_rapporto 
			INNER JOIN rapporto_tecnico AS a 
				ON commessa_rapporto.id_rapporto=a.id_rapporto AND commessa_rapporto.anno_rapporto=a.anno 
		WHERE id_commessa = job_id AND anno_commessa = job_year AND id_sottocommessa = sub_job_id
		GROUP BY commessa_rapporto.id_lotto;
		
	END IF;
	
	
	IF (job_lot_id <> -1) THEN

		DELETE 
		FROM tmp_Job_hours_worked
		WHERE Id_lotto <> job_lot_id;

	END IF;
	
	
	SELECT 
		SUM(svolte) AS svolte, 
		Id_lotto
	FROM tmp_Job_hours_worked
	GROUP BY Id_lotto
	ORDER BY Id_lotto;
		
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_printJobHeaderInfo; 
DELIMITER $$
CREATE PROCEDURE `sp_printJobHeaderInfo`(
	IN `job_id` INT(11),
	IN `job_year` INT(11),
	IN `sub_job_id` INT(11)
)
BEGIN

	DECLARE agent_name VARCHAR(50);

	SELECT DISTINCT 
		operaio.Ragione_sociale	
	INTO 
		agent_name
	FROM commessa_preventivo
		INNER JOIN preventivo 
			ON commessa_preventivo.preventivo = preventivo.Id_preventivo
				AND commessa_preventivo.anno_prev = preventivo.anno
				AND commessa_preventivo.rev = preventivo.revisione
		INNER JOIN operaio 
			ON preventivo.agente = operaio.id_operaio
	WHERE commessa_preventivo.Id_commessa = job_id 
		AND commessa_preventivo.anno = job_year
		AND id_sottocommessa = sub_job_id
	LIMIT 1; 

	SELECT
	   clienti.id_cliente,
	   ragione_sociale,
	   ragione_sociale2,
	   Id_commessa,
	   anno,
	   agent_name AS "agente",
	   data_inizio,
	   data_scadenza,
	   fax,
	   altro_telefono,
	   telefono,
	   mail,
	   partita_iva,
	   codice_fiscale,
	   CONCAT(a1.cap,
	   " - ",
	   IF(frazione.nome IS NOT NULL,
	   CONCAT(frazione.nome,
	   " di "),
	   ""),
	   a1.nome,
	   " (",
	   a.provincia,
	   ")") AS "Provincia princ",
	   CONCAT(    if((a.indirizzo IS NOT NULL),
	   CONCAT(a.indirizzo),
	   ""),
	   if((a.numero_civico IS NOT NULL),
	   CONCAT(",",
	   a.numero_civico),
	   ""),
	   if((a.altro IS NOT NULL) 
	   AND (a.altro<>" "),
	   CONCAT("/",
	   a.altro),
	   ""))      AS "Indirizzo princ"            
	FROM commessa 
		LEFT JOIN destinazione_cliente AS a     
		   on a.id_cliente=commessa.id_cliente 
		   AND a.sede_principale="1" 
		   AND a.attivo="1"     
		LEFT JOIN comune AS a1 
		   ON a1.id_comune=a.comune 
		LEFT JOIN frazione 
		   ON id_Frazione=frazione 
		LEFT JOIN clienti 
		   ON clienti.id_cliente = commessa.id_cliente 
		LEFT JOIN riferimento_clienti 
		   ON        riferimento_clienti.id_cliente = clienti.id_cliente 
		   AND id_riferimento = 1
	WHERE
	   id_commessa = job_id 
	   AND anno = job_year;
	   
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printJobBodyInfo; 
DELIMITER $$
CREATE PROCEDURE `sp_printJobBodyInfo`(
	IN `job_id` INT(11),
	IN `job_year` INT(11), 	
	IN `sub_job_id` INT(11),
	IN `job_lot_id` INT(11)
)
BEGIN
	
	DROP TABLE IF EXISTS tmp_job_body; 
	   		
	 CREATE TEMPORARY TABLE tmp_job_body
	SELECT `Id_commessa`
		,`Anno`
		,`Lotto`
		,`Posizionamento`
		,`Codice_articolo`
		,`Codice_fornitore`
		,`Descrizione`
		,`Qta_utilizzata`
		,`Qta_commessa`
		,`Qta_preventivati`
		,`UM`
		,Prezzo
		,`Costo`
		,`Prezzo_ora`
		,`Costo_ora`
		,`Sconto`
		,CAST(Tempo_installazione / 60 AS DECIMAL(11,2)) AS `Tempo_installazione`
		,`Qta_economia`
		,CAST((Prezzo * Qta_utilizzata)* (100 - `Sconto`) / 100 AS DECIMAL(11,2)) As Prezzo_finale
		,CAST((Prezzo * Qta_economia)* (100 - `Sconto`) / 100 AS DECIMAL(11,2)) As Prezzo_finale_Eco
	FROM vw_jobbody
	WHERE
	id_commessa = job_id 
		AND anno = job_year
		AND id_sottocommessa = sub_job_id
	ORDER BY Lotto, Posizionamento;
	
   		
   ALTER TABLE tmp_job_body ADD COLUMN Id INTEGER UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (`Id`);
   		
   IF (job_lot_id <> -1) THEN

		DELETE 
		FROM tmp_job_body
		WHERE Lotto <> job_lot_id;

	END IF;
   		
	SELECT 
		Id
		,`Id_commessa`
		,`Anno`
		,`Lotto`
		,`Posizionamento`
		,`Codice_articolo`
		,`Codice_fornitore`
		,`Descrizione`
		,`Qta_utilizzata`
		,`Qta_commessa`
		,`Qta_preventivati`
		,`UM`
		,CAST(IFNULL(`Prezzo`, 0) AS DECIMAL(11,2)) Prezzo
		,`Costo`
		,`Prezzo_ora`
		,`Costo_ora`
		,`Sconto`
		,`Tempo_installazione`
		,`Qta_economia`
		,Prezzo_finale
	FROM tmp_job_body; 
	
	   
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_printJobAssociatesDocuments; 
DELIMITER $$
CREATE PROCEDURE sp_printJobAssociatesDocuments(
	IN job_id INT(11),
	IN job_year INT(11), 	
	IN sub_job_id INT(11),
	IN job_lot_id INT(11)
)
BEGIN
	DROP TABLE IF EXISTS tmp_job_associates_documents;

	CREATE TEMPORARY TABLE tmp_job_associates_documents
   	SELECT 
   		ddt.id_ddt AS "ID", 
	    anno AS "anno", 
	    data_documento AS "Data", 
  		causale_trasporto.causale AS "Causale",
		"DDT" AS "Documento", 
		id_lotto, 
		CONCAT(fattura," / ", anno_fattura) AS "fattura"
	FROM ddt 
		INNER JOIN causale_trasporto 
			ON ddt.causale=id_causale 
		INNER JOIN destinazione_cliente AS b 
			ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione 
  		LEFT JOIN comune AS b1 
		  	ON b1.id_comune=b.comune  
   		INNER JOIN commessa_ddt AS A 
		   ON a.id_ddt=ddt.ID_DDT AND ddt.anno=anno_ddt 
	WHERE id_commessa = job_id AND anno_commessa = job_year AND id_sottocommessa = sub_job_id

   	UNION ALL 
	SELECT 
		rapporto.numero AS "ID",
		rapporto.anno AS "anno", 
		data_esecuzione AS "Data", 
		tipo_intervento.nome AS "Causale",
		"RAPPORTO" AS "Documento", 
		id_lotto,
		CONCAT(fattura," / ", anno_fattura) AS "fattura"
	FROM rapporto 
		INNER JOIN tipo_intervento 
			ON id_tipo=tipo_intervento 
   		LEFT JOIN resoconto_rapporto 
		   	ON rapporto.id_rapporto=resoconto_rapporto.id_rapporto AND rapporto.anno=resoconto_rapporto.anno
    	INNER JOIN destinazione_cliente AS b 
   			ON b.id_cliente=rapporto.id_cliente AND b.id_destinazione=rapporto.id_destinazione 
		LEFT JOIN comune AS b1 
			ON b.comune=b1.id_comune 
		INNER JOIN commessa_rapporto AS A 
			ON a.id_rapporto=rapporto.ID_rapporto AND rapporto.anno=anno_rapporto 
	WHERE id_commessa = job_id AND anno_commessa = job_year AND id_sottocommessa = sub_job_id
	
   	UNION ALL 
  	SELECT 
	  fattura.id_fattura AS "ID", 
	  fattura.anno AS "anno", 
	  data AS "data", 
	  tipo_com_fat.nome AS "Causale",
	  "FATTURA" AS "Documento", 
	  id_lotto,
	  "" AS "fattura" 
	FROM commessa_fattura 
		INNER JOIN FATTURA  
   			ON fattura.id_fattura=commessa_fattura.id_fattura AND anno=anno_fattura 
   		INNER JOIN tipo_com_fat 
			ON id_tipo=tipo 
   	WHERE id_commessa = job_id AND anno_commessa = job_year AND id_sottocommessa = sub_job_id

   	UNION ALL 
	SELECT 
		CONCAT(preventivo.id_preventivo,"R.", id_revisione),
		preventivo_lotto.anno, 
		data_creazione,
		lotto.nome,
		"PREVENTIVO", 
		commessa_preventivo.lotto,
		"" 
   	FROM commessa_preventivo 
   		INNER JOIN preventivo_lotto 
	   		ON id_preventivo=preventivo AND preventivo_lotto.anno=anno_prev AND posizione=pidlotto AND preventivo_lotto.id_revisione=rev 
		INNER JOIN lotto 
			ON lotto.id_lotto=preventivo_lotto.id_lotto 
   		INNER JOIN preventivo 
		   	ON preventivo.id_preventivo=preventivo_lotto.id_preventivo AND preventivo.anno=preventivo_lotto.anno 

	WHERE id_commessa = job_id AND commessa_preventivo.anno = job_year AND id_sottocommessa = sub_job_id
	 
	UNION ALL
	SELECT DISTINCT
		ordine_fornitore.Id_ordine, 
		ordine_fornitore.anno, 
		data_creazione, 
		"", 
		"ORDINE" AS "Documento", 
		com_lotto,
		"" AS "fattura" 	
	FROM ordine_dettaglio
		INNER JOIN ordine_fornitore
			ON ordine_fornitore.id_ordine = ordine_dettaglio.id_ordine AND ordine_fornitore.anno = ordine_dettaglio.anno
	WHERE id_commessa = job_id AND anno_commessa = job_year AND id_sottocommessa = sub_job_id; 



	   		
   IF (job_lot_id <> -1) THEN

		DELETE 
		FROM tmp_job_associates_documents
		WHERE id_lotto <> job_lot_id;

	END IF;

	SELECT * 
	FROM tmp_job_associates_documents
	ORDER BY Data; 

END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_printJobHoursDetails; 
DELIMITER $$
CREATE PROCEDURE sp_printJobHoursDetails(
	IN job_id INT(11),
	IN job_year INT(11),
	IN sub_job_id INT(11),
	IN job_lot_id INT(11)
)
BEGIN

	DROP TABLE IF EXISTS tmp_job_hours_details; 

	CREATE TEMPORARY TABLE tmp_job_hours_details   		
	SELECT 
		Id_commessa, 
		anno_commessa, 
		id_lotto, 
		ROUND(SUM(totale/60), 2) Ore_totali, 
		causale_lavoro.Nome
	
	FROM commessa_rapporto 
		INNER JOIN rapporto_tecnico_lavoro
		 	ON Commessa_rapporto.id_rapporto = rapporto_tecnico_lavoro.id_rapporto AND commessa_rapporto.anno_rapporto = rapporto_tecnico_lavoro.anno 	
		INNER JOIN causale_lavoro
			ON rapporto_tecnico_lavoro.Id_lavoro = causale_lavoro.Id_causale
	WHERE  id_commessa = job_id 
   		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id
	GROUP BY Id_commessa, anno_commessa, id_sottocommessa, id_lotto
	ORDER BY Id_lotto;
   		
   IF (job_lot_id <> -1) THEN

		DELETE 
		FROM tmp_job_hours_details
		WHERE id_lotto <> job_lot_id;

	END IF;

	SELECT * 
	FROM tmp_job_hours_details; 
	   
END $$
DELIMITER ;






DROP PROCEDURE IF EXISTS sp_printReportsListBody; 
DELIMITER $$
CREATE PROCEDURE `sp_printReportsListBody`(
	IN start_date DATE, 
	IN end_date DATE, 
	IN employee_id INT(11), 
	IN customer_id INT(11), 
	IN system_id INT(11)
)
BEGIN

	DROP TABLE IF EXISTS tmp_reportsList;

	CREATE TEMPORARY TABLE tmp_reportsList
	SELECT 
		rapporto.id_rapporto,
		rapporto.anno, 
		rapporto.id_cliente, 
		rapporto.Id_Impianto,
		rapporto_tecnico.Tecnico as Id_operaio		
	FROM rapporto 
		LEFT JOIN rapporto_tecnico
			ON rapporto_tecnico.id_rapporto=rapporto.id_rapporto AND rapporto_tecnico.anno=rapporto.anno
	WHERE data_esecuzione >= start_date AND data_esecuzione <= end_date;

	IF employee_id IS NOT NULL AND employee_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_operaio <> employee_id; 
	END IF; 

	IF customer_id IS NOT NULL AND customer_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_cliente <> customer_id; 
	END IF; 

	IF system_id IS NOT NULL AND system_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_impianto <> system_id; 
	END IF; 
 
	SELECT DISTINCT rapporto.numero AS "ID", 
		op.ragione_sociale AS "oper", 
		data_esecuzione AS "data", 
		a.ragione_sociale, 
		b.descrizione, 
		tipo_intervento.nome,
		rapporto.relazione,
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) AS "Tempo_lavoro",
		Tempo_viaggio,
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) + IFNULL(Tempo_viaggio, 0) AS "Tempo_totale"
	FROM tmp_reportsList AS tmp_reports 
		INNER jOIN Rapporto 
			ON Rapporto.Id_rapporto = tmp_reports.Id_Rapporto AND Rapporto.Anno = tmp_reports.Anno
		INNER JOIN tipo_intervento ON id_tipo=tipo_intervento 
		INNER JOIN clienti AS a ON a.id_cliente=rapporto.id_cliente 
		LEFT JOIN impianto AS b ON b.id_impianto=rapporto.id_impianto 
		LEFT JOIN stato_rapporto ON rapporto.stato = stato_rapporto.id_stato 
		LEFT JOIN rapporto_tecnico AS t 
			ON t.id_rapporto=rapporto.id_rapporto AND t.anno=rapporto.anno 
			AND tmp_reports.Id_operaio = t.Tecnico

		LEFT JOIN rapporto_tecnico_lavoro  
			ON rapporto_tecnico_lavoro.id_rapporto=rapporto.id_rapporto 
			AND rapporto_tecnico_lavoro.anno=rapporto.anno 
			AND tmp_reports.Id_operaio = rapporto_tecnico_lavoro.Tecnico

		INNER JOIN operaio AS op 
			ON op.id_operaio = tmp_reports.id_operaio 

	GROUP BY tmp_reports.id_rapporto, tmp_reports.anno, tmp_reports.Id_operaio
	ORDER BY  data_esecuzione DESC, a.ragione_sociale ASC;	

		
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printQuoteHeader; 
DELIMITER $$
CREATE PROCEDURE `sp_printQuoteHeader`(
	IN quote_id INT(11), 
	IN quote_year INT(11),
	IN quote_rev_id INT(11)
)
BEGIN

	DECLARE supp INT(11);

	SELECT valore
		INTO supp
	FROM preventivo_impost 
	WHERE tipo="tip_REP";


	SELECT 
		cl.codice_fiscale, 
		condizione_pagamento,
		ragione_sociale2, 
		cl.partita_iva,
		CONCAT(LPAD(p.id_preventivo, 4, "0"), CONCAT(" rev. ", quote_rev_id)) AS id_fattura,
		data, 
		rp.id_cliente, 
		cl.ragione_sociale,
		CONCAT(c.cap, " - ", c.nome, " (", dcl.provincia, ")") AS "Provincia princ",
		CONCAT(
			IFNULL(CONCAT(dcl.indirizzo), ""),
			IFNULL(CONCAT(",", dcl.numero_civico), ""),
			IFNULL(CONCAT("/", NULLIF(dcl.altro, " ")), ""))
		AS "Indirizzo princ",
		
		IF(supp = 1, tp.nome, 'PREVENTIVO') AS "tipo_preve", 
		rcl.telefono, 
		rcl.fax, 
		rcl.mail,
		corpo, 
		corpo_rtf, 
		oggetto, 
		rcl2.fax,
		rcl2.altro_telefono,
		rcl2.telefono, 
		rcl2.mail,
		rcl.altro_telefono, 
		rcl2.titolo, 
		rcl2.nome,
		IFNULL(CONCAT(rcl2.titolo, " ", NULLIF(rcl2.nome, "")), " ") AS "titolo2", 
		sitoin,
		IFNULL(CONCAT("CORTESE ATTENZIONE ", NULLIF(cortese, "")), " ") AS "cortese", 
		nota
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo
			AND p.anno = rp.anno
		LEFT JOIN tipo_preventivo tp ON tipo = id_tipo
		INNER JOIN clienti cl ON cl.id_cliente = rp.id_cliente
		INNER JOIN destinazione_cliente dcl ON dcl.id_cliente = rp.id_cliente
			AND dcl.id_destinazione = rp.destinazione
		LEFT JOIN comune c ON c.id_comune = dcl.comune
		LEFT JOIN riferimento_clienti rcl ON rcl.id_cliente = cl.id_cliente
			AND rcl.id_riferimento = "1"
		LEFT JOIN riferimento_clienti rcl2 ON rcl2.id_cliente = rp.id_cliente
			AND rp.id_riferimento = rcl2.id_riferimento
	WHERE p.id_preventivo = quote_id
		AND p.anno = quote_year
		AND id_revisione = quote_rev_id; 
			
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_printQuoteBody; 
DELIMITER $$
CREATE PROCEDURE `sp_printQuoteBody`(
	IN quote_id INT(11), 
	IN quote_year INT(11),
	IN quote_rev_id INT(11), 
	IN product_code_type SMALLINT, 
	IN show_price BIT(1)
)
BEGIN

	DECLARE decription_type INT(11);
	DECLARE discount_zero INT(11);
	DECLARE mounted INT(11); 

	SELECT valore
		INTO decription_type
	FROM preventivo_impost 
	WHERE tipo="desc";

	SELECT valore
		INTO discount_zero
	FROM preventivo_impost 
	WHERE tipo="sconto_0";

	SELECT valore
		INTO mounted
	FROM preventivo_impost 
	WHERE tipo="stampa_imoco";


	SELECT 
		articolo_preventivo.Id_preventivo,
		articolo_preventivo.Anno,
		articolo_preventivo.Id_revisione, 
		articolo_preventivo.Lotto,
		lotto.Nome AS nome_lotto,
		IF(product_code_type = 0, id_articolo, 
			IF(product_code_type = 1, articolo_preventivo.codice_fornitore, ""))
		AS "id_articolo",
		articolo_preventivo.idNota,
		articolo_preventivo.id_tab, 
		IF(id_articolo LIKE "--%" AND quantità="0","N", tipo) AS "tipo",
		IF(decription_type = 1, 
			IF(articolo.desc_brev IS NOT NULL,articolo.desc_brev,articolo_preventivo.desc_brev), 
			articolo_preventivo.desc_brev) 
		AS "desc_brev",
		CONCAT(" ", IF(l<>0 or h<>0 or p<>0 or litri<>0, 
			CONCAT("Dimensioni mm L/ø ",l," H ",h," P ",p," Litri ",litri,"l"),""), 
			IF(peso IS NOT NULL AND peso<>0, CONCAT(" Peso ", peso,"Kg"),""),
			IF(min<>0 AND max<>0, CONCAT(" Temperatura ",min,"...",max," °C "),""), 
			IF(umidità<>0, CONCAT("Umidità ",umidità,"ur% "),""),
			IF(kw<>0, CONCAT(" Ass. a ri. ",kw,"mA "),""), 
			IF(kwp<>0, CONCAT(" As. in all. ",kwp,"mA"),"")) AS "altre", 

		IF(tipo="n" AND prezzo=0, NULL, quantità) AS "quantita", 
		articolo_preventivo.unità_misura, 

		IF(show_price = 1, 
			IF(scontoriga>=0,(ROUND((prezzo-(IF(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))),(ROUND((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)*1+(IF(montato="0",0,1*((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))) - ((ROUND(round((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)*scontoriga/100,2)*1)+((IF(montato="0",0,1*((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100)))))*scontoriga/100)),
			articolo_preventivo.costo) 
		AS "prezzo", 

		IF(show_price = 1,
			IF(discount_zero = 1,
				IF(scontoriga<=0, NULL, ROUND(scontoriga,2)),
				IF(scontoriga<0, ROUND(scontoriga-scontoriga,2), ROUND(scontoriga,2))), 
			CAST(IF(montato=0,0,articolo_preventivo.tempo_installazione) AS signed)) 
		AS "sconto",

		IF(show_price = 1, 
			CAST(iva AS decimal), 
			CAST(IF(montato=0,0,articolo_preventivo.tempo_installazione/60*articolo_preventivo.quantità) AS DECIMAL(11,2))) 
		AS "iva", 

		IF(show_price = 1, 
			CAST((
				(ROUND((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100)))))
				*(IF(scontoriga=0 or scontoriga IS NULL OR scontoriga="",1, (100-scontoriga)/100))) AS DECIMAL(11,2))*quantità, 
			articolo_preventivo.quantità*articolo_preventivo.costo)
		AS "tot", 

		CONCAT(percorso, "temp.bmp") AS "foto", 

		IF(mounted = 0, 
			"", 
			IF(montato="1" AND prezzo>0 AND id_articolo IS NOT NULL,"!! N.B. IL PREZZO DELL''ARTICOLO E'' COMPRESIVO DI INSTALLAZIONE E COLLAUDO", IF(id_articolo IS NOT NULL, "!! N.B. IL PREZZO DELL''ARTICOLO E'' PER SOLA FORNITURA",""))) 
		AS "mont",

		(ROUND(((ROUND((prezzo-(IF(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))))*scontoriga/100,2)*quantità) AS "totscont", 
		
		marca.nome AS "marca",
      	articolo_preventivo.foto AS "foto2"

    FROM articolo_preventivo 
		LEFT JOIN articolo ON id_articolo=codice_articolo 
		JOIN configurazione_percorsi ON tipo_percorso="temp"   
    	LEFT JOIN marca ON id_marca=marca 
		LEFT JOIN preventivo_lotto 
			ON preventivo_lotto.id_preventivo=articolo_preventivo.id_preventivo 
			AND preventivo_lotto.anno=articolo_preventivo.anno 
			AND preventivo_lotto.posizione=articolo_preventivo.lotto  
			AND preventivo_lotto.id_revisione= quote_rev_id 
		LEFT JOIN Lotto 
			ON lotto.Id_lotto = preventivo_lotto.id_lotto
	WHERE articolo_preventivo.id_preventivo = quote_id 
    	AND articolo_preventivo.anno = quote_year
		AND articolo_preventivo.id_revisione =  quote_rev_id 
	ORDER BY articolo_preventivo.lotto, id_tab; 

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printQuoteBodyTotals; 
DELIMITER $$
CREATE PROCEDURE `sp_printQuoteBodyTotals`(
	IN quote_id INT(11), 
	IN quote_year INT(11),
	IN quote_rev_id INT(11), 
	IN product_code_type SMALLINT, 
	IN show_price BIT(1)
)
BEGIN

	DECLARE decription_type INT(11);
	DECLARE discount_zero INT(11);
	DECLARE mounted INT(11); 

	SELECT valore
		INTO decription_type
	FROM preventivo_impost 
	WHERE tipo="desc";

	SELECT valore
		INTO discount_zero
	FROM preventivo_impost 
	WHERE tipo="sconto_0";

	SELECT valore
		INTO mounted
	FROM preventivo_impost 
	WHERE tipo="stampa_imoco";


	SELECT 
		articolo_preventivo.Id_preventivo,
		articolo_preventivo.Anno,
		articolo_preventivo.Id_revisione, 
		articolo_preventivo.Lotto,
		lotto.Nome AS nome_lotto,

		SUM(IF(show_price = 1, 
			IF(scontoriga>=0,(ROUND((prezzo-(IF(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))),(ROUND((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)*1+(IF(montato="0",0,1*((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))) - ((ROUND(round((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)*scontoriga/100,2)*1)+((IF(montato="0",0,1*((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100)))))*scontoriga/100)),
			articolo_preventivo.costo))
		AS "prezzo", 

		SUM(IF(show_price = 1, 
			CAST((
				(ROUND((prezzo-(if(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100)))))
				*(IF(scontoriga=0 or scontoriga IS NULL OR scontoriga="",1, (100-scontoriga)/100))) AS DECIMAL(11,2))*quantità, 
			articolo_preventivo.quantità*articolo_preventivo.costo))
		AS "tot", 
		SUM((ROUND(((ROUND((prezzo-(IF(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)+(IF(montato="0",0,((articolo_preventivo.tempo_installazione/60*prezzo_h) - ((articolo_preventivo.tempo_installazione/60*prezzo_h)*scontolav/100))))))*scontoriga/100,2)*quantità)) AS "totscont"
	
    FROM articolo_preventivo 
		LEFT JOIN articolo ON id_articolo=codice_articolo 
		LEFT JOIN preventivo_lotto 
			ON preventivo_lotto.id_preventivo=articolo_preventivo.id_preventivo 
			AND preventivo_lotto.anno=articolo_preventivo.anno 
			AND preventivo_lotto.posizione=articolo_preventivo.lotto  
			AND preventivo_lotto.id_revisione= quote_rev_id 
		LEFT JOIN Lotto 
			ON lotto.Id_lotto = preventivo_lotto.id_lotto
	WHERE articolo_preventivo.id_preventivo = quote_id 
    	AND articolo_preventivo.anno = quote_year
		AND articolo_preventivo.id_revisione =  quote_rev_id
	GROUP BY articolo_preventivo.lotto
	ORDER BY articolo_preventivo.lotto; 

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_printQuotePrivacy; 
DELIMITER $$
CREATE PROCEDURE `sp_printQuotePrivacy`(
	IN quote_id INT(11), 
	IN quote_year INT(11),
	IN quote_rev_id INT(11)
)
BEGIN

	DECLARE quote_date DATE; 
	DECLARE quote_type INT(11); 
	
	DECLARE payment_condition INT(11);
	DECLARE payment_condition_str VARCHAR(50); 
	
	DECLARE company_name VARCHAR(150); 
	DECLARE company_holder VARCHAR(150);
	
	DECLARE extra_hour_price VARCHAR(50); 
	DECLARE hour_price VARCHAR(50);  
	
	-- extract payment condition
	SELECT condizione_pagamento, revisione_preventivo.data 
		INTO payment_condition, quote_date
	FROM revisione_preventivo
		INNER JOIN clienti ON clienti.Id_cliente = revisione_preventivo.id_cliente 
	WHERE revisione_preventivo.Id_preventivo = quote_id 
		AND revisione_preventivo.Anno = quote_year 
		AND revisione_preventivo.Id_revisione = quote_rev_id; 

  IF payment_condition IS NOT NULL then
  	SELECT nome INTO payment_condition_str 
  	FROM condizione_pagamento
  	WHERE id_condizione = payment_condition; 
  ELSE
	 SELECT valore INTO payment_condition_str 
	 FROM preventivo_impost 
	 WHERE tipo = "cond_def";
  END IF;
  
  
	SELECT tipo 
		INTO quote_type
	FROM preventivo 
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year; 
	
	-- exctract company info
	SELECT ragione_sociale 
	 INTO company_name 
	FROM azienda 
	WHERE azienda.data <= quote_date
	ORDER BY azienda.data desc 
	LIMIT 1; 
	
	SELECT operaio.Ragione_sociale
		INTO company_holder
	FROM operaio 
		INNER JOIN azienda_inizio
		ON operaio.Id_operaio = azienda_inizio.titolare;
		
	-- extract subscription info
	SELECT 
		CONCAT(ROUND(ora_straordinaria,2), ""), 
		CONCAT(ROUND(ora_normale,2) , "")
	INTO 
		extra_hour_price, 
		hour_price	
	FROM revisione_preventivo 
		LEFT JOIN abbonamento ON id_abbonamento=tariffa 
	WHERE revisione_preventivo.id_preventivo = quote_id 
		AND revisione_preventivo.anno = quote_year
      AND id_revisione = quote_rev_id;
   
   
   IF extra_hour_price IS NULL THEN
   	SET extra_hour_price = 'NESSUN ABBONAMENTO ASSOCIATO'; 
   END IF;
   
   IF hour_price IS NULL THEN
   	SET hour_price = 'NESSUN ABBONAMENTO ASSOCIATO'; 
   END IF; 

	SELECT titolo,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(testo, 
		"%azienda",  IFNULL(company_name,"")),
		"%titolare", IFNULL(company_holder, "")),
		"%annop", IFNULL(quote_year, "")), 
		"%condi", IFNULL(payment_condition_str, "")),
		"%prezzo_eco",IFNULL(extra_hour_price, "")), 
		"%prezzo_norm", IFNULL(hour_price, ""))	
	AS testo, 
	Id_tipo
   FROM preventivo_fine 
	WHERE id_tipo = 2 AND tipo_preventivo = quote_type
	ORDER BY posizione; 

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printQuoteClauses; 
DELIMITER $$
CREATE PROCEDURE `sp_printQuoteClauses`(
	IN quote_id INT(11), 
	IN quote_year INT(11),
	IN quote_rev_id INT(11)
)
BEGIN

	DECLARE quote_date DATE; 
	DECLARE quote_type INT(11); 
	
	DECLARE payment_condition INT(11);
	DECLARE payment_condition_str VARCHAR(50); 
	
	DECLARE company_name VARCHAR(150); 
	DECLARE company_holder VARCHAR(150);
	
	DECLARE extra_hour_price VARCHAR(50); 
	DECLARE hour_price VARCHAR(50);  
	
	-- extract payment condition
	SELECT condizione_pagamento, revisione_preventivo.data 
		INTO payment_condition, quote_date
	FROM revisione_preventivo
		INNER JOIN clienti ON clienti.Id_cliente = revisione_preventivo.id_cliente 
	WHERE revisione_preventivo.Id_preventivo = quote_id 
		AND revisione_preventivo.Anno = quote_year 
		AND revisione_preventivo.Id_revisione = quote_rev_id; 

  IF payment_condition IS NOT NULL then
  	SELECT nome INTO payment_condition_str 
  	FROM condizione_pagamento
  	WHERE id_condizione = payment_condition; 
  ELSE
	 SELECT valore INTO payment_condition_str 
	 FROM preventivo_impost 
	 WHERE tipo = "cond_def";
  END IF;
  
  
	SELECT tipo 
		INTO quote_type
	FROM preventivo 
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year; 
	
	-- exctract company info
	SELECT ragione_sociale 
	 INTO company_name 
	FROM azienda 
	WHERE azienda.data <= quote_date
	ORDER BY azienda.data desc 
	LIMIT 1; 
	
	SELECT operaio.Ragione_sociale
		INTO company_holder
	FROM operaio 
		INNER JOIN azienda_inizio
		ON operaio.Id_operaio = azienda_inizio.titolare;
		
	-- extract subscription info
	SELECT 
		CONCAT(ROUND(ora_straordinaria,2), ""), 
		CONCAT(ROUND(ora_normale,2) , "")
	INTO 
		extra_hour_price, 
		hour_price	
	FROM revisione_preventivo 
		LEFT JOIN abbonamento ON id_abbonamento=tariffa 
	WHERE revisione_preventivo.id_preventivo = quote_id 
		AND revisione_preventivo.anno = quote_year
      AND id_revisione = quote_rev_id;
   
   
   IF extra_hour_price IS NULL THEN
   	SET extra_hour_price = 'NESSUN ABBONAMENTO ASSOCIATO'; 
   END IF;
   
   IF hour_price IS NULL THEN
   	SET hour_price = 'NESSUN ABBONAMENTO ASSOCIATO'; 
   END IF; 

	SELECT titolo,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(testo, 
		"%azienda",  IFNULL(company_name,"")),
		"%titolare", IFNULL(company_holder, "")),
		"%annop", IFNULL(quote_year, "")), 
		"%condi", IFNULL(payment_condition_str, "")),
		"%prezzo_eco",IFNULL(extra_hour_price, "")), 
		"%prezzo_norm", IFNULL(hour_price, ""))	
	AS testo, 
	Id_tipo
   FROM preventivo_fine 
	WHERE id_tipo = 1 AND tipo_preventivo = quote_type
	ORDER BY posizione; 

END $$
DELIMITER ;



-- Invoices 
DROP PROCEDURE IF EXISTS sp_printInvoicesPayments; 
DELIMITER $$
CREATE PROCEDURE `sp_printInvoicesPayments`(
	IN start_date DATE, 
	IN end_date DATE,
	IN company_name VARCHAR(100), 
	IN payment_status TINYINT,
	IN group_by VARCHAR(100) 
)
BEGIN
	DECLARE all_payments TINYINT DEFAULT 0;
	DECLARE paid_payments TINYINT DEFAULT 1;
	DECLARE not_paid_payments TINYINT DEFAULT 2;

	-- extract invoices by filter
	DROP TABLE IF EXISTS tmp_print_invoices_payments;
	CREATE TEMPORARY TABLE tmp_print_invoices_payments
	SELECT 
		ragione_sociale, 
		fattura.id_fattura AS "id_fattura", 
		fattura.anno AS "anno", 
		(SUM(CAST(((IF(c.tipo<>"S", prezzo_unitario,0) -   (sconto /100 * if(c.tipo<>"S", prezzo_unitario,0))) * quantità) +((IF(c.tipo<>"S", prezzo_unitario,0) - (sconto/100*if(c.tipo<>"S", prezzo_unitario,0)))*quantità)* (IF(tipo_fattura="4","0", IF(c.iva="" or c.iva IS NULL, "0", c.iva))/100) as decimal(11,2))))+SUM(IF(c.tipo="S", prezzo_unitario,0)) AS "totale_fattura", 
		CAST(0 AS DECIMAL(11,2)) AS "da_pagare", 
		CAST(0 AS DECIMAL(11,2)) AS "importo_rata", 
		fattura.data AS "data", 
		condizione_pagamento.nome, 
		condizione_pagamento.tipo AS "n_tipo",
		tipo_pagamento.nome AS "tipo_pagamento", 
		fattura.stato, 
		condizione_pagamento.mesi as "quantita_rate"
		
	FROM fattura 
		INNER JOIN condizione_pagamento AS condizione_pagamento 
			ON cond_pagamento = condizione_pagamento.id_condizione 
		LEFT JOIN fattura_articoli AS c 
			ON c.id_fattura = fattura.id_fattura AND c.anno=fattura.anno 
		INNER JOIN clienti 
			ON fattura.id_cliente=clienti.id_cliente
		LEFT JOIN tipo_pagamento 
			ON condizione_pagamento.tipo=tipo_pagamento.id_tipo

	WHERE 
		fattura.DATA >= start_date
		AND fattura.DATA <= end_date
		AND fattura.anno<>"0"
	GROUP BY fattura.id_fattura, anno 
	ORDER BY n_tipo, anno DESC, fattura.id_fattura DESC;
	 
	IF IFNULL(company_name, '') <> '' THEN
		DELETE FROM tmp_print_invoices_payments 
		WHERE ragione_sociale NOT LIKE CONCAT('%',company_name,'%');
	END IF;
	
	IF payment_status = paid_payments THEN
		DELETE FROM tmp_print_invoices_payments 
		WHERE stato NOT IN (3);
	END IF; 
	
	IF payment_status = not_paid_payments THEN
		DELETE FROM tmp_print_invoices_payments 
		WHERE stato NOT IN (1,4);
	END IF;
	
	
	-- fill to pay and payments ampunt column
	UPDATE tmp_print_invoices_payments
	SET da_pagare = IFNULL(totale_fattura, 0), 
		importo_rata = IFNULL(totale_fattura, 0)/quantita_rate; 
		
		
	-- extract down payment
	DROP TABLE IF EXISTS tmp_down_payment;
	CREATE TEMPORARY TABLE tmp_down_payment
	SELECT	
		tmp_print_invoices_payments.id_fattura, 
		tmp_print_invoices_payments.anno, 
		IFNULL(SUM(fattura_acconto.importo), 0) totale_acconti
	FROM tmp_print_invoices_payments
		LEFT JOIN fattura_pagamenti 
			ON fattura_pagamenti.id_fattura = tmp_print_invoices_payments.id_fattura
				AND fattura_pagamenti.anno = tmp_print_invoices_payments.anno
				AND fattura_pagamenti.`data` IS NULL
		LEFT JOIN fattura_acconto 
		 	ON fattura_acconto.id_pagamento = fattura_pagamenti.id_pagamento 
			   AND fattura_pagamenti.id_fattura = fattura_acconto.id_fattura
				AND fattura_pagamenti.anno = fattura_acconto.anno			
	GROUP BY tmp_print_invoices_payments.id_fattura, tmp_print_invoices_payments.anno;	

	IF group_by = "payment_type" THEN
		-- extract invoices by filter	
		SELECT 		
			tmp_print_invoices_payments.ragione_sociale, 
			tmp_print_invoices_payments.id_fattura, 
			tmp_print_invoices_payments.anno, 
			tmp_print_invoices_payments.totale_fattura, 
			IF(da_pagare < ((COUNT(fattura_pagamenti.`data`) * importo_rata) + tmp_down_payment.totale_acconti), 
				0.00,
				(da_pagare - (COUNT(fattura_pagamenti.`data`) * importo_rata) - tmp_down_payment.totale_acconti)
			) as da_pagare, 
			tmp_print_invoices_payments.importo_rata, 
			tmp_print_invoices_payments.data, 
			tmp_print_invoices_payments.nome, 
			tmp_print_invoices_payments.n_tipo,
			tmp_print_invoices_payments.tipo_pagamento AS tipo_pagamento,
			mese.Nome AS mese,
			tmp_print_invoices_payments.stato,
			CONVERT(tmp_print_invoices_payments.tipo_pagamento USING utf8) AS group_by
		FROM tmp_print_invoices_payments
			LEFT JOIN fattura_pagamenti 
				ON fattura_pagamenti.id_fattura = tmp_print_invoices_payments.id_fattura
					AND fattura_pagamenti.anno = tmp_print_invoices_payments.anno
					AND fattura_pagamenti.`data` IS NOT NULL
			INNER JOIN tmp_down_payment	
				ON tmp_down_payment.id_fattura = tmp_print_invoices_payments.id_fattura
					AND tmp_down_payment.anno = tmp_print_invoices_payments.anno
					AND tmp_down_payment.anno = tmp_print_invoices_payments.anno
			INNER JOIN mese
				ON mese.Id_mese = MONTH(tmp_print_invoices_payments.data)
		GROUP BY tmp_print_invoices_payments.id_fattura, tmp_print_invoices_payments.anno
		ORDER BY tipo_pagamento, tmp_print_invoices_payments.anno DESC, tmp_print_invoices_payments.id_fattura DESC;
	
	END IF;

	IF group_by = "month" THEN		
		SELECT 		
			tmp_print_invoices_payments.ragione_sociale, 
			tmp_print_invoices_payments.id_fattura, 
			tmp_print_invoices_payments.anno, 
			tmp_print_invoices_payments.totale_fattura, 
			IF(da_pagare < ((COUNT(fattura_pagamenti.`data`) * importo_rata) + tmp_down_payment.totale_acconti), 
				0.00,
				(da_pagare - (COUNT(fattura_pagamenti.`data`) * importo_rata) - tmp_down_payment.totale_acconti)
			) as da_pagare, 
			tmp_print_invoices_payments.importo_rata, 
			tmp_print_invoices_payments.data, 
			tmp_print_invoices_payments.nome, 
			tmp_print_invoices_payments.n_tipo,
			tmp_print_invoices_payments.tipo_pagamento AS tipo_pagamento,
			mese.Nome AS mese,
			tmp_print_invoices_payments.stato,
			CONVERT(CONCAT(mese.Nome, ' ', tmp_print_invoices_payments.anno) USING utf8) AS group_by
		FROM tmp_print_invoices_payments
			LEFT JOIN fattura_pagamenti 
				ON fattura_pagamenti.id_fattura = tmp_print_invoices_payments.id_fattura
					AND fattura_pagamenti.anno = tmp_print_invoices_payments.anno
					AND fattura_pagamenti.`data` IS NOT NULL
			INNER JOIN tmp_down_payment	
				ON tmp_down_payment.id_fattura = tmp_print_invoices_payments.id_fattura
					AND tmp_down_payment.anno = tmp_print_invoices_payments.anno
					AND tmp_down_payment.anno = tmp_print_invoices_payments.anno
			INNER JOIN mese
				ON mese.Id_mese = MONTH(tmp_print_invoices_payments.data)
		GROUP BY tmp_print_invoices_payments.id_fattura, tmp_print_invoices_payments.anno
		ORDER BY tmp_print_invoices_payments.anno DESC, mese.id_mese DESC, tmp_print_invoices_payments.id_fattura DESC;
	 
	END IF;
	
END $$
DELIMITER ;

-- ReportDailyList 
DROP PROCEDURE IF EXISTS sp_printReportDailyList; 
DELIMITER $$
CREATE PROCEDURE `sp_printReportDailyList`(
	IN start_date DATE, 
	IN end_date DATE,
	IN employee_id INT(11)
)
BEGIN

	-- extract reports by filter
	DROP TABLE IF EXISTS tmp_print_report_daily_list;
	CREATE TEMPORARY TABLE tmp_print_report_daily_list
	SELECT 
		operaio.id_operaio,
		operaio.ragione_sociale, 
		rapporto_giornaliero.data_rapporto, 
		rapporto_giornaliero_tipo_attivita.nome,
		rapporto_giornaliero_tipo_attivita.id, 
		rapporto_giornaliero_attivita.descrizione_lavoro,
		rapporto_giornaliero_attivita.note as note_attivita, 
		CAST(TIME_FORMAT(`ora_inizio`, '%H:%i:00') AS TIME) AS ora_inizio,
		CAST(TIME_FORMAT(`ora_fine`, '%H:%i:00') AS TIME) AS ora_fine,
		rapporto_giornaliero.note, 
		TIME_TO_SEC(TIMEDIFF(rapporto_giornaliero_attivita.ora_fine, rapporto_giornaliero_attivita.ora_inizio)) as "totale_secondi", 
		CONCAT(operaio.id_operaio, '|', rapporto_giornaliero.data_rapporto) group_key
	FROM rapporto_giornaliero 
		INNER JOIN operaio 
			ON operaio.id_operaio = rapporto_giornaliero.id_operaio 
		INNER JOIN rapporto_giornaliero_attivita
			ON rapporto_giornaliero.id = rapporto_giornaliero_attivita.id_rapporto_giornaliero
		LEFT JOIN rapporto_giornaliero_tipo_attivita 
			ON rapporto_giornaliero_attivita.tipo_lavoro = rapporto_giornaliero_tipo_attivita.id
	WHERE 
		rapporto_giornaliero.data_rapporto >= start_date
		AND rapporto_giornaliero.data_rapporto <= end_date
	ORDER BY data_rapporto, rapporto_giornaliero_attivita.ora_inizio;
	 
	IF employee_id IS NOT NULL AND employee_id != 0 THEN
		DELETE FROM tmp_print_report_daily_list 
		WHERE id_operaio != employee_id; 
	END IF; 

	SELECT * 
	FROM tmp_print_report_daily_list; 
	
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printChecklistGetById;
DELIMITER //
CREATE PROCEDURE sp_printChecklistGetById (IN checklist_id INT(11))
BEGIN
	SELECT 	
		`id`,
		`id_mobile`,
		`data_esecuzione`,
		`id_checklist_model`
		`id_operaio`,
		`id_cliente`,
		`id_responsabile`,
		`id_impianto`,
		`ragione_sociale`,
		`indirizzo`,
		`citta`,
		`responsabile`,
		`impianto_luogo_installazione`,
		`impianto_centrale`,
		`impianto_data_installazione`,
		`impianto_dipartimento`,
		`timestamp_creazione`,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod` 
	FROM CHECKlist
	WHERE Id = checklist_id; 
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_printChecklistParagraphGetByChecklist;
DELIMITER //
CREATE PROCEDURE sp_printChecklistParagraphGetByChecklist (
	IN checklist_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_checklist_model_paragrafo`,
		`nome`,
		`descrizione`,
		`ordine`,
		`utente_mod`,
		`data_mod`
	FROM checklist_paragrafo
	WHERE id_Checklist = checklist_id; 
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_printChecklistRowGetByChecklist;
DELIMITER //
CREATE PROCEDURE sp_printChecklistRowGetByChecklist (
	IN checklist_id INT(11) 
)
BEGIN
	SELECT 	
		`id`,
		`id_checklist`,
		`id_paragrafo`,
		`json_data`,
		`tipo_riga`,
		`id_checklist_model_elemento`,
		`id_checklist_model_paragrafo`,
		`id_checklist_model`,
		`ordine`,
		`nome`,
		`descrizione`,
		`indicazioni_tecnico`
	FROM checklist_paragrafo_riga
	WHERE id_Checklist = checklist_id; 
END //
DELIMITER ;





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

	DROP TABLE IF EXISTS tmp_reportsList;

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

	IF employee_id IS NOT NULL AND employee_id > 0 THEN
		DELETE FROM tmp_reportsList
		WHERE id_operaio <> employee_id; 
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
	
	SELECT DISTINCT rapporto.numero AS "ID", 
		data_esecuzione AS "data", 
		a.ragione_sociale, 
		b.descrizione, 
		tipo_intervento.nome,
		rapporto.relazione,
		rapporto.fattura, 
		rapporto.anno_fattura, 
		stato_rapporto.Nome AS stato,
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) AS "Tempo_lavoro",
		Tempo_viaggio,
		IFNULL(SUM(IFNULL(rapporto_tecnico_lavoro.totale,0)), 0) + IFNULL(Tempo_viaggio, 0) AS "Tempo_totale",
		rapporto.cost_lav,
		rapporto.prez_lav,
		IFNULL(rapporto.Costo, 0) - IFNULL(rapporto.cost_lav, 0) AS costo_materiale,
		IFNULL(rapporto.Totale, 0) - IFNULL(rapporto.prez_lav, 0) AS prezzo_materiale,
		rapporto.Costo,
		rapporto.Totale,
		DATE_FORMAT(data_esecuzione, '%m %Y') AS titolo_gruppo,
		DATE_FORMAT(data_esecuzione, '%Y-%m') AS id_gruppo
	FROM tmp_reportsList AS tmp_reports 
		INNER jOIN Rapporto 
			ON Rapporto.Id_rapporto = tmp_reports.Id_Rapporto AND Rapporto.Anno = tmp_reports.Anno
		INNER JOIN tipo_intervento ON id_tipo=tipo_intervento 
		INNER JOIN clienti AS a ON a.id_cliente=rapporto.id_cliente 
		LEFT JOIN impianto AS b ON b.id_impianto=rapporto.id_impianto 
		LEFT JOIN stato_rapporto ON rapporto.stato = stato_rapporto.id_stato 
		LEFT JOIN rapporto_tecnico AS t 
			ON t.id_rapporto=rapporto.id_rapporto AND t.anno=rapporto.anno 
		LEFT JOIN rapporto_tecnico_lavoro  
			ON rapporto_tecnico_lavoro.id_rapporto=rapporto.id_rapporto 
			AND rapporto_tecnico_lavoro.anno=rapporto.anno 
	GROUP BY tmp_reports.id_rapporto, tmp_reports.anno
	ORDER BY  data_esecuzione DESC, a.ragione_sociale ASC;	

		
END $$
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_printDdtsListByInvoiceBody; 
DELIMITER $$
CREATE PROCEDURE `sp_printDdtsListByInvoiceBody`(
	IN start_date DATE, 
	IN end_date DATE, 
	IN customer_id INT(11), 
	IN system_id INT(11),
	IN invoiced_status INT(11)
)
BEGIN

	DROP TABLE IF EXISTS tmp_ddtsList;

	CREATE TEMPORARY TABLE tmp_ddtsList
	SELECT 
		ddt.id_ddt,
		ddt.anno, 
		ddt.id_cliente, 
		ddt.Impianto,
		ddt.stato,
		fattura,
		anno_fattura
	FROM ddt 
	WHERE id_cliente IS NOT NULL AND data_documento >= start_date AND data_documento <= end_date;
	
	IF customer_id IS NOT NULL AND customer_id > 0 THEN
		DELETE FROM tmp_ddtsList
		WHERE id_cliente <> customer_id; 
	END IF; 

	IF system_id IS NOT NULL AND system_id > 0 THEN
		DELETE FROM tmp_ddtsList
		WHERE impianto <> system_id; 
	END IF;
	
	IF invoiced_status IS NOT NULL AND invoiced_status = 2 THEN -- NON FATTURATI
		DELETE FROM tmp_ddtsList
		WHERE fattura IS NOT NULL and anno_fattura IS NOT NULL AND anno_fattura <> 0;
	END IF; 

	IF invoiced_status IS NOT NULL AND invoiced_status = 1 THEN -- FATTURATI
		DELETE FROM tmp_ddtsList
		WHERE fattura IS NULL OR anno_fattura IS NULL OR anno_fattura = 0;
	END IF; 
	
	SELECT DISTINCT ddt.id_ddt AS "ID", 
		ddt.data_documento AS "data", 
		clienti.ragione_sociale, 
		impianto.descrizione, 
		ddt.fattura, 
		ddt.anno_fattura, 
		stato_ddt.Nome AS stato,
		DATE_FORMAT(data_documento, '%m %Y') AS titolo_gruppo,
		DATE_FORMAT(data_documento, '%Y-%m') AS id_gruppo,
		causale_trasporto.causale AS "causale_trasporto", 
		IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Comune",  
		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS prezzo_totale, 
		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS costo_totale
	FROM tmp_ddtsList AS tmp_ddts
		INNER jOIN Ddt 
			ON Ddt.Id_ddt = tmp_ddts.Id_ddt AND Ddt.Anno = tmp_ddts.Anno
		LEFT JOIN causale_trasporto ON ddt.causale=id_causale
		INNER JOIN clienti ON clienti.id_cliente = ddt.id_cliente 
		LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
		LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
		LEFT JOIN impianto ON id_impianto = ddt.impianto
		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
		LEFT JOIN commessa_ddt ON commessa_ddt.Id_ddt=ddt.id_ddt AND commessa_ddt.Anno_ddt=ddt.anno 
		LEFT JOIN stato_ddt ON ddt.stato = stato_ddt.id_stato 
	GROUP BY ddt.id_ddt, ddt.anno
	ORDER BY  data_documento DESC, ragione_sociale ASC;	

		
END $$
DELIMITER ;


