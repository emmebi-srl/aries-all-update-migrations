DELIMITER $$
CREATE PROCEDURE sp_tmp20150525()
BEGIN
	DECLARE _count INT;
	SELECT COUNT(*) 
	INTO _count
	FROM information_schema.COLUMNS cols
	WHERE TABLE_SCHEMA = DATABASE()
		AND TABLE_NAME = 'utente'
		AND COLUMN_NAME = 'salt';
	IF _count = 0 THEN
		ALTER TABLE utente
			ADD COLUMN salt VARCHAR(30) NOT NULL DEFAULT '';
	END IF;
END $$
DELIMITER ;
CALL sp_tmp20150525();
DROP PROCEDURE sp_tmp20150525;

DROP PROCEDURE IF EXISTS sp_login;
DELIMITER $$
CREATE PROCEDURE sp_login(username VARCHAR(50), pass VARCHAR(50), OUT userId INT)
BEGIN
	SELECT id_utente 
	INTO userId 
	FROM utente
	WHERE nome = username 
		AND password = CONVERT(SHA1(CONCAT(pass, salt)) USING latin1);
		
	SET userId = IFNULL(userId, 0);
	
END $$
DELIMITER ;

UPDATE utente SET 
	salt = IF(salt = '', CAST(LEFT(SHA1(FLOOR(RAND() * POW(2, 32))), 8) AS CHAR(30) CHARACTER SET latin1), salt)
WHERE TRUE;

UPDATE utente SET 
	password = SHA1(CONCAT(password, salt))
WHERE LENGTH(password) <> LENGTH(SHA1('sha1length'));
