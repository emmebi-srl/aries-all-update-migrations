CREATE TABLE `cliente_promemoria_segnaposto` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_cliente_promemoria_configurazione` INT(11) NOT NULL,
	`nome` VARCHAR(100) NOT NULL DEFAULT '' COLLATE 'latin1_swedish_ci',
	`descrizione` TEXT NOT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`Id`) USING BTREE,
	UNIQUE INDEX `id_cliente_promemoria_configurazione_nome` (`id_cliente_promemoria_configurazione`, `nome`) USING BTREE,
	CONSTRAINT `FK_cliente_promemoria_configurazione` FOREIGN KEY (`id_cliente_promemoria_configurazione`) REFERENCES `cliente_promemoria_configurazione` (`Id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO cliente_promemoria_segnaposto (id_cliente_promemoria_configurazione, nome, descrizione) VALUES
	(1, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(1, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(1, '{date}', 'Data evento'),
	(1, '{time}', 'Orario inizio evento'),
	(1, '{event_type}', 'Tipo evento'),
	(1, '{system_type}', 'Tipo impianto'),
	(1, '{system_description}', 'Descrizione impianto'),
	(1, '{full_address}', 'Indirizzo impianto'),
	(1, '{municipality}', 'Comune impianto'),
	
	(2, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(2, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(2, '{date}', 'Data scadenza'),
	(2, '{phone_number}', 'Numero sim'),
	(2, '{topup_type_name}', 'Tipo ricarica sim (TIM, Vodafone, ...)'),
	(2, '{topup_price}', 'Importo ricarica'),
	(2, '{system_type}', 'Tipo impianto'),
	(2, '{system_description}', 'Descrizione impianto'),
	(2, '{full_address}', 'Indirizzo impianto'),
	(2, '{municipality}', 'Comune impianto'),
	
	(3, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(3, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(3, '{date}', 'Data scadenza'),
	(3, '{product_name}', 'Descrizione breve articolo'),
	(3, '{system_type}', 'Tipo impianto'),
	(3, '{system_description}', 'Descrizione impianto'),
	(3, '{full_address}', 'Indirizzo impianto'),
	(3, '{quantity}', 'Quantità articoli in scadenza'),
	(3, '{municipality}', 'Comune impianto'),

	(4, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(4, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(4, '{date}', 'Data rinnovo'),
	(4, '{phone_number}', 'Numero sim'),
	(4, '{topup_type_name}', 'Tipo ricarica sim (TIM, Vodafone, ...)'),
	(4, '{topup_price}', 'Importo ricarica'),
	(4, '{system_type}', 'Tipo impianto'),
	(4, '{system_description}', 'Descrizione impianto'),
	(4, '{full_address}', 'Indirizzo impianto'),
	(4, '{municipality}', 'Comune impianto'),
	
	(5, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(5, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(5, '{system_maintenance_month}', 'Mese manutenzione'),
	(5, '{system_maintenance_year}', 'Anno manutenzione'),
	(5, '{system_type}', 'Tipo impianto'),
	(5, '{system_description}', 'Descrizione impianto'),
	(5, '{full_address}', 'Indirizzo impianto'),
	(5, '{municipality}', 'Comune impianto'),
	
	
	(6, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(6, '{company_name}', 'Ragione sociale cliente'),
	(6, '{customer_name}', 'Ragione sociale cliente'),
	(6, '{date}', 'Data scadenza garanzia'),
	(6, '{system_type}', 'Tipo impianto'),
	(6, '{system_description}', 'Descrizione impianto'),
	(6, '{full_address}', 'Indirizzo impianto'),
	(6, '{municipality}', 'Comune impianto'),
	
	(7, '{title}', 'Titolo cliente (Sig, Dott, ...)'),
	(7, '{company_name}', 'Ragione sociale cliente'),
	(7, '{date}', 'Data scadenza ticket'),
	(7, '{system_type}', 'Tipo impianto'),
	(7, '{system_description}', 'Descrizione impianto'),
	(7, '{full_address}', 'Indirizzo impianto'),
	(7, '{municipality}', 'Comune impianto'),
	(7, '{ticket_description}', 'Descrizione ticket')
	
	;

UPDATE cliente_promemoria_segnaposto SET descrizione = 'Ragione sociale nostra azienda' where nome = "{company_name}";

INSERT INTO cliente_promemoria_segnaposto (id_cliente_promemoria_configurazione, nome, descrizione)
SELECT Id,
	'{contact_name}',
	'Nome contatto cliente, se vuoto viene presa la ragione sociale'
FROM cliente_promemoria_configurazione;
