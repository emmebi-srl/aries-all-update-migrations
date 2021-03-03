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
