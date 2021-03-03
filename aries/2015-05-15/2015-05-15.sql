CREATE OR REPLACE VIEW vw_mobileTicketsOpened AS 
SELECT ticket.id_ticket AS "id_ticket",
	ticket.anno AS "anno", destinazione_cliente.indirizzo,
	IFNULL(destinazione_cliente.numero_civico, 0) AS numero_civico, 
	IFNULL(destinazione_cliente.altro, "") AS altro,
	IFNULL(frazione.nome, "") AS "frazione",
	comune.nome as "comune",
	comune.provincia AS "provincia",
	IFNULL(riferimento_clienti.telefono, "") AS "telefono",
	IFNULL(riferimento_clienti.altro_telefono, "") AS "cellulare", 
	urgenza, ragione_sociale, impianto.id_impianto AS id_impianto, 
	impianto.descrizione AS impianto_descrizione, clienti.id_cliente,
	ticket.descrizione as "ticket_descrizione"
FROM ticket
	INNER JOIN clienti ON clienti.id_cliente = ticket.id_cliente
	INNER JOIN destinazione_cliente ON destinazione_cliente.id_cliente = clienti.id_cliente 
		AND destinazione_cliente.id_destinazione = ticket.id_destinazione
	LEFT JOIN comune ON comune.id_Comune = destinazione_cliente.comune
	LEFT JOIN frazione ON frazione = frazione.id_frazione
	LEFT JOIN impianto ON impianto.id_impianto = ticket.id_impianto
	LEFT JOIN riferimento_clienti ON riferimento_clienti.id_cliente = clienti.id_cliente 	
		AND id_riferimento = 1
WHERE ticket.stato_ticket = "1" AND impianto.Id_impianto IS NOT NULL;
