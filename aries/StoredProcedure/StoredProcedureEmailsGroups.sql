
DROP PROCEDURE IF EXISTS sp_check_group_name; 
DELIMITER $$
CREATE PROCEDURE `sp_check_group_name`(
    IN group_name VARCHAR(45),
    IN group_type INT(11),
    OUT group_id INT(11)
)
BEGIN
	DECLARE my_counter INT(11);

	SELECT COUNT(*), id_gruppo
        INTO my_counter, group_id
    FROM mail_gruppo
    WHERE nome = group_name;

    IF my_counter <> 1 THEN
		INSERT INTO mail_gruppo
        SET nome = group_name,
            tipo = group_type;
        
        SELECT LAST_INSERT_ID() INTO group_id;
	END IF;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_refresh_all_customers_groups; 
DELIMITER $$
CREATE PROCEDURE `sp_refresh_all_customers_groups`(
)
BEGIN
	DECLARE group_id INT;
    CALL sp_check_group_name('TUTTI I CLIENTI', 0, group_id);

    DELETE FROM mail_gruppo_cliente WHERE id_gruppo = group_id;

    INSERT INTO mail_gruppo_cliente
    SELECT riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento,
        group_id
    FROM riferimento_clienti
        INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
        INNER JOIN stato_clienti ON clienti.stato_cliente = stato_clienti.id_stato
    WHERE mail IS NOT NULL AND mail <> "" AND stato_clienti.nome IN ('ATTIVO');
    
END $$
DELIMITER ;
CALL sp_refresh_all_customers_groups();
DROP PROCEDURE IF EXISTS sp_refresh_all_customers_groups;


DROP PROCEDURE IF EXISTS sp_refresh_all_subsrib_customer;
DELIMITER $$
CREATE PROCEDURE `sp_refresh_all_subsrib_customer`(
)
BEGIN
	DECLARE group_id INT;
    CALL sp_check_group_name('PRIVATI ABBONATI', 0, group_id);

    DELETE FROM mail_gruppo_cliente WHERE id_gruppo = group_id;

    INSERT INTO mail_gruppo_cliente
    SELECT riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento,
        group_id
    FROM riferimento_clienti
        INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
        INNER JOIN stato_clienti ON clienti.stato_cliente = stato_clienti.id_stato
        INNER JOIN impianto ON impianto.id_cliente = clienti.id_cliente AND impianto.stato = 1
    WHERE mail IS NOT NULL AND mail <> "" AND stato_clienti.nome IN ('ATTIVO')
    	AND clienti.Tipo_Cliente = 6
        AND (riferimento_clienti.id_riferimento = 1
            OR riferimento_clienti.fatturazione = 1)
	 GROUP BY riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento;
    
END $$
DELIMITER ;
CALL sp_refresh_all_subsrib_customer();
DROP PROCEDURE IF EXISTS sp_refresh_all_subsrib_customer; 

DROP PROCEDURE IF EXISTS sp_refresh_all_subsrib_company; 
DELIMITER $$
CREATE PROCEDURE `sp_refresh_all_subsrib_company`(
)
BEGIN
	DECLARE group_id INT;
    CALL sp_check_group_name('AZIENDE ABBONATE', 0, group_id);

    DELETE FROM mail_gruppo_cliente WHERE id_gruppo = group_id;

    INSERT INTO mail_gruppo_cliente
    SELECT riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento,
        group_id
    FROM riferimento_clienti
        INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
        INNER JOIN stato_clienti ON clienti.stato_cliente = stato_clienti.id_stato
        INNER JOIN impianto ON impianto.id_cliente = clienti.id_cliente AND impianto.stato = 1
    WHERE mail IS NOT NULL AND mail <> "" AND stato_clienti.nome IN ('ATTIVO')
    	AND clienti.Tipo_Cliente IN (1, 3, 4, 5, 11, 12, 1000)
        AND (riferimento_clienti.id_riferimento = 1
         OR riferimento_clienti.fatturazione = 1)
	 GROUP BY riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento;
    
END $$
DELIMITER ;
CALL sp_refresh_all_subsrib_company();
DROP PROCEDURE IF EXISTS sp_refresh_all_subsrib_company; 


DROP PROCEDURE IF EXISTS sp_refresh_all_not_subsrib_customer;
DELIMITER $$
CREATE PROCEDURE `sp_refresh_all_not_subsrib_customer`(
)
BEGIN
	DECLARE group_id INT;
    CALL sp_check_group_name('PRIVATI NON ABBONATI', 0, group_id);

    DELETE FROM mail_gruppo_cliente WHERE id_gruppo = group_id;

    INSERT INTO mail_gruppo_cliente
    SELECT riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento,
        group_id
    FROM riferimento_clienti
        INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
        INNER JOIN stato_clienti ON clienti.stato_cliente = stato_clienti.id_stato
        INNER JOIN impianto ON impianto.id_cliente = clienti.id_cliente AND impianto.stato = 0
    WHERE mail IS NOT NULL AND mail <> "" AND stato_clienti.nome IN ('ATTIVO')
    	AND clienti.Tipo_Cliente = 6
        AND (riferimento_clienti.id_riferimento = 1
            OR riferimento_clienti.fatturazione = 1)
	 GROUP BY riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento;
    
END $$
DELIMITER ;
CALL sp_refresh_all_not_subsrib_customer();
DROP PROCEDURE IF EXISTS sp_refresh_all_not_subsrib_customer; 


DROP PROCEDURE IF EXISTS sp_refresh_all_not_subsrib_company; 
DELIMITER $$
CREATE PROCEDURE `sp_refresh_all_not_subsrib_company`(
)
BEGIN
	DECLARE group_id INT;
    CALL sp_check_group_name('AZIENDE NON ABBONATE', 0, group_id);

    DELETE FROM mail_gruppo_cliente WHERE id_gruppo = group_id;

    INSERT INTO mail_gruppo_cliente
    SELECT riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento,
        group_id
    FROM riferimento_clienti
        INNER JOIN clienti ON clienti.id_cliente = riferimento_clienti.id_cliente
        INNER JOIN stato_clienti ON clienti.stato_cliente = stato_clienti.id_stato
        INNER JOIN impianto ON impianto.id_cliente = clienti.id_cliente AND impianto.stato = 0
    WHERE mail IS NOT NULL AND mail <> "" AND stato_clienti.nome IN ('ATTIVO')
    	AND clienti.Tipo_Cliente IN (1, 3, 4, 5, 11, 12, 1000)
        AND (riferimento_clienti.id_riferimento = 1
         OR riferimento_clienti.fatturazione = 1)
	 GROUP BY riferimento_clienti.id_cliente,
        riferimento_clienti.id_riferimento;
    
END $$
DELIMITER ;
CALL sp_refresh_all_not_subsrib_company();
DROP PROCEDURE IF EXISTS sp_refresh_all_not_subsrib_company; 


DROP PROCEDURE IF EXISTS sp_check_group_name;