DROP PROCEDURE IF EXISTS sp_searchCustomersLight; 
DELIMITER $$
CREATE PROCEDURE `sp_searchCustomersLight`(
	IN `company_name` VARCHAR(100),
	IN `customer_id` INT(11)
)
BEGIN
	
	SELECT 
		clienti.id_cliente, 
		ragione_sociale, 
		a.provincia, 
		stato_cliente AS "Stato", 
		CONCAT(comune.nome," ", indirizzo) AS indirizzo, 
		CONCAT(comune.nome," (", a.provincia,")") AS "comune", 
		CONCAT(indirizzo,", ", numero_civico) AS "indirizzo2"    
	FROM clienti 
		LEFT JOIN destinazione_cliente AS a ON a.id_cliente=clienti.id_cliente	AND a.attivo="1"  AND a.sede_principale="1" 
		LEFT JOIN comune ON comune.id_comune=comune  
	WHERE (ragione_sociale LIKE CONCAT('%', company_name, '%') or (clienti.id_cliente = IFNULL(customer_id, -1)))   
	GROUP BY clienti.id_cliente  
	ORDER BY ragione_sociale LIKE CONCAT(company_name, '%') desc, ragione_sociale   
	LIMIT 200;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_searchSystemsLight; 
DELIMITER $$
CREATE PROCEDURE `sp_searchSystemsLight`(
	IN `search_text` VARCHAR(100),
	IN `system_id` INT(11),
	IN `customer_id` INT(11)
)
BEGIN
	SET customer_id = IFNULL(customer_id, -1);
	
	SELECT Id_impianto,
		impianto.Id_cliente,
		tipo_impianto.nome as Tipo_impianto,
		stato_impianto.nome as Stato_impianto,
		stato_impianto.colore as Stato_impianto_colore,
		impianto.Descrizione,
		CONCAT(comune.nome," ", indirizzo) AS indirizzo
	FROM impianto
		INNER JOIN tipo_impianto ON tipo_impianto = id_tipo
		INNER JOIN stato_impianto ON Stato = id_stato
		LEFT JOIN destinazione_cliente AS a ON a.id_cliente=impianto.id_cliente	AND a.id_destinazione = impianto.destinazione
		LEFT JOIN comune ON comune.id_comune=comune
	WHERE (impianto.descrizione LIKE CONCAT('%', search_text, '%') or (impianto.id_impianto = IFNULL(system_id, -1)))
		AND customer_id = IF(customer_id = -1, -1, impianto.id_cliente) 
	GROUP BY impianto.id_impianto  
	ORDER BY impianto.Descrizione LIKE CONCAT(search_text, '%') desc, impianto.descrizione   
	LIMIT 200;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_searchQuotesLight; 
DELIMITER $$
CREATE PROCEDURE `sp_searchQuotesLight`(
	IN `search_text` TEXT
)
BEGIN
	
	SELECT 
		preventivo.id_preventivo, 
		preventivo.anno,
		ragione_sociale,
		preventivo.Note as Descrizione, 
		preventivo.Stato AS "Stato",
		stato_preventivo.colore,
		revisione_preventivo.data AS "data"
	FROM preventivo 
		INNER JOIN revisione_preventivo
			ON revisione_preventivo.id_preventivo = preventivo.id_preventivo
			AND revisione_preventivo.anno = preventivo.anno
			AND revisione_preventivo.id_revisione = preventivo.revisione
		INNER JOIN clienti ON clienti.id_cliente = revisione_preventivo.id_cliente
		INNER JOIN stato_preventivo ON stato_preventivo.id_stato = preventivo.stato
	WHERE (ragione_sociale LIKE CONCAT('%', search_text, '%') 
		OR preventivo.id_preventivo LIKE CONCAT('%', search_text, '%')
		OR preventivo.anno LIKE CONCAT('%', search_text, '%')
		OR preventivo.Note LIKE CONCAT('%', search_text, '%'))
	ORDER BY stato_preventivo.prior desc, revisione_preventivo.data_creazione desc, id_preventivo desc 
	LIMIT 100;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_searchJobsLight; 
DELIMITER $$
CREATE PROCEDURE `sp_searchJobsLight`(
	IN `search_text` TEXT,
	IN customer_id INT(11)
)
BEGIN
	
	SELECT DISTINCT
		commessa.id_commessa, 
		commessa.anno,
		commessa.codice_commessa,
		clienti.ragione_sociale,
		commessa.Descrizione, 
		commessa.stato_commessa,
		stato_commessa.colore,
		commessa.data_inizio
	FROM commessa
		INNER JOIN clienti ON clienti.id_cliente = commessa.id_cliente
		INNER JOIN stato_commessa ON stato_commessa.id_stato = commessa.stato_commessa
	WHERE (ragione_sociale LIKE CONCAT('%', search_text, '%') 
		OR commessa.id_commessa LIKE CONCAT('%', search_text, '%')
		OR commessa.anno LIKE CONCAT('%', search_text, '%')
		OR commessa.Descrizione LIKE CONCAT('%', search_text, '%'))
			AND IF(customer_id = -1, True, commessa.id_cliente = customer_id)
	ORDER BY commessa.anno desc, commessa.id_commessa
	LIMIT 100;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_searchReportsLight; 
DELIMITER $$
CREATE PROCEDURE `sp_searchReportsLight`(
	IN `search_text` TEXT,
	IN customer_id INT(11)
)
BEGIN
	
	SELECT DISTINCT
		rapporto.id_rapporto, 
		rapporto.anno,
		rapporto.relazione,
		clienti.ragione_sociale, 
		rapporto.id_impianto,
		stato_rapporto.colore,
		rapporto.data_esecuzione
	FROM rapporto
		INNER JOIN clienti ON clienti.id_cliente = rapporto.id_cliente
		INNER JOIN stato_rapporto ON stato_rapporto.id_stato = rapporto.Stato
	WHERE (ragione_sociale LIKE CONCAT('%', search_text, '%') 
		OR rapporto.id_rapporto LIKE CONCAT('%', search_text, '%')
		OR rapporto.anno LIKE CONCAT('%', search_text, '%')
		OR rapporto.relazione LIKE CONCAT('%', search_text, '%'))
			AND IF(customer_id = -1, True, rapporto.id_cliente = customer_id)
	ORDER BY rapporto.anno desc, rapporto.id_rapporto desc
	LIMIT 100;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_searchDepotsTotals; 
DELIMITER $$
CREATE PROCEDURE `sp_searchDepotsTotals`(
	IN `allow_disabled` BIT(1),
	IN allow_zero_stock BIT(1)
)
BEGIN 
	SELECT tipo_magazzino.*,
		IFNULL(SUM(giacenza), 0) AS totale_articoli,
		IFNULL(SUM(prezzo*giacenza), 0) AS totale
	FROM tipo_magazzino
		LEFT JOIN magazzino ON id_tipo=tipo_Magazzino
		INNER JOIN articolo_listino ON id_listino=1 AND magazzino.id_articolo=articolo_listino.id_articolo
	WHERE IF(allow_disabled, TRUE, tipo_Magazzino.disabilitato = 0)
	GROUP BY id_tipo
	HAVING IF(allow_zero_stock, TRUE, totale_articoli <> 0)
	ORDER BY prior desc;
END $$
DELIMITER ;
