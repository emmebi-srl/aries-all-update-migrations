DROP PROCEDURE IF EXISTS sp_userInsert;
DELIMITER $$
CREATE PROCEDURE sp_userInsert(
	userName VARCHAR(60) , userPassword VARCHAR(60), description TEXT, email VARCHAR(100),
	emailSignature TEXT, calendar INT(11), smtp VARCHAR(45), port VARCHAR (45),
	emailUsername VARCHAR(45), emailPassword VARCHAR(45), userType TINYINT(4), 
	emailRequestConfirm BIT, emailUseSSL BIT, OUT userId INT)
BEGIN

	DECLARE allowInsert TINYINT DEFAULT 1; 

	DECLARE _salt CHAR(8) DEFAULT CAST(LEFT(SHA1(FLOOR(RAND() * POW(2, 32))), 8) AS CHAR(8) CHARACTER SET latin1);
	
	SET allowInsert = CONCAT(userName, userPassword) IS NOT NULL;
	SET userId = 0;
	
	SET emailRequestConfirm = IFNULL(emailRequestConfirm, 0);
	SET emailUseSSL = IFNULL(emailUseSSL, 0);
	
	IF allowInsert THEN
	
		SET userPassword = CAST(SHA1(CONCAT(userPassword, _salt)) AS CHAR(40) CHARACTER SET latin1);
	
		INSERT INTO utente SET 
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
			`tipo_utente` = userType,
			`mssl` = emailUseSSL,
			`conferma` = emailRequestConfirm,
			`salt` = _salt;
		
		SELECT LAST_INSERT_ID() INTO userId;
		
	END IF;
	
END $$
DELIMITER ;