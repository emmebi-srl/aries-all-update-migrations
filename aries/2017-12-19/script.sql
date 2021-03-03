ALTER TABLE `checklist_model_elemento`
	DROP INDEX `Id_paragrafo_Id_checklist_Id_elemento_Posizione`;

INSERT INTO `configurazione_percorsi` (`Percorso`, `Tipo_percorso`) VALUES ('\\\\192.168.12.203\\e\\DOCUMENTI GESTIONALE\\CHECKLIST\\', 'CHECKLIST');

-- 3 = AZIENDE ATTIVE, 5 = TUTTI I CLIENTI
DELETE FROM mail_gruppo_cliente WHERE id_gruppo IN (3, 5); 
INSERT INTO mail_gruppo_cliente 
SELECT riferimento_clienti.id_cliente, 
	riferimento_clienti.id_riferimento, 
	5
FROM riferimento_clienti
	INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
	INNER JOIN stato_clienti ON stato_clienti.Id_stato = clienti.Stato_cliente AND stato_clienti.bloccato <> 1
WHERE mail IS NOT NULL AND mail <> "";

INSERT INTO mail_gruppo_cliente 
SELECT riferimento_clienti.id_cliente, 
	riferimento_clienti.id_riferimento, 
	3
FROM riferimento_clienti
	INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente AND clienti.Tipo_Cliente IN (1, 1000)
	INNER JOIN stato_clienti ON stato_clienti.Id_stato = clienti.Stato_cliente AND stato_clienti.bloccato <> 1
WHERE mail IS NOT NULL AND mail <> "";