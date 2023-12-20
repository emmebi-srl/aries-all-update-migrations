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