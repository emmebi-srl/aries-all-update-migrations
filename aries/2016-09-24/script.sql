ALTER TABLE `stampante_documento`
	ADD COLUMN `Id_utente` SMALLINT UNSIGNED NULL DEFAULT NULL AFTER `copie`,
	ADD COLUMN `Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Id_utente`;



ALTER TABLE `stampante_documento`
	ADD COLUMN `Id` INT NOT NULL AUTO_INCREMENT FIRST,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id`),
	ADD UNIQUE INDEX `Id_documento_Id_utente` (`Id_documento`, `Id_utente`);


ALTER TABLE `condizione_pagamento`
	ADD COLUMN `Chiusura_alla_scadenza` BIT NOT NULL DEFAULT b'0' AFTER `condizioniPA`,
	ADD COLUMN `Id_utente` SMALLINT NOT NULL AFTER `Chiusura_alla_scadenza`,
	ADD COLUMN `Timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `Id_utente`;

	
DELETE FROM mail_gruppo_cliente WHERE mail_gruppo_cliente.id_gruppo IN (3,4,5);

INSERT IGNORE INTO mail_gruppo_cliente
SELECT riferimento_clienti.Id_cliente, 
	riferimento_clienti.Id_riferimento, 
	3
FROM riferimento_clienti 
	INNER JOIN CLIENTI ON clienti.Id_cliente = riferimento_clienti.Id_cliente
	INNER JOIN stato_clienti ON clienti.Stato_cliente = stato_clienti.Id_stato
WHERE stato_clienti.Nome IN ('SUBBAPALTO', 'ATTIVO', 'DA VERIFICARE')
AND clienti.Tipo_Cliente IN (1, 1000, 12, 4)
AND riferimento_clienti.mail IS NOT NULL AND riferimento_clienti.mail <> '';

INSERT IGNORE INTO mail_gruppo_cliente
SELECT riferimento_clienti.Id_cliente, 
	riferimento_clienti.Id_riferimento, 
	5
FROM riferimento_clienti 
	INNER JOIN CLIENTI ON clienti.Id_cliente = riferimento_clienti.Id_cliente
	INNER JOIN stato_clienti ON clienti.Stato_cliente = stato_clienti.Id_stato
WHERE stato_clienti.Nome IN ('SUBBAPALTO', 'ATTIVO', 'DA VERIFICARE')
AND riferimento_clienti.mail IS NOT NULL AND riferimento_clienti.mail <> '';

INSERT IGNORE INTO mail_gruppo_cliente
SELECT riferimento_clienti.Id_cliente, 
	riferimento_clienti.Id_riferimento, 
	4
FROM riferimento_clienti 
	INNER JOIN CLIENTI ON clienti.Id_cliente = riferimento_clienti.Id_cliente
	INNER JOIN stato_clienti ON clienti.Stato_cliente = stato_clienti.Id_stato
WHERE stato_clienti.Nome IN ('NON ATTIVO', 'BLOCCATO')
AND riferimento_clienti.mail IS NOT NULL AND riferimento_clienti.mail <> '';
