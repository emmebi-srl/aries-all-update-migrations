INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Agente', 'Questo role identifica un agente', 'sales');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Agente Esperto', 'Questo role identifica un agente esperto', 'sales_senior');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Responsabile Agenti', 'Questo role identifica un responsabile degli agenti', 'sales_manager');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Tecnico', 'Questo role identifica un tecnico', 'technician');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Tecnico Esperto', 'Questo role identifica un tecnico esperto', 'technician_senior');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Responsabile Tecnici', 'Questo role identifica un tecnico', 'technicians_manager');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Addetto Logistica', 'Questo role identifica un addetto alla logistica', 'logistics_clerk');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Responsabile Logistica', 'Questo role identifica un responsabile alla logistica', 'logistics_manager');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Addetto Contabilita', 'Questo role identifica un addetto alla contabilita', 'accounting_clerk');
INSERT INTO `utente_roles` (`nome`, `descrizione`, `app_name`) VALUES ('Responsabile Contabilita', 'Questo role identifica un responsabile alla contabilita', 'accounting_manager');


DROP TABLE tablet_posizioni;
DROP TABLE tablet;



DROP PROCEDURE IF EXISTS sp_ariesUserRolesGetyUserId;
DROP PROCEDURE IF EXISTS sp_ariesUserRolesGetUserId;
DELIMITER //
CREATE PROCEDURE sp_ariesUserRolesGetUserId (
	IN user_id INT(11)
)
BEGIN
	SELECT 
		utente_roles.id, 
		utente_utente_roles.id_utente,
		nome, 
		descrizione,
		app_name
	FROM utente_roles
		INNER JOIN utente_utente_roles ON utente_utente_roles.id_utente_roles = utente_roles.id
	WHERE id_utente = user_id;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesUserRolesGet;
DELIMITER //
CREATE PROCEDURE sp_ariesUserRolesGet (
)
BEGIN
	SELECT 
		id,
		nome, 
		descrizione,
		app_name
	FROM utente_roles;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_userUpdate;
DELIMITER $$
CREATE PROCEDURE sp_userUpdate(
	userId INT, userName VARCHAR(60) , userPassword VARCHAR(60), description TEXT, email VARCHAR(100),
	emailSignature TEXT, calendar INT(11), smtp VARCHAR(45), port VARCHAR (45),
	emailUsername VARCHAR(45), emailPassword VARCHAR(45), 
	emailRequestConfirm BIT, emailUseSSL BIT, userType TINYINT(4))
BEGIN

	DECLARE allowUpdate BIT DEFAULT 1; 
	
	SET allowUpdate = CONCAT(userId, userName) IS NOT NULL;
	
	-- CONTROLLARE USERNAME PASSWORD E TIPO UTENTE

	IF allowUpdate THEN

		SELECT IFNULL(userName, `nome`), IFNULL(CAST(SHA1(CONCAT(userPassword, salt)) AS CHAR(40) CHARACTER SET latin1), `password`), 
			IFNULL(description, `descrizione`), IFNULL(email, `mail`), IFNULL(emailSignature, `firma`), IFNULL(calendar, `calendario`),
			IFNULL(smtp, `smtp`), IFNULL(port, `porta`), IFNULL(emailUsername, `nome_utente_mail`), IFNULL(emailPassword, `password_mail`), 
			IFNULL(userType, `tipo_utente`), IFNULL(emailUseSSL, `mssl`), IFNULL(emailRequestConfirm,`conferma`)
		INTO userName, userPassword, description, email, emailSignature, calendar, smtp,
			port, emailUsername, emailPassword, userType, emailUseSSL, emailRequestConfirm
		FROM utente
		WHERE id_utente = userId;
	
		UPDATE utente SET 
			`nome` = userName, 
			`password`= userPassword, 
			`descrizione` = description, 
			`mail` = email,
			`firma` = emailSignature,
			`calendario` = calendar,
			`smtp` = smtp,
			`porta` = port,
			`nome_utente_mail` = emailUsername,
			`password_mail` = emailPassword,
			`mssl` = emailUseSSL,
			`conferma` = emailRequestConfirm,
			`tipo_utente` = userType
		WHERE id_utente = userId;
		
	END IF;
	
END $$
DELIMITER ;