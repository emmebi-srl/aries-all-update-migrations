DROP VIEW IF EXISTS vw_dashboardGridSystemPeriodicMonitoring;
CREATE VIEW vw_dashboardGridSystemPeriodicMonitoring
 AS
SELECT 	impianto_abbonamenti_mesi.impianto AS "id",
		 	impianto_abbonamenti_mesi.mese AS "id_mese",
			impianto_abbonamenti_mesi.anno AS "anno",
			impianto.id_impianto, 
			descrizione, 
			ragione_sociale AS "cliente",
			IF(eseguito_il IS NULL, 0, 1) AS "svolto",
			1 AS "tipo",
			IFNULL(eseguito_il, da_eseguire) "da_eseguire"
FROM impianto_abbonamenti_mesi
	INNER JOIN impianto ON impianto=id_impianto
	INNER JOIN clienti ON impianto.id_cliente=clienti.id_cliente
WHERE (da_eseguire BETWEEN DATE_SUB(NOW(),INTERVAL 6 MONTH) AND DATE_ADD(NOW(),INTERVAL 6 MONTH))

UNION

SELECT DISTINCT 
			NULL AS Id, 
			mese.id_mese AS Id_mese, 
			impianto_abbonamenti_mesi.anno AS "anno",
			NULL AS Id_impianto, 
			CONCAT(mese.nome," ",impianto_abbonamenti_mesi.anno) AS "descrizione", 
			NULL AS "cliente",
			0 AS Svolto,
			0 AS Tipo,
			NULL "da_eseguire"
FROM impianto_abbonamenti_mesi
	INNER JOIN mese ON id_mese=mese
WHERE (da_eseguire BETWEEN DATE_SUB(NOW(),INTERVAL 6 MONTH) AND DATE_ADD(NOW(),INTERVAL 6 MONTH))

ORDER BY anno,id_mese, tipo,cliente;

DROP VIEW IF EXISTS vw_dashboardGridSystemReminder;
CREATE VIEW vw_dashboardGridSystemReminder
 AS
SELECT 	impianto_mesi.id_impianto AS "id",
		 	impianto_mesi.id_mese AS "id_mese",
			0 AS "anno",
			impianto.id_impianto, 
			descrizione, 
			ragione_sociale AS "cliente",
			0 AS "svolto",
			1 AS "tipo",
			NULL "da_eseguire"
FROM impianto_mesi
	INNER JOIN impianto ON impianto_mesi.Id_impianto=impianto.id_impianto
	INNER JOIN clienti ON impianto.id_cliente=clienti.id_cliente

WHERE impianto.Stato = 0  AND impianto_mesi.Id_Mese= MONTH(NOW())

ORDER BY id_mese, tipo,cliente;


DROP VIEW IF EXISTS vw_systemPeriodicMonitoringReminderGridMainElementTypeZero;
CREATE VIEW vw_systemPeriodicMonitoringReminderGridMainElementTypeZero
 AS
SELECT 	impianto_abbonamenti_mesi.Id,
		 	impianto_abbonamenti_mesi.mese AS "id_mese",
			impianto_abbonamenti_mesi.anno AS "anno",
			impianto.id_impianto, 
			impianto.descrizione "descrizione_impianto", 
			clienti.Id_cliente, 
			ragione_sociale,
			IF(eseguito_il IS NULL, 0, 1) AS "svolto",
			IFNULL(eseguito_il, da_eseguire) "da_eseguire",
			Tipo_impianto.nome "Tipo_impianto",
			IFNULL(impianto.Tempo_manutenzione/60, 0) "tempo_manutenzione"		
FROM impianto_abbonamenti_mesi
	INNER JOIN impianto ON impianto_abbonamenti_mesi.impianto=impianto.id_impianto
	INNER JOIN clienti ON impianto.id_cliente=clienti.id_cliente
	INNER JOIN Tipo_impianto ON impianto.Tipo_impianto = tipo_impianto.id_tipo
ORDER BY da_eseguire;


DROP VIEW IF EXISTS vw_systemPeriodicMonitoringReminderGridMainElementTypeOne;
CREATE VIEW vw_systemPeriodicMonitoringReminderGridMainElementTypeOne
 AS
SELECT 	0 As Id,
		 	impianto_mesi.Id_mese AS "id_mese",
			0 AS "anno",
			impianto_mesi.id_impianto, 
			impianto.descrizione "descrizione_impianto", 
			clienti.Id_cliente, 
			ragione_sociale,
			0 AS "svolto",
			NULL "da_eseguire",
			Tipo_impianto.nome "Tipo_impianto",
			0 "tempo_manutenzione"		
FROM impianto_mesi
	INNER JOIN impianto ON impianto_mesi.Id_impianto=impianto.id_impianto
	INNER JOIN clienti ON impianto.id_cliente=clienti.id_cliente
	INNER JOIN Tipo_impianto ON impianto.Tipo_impianto = tipo_impianto.id_tipo
WHERE impianto.Stato = 0 

ORDER BY id_mese, ragione_sociale;


DROP VIEW IF EXISTS vw_customerInsolvent;
CREATE VIEW vw_customerInsolvent
 AS

SELECT Clienti.Id_Cliente,
	Ragione_sociale, 
	Province.SIGLA AS Provincia,
	IF(Frazione.Nome IS NULL,comune.Nome, CONCAT(Frazione.Nome, " di ",  comune.Nome))  AS Citta,
	Comune.CAP AS CAP,
	Indirizzo,
	IFNULL(destinazione_cliente.numero_civico, 0) AS Civico,
	riferimento_clienti.Telefono, 
	riferimento_clienti.altro_telefono AS Cellulare 
FROM Clienti 
	INNER JOIN destinazione_cliente
		ON clienti.Id_cliente = destinazione_cliente.id_cliente
		AND destinazione_cliente.Sede_principale = 1 
	INNER JOIN riferimento_clienti 
		ON clienti.Id_cliente = riferimento_clienti.id_cliente
		AND riferimento_clienti.Id_riferimento = 1 
	LEFT JOIN Comune 
		ON comune.Id_comune = destinazione_cliente.Comune
	LEFT JOIN province 
		ON province.Sigla = destinazione_cliente.Provincia
	LEFT JOIN Frazione 
		ON Frazione.Id_frazione = destinazione_cliente.Frazione
WHERE clienti.Insolvente = 1
GROUP BY Clienti.Id_Cliente
ORDER BY Ragione_sociale; 

DROP VIEW IF EXISTS vw_ReportGroupProducts; 
CREATE VIEW  vw_ReportGroupProducts
AS 
SELECT
	resoconto_rapporto.id_resoconto, 
	resoconto_rapporto.anno_reso, 
	rapporto_materiale.Id_rapporto,
	rapporto_materiale.anno, 
	rapporto_materiale.Id_materiale, 
	rapporto_materiale.descrizione, 
	rapporto_materiale.`quantità`,
	rapporto_materiale.Prezzo, 
	rapporto_materiale.Costo, 
	rapporto_materiale.Sconto, 
	rapporto_materiale.id_magazzino, 
	rapporto_materiale.id_tab, 
	rapporto_materiale.tipo, 
	rapporto_materiale.qeconomia,
	IFNULL(articolo.`unità_misura`, "--") unita_misura
FROM resoconto
	INNER JOIN resoconto_rapporto 
		ON resoconto.id_resoconto = resoconto_rapporto.id_resoconto
		AND resoconto.Anno = resoconto_rapporto.anno_reso
	INNER JOIN rapporto_materiale 
		ON resoconto_rapporto.id_rapporto = rapporto_materiale.Id_rapporto
		AND resoconto_rapporto.anno = rapporto_materiale.anno
	LEFT JOIN articolo
		ON articolo.Codice_articolo = rapporto_materiale.Id_materiale;
		


DROP VIEW IF EXISTS subvw_productsunionsearch;
CREATE VIEW `subvw_productsunionsearch` AS
SELECT 
	`articolo`.`Codice_articolo` AS `codice_articolo`,
	`articolo`.`Codice_fornitore` AS `codice_fornitore`,
	`articolo`.`Barcode` AS `barcode`,
	'' AS `codice`,
	`articolo`.`Desc_brev` AS `desc_brev`,
	`articolo`.`unità_misura` AS `unità_misura`,
	`articolo_stato`.`colore` AS `colore`,
	`articolo`.`Desc_brev` AS `Descrizione`,
	`articolo`.`Categoria` AS `Categoria`,
	`articolo`.`Sottocategoria` AS `Sottocategoria`,
	`articolo_stato`.`colore` AS `stato_articolo`,
	`marca`.`Nome` AS `marca`,
	`articolo`.`Tempo_installazione` AS `tempo_installazione`,
	`articolo_stato`.`bloccato` AS `bloccato`,
	`articolo`.`is_kit` AS `is_kit`
FROM `articolo`
	LEFT JOIN `marca` ON `marca`.`Id_marca` = `articolo`.`Marca`
	INNER JOIN `articolo_stato` ON `articolo_stato`.`Id_stato` = `articolo`.`Stato_articolo`
UNION ALL
SELECT 
	`articolo`.`Codice_articolo` AS `codice_articolo`,
	`articolo_codice`.`codice` AS `codice_fornitore`,
	`articolo`.`Barcode` AS `barcode`,
	`articolo_codice`.`codice` AS `codice`,
	`articolo`.`Desc_brev` AS `desc_brev`,
	`articolo`.`unità_misura` AS `unità_misura`,
	`articolo_stato`.`colore` AS `colore`,
	`articolo`.`Desc_brev` AS `Descrizione`,
	`articolo`.`Categoria` AS `Categoria`,
	`articolo`.`Sottocategoria` AS `Sottocategoria`,
	`articolo_stato`.`colore` AS `stato_articolo`,
	`marca`.`Nome` AS `marca`,
	`articolo`.`Tempo_installazione` AS `tempo_installazione`,
	`articolo_stato`.`bloccato` AS `bloccato`,
	`articolo`.`is_kit` AS `is_kit`
FROM `articolo`
	INNER JOIN `articolo_codice` ON `articolo`.`Codice_articolo` = `articolo_codice`.`id_articolo`
	LEFT JOIN `marca` ON `marca`.`Id_marca` = `articolo`.`Marca`
	INNER JOIN `articolo_stato` ON `articolo_stato`.`Id_stato` = `articolo`.`Stato_articolo`;



DROP VIEW IF EXISTS vw_productssearch;
CREATE VIEW `vw_productssearch` AS
	SELECT `codice_articolo` AS `Codice_articolo`,
		IFNULL(`codice_fornitore`, '') AS `Codice_fornitore`, 
		IFNULL(`barcode`, '') AS `Barcode`,
		`desc_brev` AS `Descrizione`,
		`Categoria` AS `Categoria`,
		`Sottocategoria` AS `Sottocategoria`,
		`unità_misura` AS `UM`,
		`colore` AS `Stato_articolo`, 
		IFNULL(`marca`, '') AS `Marca`,
		IFNULL(`costo`.`Prezzo`, 0) AS `Costo`,
		IFNULL(`prezzo`.`Prezzo`, 0) AS `Prezzo`,
		`tempo_installazione` AS `Tempo_installazione`,
		`bloccato` AS `bloccato`,
		`is_kit` AS `Is_kit`
	FROM `subvw_productsunionsearch`
		LEFT JOIN `articolo_listino` `prezzo` ON
			`prezzo`.`Id_articolo` = `subvw_productsunionsearch`.`codice_articolo` AND `prezzo`.`Id_listino` = 2
		LEFT JOIN `articolo_listino` `costo` ON
			`costo`.`Id_listino` = 1 AND `costo`.`Id_articolo` = `subvw_productsunionsearch`.`codice_articolo`
	GROUP BY `subvw_productsunionsearch`.`codice_articolo`,`subvw_productsunionsearch`.`codice_fornitore`;


-- 
-- Table structure for table vw_dashboardgridsystemperiodicmonitoring
-- 

DROP VIEW IF EXISTS vw_dashboardgridsystemperiodicmonitoring;
CREATE VIEW `vw_dashboardgridsystemperiodicmonitoring` AS select `impianto_abbonamenti_mesi`.`impianto` AS `id`,`impianto_abbonamenti_mesi`.`mese` AS `id_mese`,`impianto_abbonamenti_mesi`.`anno` AS `anno`,`impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Descrizione` AS `descrizione`,`clienti`.`Ragione_Sociale` AS `cliente`,if(isnull(`impianto_abbonamenti_mesi`.`Eseguito_il`),0,1) AS `svolto`,1 AS `tipo`,ifnull(`impianto_abbonamenti_mesi`.`Eseguito_il`,`impianto_abbonamenti_mesi`.`da_eseguire`) AS `da_eseguire` from ((`impianto_abbonamenti_mesi` join `impianto` on((`impianto_abbonamenti_mesi`.`impianto` = `impianto`.`Id_impianto`))) join `clienti` on((`impianto`.`Id_cliente` = `clienti`.`Id_cliente`))) where (`impianto_abbonamenti_mesi`.`da_eseguire` between (now() - interval 6 month) and (now() + interval 6 month)) union select distinct NULL AS `Id`,`mese`.`Id_mese` AS `Id_mese`,`impianto_abbonamenti_mesi`.`anno` AS `anno`,NULL AS `Id_impianto`,concat(`mese`.`Nome`,' ',`impianto_abbonamenti_mesi`.`anno`) AS `descrizione`,NULL AS `cliente`,0 AS `Svolto`,0 AS `Tipo`,NULL AS `da_eseguire` from (`impianto_abbonamenti_mesi` join `mese` on((`mese`.`Id_mese` = `impianto_abbonamenti_mesi`.`mese`))) where (`impianto_abbonamenti_mesi`.`da_eseguire` between (now() - interval 6 month) and (now() + interval 6 month)) order by `anno`,`id_mese`,`tipo`,`cliente`;

-- 
-- Table structure for table vw_dashboardgridsystemreminder
-- 

DROP VIEW IF EXISTS vw_dashboardgridsystemreminder;
CREATE VIEW `vw_dashboardgridsystemreminder` AS 
	SELECT 
		`impianto_mesi`.`Id_impianto` AS `id`,
		`impianto_mesi`.`Id_mese` AS `id_mese`,
		0 AS `anno`,`impianto`.
		`Id_impianto` AS `id_impianto`,
		`impianto`.`Descrizione` AS `descrizione`,
		`clienti`.`Ragione_Sociale` AS `cliente`,
		0 AS `svolto`,1 AS `tipo`,
		NULL AS `da_eseguire` 
	FROM impianto_mesi 
		JOIN impianto
			ON `impianto_mesi`.`Id_impianto` = `impianto`.`Id_impianto` 
		JOIN clienti 
			ON impianto.`Id_cliente` = clienti.`Id_cliente`
	WHERE ((`impianto`.`Stato` = 0) AND (`impianto_mesi`.`Id_mese` = MONTH(NOW()))) 
	ORDER BY `impianto_mesi`.`Id_mese`,1,`clienti`.`Ragione_Sociale`;

   

-- 
-- Table structure for table subvw_jobbodyproductswithreportsonlyeconomy
-- 

DROP VIEW IF EXISTS subvw_jobbodyproductswithreportsonlyeconomy;
	
-- 
-- Table structure for table subvw_jobbodyproductswithreportswithouteconomy
-- 

DROP VIEW IF EXISTS subvw_jobbodyproductswithreportswithouteconomy;

-- 
-- Table structure for table vw_jobbodynoteswithamount
-- 

DROP VIEW IF EXISTS vw_jobbodynoteswithamount;
-- 
-- Table structure for table vw_jobbodyproducts
-- 

DROP VIEW IF EXISTS vw_jobbodyproducts;
-- 
-- Table structure for table vw_jobbodyproductswithreports
-- 
DROP VIEW IF EXISTS vw_jobbodyproductswithreports;

-- 
-- Table structure for table vw_jobbodywithreports
-- 

DROP VIEW IF EXISTS vw_jobbodywithreports;


-- 
-- Table structure for table vw_jobtotaltravelinterventions
-- 

DROP VIEW IF EXISTS vw_jobtotaltravelinterventions;
CREATE VIEW `vw_jobtotaltravelinterventions` AS 
SELECT `cr`.`id_commessa` AS `id_commessa`,
	`cr`.`anno_commessa` AS `anno_commessa`,
	`cr`.`id_sottocommessa` AS `id_sottocommessa`,
	`cr`.`id_lotto` AS `id_lotto`,
	cast(sum(`rt`.`Spesa_trasferta`) as decimal(11,2)) AS `Totale_spese_trasferta`,
	cast(sum(`rt`.`autostrada`) as decimal(11,2)) AS `Totale_autostrada`,
	cast(sum(`rt`.`parcheggio`) as decimal(11,2)) AS `Totale_parcheggio`,
	cast(sum(`rt`.`altro`) as decimal(11,2)) AS `Totale_altro`,
	cast(if(isnull(sum(`rt`.`Km`)),0,sum(`rt`.`Km`)) as unsigned) AS `Totale_KM`,
	cast(if(isnull(sum((`rt`.`Km` * `t`.`costo_km`))),0,sum((`rt`.`Km` * `t`.`costo_km`))) as decimal(11,2)) AS `Totale_costo_KM`,
	cast(if(isnull(sum((`rt`.`Km` * `a`.`Prezzo_strada`))),0,sum((`rt`.`Km` * `a`.`Prezzo_strada`))) as decimal(11,2)) AS `Totale_prezzo_KM`,
	cast(sum((`rt`.`Tempo_viaggio` / 60)) as decimal(11,2)) AS `Totale_tempo_viaggio`,
	cast(if(isnull(sum(((`rt`.`Tempo_viaggio` / 60) * `t`.`Costo_h`))),0,sum(((`rt`.`Tempo_viaggio` / 60) * `t`.`Costo_h`))) as decimal(11,2)) AS `Totale_costo_tempo_viaggio`,
	cast(if(isnull(sum(((`rt`.`Tempo_viaggio` / 60) * `a`.`Ora_normale`))),0,sum(((`rt`.`Tempo_viaggio` / 60) * `a`.`Ora_normale`))) as decimal(11,2)) AS `Totale_prezzo_tempo_viaggio` 
FROM `rapporto_tecnico` `rt`
	JOIN `commessa_rapporto` `cr` ON `cr`.`id_rapporto` = `rt`.`Id_rapporto`
		AND `rt`.`Anno` = `cr`.`anno_rapporto`
	LEFT JOIN `operaio_contratto` `oc` ON `oc`.`id_operaio` = `rt`.`Tecnico`
	LEFT JOIN `tariffario` `t` ON `t`.`Id_tariffario` = `oc`.`id_tariffario`
	JOIN `rapporto` `r` ON `r`.`Id_rapporto` = `rt`.`Id_rapporto`
		AND`r`.`Anno` = `rt`.`Anno`
	LEFT JOIN`abbonamento` `a` ON `r`.`abbonamento` = `a`.`Id_abbonamento`
GROUP BY `cr`.`id_commessa`,`cr`.`anno_commessa`,cr.id_sottocommessa,`cr`.`id_lotto`;

-- 
-- Table structure for table vw_jobtotalworkinterventions
-- 

DROP VIEW IF EXISTS vw_jobtotalworkinterventions;
CREATE VIEW `vw_jobtotalworkinterventions` AS 
	SELECT `cr`.`id_commessa` AS `id_commessa`,
		`cr`.`anno_commessa` AS `anno_commessa`,
		`cr`.`id_sottocommessa` AS `id_sottocommessa`,
		`cr`.`id_lotto` AS `id_lotto`,
		CAST(
			IFNULL(SUM((`r`.`totale` / 60) * `r`.`ora_normale`), 0) AS DECIMAL(11,2)
		) AS `Totale_prezzo_lavoro`,
		CAST(
			IFNULL(SUM((`r`.`totale` / 60) * 
				IF((`r`.`straordinario` = 1) or (`r`.`straordinario` = 4), Straordinario_c, `t`.`Costo_h`)
			), 0) AS DECIMAL(11,2)
		) AS `Totale_costo_lavoro`,
		cast(sum((`r`.`totale` / 60)) as decimal(11,2)) AS `Totale_ore_lavorate`,if(((`r`.`straordinario` = 3) or (`r`.`straordinario` = 4)),1,0) AS `Economia`,
		IF(((`r`.`straordinario` = 1) or (`r`.`straordinario` = 4)),1,0) AS `Straordinario` 
	FROM `rapporto_tecnico_lavoro` `r`
		JOIN `commessa_rapporto` `cr` ON `cr`.`id_rapporto` = `r`.`Id_rapporto`
			AND `r`.`anno` = `cr`.`anno_rapporto`
		LEFT JOIN `operaio_contratto` `oc` ON `oc`.`id_operaio` = `r`.`tecnico`
		LEFT JOIN `tariffario` `t` ON `t`.`Id_tariffario` = `oc`.`id_tariffario`
	GROUP BY `cr`.`id_commessa`,`cr`.`anno_commessa`,cr.id_sottocommessa,`cr`.`id_lotto`,`r`.`straordinario`;
-- 
-- Table structure for table vw_mapsmarkersinformation
-- 

DROP VIEW IF EXISTS vw_mapsmarkersinformation;
CREATE VIEW  `vw_mapsmarkersinformation` AS select `impianto`.`Id_impianto` AS `Id_Impianto`,`ticket`.`Id_cliente` AS `Id_Cliente`,`clienti`.`Ragione_Sociale` AS `Ragione_Sociale`,concat(`destinazione_cliente`.`Indirizzo`,',',`destinazione_cliente`.`numero_civico`) AS `Indirizzo`,concat(`comune`.`cap`,' - ',`comune`.`Nome`,'(',`destinazione_cliente`.`Provincia`,')') AS `Provincia`,`impianto`.`Descrizione` AS `Impianto_Descrizione`,if((`impianto`.`Stato` = 1),1,0) AS `Abbonato`,if((`impianto`.`stato_invio_doc` = 'clblue'),0,if((`impianto`.`stato_invio_doc` = 'clYellow'),1,2)) AS `Stato_invio_richiesta_abbonamento`,max(`ticket`.`data_ticket`) AS `Data_Ticket`,max(`ticket`.`Urgenza`) AS `Urgenza`,`ticket`.`Descrizione` AS `Ticket_Descrizione`,`riferimento_clienti`.`Telefono` AS `Telefono`,`riferimento_clienti`.`altro_telefono` AS `Cellulare`,`riferimento_clienti`.`mail` AS `Mail`,cast(replace(`destinazione_cliente`.`latitudine`,',','.') as decimal(21,16)) AS `Latitudine`,cast(replace(`destinazione_cliente`.`longitudine`,',','.') as decimal(21,16)) AS `Longitudine` from (((((((`ticket` join `clienti` on((`clienti`.`Id_cliente` = `ticket`.`Id_cliente`))) left join `causale_ticket` on((`causale_ticket`.`Id_causale` = `ticket`.`Causale`))) left join `tipo_intervento` on((`tipo_intervento`.`Id_tipo` = `ticket`.`intervento`))) join `riferimento_clienti` on((`clienti`.`Id_cliente` = `riferimento_clienti`.`Id_cliente`))) left join `impianto` on((`impianto`.`Id_impianto` = `ticket`.`Id_impianto`))) join `destinazione_cliente` on(((`clienti`.`Id_cliente` = `destinazione_cliente`.`id_cliente`) and (`impianto`.`Destinazione` = `destinazione_cliente`.`Id_destinazione`)))) join `comune` on((`comune`.`Id_comune` = `destinazione_cliente`.`Comune`))) where ((`ticket`.`Stato_ticket` = 1) and (`destinazione_cliente`.`latitudine` <> '') and (`destinazione_cliente`.`longitudine` <> '') and (`destinazione_cliente`.`latitudine` is not null) and (`destinazione_cliente`.`longitudine` is not null)) group by `impianto`.`Id_impianto` order by `impianto`.`Id_impianto`;

-- 
-- Table structure for table vw_mobilesystems
-- 

DROP VIEW IF EXISTS vw_mobilesystems;
CREATE VIEW `vw_mobilesystems` AS select `impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Id_cliente` AS `id_cliente`,`impianto`.`Id_gestore` AS `id_gestore`,`impianto`.`Id_occupante` AS `id_occupante`,ifnull(`impianto`.`Abbonamento`,0) AS `abbonamento`,ifnull(`impianto`.`Data_Funzione`,cast('0000-00-00 00:00:00' as datetime)) AS `data_funzione`,ifnull(`impianto`.`scadenza_garanzia`,cast('0000-00-00 00:00:00' as datetime)) AS `Scadenza_Garanzia`,`impianto`.`Tipo_impianto` AS `tipo_impianto`,`impianto`.`Stato` AS `stato`,`impianto`.`Descrizione` AS `descrizione`,ifnull(if((`d1`.`Id_destinazione` <> `d2`.`Id_destinazione`),concat(concat(`d2`.`Indirizzo`,' n.',`d2`.`numero_civico`,`d2`.`Altro`),' - ',concat(if(((`f2`.`Nome` is not null) and (`f2`.`Nome` <> '')),concat(`f2`.`Nome`,' di '),''),`c2`.`Nome`,' (',`c2`.`provincia`,')'),' - ',`impianto`.`Descrizione`),''),'') AS `luogo`,ifnull(concat(`d1`.`Indirizzo`,' n.',`d1`.`numero_civico`,`d1`.`Altro`),'') AS `indirizzo`,concat(if(((`frazione`.`Nome` is not null) and (`frazione`.`Nome` <> '')),concat(`frazione`.`Nome`,' di '),''),`comune`.`Nome`,' (',`comune`.`provincia`,')') AS `citta`,ifnull(`r1`.`mail`,'') AS `mail`,ifnull(`r1`.`Telefono`,'') AS `telefono`,ifnull(`r1`.`altro_telefono`,'') AS `cellulare`,`tipo_impianto`.`nome` AS `tipo_impianto_nome`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`,ifnull(`clienti`.`Partita_iva`,'') AS `partita_iva`,ifnull(`clienti`.`Codice_Fiscale`,'') AS `codice_fiscale`,ifnull(`impianto`.`centrale`,'') AS `centrale`,ifnull(`impianto`.`gsm`,'') AS `gsm`,ifnull(`impianto`.`combinatore_telefonico`,'') AS `combinatore_telefonico`,`impianto`.`orario_prog` AS `orario_prog` from (((((((((`impianto` join `clienti` on((`clienti`.`Id_cliente` = `impianto`.`Id_cliente`))) join `destinazione_cliente` `d1` on(((`d1`.`id_cliente` = `clienti`.`Id_cliente`) and (`d1`.`Id_destinazione` = 1)))) join `comune` on((`comune`.`Id_comune` = `d1`.`Comune`))) left join `frazione` on((`frazione`.`Id_frazione` = `d1`.`Frazione`))) left join `tipo_impianto` on((`tipo_impianto`.`id_tipo` = `impianto`.`Tipo_impianto`))) left join `destinazione_cliente` `d2` on(((`d2`.`id_cliente` = `clienti`.`Id_cliente`) and (`d2`.`Id_destinazione` = `impianto`.`Destinazione`)))) join `comune` `c2` on((`c2`.`Id_comune` = `d2`.`Comune`))) left join `frazione` `f2` on((`f2`.`Id_frazione` = `d2`.`Frazione`))) left join `riferimento_clienti` `r1` on(((`r1`.`Id_cliente` = `clienti`.`Id_cliente`) and (`r1`.`Id_riferimento` = '1')))) where ((`impianto`.`Stato` < 4) or (`impianto`.`Stato` > 7)) group by `impianto`.`Id_impianto`;

-- 
-- Table structure for table vw_mobileticketsopened
-- 

DROP VIEW IF EXISTS vw_mobileticketsopened;
CREATE VIEW `vw_mobileticketsopened` AS select `ticket`.`Id_ticket` AS `id_ticket`,`ticket`.`anno` AS `anno`,`destinazione_cliente`.`Indirizzo` AS `indirizzo`,ifnull(`destinazione_cliente`.`numero_civico`,0) AS `numero_civico`,ifnull(`destinazione_cliente`.`Altro`,'') AS `altro`,ifnull(`frazione`.`Nome`,'') AS `frazione`,`comune`.`Nome` AS `comune`,`comune`.`provincia` AS `provincia`,ifnull(`riferimento_clienti`.`Telefono`,'') AS `telefono`,ifnull(`riferimento_clienti`.`altro_telefono`,'') AS `cellulare`,`ticket`.`Urgenza` AS `urgenza`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`,`impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Descrizione` AS `impianto_descrizione`,`clienti`.`Id_cliente` AS `id_cliente`,`ticket`.`Descrizione` AS `ticket_descrizione` from ((((((`ticket` join `clienti` on((`clienti`.`Id_cliente` = `ticket`.`Id_cliente`))) join `destinazione_cliente` on(((`destinazione_cliente`.`id_cliente` = `clienti`.`Id_cliente`) and (`destinazione_cliente`.`Id_destinazione` = `ticket`.`Id_destinazione`)))) left join `comune` on((`comune`.`Id_comune` = `destinazione_cliente`.`Comune`))) left join `frazione` on((`destinazione_cliente`.`Frazione` = `frazione`.`Id_frazione`))) left join `impianto` on((`impianto`.`Id_impianto` = `ticket`.`Id_impianto`))) left join `riferimento_clienti` on(((`riferimento_clienti`.`Id_cliente` = `clienti`.`Id_cliente`) and (`riferimento_clienti`.`Id_riferimento` = 1)))) where ((`ticket`.`Stato_ticket` = '1') and (`impianto`.`Id_impianto` is not null));

-- 
-- Table structure for table vw_reportgroupproducts
-- 

DROP VIEW IF EXISTS vw_reportgroupproducts;
CREATE VIEW `vw_reportgroupproducts` AS select `resoconto_rapporto`.`id_resoconto` AS `id_resoconto`,`resoconto_rapporto`.`anno_reso` AS `anno_reso`,`rapporto_materiale`.`Id_rapporto` AS `Id_rapporto`,`rapporto_materiale`.`anno` AS `anno`,`rapporto_materiale`.`Id_materiale` AS `Id_materiale`,`rapporto_materiale`.`descrizione` AS `descrizione`,`rapporto_materiale`.`quantità` AS `quantità`,`rapporto_materiale`.`Prezzo` AS `Prezzo`,`rapporto_materiale`.`costo` AS `Costo`,`rapporto_materiale`.`sconto` AS `Sconto`,`rapporto_materiale`.`id_magazzino` AS `id_magazzino`,`rapporto_materiale`.`id_tab` AS `id_tab`,`rapporto_materiale`.`tipo` AS `tipo`,`rapporto_materiale`.`qeconomia` AS `qeconomia`,ifnull(`articolo`.`unità_misura`,'--') AS `unita_misura` from (((`resoconto` join `resoconto_rapporto` on(((`resoconto`.`id_resoconto` = `resoconto_rapporto`.`id_resoconto`) and (`resoconto`.`anno` = `resoconto_rapporto`.`anno_reso`)))) join `rapporto_materiale` on(((`resoconto_rapporto`.`id_rapporto` = `rapporto_materiale`.`Id_rapporto`) and (`resoconto_rapporto`.`anno` = `rapporto_materiale`.`anno`)))) left join `articolo` on((`articolo`.`Codice_articolo` = `rapporto_materiale`.`Id_materiale`)));

-- 
-- Table structure for table vw_systemperiodicmonitoringremindergridmain
-- 

DROP VIEW IF EXISTS vw_systemperiodicmonitoringremindergridmain;
CREATE VIEW `vw_systemperiodicmonitoringremindergridmain` AS select `impianto_abbonamenti_mesi`.`id` AS `Id`,`impianto_abbonamenti_mesi`.`mese` AS `id_mese`,`impianto_abbonamenti_mesi`.`anno` AS `anno`,`impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Descrizione` AS `descrizione_impianto`,`clienti`.`Id_cliente` AS `Id_cliente`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`,if(isnull(`impianto_abbonamenti_mesi`.`Eseguito_il`),0,1) AS `svolto`,ifnull(`impianto_abbonamenti_mesi`.`Eseguito_il`,`impianto_abbonamenti_mesi`.`da_eseguire`) AS `da_eseguire`,`tipo_impianto`.`nome` AS `Tipo_impianto`,ifnull((`impianto`.`Tempo_manutenzione` / 60),0) AS `tempo_manutenzione` from (((`impianto_abbonamenti_mesi` join `impianto` on((`impianto_abbonamenti_mesi`.`impianto` = `impianto`.`Id_impianto`))) join `clienti` on((`impianto`.`Id_cliente` = `clienti`.`Id_cliente`))) join `tipo_impianto` on((`impianto`.`Tipo_impianto` = `tipo_impianto`.`id_tipo`))) order by ifnull(`impianto_abbonamenti_mesi`.`Eseguito_il`,`impianto_abbonamenti_mesi`.`da_eseguire`);

-- 
-- Table structure for table vw_systemperiodicmonitoringremindergridmainelementtypeone
-- 

DROP VIEW IF EXISTS vw_systemperiodicmonitoringremindergridmainelementtypeone;
CREATE VIEW `vw_systemperiodicmonitoringremindergridmainelementtypeone` AS select 0 AS `Id`,`impianto_mesi`.`Id_mese` AS `id_mese`,0 AS `anno`,`impianto_mesi`.`Id_impianto` AS `id_impianto`,`impianto`.`Descrizione` AS `descrizione_impianto`,`clienti`.`Id_cliente` AS `Id_cliente`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`,0 AS `svolto`,NULL AS `da_eseguire`,`tipo_impianto`.`nome` AS `Tipo_impianto`,0 AS `tempo_manutenzione` from (((`impianto_mesi` join `impianto` on((`impianto_mesi`.`Id_impianto` = `impianto`.`Id_impianto`))) join `clienti` on((`impianto`.`Id_cliente` = `clienti`.`Id_cliente`))) join `tipo_impianto` on((`impianto`.`Tipo_impianto` = `tipo_impianto`.`id_tipo`))) where (`impianto`.`Stato` = 0) order by `impianto_mesi`.`Id_mese`,`clienti`.`Ragione_Sociale`;

-- 
-- Table structure for table vw_systemperiodicmonitoringremindergridmainelementtypezero
-- 

DROP VIEW IF EXISTS vw_systemperiodicmonitoringremindergridmainelementtypezero;
CREATE  VIEW `vw_systemperiodicmonitoringremindergridmainelementtypezero` AS select `impianto_abbonamenti_mesi`.`id` AS `Id`,`impianto_abbonamenti_mesi`.`mese` AS `id_mese`,`impianto_abbonamenti_mesi`.`anno` AS `anno`,`impianto`.`Id_impianto` AS `id_impianto`,`impianto`.`Descrizione` AS `descrizione_impianto`,`clienti`.`Id_cliente` AS `Id_cliente`,`clienti`.`Ragione_Sociale` AS `ragione_sociale`,if(isnull(`impianto_abbonamenti_mesi`.`Eseguito_il`),0,1) AS `svolto`,ifnull(`impianto_abbonamenti_mesi`.`Eseguito_il`,`impianto_abbonamenti_mesi`.`da_eseguire`) AS `da_eseguire`,`tipo_impianto`.`nome` AS `Tipo_impianto`,ifnull((`impianto`.`Tempo_manutenzione` / 60),0) AS `tempo_manutenzione` from (((`impianto_abbonamenti_mesi` join `impianto` on((`impianto_abbonamenti_mesi`.`impianto` = `impianto`.`Id_impianto`))) join `clienti` on((`impianto`.`Id_cliente` = `clienti`.`Id_cliente`))) join `tipo_impianto` on((`impianto`.`Tipo_impianto` = `tipo_impianto`.`id_tipo`))) order by ifnull(`impianto_abbonamenti_mesi`.`Eseguito_il`,`impianto_abbonamenti_mesi`.`da_eseguire`);


		
		
		
-- 
-- Table structure for table vw_jobbody
-- 

DROP VIEW IF EXISTS vw_jobbody;
CREATE VIEW `vw_jobbody` AS 
	SELECT  
		`ca`.`id_commessa` AS `Id_commessa`,
		`ca`.`anno` AS `Anno`,
		ca.id_sottocommessa,
		`ca`.`id_lotto` AS `Lotto`,
		`ca`.`codice_articolo` AS `Codice_articolo`,
		`ca`.`codice_fornitore` AS `Codice_fornitore`,
		`ca`.`descrizione` AS `Descrizione`,
		IF(ca.codice_articolo IS NULL, ca.`quantità`, ca.portati) AS `Qta_utilizzata`,
		CAST(`ca`.`quantità` as decimal(11,2)) AS `Qta_commessa`,
		CAST(`ca`.`preventivati` as decimal(11,2)) AS `Qta_preventivati`,
		`ca`.`UM` AS `UM`,
		CAST(`ca`.`prezzo` as decimal(11,2)) AS `Prezzo`,
		CAST(`ca`.`costo` as decimal(11,2)) AS `Costo`,
		CAST(`ca`.`prezzo_ora` as decimal(11,2)) AS `Prezzo_ora`,
		CAST(`ca`.`costo_ora` as decimal(11,2)) AS `Costo_ora`,
		CAST(`ca`.`sconto` as decimal(11,2)) AS `Sconto`,
		`ca`.`tempo` AS `Tempo_Installazione`,
		ca.economia AS `Qta_economia`,
		CAST(`ca`.`id_tab` as signed) AS `Posizionamento` 
	FROM commessa_articoli as ca
;


		
-- 
-- Table structure for table vw_jobbodywwithkit
-- 

DROP VIEW IF EXISTS vw_jobbodywwithkit;
CREATE VIEW `vw_jobbodywwithkit` AS
		SELECT  
			`ca`.`id_commessa` AS `Id_commessa`,
			`ca`.`anno` AS `Anno`,
			ca.id_sottocommessa,
			`ca`.`id_lotto` AS `Lotto`,
			`ca`.`codice_articolo` AS `Codice_articolo`,
			`ca`.`codice_fornitore` AS `Codice_fornitore`,
			`ca`.`descrizione` AS `Descrizione`,
			ca.portati AS `Qta_utilizzata`,
			CAST(`ca`.`quantità` as decimal(11,2)) AS `Qta_commessa`,
			CAST(`ca`.`preventivati` as decimal(11,2)) AS `Qta_preventivati`,
			`ca`.`UM` AS `UM`,
			CAST(`ca`.`prezzo` as decimal(11,2)) AS `Prezzo`,
			CAST(`ca`.`costo` as decimal(11,2)) AS `Costo`,
			CAST(`ca`.`prezzo_ora` as decimal(11,2)) AS `Prezzo_ora`,
			CAST(`ca`.`costo_ora` as decimal(11,2)) AS `Costo_ora`,
			CAST(`ca`.`sconto` as decimal(11,2)) AS `Sconto`,
			`ca`.`tempo` AS `Tempo_Installazione`,
			ca.economia AS `Qta_economia`,
			CAST(`ca`.`id_tab` as signed) AS `Posizionamento`,
			IFNULL(articolo.is_kit, 0) AS `is_kit`
		FROM commessa_articoli as ca
			LEFT JOIN articolo ON articolo.codice_articolo=ca.codice_articolo
		UNION ALL
		SELECT `ca`.`id_commessa` AS `Id_commessa`,
			`ca`.`anno` AS `Anno`,
			ca.id_sottocommessa,
			`ca`.`id_lotto` AS `Lotto`,
			`articolo`.`codice_articolo` AS `Codice_articolo`,
			`articolo`.`codice_fornitore` AS `Codice_fornitore`,
			`articolo`.`desc_brev` AS `Descrizione`,
			CAST(ca.portati * rka.quantita as decimal(11,2)) AS `Qta_utilizzata`,
			CAST(ca.quantità * rka.quantita as decimal(11,2)) AS `Qta_commessa`,
			CAST(ca.preventivati * rka.quantita as decimal(11,2)) AS `Qta_preventivati`,
			`ca`.`UM` AS `UM`,
			CAST(`ca`.`prezzo` as decimal(11,2)) AS `Prezzo`,
			CAST(`ca`.`costo` as decimal(11,2)) AS `Costo`,
			CAST(`ca`.`prezzo_ora` as decimal(11,2)) AS `Prezzo_ora`,
			CAST(`ca`.`costo_ora` as decimal(11,2)) AS `Costo_ora`,
			CAST(`ca`.`sconto` as decimal(11,2)) AS `Sconto`,
			`ca`.`tempo` AS `Tempo_Installazione`,
			CAST(ca.economia * rka.quantita as decimal(11,2)) AS `Qta_economia`,
			CAST(`ca`.`id_tab` as signed) AS `Posizionamento`,
			2 AS `is_kit` -- necessary yo order by
		FROM commessa_articoli as ca
			INNER JOIN riferimento_kit_articoli AS rka ON id_kit = ca.codice_articolo
			LEFT JOIN articolo ON articolo.codice_articolo=rka.id_articolo
;


DROP VIEW IF EXISTS vw_depotsOperationsNotOrdered;
CREATE VIEW `vw_depotsOperationsNotOrdered` AS
	-- Inserimento manuale
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		data as 'data_ins',
		data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT("Inserimento manuale effettuato il ", data) AS "Causale", 
		NULL AS "documento", 
		NULL AS "ragione_sociale",
		NULL AS "id_doc", 
		NULL AS "anno_doc",
		sorgente
	FROM magazzino_operazione
			INNER JOIN causale_magazzino ON causale = id_causale
			INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
	WHERE sorgente = 1
	
	-- RAPPORTO
	UNION ALL
	SELECT
		magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		rapporto.data_esecuzione AS 'data_operazione',
			quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Rapporto ", magazzino_rapporto_materiale.Id_rapporto,"/", magazzino_rapporto_materiale.anno_rapporto) AS "Causale",
			"RAPPORTO" AS "documento", 
			IF(rapporto.Id_cliente IS NOT NULL, clienti.ragione_sociale,"") AS "ragione_sociale",
			magazzino_rapporto_materiale.Id_rapporto AS "id_doc",
			magazzino_rapporto_materiale.anno_rapporto AS "anno_doc",
		sorgente
		FROM magazzino_operazione
			INNER JOIN causale_magazzino ON causale = id_causale
			INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
			INNER JOIN magazzino_rapporto_materiale
			ON magazzino_rapporto_materiale.id_operazione = magazzino_operazione.id_operazione
			INNER JOIN rapporto 
			ON magazzino_rapporto_materiale.Id_rapporto = rapporto.id_rapporto AND magazzino_rapporto_materiale.anno_rapporto = rapporto.anno
			INNER JOIN clienti ON rapporto.Id_cliente = clienti.id_cliente
	WHERE sorgente = 2
	
	-- DDT EMESSO
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID", 
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		data as 'data_ins',
		ddt.data_documento AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da Ddt emesso ", magazzino_ddt_emessi.id_ddt,"/", magazzino_ddt_emessi.anno_ddt) AS "Causale",
		"DDT EMESSO" AS "documento",
		IFNULL(clienti.ragione_sociale, fornitore.ragione_sociale) AS "ragione_sociale",
		magazzino_ddt_emessi.id_ddt AS "id_doc",
		magazzino_ddt_emessi.anno_ddt AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_ddt_emessi ON magazzino_ddt_emessi.id_operazione = magazzino_operazione.id_operazione
		INNER JOIN ddt ON magazzino_ddt_emessi.id_ddt = ddt.id_ddt
		AND magazzino_ddt_emessi.anno_ddt = ddt.anno
		LEFT JOIN clienti ON ddt.id_cliente = clienti.id_cliente
		LEFT JOIN fornitore ON ddt.id_fornitore = fornitore.id_fornitore
		WHERE magazzino_operazione.sorgente = 3

	-- DDT EMESSO RESO
	UNION ALL
		SELECT magazzino_operazione.id_operazione AS "ID", 
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		data as 'data_ins',
		ddt.data_documento AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da Ddt emesso ", magazzino_ddt_emessi.id_ddt,"/", magazzino_ddt_emessi.anno_ddt) AS "Causale",
		"DDT EMESSO" AS "documento",
		IFNULL(clienti.ragione_sociale, fornitore.ragione_sociale) AS "ragione_sociale",
		magazzino_ddt_emessi.id_ddt AS "id_doc",
		magazzino_ddt_emessi.anno_ddt AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_ddt_emessi ON (magazzino_ddt_emessi.id_reso IS NOT NULL AND magazzino_ddt_emessi.id_reso=magazzino_operazione.id_operazione)
		INNER JOIN ddt ON magazzino_ddt_emessi.id_ddt = ddt.id_ddt
		AND magazzino_ddt_emessi.anno_ddt = ddt.anno
		LEFT JOIN clienti ON ddt.id_cliente = clienti.id_cliente
		LEFT JOIN fornitore ON ddt.id_fornitore = fornitore.id_fornitore
		WHERE magazzino_operazione.sorgente = 3
	
	-- Trasferimento Magazzini
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		data as 'data_ins',
		data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT("Trasferimento tra magazzini effettuato il ", data) AS "Causale", 
		NULL AS "documento", 
		NULL AS "ragione_sociale",
		NULL AS "id_doc", 
		NULL AS "anno_doc",
		sorgente
	FROM magazzino_operazione
			INNER JOIN causale_magazzino ON causale = id_causale
			INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
	WHERE sorgente = 4
	
	-- Inserimento mobile
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		data as 'data_ins',
		data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT("Inserimento mobile effettuato il ", data) AS "Causale", 
		NULL AS "documento", 
		NULL AS "ragione_sociale",
		NULL AS "id_doc", 
		NULL AS "anno_doc",
		sorgente
	FROM magazzino_operazione
			INNER JOIN causale_magazzino ON causale = id_causale
			INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
	WHERE sorgente = 5
	
	-- FATTURA FORNITORE
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		fornfattura.data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Fattura Fornitore ", fattura_fornitore) AS "Causale",
		"FATTURA FORNITORE" AS "documento",
		fornitore.ragione_sociale AS "ragione_sociale",
		fornfattura.id_fattura AS "id_doc",
		fornfattura.anno AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_fornfattura ON magazzino_fornfattura.id_operazione = magazzino_operazione.id_operazione
		INNER JOIN fornfattura ON magazzino_fornfattura.id_fattura = fornfattura.id_fattura
			AND magazzino_fornfattura.anno = fornfattura.anno
		INNER JOIN fornitore ON fornfattura.id_fornitore = fornitore.id_fornitore
	WHERE sorgente = 6
	
	-- FATTURA CLIENTE	
	UNION ALL 
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		fattura.data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Fattura ", fattura.id_fattura,"/", fattura.anno) AS "Causale",
		"FATTURA" AS "documento", clienti.ragione_sociale AS "ragione_sociale",
		fattura.id_fattura AS "id_doc",
		fattura.anno AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_fattura ON magazzino_fattura.id_operazione = magazzino_operazione.id_operazione
		INNER JOIN fattura ON magazzino_fattura.id_fattura = fattura.id_fattura
			AND magazzino_fattura.anno = fattura.anno
		INNER JOIN clienti ON fattura.id_cliente = clienti.id_cliente
	WHERE sorgente = 7
			
	-- DDT RICEVUTI
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		ddt_ricevuti.data_documento AS 'data_operazione',
		quantità, 
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Ddt ricevuto ",ddt_ricevuti.numero_ddt,"/", id_anno) AS "Causale",
		"DDT RICEVUTO" AS "documento", 
		IF(ddt_ricevuti.id_fornitore IS NOT NULL, fornitore.ragione_sociale, clienti.ragione_sociale) AS "ragione_sociale",
		magazzino_ddt_ricevuti.id_ddt AS "id_doc",
		magazzino_ddt_ricevuti.id_anno AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_ddt_ricevuti ON magazzino_ddt_ricevuti.id_operazione = magazzino_operazione.id_operazione
		INNER JOIN ddt_ricevuti ON magazzino_ddt_ricevuti.id_ddt = ddt_ricevuti.id_ddt
			AND magazzino_ddt_ricevuti.id_anno = ddt_ricevuti.anno
		LEFT JOIN fornitore ON ddt_ricevuti.id_fornitore = fornitore.id_fornitore
		LEFT JOIN clienti ON ddt_ricevuti.id_cliente = clienti.id_cliente 
		WHERE magazzino_operazione.sorgente = 8
		
	-- DDT RICEVUTI RESO
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		ddt_ricevuti.data_documento AS 'data_operazione',
		quantità, 
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Ddt ricevuto ",ddt_ricevuti.numero_ddt,"/", id_anno) AS "Causale",
		"DDT RICEVUTO" AS "documento", 
		IF(ddt_ricevuti.id_fornitore IS NOT NULL, fornitore.ragione_sociale, clienti.ragione_sociale) AS "ragione_sociale",
		magazzino_ddt_ricevuti.id_ddt AS "id_doc",
		magazzino_ddt_ricevuti.id_anno AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_ddt_ricevuti ON 
			(magazzino_ddt_ricevuti.id_reso IS NOT NULL AND magazzino_ddt_ricevuti.id_reso = magazzino_operazione.id_operazione)
		INNER JOIN ddt_ricevuti ON magazzino_ddt_ricevuti.id_ddt = ddt_ricevuti.id_ddt
			AND magazzino_ddt_ricevuti.id_anno = ddt_ricevuti.anno
		LEFT JOIN fornitore ON ddt_ricevuti.id_fornitore = fornitore.id_fornitore
		LEFT JOIN clienti ON ddt_ricevuti.id_cliente = clienti.id_cliente 
		WHERE magazzino_operazione.sorgente = 8

	-- LIST PRELIEVO
	UNION ALL
	SELECT magazzino_operazione.id_operazione AS "ID",
		magazzino_operazione.articolo as 'codice_articolo',
		tipo_magazzino.id_tipo as 'id_magazzino',
		tipo_magazzino.nome as 'tipo_magazzino',
		magazzino_operazione.data as 'data_ins',
		lista_prelievo.data AS 'data_operazione',
		quantità,
		causale_magazzino.nome AS 'nome_causale',
		CONCAT(causale_magazzino.nome," da "," Lista di prelievo ", a.id_lista,"/", a.anno) AS "Causale",
		"PRELIEVO" AS "documento",
		IF(lista_prelievo.cliente IS NOT NULL, clienti.ragione_sociale,"") AS "ragione_sociale",
		a.id_lista AS "id_doc",
		a.anno AS "anno_doc",
		sorgente
	FROM magazzino_operazione
		INNER JOIN causale_magazzino ON causale = id_causale
		INNER JOIN tipo_magazzino ON id_tipo = id_magazzino
		INNER JOIN magazzino_liste AS a ON magazzino_operazione.id_operazione IN (a.id_operazione_del, a.id_operazione_ins) 
		INNER JOIN lista_prelievo ON a.id_lista = lista_prelievo.id_lista
		AND a.anno = lista_prelievo.anno
		LEFT JOIN clienti ON lista_prelievo.cliente = clienti.id_cliente
	WHERE sorgente = 9;

	
DROP VIEW IF EXISTS vw_depotsOperations;
CREATE VIEW `vw_depotsOperations` AS
	SELECT *
	FROM vw_depotsOperationsNotOrdered
	ORDER BY data_operazione DESC, ID DESC;

DROP VIEW IF EXISTS vw_contatsExport;
CREATE VIEW `vw_contatsExport` AS
 SELECT TRIM(cl.ragione_sociale) AS "ragione_sociale", 
   IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
   c.cap, 
   dc.provincia,
   IF(numero_civico IS NULL OR indirizzo = "", indirizzo,  CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,
   cl.data_inserimento,
   rc.nome, -- nome rif cliente
   sc.nome AS status, 
   rfg.figura,
   rc.telefono,
   rc.altro_telefono,
   rc.fax,
   rc.centralino,
   rc.mail,
   cl.id_cliente AS "id",
   IF(tipo_cliente = 6, 'customer_private', 'customer_company') AS record_type -- check if tipo cliente is PRIVATO
 FROM clienti cl 
   INNER JOIN riferimento_clienti rc ON cl.id_cliente = rc.id_cliente 
   LEFT JOIN destinazione_cliente dc ON dc.id_cliente = cl.id_cliente 
     AND id_destinazione = "1" 
   LEFT JOIN riferimento_figura rfg ON rfg.id_figura = rc.figura 
   LEFT JOIN comune c ON c.id_comune = dc.comune
   LEFT JOIN frazione f ON f.id_frazione = dc.frazione
   LEFT JOIN stato_clienti sc ON sc.id_stato = cl.stato_cliente 
 WHERE (rc.telefono <> "" 
   OR rc.altro_telefono <> "")
 
 UNION ALL 

 SELECT TRIM(fr.ragione_sociale) AS "ragione_sociale", 
   IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
   c.cap, 
   df.provincia,
   IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,
   fr.data_inserimento,
   rf.nome,
   sf.nome AS status, 
   rfg.figura,
   telefono,
   altro_telefono,
   fax,
   rf.centralino,
   rf.mail,
   fr.id_fornitore AS "id",
   'supplier' AS record_type
 FROM fornitore fr 
   INNER JOIN riferimento_fornitore rf ON rf.id_fornitore = fr.id_fornitore 
   LEFT JOIN destinazione_fornitore df ON df.id_fornitore = fr.id_fornitore 
     AND id_destinazione = "1" 
   LEFT JOIN riferimento_figura rfg ON rfg.id_figura = rf.figura 
   LEFT JOIN comune c ON c.id_comune = df.comune
   LEFT JOIN frazione f ON f.id_frazione = df.frazione
   LEFT JOIN stato_fornitore sf ON sf.id_stato = fr.stato_fornitore 
 WHERE (rf.telefono <> "" 
   OR rf.altro_telefono <> "")
 
 UNION ALL 
 
 SELECT TRIM(cl.ragione_sociale) AS "ragione_sociale", 
   IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
   c.cap, 
   dc.provincia,
   IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,
   cl.data_inserimento,
   i.descrizione,
   sc.nome AS status, 
   "impianto",
   "",
   "",
   "",
   "",
   "",
   i.id_impianto AS "id",
   'system_address' AS record_type
 FROM impianto i
   INNER JOIN clienti cl ON cl.id_cliente = i.id_cliente 
   LEFT JOIN destinazione_cliente dc ON dc.id_cliente = cl.id_cliente 
     AND dc.id_destinazione = i.destinazione 
   LEFT JOIN comune c ON c.id_comune = dc.comune
   LEFT JOIN frazione f ON f.id_frazione = dc.frazione
   LEFT JOIN stato_clienti sc ON sc.id_stato = cl.stato_cliente 
 
 UNION ALL 
 
 SELECT TRIM(o.ragione_sociale) AS "ragione_sociale", 
   IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
   c.cap, 
   o.provincia,
   o.indirizzo,
   o.Data_assunzione,
   "ATTIVO",
   "", 
   "Dipendente",
   o.Telefono_abitazione,
   o.altro_telefono,
   "",
   "",
   o.E_mail,
   o.Id_operaio AS "id",
   "employee" AS record_type
 FROM operaio o 
   LEFT JOIN comune c ON c.Id_comune = o.Comune
   LEFT JOIN frazione f ON f.Id_frazione = o.Frazione
 WHERE IFNULL(o.Data_licenziamento, CURRENT_DATE) >= CURRENT_DATE
 
 ORDER BY ragione_sociale;


DROP VIEW IF EXISTS vw_customersExport;
CREATE VIEW `vw_customersExport` AS
 SELECT cl.id_cliente, TRIM(cl.ragione_sociale) AS "ragione_sociale", 
   IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
	c.cap, 
   dc.provincia,
	IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,

	cl.data_inserimento,
	rc.nome, -- nome riferimento
	sc.nome AS status, -- stato cliente
	tc.id_tipo AS id_tipo_cliente, -- ID tipo cliente
	tc.nome AS tipo_cliente, -- tipo cliente
	tr.nome AS tipo_rapporto,
	ta.nome AS tipo_attivita,
   rfg.figura,
	rc.telefono,
	rc.altro_telefono,
	rc.fax,
	rc.centralino,
	rc.mail,
	dc.tempo_strada,
	dc.km_sede
 FROM clienti cl 
   INNER JOIN riferimento_clienti rc ON cl.id_cliente = rc.id_cliente 
   LEFT JOIN destinazione_cliente dc ON dc.id_cliente = cl.id_cliente 
     AND id_destinazione = "1" 
   LEFT JOIN riferimento_figura rfg ON rfg.id_figura = rc.figura 
   LEFT JOIN comune c ON c.id_comune = dc.comune
   LEFT JOIN frazione f ON f.id_frazione = dc.frazione
   INNER JOIN stato_clienti sc ON sc.id_stato = cl.stato_cliente 
   INNER JOIN tipo_cliente tc ON tc.id_tipo = cl.tipo_cliente 
   LEFT JOIN tipo_rapclie tr ON tr.id_tipo = cl.tipo_rapporto 
   LEFT JOIN tipo_attivita ta ON ta.id_tipo = cl.id_attività 
 WHERE (IFNULL(rc.telefono, "") <> "" 
   OR IFNULL(rc.altro_telefono, "") <> ""
   OR IFNULL(rc.mail, "") <> "")
 ORDER BY ragione_sociale;


DROP VIEW IF EXISTS vw_depotsProducts;
CREATE VIEW `vw_depotsProducts` AS
  SELECT codice_articolo,
    articolo.stato_articolo AS id_stato_articolo,
    articolo_stato.colore AS stato_articolo_colore,
  	desc_brev AS "descrizione",
    codice_fornitore as "codice_fornitore",
    giacenza AS "giacenza",
    marca.nome as"marca",
    categoria_merciologica.nome AS "categoria",
    Sottocategoria.nome AS "sottocategoria",
    ROUND(articolo_listino.prezzo,2) AS "prezzo",
    ROUND(b.prezzo,2) AS "costo",
    tipo_magazzino.nome AS tipo_magazzino,
    tipo_magazzino.id_tipo AS id_tipo_magazzino,
    data_ultimo_movimento,
    magazzino.Data_mod
  FROM magazzino
    INNER JOIN articolo  ON magazzino.id_articolo=codice_Articolo
    INNER JOIN articolo_stato  ON articolo.stato_articolo=articolo_stato.id_stato
    LEFT JOIN marca ON marca=id_marca
    LEFT JOIN sottocategoria ON sottocategoria=id_sottocategoria
    LEFT JOIN categoria_merciologica ON categoria_merciologica.id_categoria=categoria
    LEFT JOIN articolo_listino ON articolo_listino.id_articolo=codice_articolo AND articolo_listino.id_listino = 2
    LEFT JOIN articolo_listino AS b ON b.id_articolo=codice_articolo AND b.id_listino = 1
    INNER JOIN tipo_magazzino ON id_tipo=magazzino.tipo_magazzino
  ORDER BY data_ultimo_movimento DESC;


DROP VIEW IF EXISTS subvw_systemsComponentsDetailWithAllVersions;
DROP VIEW IF EXISTS vw_systemsComponentsDetail;
DROP VIEW IF EXISTS vw_systems_components_detail;
CREATE VIEW `vw_systems_components_detail` AS
	SELECT
		impianto_componenti.id_impianto,
		impianto_componenti.id_articolo,
		impianto_box.descrizione as"Posizionamento",
		fine_garanzia,
		id as ordine,
		data_installazione,
		data_dismesso,
		data_scadenza,
		IF(data_scadenza IS NULL, 'none',
			IF(data_scadenza BETWEEN NOW() + INTERVAL 30 DAY AND NOW(), "expiring",
			IF(data_scadenza < NOW(), "expired", "not_expired"))) as "stato_scadenza",
		garanzia_fornitore,
		impianto_componenti.id_versione,
		versione
	FROM impianto_componenti 
		LEFT JOIN impianto_box ON impianto_box.id_impianto=impianto_componenti.id_impianto AND id_box=box
   		LEFT JOIN impianto_componenti_versione ON impianto_componenti_versione.id_versione = impianto_componenti.id_versione
	GROUP BY id_impianto, id_articolo, ordine
	ORDER BY data_scadenza IS NULL, data_scadenza ASC, data_dismesso IS NULL, data_dismesso ASC;

DROP VIEW IF EXISTS vw_systems_components;
CREATE VIEW `vw_systems_components` AS
	SELECT DISTINCT id_articolo,
		desc_brev,
		codice_fornitore,
		id_impianto,
    	SUM(IF(data_dismesso IS NULL,1,0)) AS quantità,
    	SUM(IF(data_dismesso IS NULL AND stato_scadenza = 'expiring',1,0)) AS quantita_in_scadenza,
    	SUM(IF(data_dismesso IS NULL AND stato_scadenza = 'expired',1,0)) AS quantita_scaduti,
    	SUM(IF(data_dismesso IS NULL AND stato_scadenza = 'not_expired',1,0)) AS quantita_non_scaduti,
    	SUM(IF(data_dismesso IS NULL AND stato_scadenza = 'none',1,0)) AS quantita_no_scadenza,
		colore 
	FROM vw_systems_components_detail 
		INNER JOIN articolo ON id_articolo = codice_articolo
		LEFT JOIN articolo_stato ON articolo.stato_articolo = articolo_stato.id_stato
	GROUP BY id_impianto, id_articolo;

DRop VIEW IF EXISTS vw_product_sub_categories;
CREATE VIEW vw_product_sub_categories AS
	SELECT `Id_categoria`,
		`id_sottocategoria`,
		NULL AS id_sottocategoria_padre,
		`Nome`,
		`Descrizione`,
		1 AS 'livello'
	FROM sottocategoria
	UNION ALL
	-- SOTTOCATEGORIA2
	SELECT s1.Id_categoria,
		s2.id_livello2 AS `id_sottocategoria`,
		s2.id_sottocategoria AS id_sottocategoria_padre,
		s2.Nome,
		s2.Descrizione,
		2 AS 'livello'
	FROM sottocategoria2 AS s2
		INNER JOIN sottocategoria AS s1 ON s1.id_sottocategoria = s2.id_sottocategoria;


DROP VIEW IF EXISTS subvw_depots_types_products;
CREATE VIEW subvw_depots_types_products AS 
	SELECT *
	FROM articolo, tipo_magazzino;

DROP VIEW IF EXISTS vw_depots_all_products;
CREATE VIEW vw_depots_all_products AS
	SELECT articolo_stato.Nome AS 'Stato', 
		subvw_depots_types_products.codice_articolo AS 'Cod. Articolo',
		subvw_depots_types_products.Desc_brev AS 'Descrizione',
		subvw_depots_types_products.codice_fornitore AS 'Cod. Fornitore',
		subvw_depots_types_products.Nome AS 'Tipo Magazzino',
		IF(magazzino.id IS NULL, 'NO', 'SI') AS 'Visibile Magazzino',
		IFNULL(magazzino.giacenza, 0) AS Giacenza,
		marca.Nome as 'Marca',
		categoria_merciologica.Nome as 'Categoria Merceologica',
		listino_prezzo.Prezzo AS Prezzo,
		listino_costo.Prezzo AS Costo
	FROM subvw_depots_types_products
		LEFT JOIN magazzino ON magazzino.tipo_magazzino = subvw_depots_types_products.Id_tipo 
			AND magazzino.id_articolo = subvw_depots_types_products.Codice_articolo
		INNER JOIN articolo_stato ON subvw_depots_types_products.Stato_articolo = articolo_stato.id_stato
		LEFT JOIN marca ON subvw_depots_types_products.Marca = marca.Id_marca
		LEFT JOIN categoria_merciologica ON categoria_merciologica.Id_categoria = subvw_depots_types_products.categoria
		LEFT JOIN articolo_listino AS listino_prezzo ON listino_prezzo.Id_articolo = Codice_articolo AND listino_prezzo.id_listino = 2
		LEFT JOIN articolo_listino AS listino_costo ON listino_costo.Id_articolo = Codice_articolo AND listino_costo.id_listino = 1 
	ORDER BY id_tipo, codice_articolo;


DROP VIEW IF EXISTS vw_systems_customers_details;
CREATE VIEW vw_systems_customers_details AS
	SELECT 
		clienti.id_cliente,
      	clienti.ragione_sociale,
		tipo_cliente.nome as "tipo_cliente",
		tipo_rapclie.nome AS "tipo_rap",
		stato_clienti.nome AS "stato_cliente",
		riferimento_clienti.telefono,
		riferimento_clienti.mail,
		riferimento_clienti.altro_telefono,
		IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
		c.cap, 
		dc.provincia,
		IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,
		CONCAT(impianto.id_impianto," ") AS "id",
		impianto.id_impianto AS "id_impianto",
		tipo_impianto.nome as "tipo_impianto",
		impianto.descrizione AS "descrizione",
		impianto.data_funzione AS "data_funzione",
		impianto.scadenza_garanzia AS "scadenza_garanzia",
		tempo_manutenzione/60 AS "tempo_manutenzione",
		MAX(impianto_uscita.manutenzione) AS "costo2",
		costo_manutenzione AS "manutenzione",
		abbonamento.nome AS "abbonamento",
		persone,
		CAST(GROUP_CONCAT(DISTINCT substring(mese.nome,1,3) separator ", ")  AS CHAR(150) CHARACTER SET utf8) AS "Controlli",
		"NESSUNO" AS "id_mese"
   	FROM impianto
	   	INNER JOIN tipo_impianto ON impianto.tipo_impianto = tipo_impianto.id_tipo
		INNER JOIN clienti ON clienti.id_cliente=impianto.id_cliente
		INNER JOIN stato_clienti ON clienti.stato_cliente=stato_clienti.id_stato
		INNER JOIN tipo_cliente ON clienti.tipo_cliente=tipo_cliente.id_tipo
		INNER JOIN tipo_rapclie ON clienti.tipo_rapporto=tipo_rapclie.id_tipo
		LEFT JOIN impianto_uscita ON impianto_uscita.id_impianto=impianto.id_impianto AND impianto_uscita.id_impianto
		INNER JOIN riferimento_clienti ON clienti.id_cliente=riferimento_clienti.id_cliente AND riferimento_clienti.id_riferimento=1
		LEFT JOIN destinazione_cliente dc ON dc.id_cliente = clienti.id_cliente AND id_destinazione = impianto.destinazione
		LEFT JOIN comune c ON c.id_comune = dc.comune
		LEFT JOIN frazione f ON f.id_frazione = dc.frazione
		LEFT JOIN abbonamento ON abbonamento.id_abbonamento=impianto_uscita.id_abbonamento 
		LEFT JOIN impianto_abbonamenti_mesi ON impianto.id_impianto=impianto_abbonamenti_mesi.impianto AND impianto_abbonamenti_mesi.anno=DATE_FORMAT(NOW(),'%Y')
      	LEFT JOIN mese ON mese.id_mese=impianto_abbonamenti_mesi.mese
   	GROUP BY impianto.id_impianto
	UNION ALL
	SELECT clienti.id_cliente,
		ragione_sociale,
		tipo_cliente.nome AS "tipo_cliente",
		tipo_rapclie.nome AS "tipo_rap", 
		stato_clienti.nome AS stato_cliente,
		riferimento_clienti.telefono AS "telefono",
		riferimento_clienti.mail  AS "mail",
		riferimento_clienti.altro_telefono AS "altro_telefono",
		IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
		c.cap, 
		dc.provincia,
		IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo,
		"" AS "id",
		NULL AS "id_impianto",
		"" AS "tipo_impianto",
		"" AS "descrizione",
		NULL AS "data_funzione",
		NULL AS "scadenza_garanzia",
		NULL AS "tempo_manutenzione",
		NULL  AS "costo2",
		NULL AS "manutenzione",
		"" AS "abbonamento",
		NULL AS "persone",
		"" AS "Controlli",
		"NESSUNO" AS "id_mese"
	FROM clienti
		INNER JOIN riferimento_clienti ON clienti.id_cliente=riferimento_clienti.id_cliente AND riferimento_clienti.id_riferimento=1
		LEFT JOIN destinazione_cliente dc ON dc.id_cliente = clienti.id_cliente AND sede_principale = 1
		LEFT JOIN comune c ON c.id_comune = dc.comune
		LEFT JOIN frazione f ON f.id_frazione = dc.frazione
		INNER JOIN stato_clienti ON clienti.stato_cliente=stato_clienti.id_stato
		INNER JOIN tipo_cliente ON clienti.tipo_cliente=tipo_cliente.id_tipo
		INNER JOIN tipo_rapclie ON clienti.tipo_rapporto=tipo_rapclie.id_tipo;



DROP VIEW IF EXISTS vw_ticket_details;
CREATE VIEW vw_ticket_details AS
	
	SELECT Id_ticket,
		ticket.`Id_impianto`,
		ticket.Id_cliente,
		clienti.ragione_sociale as cliente,
		impianto.Descrizione as impianto,
		tipo_impianto.nome as tipo_impianto,
		ticket.`Descrizione` as descrizione,
		stato_ticket.id_stato AS id_stato_ticket,
		stato_ticket.nome AS stato_ticket,
		causale_ticket.Nome as Causale,
		IF(`Urgenza`= 0, 'BASSA', IF(Urgenza = 1, 'NORMALE', 'ALTA')) AS Urgenza,
		tipo_intervento.Nome as tipo_intervento,
		pervenuta_per.nome AS sorgente,
		tempo as `tempo_minuti`,
		ROUND(tempo / 60, 2) AS `tempo_ore`,
		`data_ticket`,
		`scadenza`,
		`data_soluzione`,
		telefono,
		altro_telefono as cellulare,
		mail,	
		IF(frazione IS NULL, c.nome, CONCAT(c.nome, " - ", f.nome)) AS paese,
		c.cap, 
		dc.provincia,
		IF(numero_civico IS NULL OR indirizzo = "", indirizzo, CONCAT(indirizzo, ", ", numero_civico)) AS indirizzo
	FROM ticket
		INNER JOIN clienti ON clienti.Id_cliente = ticket.id_cliente
		LEFT JOIN impianto ON impianto.id_impianto = ticket.id_impianto
	   	LEFT JOIN tipo_impianto ON impianto.tipo_impianto = tipo_impianto.id_tipo
		INNER JOIN causale_ticket ON causale_ticket.Id_causale = ticket.Causale
		INNER JOIN tipo_intervento ON tipo_intervento.Id_tipo = ticket.intervento
		INNER JOIN stato_ticket ON stato_ticket.Id_stato = ticket.Stato_ticket
		INNER JOIN pervenuta_per ON pervenuta_per.Id_modo = ticket.comunicazione
		INNER JOIN riferimento_clienti ON clienti.id_cliente=riferimento_clienti.id_cliente
			AND riferimento_clienti.id_riferimento=1
		LEFT JOIN destinazione_cliente dc ON dc.id_cliente = clienti.id_cliente AND dc.Id_destinazione = ticket.id_destinazione
		LEFT JOIN comune c ON c.id_comune = dc.comune
		LEFT JOIN frazione f ON f.id_frazione = dc.frazione
	ORDER BY data_ticket desc;




DROP VIEW IF EXISTS vw_quotes_details;
	CREATE VIEW vw_quotes_details AS
	SELECT 
		preventivo.id_preventivo AS "ID Preventivo",
		preventivo.anno AS "Anno",
		clienti.id_cliente AS "ID Cliente",
		clienti.ragione_sociale AS "Cliente",
		tipo_preventivo.Nome AS "Tipo Preventivo",
		tipo_intprev.Nome AS "Tipo Intervento",
		UPPER(stato_preventivo.Nome) AS "Stato Preventivo",
		preventivo.note AS "Note Preventivo",
		CONCAT(IF((frazione.nome IS NOT NULL), CONCAT(frazione.nome," di "),""),
			IF((comune.nome IS NOT NULL),CONCAT(comune.nome),""),
			IF((destinazione_cliente.indirizzo IS NOT NULL), CONCAT(" - ", destinazione_cliente.indirizzo),""),
			IF((numero_civico IS NOT NULL), CONCAT(",", numero_civico),""),
			IF((destinazione_cliente.altro IS NOT NULL), CONCAT("/", destinazione_cliente.altro),""),
			IF((comune.cap IS NOT NULL), CONCAT(" - ", comune.cap),""),
			" ",
			IF((destinazione_cliente.Provincia IS NOT NULL), CONCAT(destinazione_cliente.Provincia),"")) AS "Provincia",
		revisione AS "Nr° Revisione",
		IF(stampato = 1, 'SI', 'NO') AS Stampato,
		IF(inviato = 1, 'SI', 'NO') AS Inviato,
		SUM(
			(ROUND((prezzo-(IF(preventivo_lotto.tipo_ricar=1,0,sconto)/100*prezzo)),2)
			+ROUND((IF(montato="0", 0, ((b.tempo_installazione/60*prezzo_h) - ((b.tempo_installazione/60*prezzo_h)*scontolav/100)))), 2)
		)*quantità) AS "Totale",
		data_invio AS "Data Invio",
		primo_sollecito AS "Data invio 1° sollecito",
		secondo_sollecito AS "Data invio 2° sollecito",
		preventivo.data_creazione AS "Data Creazione"
	FROM preventivo
			LEFT JOIN revisione_preventivo ON revisione=id_revisione AND preventivo.id_preventivo=revisione_preventivo.id_preventivo AND revisione_preventivo.anno= preventivo.anno
			LEFT JOIN clienti ON clienti.id_cliente=revisione_preventivo.id_cliente
			LEFT JOIN destinazione_cliente ON destinazione_cliente.id_cliente=revisione_preventivo.id_cliente AND destinazione_cliente.id_destinazione=revisione_preventivo.destinazione
			LEFT JOIN comune ON id_comune=destinazione_cliente.comune
			LEFT JOIN frazione ON id_frazione=destinazione_cliente.frazione
			LEFT JOIN articolo_preventivo AS b ON preventivo.id_preventivo=b.id_preventivo AND preventivo.anno=b.anno AND b.id_revisione=revisione
			LEFT JOIN preventivo_lotto ON preventivo_lotto.id_preventivo=revisione_preventivo.id_preventivo AND revisione_preventivo.anno=preventivo_lotto.anno AND revisione_preventivo.id_revisione=preventivo_lotto.id_revisione AND preventivo_lotto.posizione=b.lotto
			INNER JOIN stato_preventivo ON stato = id_stato
			LEFT JOIN tipo_intprev ON tipo_intprev.id_tipo = preventivo.tipo_preventivo
			INNER JOIN tipo_preventivo ON preventivo.tipo = tipo_preventivo.id_tipo
	GROUP BY anno, preventivo.id_preventivo
	ORDER BY preventivo.anno DESC, preventivo.id_preventivo DESC;

DROP VIEW IF EXISTS vw_report_daily_detailed;
CREATE VIEW vw_report_daily_detailed AS
SELECT
	rapporto_giornaliero.id as id_rapporto_giornaliero,
	operaio.id_operaio,
	operaio.ragione_sociale as ragione_sociale_operaio,
 	rapporto_giornaliero.data_rapporto,
	rapporto_giornaliero_attivita.ora_inizio,
	rapporto_giornaliero_attivita.ora_fine,
	ROUND(TIME_TO_SEC(IF(ora_fine > ora_inizio,
		TIMEDIFF(ora_fine, ora_inizio),
		TIMEDIFF('24:00:00', TIMEDIFF(ora_inizio, ora_fine))
	))/60) AS minuti_differenza,
	IF(ora_fine > ora_inizio,
		TIMEDIFF(ora_fine, ora_inizio),
		TIMEDIFF('24:00:00', TIMEDIFF(ora_inizio, ora_fine))
	) AS time_differenza,
	rapporto_giornaliero_attivita.tipo_lavoro AS tipo_attivita,
	rapporto_giornaliero_tipo_attivita.nome,
	rapporto_giornaliero_attivita.note AS note,
	rapporto.id_rapporto,
	rapporto.Anno as anno_rapporto,
	clienti.Id_cliente,
	clienti.ragione_sociale as ragione_sociale_cliente,
	impianto.id_impianto,
	impianto.Descrizione AS descrizione_impianto,
	CONCAT(comune.Nome, " (", comune.provincia, ") - "
		, comune.cap, " - "
		, destinazione_cliente.Indirizzo, ", "
		, destinazione_cliente.numero_civico) AS indirizzo,
	tipo_intervento.Id_tipo AS id_tipo_intervento,
	tipo_intervento.Nome AS tipo_intervento,
	IFNULL(rapporto_tecnico.spesa_trasferta, 0) as spesa_trasferta,
	IFNULL(rapporto_tecnico.autostrada, 0) as spesa_autostrada,
	IFNULL(rapporto_tecnico.parcheggio, 0) as spesa_parcheggio,
	IFNULL(rapporto_tecnico.altro, 0) AS spesa_altro,
	rapporto_tecnico.altro_n AS spesa_altro_nota
FROM rapporto_giornaliero
	INNER JOIN operaio ON operaio.id_operaio = rapporto_giornaliero.id_operaio
	INNER JOIN rapporto_giornaliero_attivita
		ON rapporto_giornaliero.id = rapporto_giornaliero_attivita.Id_rapporto_giornaliero
	INNER JOIN rapporto_giornaliero_tipo_attivita
		ON rapporto_giornaliero_tipo_attivita.Id = rapporto_giornaliero_attivita.tipo_lavoro
	LEFT JOIN rapporto_giornaliero_attivita_rapporto
		ON rapporto_giornaliero_attivita_rapporto.Id_rapporto_giornaliero_attivita = rapporto_giornaliero_attivita.Id
	LEFT JOIN rapporto
		ON rapporto.id_rapporto = rapporto_giornaliero_attivita_rapporto.id_rapporto
			AND rapporto.anno = rapporto_giornaliero_attivita_rapporto.anno_rapporto
	LEFT JOIN rapporto_tecnico ON rapporto_tecnico.id_rapporto = rapporto.id_rapporto
		AND rapporto_tecnico.anno = rapporto.anno
		AND rapporto_tecnico.tecnico = rapporto_giornaliero.id_operaio
	LEFT JOIN tipo_intervento ON tipo_intervento.id_tipo = rapporto.Tipo_intervento
	LEFT JOIN clienti ON clienti.id_cliente = rapporto.Id_cliente
	LEFT JOIN impianto ON impianto.id_impianto = rapporto.Id_Impianto
	LEFT JOIN destinazione_cliente ON destinazione_cliente.Id_destinazione = impianto.Destinazione
		AND clienti.Id_cliente = destinazione_cliente.id_cliente
	LEFT JOIN comune ON comune.Id_comune = destinazione_cliente.Comune
ORDER BY rapporto_giornaliero.data_rapporto DESC, rapporto_giornaliero_attivita.ora_inizio DESC;



DROP VIEW IF EXISTS vw_quote_body_details;
CREATE VIEW vw_quote_body_details AS
SELECT
	ap.Id_preventivo,
	ap.anno,
	ap.Id_revisione,
	ap.Lotto as "id_lotto",
	id_tab,
	l.nome as "lotto",
	ap.id_articolo,
	IFNULL(articolo.desc_brev, ap.Desc_brev) AS descrizione,
	ap.codice_fornitore,
	ROUND(quantità,2) AS "quantità",
	ap.unità_misura,
	ROUND(prezzo,2) as prezzo_maateriale,
	ROUND(costo,2) as costo_materiale,
	sconto AS "sconto_materiale",
	prezzo_h,
	costo_h,
	montato,
	ap.tempo_installazione,
	scontolav AS "sconto_lavoro",
	scontoriga AS "sconto_riga",
	ROUND((((quantità*(prezzo/100*(100-sconto)))+(IF(montato=0, 0, (prezzo_h*((ap.tempo_installazione*quantità)/60))/100*(0-scontolav+100))))/100*(0-scontoriga+100)),2) AS "prezzo_totale",
	ROUND((quantità*costo)+IF(montato=0, 0, (costo_h*((ap.tempo_installazione*quantità)/60))),2) AS "costo_totale"
FROM articolo_preventivo as ap
	LEFT JOIN articolo ON articolo.Codice_articolo = ap.Id_articolo
	INNER JOIN preventivo_lotto AS pl
		ON ap.Id_preventivo = pl.id_preventivo
		AND ap.anno = pl.anno
		AND ap.Lotto = pl.posizione
		AND ap.Id_revisione = pl.id_revisione
	LEFT JOIN Lotto AS l
		ON l.id_lotto = pl.id_lotto
ORDER BY anno desc, id_preventivo desc, id_lotto, id_tab;