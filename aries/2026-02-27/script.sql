INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'customer_name', 'Ragione Sociale');
INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'system_description', 'Descrizione Impianto');
INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'system_address', 'Indirizzo Impianto');
INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'subscription_price', 'Prezzo Abbonamento');
INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'subscription_maintenace_number', 'Numero Manutenzioni');
INSERT INTO campagna_aries_segnaposto (uuid, id_tipo_campagna, nome, descrizione)
VALUE 
(UUID(), (select id from tipo_campagna_aries where uuid = '83ddae04-d05b-4211-8df5-76791801a1e6'), 'link_landing_page', 'Link landing page');