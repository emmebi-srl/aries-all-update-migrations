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

DROP VIEW if exists `vw_mobilerapportointestazione`;

CREATE OR REPLACE VIEW vw_mobilesystems
as
SELECT `impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Id_cliente` AS `id_cliente`,`impianto`.`Id_gestore` AS `id_gestore`,`impianto`.`Id_occupante` AS `id_occupante`, IFNULL(`impianto`.`Abbonamento`,0) AS `abbonamento`, IFNULL(`impianto`.`Data_Funzione`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `data_funzione`, IFNULL(`impianto`.`scadenza_garanzia`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `Scadenza_Garanzia`,`impianto`.`Tipo_impianto` AS `tipo_impianto`,`impianto`.`Stato` AS `stato`,`impianto`.`Descrizione` AS `descrizione`, IFNULL(IF((`d1`.`Id_destinazione` <> `d2`.`Id_destinazione`), CONCAT(CONCAT(`d2`.`Indirizzo`,' n.',`d2`.`numero_civico`,`d2`.`Altro`),' - ', CONCAT(IF(((`f2`.`Nome` IS NOT NULL) AND (`f2`.`Nome` <> '')), CONCAT(`f2`.`Nome`,' di '),''),`c2`.`Nome`,' (',`c2`.`provincia`,')'),' - ',`impianto`.`Descrizione`),''),'') AS `luogo`, IFNULL(CONCAT(`d1`.`Indirizzo`,' n.',`d1`.`numero_civico`,`d1`.`Altro`),'') AS `indirizzo`, CONCAT(IF(((`frazione`.`Nome` IS NOT NULL) AND (`frazione`.`Nome` <> '')), CONCAT(`frazione`.`Nome`,' di '),''),`comune`.`Nome`,' (',`comune`.`provincia`,')') AS `citta`, IFNULL(`r1`.`mail`,'') AS `mail`, IFNULL(`r1`.`Telefono`,'') AS `telefono`, IFNULL(`r1`.`altro_telefono`,'') AS `cellulare`,`tipo_impianto`.`nome` AS `tipo_impianto_nome`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`, IFNULL(`clienti`.`Partita_iva`,'') AS `partita_iva`, IFNULL(`clienti`.`Codice_Fiscale`,'') AS `codice_fiscale`, IFNULL(`impianto`.`centrale`,'') AS `centrale`, IFNULL(`impianto`.`gsm`,'') AS `gsm`, IFNULL(`impianto`.`combinatore_telefonico`,'') AS `combinatore_telefonico`,`impianto`.`orario_prog` AS `orario_prog`
FROM (((((((((`impianto`
JOIN `clienti` ON((`clienti`.`Id_cliente` = `impianto`.`Id_cliente`)))
JOIN `destinazione_cliente` `d1` ON(((`d1`.`id_cliente` = `clienti`.`Id_cliente`) AND (`d1`.`Id_destinazione` = 1))))
JOIN `comune` ON((`comune`.`Id_comune` = `d1`.`Comune`)))
LEFT JOIN `frazione` ON((`frazione`.`Id_frazione` = `d1`.`Frazione`)))
LEFT JOIN `tipo_impianto` ON((`tipo_impianto`.`id_tipo` = `impianto`.`Tipo_impianto`)))
LEFT JOIN `destinazione_cliente` `d2` ON(((`d2`.`id_cliente` = `clienti`.`Id_cliente`) AND (`d2`.`Id_destinazione` = `impianto`.`Destinazione`))))
JOIN `comune` `c2` ON((`c2`.`Id_comune` = `d2`.`Comune`)))
LEFT JOIN `frazione` `f2` ON((`f2`.`Id_frazione` = `d2`.`Frazione`)))
LEFT JOIN `riferimento_clienti` `r1` ON(((`r1`.`Id_cliente` = `clienti`.`Id_cliente`) AND (`r1`.`Id_riferimento` = '1'))))
WHERE ((`impianto`.`Stato` < 4) OR (`impianto`.`Stato` > 7))
GROUP BY `impianto`.`Id_impianto`;
