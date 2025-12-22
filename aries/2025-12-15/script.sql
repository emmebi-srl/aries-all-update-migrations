INSERT INTO `cliente_promemoria_configurazione` (`Nome`, `Tipo_intervallo`, `Valore`, `Data_ultima_esecuzione`, `Oggetto_email`, `Corpo_email`, `Testo_sms`, `abilita_sms`, `abilita_email`, `Data_mod`, `Utente_mod`)
	VALUES ('PROMEMORIA INVIO RESOCONTI', 6, 0, '2024-10-04 12:03:02', 'scadenza SIM {phone_number}', '{system_type} {full_address} {system_description} {company_name} {title} {phone_number} {municipality} {renew_price}', 'some text', b'0', b'1', '2024-10-04 12:03:02', 1);
UPDATE `cliente_promemoria_configurazione` SET `Tipo_intervallo`=7, `Valore`=15, `Oggetto_email`='Promemoria Resoconto', `Corpo_email`='Promemoria Invio Resoconto', `Testo_sms`='Promemoria Invio Resoconto', `abilita_email`=b'0' WHERE  `Id`=8;

INSERT INTO cliente_promemoria_segnaposto (id_cliente_promemoria_configurazione, nome, descrizione) VALUES
	(8, '{company_name}', 'Ragione sociale nostra azienda'),
	(8, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(8, '{customer_name}', 'Ragione sociale cliente'),
	(8, '{report_group_id}', 'ID Resoconto'),
	(8, '{report_group_year}', 'Anno Resoconto'),
	(8, '{report_group_date}', 'Data Resoconto'),
	(8, '{report_group_email_send_date}', 'Data Invio Resoconto'),
	(8, '{full_address}', 'Indirizzo'),
	(8, '{municipality}', 'Comune');


ALTER TABLE `resoconto`
	ADD COLUMN `promemoria_inviato` BIT(1) NULL DEFAULT  b'0' AFTER `prezzo_extra`;
	
ALTER TABLE `resoconto`
	ADD COLUMN `data_invio_promemoria` DATETIME NULL DEFAULT NULL AFTER `promemoria_inviato`;

INSERT INTO `environment_variables` (`var_key`, `var_value`) VALUES ('ENABLE_SUBSCRIPTIONS_CAMPAIGNS_ON_INVOICE_SEND', '1');

INSERT INTO `tipo_campagna_aries` (`uuid`, `nome`, `rif_applicazione`) VALUES ('83ddae04-d05b-4211-8df5-76791801a1e6', 'Abbonamento Impianto', 'system_subscription');
