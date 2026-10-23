-- CustomerDestinationRepository now reads the comune/frazione ids of the customer destinations
-- (CustomerDestinationDto.ComuneId/FrazioneId): the web customer page lets operators change them.

DROP PROCEDURE IF EXISTS sp_apiCustomerDestinationGetByCustomers;
DELIMITER //
CREATE PROCEDURE sp_apiCustomerDestinationGetByCustomers
(
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT id_destinazione,
		destinazione_cliente.id_cliente,
		IFNULL(destinazione_cliente.provincia, "") 'provincia',
		IFNULL(comune.nome, "") 'comune',
		IFNULL(frazione.nome, "") 'frazione',
		destinazione_cliente.comune 'id_comune',
		destinazione_cliente.frazione 'id_frazione',
		IFNULL(indirizzo, "") 'indirizzo',
		IFNULL(numero_civico, 0) 'numero_civico',
		IFNULL(destinazione_cliente.altro, "") 'altro',
		comune.cap,
		km_sede,
		tempo_strada,
		longitudine,
		latitudine,
		destinazione_cliente.sede_principale
	FROM destinazione_cliente
		LEFT JOIN comune ON
			destinazione_cliente.comune = id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = id_frazione
	WHERE FIND_IN_SET(destinazione_cliente.id_cliente, customer_ids);

END; //
DELIMITER ;
