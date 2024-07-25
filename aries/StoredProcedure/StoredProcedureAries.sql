-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versione server:              5.5.37 - MySQL Community Server (GPL)
-- S.O. server:                  Win32
-- HeidiSQL Versione:            9.1.0.4867
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


DROP PROCEDURE IF EXISTS `sp_ariesAgentSettingPercentagesCategoryGetById`;
DELIMITER //
CREATE PROCEDURE `sp_ariesAgentSettingPercentagesCategoryGetById`(
	IN enter_id INT(11)
)
BEGIN

	SELECT id,
		nome
	FROM preventivo_confcost_categoria
	WHERE id = enter_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesAgentSettingPercentagesGetByCategory
DROP PROCEDURE IF EXISTS `sp_ariesAgentSettingPercentagesGetByCategory`;
DELIMITER //
CREATE PROCEDURE `sp_ariesAgentSettingPercentagesGetByCategory`(
	IN category_id INT(11)
)
BEGIN

	SELECT id,
		costi,
		utile,
		agente,
		sconto,
		fattore1,
		fattore2, 
		id_categoria,
		data_ins, 
		utente_ins
	FROM preventivo_confcost
	WHERE id_categoria = category_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesAgentSettingPercentagesGetById
DROP PROCEDURE IF EXISTS `sp_ariesAgentSettingPercentagesGetById`;
DELIMITER //
CREATE PROCEDURE `sp_ariesAgentSettingPercentagesGetById`(
enter_id INT(11)
)
BEGIN

	SELECT id,
		costi,
		utile,
		agente,
		sconto,
		fattore1,
		fattore2, 
		id_categoria,
		data_ins, 
		utente_ins
	FROM preventivo_confcost
	WHERE Id = enter_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesAgentSettingPercentagesInsert
DROP PROCEDURE IF EXISTS `sp_ariesAgentSettingPercentagesInsert`;
DELIMITER //
CREATE PROCEDURE `sp_ariesAgentSettingPercentagesInsert`(
	IN fixed_costs_percentage DECIMAL(11,2),
	IN profit_percentage DECIMAL(11,2),
	IN sale_percentage DECIMAL(11,2),
	IN agents_percentage DECIMAL(11,2),
	IN first_factor DECIMAL(11,2),
	IN second_factor DECIMAL(11,2),
	IN category_id INT(11), 
	OUT result INT(11)
)
BEGIN

	INSERT INTO preventivo_confcost
	SET costi = fixed_costs_percentage,
		utile = profit_percentage,
		agente = agents_percentage,
		sconto = sale_percentage,
		fattore1 = first_factor,
		fattore2 = second_factor, 
		id_categoria = category_id,
		data_ins = NOW(), 
		utente_ins = @USER_ID;


	SET Result = LAST_INSERT_ID(); 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesAgentSettingPercentagesUpdate
DROP PROCEDURE IF EXISTS sp_ariesAgentSettingPercentagesUpdate;
DELIMITER //
CREATE PROCEDURE `sp_ariesAgentSettingPercentagesUpdate`(
	IN fixed_costs_percentage DECIMAL(11,2),
	IN profit_percentage DECIMAL(11,2),
	IN sale_percentage DECIMAL(11,2),
	IN agents_percentage DECIMAL(11,2),
	IN first_factor DECIMAL(11,2),
	IN second_factor DECIMAL(11,2),
	IN category_id INT(11), 
	IN enter_id INT(11),
	OUT result INT(11)
)
BEGIN

	UPDATE preventivo_confcost
	SET costi = fixed_costs_percentage,
		utile = profit_percentage,
		agente = agents_percentage,
		sconto = sale_percentage,
		fattore1 = first_factor,
		fattore2 = second_factor, 
		id_categoria = category_id,
		data_ins = NOW(), 
		utente_ins = @USER_ID
	WHERE id = enter_id;


	SET Result = 1; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankDelete
DROP PROCEDURE IF EXISTS sp_ariesBankDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM banca 
	WHERE id_banca = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankGet
DROP PROCEDURE IF EXISTS sp_ariesBankGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankGet`( 
)
BEGIN
	SELECT id_banca,
	Nome,
	IFNULL(abi, '') AS 'abi',  
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM banca
	ORDER BY id_banca;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankGetById
DROP PROCEDURE IF EXISTS sp_ariesBankGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankGetById`( 
	Bank_id INT
)
BEGIN
	SELECT id_banca,
	Nome,
	IFNULL(abi, '') AS 'abi',  
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM banca
	WHERE id_banca = Bank_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankGetByName
DROP PROCEDURE IF EXISTS sp_ariesBankGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankGetByName`( 
	name VARCHAR(45)
)
BEGIN
	SELECT id_banca,
	Nome,
	IFNULL(abi, '') AS 'abi',  
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM banca
	WHERE Nome = name;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankInsert
DROP PROCEDURE IF EXISTS sp_ariesBankInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankInsert`( 
	name VARCHAR(45),
	enter_abi VARCHAR(5),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	

	SELECT Count(Nome) INTO Result
	FROM Banca 
	WHERE Nome = Name; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Bank name already exists
	END IF;

	
	IF Result = 0 THEN
		INSERT INTO Banca 
		SET 
			Nome = name,
			abi = enter_abi, 
			Data_ins = NOW(), 
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesBankUpdate
DROP PROCEDURE IF EXISTS sp_ariesBankUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesBankUpdate`( 
	enter_id INTEGER,
	name VARCHAR(45),
	enter_abi VARCHAR(5),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	

	SELECT Count(Nome) INTO Result
	FROM banca 
	WHERE Nome = Name AND id_banca != enter_id; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Bank name already exists
	END IF;

	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Banca 
			WHERE id_banca = enter_id;
			
			IF Result = 0 THEN
				SET Result = -2; # Bank ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		
		
		UPDATE Banca 
		SET 
			Nome = name,
			abi = enter_abi, 
			Utente_mod = @USER_ID
		Where id_banca = enter_id;
		
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistElementTypeGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistElementTypeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistElementTypeGet`( )
BEGIN
        

	SELECT tipo_checklist_elemento.Id,
		tipo_checklist_elemento.Nome,
		IFNULL(tipo_checklist_elemento.Descrizione, "") Descrizione, 
		tipo_checklist_elemento.RifApplicazioni
	FROM tipo_checklist_elemento;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistElementTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistElementTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistElementTypeGetById`( IN element_type_id INT(11) )
BEGIN
        

	SELECT tipo_checklist_elemento.Id,
		tipo_checklist_elemento.Nome,
		IFNULL(tipo_checklist_elemento.Descrizione, "") Descrizione, 
		tipo_checklist_elemento.RifApplicazioni
	FROM tipo_checklist_elemento
	WHERE tipo_checklist_elemento.Id = element_type_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelDelete`( 
	IN enter_id INT(11),
	OUT result INT(11)
)
BEGIN
   
  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
   
	SELECT COUNT(checklist_model.id_check)
		INTO Result
	FROM checklist_model
	WHERE checklist_model.id_check = enter_id;
	
	IF Result > 0 THEN
		DELETE 	
		FROM checklist_model
		WHERE checklist_model.id_check = enter_id; 
	ELSE 
		SET Result = -4; -- checklist not found		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelDuplicate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelDuplicate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelDuplicate`( 
	IN enter_id INT(11),
	OUT result INT(11)
)
BEGIN

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE checklist_id INT(11);
	DECLARE cursor_id INT(11);
	DECLARE paragraph_id INT(11); 
	DECLARE exit_loop BOOLEAN;
	DECLARE paragraph_cursos CURSOR FOR SELECT id FROM checklist_model_paragrafo WHERE id_checklist = enter_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SELECT COUNT(checklist_model.id_check)
		INTO Result
	FROM checklist_model
	WHERE checklist_model.id_check = enter_id;
	
	IF Result > 0 THEN
		INSERT INTO checklist_model (`Id_check_parent`, `nome`, `descrizione`, `note`, `tipo_impianto`,
			`Stato`, `Data_ins`, `Data_mod`, `Utente_ins`, `Utente_mod`)
		SELECT
			`Id_check_parent`,
			`nome`,
			`descrizione`,
			`note` ,
			`tipo_impianto`,
			`Stato`,
			NOW(),
			NOW(),
			@USER_ID,
			@USER_ID
		FROM checklist_model 
		WHERE Id_check = enter_id;
		
		SET checklist_id = LAST_INSERT_ID();
		SET Result = checklist_id;
		
		INSERT INTO `checklist_model_impianto` (`id_checklist`, `id_impianto`, `Data_ins`,`Utente_ins`)
		SELECT 
			checklist_id,
			`id_impianto`,
			NOW(),
			@USER_ID
		FROM checklist_model_impianto
		WHERE Id_checklist = enter_id;
		
		
		-- open the cursor
		OPEN paragraph_cursos;
		
		-- start looping
		paragrah_loop: LOOP
		-- read the name from next row into the variables 
		FETCH  paragraph_cursos INTO cursor_id;
		IF exit_loop THEN
			CLOSE paragraph_cursos;
			LEAVE paragrah_loop;
		END IF;
		
		INSERT INTO `checklist_model_paragrafo` (`id_checklist`, `nome`, `descrizione`, `ordine`, `Data_ins`,
			`Data_mod`, `Utente_ins`, Utente_mod)
		SELECT
			checklist_id,
			`nome`,
			`descrizione`,
			`ordine`,
			NOW(),
			NOW(), 
			@USER_ID, 
			@USER_ID
		FROM checklist_model_paragrafo
		WHERE id = cursor_id;	
		
		SET paragraph_id = LAST_INSERT_ID();
		
		INSERT INTO `checklist_model_elemento` (`Id_paragrafo`, `Id_checklist`, `Posizione`, `tipo_elemento`, `nome`,
			`descrizione`, `indicazioni`, `Id_elemento`, `Data_ins`, `Data_mod`, `Utente_ins`, `Utente_mod`)
		SELECT
			paragraph_id,
			checklist_id,
			`Posizione`,
			`tipo_elemento`,
			`nome`,
			`descrizione`,
			`indicazioni`,
			`Id_elemento`,
			NOW(),
			NOW(), 
			@USER_ID, 
			@USER_ID
		FROM checklist_model_elemento
		WHERE id_paragrafo = cursor_id;
			
		END LOOP paragrah_loop;

		
	ELSE 
		SET Result = -4; -- checklist not found		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDefValueDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDefValueDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDefValueDelete`( 
	IN element_id INT(11),
	OUT result INT(11)
)
BEGIN


	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	DELETE FROM checklist_model_elemento_def_valore 
	WHERE Id_elemento = element_id;
	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDefValueGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDefValueGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDefValueGet`( 
)
BEGIN
	SELECT 	
		IFNULL(checklist_model_elemento_def_valore.Id, -1) AS Id,
		checklist_model_elemento_def_valore.id_elemento,
		tipo_checklist_model_elemento_def_valore.Id as Id_tipo_def_val,
		tipo_checklist_model_elemento_def_valore.Nome AS Label,
		tipo_checklist_model_elemento_def_valore.Field As Field,
		tipo_checklist_model_elemento_def_valore.Field_type As Field_type,
		checklist_model_elemento_def_valore.Value,
		IFNULL(checklist_model_elemento_def_valore.Data_mod, NOW()) AS Data_mod,
		IFNULL(Utente_mod, @USER_ID) AS Utente_mod
	FROM checklist_model_elemento_def_valore
		INNER JOIN tipo_checklist_model_elemento_def_valore
		ON checklist_model_elemento_def_valore.Id_tipo_def_val = tipo_checklist_model_elemento_def_valore.Id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDefValueGetByElement
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDefValueGetByElement;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDefValueGetByElement`( 
	IN element_id INT(11), 
	IN element_type INT(11)
)
BEGIN
	SELECT 	
		IFNULL(checklist_model_elemento_def_valore.Id, -1) AS Id,
		element_id AS id_elemento,
		tipo_checklist_model_elemento_def_valore.Id as Id_tipo_def_val,
		tipo_checklist_model_elemento_def_valore.Nome AS Label,
		tipo_checklist_model_elemento_def_valore.Field As Field,
		tipo_checklist_model_elemento_def_valore.Field_type As Field_type,
		checklist_model_elemento_def_valore.Value,
		IFNULL(checklist_model_elemento_def_valore.Data_mod, NOW()) AS Data_mod,
		IFNULL(Utente_mod, @USER_ID) AS Utente_mod
	FROM tipo_checklist_model_elemento_def_valore
		LEFT JOIN checklist_model_elemento_def_valore
		ON checklist_model_elemento_def_valore.Id_tipo_def_val = tipo_checklist_model_elemento_def_valore.Id
			AND checklist_model_elemento_def_valore.ID_elemento = element_id
	WHERE Id_tipo = element_type;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDefValueInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDefValueInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDefValueInsert`( 
	IN field VARCHAR(100),
	IN label VARCHAR(100),
	IN value MEDIUMTEXT,
	IN element_id INT(11),
	IN element_type INT(11),
	OUT result INT(11)
)
BEGIN

	
	SET Result = 0;

	SELECT COUNT(Id) 
		INTO Result
	FROM checklist_model_elemento 
	WHERE Id = element_id; 

	IF Result = 0 THEN
		SET Result = -1; -- element not found
	END IF;
	
	IF Result >= 0 THEN
	
		INSERT INTO checklist_model_elemento_def_valore 
		SET 
	      `Id_elemento` = element_id,
		  `Id_tipo_def_val` = element_type,
	      `Label` = label,
	      `Field` = field,
	      `Value` = value,
	      `Data_mod` = NOW(),
	      `Utente_mod` = @USER_ID;
		 
		 SET Result  = LAST_INSERT_ID();
		 
	END IF; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDefValueUpdate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDefValueUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDefValueUpdate`( 
	IN field VARCHAR(100),
	IN label VARCHAR(100),
	IN value MEDIUMTEXT,
	IN element_id INT(11),
	IN element_type INT(11),
	IN enter_id INT(11),
	OUT result INT(11)
)
BEGIN


	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = 0;

	SELECT COUNT(Id) 
		INTO Result
	FROM checklist_model_elemento 
	WHERE Id = element_id; 

	IF Result = 0 THEN
		SET Result = -1; -- element not found
	END IF;
	
	IF Result >= 0 THEN
	
		UPDATE checklist_model_elemento_def_valore 
		SET 
	      `Id_elemento` = element_id,
		  `Id_tipo_def_val` = element_type,
	      `Label` = label,
	      `Field` = field,
	      `Value` = value,
	      `Data_mod` = NOW(),
	      `Utente_mod` = @USER_ID
		 WHERE Id = enter_id;
		 
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementDelete`( 
	IN enter_id INT(11),
	OUT Result INT(11)
)
BEGIN
   
  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
   
	SELECT COUNT(checklist_model_elemento_generico.Id_elemento)
		INTO Result
	FROM checklist_model_elemento_generico
	WHERE checklist_model_elemento_generico.Id_elemento = enter_id;
	
	IF Result > 0 THEN
		DELETE 	
		FROM checklist_model_elemento_generico
		WHERE checklist_model_elemento_generico.Id_elemento = enter_id; 
	ELSE 
		SET Result = -3; -- checklist element not found		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementGet`( )
BEGIN
        

	SELECT checklist_model_elemento_generico.Id_elemento,
		checklist_model_elemento_generico.tipo_elemento,
		checklist_model_elemento_generico.nome, 
		checklist_model_elemento_generico.Descrizione, 
		checklist_model_elemento_generico.Indicazioni,
		checklist_model_elemento_generico.Data_mod,
		checklist_model_elemento_generico.Data_ins,
		checklist_model_elemento_generico.Utente_ins, 
		checklist_model_elemento_generico.Utente_mod 
	FROM checklist_model_elemento_generico;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementGetById`( 
	enter_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_elemento_generico.Id_elemento,
		checklist_model_elemento_generico.tipo_elemento,
		checklist_model_elemento_generico.nome, 
		checklist_model_elemento_generico.Descrizione, 
		checklist_model_elemento_generico.Indicazioni,
		checklist_model_elemento_generico.Data_mod,
		checklist_model_elemento_generico.Data_ins,
		checklist_model_elemento_generico.Utente_ins, 
		checklist_model_elemento_generico.Utente_mod 
	FROM checklist_model_elemento_generico
	WHERE checklist_model_elemento_generico.Id_elemento = enter_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementGetByName
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementGetByName`( 
	IN name VARCHAR(150) 
)
BEGIN
    
	SELECT checklist_model_elemento_generico.Id_elemento,
		checklist_model_elemento_generico.tipo_elemento,
		checklist_model_elemento_generico.nome, 
		checklist_model_elemento_generico.Descrizione, 
		checklist_model_elemento_generico.Indicazioni,
		checklist_model_elemento_generico.Data_mod,
		checklist_model_elemento_generico.Data_ins,
		checklist_model_elemento_generico.Utente_ins, 
		checklist_model_elemento_generico.Utente_mod 
	FROM checklist_model_elemento_generico
	WHERE checklist_model_elemento_generico.nome = name;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementInsert`( 
	IN element_type INT(11), 
	IN name VARCHAR(45), 
	IN description TEXT,
	IN employee_indications VARCHAR(500), 
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(checklist_model_elemento_generico.Id_Elemento)
		INTO Result
	FROM checklist_model_elemento_generico
	WHERE 
		checklist_model_elemento_generico.tipo_elemento = element_type
		AND checklist_model_elemento_generico.nome = name
		AND checklist_model_elemento_generico.Indicazioni = employee_indications; 
	
	IF Result > 0 THEN
		SET Result = -1; -- checklist model element already exists
	ELSE
		SELECT COUNT(tipo_checklist_elemento.Id)
			INTO Result 
		FROM tipo_checklist_elemento
		WHERE tipo_checklist_elemento.Id = element_type;
		
		IF Result <= 0 THEN
			SET Result = -2; -- element type not found
		END IF; 	
	END IF; 
	
	IF Result >= 0 THEN
		INSERT INTO checklist_model_elemento_generico
		SET checklist_model_elemento_generico.tipo_elemento = element_type,
			checklist_model_elemento_generico.nome = name, 
			checklist_model_elemento_generico.descrizione = description, 
			checklist_model_elemento_generico.Indicazioni = employee_indications, 
			checklist_model_elemento_generico.Data_ins = NOW(), 
			checklist_model_elemento_generico.Data_mod = NOW(), 
			checklist_model_elemento_generico.Utente_ins = @USER_ID, 
			checklist_model_elemento_generico.Utente_mod = @USER_ID; 
			
			SET Result = LAST_INSERT_ID();
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelElementUpdate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelElementUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelElementUpdate`( 
	IN enter_id INT(11),
	IN element_type INT(11), 
	IN name VARCHAR(45), 
	IN description TEXT,
	IN employee_indications VARCHAR(500), 
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(checklist_model_elemento_generico.Id_Elemento)
		INTO Result
	FROM checklist_model_elemento_generico
	WHERE 
		checklist_model_elemento_generico.id_elemento = enter_id; 
	
	IF Result <= 0 THEN
		SET Result = -3; -- checklist model element already exists
	ELSE
		SELECT COUNT(tipo_checklist_elemento.Id)
			INTO Result 
		FROM tipo_checklist_elemento
		WHERE tipo_checklist_elemento.Id = element_type;
		
		IF Result <= 0 THEN
			SET Result = -2; -- element type not found
		END IF; 	
	END IF; 
	
	IF Result >= 0 THEN
	
		UPDATE checklist_model_elemento_generico
		SET checklist_model_elemento_generico.tipo_elemento = element_type,
			checklist_model_elemento_generico.nome = name, 
			checklist_model_elemento_generico.descrizione = description, 
			checklist_model_elemento_generico.Indicazioni = employee_indications, 
			checklist_model_elemento_generico.Data_mod = NOW(), 
			checklist_model_elemento_generico.Utente_mod = @USER_ID
		WHERE Id_elemento = enter_id; 
			
			SET Result = 1;
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelGet`( )
BEGIN
        

	SELECT checklist_model.id_check,
		IFNULL(checklist_model.Id_check_parent, 0) Id_check_parent,
		checklist_model.nome, 
		Checklist_model.Descrizione, 
		Checklist_model.Note,
		IFNULL(Checklist_model.tipo_impianto, 0) tipo_impianto, 
		Checklist_model.Stato,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01 00:00:00', '%Y-%m-%d')) Data_mod,
		IFNULL(Data_ins, STR_TO_DATE( '1970-01-01 00:00:00', '%Y-%m-%d')) Data_ins,
		Checklist_model.Utente_ins, 
		IFNULL(Checklist_model.Utente_mod, 0) Utente_mod 
	FROM Checklist_model
	ORDER BY Id_check desc;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelGetById`( 
	enter_id INT(11) 
)
BEGIN
        

	SELECT checklist_model.id_check,
		IFNULL(checklist_model.Id_check_parent, 0) Id_check_parent,
		checklist_model.nome, 
		Checklist_model.Descrizione, 
		Checklist_model.Note,
		IFNULL(Checklist_model.tipo_impianto, 0) tipo_impianto, 
		Checklist_model.Stato,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01 00:00:00', '%Y-%m-%d')) Data_mod,
		IFNULL(Data_ins, STR_TO_DATE( '1970-01-01 00:00:00', '%Y-%m-%d')) Data_ins,
		Checklist_model.Utente_ins, 
		IFNULL(Checklist_model.Utente_mod, 0) Utente_mod 
	FROM Checklist_model
	WHERE Checklist_model.id_check = enter_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelInsert`( 
	IN parent_id INT(11), 
	IN name VARCHAR(45),
	IN description VARCHAR(300), 
	IN notes VARCHAR(200), 
	IN system_type_id SMALLINT(6), 
	IN `status` TINYINT(4),
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(tipo_impianto.id_tipo)
		INTO Result
	FROM tipo_impianto
	WHERE tipo_impianto.id_tipo = system_type_id; 
	
	IF Result = 0 THEN
		SET Result = -1; -- system type not found
	ELSE
		SELECT COUNT(checklist_model.id_check)
			INTO Result
		FROM checklist_model
		WHERE checklist_model.nome = name;
		
		IF Result > 0 THEN
			SET Result = -2; -- already exists checklist with this name
		ELSE 
			IF parent_id > 0 THEN 
				SELECT COUNT(checklist_model.id_check)
					INTO Result
				FROM checklist_model
				WHERE checklist_model.id_check_parent = parent_id;
				
				IF Result = 0 THEN
					SET Result = -3; -- not found parent checklist
				END IF; 
				
			END IF; 
		END IF; 
	END IF; 
	
	IF Result >= 0 THEN
		INSERT INTO checklist_model 
		SET checklist_model.Id_check_parent = IF(parent_id = 0, NULL, parent_id),
			checklist_model.nome = name, 
			checklist_model.descrizione = description, 
			checklist_model.note = notes, 
			checklist_model.tipo_impianto = system_type_id, 
			checklist_model.Stato = `status`, 
			checklist_model.Data_ins = NOW(), 
			checklist_model.Utente_ins = @USER_ID, 
			checklist_model.Utente_mod = @USER_ID; 
			
			SET Result = LAST_INSERT_ID();
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphDelete`( 
	IN enter_id INT(11),
	OUT Result INT(11)
)
BEGIN
  DECLARE checklist_id INT(11);
  
  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
   
	SELECT COUNT(Id), Id_Checklist
		INTO Result, checklist_id
	FROM checklist_model_paragrafo
	WHERE checklist_model_paragrafo.Id = enter_id;
	
	IF Result > 0 THEN
		DELETE 	
		FROM checklist_model_paragrafo
		WHERE checklist_model_paragrafo.Id = enter_id; 
		
		CALL sp_ariesChecklistModelParagraphSortAll (checklist_id, enter_id, -1);
	ELSE 
		SET Result = -2; -- checklist paragrph not found		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphDuplicate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphDuplicate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphDuplicate`( 
	IN enter_id INT(11),
	OUT Result INT(11)
)
BEGIN
   
    DECLARE checklist_id INT(10) DEFAULT 0;
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
		
	SELECT id_checklist 
		INTO checklist_id
	FROM checklist_model_paragrafo
	WHERE id = enter_id;
	
	START TRANSACTION;
	
	INSERT INTO `checklist_model_paragrafo` (`id_checklist`, `nome`, `descrizione`, `ordine`, `Data_ins`,
		`Data_mod`, `Utente_ins`, Utente_mod)
	SELECT
		checklist_id,
		`nome`,
		`descrizione`,
		IFNULL((SELECT MAX(ordine) + 1 FROM checklist_model_paragrafo WHERE id_checklist = checklist_id) ,1),
		NOW(),
		NOW(), 
		@USER_ID, 
		@USER_ID
	FROM checklist_model_paragrafo
	WHERE id = enter_id;	
	
	SET Result = LAST_INSERT_ID();
	
	INSERT INTO `checklist_model_elemento` (`Id_paragrafo`, `Id_checklist`, `Posizione`, `tipo_elemento`, `nome`,
		`descrizione`, `indicazioni`, `Id_elemento`, `Data_ins`, `Data_mod`, `Utente_ins`, `Utente_mod`)
	SELECT
		Result,
		checklist_id,
		`Posizione`,
		`tipo_elemento`,
		`nome`,
		`descrizione`,
		`indicazioni`,
		`Id_elemento`,
		NOW(),
		NOW(), 
		@USER_ID, 
		@USER_ID
	FROM checklist_model_elemento
	WHERE id_paragrafo = enter_id;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementDelete`( 
	IN enter_id INT(11),
	OUT Result INT(11)
)
BEGIN
  DECLARE paragraph_id INT(11);
  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
   
	SELECT COUNT(checklist_model_elemento.Id), Id_paragrafo
		INTO Result, paragraph_id
	FROM checklist_model_elemento
	WHERE checklist_model_elemento.Id = enter_id;
	
	IF Result > 0 THEN
		DELETE 	
		FROM checklist_model_elemento
		WHERE checklist_model_elemento.Id = enter_id; 
		
		CALL sp_ariesChecklistModelParagraphElementSortAll(paragraph_id, enter_id, -1);
	ELSE 
		SET Result = -3; -- checklist paragraph element not found		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementGetById`( 
	enter_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_elemento.Id,
		checklist_model_elemento.Id_paragrafo,
		checklist_model_elemento.Id_checklist, 
		checklist_model_elemento.Id_elemento, 
		checklist_model_elemento.Posizione,
		checklist_model_elemento.tipo_elemento,
		checklist_model_elemento.nome, 
		checklist_model_elemento.Descrizione, 
		checklist_model_elemento.Indicazioni,
		checklist_model_elemento.Data_mod,
		checklist_model_elemento.Data_ins,
		checklist_model_elemento.Utente_ins, 
		checklist_model_elemento.Utente_mod 
	FROM checklist_model_elemento
	WHERE checklist_model_elemento.Id = enter_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementGetByParagraph
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementGetByParagraph;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementGetByParagraph`( 
	paragraph_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_elemento.Id,
		checklist_model_elemento.Id_paragrafo,
		checklist_model_elemento.Id_checklist, 
		checklist_model_elemento.Id_elemento, 
		checklist_model_elemento.Posizione,
		checklist_model_elemento.tipo_elemento,
		checklist_model_elemento.nome, 
		checklist_model_elemento.Descrizione, 
		checklist_model_elemento.Indicazioni,
		checklist_model_elemento.Data_mod,
		checklist_model_elemento.Data_ins,
		checklist_model_elemento.Utente_ins, 
		checklist_model_elemento.Utente_mod 
	FROM checklist_model_elemento
	WHERE checklist_model_elemento.Id_paragrafo = paragraph_id
	ORDER BY Posizione;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementInsert`( 
	IN paragraph_id INT(11), 
	IN element_id INT(11),
	IN `order` SMALLINT(6), 
	IN `element_type` TINYINT(4) ,
	IN `name` VARCHAR(45),
	IN `description` TEXT,
	IN `employee_indications`VARCHAR(500),
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE checklist_id INT(11); 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	

	SELECT COUNT(checklist_model_paragrafo.Id), 
			checklist_model_paragrafo.id_checklist
		INTO Result, checklist_id
	FROM checklist_model_paragrafo
	WHERE checklist_model_paragrafo.Id = paragraph_id;
	
	IF Result = 0 THEN
		SET Result = -2; -- paragraph not found
	END IF; 	

	IF Result >= 0 THEN

		INSERT INTO checklist_model_elemento
		SET checklist_model_elemento.id_elemento = element_id,
			checklist_model_elemento.id_checklist = checklist_id, 
			checklist_model_elemento.id_paragrafo = paragraph_id, 
			checklist_model_elemento.tipo_elemento = element_type,
			checklist_model_elemento.nome = name, 
			checklist_model_elemento.Descrizione = description, 
			checklist_model_elemento.Indicazioni = employee_indications,
			checklist_model_elemento.Posizione = `order`, 
			checklist_model_elemento.Data_ins = NOW(), 
			checklist_model_elemento.Data_mod = NOW(), 
			checklist_model_elemento.Utente_ins = @USER_ID, 
			checklist_model_elemento.Utente_mod = @USER_ID; 
			
		SET Result = LAST_INSERT_ID();
		
		CALL sp_ariesChecklistModelParagraphElementSortAll(paragraph_id, Result, `order`);
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementSortAll
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementSortAll;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementSortAll`( 
	IN `paragraph_id` INT(11),
	IN element_id INT(11), 
	IN `new_element_position` INT(11)
)
BEGIN

	If new_element_position >= 0 THEN
		UPDATE checklist_model_elemento
		SET Posizione = Posizione + 1
		WHERE (Id <> element_id AND Posizione >= new_element_position AND Id_paragrafo = paragraph_id);
	END IF;
	
	set @fakeId=0;
	UPDATE checklist_model_elemento
	SET Posizione = getFakeId()
	WHERE Id_paragrafo = paragraph_id
	ORDER BY Posizione;
	
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphElementUpdate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphElementUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphElementUpdate`( 
	IN enter_id INT(11),
	IN paragraph_id INT(11), 
	IN element_id INT(11),
	IN `element_type` TINYINT(4) ,
	IN `name` VARCHAR(45),
	IN `description` TEXT,
	IN `employee_indications`VARCHAR(500),
	IN `order` SMALLINT(6), 
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE checklist_id INT(11); 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;

	SELECT COUNT(checklist_model_paragrafo.Id), 
			checklist_model_paragrafo.id_checklist
		INTO Result, checklist_id
	FROM checklist_model_paragrafo
	WHERE checklist_model_paragrafo.Id = paragraph_id;
	
	IF Result = 0 THEN
		SET Result = -2; -- paragraph not found
	END IF; 	

	
	IF Result >= 0 THEN
	
		UPDATE checklist_model_elemento
		SET checklist_model_elemento.id_elemento = element_id,
			checklist_model_elemento.id_checklist = checklist_id, 
			checklist_model_elemento.id_paragrafo = paragraph_id, 
			checklist_model_elemento.Posizione = `order`, 
			checklist_model_elemento.tipo_elemento = element_type,
			checklist_model_elemento.nome = name, 
			checklist_model_elemento.Descrizione = description, 
			checklist_model_elemento.Indicazioni = employee_indications,
			checklist_model_elemento.Data_ins = NOW(), 
			checklist_model_elemento.Data_mod = NOW(), 
			checklist_model_elemento.Utente_ins = @USER_ID, 
			checklist_model_elemento.Utente_mod = @USER_ID
		WHERE id = enter_id;
		
		CALL sp_ariesChecklistModelParagraphElementSortAll(paragraph_id, enter_id, `order`);
		
		SET Result = 1;
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphGet`( )
BEGIN
        

	SELECT checklist_model_paragrafo.id,
		checklist_model_paragrafo.id_checklist,
		checklist_model_paragrafo.nome, 
		checklist_model_paragrafo.Descrizione, 
		checklist_model_paragrafo.Ordine,
		Data_mod,
		Data_ins,
		checklist_model_paragrafo.Utente_ins, 
		Utente_mod 
	FROM checklist_model_paragrafo;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphGetByChecklistId
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphGetByChecklistId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphGetByChecklistId`( 
	checklist_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_paragrafo.id,
		checklist_model_paragrafo.id_checklist,
		checklist_model_paragrafo.nome, 
		checklist_model_paragrafo.Descrizione, 
		checklist_model_paragrafo.Ordine,
		Data_mod,
		Data_ins,
		checklist_model_paragrafo.Utente_ins, 
		Utente_mod 
	FROM checklist_model_paragrafo
	WHERE checklist_model_paragrafo.id_checklist = checklist_id
	ORDER BY checklist_model_paragrafo.Ordine;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphGetById`( 
	IN enter_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_paragrafo.id,
		checklist_model_paragrafo.id_checklist,
		checklist_model_paragrafo.nome, 
		checklist_model_paragrafo.Descrizione, 
		checklist_model_paragrafo.Ordine,
		Data_mod,
		Data_ins,
		checklist_model_paragrafo.Utente_ins, 
		Utente_mod 
	FROM checklist_model_paragrafo
	WHERE checklist_model_paragrafo.id = enter_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphInsert`( 
	IN checklist_id INT(11), 
	IN name VARCHAR(100), 
	IN description TEXT,
	IN `order` SMALLINT(6), 
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(checklist_model.Id_check)
		INTO Result
	FROM checklist_model
	WHERE checklist_model.Id_check = checklist_id; 
	
	IF Result = 0 THEN
		SET Result = -1; -- checklist not found
	END IF; 
	
	IF Result >= 0 THEN
		SET Result = 0;
	
		INSERT INTO checklist_model_paragrafo 
		SET checklist_model_paragrafo.id_checklist = checklist_id,
			checklist_model_paragrafo.nome = name, 
			checklist_model_paragrafo.descrizione = description, 
			checklist_model_paragrafo.ordine = `order`, 
			checklist_model_paragrafo.Data_ins = NOW(), 
			checklist_model_paragrafo.Utente_ins = @USER_ID, 
			checklist_model_paragrafo.Utente_mod = @USER_ID; 
			
		SET Result = LAST_INSERT_ID();
				
		CALL sp_ariesChecklistModelParagraphSortAll(checklist_id, Result, `order`);
		
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphSortAll
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphSortAll;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphSortAll`( 
	IN checklist_id INT(11),
	IN paragraph_id INT(11), 
	IN new_paragraph_position INT(11)
)
BEGIN

	If new_paragraph_position >= 0 THEN
		UPDATE checklist_model_paragrafo
		SET Ordine = Ordine + 1
		WHERE (Id <> paragraph_id AND Ordine >= new_paragraph_position AND Id_checklist = checklist_id);
	END IF;
	
	set @fakeId=0;
	UPDATE checklist_model_paragrafo
	SET Ordine = getFakeId()
	WHERE Id_checklist = checklist_id
	ORDER BY Ordine;
	
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelParagraphUpdate
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelParagraphUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelParagraphUpdate`( 
	IN paragraph_id INT(11), 
	IN checklist_id INT(11), 
	IN name VARCHAR(100), 
	IN description TEXT,
	IN `order` SMALLINT(6), 
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE old_order INT(11) DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(checklist_model.Id_check)
		INTO Result
	FROM checklist_model
	WHERE checklist_model.Id_check = checklist_id; 
	
	IF Result = 0 THEN
		SET Result = -1; -- checklist not found
	END IF; 
	
	
	IF Result >= 0 THEN
	
		UPDATE checklist_model_paragrafo 
		SET checklist_model_paragrafo.id_checklist = checklist_id,
			checklist_model_paragrafo.nome = name, 
			checklist_model_paragrafo.descrizione = description, 
			checklist_model_paragrafo.ordine = `order`, 
			checklist_model_paragrafo.Utente_mod = @USER_ID
		WHERE checklist_model_paragrafo.Id = paragraph_id; 	
		
		CALL sp_ariesChecklistModelParagraphSortAll(checklist_id, paragraph_id, `order`);
		
		SET Result = 1;
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelPragraphElementGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelPragraphElementGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelPragraphElementGet`( )
BEGIN
        

	SELECT checklist_model_elemento.Id,
		checklist_model_elemento.Id_paragrafo,
		checklist_model_elemento.Id_checklist, 
		checklist_model_elemento.Id_elemento, 
		checklist_model_elemento.Posizione,
		checklist_model_elemento.tipo_elemento,
		checklist_model_elemento.nome, 
		checklist_model_elemento.Descrizione, 
		checklist_model_elemento.Indicazioni,
		checklist_model_elemento.Data_mod,
		checklist_model_elemento.Data_ins,
		checklist_model_elemento.Utente_ins, 
		checklist_model_elemento.Utente_mod 
	FROM checklist_model_elemento;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemDelete
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelSystemDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelSystemDelete`( 
	IN enter_id INT(11),
	OUT Result INT(11)
)
BEGIN
   
  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
   
	SELECT COUNT(checklist_model_impianto.Id_elemento)
		INTO Result
	FROM checklist_model_impianto
	WHERE checklist_model_impianto.Id = enter_id;
	
	IF Result > 0 THEN
		DELETE 	
		FROM checklist_model_impianto
		WHERE checklist_model_impianto.Id = enter_id; 
	ELSE 
		SET Result = -4; -- nnot found	
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemDelete
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_ariesChecklistModelSystemDeleteByChecklist`;
CREATE  PROCEDURE `sp_ariesChecklistModelSystemDeleteByChecklist`( 
	IN checklist_id INT(11)
)
BEGIN
	DELETE 	
	FROM checklist_model_impianto
	WHERE checklist_model_impianto.Id_checklist = checklist_id;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemGet
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelSystemGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelSystemGet`( )
BEGIN
	SELECT checklist_model_impianto.Id,
		checklist_model_impianto.id_impianto,
		checklist_model_impianto.Id_checklist, 
		checklist_model_impianto.Data_ins,
		checklist_model_impianto.Utente_ins
	FROM checklist_model_impianto;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemGetByChecklistId
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelSystemGetByChecklistId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelSystemGetByChecklistId`( 
	checklist_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_impianto.Id,
		checklist_model_impianto.id_impianto,
		checklist_model_impianto.Id_checklist, 
		checklist_model_impianto.Data_ins,
		checklist_model_impianto.Utente_ins
	FROM checklist_model_impianto
	WHERE checklist_model_impianto.Id_checklist = checklist_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemGetById
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelSystemGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelSystemGetById`( 
	enter_id INT(11) 
)
BEGIN
        

	SELECT checklist_model_impianto.Id,
		checklist_model_impianto.id_impianto,
		checklist_model_impianto.Id_checklist, 
		checklist_model_impianto.Data_ins,
		checklist_model_impianto.Utente_ins
	FROM checklist_model_impianto
	WHERE checklist_model_impianto.Id = enter_id;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelSystemInsert
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelSystemInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesChecklistModelSystemInsert`( 
	IN system_id INT(11), 
	IN checklist_id INT(11),
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE checklist_id INT(11); 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	
	SELECT COUNT(checklist_model_impianto.Id)
		INTO Result
	FROM checklist_model_impianto
	WHERE 
		checklist_model_impianto.id_impianto = system_id AND checklist_model_impianto.id_checklist = checklist_id; 
	
	IF Result > 0 THEN
		SET Result = -1; -- System already associated
	ELSE
		SELECT COUNT(impianto.Id)
			INTO Result
		FROM impianto
		WHERE impianto.Id_impianto = system_id;
		
		IF Result = 0 THEN
			SET Result = -2; -- system not found
		ELSE	
			SELECT COUNT(Checklist_model.Id_check) 
				INTO Result
			FROM Checklist_model
			WHERE Checklist_model.Id_check = checklist_id;
			
			IF Result = 0 THEN
				SET Result = -3; -- checklist not found
			END IF; 
		END IF; 	
	END IF; 
	
	IF Result >= 0 THEN
		INSERT INTO checklist_model_impianto
		SET checklist_model_impianto.id_impianto = system_id,
			checklist_model_impianto.id_checklist = checklist_id, 
			checklist_model_impianto.Data_ins = NOW(), 
			checklist_model_impianto.Utente_ins = @USER_ID; 
			
			SET Result = LAST_INSERT_ID();
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesChecklistModelUpdate

DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesChecklistModelUpdate;
CREATE  PROCEDURE `sp_ariesChecklistModelUpdate`( 
	IN enter_id INT(11), 
	IN parent_id INT(11), 
	IN name VARCHAR(45),
	IN description VARCHAR(300), 
	IN notes VARCHAR(200), 
	IN system_type_id SMALLINT(6), 
	IN `status` TINYINT(4),
	OUT result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = -1; 
	
	SELECT COUNT(tipo_impianto.id_tipo)
		INTO Result
	FROM tipo_impianto
	WHERE tipo_impianto.id_tipo = system_type_id; 
	
	IF Result = 0 THEN
		SET Result = -1; -- system type not found
	ELSE
		SELECT COUNT(checklist_model.id_check)
			INTO Result
		FROM checklist_model
		WHERE checklist_model.nome = name and checklist_model.id_check <> enter_id;
		
		IF Result > 0 THEN
			SET Result = -2; -- already exists checklist with this name
		ELSE 
			IF parent_id > 0 THEN 
				SELECT COUNT(checklist_model.id_check)
					INTO Result
				FROM checklist_model
				WHERE checklist_model.id_check_parent = parent_id;
				
				IF Result = 0 THEN
					SET Result = -3; -- not found parent checklist
				END IF; 
				
			END IF; 
		END IF; 
	END IF; 
	
	IF Result >= 0 THEN
		UPDATE checklist_model 
		SET checklist_model.Id_check_parent = IF(parent_id = 0, NULL, parent_id),
			checklist_model.nome = name, 
			checklist_model.descrizione = description, 
			checklist_model.note = notes, 
			checklist_model.tipo_impianto = system_type_id, 
			checklist_model.Stato = `status`, 
			checklist_model.Data_mod = NOW(), 
			checklist_model.Utente_mod = @USER_ID
		WHERE checklist_model.id_check = enter_id;
			
			SET Result = 1;
	END IF; 
		
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCompanyGet
DROP PROCEDURE IF EXISTS sp_ariesCompanyGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCompanyGet`( 
)
BEGIN
	SELECT id_azienda as "id_azienda",
	IFNULL(titolare, "") as "titolare",
	IFNULL(ragione_sociale, "") as "ragione_sociale",
	IFNULL(settore, "") as "settore",
	IFNULL(indirizzo, "") as "indirizzo",
	IFNULL(comune, "") as "comune",
	IFNULL(provincia, "") as "provincia",
	IFNULL(telefono, "") as "telefono",
	cellulare as "cellulare",
	IFNULL(partita_iva, "") as "partita_iva",
	IFNULL(regImprese, 0) as "regImprese",
	IFNULL(alboProvinciale, 0) as "alboProvinciale",
	IFNULL(ciaa, "") as "ciaa",
	IFNULL(ciaa_n, "") as "ciaa_n",
	IFNULL(albo_provincia, "") as "albo_provincia",
	IFNULL(albo_n, "") as "albo_n",
	IFNULL(numero, "") as "numero",
	IFNULL(sito_internet, "") as "sito_internet",
	IFNULL(fax, "") as "fax",
	IFNULL(e_mail, "") as "e_mail",
	IFNULL(cod_fis, "") as "cod_fis",
	IFNULL(numero_rea, "") as "numero_rea",
	IFNULL(posizione_inps, "") as "posizione_inps",
	IFNULL(posizione_inail, "") as "posizione_inail",
	IFNULL(codice_ateco, "") as "codice_ateco",
	IFNULL(assicu_rct, "") as "assicu_rct",
	IFNULL(frazione, "") as "frazione",
	IFNULL(capi_soc, "") as "capi_soc",
	data as "data",
	IFNULL(abilitazione, "") as "abilitazione",
	IFNULL(smtp, "") as "smtp",
	IFNULL(porta, 0) as "porta",
	mssl as "mssl",
	IFNULL(utente_mail, "") as "utente_mail",
	IFNULL(password, "") as "password",
	IFNULL(nome_mail, "") as "nome_mail",
	id_filiale,
	IFNULL(banca, "") as "banca",
	IFNULL(iban, "") as "iban",
	listino as "listino",
	sconto as "sconto",
	tipo_sconto as "tipo_sconto",
	stampa_ragione as "stampa_ragione",
	stampa_ri as "stampa_ri",
	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",
	IFNULL(cap2, "") as "cap2",
	IFNULL(stampante_promemoria, "") as "stampante_promemoria",
	IFNULL(mail_amministrazione, "") as "mail_amministrazione",
	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",
	IFNULL(host_caldav, "") as "host_caldav",
	IFNULL(nome_caldav, "") as "nome_caldav",
	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",
	IFNULL(license, "") as "license",
	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",
	IFNULL(tele_fatt, "") as "tele_fatt",
	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",
	IFNULL(notifica_attesa, 0) as "notifica_attesa",
	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",
	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",
	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",
	IFNULL(regime_fiscale, "") as "regime_fiscale",
	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine,
	Data_ins, 
	Data_mod, 
	Utente_ins,
	Utente_mod
	FROM Azienda; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCompanyGetById
DROP PROCEDURE IF EXISTS sp_ariesCompanyGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCompanyGetById`( 
	company_id INT
)
BEGIN
	SELECT id_azienda as "id_azienda",
	IFNULL(titolare, "") as "titolare",
	IFNULL(ragione_sociale, "") as "ragione_sociale",
	IFNULL(settore, "") as "settore",
	IFNULL(indirizzo, "") as "indirizzo",
	IFNULL(comune, "") as "comune",
	IFNULL(provincia, "") as "provincia",
	IFNULL(telefono, "") as "telefono",
	cellulare as "cellulare",
	IFNULL(partita_iva, "") as "partita_iva",
	IFNULL(regImprese, 0) as "regImprese",
	IFNULL(alboProvinciale, 0) as "alboProvinciale",
	IFNULL(ciaa, "") as "ciaa",
	IFNULL(ciaa_n, "") as "ciaa_n",
	IFNULL(albo_provincia, "") as "albo_provincia",
	IFNULL(albo_n, "") as "albo_n",
	IFNULL(numero, "") as "numero",
	IFNULL(sito_internet, "") as "sito_internet",
	IFNULL(fax, "") as "fax",
	IFNULL(e_mail, "") as "e_mail",
	IFNULL(cod_fis, "") as "cod_fis",
	IFNULL(numero_rea, "") as "numero_rea",
	IFNULL(posizione_inps, "") as "posizione_inps",
	IFNULL(posizione_inail, "") as "posizione_inail",
	IFNULL(codice_ateco, "") as "codice_ateco",
	IFNULL(assicu_rct, "") as "assicu_rct",
	IFNULL(frazione, "") as "frazione",
	IFNULL(capi_soc, "") as "capi_soc",
	data as "data",
	IFNULL(abilitazione, "") as "abilitazione",
	IFNULL(smtp, "") as "smtp",
	IFNULL(porta, 0) as "porta",
	mssl as "mssl",
	IFNULL(utente_mail, "") as "utente_mail",
	IFNULL(password, "") as "password",
	IFNULL(nome_mail, "") as "nome_mail",
	id_filiale,
	IFNULL(banca, "") as "banca",
	IFNULL(iban, "") as "iban",
	listino as "listino",
	sconto as "sconto",
	tipo_sconto as "tipo_sconto",
	stampa_ragione as "stampa_ragione",
	stampa_ri as "stampa_ri",
	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",
	IFNULL(cap2, "") as "cap2",
	IFNULL(stampante_promemoria, "") as "stampante_promemoria",
	IFNULL(mail_amministrazione, "") as "mail_amministrazione",
	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",
	IFNULL(host_caldav, "") as "host_caldav",
	IFNULL(nome_caldav, "") as "nome_caldav",
	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",
	IFNULL(license, "") as "license",
	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",
	IFNULL(tele_fatt, "") as "tele_fatt",
	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",
	IFNULL(notifica_attesa, 0) as "notifica_attesa",
	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",
	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",
	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",
	IFNULL(regime_fiscale, "") as "regime_fiscale",
	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine,
	Data_ins, 
	Data_mod, 
	Utente_ins,
	Utente_mod
	FROM Azienda WHERE Id_azienda = company_id; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCompanyGetMostRecent
DROP PROCEDURE IF EXISTS sp_ariesCompanyGetMostRecent;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCompanyGetMostRecent`( 
)
BEGIN
	SELECT id_azienda as "id_azienda",
	IFNULL(titolare, "") as "titolare",
	IFNULL(ragione_sociale, "") as "ragione_sociale",
	IFNULL(settore, "") as "settore",
	IFNULL(indirizzo, "") as "indirizzo",
	IFNULL(comune, "") as "comune",
	IFNULL(provincia, "") as "provincia",
	IFNULL(telefono, "") as "telefono",
	cellulare as "cellulare",
	IFNULL(partita_iva, "") as "partita_iva",
	IFNULL(regImprese, 0) as "regImprese",
	IFNULL(alboProvinciale, 0) as "alboProvinciale",
	IFNULL(ciaa, "") as "ciaa",
	IFNULL(ciaa_n, "") as "ciaa_n",
	IFNULL(albo_provincia, "") as "albo_provincia",
	IFNULL(albo_n, "") as "albo_n",
	IFNULL(numero, "") as "numero",
	IFNULL(sito_internet, "") as "sito_internet",
	IFNULL(fax, "") as "fax",
	IFNULL(e_mail, "") as "e_mail",
	IFNULL(cod_fis, "") as "cod_fis",
	IFNULL(numero_rea, "") as "numero_rea",
	IFNULL(posizione_inps, "") as "posizione_inps",
	IFNULL(posizione_inail, "") as "posizione_inail",
	IFNULL(codice_ateco, "") as "codice_ateco",
	IFNULL(assicu_rct, "") as "assicu_rct",
	IFNULL(frazione, "") as "frazione",
	IFNULL(capi_soc, "") as "capi_soc",
	data as "data",
	IFNULL(abilitazione, "") as "abilitazione",
	IFNULL(smtp, "") as "smtp",
	IFNULL(porta, 0) as "porta",
	mssl as "mssl",
	IFNULL(utente_mail, "") as "utente_mail",
	IFNULL(password, "") as "password",
	IFNULL(nome_mail, "") as "nome_mail",
	id_filiale,
	IFNULL(banca, "") as "banca",
	IFNULL(iban, "") as "iban",
	listino as "listino",
	sconto as "sconto",
	tipo_sconto as "tipo_sconto",
	stampa_ragione as "stampa_ragione",
	stampa_ri as "stampa_ri",
	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",
	IFNULL(cap2, "") as "cap2",
	IFNULL(stampante_promemoria, "") as "stampante_promemoria",
	IFNULL(mail_amministrazione, "") as "mail_amministrazione",
	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",
	IFNULL(host_caldav, "") as "host_caldav",
	IFNULL(nome_caldav, "") as "nome_caldav",
	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",
	IFNULL(license, "") as "license",
	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",
	IFNULL(tele_fatt, "") as "tele_fatt",
	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",
	IFNULL(notifica_attesa, 0) as "notifica_attesa",
	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",
	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",
	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",
	IFNULL(regime_fiscale, "") as "regime_fiscale",
	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine,
	Data_ins, 
	Data_mod, 
	Utente_ins,
	Utente_mod
	FROM Azienda ORDER BY Id_azienda DESC LIMIT 1; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryDelete
DROP PROCEDURE IF EXISTS sp_ariesCountryDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM Nazione 
	WHERE id_Nazione = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryGet
DROP PROCEDURE IF EXISTS sp_ariesCountryGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryGet`( 
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	ORDER BY Id_nazione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryGetById
DROP PROCEDURE IF EXISTS sp_ariesCountryGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryGetById`( 
	Country_id INT
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	WHERE Id_nazione = Country_id
	ORDER BY Id_nazione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryGetByMunicipality
DROP PROCEDURE IF EXISTS sp_ariesCountryGetByMunicipality;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryGetByMunicipality`( 
	municipality_id INT
)
BEGIN


	DECLARE countryId INT(11); 
	
	SELECT Nazione.Id_nazione 
		into countryId 
	FROM comune
		INNER JOIN province ON comune.id_provincia = province.id_provincia 
		INNER JOIN regione ON Regione.id_regione = province.Regione 
		INNER JOIN Nazione on id_nazione = regione.nazione
	WHERE comune.Id_comune = municipality_id; 

	CALL sp_ariesCountryGetById(countryId);

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryGetByName
DROP PROCEDURE IF EXISTS sp_ariesCountryGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryGetByName`( 
	name VARCHAR(30)
)
BEGIN
	SELECT Id_nazione,
	Nome,
	sigla,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Nazione
	WHERE Nome = name
	ORDER BY Id_nazione;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryInsert
DROP PROCEDURE IF EXISTS sp_ariesCountryInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryInsert`( 
	name VARCHAR(45),
	abbreviation varchar(10),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT Count(id_nazione) INTO Result
	FROM Nazione 
	WHERE Nome = Name; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Country name already exists
	END IF;

	
	IF Result = 0 THEN
		INSERT INTO Nazione 
		SET 
			Nome = name,
			sigla = Abbreviation, 
			Data_ins = NOW(), 
			Data_mod = NOW(), 
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCountryUpdate
DROP PROCEDURE IF EXISTS sp_ariesCountryUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCountryUpdate`( 
	enter_id INTEGER,
	name VARCHAR(45),
	abbreviation varchar(10),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT Count(Id_nazione) INTO Result
	FROM Nazione 
	WHERE Nome = Name AND Id_nazione != enter_id; 
	
	IF Result > 0 THEN
		 SET Result = -1; # Country name already exists
	END IF;

	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Nazione 
			WHERE id_Nazione = enter_id;
			
			IF Result = 0 THEN
				SET Result = -2; # Country ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		UPDATE Nazione 
		SET 
			Nome = name,
			sigla = Abbreviation, 
			Utente_mod = @USER_ID
		Where id_Nazione = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGet
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsGet`()
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_riferimento, 
		Nome, 
		Figura, 
		Telefono, 
		altro_telefono, 
		fax, 
		mail,
		centralino, 
		IF(Fatturazione = 1, 1, 0) AS 'Fatturazione',
		titolo, 
		nota_cli, 
		esterno, 
		sito, 
		skype, 
		rif_esterno, 
		sito_utente, 
		sito_passwd, 
		mail_pec, 
		`mod`, 
		IFNULL(idut, 0) "idut",
		Promemoria_cliente
	FROM riferimento_clienti;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsGetByCustomerId`(
	IN customer_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_riferimento, 
		Nome, 
		Figura, 
		Telefono, 
		altro_telefono, 
		fax, 
		mail,
		centralino, 
		IF(Fatturazione = 1, 1, 0) AS 'Fatturazione',
		titolo, 
		nota_cli, 
		esterno, 
		sito, 
		skype, 
		rif_esterno, 
		sito_utente, 
		sito_passwd, 
		mail_pec, 
		`mod`, 
		IFNULL(idut, 0) "idut",
		Promemoria_cliente
	FROM riferimento_clienti
	WHERE Id_cliente = customer_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGetByCustomerIdAndContactsId
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsGetByCustomerIdAndContactsId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsGetByCustomerIdAndContactsId`(
	IN customer_id INT,
	IN contacts_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_riferimento, 
		Nome, 
		Figura, 
		Telefono, 
		altro_telefono, 
		fax, 
		mail,
		centralino, 
		IF(Fatturazione = 1, 1, 0) AS 'Fatturazione',
		titolo, 
		nota_cli, 
		esterno, 
		sito, 
		skype, 
		rif_esterno, 
		sito_utente, 
		sito_passwd, 
		mail_pec, 
		`mod`, 
		IFNULL(idut, 0) "idut",
		Promemoria_cliente
	FROM riferimento_clienti
	WHERE Id_cliente = customer_id AND Id_riferimento = contacts_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGetByCustomerIds
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsGetByCustomerIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsGetByCustomerIds`(
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT 
		Id, 
		Id_cliente, 
		Id_riferimento, 
		Nome, 
		Figura, 
		Telefono, 
		altro_telefono, 
		fax, 
		mail,
		centralino, 
		IF(Fatturazione = 1, 1, 0) AS 'Fatturazione',
		titolo, 
		nota_cli, 
		esterno, 
		sito, 
		skype, 
		rif_esterno, 
		sito_utente, 
		sito_passwd, 
		mail_pec, 
		`mod`, 
		IFNULL(idut, 0) "idut",
		Promemoria_cliente
	FROM riferimento_clienti
	WHERE FIND_IN_SET(Id_cliente, customer_ids) > 0;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGetByEmailGroupToSend
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsGetByEmailGroupToSend;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsGetByEmailGroupToSend`(
	IN email_group_id INT(11), 
	IN email_id INT(11)
)
BEGIN

	SELECT 
		Id, 
		riferimento_clienti.Id_cliente, 
		riferimento_clienti.Id_riferimento, 
		riferimento_clienti.Nome, 
		Figura, 
		Telefono, 
		altro_telefono, 
		fax, 
		mail,
		centralino, 
		IF(Fatturazione = 1, 1, 0) AS 'Fatturazione',
		titolo, 
		nota_cli, 
		esterno, 
		sito, 
		skype, 
		rif_esterno, 
		sito_utente, 
		sito_passwd, 
		mail_pec, 
		`mod`, 
		IFNULL(idut, 0) "idut",
		Promemoria_cliente
	FROM mail_gruppo_cliente
		INNER JOIN riferimento_clienti ON mail_gruppo_cliente.id_cliente = riferimento_clienti.id_cliente
			AND mail_gruppo_cliente.Id_riferimento = riferimento_clienti.Id_riferimento
			
		LEFT JOIN mail_gruppo_inviate ON mail_gruppo_inviate.id_mail = email_id
			AND mail_gruppo_cliente.id_cliente = mail_gruppo_inviate.id_cliente
			AND mail_gruppo_cliente.Id_riferimento = mail_gruppo_inviate.Id_riferimento	
				
	WHERE mail_gruppo_cliente.id_gruppo = email_group_id AND mail_gruppo_inviate.stato IS NULL; 
	  
		
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsSetAsBilling
DROP PROCEDURE IF EXISTS sp_ariesCustomerContactsSetAsBilling;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerContactsSetAsBilling`(
	IN customer_id INT,
	IN contact_id INT, 
	OUT result INT
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	UPDATE riferimento_clienti 
	SET Fatturazione = 1, 
		IDUT = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_riferimento = contact_id; 
	
	UPDATE riferimento_clienti 
	SET Fatturazione = 0, 
		IDUT = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_riferimento <> contact_id;
			
	SET Result = 1; 
	

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationGet
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationGet`()
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationGetByCustomerId`(
	IN customer_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE Id_cliente = customer_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationGetByCustomerIdAndDestinationId
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationGetByCustomerIdAndDestinationId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationGetByCustomerIdAndDestinationId`(
	IN customer_id INT,
	IN destination_id INT
)
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE Id_cliente = customer_id AND Id_destinazione = destination_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationGetByCustomerIds
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationGetByCustomerIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationGetByCustomerIds`(
	IN customer_ids MEDIUMTEXT
)
BEGIN

	SELECT DISTINCT
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE("1970-01-01 00:00:00", "%y-%m-&d %h:%i:%s")) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE FIND_IN_SET(Id_cliente,customer_ids) > 0;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationGetWithoutDistanceAndTime
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationGetWithoutDistanceAndTime;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationGetWithoutDistanceAndTime`()
BEGIN
	SELECT 
		Id, 
		Id_cliente, 
		Id_destinazione, 
		IFNULL(Provincia, "") Provincia, 
		IFNULL(Comune, 0) Comune, 
		IFNULL(Frazione, 0) Frazione,
		IFNULL(Indirizzo, "") Indirizzo, 
		IFNULL(numero_civico, 0) Numero_civico, 
		Descrizione, 
		IFNULL(Scala, "") Scala, 
		IFNULL(Altro, "") Altro, 
		IFNULL(Km_sede, 0) Km_sede, 
		IFNULL(Pedaggio, 0) Pedaggio, 
		IFNULL(Tempo_strada, 0) Tempo_strada,
		IFNULL(Attivo, 0) Attivo, 
		ztl, 
		IFNULL(Note, "") Note, 
	   Autostrada, 
		Sede_principale,
		Dalle1,
		Alle1,
		Dalle2,
		Alle2,
		IFNULL(Piano, 0) Piano, 
		IFNULL(Interno, 0) Interno, 
		IFNULL(Id_autostrada, 0) Id_autostrada,
		IFNULL(Longitudine, 0) Longitudine,
		IFNULL(Latitudine, 0) Latitudine, 
		IFNULL(Data_ins, STR_TO_DATE('1970-01-01 00:00:00', '%y-%m-&d %h:%i:%s')) Data_ins,
		Data_mod,
		IFNULL(Utente_ins, 0) Utente_ins,
		IFNULL(Utente_mod, 0) Utente_mod
	FROM destinazione_cliente
	WHERE (Km_sede = 0 
		and Tempo_strada = 0 
		and comune IS NOT NULL 
		and indirizzo IS NOT NULL 
		and indirizzo <> "");
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationInsert
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationInsert`(
  IN customer_id INT(11),
  IN province VARCHAR(5),
  IN municipality_id INT(11),
  IN district_id INT(11),
  IN street VARCHAR(50),
  IN street_number SMALLINT(6),
  IN description VARCHAR(105),
  IN stair VARCHAR(6),
  IN other VARCHAR(9),
  IN distance SMALLINT(6),
  IN toll DECIMAL(11,2),
  IN trip_time SMALLINT(6),
  IN is_active BIT,
  IN is_limited_traffic_zone BIT,
  IN notes TEXT,
  IN has_speedway BIT,
  IN is_main_destination BIT,
  IN from_morning TIME,
  IN to_morning TIME,
  IN from_afternoon TIME,
  IN to_afternoon TIME,
  IN floor TINYINT,
  IN intern TINYINT,
  IN speedway_id INT,
  IN latitude DECIMAL (11,8),
  IN longitude DECIMAL (11,8),
  OUT result INT,
  OUT destination_id INT
)
BEGIN
	
	DECLARE tmp_province VARCHAR(5) DEFAULT NULL;
	DECLARE tmp_municipality_id INT(11) DEFAULT NULL;
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SELECT COUNT(Id_cliente)
		INTO result 
	FROM clienti 
	WHERE Id_cliente = customer_id; 
	
	IF result = 0 THEN
		SET result = -1; -- customer not found
	ELSE
	
		IF province IS NOT NULL THEN
		
		  SELECT COUNT(province.Sigla)
		 	INTO result
		  FROM province 
		  WHERE province.Sigla = province;
		    
		END IF; 
		
		IF result = 0 THEN
			SET result = -7; -- province not found
		ELSE
			IF municipality_id IS NOT NULL THEN
			
				SELECT COUNT(Id_comune), comune.provincia
					INTO result, tmp_province 
				FROM comune 
				WHERE comune.Id_comune = municipality_id; 
				
				IF result = 0 THEN
					SET result = -2; -- municipality not found
				ELSE
					IF province <> tmp_province THEN
						SET result = -3; -- invalid province by municipality id
					END IF;			
				END IF; 
				
				IF result > 0 AND district_id IS NOT NULL THEN
				
					SELECT COUNT(Id_frazione), frazione.Id_comune
						INTO result, tmp_municipality_id 
					FROM frazione 
					WHERE frazione.Id_frazione = district_id; 
					
					IF result = 0 THEN
						SET result = -4; -- distirct not found
					ELSE
						IF municipality_id <> tmp_municipality_id THEN
							SET result = -5; -- invalid municipality id by destrict id
						END IF;			
					END IF; 
				
				END IF; 
				
				IF result > 0 AND speedway_id IS NOT NULL THEN
					
					SELECT id_autostrada
						INTO result
					FROM tipo_autostrada 
					WHERE tipo_autostrada.Id_tipo = speedway_id; 
	
					IF result = 0 THEN
						SET result = -6; -- speedway not found
					END IF; 
				END IF; 						
			END IF;
		END IF; 
	END IF;   		
	

	IF result > 0 THEN
	
		SELECT IFNULL(id_destinazione + 1, 1)
			INTO destination_id
		FROM destinazione_cliente 
		WHERE id_cliente = customer_id; 
		
		INSERT INTO destinazione_cliente
		SET  
			Id_cliente = customer_id, 
			Id_destinazione = destination_id, 
			Provincia = province, 
			Comune = municipality_id, 
			Frazione = district_id,
			Indirizzo = street, 
			Numero_civico = street_number, 
			Descrizione = description, 
			Scala = stair, 
			Altro = other, 
			Km_sede = distance, 
			Pedaggio = toll,
			Tempo_strada = trip_time, 
			Attivo = is_active, 
			ztl = is_limited_traffic_zone, 
			Note = notes, 
			Autostrada = has_speedway, 
			Sede_principale = is_main_destination,
			Dalle1 = from_morning,
			Alle1 = to_morning,
			Dalle2 = from_afternoon,
			Alle2 = to_afternoon,
			Piano = stair, 
			Interno = intern, 
			Id_autostrada = speedway_id,
			Longitudine = longitude,
			Latitudine = latitude, 
			Data_ins = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
			
			IF is_main_destination THEN
				CALL sp_ariesCustomerDestinationSetAsMainDestination(customer_id, destination_id, @Result);
			END IF; 
		 
		SET Result = LAST_INSERT_ID(); 
			
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationResetAllDistance
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationResetAllDistance;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationResetAllDistance`(
)
BEGIN
	UPDATE destinazione_cliente 
	SET tempo_strada = 0,
		km_sede = 0;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerDestinationSetAsMainDestination
DROP PROCEDURE IF EXISTS sp_ariesCustomerDestinationSetAsMainDestination;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerDestinationSetAsMainDestination`(
	IN customer_id INT,
	IN destination_id INT, 
	OUT result INT
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	UPDATE destinazione_cliente 
	SET Sede_principale = True, 
		Utente_mod = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_destinazione = destination_id; 
	
	UPDATE destinazione_cliente 
	SET Sede_principale = False, 
		Utente_mod = @USER_ID
	WHERE Id_cliente = customer_id AND
			Id_destinazione <> destination_id;
			
	SET Result = 1; 
	

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGet
DROP PROCEDURE IF EXISTS sp_ariesCustomerGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGet`(
)
BEGIN

	SELECT `Id_cliente`,
		`Ragione_Sociale` ,
		IFNULL(`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(`Partita_iva` , '') Partita_iva,
		IFNULL(`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(`Stato_cliente`,'') Stato_cliente,
		IFNULL(`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(`stato_economico`, 0) 'stato_economico',
		IFNULL(`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(`Sito_internet` , '') Sito_internet,
		IFNULL(`password`, '') 'password',
		IFNULL(`Utente_sito`, '') Utente_sito,
		IFNULL(`iva` ,0) 'iva',
		`modi`,
		`rc` ,
		`posta` ,
		IFNULL(`ex` , 0) ex,
		IFNULL(`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(`id_utente` , 0) id_utente,
		IFNULL(`id_agente` , 0) id_agente,
		IFNULL(`id_abbona` , 0) id_abbona,
		IFNULL(`id_attività` , 0) id_attività,
		IFNULL(`pec`, '') pec ,
		IFNULL(`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		`data_ultima_modifica`
	FROM Clienti; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetById
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetById`(
	customerId INT(11)
)
BEGIN

	SELECT `Id_cliente`,
		`Ragione_Sociale` ,
		IFNULL(`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(`Partita_iva` , '') Partita_iva,
		IFNULL(`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(`Stato_cliente`,'') Stato_cliente,
		IFNULL(`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(`stato_economico`, 0) 'stato_economico',
		IFNULL(`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(`Sito_internet` , '') Sito_internet,
		IFNULL(`password`, '') 'password',
		IFNULL(`Utente_sito`, '') Utente_sito,
		IFNULL(`iva` ,0) 'iva',
		`modi`,
		`rc` ,
		`posta` ,
		IFNULL(`ex` , 0) ex,
		IFNULL(`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(`id_utente` , 0) id_utente,
		IFNULL(`id_agente` , 0) id_agente,
		IFNULL(`id_abbona` , 0) id_abbona,
		IFNULL(`id_attività` , 0) id_attività,
		IFNULL(`pec`, '') pec ,
		IFNULL(`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		`data_ultima_modifica`
	FROM Clienti
	WHERE Id_cliente = customerId; 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetByIds
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetByIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetByIds`(
	IN idArray MEDIUMTEXT
	)
BEGIN

  SELECT DISTINCT Clienti.`Id_cliente`,
		Clienti.Ragione_Sociale ,
		IFNULL(Clienti.`Ragione_sociale2`, "") Ragione_Sociale2,
		IFNULL(Clienti.`Partita_iva` , "") Partita_iva,
		IFNULL(Clienti.`Codice_Fiscale`, "") Codice_fiscale,
		IFNULL(Clienti.`Cortese_attenzione`, "") Cortese_attenzione,
		STR_TO_DATE( IFNULL(Clienti.`Data_inserimento`, "1970-01-01 00:00:00"), "%Y-%m-%d") data_inserimento,
		IFNULL(Clienti.`Stato_cliente`,"") Stato_cliente,
		IFNULL(Clienti.`Tipo_Cliente`, 0) "Tipo_cliente",
		IFNULL(Clienti.`stato_economico`, 0) "stato_economico",
		IFNULL(Clienti.`condizione_pagamento`, 0 ) "condizione_pagamento",
		IFNULL(Clienti.`Sito_internet` , "") Sito_internet,
		IFNULL(Clienti.`password`, "") password,
		IFNULL(Clienti.`Utente_sito`, "") Utente_sito,
		IFNULL(Clienti.`iva` ,0) iva,
		Clienti.`modi`,
		Clienti.`rc` ,
		Clienti.`posta` ,
		IFNULL(Clienti.`ex` , 0) ex,
		IFNULL(Clienti.`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(Clienti.`id_utente` , 0) id_utente,
		IFNULL(Clienti.`id_agente` , 0) id_agente,
		IFNULL(Clienti.`id_abbona` , 0) id_abbona,
		IFNULL(Clienti.`id_attività` , 0) id_attività,
		IFNULL(Clienti.`pec`, "") pec ,
		IFNULL(Clienti.`codice_univoco`, "") codice_univoco,
		e_codice_destinatario,
		Clienti.`data_ultima_modifica`
	FROM Clienti
  WHERE FIND_IN_SET(id_cliente ,idArray) > 0;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetByTicketStatus
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetByTicketStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetByTicketStatus`( 
	statusTicket INT(11)
)
BEGIN

	SELECT Clienti.`Id_cliente`,
		Clienti.`Ragione_Sociale` ,
		IFNULL(Clienti.`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(Clienti.`Partita_iva` , '') Partita_iva,
		IFNULL(Clienti.`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(Clienti.`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(Clienti.`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(Clienti.`Stato_cliente`,'') Stato_cliente,
		IFNULL(Clienti.`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(Clienti.`stato_economico`, 0) 'stato_economico',
		IFNULL(Clienti.`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(Clienti.`Sito_internet` , '') Sito_internet,
		IFNULL(Clienti.`password`, '') 'password',
		IFNULL(Clienti.`Utente_sito`, '') Utente_sito,
		IFNULL(Clienti.`iva` ,0) 'iva',
		Clienti.`modi`,
		Clienti.`rc` ,
		Clienti.`posta` ,
		IFNULL(Clienti.`ex` , 0) ex,
		IFNULL(Clienti.`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(Clienti.`id_utente` , 0) id_utente,
		IFNULL(Clienti.`id_agente` , 0) id_agente,
		IFNULL(Clienti.`id_abbona` , 0) id_abbona,
		IFNULL(Clienti.`id_attività` , 0) id_attività,
		IFNULL(Clienti.`pec`, '') pec ,
		IFNULL(Clienti.`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		Clienti.`data_ultima_modifica`
	FROM Clienti
		INNER JOIN Ticket 
		ON Clienti.Id_cliente = Ticket.Id_impianto AND Ticket.Stato_ticket = statusTicket; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetOrderByCompanyName
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetOrderByCompanyName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetOrderByCompanyName`(
)
BEGIN

	SELECT `Id_cliente`,
		`Ragione_Sociale` ,
		IFNULL(`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(`Partita_iva` , '') Partita_iva,
		IFNULL(`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(`Stato_cliente`,'') Stato_cliente,
		IFNULL(`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(`stato_economico`, 0) 'stato_economico',
		IFNULL(`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(`Sito_internet` , '') Sito_internet,
		IFNULL(`password`, '') 'password',
		IFNULL(`Utente_sito`, '') Utente_sito,
		IFNULL(`iva` ,0) 'iva',
		`modi`,
		`rc` ,
		`posta` ,
		IFNULL(`ex` , 0) ex,
		IFNULL(`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(`id_utente` , 0) id_utente,
		IFNULL(`id_agente` , 0) id_agente,
		IFNULL(`id_abbona` , 0) id_abbona,
		IFNULL(`id_attività` , 0) id_attività,
		IFNULL(`pec`, '') pec ,
		IFNULL(`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		`data_ultima_modifica`
	FROM Clienti
	ORDER BY Clienti.Ragione_Sociale; 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetOrderByCompanyName
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetByTagId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetByTagId`(
	tag_id INT
)
BEGIN

	SELECT clienti.Id_cliente,
		`Ragione_Sociale` ,
		IFNULL(`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(`Partita_iva` , '') Partita_iva,
		IFNULL(`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(`Stato_cliente`,'') Stato_cliente,
		IFNULL(`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(`stato_economico`, 0) 'stato_economico',
		IFNULL(`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(`Sito_internet` , '') Sito_internet,
		IFNULL(`password`, '') 'password',
		IFNULL(`Utente_sito`, '') Utente_sito,
		IFNULL(`iva` ,0) 'iva',
		`modi`,
		`rc` ,
		`posta` ,
		IFNULL(`ex` , 0) ex,
		IFNULL(`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(`id_utente` , 0) id_utente,
		IFNULL(`id_agente` , 0) id_agente,
		IFNULL(`id_abbona` , 0) id_abbona,
		IFNULL(`id_attività` , 0) id_attività,
		IFNULL(`pec`, '') pec ,
		IFNULL(`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		`data_ultima_modifica`
	FROM Clienti
		INNER JOIN cliente_tag ON clienti.Id_cliente = cliente_tag.id_cliente
	WHERE cliente_tag.id_tag = tag_id; 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesCustomerGetOrderByCompanyName
DROP PROCEDURE IF EXISTS sp_ariesCustomerGetByCompanyName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGetByCompanyName`(
	company_name VARCHAR(150)
)
BEGIN

	SELECT clienti.Id_cliente,
		`Ragione_Sociale` ,
		IFNULL(`Ragione_sociale2`, '') Ragione_Sociale2,
		IFNULL(`Partita_iva` , '') Partita_iva,
		IFNULL(`Codice_Fiscale`, '') Codice_fiscale,
		IFNULL(`Cortese_attenzione`, '') 'Cortese_attenzione',
		STR_TO_DATE( IFNULL(`Data_inserimento`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_inserimento,
		IFNULL(`Stato_cliente`,'') Stato_cliente,
		IFNULL(`Tipo_Cliente`, 0) 'Tipo_cliente',
		IFNULL(`stato_economico`, 0) 'stato_economico',
		IFNULL(`condizione_pagamento`, 0 ) 'condizione_pagamento',
		IFNULL(`Sito_internet` , '') Sito_internet,
		IFNULL(`password`, '') 'password',
		IFNULL(`Utente_sito`, '') Utente_sito,
		IFNULL(`iva` ,0) 'iva',
		`modi`,
		`rc` ,
		`posta` ,
		IFNULL(`ex` , 0) ex,
		IFNULL(`tipo_rapporto`  , 0) tipo_rapporto,
		IFNULL(`id_utente` , 0) id_utente,
		IFNULL(`id_agente` , 0) id_agente,
		IFNULL(`id_abbona` , 0) id_abbona,
		IFNULL(`id_attività` , 0) id_attività,
		IFNULL(`pec`, '') pec ,
		IFNULL(`codice_univoco`, '') codice_univoco,
		e_codice_destinatario,
		`data_ultima_modifica`
	FROM Clienti
	WHERE (ragione_sociale = company_name) OR (ragione_sociale2 = company_name)
	ORDER BY clienti.Stato_cliente LIKE 'clLime' DESC; 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesCustomerGroupEmailSent
DROP PROCEDURE IF EXISTS sp_ariesCustomerGroupEmailSent;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGroupEmailSent`()
BEGIN
	SELECT 
		Id_mail, 
		Id_riferimento, 
		id_cliente, 
		Stato, 
		IFNULL(Codice_errore, 0) Codice_errore,
		Messaggio_errore, 
		Timestamp
	FROM mail_gruppo_inviate;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGroupEmailSentByEmailId
DROP PROCEDURE IF EXISTS sp_ariesCustomerGroupEmailSentByEmailId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGroupEmailSentByEmailId`(
	IN email_id INT(11) 
)
BEGIN
	SELECT 
		Id_mail, 
		Id_riferimento, 
		id_cliente, 
		Stato, 
		IFNULL(Codice_errore, 0) Codice_errore,
		Messaggio_errore, 
		Timestamp
	FROM mail_gruppo_inviate
	WHERE Id_mail = email_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerGroupEmailSentInsert
DROP PROCEDURE IF EXISTS sp_ariesCustomerGroupEmailSentInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerGroupEmailSentInsert`(
	IN email_id INT(11), 
	IN contact_id INT(11), 
	IN customer_id INT(11), 
	IN is_sent BIT(1), 
	IN error_code INT(11), 
	IN error_message VARCHAR(200), 
	OUT result SMALLINT
)
BEGIN

	
	INSERT INTO mail_gruppo_inviate 
	SET
		Id_mail = email_id, 
		Id_riferimento = contact_id, 
		id_cliente = customer_id, 
		Stato = is_sent, 
		Codice_errore = error_code,
		Messaggio_errore = error_message;
		
	SET result = 1; 	
	
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtGetById
DROP PROCEDURE IF EXISTS sp_ariesDdtGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtGetById`( 
enter_id INT, 
enter_year INT
)
BEGIN
        
	SELECT 
		ddt.`Id_ddt`,
		ddt.`anno` ,
		IFNULL(`id_cliente`, 0) id_cliente,
		IFNULL(`id_fornitore`, 0) id_fornitore,
		IFNULL(`Id_destinazione`, 0) Id_destinazione,
		IFNULL(`condizione_pagamento`, 0) Condizione_pagamento,
		IFNULL(`Porto_resa`, 0) Porto_resa,
		CAST(IFNULL(data_documento ,'1970-01-01') AS DATE) `data_documento`,
		IFNULL(`Vettore`, 0) Vettore,
		CAST(IFNULL(data_ora_ritiro ,'1970-01-01') AS DATETIME) `data_ora_ritiro`,
		CAST(IFNULL(data_ora_inizio ,'1970-01-01') AS DATETIME) `data_ora_inizio`,
		`trasport_a_cura`,
		Causale,
		IFNULL(`Fattura`, 0) Fattura,
		IFNULL(`Anno_fattura`, 0) Anno_fattura,
		IFNULL(`colli`, 0)  colli,
		IFNULL(`Peso`, 0) Peso,
		`Nota`,
		`Descrizione`,
		IFNULL(`id_principale`, 0) id_principale,
		IFNULL(`impianto`, 0) Impianto,
		`STAMPA`,
		IFNULL(`destinazione_forn`, 0) destinazione_forn,
		IFNULL(`principale_forn`, 0) principale_forn,
		IFNULL(`id_utente`, 0) id_utente,
		`data_modifica`,
		IFNULL(`stampa_ora`, 0) stampa_ora,
		IFNULL(`fatturaf`, 0) fatturaf,
		IFNULL(`anno_fatturaf`, 0) anno_fatturaf,
		`stato`, 
		filename_firma_destinatario, 
		filename_firma_conducente,
		cd.Id_commessa,
		cd.id_sottocommessa,
		cd.anno_commessa
	FROM ddt
		INNER JOIN commessa_ddt cd
			ON ddt.id_ddt = cd.Id_ddt AND ddt.anno = cd.Anno_ddt
	WHERE id_ddt = enter_id AND anno = enter_year; 

END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesDdtGetNotInvoicedByJob
DROP PROCEDURE IF EXISTS sp_ariesDdtGetNotInvoicedByJob;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtGetNotInvoicedByJob`( 
job_id INT, 
job_year INT,
sub_job_id INT, 
job_lot_id INT
)
BEGIN
	SELECT 
		d.`Id_ddt`,
		d.`anno` ,
		IFNULL(`id_cliente`, 0) id_cliente,
		IFNULL(`id_fornitore`, 0) id_fornitore,
		IFNULL(`Id_destinazione`, 0) Id_destinazione,
		IFNULL(`condizione_pagamento`, 0) Condizione_pagamento,
		IFNULL(`Porto_resa`, 0) Porto_resa,
		CAST(IFNULL(data_documento ,'1970-01-01') AS DATE) `data_documento`,
		IFNULL(`Vettore`, 0) Vettore,
		CAST(IFNULL(data_ora_ritiro ,'1970-01-01') AS DATETIME) `data_ora_ritiro`,
		CAST(IFNULL(data_ora_inizio ,'1970-01-01') AS DATETIME) `data_ora_inizio`,
		`trasport_a_cura`,
		Causale,
		IFNULL(`Fattura`, 0) Fattura,
		IFNULL(`Anno_fattura`, 0) Anno_fattura,
		IFNULL(`colli`, 0)  colli,
		IFNULL(`Peso`, 0) Peso,
		`Nota`,
		`Descrizione`,
		IFNULL(`id_principale`, 0) id_principale,
		IFNULL(`impianto`, 0) Impianto,
		`STAMPA`,
		IFNULL(`destinazione_forn`, 0) destinazione_forn,
		IFNULL(`principale_forn`, 0) principale_forn,
		IFNULL(`id_utente`, 0) id_utente,
		`data_modifica`,
		IFNULL(`stampa_ora`, 0) stampa_ora,
		IFNULL(`fatturaf`, 0) fatturaf,
		IFNULL(`anno_fatturaf`, 0) anno_fatturaf,
		`stato`, 
		filename_firma_destinatario, 
		filename_firma_conducente,
		cd.Id_commessa,
		cd.id_sottocommessa,
		cd.anno_commessa
	FROM ddt d
		INNER JOIN commessa_ddt cd
			ON d.id_ddt = cd.Id_ddt AND d.anno = cd.Anno_ddt 
				AND cd.Id_commessa = job_id AND cd.anno_commessa = job_year 
				AND cd.id_sottocommessa = sub_job_id AND IF(job_lot_id = -1, True, cd.id_lotto = job_lot_id)
	WHERE (Fattura IS NULL OR Fattura = 0) AND (Fatturaf IS NULL OR Fatturaf = 0);

END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesDdtGetById
DROP PROCEDURE IF EXISTS sp_ariesDdtDeleteById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtDeleteById`( 
enter_id INT, 
enter_year INT
)
BEGIN

	DELETE FROM commessa_ddt
	WHERE id_ddt = enter_id AND anno_ddt = enter_year; 

	DELETE FROM articoli_ddt
	WHERE id_ddt = enter_id AND anno = enter_year; 

	DELETE FROM ddt_rapporto
	WHERE id_ddt = enter_id AND anno_ddt = enter_year; 

	DELETE FROM ddt
	WHERE id_ddt = enter_id AND anno = enter_year; 

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesDdtGetByInvoiceId
DROP PROCEDURE IF EXISTS sp_ariesDdtGetByInvoiceId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtGetByInvoiceId`( 
enter_id INT, 
enter_year INT
)
BEGIN
        
	SELECT 
		ddt.`Id_ddt`,
		ddt.`anno` ,
		IFNULL(`id_cliente`, 0) id_cliente,
		IFNULL(`id_fornitore`, 0) id_fornitore,
		IFNULL(`Id_destinazione`, 0) Id_destinazione,
		IFNULL(`condizione_pagamento`, 0) Condizione_pagamento,
		IFNULL(`Porto_resa`, 0) Porto_resa,
		CAST(IFNULL(data_documento ,'1970-01-01') AS DATE) `data_documento`,
		IFNULL(`Vettore`, 0) Vettore,
		CAST(IFNULL(data_ora_ritiro ,'1970-01-01') AS DATETIME) `data_ora_ritiro`,
		CAST(IFNULL(data_ora_inizio ,'1970-01-01') AS DATETIME) `data_ora_inizio`,
		`trasport_a_cura`,
		Causale,
		IFNULL(`Fattura`, 0) Fattura,
		IFNULL(`Anno_fattura`, 0) Anno_fattura,
		IFNULL(`colli`, 0)  colli,
		IFNULL(`Peso`, 0) Peso,
		`Nota`,
		`Descrizione`,
		IFNULL(`id_principale`, 0) id_principale,
		IFNULL(`impianto`, 0) Impianto,
		`STAMPA`,
		IFNULL(`destinazione_forn`, 0) destinazione_forn,
		IFNULL(`principale_forn`, 0) principale_forn,
		IFNULL(`id_utente`, 0) id_utente,
		`data_modifica`,
		IFNULL(`stampa_ora`, 0) stampa_ora,
		IFNULL(`fatturaf`, 0) fatturaf,
		IFNULL(`anno_fatturaf`, 0) anno_fatturaf,
		`stato`, 
		filename_firma_destinatario, 
		filename_firma_conducente,
		cd.Id_commessa,
		cd.id_sottocommessa,
		cd.anno_commessa
	FROM ddt
		INNER JOIN commessa_ddt cd
			ON ddt.id_ddt = cd.Id_ddt AND ddt.anno = cd.Anno_ddt 
	WHERE Fattura = enter_id AND Anno_fattura = enter_year; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtProductDeleteByDdt
DROP PROCEDURE IF EXISTS sp_ariesDdtProductDeleteByDdt;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtProductDeleteByDdt`(
ddt_id INT(11), 
ddt_year INT(11)
)
BEGIN

	DELETE FROM articoli_ddt
	WHERE Id_ddt = ddt_id 
		and anno = ddt_year;

	DELETE FROM riferimento_sn_ddt_kit 
	WHERE Id_ddt = ddt_id 
		and anno = ddt_year;
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtProductGetByDdt
DROP PROCEDURE IF EXISTS sp_ariesDdtProductGetByDdt;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtProductGetByDdt`(
ddt_id INT(11), 
ddt_year INT(11)
)
BEGIN

	SELECT 
		id_articolo,
		Costo,
		id_ddt,
		Desc_breve,
		anno
		codice_fornitore,
		numero_tab,
		IFNULL(quantità, 0) quantità,
		Unità_misura,
		Prezzo,
		Serial_number,
		tipo,
		IFNULL(idnota, 0) idnota,
		IFNULL(causale_scarico, 0) causale_scarico,
		IFNULL(id_rif, 0) id_rif,
		IFNULL(anno_rif, 0) anno_rif,
		0 AS sconto2,
		sconto,
		IFNULL(economia, 0) economia,
		id_commessa,
		anno_commessa,
		id_sottocommessa,
		id_lotto_commessa,
		id_tab_commessa,
		sostituzione,
		codice_articolo_sostituzione,
		id_tab_sostituzione
	FROM articoli_ddt
	WHERE Id_ddt = ddt_id 
		and anno = ddt_year
	ORDER BY numero_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtProductGetByDdtIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesDdtProductGetByDdtIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtProductGetByDdtIdAndYear`( 
	ddt_id INT, 
	ddt_year INT
)
BEGIN

	SELECT 
		IFNULL(Id_articolo, "") AS Id_articolo, 
		costo, 
		id_ddt, 
		IFNULL(Desc_breve, "") AS Desc_breve,
		Anno, 
		IFNULL(Codice_fornitore, "") AS codice_fornitore, 
		Numero_tab, 
		IFNULL(Quantità, 0) AS quantità,
		IFNULL(unità_misura, "") AS Unità_misura, 
		Prezzo, 
		IFNULL(Serial_number, "") AS Serial_number, 
		IFNULL(Tipo, "") AS tipo, 
		IFNULL(idnota, 0) as idnota, 
		IFNULL(causale_scarico, 0) AS causale_scarico, 
		IFNULL(id_rif, 0) AS id_rif, 
		IFNULL(anno_rif, 0) AS anno_rif, 
		IFNULL(sconto2, 0) AS sconto2, 
		sconto, 
		IFNULL(economia, 0) AS economia,
		id_commessa,
		anno_commessa,
		id_sottocommessa,
		id_lotto_commessa,
		id_tab_commessa,
		sostituzione,
		codice_articolo_sostituzione,
		id_tab_sostituzione
	FROM articoli_ddt
	WHERE Id_ddt = ddt_id AND anno = ddt_year
	ORDER BY Numero_tab; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtProductGetByJobAndProductCode
DROP PROCEDURE IF EXISTS sp_ariesDdtProductGetByJobAndProductCode;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtProductGetByJobAndProductCode`(
	job_id INT(11), 
	job_year INT(11), 
	sub_job_id INT(11),
	job_lot_id INT(11), 
	product_code VARCHAR(11)
)
BEGIN
	SELECT 
		id_articolo,
		Costo,
		articoli_ddt.id_ddt,
		Desc_breve,
		articoli_ddt.anno,
		codice_fornitore,
		numero_tab,
		IFNULL(quantità, 0) quantità,
		Unità_misura,
		Prezzo,
		Serial_number,
		tipo,
		IFNULL(idnota, 0) idnota,
		IFNULL(causale_scarico, 0) causale_scarico,
		IFNULL(id_rif, 0) id_rif,
		IFNULL(anno_rif, 0) anno_rif,
		0 AS sconto2,
		sconto,
		IFNULL(economia, 0) economia,
		articoli_ddt.id_commessa,
		articoli_ddt.anno_commessa,
		articoli_ddt.id_sottocommessa,
		articoli_ddt.id_lotto_commessa,
		articoli_ddt.id_tab_commessa,
		sostituzione,
		codice_articolo_sostituzione,
		id_tab_sostituzione
	FROM articoli_ddt
		INNER JOIN commessa_ddt 
			ON commessa_ddt.Id_ddt = articoli_ddt.id_ddt 
			AND commessa_ddt.anno_ddt = articoli_ddt.anno 
			AND commessa_ddt.id_lotto = job_lot_id
			AND commessa_ddt.id_commessa = job_id 
			AND commessa_ddt.anno_commessa = job_year
	WHERE articoli_ddt.id_articolo = product_code 
	ORDER BY numero_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtProductSetQuantities
DROP PROCEDURE IF EXISTS sp_ariesDdtProductSetQuantities;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtProductSetQuantities`(
	ddt_id INT(11), 
	ddt_year INT(11),
	row_id SMALLINT, 
	quantity DECIMAL(11,2), 
	economy_quantity DECIMAL(11,2)
)
BEGIN

	DECLARE job_id INT(11);
	DECLARE job_year INT(11);
	DECLARE sub_job_id INT(11);
	DECLARE lot_id INT(11);
	DECLARE has_job_link BIT(1);
	
	SELECT fnc_ddtHasJobLink(ddt_id, ddt_year)
		INTO has_job_link;
	
	-- WE CANNOT UPDATE A PRODUCT LINKED TO THE JOB.
	-- FOR THIS REASON WE NEED TO REMOVE JOB-DDT LINK FIRST, 
	-- UPDATE PRODUCT AND CREATE BACK JOB-DDT LINK
	IF has_job_link THEN
		SELECT id_commessa,
			anno_commessa,
			id_sottocommessa,
			id_lotto
		INTO job_id, 
			job_year,
			sub_job_id,
			lot_id
		FROM commessa_ddt
		WHERE id_ddt = ddt_id and anno_ddt = ddt_year;

		DELETE FROM commessa_ddt
		WHERE id_commessa = job_id
			AND anno_commessa = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = lot_id
			AND id_ddt = ddt_id 
			AND anno_ddt = ddt_year;
	END IF;

	UPDATE articoli_ddt
	SET
		quantità = quantity + economy_quantity, 
		economia = economy_quantity
	WHERE Id_ddt = ddt_id 
		and anno = ddt_year
		and numero_tab = row_id; 

	IF has_job_link THEN
		INSERT INTO commessa_ddt
		SET id_commessa = job_id,
			anno_commessa = job_year,
			id_sottocommessa = sub_job_id,
			id_lotto = lot_id,
			id_ddt = ddt_id, 
			anno_ddt = ddt_year;
	END IF;

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDdtSetIsPrinted
DROP PROCEDURE IF EXISTS sp_ariesDdtSetIsPrinted;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDdtSetIsPrinted`( 
enter_id INT, 
enter_year INT, 
is_printed BIT
)
BEGIN
        
	UPDATE DDT
	SET STAMPA = is_printed
	WHERE Id_ddt = enter_id AND anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDefaultLotBodyDeleteByLotId
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotBodyDeleteByLotId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotBodyDeleteByLotId`(
lot_id INT(11)
)
BEGIN

	DELETE FROM articolo_lotto
	WHERE id_lotto = lot_id;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDefaultLotBodyGetByLotId
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotBodyGetByLotId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotBodyGetByLotId`(
lot_id INT(11)
)
BEGIN

	SELECT 
		Id_lotto,
		Id_tab,
		IFNULL(id_articolo, '') AS 'Id_articolo', 
		IFNULL(quantità, 0) AS 'Quantità', 
		IFNULL(Codice_fornitore, '') AS 'Codice_fornitore', 
		IFNULL(Unità_misura, '') AS 'Unità_misura', 
		IFNULL(Prezzo, 0) AS 'Prezzo',
		IFNULL(costo, 0) AS 'Costo', 
		IFNULL(Tempo_installazione, 0) AS 'Tempo_installazione',  
		IFNULL(Prezzo_h, 0) AS 'Prezzo_h',
		IFNULL(costo_h, 0) AS 'Costo_h',
		IFNULL(Desc_brev, '') AS 'Desc_brev', 
		Montato, 
		Tipo, 
		IFNULL(idnota, 0 ) AS 'IdNota'
	FROM articolo_lotto
	WHERE id_lotto = lot_id
	ORDER BY Id_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDefaultLotDeleteById
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotDeleteById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotDeleteById`(
lot_id INT(11), 
OUT result  TINYINT
)
BEGIN
	
	SET result = 1; 
	
		-- check if lot exists
	SELECT 
		IF(id_lotto IS NULL, -2, 1)
	INTO 
		result
	FROM lotto
	WHERE Id_lotto = lot_id; 
	
	IF result = 1 THEN 
	
		-- check if lot is already used in any quote
		SELECT 
			IF(id_lotto IS NOT NULL, -1, 1)
		INTO 
			result
		FROM preventivo_lotto
		WHERE Id_lotto = lot_id; 
		
	END IF;

	IF result = 1 THEN 
		DELETE FROM articolo_lotto
		WHERE id_lotto = lot_id;
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDefaultLotUpdateStatusById
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotUpdateStatusById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotUpdateStatusById`(
lot_id INT(11), 
status_id TINYINT,
OUT result  TINYINT
)
BEGIN
	
	SET result = 1; 
	
	-- check if lot exists
	SELECT 
		IF(id_lotto IS NULL, -2, 1)
	INTO 
		result
	FROM lotto
	WHERE Id_lotto = lot_id; 

	IF result = 1 THEN 
		UPDATE lotto
		SET stato = status_id 
		WHERE id_lotto = lot_id;
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductDelete
DROP PROCEDURE IF EXISTS sp_ariesDepotProductDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductDelete`(
	IN depot_product_id INT(11),
	OUT result INT(11)
)
BEGIN

	DELETE
	FROM Magazzino
	WHERE Id = depot_product_id; 
	
	SET result = 1;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductDeleteByProductCodeAndDepotTypeId
DROP PROCEDURE IF EXISTS sp_ariesDepotProductDeleteByProductCodeAndDepotTypeId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductDeleteByProductCodeAndDepotTypeId`(
	IN product_code VARCHAR(11),
	IN depot_type_id INT(11),
	OUT result INT(11)
)
BEGIN

	DELETE
	FROM Magazzino
	WHERE Magazzino.Id_articolo = product_code AND magazzino.tipo_magazzino = depot_type_id; 
	
	SET result = 1;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductGet
DROP PROCEDURE IF EXISTS sp_ariesDepotProductGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductGet`(
)
BEGIN

	SELECT `Id`,
		`Id_articolo` ,
		Giacenza,
		Tipo_magazzino, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		Utente_mod,
		IFNULL(`Data_ins`, STR_TO_DATE('1970-01-01 00:00:00', '%Y-%m-%d')) data_ins,
		Data_mod
	FROM Magazzino; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductGetByCodeAndDepotTypeId
DROP PROCEDURE IF EXISTS sp_ariesDepotProductGetByCodeAndDepotTypeId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductGetByCodeAndDepotTypeId`(
	IN depot_type_id INT(11), 
	IN product_code VARCHAR(11)
)
BEGIN

	SELECT `Id`,
		`Id_articolo` ,
		Giacenza,
		Tipo_magazzino, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		Utente_mod,
		IFNULL(`Data_ins`, STR_TO_DATE('1970-01-01 00:00:00', '%Y-%m-%d')) data_ins,
		Data_mod
	FROM Magazzino
	WHERE Id_articolo = product_code AND Tipo_magazzino = depot_type_id; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductGetById
DROP PROCEDURE IF EXISTS sp_ariesDepotProductGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductGetById`(
	IN depot_product_id INT(11)
)
BEGIN

	SELECT `Id`,
		`Id_articolo` ,
		Giacenza,
		Tipo_magazzino, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		Utente_mod,
		IFNULL(`Data_ins`, STR_TO_DATE('1970-01-01 00:00:00', '%Y-%m-%d')) data_ins,
		Data_mod
	FROM Magazzino
	WHERE Id = depot_product_id; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductInsert
DROP PROCEDURE IF EXISTS sp_ariesDepotProductInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductInsert`(
	IN product_code VARCHAR(11),
	IN depot_type_id INT(11),
	IN stock DECIMAL(11,2),
	OUT Result INT(11)
)
BEGIN


	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = 0;

	SELECT COUNT(Articolo.Codice_articolo) 
		INTO Result
	FROM Articolo 
	WHERE Articolo.Codice_articolo = product_code; 

	IF Result = 0 THEN
		SET Result = -1; -- product code not found
	ELSE
		SELECT COUNT(tipo_magazzino.Id_tipo) 
			INTO Result
		FROM tipo_magazzino 
		WHERE tipo_magazzino.Id_tipo = depot_type_id;
		
		IF Result = 0 THEN
			SET Result = -2; -- depot_type_id not found
		ELSE
			SELECT COUNT(Magazzino.Id) 
				INTO Result
			FROM Magazzino 
			WHERE Magazzino.id_articolo = product_code AND magazzino.tipo_magazzino = depot_type_id; 
			
			IF Result > 0 THEN
				SET Result = -3; -- product code alreadg exists for this depot type id
			END IF;
		END IF;
	END IF;
	
	IF Result >= 0 THEN
	
		INSERT INTO Magazzino 
		SET 
			Magazzino.Id_articolo = product_code, 
			magazzino.tipo_magazzino = depot_type_id, 
			magazzino.giacenza = stock, 
			magazzino.data_ultimo_movimento = NOW(),
			Magazzino.Data_ins = NOW(), 
			Magazzino.Utente_ins = @USER_ID, 
			Magazzino.Utente_mod = @USER_ID; 	 
		
		 SET Result  = LAST_INSERT_ID();
		 
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductResetStocksBy
DROP PROCEDURE IF EXISTS sp_ariesDepotProductResetStocksBy;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductResetStocksBy`(
	IN depot_type_id INT(11),
	OUT Result INT(11)
)
BEGIN

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = 0;
	
	If depot_type_id IS NOT NULL THEN
		SELECT COUNT(tipo_magazzino.Id_tipo) 
			INTO Result
		FROM tipo_magazzino 
		WHERE tipo_magazzino.Id_tipo = depot_type_id;

		IF Result = 0 THEN
			SET Result = -2; -- depot_type_id not found
		END IF;
	END IF;
	
	IF Result >= 0 THEN
	
		UPDATE Magazzino 
		SET 
			magazzino.giacenza = 0, 
			data_ultimo_movimento = NOW(),
			Magazzino.Utente_mod = @USER_ID
		WHERE IF(depot_type_id IS NULL, True, magazzino.tipo_magazzino = depot_type_id); 
		
		If depot_type_id IS NOT NULL THEN
		
			INSERT INTO magazzino_azzera 
				(data_azzeramento, Id_utente, Id_tipo_magazzino) 
			VALUES 
				(curdate(), @USER_ID, depot_type_id ); 
				
		ELSE
		
			INSERT INTO magazzino_azzera 
				(data_azzeramento, Id_utente, Id_tipo_magazzino) 
			SELECT 
				CURDATE(), 
				@USER_ID,
				tipo_magazzino.Id_tipo
			FROM Tipo_magazzino; 
			
		END IF; 
		
		SET Result  = 1;
		 
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductStoredCurrentStatus
DROP PROCEDURE IF EXISTS sp_ariesDepotProductStoredCurrentStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductStoredCurrentStatus`(
	IN stored_year SMALLINT, 
	IN description VARCHAR(100), 
	OUT Result INT(11)
)
BEGIN
	DECLARE stored_id INT DEFAULT 1; 
	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = 0;
	

	IF Result >= 0 THEN
	
		INSERT INTO magazzino_arch
		SET
			magazzino_arch.anno = stored_year, 
			magazzino_arch.descrizione = description, 
			magazzino_arch.Utente_ins = @USER_ID, 
			magazzino_arch.Utente_mod = @USER_ID, 
			magazzino_arch.Data_ins = NOW();
			
		
		SET stored_id = LAST_INSERT_ID(); 
		
		INSERT INTO magazzino_stored 
		(  
			id_stored,	
			Id_articolo, 
			tipo_magazzino , 
			giacenza , 
			Data_ins,
			Data_mod, 
			Utente_ins, 
			Utente_mod
		)
		SELECT
			stored_id, 
			magazzino.Id_articolo, 
			magazzino.tipo_magazzino , 
			magazzino.giacenza , 
			magazzino.Data_ins, 
			magazzino.Data_mod,
			magazzino.Utente_ins, 
			magazzino.Utente_mod
		FROM Magazzino; 	 
		
		SET Result  = 1;
		 
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotProductUpdate
DROP PROCEDURE IF EXISTS sp_ariesDepotProductUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotProductUpdate`(
	IN product_code VARCHAR(11),
	IN depot_product_id INT(11), 
	IN depot_type_id INT(11),
	IN stock DECIMAL(11,2),
	OUT Result INT(11)
)
BEGIN

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	SET Result = 0;

	SELECT COUNT(Articolo.Codice_articolo) 
		INTO Result
	FROM Articolo 
	WHERE Articolo.Codice_articolo = product_code; 

	IF Result = 0 THEN
		SET Result = -1; -- product code not found
	ELSE
		SELECT COUNT(tipo_magazzino.Id_tipo) 
			INTO Result
		FROM tipo_magazzino 
		WHERE tipo_magazzino.Id_tipo = depot_type_id;
		
		IF Result = 0 THEN
			SET Result = -2; -- depot_type_id not found
		ELSE
			SELECT COUNT(Magazzino.Id) 
				INTO Result
			FROM Magazzino 
			WHERE Magazzino.id_articolo = product_code AND magazzino.tipo_magazzino = depot_type_id; 
			
			IF Result = 0 THEN
				SET Result = -4; -- not found record with this product code and depot type id
			END IF;
		END IF;
	END IF;
	
	IF Result >= 0 THEN
	
		UPDATE Magazzino 
		SET 
			Magazzino.Id_articolo = product_code, 
			magazzino.tipo_magazzino = depot_type_id, 
			magazzino.giacenza = stock, 
			data_ultimo_movimento = NOW(),
			Magazzino.Utente_mod = @USER_ID
		WHERE magazzino.Id = depot_product_id; 
		
		SET Result  = 1;
		 
	END IF; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotTypeGet
DROP PROCEDURE IF EXISTS sp_ariesDepotTypeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeGet`(
)
BEGIN

	SELECT `Id_tipo`,
		`nome` ,
		Descrizione,
		IFNULL(prior, -1) prior,
		IFNULL(id_master, -1) id_master,
		IFNULL(reso, 0) reso,
		disabilitato
	FROM Tipo_magazzino; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesDepotTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeGetById`(
	IN depot_type_id INT(11)
)
BEGIN

	SELECT `Id_tipo`,
		`nome` ,
		Descrizione,
		IFNULL(prior, -1) prior,
		IFNULL(id_master, -1) id_master,
		IFNULL(reso, 0) reso,
		disabilitato
	FROM Tipo_magazzino
	WHERE Id_tipo = depot_type_id; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotTypeGetWithHighestPriority
DROP PROCEDURE IF EXISTS sp_ariesDepotTypeGetWithHighestPriority;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeGetWithHighestPriority`( )
BEGIN

	SELECT `Id_tipo`,
		`nome` ,
		Descrizione,
		IFNULL(prior, -1) prior,
		IFNULL(id_master, -1) id_master,
		IFNULL(reso, 0) reso,
		disabilitato
	FROM Tipo_magazzino
	ORDER BY prior DESC
	LIMIT 1; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDepotTypeGetByDepotCausal
DROP PROCEDURE IF EXISTS sp_ariesDepotTypeGetByDepotCausal;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeGetByDepotCausal`(
	IN causal_type_id VARCHAR(8)
)
BEGIN

	SELECT `Id_tipo`,
		Tipo_magazzino.`nome` ,
		Tipo_magazzino.Descrizione,
		IFNULL(prior, -1) prior,
		IFNULL(id_master, -1) id_master,
		IFNULL(Tipo_magazzino.reso, 0) reso,
		disabilitato
	FROM Tipo_magazzino
		INNER JOIN Causale_magazzino ON Tipo_magazzino.Id_tipo = causale_magazzino.tipo_magazzino
	WHERE Causale_magazzino.id_causale = causal_type_id;
	
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesDocumentPrinterGet
DROP PROCEDURE IF EXISTS sp_ariesDocumentPrinterGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDocumentPrinterGet`()
BEGIN

	SELECT 
		Id_documento,
		Stampante,
		copie
	FROM stampante_documento
	WHERE Id_utente = @USER_ID; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDocumentPrinterGetById
DROP PROCEDURE IF EXISTS sp_ariesDocumentPrinterGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDocumentPrinterGetById`(
	IN document_id INT(11)
)
BEGIN

	SELECT 
		Id_documento,
		Stampante,
		copie
	FROM stampante_documento
	WHERE Id_utente = @USER_ID AND Id_documento = document_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDocumentPrinterInsert
DROP PROCEDURE IF EXISTS sp_ariesDocumentPrinterInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDocumentPrinterInsert`(
	IN `document_id` INT(11),
	IN `printer_name` VARCHAR(100), 
	IN `copies_number` INT(11),
	OUT Result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

	INSERT INTO stampante_documento
	SET 
		Id_documento = document_id, 
		Stampante = printer_name, 
		copie = copies_number, 
		Id_utente = @USER_ID;

	SET Result = 1;
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDocumentPrinterUpdate
DROP PROCEDURE IF EXISTS sp_ariesDocumentPrinterUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDocumentPrinterUpdate`(
	IN `document_id` INT(11),
	IN `printer_name` VARCHAR(100), 
	IN `copies_number` INT(11),
	OUT Result INT(11)
)
BEGIN
   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

	UPDATE stampante_documento
	SET
		Stampante = printer_name, 
		copie = copies_number
	WHERE Id_utente = @USER_ID AND Id_documento = document_id; 	

	SET Result = 1;
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesDocumentTypeObjGet
DROP PROCEDURE IF EXISTS sp_ariesDocumentTypeObjGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDocumentTypeObjGet`()
BEGIN

	SELECT 
		`Id_tipo`,
		Nome,
		Descrizione
	FROM tipo_documento; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailDelete
DROP PROCEDURE IF EXISTS sp_ariesEmailDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailDelete`(
	IN `email_id` INT(11),
	OUT result SMALLINT
)
BEGIN

	DECLARE email_status SMALLINT; 
	

	
	SELECT COUNT(mail.Id)
		INTO Result
	FROM mail
	WHERE 
		mail.id = email_id;
		
	IF Result <= 0 THEN
		SET Result = -3; -- email not found	
	END IF;

	

	
	IF Result >= 0 THEN
	
		-- control if is in draft
		SELECT mail.Id_stato
			INTO email_status
		FROM mail
		WHERE 
			mail.id = email_id;
			
			
		If email_status = 5 THEN
			DELETE FROM mail
			WHERE mail.Id = email_id;  
		ELSE
			UPDATE mail
			SET Id_stato = 6
			WHERE mail.Id = email_id;  
		END IF; 
		
		SET Result = 1;
	END IF; 
		

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGet
DROP PROCEDURE IF EXISTS sp_ariesEmailGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGet`()
BEGIN
	SELECT 
		`Id`,
		`Id_mittente`,
		IFNULL(`Destinatari_cc`, "") Destinatari_cc,
		IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
		`Oggetto`,
		`Corpo`,
		`Pec`,
		`Id_stato`,
		IFNULL(`Id_risposta`, 0) Id_risposta,
		IFNULL(`Id_gruppo`, 0) Id_gruppo,
		IFNULL(`Tipo`, '1') Tipo,
		IFNULL(`Id_documento`, "") Id_documento,
		IFNULL(`Anno_documento`, "") Anno_documento,
		IFNULL(`Revisione_documento`, "") Revisione_documento,
		IFNULL(`Tipo_documento`, "") Tipo_documento,
		`Tentativo`,
		`Data_invio`,
		`Letto`,
		IFNULL(Id_stato_errore, 0) Id_stato_errore, 
		IFNULL(Messaggio_errore, "") Messaggio_errore,
		`Data_ins`,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) Utente_mod
	FROM mail
	WHERE mail.Id_stato <> 6
	ORDER BY Id DESC; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGetById
DROP PROCEDURE IF EXISTS sp_ariesEmailGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGetById`(IN enter_id INT(11))
BEGIN
	SELECT 
		`Id`,
		`Id_mittente`,
		IFNULL(`Destinatari_cc`, "") Destinatari_cc,
		IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
		`Oggetto`,
		`Corpo`,
		`Pec`,
		`Id_stato`,
		IFNULL(`Id_risposta`, 0) Id_risposta,
		IFNULL(`Id_gruppo`, 0) Id_gruppo,
		IFNULL(`Tipo`, '1') Tipo,
		IFNULL(`Id_documento`, "") Id_documento,
		IFNULL(`Anno_documento`, "") Anno_documento,
		IFNULL(`Revisione_documento`, "") Revisione_documento,
		IFNULL(`Tipo_documento`, "") Tipo_documento,

		`Tentativo`,
		`Data_invio`,
		`Letto`,
		IFNULL(Id_stato_errore, 0) Id_stato_errore, 
		IFNULL(Messaggio_errore, "") Messaggio_errore,
		`Data_ins`,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) Utente_mod
	FROM mail
	WHERE Id = enter_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGetByStatusId
DROP PROCEDURE IF EXISTS sp_ariesEmailGetByStatusId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGetByStatusId`(IN `status_id` MEDIUMINT(9))
BEGIN
	SELECT 
		`Id`,
		`Id_mittente`,
		IFNULL(`Destinatari_cc`, "") Destinatari_cc,
		IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
		`Oggetto`,
		`Corpo`,
		`Pec`,
		`Id_stato`,
		IFNULL(`Id_risposta`, 0) Id_risposta,
		IFNULL(`Id_gruppo`, 0) Id_gruppo,
		IFNULL(`Tipo`, '1') Tipo,
		IFNULL(`Id_documento`, "") Id_documento,
		IFNULL(`Anno_documento`, "") Anno_documento,
		IFNULL(`Revisione_documento`, "") Revisione_documento,
		IFNULL(`Tipo_documento`, "") Tipo_documento,
		`Tentativo`,
		`Data_invio`,
		`Letto`,
		IFNULL(Id_stato_errore, 0) Id_stato_errore, 
		IFNULL(Messaggio_errore, "") Messaggio_errore,
		`Data_ins`,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) Utente_mod
	FROM mail
	WHERE mail.Id_stato = status_id
	ORDER BY Id DESC;	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGetByUserPermissions
DROP PROCEDURE IF EXISTS sp_ariesEmailGetByUserPermissions;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGetByUserPermissions`(IN user_id INT(11))
BEGIN

	DECLARE is_admin BIT;
	
	SELECT COUNT(Id_utente)
	INTO is_admin
	FROM Utente
	WHERE Utente.Id_utente = user_id AND nome = 'admin'; 	 

	IF is_admin THEN
		CALL sp_ariesEmailGet();
	ELSE
		
		SELECT DISTINCT
			`Id`,
			`Id_mittente`,
			IFNULL(`Destinatari_cc`, "") Destinatari_cc,
			IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
			`Oggetto`,
			`Corpo`,
			`Pec`,
			`Id_stato`,
			IFNULL(`Id_risposta`, 0) Id_risposta,
			IFNULL(`Id_gruppo`, 0) Id_gruppo,
			IFNULL(`Tipo`, '1') Tipo,
			IFNULL(`Id_documento`, "") Id_documento,
			IFNULL(`Anno_documento`, "") Anno_documento,
			IFNULL(`Revisione_documento`, "") Revisione_documento,
			IFNULL(`Tipo_documento`, "") Tipo_documento,
	
			`Tentativo`,
			`Data_invio`,
			`Letto`,
			IFNULL(Id_stato_errore, 0) Id_stato_errore, 
			IFNULL(Messaggio_errore, "") Messaggio_errore,
			`Data_ins`,
			IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
			`Utente_ins`,
			IFNULL(`Utente_mod`, 0) Utente_mod
		FROM mail
			INNER JOIN utente_mail
			ON utente_mail.id_utente = user_id
				AND utente_mail.id_utente_mail IN (mail.id_mittente, mail.Utente_ins, mail.Utente_mod)
			
		ORDER BY Id DESC;
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGetByUserPermissionsAndStatusId
DROP PROCEDURE IF EXISTS sp_ariesEmailGetByUserPermissionsAndStatusId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGetByUserPermissionsAndStatusId`(IN user_id INT(11), IN `status_id` MEDIUMINT(9))
BEGIN

	DECLARE is_admin BIT; 
	
	SELECT COUNT(Id_utente)
	INTO is_admin
	FROM Utente
	WHERE Utente.Id_utente = user_id AND nome = 'admin'; 	 

	IF is_admin THEN
		CALL sp_ariesEmailGetByStatusId(status_id);
	ELSE
	  
		
		SELECT DISTINCT
			`Id`,
			`Id_mittente`,
			IFNULL(`Destinatari_cc`, "") Destinatari_cc,
			IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
			`Oggetto`,
			`Corpo`,
			`Pec`,
			`Id_stato`,
			IFNULL(`Id_risposta`, 0) Id_risposta,
			IFNULL(`Id_gruppo`, 0) Id_gruppo,
			IFNULL(`Tipo`, '1') Tipo,
			IFNULL(`Id_documento`, "") Id_documento,
			IFNULL(`Anno_documento`, "") Anno_documento,
			IFNULL(`Revisione_documento`, "") Revisione_documento,
			IFNULL(`Tipo_documento`, "") Tipo_documento,
	
			`Tentativo`,
			`Data_invio`,
			`Letto`,
			IFNULL(Id_stato_errore, 0) Id_stato_errore, 
			IFNULL(Messaggio_errore, "") Messaggio_errore,
			`Data_ins`,
			IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
			`Utente_ins`,
			IFNULL(`Utente_mod`, 0) Utente_mod
		FROM mail
			INNER JOIN utente_mail
			ON utente_mail.id_utente = user_id
				AND utente_mail.id_utente_mail IN (mail.id_mittente, mail.Utente_ins, mail.Utente_mod)
		WHERE mail.Id_stato = status_id	
		ORDER BY Id DESC;
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGetScheduledToSend
DROP PROCEDURE IF EXISTS sp_ariesEmailGetScheduledToSend;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGetScheduledToSend`()
BEGIN
	SELECT 
		`Id`,
		`Id_mittente`,
		IFNULL(`Destinatari_cc`, "") Destinatari_cc,
		IFNULL(`Destinatari_ccn`, "") Destinatari_ccn,
		`Oggetto`,
		`Corpo`,
		`Pec`,
		`Id_stato`,
		IFNULL(`Id_risposta`, 0) Id_risposta,
		IFNULL(`Id_gruppo`, 0) Id_gruppo,
		IFNULL(`Tipo`, '1') Tipo,
		IFNULL(`Id_documento`, "") Id_documento,
		IFNULL(`Anno_documento`, "") Anno_documento,
		IFNULL(`Revisione_documento`, "") Revisione_documento,
		IFNULL(`Tipo_documento`, "") Tipo_documento,
		`Tentativo`,
		`Data_invio`,
		`Letto`,
		IFNULL(Id_stato_errore, 0) Id_stato_errore, 
		IFNULL(Messaggio_errore, "") Messaggio_errore,
		`Data_ins`,
		IFNULL(Data_mod, STR_TO_DATE('1970-01-01', '%Y-%m-%d')) Data_mod,
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) Utente_mod
	FROM mail
		INNER JOIN mail_scheduler 
		ON mail.Id = mail_scheduler.id_schedulazione AND CAST(CONCAT(mail_scheduler.data_inizio, ' ', mail_scheduler.ora_inizio) AS DATETIME) < NOW() 
	WHERE mail.Id_stato = 3 ; 		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGroupGet
DROP PROCEDURE IF EXISTS sp_ariesEmailGroupGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGroupGet`()
BEGIN
	SELECT 
		`Id_gruppo`,
		`nome`, 
		`descrizione`,
		`Tipo`
	FROM mail_gruppo
	ORDER BY nome; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGroupGetById
DROP PROCEDURE IF EXISTS sp_ariesEmailGroupGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGroupGetById`(
	IN group_id INT(11)
)
BEGIN

	SELECT 
		`Id_gruppo`,
		`nome`, 
		`descrizione`,
		`Tipo`
	FROM mail_gruppo
	WHERE Id_gruppo = group_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailGroupGetByName
DROP PROCEDURE IF EXISTS sp_ariesEmailGroupGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailGroupGetByName`(
	IN group_name VARCHAR(45)
)
BEGIN

	SELECT 
		`Id_gruppo`,
		`nome`, 
		`descrizione`,
		`Tipo`
	FROM mail_gruppo
	WHERE nome = group_name; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailInsert
DROP PROCEDURE IF EXISTS sp_ariesEmailInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailInsert`(
	IN `sender_id` INT(11),
	IN `recipients_cc` VARCHAR(500),
	IN `recipients_ccn` VARCHAR(500),
	IN `subject` VARCHAR(100),
	IN `body` TEXT,
	IN `is_pec` BIT,
	IN `status_id` INT(11),
	IN `response_id` INT(11),
	IN `group_id` INT(11),
	IN `mail_type` VARCHAR(15),
	IN `document_id` VARCHAR(10),
	IN `document_year` VARCHAR(10),
	IN `document_review` VARCHAR(10),
	IN `document_type` VARCHAR(30),
	IN `attempts` TINYINT(4),
	IN `send_date` DATETIME,
	IN `is_read` BIT(1),
	IN `error_status_id` MEDIUMINT(9),
	IN `error_message` VARCHAR(500),
	OUT result INT(32)
)
BEGIN

	SELECT COUNT(mail_stato.id_Stato)
		INTO Result
	FROM mail_stato
	WHERE 
		mail_stato.id_Stato = status_id;
		
	IF Result > 0 THEN
		SELECT COUNT(utente.Id_utente)
			INTO Result
		FROM utente
		WHERE 
			utente.id_utente = sender_id;
			
		IF Result <= 0 THEN
			SET Result = -2; -- user not found	
		END IF;
	ELSE 
		SET Result = -1; -- email status found	
	END IF;  
	

	IF Result >= 0 THEN
		INSERT INTO mail
		SET 		
			Id_mittente = sender_id,
			Destinatari_cc = recipients_cc,
			Destinatari_ccn = recipients_ccn,
			Oggetto = subject,
			Corpo = body,
			Pec = is_pec,
			Id_stato = status_id,
			Id_risposta = response_id,
			Id_gruppo = group_id,
			Tipo = mail_type,
			Id_documento = document_id,
			Anno_documento = document_year,
			Revisione_documento = document_review,
			Tipo_documento = document_type,
			Tentativo = attempts,
			Data_invio = send_date,
			Letto = is_read,
			Id_stato_errore = error_status_id,
			Messaggio_errore = error_message,
			Data_ins = NOW(),
			Utente_ins = @USER_ID; 
		
		SET Result = LAST_INSERT_ID();
		
		CALL sp_ariesEmailSetDocumentStatus(Result); 
		CALL sp_ariesEmailWriteSideEffects(Result); 
		
	END IF; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailSchedulerGet
DROP PROCEDURE IF EXISTS sp_ariesEmailSchedulerGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSchedulerGet`()
BEGIN
	SELECT 
		`id_schedulazione`,
		`data_inizio`, 
		`ora_inizio`,
		`Stato`, 
		Utente
	FROM mail_scheduler; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailSchedulerGetById
DROP PROCEDURE IF EXISTS sp_ariesEmailSchedulerGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSchedulerGetById`(
	IN scheduler_id INT(11)
)
BEGIN

	SELECT 
		`id_schedulazione`,
		`data_inizio`, 
		`ora_inizio`,
		`Stato`, 
		Utente
	FROM mail_scheduler
	WHERE id_schedulazione = scheduler_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailSchedulerInsert
DROP PROCEDURE IF EXISTS sp_ariesEmailSchedulerInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSchedulerInsert`(
	IN scheduler_id INT(11), 
	IN start_date DATE, 
	IN start_time TIME, 
	IN Status_id INT(11), 
	IN user_id SMALLINT, 
	OUT result SMALLINT
)
BEGIN

	SET result = 1; 
	
	INSERT IGNORE INTO mail_scheduler 
	SET 
		`id_schedulazione` = scheduler_id,
		`data_inizio` = start_date, 
		`ora_inizio` = start_time,
		`Stato` = Status_id, 
		Utente = user_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailSetAllFailedAsCanceled
DROP PROCEDURE IF EXISTS sp_ariesEmailSetAllFailedAsCanceled;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSetAllFailedAsCanceled`()
BEGIN
	
	UPDATE mail
	SET Id_stato = 4 -- canceled 
	WHERE Id_stato = 2; -- failed
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailSetAllFailedAsCanceledByUserPermissions
DROP PROCEDURE IF EXISTS sp_ariesEmailSetAllFailedAsCanceledByUserPermissions;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSetAllFailedAsCanceledByUserPermissions`(IN user_id INT(11))
BEGIN
	
	DECLARE is_admin BIT;
	
	SELECT COUNT(Id_utente)
	INTO is_admin
	FROM Utente
	WHERE Utente.Id_utente = user_id AND nome = 'admin'; 	 

	IF is_admin THEN
		CALL sp_ariesEmailSetAllFailedAsCanceled();
	ELSE
	
		UPDATE mail
			INNER JOIN utente_mail
			ON utente_mail.id_utente = user_id
				AND utente_mail.id_utente_mail IN (mail.id_mittente, mail.Utente_ins, mail.Utente_mod)
		SET Id_stato = 4
		WHERE Id_stato = 2;
		 
	END IF; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariessssEmailSetDocumentStatus
DROP PROCEDURE IF EXISTS sp_ariesEmailSetDocumentStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSetDocumentStatus`(
	IN `email_id` INT(11)
)
BEGIN
	
	DECLARE DocumentType VARCHAR(30); 
	DECLARE DocumentId VARCHAR(10);
	DECLARE DocumentYear VARCHAR(10); 
	DECLARE DocumentReview VARCHAR(10); 
	DECLARE StatusId INT(11);
	DECLARE SystemId INT(11); 
	DECLARE ReminderNumber TINYINT;
	
	SELECT mail.Tipo_documento,
		mail.Id_documento,
		mail.anno_documento, 
		mail.Revisione_documento, 
		mail.Id_stato 
	INTO 
		DocumentType, 
		DocumentId, 
		DocumentYear, 
		DocumentReview, 
		StatusId
	FROM mail
	WHERE Id = email_id; 
	
	IF (DocumentType IS NOT NULL) AND (StatusId = 1 OR DocumentType = 'rapporto_mobile_intervento' OR DocumentType = 'rapporto_mobile_collaudo')  THEN
		
		IF DocumentType = 'prev' THEN -- if document is quote
		
			UPDATE revisione_preventivo 
			SET inviato=1 
			WHERE id_preventivo=DocumentId AND anno = DocumentYear AND id_revisione = DocumentReview;
		   
			UPDATE preventivo 
			SET stato=3,
				data_invio=curdate() 
			WHERE id_preventivo = DocumentId AND anno = DocumentYear AND stato IN (5, 6); 
			
		END IF;
		
		
		
		IF DocumentType = 'sollecito_preventivo' AND (DocumentId IS NOT NULL) THEN
			
			UPDATE preventivo 
			SET secondo_sollecito = NOW()
			WHERE id_preventivo = DocumentId AND anno = DocumentYear AND primo_sollecito IS NOT NULL;  
				
			UPDATE preventivo 
			SET primo_sollecito = NOW()
			WHERE id_preventivo = DocumentId AND anno = DocumentYear AND primo_sollecito IS NULL;  	
			
		END IF;
		
		
		
		IF DocumentType = 'fatt' THEN
			UPDATE fattura 
			SET inviato = 1 
			WHERE id_fattura = DocumentId AND anno= DocumentYear;
		END IF;
		
		
		
		IF DocumentType = 'tk' THEN
		
			SELECT IFNULL(Id_impianto, -1) 
				INTO 
				SystemId
			FROM Ticket
			WHERE Id = DocumentId;
		
			UPDATE ticket  
			SET Stato_ticket=2, 
				inviato=1 
			WHERE id_impianto = SystemId;
			
		END IF;
		
		
		
		IF DocumentType = 'COMMESSA' THEN
			UPDATE commessa 
			SET inv_com = 1
			 WHERE id_commessa = DocumentId AND anno = DocumentYear;
		END IF;
		
		
		IF DocumentType = 'reso' THEN
			UPDATE resoconto 
			SET inviato=1 
			WHERE id_resoconto = DocumentId
				AND anno = DocumentYear;
		END IF;
		
		IF DocumentType = 'ordine' THEN
			UPDATE ordine_fornitore 
			SET inviato = 1 
			WHERE id_Ordine = DocumentId
				AND anno = DocumentYear;
		END IF;
		
		if DocumentType = 'fatt1' THEN

			 UPDATE fattura 
			 SET inviato = 1 
			 WHERE id_fattura = DocumentId
			    AND anno = DocumentYear; 
			    
			 UPDATE clienti 
			 SET rc = 1 
			 WHERE id_cliente = 
			 	(	
				 	SELECT id_cliente 
				 	FROM fattura  
				 	WHERE id_fattura = DocumentId
			    	AND anno = DocumentYear
			    ); 
			   
		
		END IF;
		
		if DocumentType = 'sollecito_fattura' AND (DocumentId IS NOT NULL) THEN

			UPDATE fattura
			SET data_invio_promemoria=NOW() 
			WHERE id_cliente = DocumentId;	 
		
		END IF;
		
		
		IF DocumentType = 'rapporto_mobile_intervento' THEN

			 UPDATE rapporto_mobile 
			 SET inviato = 1 
			 WHERE Id_rapporto = DocumentId AND anno = DocumentYear; 

		
		END IF;
		
		
		IF DocumentType = 'rapporto_mobile_collaudo' THEN

			 UPDATE rapporto_mobile_collaudo 
			 SET inviato = 1 
			 WHERE Id_rapporto = DocumentId AND anno = DocumentYear; 

		
		END IF;
	
	END IF; 		

		

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesEmailWriteSideEffects
DROP PROCEDURE IF EXISTS sp_ariesEmailWriteSideEffects;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailWriteSideEffects`(
	IN `email_id` INT(11)
)
BEGIN
	
	DECLARE DocumentType VARCHAR(30); 
	DECLARE DocumentId VARCHAR(10);
	DECLARE DocumentYear VARCHAR(10);
	DECLARE StatusId INT(11);
	
	SELECT mail.Tipo_documento,
		mail.Id_documento,
		mail.anno_documento, 
		mail.Id_stato 
	INTO 
		DocumentType, 
		DocumentId, 
		DocumentYear, 
		StatusId 
	FROM mail
	WHERE Id = email_id; 
	
	IF StatusId = 0 AND (DocumentType = 'rapporto_mobile_intervento' OR DocumentType = 'rapporto_mobile_collaudo')  THEN
		UPDATE rapporto_mobile_destinatario 
		SET rapporto_mobile_destinatario.id_mail = email_id
		WHERE Id_rapporto = DocumentId AND anno = DocumentYear; 
	END IF; 		
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesEmailSetStatus
DROP PROCEDURE IF EXISTS sp_ariesEmailSetStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailSetStatus`(
	IN `email_id` INT(11),
	IN `send_date` DATETIME,
	IN `status_id` INT(11),
	IN `attempts` TINYINT(4),
	IN `error_status_id` MEDIUMINT(9),
	IN `error_message` VARCHAR(500),
	OUT result SMALLINT
)
BEGIN
	
	SELECT COUNT(mail_stato.id_Stato)
		INTO Result
	FROM mail_stato
	WHERE 
		mail_stato.id_Stato = status_id;
		

	IF Result > 0 THEN
	
		SELECT COUNT(mail.Id)
			INTO Result
		FROM mail
		WHERE 
			mail.id = email_id;
			
		IF Result <= 0 THEN
			SET Result = -3; -- email not found	
		END IF;

		
	ELSE 
		SET Result = -1; -- email status found	
	END IF;  
	
	

	
	IF Result >= 0 THEN
	
		UPDATE mail
		SET Id_stato = status_id, 
			Data_invio = send_date, 
			Tentativo = attempts,
			Id_stato_errore = error_status_id,
			Messaggio_errore = error_message
		WHERE mail.Id = email_id;  
		
		CALL sp_ariesEmailSetDocumentStatus(email_id); 
		CALL sp_ariesEmailWriteSideEffects(email_id);

		SET Result = 1;
	END IF; 
		

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmailUpdate
DROP PROCEDURE IF EXISTS sp_ariesEmailUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmailUpdate`(
	IN `email_id` INT(11),
	IN `sender_id` INT(11),
	IN `recipients_cc` VARCHAR(500),
	IN `recipients_ccn` VARCHAR(500),
	IN `subject` VARCHAR(100),
	IN `body` TEXT,
	IN `is_pec` BIT,
	IN `status_id` INT(11),
	IN `response_id` INT(11),
	IN `group_id` INT(11),
	IN `mail_type` VARCHAR(15),
	IN `document_id` VARCHAR(10),
	IN `document_year` VARCHAR(10),
	IN `document_review` VARCHAR(10),
	IN `document_type` VARCHAR(30),
	IN `attempts` TINYINT(4),
	IN `send_date` DATETIME,
	IN `is_read` BIT(1),
	IN `error_status_id` MEDIUMINT(9),
	IN `error_message` VARCHAR(500),
	OUT result SMALLINT
)
BEGIN
	
	SELECT COUNT(mail_stato.id_Stato)
		INTO Result
	FROM mail_stato
	WHERE 
		mail_stato.id_Stato = status_id;
		
	IF Result > 0 THEN
		SELECT COUNT(utente.Id_utente)
			INTO Result
		FROM utente
		WHERE 
			utente.id_utente = sender_id;
			
		IF Result > 0 THEN
			SELECT COUNT(mail.Id)
				INTO Result
			FROM mail
			WHERE 
				mail.id = email_id;
				
			IF Result <= 0 THEN
				SET Result = -3; -- email not found	
			END IF;
		ELSE 
			SET Result = -2; -- user not found	
		END IF;
		
	ELSE 
		SET Result = -1; -- email status found	
	END IF;  
	

	
	IF Result >= 0 THEN
		UPDATE mail
		SET 		
			Id_mittente = sender_id,
			Destinatari_cc = recipients_cc,
			Destinatari_ccn = recipients_ccn,
			Oggetto = subject,
			Corpo = body,
			Pec = is_pec,
			Id_stato = status_id,
			Id_risposta = response_id,
			Id_gruppo = group_id,
			Tipo = mail_type,
			Id_documento = document_id,
			Anno_documento = document_year,
			Revisione_documento = document_review,
			Tipo_documento = document_type,
			Tentativo = attempts,
			Data_invio = send_date,
			Letto = is_read,
			Id_stato_errore = error_status_id,
			Messaggio_errore = error_message,
			Data_mod = NOW(),
			Utente_mod = @USER_ID
		WHERE mail.Id = email_id; 
		
		CALL sp_ariesEmailSetDocumentStatus(email_id); 
		CALL sp_ariesEmailWriteSideEffects(email_id); 
		
		SET Result = 1;
	END IF; 
		

			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmployeeGet
DROP PROCEDURE IF EXISTS sp_ariesEmployeeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmployeeGet`( )
BEGIN
        
	SELECT Id_operaio,
		 IFNULL(Ragione_sociale, "" ) AS Ragione_sociale,
		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Provincia, "" ) AS Provincia,
		 IFNULL(Comune, 0) AS Comune,
		 IFNULL(Frazione, 0) AS Frazione ,
		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Indirizzo, "" ) AS  Indirizzo,
		 IFNULL(Iban, "" ) AS Iban,
		 IFNULL(livello_associato, 0 ) AS  livello_associato,
		 IFNULL(N_matricola,0 ) AS N_matricola,
		 IFNULL(Scade_contratto, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Scade_contratto,
		 IFNULL(Telefono, "" ) AS Telefono,
		 IFNULL(Telefono_abitazione, "" ) AS Telefono_abitazione,
		 IFNULL(altro_telefono, "" ) AS altro_telefono,
		 IFNULL(E_mail, "" ) AS E_mail,
		 IFNULL(qualifica, 0 ) AS qualifica,
		 IFNULL(Data_assunzione, CAST("1970-01-01" AS DATE) ) AS Data_assunzione,
		 IFNULL(Data_licenziamento, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS   Data_licenziamento,
		 IFNULL(Tariffario, 0 ) AS Tariffario,
		 IFNULL(collaboratore, 0 ) AS collaboratore,
		 IFNULL(id_filiale, 0 ) AS id_filiale,
		 IFNULL(l_nas, 0 ) AS l_nas,
		 IFNULL(d_nas, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS d_nas,
		 IFNULL(tipo_operaio, 0 ) AS tipo_operaio,
		 IFNULL(agente, 0 ) AS agente,
		 IFNULL(id_utente, 0 ) AS id_utente,
		 IFNULL(is_cassa, 0 ) AS is_cassa,
		 IFNULL(is_tecnico, 0 ) AS  is_tecnico,
		 IFNULL(mail_account, "" ) AS mail_account,
		 IFNULL(password, "" ) AS password,
		 IFNULL(username, "" ) AS username,
		 IFNULL(sigla_operaio, "" ) AS sigla_operaio,
		 IFNULL(Data_ins, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_ins,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_mod,
		 IFNULL(Utente_ins, 0 ) AS Utente_ins,
		 IFNULL(Utente_mod, 0 ) AS Utente_mod
	FROM Operaio;  
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmployeeGetByEventGroupId
DROP PROCEDURE IF EXISTS sp_ariesEmployeeGetByEventGroupId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmployeeGetByEventGroupId`( 
event_group_id INT
)
BEGIN
        
	SELECT DISTINCT Operaio.Id_operaio,
		 IFNULL(Operaio.Ragione_sociale, "" ) AS Ragione_sociale,
		 IFNULL(Operaio.Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Operaio.Provincia, "" ) AS Provincia,
		 IFNULL(Operaio.Comune, 0) AS Comune,
		 IFNULL(Operaio.Frazione, 0) AS Frazione ,
		 IFNULL(Operaio.Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Operaio.Indirizzo, "" ) AS  Indirizzo,
		 IFNULL(Operaio.Iban, "" ) AS Iban,
		 IFNULL(Operaio.livello_associato, 0 ) AS  livello_associato,
		 IFNULL(Operaio.N_matricola,0 ) AS N_matricola,
		 IFNULL(Operaio.Scade_contratto, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Scade_contratto,
		 IFNULL(Operaio.Telefono, "" ) AS Telefono,
		 IFNULL(Operaio.Telefono_abitazione, "" ) AS Telefono_abitazione,
		 IFNULL(Operaio.altro_telefono, "" ) AS altro_telefono,
		 IFNULL(Operaio.E_mail, "" ) AS E_mail,
		 IFNULL(Operaio.qualifica, 0 ) AS qualifica,
		 IFNULL(Operaio.Data_assunzione, CAST("1970-01-01" AS DATE) ) AS Data_assunzione,
		 IFNULL(Operaio.Data_licenziamento, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS   Data_licenziamento,
		 IFNULL(Operaio.Tariffario, 0 ) AS Tariffario,
		 IFNULL(Operaio.collaboratore, 0 ) AS collaboratore,
		 IFNULL(Operaio.id_filiale, 0 ) AS id_filiale,
		 IFNULL(Operaio.l_nas, 0 ) AS l_nas,
		 IFNULL(Operaio.d_nas, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS d_nas,
		 IFNULL(Operaio.tipo_operaio, 0 ) AS tipo_operaio,
		 IFNULL(Operaio.agente, 0 ) AS agente,
		 IFNULL(Operaio.id_utente, 0 ) AS id_utente,
		 IFNULL(Operaio.is_cassa, 0 ) AS is_cassa,
		 IFNULL(Operaio.is_tecnico, 0 ) AS  is_tecnico,
		 IFNULL(Operaio.mail_account, "" ) AS mail_account,
		 IFNULL(Operaio.password, "" ) AS password,
		 IFNULL(Operaio.username, "" ) AS username,
		 IFNULL(Operaio.sigla_operaio, "" ) AS sigla_operaio,
		 IFNULL(Operaio.Data_ins, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_ins,
		 IFNULL(Operaio.Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_mod,
		 IFNULL(Operaio.Utente_ins, 0 ) AS Utente_ins,
		 IFNULL(Operaio.Utente_mod, 0 ) AS Utente_mod
	FROM Evento_gruppo
		INNER JOIN evento_gruppo_evento ON Evento_gruppo.Id = evento_gruppo_evento.Id_gruppo_evento
		INNER JOIN evento_operaio ON evento_gruppo_evento.Id_evento = evento_operaio.Id_evento
		INNER JOIN operaio ON operaio.Id_operaio = evento_operaio.Id_operaio
	WHERE Evento_gruppo.Id = event_group_id
	ORDER BY operaio.Ragione_sociale; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmployeeGetById
DROP PROCEDURE IF EXISTS sp_ariesEmployeeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmployeeGetById`( 
employee_id INT
)
BEGIN
        
	SELECT Id_operaio,
		 IFNULL(Ragione_sociale, "" ) AS Ragione_sociale,
		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Provincia, "" ) AS Provincia,
		 IFNULL(Comune, 0) AS Comune,
		 IFNULL(Frazione, 0) AS Frazione ,
		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,
		 IFNULL(Indirizzo, "" ) AS  Indirizzo,
		 IFNULL(Iban, "" ) AS Iban,
		 IFNULL(livello_associato, 0 ) AS  livello_associato,
		 IFNULL(N_matricola,0 ) AS N_matricola,
		 IFNULL(Scade_contratto, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Scade_contratto,
		 IFNULL(Telefono, "" ) AS Telefono,
		 IFNULL(Telefono_abitazione, "" ) AS Telefono_abitazione,
		 IFNULL(altro_telefono, "" ) AS altro_telefono,
		 IFNULL(E_mail, "" ) AS E_mail,
		 IFNULL(qualifica, 0 ) AS qualifica,
		 IFNULL(Data_assunzione, CAST("1970-01-01" AS DATE) ) AS Data_assunzione,
		 IFNULL(Data_licenziamento, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS   Data_licenziamento,
		 IFNULL(Tariffario, 0 ) AS Tariffario,
		 IFNULL(collaboratore, 0 ) AS collaboratore,
		 IFNULL(id_filiale, 0 ) AS id_filiale,
		 IFNULL(l_nas, 0 ) AS l_nas,
		 IFNULL(d_nas, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS d_nas,
		 IFNULL(tipo_operaio, 0 ) AS tipo_operaio,
		 IFNULL(agente, 0 ) AS agente,
		 IFNULL(id_utente, 0 ) AS id_utente,
		 IFNULL(is_cassa, 0 ) AS is_cassa,
		 IFNULL(is_tecnico, 0 ) AS  is_tecnico,
		 IFNULL(mail_account, "" ) AS mail_account,
		 IFNULL(password, "" ) AS password,
		 IFNULL(username, "" ) AS username,
		 IFNULL(sigla_operaio, "" ) AS sigla_operaio,
		 IFNULL(Data_ins, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_ins,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_mod,
		 IFNULL(Utente_ins, 0 ) AS Utente_ins,
		 IFNULL(Utente_mod, 0 ) AS Utente_mod
	FROM Operaio
	WHERE Id_operaio = employee_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEmployeeShiftLastForEachEmployee
DROP PROCEDURE IF EXISTS sp_ariesEmployeeShiftLastForEachEmployee;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEmployeeShiftLastForEachEmployee`()
BEGIN
	SELECT 
		Id,
		Id_operaio, 
		Id_utente, 
		Latitudine, 
		Longitudine, 
		Data_rilevazione, 
		Sorgente_rilevazione, 
		Data_ins		
	FROM 
		(SELECT 
			operaio_spostamenti.Id,
			operaio_spostamenti.Id_operaio, 
			operaio_spostamenti.Id_utente, 
			operaio_spostamenti.Latitudine, 
			operaio_spostamenti.Longitudine, 
			operaio_spostamenti.Data_rilevazione, 
			operaio_spostamenti.Sorgente_rilevazione, 
			operaio_spostamenti.Data_ins		
		FROM operaio_spostamenti
			INNER JOIN operaio ON operaio.Id_operaio = operaio_spostamenti.id_operaio
				AND operaio.Data_licenziamento IS NULL
		WHERE Latitudine > 0 and Longitudine > 0
		ORDER BY Data_rilevazione DESC) AS employee_shift
	GROUP BY Id_operaio; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventDelete
DROP PROCEDURE IF EXISTS sp_ariesEventDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventDelete`(
enter_id INT,
OUT result BIT
)
BEGIN
	DECLARE event_type INT;
	DECLARE refer_id INT;

	SET Result = 1; 

	If enter_id <= 0 OR enter_id IS NULL
	THEN
		SET Result = 0;  
	END IF; 	
	
	IF Result 
	THEN		 
	
		-- Retrive event informations 
		SELECT id_tipo_evento, 
			id_riferimento 
		INTO
			event_type, 
			refer_id 
		FROM Evento
		WHERE Id = enter_id; 
		
		IF event_type = 1 
		THEN
			DELETE FROM Impianto_abbonamenti_mesi 
			WHERE Id = refer_id; 
		END IF; 
	
		
		UPDATE evento 
		SET Eliminato = 1,
			stato_notifica = 1, 
			data_notifica = NULL,
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = enter_id; 

		DELETE FROM evento_gruppo_evento
		WHERE id_evento = enter_id;

	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventEmployeeDeleteByEventId
DROP PROCEDURE IF EXISTS sp_ariesEventEmployeeDeleteByEventId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventEmployeeDeleteByEventId`( 
event_Id INT,
OUT result BIT
)
BEGIN
        
	SET Result = 1; 

	If event_Id <= 0 OR event_Id IS NULL
	THEN
		SET Result = 0;  
	END IF; 	
	
	IF Result 
	THEN
		 	DELETE
			FROM Evento_Operaio
			WHERE id_evento = event_id;
	END IF; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventEmployeeGet
DROP PROCEDURE IF EXISTS sp_ariesEventEmployeeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventEmployeeGet`( )
BEGIN
        
	SELECT Evento_Operaio.Id, 
		Id_evento, 
		id_operaio,
		Evento_Operaio.Data_ins, 
		Evento_Operaio.Data_mod, 
		Evento_Operaio.Utente_ins, 
		Evento_Operaio.Utente_mod
	FROM Evento_Operaio
		INNER JOIN Evento ON Id_evento = Evento.id
	ORDER BY Evento.Data_esecuzione ASC, Evento.Ora_inizio_esecuzione ASC; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventEmployeeGetByEmployeeId
DROP PROCEDURE IF EXISTS sp_ariesEventEmployeeGetByEmployeeId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventEmployeeGetByEmployeeId`( 
employee_Id INT
)
BEGIN
        
	SELECT Evento_Operaio.Id, 
		Id_evento, 
		id_operaio,
		Evento_Operaio.Data_ins, 
		Evento_Operaio.Data_mod, 
		Evento_Operaio.Utente_ins, 
		Evento_Operaio.Utente_mod
	FROM Evento_Operaio
		INNER JOIN Evento ON Id_evento = Evento.id
	WHERE id_operaio = employee_id
	ORDER BY Evento.Data_esecuzione ASC, Evento.Ora_inizio_esecuzione ASC; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventEmployeeGetByEventId
DROP PROCEDURE IF EXISTS sp_ariesEventEmployeeGetByEventId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventEmployeeGetByEventId`( 
event_Id INT
)
BEGIN
        
	SELECT Id, 
		id_evento, 
		id_operaio,
		Data_ins, 
		Data_mod, 
		Utente_ins, 
		Utente_mod
	FROM Evento_Operaio
	WHERE id_evento = event_id; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavDelete
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavDelete`( 
	enter_id INT
)
BEGIN
	DELETE FROM evento_file_associati_caldav WHERE id = enter_id; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavGet
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavGet`( 
)
BEGIN

	SELECT Id, 
		File_name, 
		id_evento, 
		id_operaio, 
		data_ins, 
		data_mod, 
		utente_ins, 
		utente_mod	
	FROM evento_file_associati_caldav;   

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavGetByEventId
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavGetByEventId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByEventId`( 
	event_id Integer
)
BEGIN

		SELECT Id, 
		File_name, 
		id_evento, 
		id_operaio, 
		data_ins, 
		data_mod, 
		utente_ins, 
		utente_mod	
	FROM evento_file_associati_caldav  
	WHERE id_evento = event_id; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavGetByEventIdAndEmployeeId
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavGetByEventIdAndEmployeeId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByEventIdAndEmployeeId`( 
	event_id Integer,
	employee_id integer
)
BEGIN

		SELECT Id, 
		File_name, 
		id_evento, 
		id_operaio, 
		data_ins, 
		data_mod, 
		utente_ins, 
		utente_mod	
	FROM evento_file_associati_caldav  
	WHERE id_evento = event_id AND id_operaio = employee_id; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavGetByFileName
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavGetByFileName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByFileName`( 
	enter_file_name VARCHAR(150)
)
BEGIN

		SELECT Id, 
		File_name, 
		id_evento, 
		id_operaio, 
		data_ins, 
		data_mod, 
		utente_ins, 
		utente_mod	
	FROM evento_file_associati_caldav  
	WHERE file_name = enter_file_name; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavGetById
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavGetById`( 
	enter_id INT
)
BEGIN

		SELECT Id, 
		File_name, 
		id_evento, 
		id_operaio, 
		data_ins, 
		data_mod, 
		utente_ins, 
		utente_mod	
	FROM evento_file_associati_caldav  
	WHERE id = enter_id; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventFileAssociatedCaldavInsert
DROP PROCEDURE IF EXISTS sp_ariesEventFileAssociatedCaldavInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventFileAssociatedCaldavInsert`( 
	event_id INT, 
	input_file_name VARCHAR(150), 
	employee_id INT
)
BEGIN


	IF event_id IS NULL 
	THEN
		SET event_id = 1; 
	END IF; 

	 INSERT INTO evento_file_associati_caldav 
	 SET 
		File_name = input_file_name, 
		id_evento = event_id, 
		id_operaio = employee_id, 
		data_ins = NOW(), 
		utente_ins = @USER_ID, 
		utente_mod = @USER_ID;   

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGet
DROP PROCEDURE IF EXISTS sp_ariesEventGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGet`( )
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Eliminato = 0
	ORDER BY Evento.Data_esecuzione ASC, Evento.Ora_inizio_esecuzione ASC; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetBetweenDate
DROP PROCEDURE IF EXISTS sp_ariesEventGetBetweenDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetBetweenDate`( 
	IN start_date DATETIME, 
	IN end_date DATETIME
)
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Eliminato = 0 AND (Data_esecuzione BETWEEN start_date AND end_date)
	ORDER BY Evento.Data_esecuzione ASC, Evento.Ora_inizio_esecuzione ASC; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetByGroupId
DROP PROCEDURE IF EXISTS sp_ariesEventGetByGroupId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetByGroupId`( 
	event_group_id INT
)
BEGIN
        
	SELECT Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Sveglia,  
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod,
		evento_gruppo_evento.Id_gruppo_evento AS Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento
			ON Evento_gruppo_evento.Id_evento = Evento.Id AND evento_gruppo_evento.Id_gruppo_evento=event_group_id
	WHERE Eliminato = 0
	ORDER BY Evento.Data_esecuzione ASC, Evento.Ora_inizio_esecuzione ASC; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetById
DROP PROCEDURE IF EXISTS sp_ariesEventGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetById`( 
enter_id INT
)
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Evento.Id = enter_id AND Eliminato = 0; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetByNotifStatus
DROP PROCEDURE IF EXISTS sp_ariesEventGetByNotifStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetByNotifStatus`( 
	IN notification_status TINYINT(4)
)
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Eliminato = 0 AND Stato_notifica = notification_status
	ORDER BY Id; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetByTypeAndReferId
DROP PROCEDURE IF EXISTS sp_ariesEventGetByTypeAndReferId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetByTypeAndReferId`( 
refer_id INT,
event_type TINYINT
)
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Evento.id_riferimento = refer_id
		AND id_tipo_evento = event_type 
		AND Eliminato = 0; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGetByTypes
DROP PROCEDURE IF EXISTS sp_ariesEventGetByTypes;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGetByTypes`( 
	IN event_types MEDIUMTEXT
)
BEGIN
        
	SELECT 
		Evento.Id,
		Evento.Oggetto, 
		Evento.Descrizione, 
		Evento.Id_riferimento, 
		Evento.id_tipo_evento, 
		Evento.Eseguito, 
		Evento.Ricorrente, 
		Evento.Giorni_ricorrenza,
		Evento.Data_esecuzione, 
		Evento.Ora_inizio_esecuzione, 
		Evento.Ora_fine_esecuzione,
		Evento.Stato_notifica, 
		Evento.Data_notifica,  
		Evento.Sveglia, 
		Evento.Data_sveglia,
		Evento.Data_ins, 
		Evento.Data_mod, 
		Evento.Utente_ins, 
		Evento.Utente_mod, 
		Evento_gruppo_evento.Id_gruppo_evento
	FROM Evento
		INNER JOIN Evento_gruppo_evento 
		ON Evento.Id = Evento_gruppo_evento.Id_evento AND Tipo_associazione = 1
	WHERE Eliminato = 0 AND FIND_IN_SET(Evento.id_tipo_evento ,event_types) > 0
	ORDER BY Id; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupEvaluateStatus
DROP PROCEDURE IF EXISTS sp_ariesEventGroupEvaluateStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupEvaluateStatus`( 
enter_id INT,
OUT status_id TINYINT
)
BEGIN

	DECLARE STATUS_OPEN TINYINT DEFAULT 1; 
	DECLARE STATUS_PARTIAL TINYINT DEFAULT 2; 
	DECLARE STATUS_CLOSE TINYINT DEFAULT 3; 
	DECLARE open_events INT;
	DECLARE close_events INT; 
	DECLARE current_status TINYINT;
	
	SET open_events = 0;
	SET close_events = 0; 
	
	
	SELECT COUNT(*)
		INTO open_events
	FROM evento_gruppo_evento
		INNER JOIN evento 
		ON evento.id = evento_gruppo_evento.id_evento
			AND evento.eseguito = 0
	WHERE id_gruppo_evento = enter_id;
	
	SELECT COUNT(*)
		INTO close_events
	FROM evento_gruppo_evento
		INNER JOIN evento 
		ON evento.id = evento_gruppo_evento.id_evento
			AND evento.eseguito = 1
	WHERE id_gruppo_evento = enter_id;
	
	IF open_events = 0 THEN
		SET current_status = STATUS_CLOSE; 
	ELSE
		IF open_events = 0 THEN
			SET current_status = STATUS_OPEN;
		ELSE
			SET current_status = STATUS_PARTIAL;
		END IF;
	END IF;
	
	UPDATE evento_gruppo 
	SET Id_stato = current_status
	WHERE id = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupGet
DROP PROCEDURE IF EXISTS sp_ariesEventGroupGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupGet`( )
BEGIN
        
	SELECT 	
		Evento_gruppo.Id,
		Evento_gruppo.Oggetto,
		Evento_gruppo.Descrizione,
		Evento_gruppo.Id_cliente,
		Evento_gruppo.Id_impianto,
		Evento_gruppo.Id_stato,
		Evento_gruppo.Stato_notifica,
		Evento_gruppo.Data_notifica,
		Evento_gruppo.Data_ora_inizio,
		Evento_gruppo.Data_ora_fine,
		Evento_gruppo.Data_ins,
		Evento_gruppo.Data_mod,
		Evento_gruppo.Utente_ins,
		Evento_gruppo.Utente_mod
	FROM Evento_gruppo
	WHERE Eliminato = 0
	ORDER BY Data_ora_inizio; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupGetBetweenDate
DROP PROCEDURE IF EXISTS sp_ariesEventGroupGetBetweenDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupGetBetweenDate`( 
	IN start_date DATETIME, 
	IN end_date DATETIME
)
BEGIN
        
	SELECT 
		Evento_gruppo.Id,
		Evento_gruppo.Oggetto,
		Evento_gruppo.Descrizione,
		Evento_gruppo.Id_cliente,
		Evento_gruppo.Id_impianto,
		Evento_gruppo.Id_stato,
		Evento_gruppo.Stato_notifica,
		Evento_gruppo.Data_notifica,
		Evento_gruppo.Data_ora_inizio,
		Evento_gruppo.Data_ora_fine,
		Evento_gruppo.Data_ins,
		Evento_gruppo.Data_mod,
		Evento_gruppo.Utente_ins,
		Evento_gruppo.Utente_mod
	FROM Evento_gruppo
	WHERE Eliminato = 0 AND 
			((Data_ora_inizio BETWEEN start_date AND end_date) OR (Data_ora_fine BETWEEN start_date AND end_date))
	ORDER BY Data_ora_inizio; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupGetById
DROP PROCEDURE IF EXISTS sp_ariesEventGroupGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupGetById`( 
enter_id INT
)
BEGIN
        
	SELECT 
		Evento_gruppo.Id,
		Evento_gruppo.Oggetto,
		Evento_gruppo.Descrizione,
		Evento_gruppo.Id_cliente,
		Evento_gruppo.Id_impianto,
		Evento_gruppo.Id_stato,
		Evento_gruppo.Stato_notifica,
		Evento_gruppo.Data_notifica,
		Evento_gruppo.Data_ora_inizio,
		Evento_gruppo.Data_ora_fine,
		Evento_gruppo.Data_ins,
		Evento_gruppo.Data_mod,
		Evento_gruppo.Utente_ins,
		Evento_gruppo.Utente_mod
	FROM Evento_gruppo
	WHERE Id = enter_id AND Eliminato = 0; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupGetByNotifStatus
DROP PROCEDURE IF EXISTS sp_ariesEventGroupGetByNotifStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupGetByNotifStatus`( 
	IN notification_status TINYINT(4)
)
BEGIN
        
	SELECT 
		Evento_gruppo.Id,
		Evento_gruppo.Oggetto,
		Evento_gruppo.Descrizione,
		Evento_gruppo.Id_cliente,
		Evento_gruppo.Id_impianto,
		Evento_gruppo.Id_stato,
		Evento_gruppo.Stato_notifica,
		Evento_gruppo.Data_notifica,
		Evento_gruppo.Data_ora_inizio,
		Evento_gruppo.Data_ora_fine,
		Evento_gruppo.Data_ins,
		Evento_gruppo.Data_mod,
		Evento_gruppo.Utente_ins,
		Evento_gruppo.Utente_mod
	FROM Evento_gruppo
	WHERE Eliminato = 0 AND Stato_notifica = notification_status
	ORDER BY Id; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupInsert
DROP PROCEDURE IF EXISTS sp_ariesEventGroupInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupInsert`(
subject VARCHAR(50),
description TEXT,
event_type TINYINT, 
status_id INTEGER, 
start_date_time DATETIME,
end_date_time DATETIME,
customer_id INTEGER, 
system_id INTEGER,
OUT result INTEGER
)
MainLabel:BEGIN
	SET Result = 1; 
	
	If subject = "" OR subject IS NULL
	THEN
		SET Result = -1; 
		LEAVE MainLabel;
	END IF; 	
	
	If description = "" OR description IS NULL
	THEN
		SET Result = -2;  
		LEAVE MainLabel;
	END IF;
	
	IF Result 
	THEN
		INSERT INTO Evento_gruppo
		SET 
			Oggetto = subject,
			Descrizione = description,
			Id_cliente = customer_id,
			Id_impianto = system_id,
			Data_ora_inizio = start_date_time, 
			Data_ora_fine = end_date_time,
			Id_stato = status_id,
			Data_ins = NOW(),
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID; 
		SET Result = LAST_INSERT_ID(); 
	END IF;  
		
	
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupReplaceEmployee
DROP PROCEDURE IF EXISTS sp_ariesEventGroupReplaceEmployee;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupReplaceEmployee`( 
event_group_id INT,
new_employee INT,
old_employee INT,

OUT result TINYINT
)
BEGIN

	SET result = 1; 
	
	SELECT COUNT(Id)
		INTO result
	FROM Evento_gruppo
	WHERE evento_gruppo.Id = event_group_id; 
	
	If result = 0 THEN
		SET result = -10;	 
	END IF; 
	
	IF result = 1 THEN 
		
		UPDATE evento_operaio
			INNER JOIN evento_gruppo_evento ON evento_operaio.Id_evento = evento_gruppo_evento.Id_evento AND evento_gruppo_evento.Id_gruppo_evento = event_group_id
			INNER JOIN evento ON evento_operaio.Id_evento = evento.Id AND evento.Eseguito = 0
		SET evento_operaio.Id_operaio = new_employee
		WHERE evento_operaio.Id_operaio = old_employee; 
	
		SET result = 1; 
	END IF; 
	

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesEventGroupDelete
DROP PROCEDURE IF EXISTS sp_ariesEventGroupDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupDelete`( 
	event_group_id INT,
	OUT result INT
)
BEGIN
	SET result = 1; 
	DELETE FROM Evento_gruppo
	WHERE evento_gruppo.Id = event_group_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupSetNotificationStatus
DROP PROCEDURE IF EXISTS sp_ariesEventGroupSetNotificationStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupSetNotificationStatus`(
IN ids MEDIUMTEXT,
IN notification_status TINYINT,
OUT result BIT)
BEGIN

	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION; 
	
	UPDATE Evento_gruppo
	SET Stato_notifica = notification_status 
	WHERE FIND_IN_SET(Id ,ids) > 0;

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupStatusGetById
DROP PROCEDURE IF EXISTS sp_ariesEventGroupStatusGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupStatusGetById`( 
enter_id INT
)
BEGIN
        
	SELECT Id,
		Nome, 
		Colore
	FROM Evento
	WHERE Id = enter_id; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventGroupUpdate
DROP PROCEDURE IF EXISTS sp_ariesEventGroupUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventGroupUpdate`(
event_group_id INT,
subject VARCHAR(50),
Description TEXT,
event_type TINYINT, 
status_id INTEGER, 
start_date_time DATETIME,
end_date_time DATETIME,
customer_id INTEGER, 
system_id INTEGER,
OUT result INTEGER
)
MainLabel:BEGIN
	SET Result = 1; 
	
	If subject = "" OR subject IS NULL
	THEN
		SET Result = -1; 
		LEAVE MainLabel;
	END IF; 	
	
	If Description = "" OR Description IS NULL
	THEN
		SET Result = -2;  
		LEAVE MainLabel;
	END IF;
	
	IF Result 
	THEN
		UPDATE Evento_gruppo
		SET 
			Oggetto = subject,
			Descrizione = description,
			Id_cliente = customer_id,
			Id_impianto = system_id,
			Data_ora_inizio = start_date_time, 
			Data_ora_fine = end_date_time,
			Id_stato = status_id,
			stato_notifica = 3, 
			data_notifica = NULL,
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_group_id; 
		
		SET Result = 1; 
			
	END IF;  
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventInsert
DROP PROCEDURE IF EXISTS sp_ariesEventInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventInsert`(
subject VARCHAR(50),
Description TEXT,
refer_id INT, 
group_id INT,
event_type TINYINT, 
was_performed BIT,
is_recurs BIT, 
recurrence_days INT,
has_alarm BIT, 
execution_date DATE, 
execution_start_time TIME,
execution_end_time TIME,
alarm DATETIME,
OUT result BIT,
OUT InsertId INTEGER
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	SET InsertId = 0;
	
	START TRANSACTION; 

	If subject = "" OR subject IS NULL
	THEN
		SET Result = 0;  
	END IF; 	
	
	If Description = "" OR Description IS NULL
	THEN
		SET Result = 0;  
	END IF;
	
	If execution_date IS NULL
	THEN 
		SET Result = 0;  
	END IF;
	
	If group_id IS NULL
	THEN 
		SET Result = 0;  
	END IF;
	
	
	If execution_end_time <= execution_start_time
	THEN 
		SET Result = 0;  
	END IF;
	
	IF Result 
	THEN
	
		INSERT INTO Evento
		SET 
			Oggetto = Subject, 
			Descrizione = Description, 
			Id_riferimento = refer_id, 
			id_tipo_evento = event_type, 
			Eseguito = was_performed, 
			Ricorrente = is_recurs,
			giorni_ricorrenza = recurrence_days,
			Data_esecuzione = execution_date, 
			Sveglia = has_alarm, 
			Data_sveglia = IFNULL(alarm, '1970-01-01 00:00:00'), 
			Ora_inizio_esecuzione = execution_start_time, 
			ora_fine_esecuzione = execution_end_time,
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID; 
		SET InsertId = LAST_INSERT_ID();
		
		
		INSERT INTO Evento_gruppo_evento (Id_evento, Id_gruppo_evento, Tipo_associazione, Timestamp)
			VALUES (InsertId, group_id, 1, CURRENT_TIMESTAMP);
		
		
		SET Result = 1; 
	END IF;  
	
	IF `_rollback` THEN
		ROLLBACK;
		SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventSetNotificationStatus
DROP PROCEDURE IF EXISTS sp_ariesEventSetNotificationStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventSetNotificationStatus`(
IN ids MEDIUMTEXT,
IN notification_status TINYINT,
OUT result BIT)
BEGIN

	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION; 
	
	UPDATE Evento 
	SET Stato_notifica = notification_status 
	WHERE FIND_IN_SET(Id ,ids) > 0;

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventSetWasPermormed
DROP PROCEDURE IF EXISTS sp_ariesEventSetWasPermormed;
DELIMITER //
CREATE PROCEDURE `sp_ariesEventSetWasPermormed`(
event_id INT,
was_performed BIT,
is_recurs BIT, 
OUT result INT
)
BEGIN
	DECLARE execution_date DATE; 
	DECLARE event_type TINYINT; 
	DECLARE refer_id INT; 
	
	SET Result = 1; 

	
	IF Result 
	THEN
		UPDATE Evento
		SET 
			Eseguito = was_performed, 
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
		
		-- Retrive event informations 
		SELECT Data_esecuzione,
			id_tipo_evento, 
			id_riferimento 
		INTO
			execution_date, 
			event_type, 
			refer_id 
		FROM Evento
		WHERE Id = event_id; 
		
		IF was_performed AND event_type = 1 
		THEN
			UPDATE Impianto_abbonamenti_mesi 
			SET eseguito_il = execution_date
			WHERE Id = refer_id; 
		ELSE
			IF event_type = 1  THEN	
				UPDATE Impianto_abbonamenti_mesi 
				SET eseguito_il = execution_date
				WHERE Id = refer_id; 
			END IF; 	
		END IF; 
			
		IF is_recurs
		THEN
			INSERT INTO EVENTO 
			(
				oggetto, 
				Descrizione, 
				Id_riferimento, 
				id_tipo_evento, 
				Eseguito, 
				Ricorrente, 
				Giorni_ricorrenza,
				Data_esecuzione, 
				Ora_inizio_esecuzione, 
				Ora_fine_esecuzione,
				Sveglia,  
				Data_sveglia,
				Data_ins, 
				Data_mod, 
				Utente_ins, 
				Utente_mod
			) 
			SELECT oggetto, 
				Descrizione, 
				Id_riferimento, 
				id_tipo_evento, 
				0, 
				Ricorrente, 
				Giorni_ricorrenza,
				DATE_ADD(Data_esecuzione, INTERVAL Giorni_ricorrenza DAY), 
				Ora_inizio_esecuzione, 
				Ora_fine_esecuzione,
				Sveglia,  
				Data_sveglia,
				CURRENT_TIMESTAMP, 
				CURRENT_TIMESTAMP, 
				@USER_ID, 
				@USER_ID
			FROM Evento 
			WHERE Id = event_id;		
			
			
			SET Result = LAST_INSERT_ID();
				
		END IF;	
		
	END IF;  
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventTypeGet
DROP PROCEDURE IF EXISTS sp_ariesEventTypeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventTypeGet`( 
)
BEGIN
        
	SELECT Id_tipo, 
		Nome, 
		Colore,
		Id_tipologia
	FROM Tipo_evento
	ORDER BY Nome ASC; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesEventTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventTypeGetById`( 
	IN EventTypeId INT(11)
)
BEGIN
        
	SELECT Id_tipo, 
	Nome, 
	Colore,
	Id_tipologia
	FROM Tipo_evento
	WHERE Id_tipo = EventTypeId; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesEventUpdate
DROP PROCEDURE IF EXISTS sp_ariesEventUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEventUpdate`(
event_id INT,
subject VARCHAR(50),
Description TEXT,
refer_id INT, 
event_type TINYINT, 
was_performed BIT,
is_recurs BIT, 
recurrence_days INT,
has_alarm BIT, 
execution_date DATE, 
execution_start_time TIME,
execution_end_time TIME,
alarm DATETIME,
OUT result BIT
)
BEGIN
	SET Result = 1; 


	If subject = "" OR subject IS NULL
	THEN
		SET Result = 0;  
	END IF; 	
	
	If Description = "" OR Description IS NULL
	THEN
		SET Result = 0;  
	END IF;
	
	If execution_date IS NULL
	THEN 
		SET Result = 0;  
	END IF;
	
		
	If execution_end_time <= execution_start_time
	THEN 
		SET Result = 0;  
	END IF;
	
	IF Result 
	THEN
		UPDATE Evento
		SET 
			Oggetto = Subject, 
			Descrizione = Description, 
			Id_riferimento = refer_id, 
			id_tipo_evento = event_type, 
			Eseguito = was_performed, 
			Ricorrente = is_recurs,
			giorni_ricorrenza = recurrence_days,
			Data_esecuzione = execution_date, 
			Sveglia = has_alarm, 
			Data_sveglia = IFNULL(alarm, '1970-01-01 00:00:00'),
			Ora_inizio_esecuzione = execution_start_time, 
			ora_fine_esecuzione = execution_end_time,
			stato_notifica = 3, 
			data_notifica = NULL,
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
		
		IF was_performed AND event_type = 1 
		THEN
			UPDATE Impianto_abbonamenti_mesi 
			SET eseguito_il = execution_date
			WHERE Id = refer_id; 
		ELSE
			IF event_type = 1  THEN	
				UPDATE Impianto_abbonamenti_mesi 
				SET eseguito_il = NULL
				WHERE Id = refer_id; 
			END IF; 	
		END IF; 
		
			
	END IF;  
		
	
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesExpenseTypeGetByName
DROP PROCEDURE IF EXISTS sp_ariesExpenseTypeGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesExpenseTypeGetByName`( 
	IN name VARCHAR(45)
)
BEGIN

	SELECT 
		`Id_tipo`,
		`nome`,
		`Operazione`,
		`descrizione`,
		`trasf`,
		`appartenenza`
	FROM tipo_spesa 
	WHERE nome = name;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesExpenseTypeInsert
DROP PROCEDURE IF EXISTS sp_ariesExpenseTypeInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesExpenseTypeInsert`( 
	IN `type_id` INT(11),
	IN `name` VARCHAR(45),
	IN `operation_type` CHAR(2),
	IN `description` VARCHAR(100),
	IN `is_transf` INT(10),
	IN `membership` VARCHAR(45),
	OUT result INT(11)
)
BEGIN

	INSERT INTO tipo_spesa
	SET
		`Id_tipo` = type_id,
		`nome` = name,
		`Operazione` = operation_type,
		`descrizione` = description,
		`trasf` = is_transf,
		`appartenenza` = membership; 
		
	SET result = LAST_INSERT_ID();
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteDelete
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteDelete`( 
	IN first_note_id INT(11), 
	IN first_note_year INT(11), 
	OUT result INT(11)
)
BEGIN

	DELETE FROM prima_nota 
	WHERE Id_prima_nota = first_note_id
		AND anno = first_note_year;
	
	SET result = 1;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteDeleteByInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteDeleteByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteDeleteByInvoice`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11), 
	OUT result INT(11)
)
BEGIN

	DELETE FROM prima_nota 
	WHERE id_fattura = invoice_id
		AND anno_fattura = invoice_year
		AND IF(payment_id <> -1, id_pagamento = payment_id, TRUE);
	
	SET result = 1;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteDeleteBySupplierInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteDeleteBySupplierInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteDeleteBySupplierInvoice`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11), 
	OUT result INT(11)
)
BEGIN

	DELETE FROM prima_nota 
	WHERE id_fornfattura = invoice_id
		AND anno_fornfattura = invoice_year
		AND IF(payment_id <> -1, id_pagamento = payment_id, TRUE);
		
	SET result = 1;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteGet
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteGet`( 
)
BEGIN
	SELECT 
		`Id_prima_nota`,
		`anno`,
		`Data`,
		`Dipendente`,
		`Tipo_spesa`,
		`Spesa`,
		`Note_spesa`,
		`id_utente`,
		`id_fattura`,
		`anno_fattura`,
		`id_fornfattura`,
		`anno_fornfattura`,
		`id_pagamento`,
		`ricevente`
	FROM prima_nota; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteGetByInvoice`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11)
)
BEGIN
	SELECT 
		`Id_prima_nota`,
		`anno`,
		`Data`,
		`Dipendente`,
		`Tipo_spesa`,
		`Spesa`,
		`Note_spesa`,
		`id_utente`,
		`id_fattura`,
		`anno_fattura`,
		`id_fornfattura`,
		`anno_fornfattura`,
		`id_pagamento`,
		`ricevente`
	FROM prima_nota
	WHERE id_fattura = invoice_id
		AND anno_fattura = invoice_year
		AND id_pagamento = payment_id;
 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteGetBySupplierInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteGetBySupplierInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteGetBySupplierInvoice`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11)
)
BEGIN
	SELECT 
		`Id_prima_nota`,
		`anno`,
		`Data`,
		`Dipendente`,
		`Tipo_spesa`,
		`Spesa`,
		`Note_spesa`,
		`id_utente`,
		`id_fattura`,
		`anno_fattura`,
		`id_fornfattura`,
		`anno_fornfattura`,
		`id_pagamento`,
		`ricevente`
	FROM prima_nota
	WHERE id_fornfattura = invoice_id
		AND anno_fornfattura = invoice_year
		AND id_pagamento = payment_id;
 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteGetById`( 
	IN enter_id INT(11), 
	IN enter_year INT(11)
)
BEGIN
	SELECT 
		`Id_prima_nota`,
		`anno`,
		`Data`,
		`Dipendente`,
		`Tipo_spesa`,
		`Spesa`,
		`Note_spesa`,
		`id_utente`,
		`id_fattura`,
		`anno_fattura`,
		`id_fornfattura`,
		`anno_fornfattura`,
		`id_pagamento`,
		`ricevente`
	FROM prima_nota
	WHERE Id_prima_nota = enter_id
		AND anno = enter_year;
 
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteInsert
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteInsert`( 
	IN exec_date DATE, 
	IN employee_id INT(11), 
	IN expense_type INT(11), 
	IN expense_value DECIMAL(11,2),
	IN expense_notes VARCHAR(100),
	IN invoice_id INT(11),
	IN invoice_year INT(11), 
	IN user_id INT(11), 
	IN recipient_id INT(11), 
	IN supplier_invoice_id INT(11), 
	IN supplier_invoice_year INT(11),
	IN payment_id INT(11), 
	OUT first_note_id INT(11), 
	OUT first_note_year INT(11), 
	OUT result INT(11)
)
BEGIN
	SET first_note_year = YEAR(exec_date);
	SELECT IFNULL(MAX(Id_prima_nota) + 1, 1)
		INTO first_note_id
	FROM prima_nota 
	WHERE anno = first_note_year;

	INSERT INTO prima_nota
	SET 
		Id_prima_nota = first_note_id, 
		anno = first_note_year,
		`Data` = exec_date,
		`Dipendente` = employee_Id,
		`Tipo_spesa` = expense_type,
		`Spesa` = expense_value,
		`Note_spesa` = expense_notes,
		`id_utente` = user_id,
		`id_fattura` = invoice_id,
		`anno_fattura` = invoice_year,
		`id_fornfattura` = supplier_invoice_id,
		`anno_fornfattura` = supplier_invoice_year,
		`id_pagamento` = payment_id,
		`ricevente` = recipient_id;
	
	CALL sp_ariesFirstNoteEvaluateSupplierInvoice(first_note_id,
		first_note_year, supplier_invoice_id, supplier_invoice_year, payment_id,
		expense_type);

	CALL sp_ariesFirstNoteEvaluateInvoice(first_note_id,
		first_note_year, invoice_id, invoice_year, payment_id,
		expense_type);

	SET result = 1;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteUpdate
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteUpdate`( 
	IN first_note_id INT(11), 
	IN first_note_year INT(11),
	IN exec_date DATE, 
	IN employee_id INT(11), 
	IN expense_type INT(11), 
	IN expense_value DECIMAL(11,2),
	IN expense_notes VARCHAR(100),
	IN invoice_id INT(11),
	IN invoice_year INT(11), 
	IN user_id INT(11), 
	IN recipient_id INT(11), 
	IN supplier_invoice_id INT(11), 
	IN supplier_invoice_year INT(11),
	IN payment_id INT(11), 
	OUT new_first_note_id INT(11), 
	OUT new_first_note_year INT(11), 
	OUT result INT(11)
)
BEGIN
	
	IF first_note_year <> YEAR(exec_date) THEN
		SET new_first_note_year = YEAR(exec_date);
		SELECT IFNULL(MAX(Id_prima_nota) + 1, 1)
			INTO new_first_note_id
		FROM prima_nota 
		WHERE anno = first_note_year;
	ELSE 
		SET new_first_note_year = first_note_year;
		SET new_first_note_id = first_note_id;
	END IF;

	UPDATE prima_nota
	SET 
		Id_prima_nota = new_first_note_id, 
		anno = new_first_note_year,
		`Data` = exec_date,
		`Dipendente` = employee_Id,
		`Tipo_spesa` = expense_type,
		`Spesa` = expense_value,
		`Note_spesa` = expense_notes,
		`id_utente` = user_id,
		`id_fattura` = invoice_id,
		`anno_fattura` = invoice_year,
		`id_fornfattura` = supplier_invoice_id,
		`anno_fornfattura` = supplier_invoice_year,
		`id_pagamento` = payment_id,
		`ricevente` = recipient_id
	WHERE `Id_prima_nota` = first_note_id AND
		`anno` = first_note_year;

	CALL sp_ariesFirstNoteEvaluateSupplierInvoice(new_first_note_id,
		new_first_note_year, supplier_invoice_id, supplier_invoice_year, payment_id,
		expense_type);

	CALL sp_ariesFirstNoteEvaluateInvoice(new_first_note_id,
		new_first_note_year, invoice_id, invoice_year, payment_id,
		expense_type);
		
	SET result = 1;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteEvaluateInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteEvaluateInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteEvaluateInvoice`( 
	IN first_note_id INT(11), 
	IN first_note_year INT(11),
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	IN invoice_payment INT(11),
	IN expense_type INT(11)
)
BEGIN
	DECLARE is_transfer_to BIT(1) DEFAULT false;
	
	SELECT IF(trasf = 1, true, false)
		INTO is_transfer_to
	FROM tipo_spesa
	WHERE Id_tipo = expense_type;

	IF (invoice_id IS NOT NULL 
	AND invoice_year IS NOT NULL
		AND invoice_payment IS NOT NULL) THEN
		
		if is_transfer_to = true THEN

			UPDATE fattura_pagamenti
			SET id_trasferimento_verso = first_note_id,
				anno_trasferimento_verso = first_note_year
			WHERE id_fattura = invoice_id
				AND anno = invoice_year
				AND id_pagamento = invoice_payment;

		ELSE

			UPDATE fattura_pagamenti
			SET Id_prima_nota = first_note_id,
				anno_prima_nota = first_note_year
			WHERE id_fattura = invoice_id
				AND anno = invoice_year
				AND id_pagamento = invoice_payment;

		END IF;
	END IF;
		
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesFirstNoteEvaluateSupplierInvoice
DROP PROCEDURE IF EXISTS sp_ariesFirstNoteEvaluateSupplierInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesFirstNoteEvaluateSupplierInvoice`( 
	IN first_note_id INT(11), 
	IN first_note_year INT(11),
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	IN invoice_payment INT(11),
	IN expense_type INT(11)
)
BEGIN
	DECLARE is_transfer_to BIT(1) DEFAULT false;
	
	SELECT IF(trasf = 1, true, false)
		INTO is_transfer_to
	FROM tipo_spesa
	WHERE Id_tipo = expense_type;

	IF (invoice_id IS NOT NULL 
	AND invoice_year IS NOT NULL
		AND invoice_payment IS NOT NULL) THEN
		
		if is_transfer_to = true THEN

			UPDATE fornfattura_pagamenti
			SET id_trasferimento_verso = first_note_id,
				anno_trasferimento_verso = first_note_year
			WHERE id_fattura = invoice_id
				AND anno = invoice_year
				AND id_pagamento = invoice_payment;

		ELSE

			UPDATE fornfattura_pagamenti
			SET Id_prima_nota = first_note_id,
				anno_prima_nota = first_note_year
			WHERE id_fattura = invoice_id
				AND anno = invoice_year
				AND id_pagamento = invoice_payment;

		END IF;
	END IF;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesGetDdtById
DROP PROCEDURE IF EXISTS sp_ariesGetDdtById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetDdtById`(
	enter_id INT(11), 
	enter_year INT(11)
)
BEGIN

	SELECT 
		`Id_ddt`,
		`anno`,
		`id_cliente`,
		`id_fornitore`,
		`Id_destinazione`,
		`condizione_pagamento`,
		`Porto_resa`,
		`data_documento`,
		`Vettore`,
		`data_ora_ritiro`,
		`data_ora_inizio`,
		`trasport_a_cura`,
		`Causale`,
		`Fattura`,
		`Anno_fattura`,
		`colli`,
		`Peso`,
		`Nota`,
		`Descrizione`,
		`id_principale`,
		`impianto`,
		`STAMPA`,
		`destinazione_forn`,
		`principale_forn`,
		`id_utente`,
		`data_modifica`,
		`stampa_ora`,
		`stampa_data_ora_ritiro`,
		`fatturaf`,
		`anno_fatturaf`,
		`stato`, 
		filename_firma_destinatario, 
		filename_firma_conducente
	FROM Ddt
	WHERE id_ddt = enter_id AND anno = enter_year;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesGetDdtStatusById
DROP PROCEDURE IF EXISTS sp_ariesGetDdtStatusById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetDdtStatusById`(
	status_id INT(11)
)
BEGIN

	SELECT `Id_stato`,
		`Nome`,
		`Descrizione`,
		`colore`
	FROM Stato_ddt
	WHERE Id_stato = status_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesGetReportStatusById
DROP PROCEDURE IF EXISTS sp_ariesGetReportStatusById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetReportStatusById`(
	status_id INT(11)
)
BEGIN

	SELECT `Id_stato`,
		`Nome`,
		`Descrizione`,
		`colore`,
		`bloccato`,
		fatturato
	FROM Stato_rapporto
	WHERE Id_stato = status_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesGetReportValidPermissionsById
DROP PROCEDURE IF EXISTS sp_ariesGetReportValidPermissionsById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetReportValidPermissionsById`(
	enter_id INT(11)
)
BEGIN

	SELECT `tipo_utente`,
		`Firma1`,
		`Firma2`,
		`Firma3`
	FROM rapporto_convalida
	WHERE tipo_utente = enter_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletDelete
DROP PROCEDURE IF EXISTS sp_ariesHamletDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM frazione 
	WHERE id_frazione = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletGet
DROP PROCEDURE IF EXISTS sp_ariesHamletGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletGet`( 
)
BEGIN
	SELECT Id_frazione,
	Nome,
	id_comune, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM frazione
	ORDER BY Id_frazione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletGetById
DROP PROCEDURE IF EXISTS sp_ariesHamletGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletGetById`( 
	Hamlet_id INT
)
BEGIN
	SELECT Id_frazione,
	Nome,
	id_comune,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM frazione
	WHERE Id_frazione = Hamlet_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletGetByName
DROP PROCEDURE IF EXISTS sp_ariesHamletGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletGetByName`( 
	name VARCHAR(30)
)
BEGIN
	SELECT Id_frazione,
	Nome,
	id_comune,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM frazione
	WHERE Nome = name;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletInsert
DROP PROCEDURE IF EXISTS sp_ariesHamletInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletInsert`( 
	name VARCHAR(30),
	municipality_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM comune 
	WHERE id_comune = municipality_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM frazione 
		WHERE Nome = Name; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Hamlet name already exists
		END IF;
	ELSE
		SET Result = -2; # municipality not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO frazione 
		SET 
			Nome = name,
			id_comune = municipality_id, 
			Data_ins = NOW(), 
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesHamletUpdate
DROP PROCEDURE IF EXISTS sp_ariesHamletUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesHamletUpdate`( 
	enter_id INTEGER,
	name VARCHAR(30),
	municipality_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM comune 
	WHERE id_comune = municipality_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM frazione 
		WHERE Nome = Name AND Id_frazione != enter_id; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Hamlet name already exists
		END IF;
	ELSE
		SET Result = -2; # municipality not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM frazione 
			WHERE id_frazione = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Hamlet ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		UPDATE frazione 
		SET 
			Nome = name,
			id_comune = municipality_id, 
			Utente_mod = @USER_ID
		Where id_frazione = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInterventionTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesInterventionTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInterventionTypeGetById`(
type_id INT(11)
)
BEGIN

	SELECT Id_tipo, 
		Nome, 
		Descrizione
	FROM Tipo_intervento
	WHERE Id_tipo = type_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoiceEvaluateStatus
DROP PROCEDURE IF EXISTS sp_ariesInvoiceEvaluateStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceEvaluateStatus`(
	invoice_id INT(11), 
	invoice_year INT(11)
)
BEGIN

	DECLARE totals_payments_to_do TINYINT; 
	DECLARE totals_payments_done TINYINT; 
	DECLARE new_status INT(11); 

	
	SELECT COUNT(IFNULL(Insoluto,1))
		INTO 
		totals_payments_done
	FROM fattura_pagamenti
	WHERE id_fattura=invoice_id AND anno=invoice_year AND data IS NOT NULL; 

	
	SELECT IFNULL(mesi, 0) 
		INTO
		totals_payments_to_do
	FROM fattura 
		INNER JOIN condizione_pagamento 
			ON fattura.cond_pagamento = condizione_pagamento.id_condizione
	WHERE id_fattura=invoice_id
			AND anno=invoice_year; 
	
	
	IF totals_payments_done = totals_payments_to_do THEN
		SET new_status = 3; 
	ELSE
		SET new_status = 1; 
	END IF; 
	
	UPDATE fattura 
	SET stato = new_status
	WHERE id_fattura= invoice_id
		AND anno= invoice_year 
		AND stato <> new_status; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoiceGet
DROP PROCEDURE IF EXISTS sp_ariesInvoiceGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceGet`(

)
BEGIN

	SELECT
		`Id`,
		`Id_fattura`,
		`anno`,
		1 as `Id_bollettario`,
		`id_cliente`,
		`id_destinazione`,
		`destinazione`,
		`Data_registrazione`,
		CAST(IFNULL(data_modifica ,'1970-01-01') AS DATETIME) data_modifica,
		`data`,
		`cond_pagamento`,
		`banca` ,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`iban`,
		`abi`,
		`cab`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`inviato`,
		CAST(IFNULL(pagato_il ,'00:00:00') AS TIME) pagato_il,
		IFNULL(`tramite`, 0) tramite,
		`insoluto`,
		`stampato`,
		`subappalto`,
		IFNULL(`id_utente`, 0) id_utente,
		`scont_mat`,
		IFNULL(`id_iv`, 0) id_iv,
		id_tipo_natura_iva,
		CAST(IFNULL(data_invio_promemoria ,'1970-01-01') AS DATETIME) data_invio_promemoria,
		IFNULL(`controllo_promemoria`, 1) controllo_promemoria,
		`area_attivita`,
		IFNULL(`nostra`, 0) nostra,
		`data_ultima_modifica`,
		importo_imponibile, 
		importo_iva,
		importo_totale,
		costo_totale,
		id_documento_ricezione,
		movimenta_magazzino
	FROM Fattura;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoiceGetById
DROP PROCEDURE IF EXISTS sp_ariesInvoiceGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceGetById`(
	IN enter_id INT(11)
)
BEGIN

	SELECT
		`Id`,
		`Id_fattura`,
		`anno`,
		1 as `Id_bollettario`,
		`id_cliente`,
		`id_destinazione`,
		`destinazione`,
		`Data_registrazione`,
		CAST(IFNULL(data_modifica ,'1970-01-01') AS DATETIME) data_modifica,
		`data`,
		`cond_pagamento`,
		`banca` ,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`iban`,
		`abi`,
		`cab`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`inviato`,
		CAST(IFNULL(pagato_il ,'00:00:00') AS TIME) pagato_il,
		IFNULL(`tramite`, 0) tramite,
		`insoluto`,
		`stampato`,
		`subappalto`,
		IFNULL(`id_utente`, 0) id_utente,
		`scont_mat`,
		IFNULL(`id_iv`, 0) id_iv,
		id_tipo_natura_iva,
		CAST(IFNULL(data_invio_promemoria ,'1970-01-01') AS DATETIME) data_invio_promemoria,
		IFNULL(`controllo_promemoria`, 1) controllo_promemoria,
		`area_attivita`,
		IFNULL(`nostra`, 0) nostra,
		`data_ultima_modifica`,
		importo_imponibile, 
		importo_iva,
		importo_totale,
		costo_totale,
		id_documento_ricezione,
		movimenta_magazzino
	FROM Fattura
	WHERE Fattura.Id = enter_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoiceGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesInvoiceGetByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceGetByIdAndYear`(
	IN enter_id INT(11), 
	IN enter_year INT(11)
)
BEGIN

	SELECT
		`Id`,
		`Id_fattura`,
		`anno`,
		1 as `Id_bollettario`,
		`id_cliente`,
		`id_destinazione`,
		`destinazione`,
		`Data_registrazione`,
		CAST(IFNULL(data_modifica ,'1970-01-01') AS DATETIME) data_modifica,
		`data`,
		`cond_pagamento`,
		`banca` ,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`iban`,
		`abi`,
		`cab`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`inviato`,
		CAST(IFNULL(pagato_il ,'00:00:00') AS TIME) pagato_il,
		IFNULL(`tramite`, 0) tramite,
		`insoluto`,
		`stampato`,
		`subappalto`,
		IFNULL(`id_utente`, 0) id_utente,
		`scont_mat`,
		IFNULL(`id_iv`, 0) id_iv,
		id_tipo_natura_iva,
		CAST(IFNULL(data_invio_promemoria ,'1970-01-01') AS DATETIME) data_invio_promemoria,
		IFNULL(`controllo_promemoria`, 1) controllo_promemoria,
		`area_attivita`,
		IFNULL(`nostra`, 0) nostra,
		`data_ultima_modifica`,
		importo_imponibile, 
		importo_iva,
		importo_totale,
		costo_totale,
		id_documento_ricezione,
		movimenta_magazzino
	FROM Fattura
	WHERE Fattura.Id_fattura = enter_id AND Fattura.anno = enter_year;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoiceGetByTagId
DROP PROCEDURE IF EXISTS sp_ariesInvoiceGetByTagId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceGetByTagId`(
	IN tag_id INT(11)
)
BEGIN

	SELECT
		`Id`,
		fattura.`Id_fattura`,
		`anno`,
		1 as `Id_bollettario`,
		`id_cliente`,
		`id_destinazione`,
		`destinazione`,
		`Data_registrazione`,
		CAST(IFNULL(data_modifica ,'1970-01-01') AS DATETIME) data_modifica,
		`data`,
		`cond_pagamento`,
		`banca` ,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`iban`,
		`abi`,
		`cab`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`inviato`,
		CAST(IFNULL(pagato_il ,'00:00:00') AS TIME) pagato_il,
		IFNULL(`tramite`, 0) tramite,
		`insoluto`,
		`stampato`,
		`subappalto`,
		IFNULL(`id_utente`, 0) id_utente,
		`scont_mat`,
		IFNULL(`id_iv`, 0) id_iv,
		id_tipo_natura_iva,
		CAST(IFNULL(data_invio_promemoria ,'1970-01-01') AS DATETIME) data_invio_promemoria,
		IFNULL(`controllo_promemoria`, 1) controllo_promemoria,
		`area_attivita`,
		IFNULL(`nostra`, 0) nostra,
		`data_ultima_modifica`,
		importo_imponibile, 
		importo_iva,
		importo_totale,
		costo_totale,
		id_documento_ricezione,
		movimenta_magazzino
	FROM Fattura
		INNER JOIN fattura_tag ON Fattura.id_fattura = fattura_tag.id_fattura AND Fattura.anno = fattura_tag.anno_fattura
	WHERE fattura_tag.id_tag = tag_id; 
		
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoiceInsert
DROP PROCEDURE IF EXISTS sp_ariesInvoiceInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceInsert`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN invoice_category INT(11),
	IN invoice_date DATE, 
	IN customer_id INT(11), 
	IN destination INT(11), 
	IN destination_id INT(11), 
	IN `registration_date` DATE,
	IN `edit_date` DATE,
	IN `payment_condition_id` INT(11),
	IN `bank_id` INT(11),
	IN `annotations` TEXT,
	IN `status_id` INT(11),
	IN `transport_casual_id` INT(11),
	IN `internal_note` VARCHAR(100),
	IN `iban` VARCHAR(45),
	IN `abi` VARCHAR(6),
	IN `cab` VARCHAR(6),
	IN `type_id` INT(11),
	IN `recessed_import` FLOAT(11,2),
	IN `stamp_import` FLOAT(11,2),
	IN `transport_import` FLOAT(11,2),
	IN `is_sent` INT(11),
	IN `sending_method` INT(11),
	IN `is_printed` TINYINT(1),
	IN `subcontract` TINYINT(4),
	IN `user_id` INT(11),
	IN `products_discount` VARCHAR(15),
	IN `vat_id` INT(11),
	IN `reminder_date` DATE,
	IN `reminder_check` TINYINt(1),
	IN `work_area` VARCHAR(45),
	IN `is_our` TINYINT(1), 
	OUT result INT(11) 
)
BEGIN

	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION; 

	

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePaymentGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoicePaymentGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePaymentGetByInvoice`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11)
)
BEGIN

	DECLARE iva_collectability VARCHAR(5); 
	SELECT esigibilita 
		INTO iva_collectability
	FROM fattura INNER JOIN tipo_iva ON fattura.id_iv = tipo_iva.id_iva
	WHERE Fattura.Id_fattura = invoice_id 
		AND fattura.anno = invoice_year;


	SELECT 
		IF(fattura_pagamenti.id_fattura IS NULL, false, True) AS 'Exists',
		fattura.id_fattura,
		fattura.anno, 
		fattura.id_cliente,
		ifNULL(id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d') AS UNSIGNED)) as id_pagamento_fix,
		fattura_pagamenti.nota,
		IFNULL(fattura_pagamenti.tipo_pagamento, a.tipo) as 'tipo_pagamento',
		fattura_pagamenti.insoluto,
		fattura_pagamenti.id_prima_nota,
		fattura_pagamenti.anno_prima_nota,
		fattura_pagamenti.id_trasferimento_verso,
		fattura_pagamenti.anno_trasferimento_verso,
		ROUND(IF(iva_collectability <> 'S', fattura.importo_totale, fattura.importo_imponibile)/a.mesi, 2) AS "importo_rata", 
		ROUND(fattura.importo_imponibile/a.mesi, 2) AS "importo_rata_imponibile", 
		ROUND(IF(iva_collectability <> 'S', fattura.importo_iva/a.mesi, 0), 2) AS "importo_rata_iva",  
		if (iva_collectability = 'S', 1, 0)  AS "split_payment", -- in questo caso l'iva non va a fare parte dell'importo della rata
		IFNULL(fattura_pagamenti.`data`, LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY) AS "data"
		
	FROM fattura
		INNER JOIN fattura_articoli AS c ON c.id_fattura = fattura.id_fattura AND c.anno=fattura.anno
		INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
		INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
		LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
	WHERE Fattura.Id_fattura = invoice_id 
		AND fattura.anno = invoice_year 
	GROUP BY fattura.id_fattura, fattura.anno, id_pagamento_fix
	ORDER BY fattura.anno desc, fattura.id_fattura desc;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePaymentGetById
DROP PROCEDURE IF EXISTS sp_ariesInvoicePaymentGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePaymentGetById`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11)
)
BEGIN
	DECLARE iva_collectability VARCHAR(5); 
	SELECT esigibilita 
		INTO iva_collectability
	FROM fattura INNER JOIN tipo_iva ON fattura.id_iv = tipo_iva.id_iva
	WHERE Fattura.Id_fattura = invoice_id 
		AND fattura.anno = invoice_year;

	SELECT 
		IF(fattura_pagamenti.id_fattura IS NULL, false, True) AS 'Exists',
		fattura.id_fattura,
		fattura.anno, 
		fattura.id_cliente,
		ifNULL(id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d') AS UNSIGNED)) as id_pagamento_fix,
		fattura_pagamenti.nota,
		IFNULL(fattura_pagamenti.tipo_pagamento, a.tipo) as 'tipo_pagamento',
		fattura_pagamenti.insoluto,
		fattura_pagamenti.id_prima_nota,
		fattura_pagamenti.anno_prima_nota,
		fattura_pagamenti.id_trasferimento_verso,
		fattura_pagamenti.anno_trasferimento_verso,
		ROUND(IF(iva_collectability <> 'S', fattura.importo_totale, fattura.importo_imponibile)/a.mesi, 2) AS "importo_rata", 
		ROUND(fattura.importo_imponibile/a.mesi, 2) AS "importo_rata_imponibile", 
		ROUND(IF(iva_collectability <> 'S', fattura.importo_iva/a.mesi, 0), 2) AS "importo_rata_iva",  
		if (iva_collectability = 'S', 1, 0)  AS "split_payment", -- in questo caso l'iva non va a fare parte dell'importo della rata
		IFNULL(fattura_pagamenti.`data`, LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY) AS "data"
		
	FROM fattura
		INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
		INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
		LEFT JOIN fattura_pagamenti ON fattura.id_fattura=fattura_pagamenti.id_fattura AND fattura_pagamenti.anno=fattura.anno AND fattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
	WHERE Fattura.Id_fattura = invoice_id 
		AND fattura.anno = invoice_year 
		AND IfNULL(id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d') AS UNSIGNED)) = payment_id
	GROUP BY fattura.id_fattura, fattura.anno, id_pagamento_fix
	ORDER BY fattura.anno desc, fattura.id_fattura desc;

	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePaymentInsert
DROP PROCEDURE IF EXISTS sp_ariesInvoicePaymentInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePaymentInsert`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11), 
	IN payment_date DATE, 
	IN notes TEXT, 
	IN payment_type INT(11), 
	IN unsolved BIT(1),
	OUT result INT(11)
)
BEGIN
	DECLARE reminder_date DATE;

	INSERT INTO fattura_pagamenti
	SET id_fattura = invoice_id, 
		anno = invoice_year, 
		id_pagamento = payment_id, 
		nota = notes, 
		tipo_pagamento = payment_type, 
		insoluto = unsolved,
		data = payment_date; 
	
	IF payment_date IS NULL THEN
		SET reminder_date = STR_TO_DATE('0002-02-02', '%Y-%m-%d');
	ELSE
		SET reminder_date = STR_TO_DATE(CONCAT(payment_id, ''), '%Y%m%d');
	END IF;
	
	UPDATE fattura 
	SET data_invio_promemoria = reminder_date 
	WHERE id_fattura = invoice_id AND anno = invoice_year;
	
	SET result = 1;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePaymentUpdate
DROP PROCEDURE IF EXISTS sp_ariesInvoicePaymentUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePaymentUpdate`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11), 
	IN payment_date DATE, 
	IN notes TEXT, 
	IN payment_type INT(11), 
	IN unsolved BIT(1),
	OUT result INT(11)
)
BEGIN
	DECLARE reminder_date DATE;
	DECLARE last_payment_date DATE; 
	
	IF (payment_date IS NULL OR (payment_type <> 4 AND payment_type <> 3)) THEN
		CALL sp_ariesFirstNoteDeleteByInvoice(invoice_id, invoice_year, payment_id, result);
	ELSE 
		SELECT data INTO last_payment_date 
		FROM fattura_pagamenti 
		WHERE id_fattura = invoice_id AND 
			anno = invoice_year AND 
			id_pagamento = payment_id;
			
		IF last_payment_date <> payment_date THEN
		
			UPDATE prima_nota
			SET Data = payment_date		
			WHERE id_fattura = invoice_id AND 
				anno_fattura = invoice_year AND 
				id_pagamento = payment_id;
			
		END IF; 
	END IF;
	
	UPDATE fattura_pagamenti
	SET  nota = notes, 
		tipo_pagamento = payment_type, 
		insoluto = unsolved,
		data = payment_date
	WHERE id_fattura = invoice_id AND 
		anno = invoice_year AND 
		id_pagamento = payment_id; 
		
	IF payment_date IS NULL THEN
		SET reminder_date = STR_TO_DATE('0002-02-02', '%Y-%m-%d');
	ELSE
		SET reminder_date = STR_TO_DATE(CONCAT(payment_id, ''), '%Y%m%d');
	END IF;
	
	UPDATE fattura 
	SET data_invio_promemoria = reminder_date 
	WHERE id_fattura = invoice_id AND anno = invoice_year;

	SET result = 1;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePrepaymentGet
DROP PROCEDURE IF EXISTS sp_ariesInvoicePrepaymentGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePrepaymentGet`( 

)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fattura_acconto;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePrepaymentGetById
DROP PROCEDURE IF EXISTS sp_ariesInvoicePrepaymentGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePrepaymentGetById`( 
	IN prepayment_id INT(11)
)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fattura_acconto
	WHERE id_acconto = prepayment_id;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePrepaymentGetByPayment
DROP PROCEDURE IF EXISTS sp_ariesInvoicePrepaymentGetByPayment;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePrepaymentGetByPayment`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11)
)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fattura_acconto
	WHERE id_fattura = invoice_id
		AND anno = invoice_year
		AND id_pagamento = payment_id;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePrepaymentGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoicePrepaymentGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePrepaymentGetByInvoice`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fattura_acconto
	WHERE id_fattura = invoice_id
		AND anno = invoice_year;
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesInvoiceProductGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoiceProductGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceProductGetByInvoice`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11)
)
BEGIN

	SELECT 
		`id_fattura`,
		`Anno`,
		`n_tab`,
		`Descrizione`,
		`um`,
		`quantità`,
		`prezzo_unitario`,
		`sconto`,
		`costo`,
		`serial_number`,
		`id_materiale`,
		`Iva`,
		`codice_fornitore`,
		`anno_rif`,
		`id_rif`,
		`tipo`,
		`idnota`
	FROM fattura_articoli
	WHERE id_fattura = invoice_id AND Anno = invoice_year
	ORDER BY n_tab ASC;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoiceUpdate
DROP PROCEDURE IF EXISTS sp_ariesInvoiceUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceUpdate`(
	IN enter_id INT(11),
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN invoice_category INT(11),
	IN invoice_date DATE, 
	IN customer_id INT(11), 
	IN destination INT(11), 
	IN destination_id INT(11), 
	IN `registration_date` DATE,
	IN `edit_date` DATE,
	IN `payment_condition_id` INT(11),
	IN `bank_id` INT(11),
	IN `annotations` TEXT,
	IN `status_id` INT(11),
	IN `transport_casual_id` INT(11),
	IN `internal_note` VARCHAR(100),
	IN `iban` VARCHAR(45),
	IN `abi` VARCHAR(6),
	IN `cab` VARCHAR(6),
	IN `type_id` INT(11),
	IN `recessed_import` FLOAT(11,2),
	IN `stamp_import` FLOAT(11,2),
	IN `transport_import` FLOAT(11,2),
	IN `is_sent` INT(11),
	IN `sending_method` INT(11),
	IN `is_printed` TINYINT(1),
	IN `subcontract` TINYINT(4),
	IN `user_id` INT(11),
	IN `products_discount` VARCHAR(15),
	IN `vat_id` INT(11),
	IN `reminder_date` DATE,
	IN `reminder_check` TINYINt(1),
	IN `work_area` VARCHAR(45),
	IN `is_our` TINYINT(1),
	OUT result INT(11)
)
BEGIN

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesInvoiceSaveTotals
DROP PROCEDURE IF EXISTS sp_ariesInvoiceSaveTotals;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceSaveTotals`(
	IN `invoice_id` INT(11),
	IN `total_amount` DECIMAL(11, 2),
	IN `taxable_amount` DECIMAL(11, 2),
	IN `tax_amount` DECIMAL(11, 2),
	IN `total_cost` DECIMAL(11, 2),
	OUT result BIT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION;
	
	UPDATE fattura
	SET importo_imponibile = taxable_amount,
		importo_iva = tax_amount,
		importo_totale = total_amount,
		costo_totale = total_cost
	WHERE id = invoice_id;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
				
END//
DELIMITER ;

	


-- Dump della struttura di procedura emmebi.sp_ariesJobGet
DROP PROCEDURE IF EXISTS sp_ariesJobGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobGet`()
BEGIN

	SELECT 
		Id,
		`Id_commessa`,
		`anno`,
		IFNULL(`id_cliente`, 0) 'Id_cliente',
		IFNULL(data_inizio, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_inizio',
		IFNULL(data_fine, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_fine',
		IFNULL(`stato_commessa`, 0) 'stato_commessa',
		IFNULL(`Descrizione`, '') Descrizione,
		IFNULL(`nr_appalto` , '') nr_appalto,
		IFNULL(`codice_commessa` , '') codice_commessa,
		IFNULL(data_scadenza, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_scadenza',
		IFNULL(`tipo_commessa`,0) 'tipo_commessa',
		IFNULL(`num_ordine` , '') num_ordine,
		`inv_com`,
		`stamp_com`,
		`Data_ins`,
		IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) 'Data_mod',
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) 'Utente_mod'
	FROM Commessa; 
				
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesJobGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesJobGetByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobGetByIdAndYear`(
job_id INT(11),
job_year SMALLINT)
BEGIN

	SELECT 
		Id, 
		`Id_commessa`,
		`anno`,
		IFNULL(`id_cliente`, 0) 'Id_cliente',
		IFNULL(data_inizio, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_inizio',
		IFNULL(data_fine, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_fine',
		IFNULL(`stato_commessa`, 0) 'stato_commessa',
		IFNULL(`Descrizione`, '') Descrizione,
		IFNULL(`nr_appalto` , '') nr_appalto,
		IFNULL(`codice_commessa` , '') codice_commessa,
		IFNULL(data_scadenza, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_scadenza',
		IFNULL(`tipo_commessa`,0) 'tipo_commessa',
		IFNULL(`num_ordine` , '') num_ordine,
		`inv_com`,
		`stamp_com`,
		`Data_ins`,
		IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) 'Data_mod',
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) 'Utente_mod'
	FROM Commessa
	WHERE anno = job_year AND Id_commessa = job_id; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobGetByYear
DROP PROCEDURE IF EXISTS sp_ariesJobGetByYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobGetByYear`(
job_year SMALLINT)
BEGIN

	SELECT 
		Id, 
		`Id_commessa`,
		`anno`,
		IFNULL(`id_cliente`, 0) 'Id_cliente',
		IFNULL(data_inizio, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_inizio',
		IFNULL(data_fine, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_fine',
		IFNULL(`stato_commessa`, 0) 'stato_commessa',
		IFNULL(`Descrizione`, '') Descrizione,
		IFNULL(`nr_appalto` , '') nr_appalto,
		IFNULL(`codice_commessa` , '') codice_commessa,
		IFNULL(data_scadenza, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_scadenza',
		IFNULL(`tipo_commessa`,0) 'tipo_commessa',
		IFNULL(`num_ordine` , '') num_ordine,
		`inv_com`,
		`stamp_com`,
		`Data_ins`,
		IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) 'Data_mod',
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) 'Utente_mod'
	FROM Commessa
	WHERE anno = job_year; 
				
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesJobGetByYear
DROP PROCEDURE IF EXISTS sp_ariesJobGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobGetByInvoice`(
invoice_id SMALLINT,
invoice_year SMALLINT)
BEGIN

	SELECT 
		Id, 
		commessa.Id_commessa,
		commessa.anno,
		IFNULL(`id_cliente`, 0) 'Id_cliente',
		IFNULL(data_inizio, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_inizio',
		IFNULL(data_fine, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_fine',
		IFNULL(`stato_commessa`, 0) 'stato_commessa',
		IFNULL(`Descrizione`, '') Descrizione,
		IFNULL(`nr_appalto` , '') nr_appalto,
		IFNULL(`codice_commessa` , '') codice_commessa,
		IFNULL(data_scadenza, CAST("1970-01-01 00:00:00" AS DATETIME)) 'data_scadenza',
		IFNULL(`tipo_commessa`,0) 'tipo_commessa',
		IFNULL(`num_ordine` , '') num_ordine,
		`inv_com`,
		`stamp_com`,
		`Data_ins`,
		IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) 'Data_mod',
		`Utente_ins`,
		IFNULL(`Utente_mod`, 0) 'Utente_mod'
	FROM Commessa
		INNER JOIN commessa_fattura ON commessa.id_commessa = commessa_fattura.id_commessa
			AND commessa.anno = commessa_fattura.anno_commessa
	WHERE id_fattura = invoice_id AND anno_fattura = invoice_year; 
				
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesJobProductGetByJob
DROP PROCEDURE IF EXISTS sp_ariesJobProductGetByJob;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductGetByJob`(
	IN job_id INT, 
	IN job_year SMALLINT, 
	IN lot_id INT,
	IN sub_job_id INT
)
BEGIN
	SELECT 
		Id_commessa,
		Anno,
		Id_sottocommessa,
		Lotto,
		Posizionamento,
		Codice_articolo,
		Codice_fornitore,
		Descrizione,
		Qta_utilizzata,
		Qta_commessa,
		Qta_preventivati,
		UM,
		Prezzo,
		Costo,
		Prezzo_ora,
		Costo_ora,
		Sconto,
		Tempo_installazione,
		Qta_economia
	FROM vw_jobbody
	WHERE Id_commessa = job_id
		AND Anno = job_year
		AND id_sottocommessa = sub_job_id
		AND IF(lot_id = -1, True, lot_id = Lotto);
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobProductGetByJobAndRowId
DROP PROCEDURE IF EXISTS sp_ariesJobProductGetByJobAndRowId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductGetByJobAndRowId`(
	IN job_id INT, 
	IN job_year SMALLINT, 
	IN lot_id INT,
	IN sub_job_id INT,
	IN row_id INT(11)
)
BEGIN

	SELECT 
		Id_commessa,
		Anno,
		Id_sottocommessa,
		Lotto,
		Posizionamento,
		Codice_articolo,
		Codice_fornitore,
		Descrizione,
		Qta_utilizzata,
		Qta_commessa,
		Qta_preventivati,
		UM,
		Prezzo,
		Costo,
		Prezzo_ora,
		Costo_ora,
		Sconto,
		Tempo_installazione,
		Qta_economia
	FROM vw_jobbody
	WHERE Id_commessa = job_id	AND Anno = job_year
		AND id_sottocommessa = sub_job_id AND Lotto = lot_id AND Posizionamento = row_id;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobProductGetByJobs
DROP PROCEDURE IF EXISTS sp_ariesJobProductGetByJobs;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductGetByJobs`(
	IN job_ids MEDIUMTEXT)
BEGIN

	
SET @s = CONCAT('
SELECT 
		Id_commessa,
		Anno,
		Id_sottocommessa,
		Lotto,
		Posizionamento,
		Codice_articolo,
		Codice_fornitore,
		Descrizione,
		Qta_utilizzata,
		Qta_commessa,
		Qta_preventivati,
		UM,
		Prezzo,
		Costo,
		Prezzo_ora,
		Costo_ora,
		Sconto,
		Tempo_installazione,
		Qta_economia
	FROM vw_jobbody
	WHERE ', job_ids, ' ORDER BY Anno , Id_commessa, Posizionamento;'); 

PREPARE stmt1 FROM @s; 
EXECUTE stmt1; 
DEALLOCATE PREPARE stmt1; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobProductInsert
DROP PROCEDURE IF EXISTS sp_ariesJobProductInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductInsert`(
	IN job_id INT, 
	IN job_year SMALLINT, 
	IN sub_job_id INT,
	IN lot_id INT,
	IN row_id INT(11), 
	IN product_code VARCHAR(16), 
	IN supplier_product_code VARCHAR(40), 
	IN description TEXT,
	IN measure_unit VARCHAR(5), 
	IN quantity DECIMAL(11,2), 
	IN price DECIMAL(11,2), 
	IN cost DECIMAL(11,2), 
	IN hourly_price DECIMAL(11,2), 
	IN hourly_cost DECIMAL(11,2), 
	IN installation_time INT(11), 
	IN discount INT(11), 
	IN quote_quantity DECIMAL(11,2), 
	OUT result SMALLINT
)
BEGIN


	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;

	IF (row_id = -1) OR (row_id = 999) OR (row_id IS NULL) THEN

	  SELECT MAX(id_tab) + 1
	  	INTO
		  row_id
	  FROM commessa_articoli
	  WHERE Id_commessa = job_id AND Anno = job_year AND id_lotto = lot_id; 

	END IF;

	INSERT INTO commessa_articoli
	SET 
		descrizione = description,
		quantità = quantity,
		codice_articolo = product_code,
		codice_fornitore = supplier_product_code,
		UM = measure_unit,
		prezzo = price,
		costo = cost,
		costo_ora = hourly_cost,
		tempo = installation_time,
		sconto = discount,
		prezzo_ora = hourly_price,
		preventivati = quote_quantity,
		Id_commessa = job_id, 
		Anno = job_year,
		id_lotto = lot_id,
		id_sottocommessa = sub_job_id,
		Id_tab = row_id;

	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobProductUpdate
DROP PROCEDURE IF EXISTS sp_ariesJobProductUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductUpdate`(
	IN job_id INT, 
	IN job_year SMALLINT, 
	IN sub_job_id INT,
	IN lot_id INT, 
	IN row_id INT(11), 
	IN product_code VARCHAR(16), 
	IN supplier_product_code VARCHAR(40), 
	IN description TEXT,
	IN measure_unit VARCHAR(5), 
	IN quantity DECIMAL(11,2), 
	IN price DECIMAL(11,2), 
	IN cost DECIMAL(11,2), 
	IN hourly_price DECIMAL(11,2), 
	IN hourly_cost DECIMAL(11,2), 
	IN installation_time INT(11), 
	IN discount INT(11), 
	IN quote_quantity DECIMAL(11,2), 
	OUT result SMALLINT
)
BEGIN

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;

	UPDATE commessa_articoli
	SET 
		descrizione = description,
		quantità = quantity,
		codice_articolo = product_code,
		codice_fornitore = supplier_product_code,
		UM = measure_unit,
		prezzo = price,
		costo = cost,
		costo_ora = hourly_cost,
		tempo = installation_time,
		sconto = discount,
		prezzo_ora = hourly_price,
		preventivati = quote_quantity
	WHERE Id_commessa = job_id	AND Anno = job_year AND
		Id_sottocommessa = sub_job_id AND id_lotto = lot_id AND Id_tab = row_id;

	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobSettingsGet
DROP PROCEDURE IF EXISTS sp_ariesJobSettingsGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobSettingsGet`()
BEGIN

	SELECT 
		tipo, 
		valore
	FROM commessa_impostazioni_default; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobSpecificSettingsGet
DROP PROCEDURE IF EXISTS sp_ariesJobSpecificSettingsGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobSpecificSettingsGet`()
BEGIN

	SELECT 
		Id_commessa,
		anno,
		tipo, 
		valore
	FROM commessa_impostazioni; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesJobSpecificSettingsGetBy
DROP PROCEDURE IF EXISTS sp_ariesJobSpecificSettingsGetBy;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobSpecificSettingsGetBy`(
	IN `job_id` INT(11),
	IN `job_year` INT(11), 
	IN `name` VARCHAR(30)
	)
BEGIN
	IF name IS NULL THEN
		SELECT 
			Id_commessa,
			anno,
			tipo, 
			valore
		FROM commessa_impostazioni
		WHERE id_commessa = job_id AND anno = job_year; 
	
	ELSE
		SELECT 
			Id_commessa,
			anno,
			tipo, 
			valore
		FROM commessa_impostazioni
		WHERE id_commessa = job_id AND anno = job_year AND Tipo = name; 
	END IF; 
			
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesJobUnionLots
DROP PROCEDURE IF EXISTS sp_ariesJobUnionLots;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobUnionLots`(
	IN `job_id` INT(11),
	IN `job_year` INT(11),
	IN `sub_job_id` INT(11),
	IN `job_lot_destination` INT(11),
	IN `job_lot_source` INT(11),
	OUT result SMALLINT
)
BEGIN

  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
  
  SET result = 1; 
  
  START TRANSACTION; 
  
  DROP TABLE IF EXISTS  temp_jobs_products_for_union; 
  
  CREATE TEMPORARY TABLE temp_jobs_products_for_union (
	  	`id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	  	`id_commessa` INT(11) NOT NULL,
	  	`id_sottocommessa` INT(11) NOT NULL,
		`anno` INT(11) NOT NULL,
		`descrizione` TEXT NULL,
		`quantità` DECIMAL(11,2) NULL DEFAULT NULL,
		`codice_articolo` VARCHAR(16) NULL DEFAULT NULL,
		`codice_fornitore` VARCHAR(40) NULL DEFAULT NULL,
		`UM` VARCHAR(5) NULL DEFAULT NULL,
		`id_tab` INT(11) NOT NULL,
		`economia` DECIMAL(11,2) NULL DEFAULT NULL,
		`id_lotto` INT(11) NOT NULL DEFAULT '0',
		`prezzo` DECIMAL(11,2) NULL DEFAULT '0.00',
		`costo` DECIMAL(11,2) NULL DEFAULT '0.00',
		`costo_ora` DECIMAL(11,2) NULL DEFAULT '0.00',
		`tempo` INT(11) NULL DEFAULT '0',
		`sconto` DECIMAL(11,2) NULL DEFAULT '0.00',
		`prezzo_ora` DECIMAL(11,2) NULL DEFAULT '0.00',
		`preventivati` DECIMAL(11,2) NULL DEFAULT '0.00',
		`Lunghezza` INT(11) NULL DEFAULT NULL,
		`iva` INT(11) NULL DEFAULT NULL
	);
	
	INSERT INTO temp_jobs_products_for_union
	   (`id_commessa`, `anno`, id_sottocommessa, `descrizione`, `quantità`, `codice_articolo`, `codice_fornitore`, `UM`, `id_tab`, `economia`, `id_lotto`,
		`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, `preventivati`, `Lunghezza`, `iva`)
		
	SELECT `id_commessa`, `anno`, id_sottocommessa, `descrizione`, SUM(`quantità`), `codice_articolo`, `codice_fornitore`, `UM`, `id_tab`, `economia`, `id_lotto`,
		`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, SUM(`preventivati`), `Lunghezza`, `iva`
	FROM (
		-- EXTRACT ALL ARTICLE FROM DESTINATION
		SELECT `id_commessa`, `anno`, id_sottocommessa, `descrizione`, `quantità`, `codice_articolo`, `codice_fornitore`, `UM`, `id_tab`, `economia`, `id_lotto`,
			`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, `preventivati`, `Lunghezza`, `iva`
		FROM commessa_articoli 
		WHERE id_commessa = job_id 
			AND id_sottocommessa = sub_job_id
			AND anno = job_year 
			AND id_lotto = job_lot_destination
		
		UNION ALL
		
		-- EXTRACT ALL ARTICLE FROM SOURCE 
		SELECT `id_commessa`, `anno`, id_sottocommessa, `descrizione`, `quantità`, `codice_articolo`, `codice_fornitore`, `UM`, `id_tab`, `economia`, `id_lotto`,
			`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, `preventivati`, `Lunghezza`, `iva`
		FROM commessa_articoli 
		WHERE id_commessa = job_id 
			AND anno = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = job_lot_source	
	) AS under_query
	GROUP BY CONCAT(IFNULL(codice_articolo, "NOTA"),"-", prezzo, "-", costo, "-", sconto) 
	ORDER BY FIELD(id_lotto, job_lot_source) ASC, id_tab ASC;
	
	
	DELETE FROM commessa_articoli 
	WHERE id_commessa = job_id 
		AND anno = job_year 
		AND id_sottocommessa = sub_job_id
		AND id_lotto IN (job_lot_source, job_lot_destination); 
		
	INSERT INTO commessa_articoli
		   (`id_commessa`, `anno`, id_sottocommessa, `descrizione`, `quantità`, `codice_articolo`, `codice_fornitore`, `UM`, `id_tab`, `economia`, `id_lotto`,
		`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, `preventivati`, `Lunghezza`, `iva`)
	SELECT 
		`id_commessa`, `anno`, id_sottocommessa, `descrizione`, `quantità`, `codice_articolo`, `codice_fornitore`, `UM`, `id`, `economia`, job_lot_destination,
		`prezzo`, `costo`, `costo_ora`, `tempo`, `sconto`, `prezzo_ora`, `preventivati`, `Lunghezza`, `iva`
	FROM temp_jobs_products_for_union; 


	UPDATE commessa_ddt 
	SET id_lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno_commessa = job_year 
		AND id_lotto = job_lot_source;
	
	UPDATE commessa_fattura 
	SET id_lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno_commessa = job_year 
		AND id_lotto = job_lot_source; 
	
	UPDATE commessa_rapporto 
	SET id_lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno_commessa = job_year 
		AND id_lotto = job_lot_source; 
		
	UPDATE ordine_dettaglio 
	SET com_lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno_commessa = job_year 
		AND com_lotto = job_lot_source; 
	
	UPDATE commessa_preventivo 
	SET lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno = job_year 
		AND lotto = job_lot_source; 
	
	UPDATE commessa_ddtr 
	SET id_lotto = job_lot_destination
	WHERE id_commessa = job_id 
		AND anno_commessa = job_year 
		AND id_lotto = job_lot_source; 
	
	DELETE FROM commessa_lotto 
	WHERE id_commessa = job_id 
		AND anno = job_year 
		AND id_lotto = job_lot_source; 
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesLogoConfigurationGet
DROP PROCEDURE IF EXISTS sp_ariesLogoConfigurationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesLogoConfigurationGet`(
)
BEGIN

	SELECT nome, 
		attivo, 
		tipo
	FROM configurazione_loghi; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesLogoConfigurationGetByNameAndType
DROP PROCEDURE IF EXISTS sp_ariesLogoConfigurationGetByNameAndType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesLogoConfigurationGetByNameAndType`(
	name VARCHAR(30), 
	logo_type VARCHAR(45)
)
BEGIN

	SELECT nome, 
		attivo, 
		tipo
	FROM configurazione_loghi
	WHERE nome = name AND tipo = logo_type; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityDelete
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM Comune 
	WHERE id_comune = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityGet
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityGet`( 
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	ORDER BY Id_comune;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityGetById
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityGetById`( 
	municipality_id INT
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	WHERE Id_Comune = municipality_id;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityGetByName
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityGetByName`( 
	IN `name` VARCHAR(100)
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	WHERE nome = `name`;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityGetByPostalCode
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityGetByPostalCode;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityGetByPostalCode`( 
	postal_code VARCHAR(30)
)
BEGIN
	SELECT Id_comune,
	Nome,
	Provincia, 
	Cap, 
	Id_Provincia,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Comune
	WHERE Cap = postal_code;
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityInsert
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityInsert`( 
	name VARCHAR(30),
	province varchar(15),
	postal_code varchar(10),
	province_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Province 
	WHERE sigla = province AND id_provincia = province_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Comune 
		WHERE Nome = Name AND Cap = postal_code; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Municipality name & postal code already exists
		END IF;
	ELSE
		SET Result = -2; # province not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO Comune 
		SET 
			Nome = name,
			Provincia = province , 
			Cap = postal_code, 
			Id_Provincia = province_id,
			Data_ins = NOW(),  
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesMunicipalityUpdate
DROP PROCEDURE IF EXISTS sp_ariesMunicipalityUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesMunicipalityUpdate`( 
	enter_id INTEGER,
	name VARCHAR(30),
	province varchar(15),
	postal_code varchar(10),
	province_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Province 
	WHERE sigla = province AND id_provincia = province_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Comune 
		WHERE Nome = Name AND Cap = postal_code AND id_comune != enter_id;
		
		IF Result > 0 THEN
			 SET Result = -1; # Municipality name & postal code already exists
		END IF;
	ELSE
		SET Result = -2; # province not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Comune 
			WHERE id_comune = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Municipality ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		UPDATE Comune 
		SET 
			Nome = name,
			Provincia = province , 
			Cap = postal_code, 
			Id_Provincia = province_id,
			Utente_mod = @USER_ID
		Where id_comune = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesNoteGet
DROP PROCEDURE IF EXISTS sp_ariesNoteGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesNoteGet`(
)
BEGIN

	SELECT 
	`id_nota`,
	`Nome`,
	`note`,
	`prezz`,
	`cost`,
	`temp`,
	`nota_stato`,
	`Data_mod`
	FROM Nota
	ORDER BY Id_nota; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesNoteGetById
DROP PROCEDURE IF EXISTS sp_ariesNoteGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesNoteGetById`(
	note_id INT(11)
)
BEGIN

	SELECT 
	`id_nota`,
	`Nome`,
	`note`,
	`prezz`,
	`cost`,
	`temp`,
	`nota_stato`,
	`Data_mod`
	FROM Nota
	WHERE Id_nota = note_id; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesOrderSupplierMarkAsComplete
DROP PROCEDURE IF EXISTS sp_ariesOrderSupplierMarkAsComplete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesOrderSupplierMarkAsComplete`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
	DECLARE previous_status INT(11);

	SELECT stato INTO previous_status
	FROM ordine_fornitore
	WHERE id_ordine = enter_id AND Anno = enter_year; 

	IF previous_status = 3 OR previous_status = 1 THEN
		UPDATE ordine_fornitore
		SET segna_come_evaso = 1,
			utente_evasione = @USER_ID,
			stato_pre_evasione = previous_status,
			stato = 4
		WHERE id_ordine = enter_id AND Anno = enter_year; 
	END IF;	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesOrderSupplierUnmarkAsComplete
DROP PROCEDURE IF EXISTS sp_ariesOrderSupplierUnmarkAsComplete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesOrderSupplierUnmarkAsComplete`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
	DECLARE pre_completed_status INT(11);

	SELECT stato_pre_evasione INTO pre_completed_status
	FROM ordine_fornitore
	WHERE id_ordine = enter_id AND Anno = enter_year; 

	IF pre_completed_status IS NOT NULL  THEN
		UPDATE ordine_fornitore
		SET segna_come_evaso = 0,
			utente_evasione = @USER_ID,
			stato_pre_evasione = NULL,
			stato = pre_completed_status
		WHERE id_ordine = enter_id AND Anno = enter_year; 
	END IF;	
END//
DELIMITER ;




-- Dump della struttura di procedura emmebi.sp_ariesOrderSupplierRowDeleteByOrderSupplier
DROP PROCEDURE IF EXISTS sp_ariesOrderSupplierRowDeleteByOrderSupplier;
DELIMITER //
CREATE  PROCEDURE `sp_ariesOrderSupplierRowDeleteByOrderSupplier`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	DELETE FROM ordine_dettaglio
	WHERE id_ordine = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesOrderSupplierRowGetByOrderSupplier
DROP PROCEDURE IF EXISTS sp_ariesOrderSupplierRowGetByOrderSupplier;
DELIMITER //
CREATE  PROCEDURE `sp_ariesOrderSupplierRowGetByOrderSupplier`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	SELECT 
		`id_ordine`,
		`anno`,
		`numero_tab`,
		`id_Articolo`,
		`desc_breve`,
		`codice_fornitore`,
		`id_cliente`,
		`id_fornitore`,
		`qt`,
		`scadenza`,
		`id_nota`,
		`id_commessa`,
		`anno_commessa`,
		`com_lotto`,
		`tipo`,
		`prez`,
		`iva` 
	FROM ordine_dettaglio
	WHERE id_ordine = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPathConfigurationGet
DROP PROCEDURE IF EXISTS sp_ariesPathConfigurationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPathConfigurationGet`(
)
BEGIN

	SELECT configurazione_percorsi.Tipo_percorso, 
		configurazione_percorsi.Percorso
	FROM configurazione_percorsi;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPaymentConditionDelete
DROP PROCEDURE IF EXISTS sp_ariesPaymentConditionDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPaymentConditionDelete`(
	IN payment_condition_id INT(11), 
	OUT result INT(11)
)
BEGIN
	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	


	IF result = 1 THEN
		DELETE FROM condizione_pagamento
		WHERE id_condizione = payment_condition_id; 
	END IF; 

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPaymentConditionGet
DROP PROCEDURE IF EXISTS sp_ariesPaymentConditionGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPaymentConditionGet`()
BEGIN
	SELECT 
		id_condizione, 
		Nome, 
		Descrizione, 
		tipo, 
		pagato,
		mesi, 
		modalitaPA,
		condizioniPA, 
		Chiusura_alla_scadenza, 
		id_utente,
		Timestamp
	FROM condizione_pagamento;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPaymentConditionGetById
DROP PROCEDURE IF EXISTS sp_ariesPaymentConditionGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPaymentConditionGetById`(
	IN payment_condition_id INT(11)
)
BEGIN
	SELECT 
		id_condizione, 
		Nome, 
		Descrizione, 
		tipo, 
		pagato,
		mesi, 
		modalitaPA,
		condizioniPA, 
		Chiusura_alla_scadenza, 
		id_utente,
		Timestamp
	FROM condizione_pagamento
	WHERE id_condizione = payment_condition_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPaymentConditionInsert
DROP PROCEDURE IF EXISTS sp_ariesPaymentConditionInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPaymentConditionInsert`(
	IN name VARCHAR(30),
	IN description VARCHAR(20), 
	IN type_id INT(11), 
	IN total_months INT(10), 
	IN is_paid BIT(1), 
	IN pa_modality VARCHAR(5), 
	IN pa_condition VARCHAR(5), 
	IN auto_closed BIT(1), 
	OUT result INT(11)
)
BEGIN

	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION;

	SELECT Count(Chiusura_alla_scadenza) 
		INTO Result
	FROM condizione_pagamento 
	WHERE nome = name; 

	IF Result != 0 THEN
		SET Result = -1; -- name already used
	END IF; 

	IF Result = 0 THEN
		SELECT Count(Id_tipo) 
			INTO Result
		FROM Tipo_pagamento
		WHERE id_Tipo = type_id; 
	END IF; 

	IF Result = 0 THEN
		SET Result = -2; -- payment type not found
	END IF; 

	IF Result = 1 THEN
		INSERT INTO condizione_pagamento
		SET  
			Nome = name, 
			Descrizione = description, 
			tipo = type_id, 
			pagato = is_paid,
			mesi = total_months, 
			modalitaPA = pa_modality,
			condizioniPA = pa_condition, 
			Chiusura_alla_scadenza = auto_closed, 
			id_utente = @USER_ID;

					
		SET Result = LAST_INSERT_ID();
	END IF;


	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPaymentConditionUpdate
DROP PROCEDURE IF EXISTS sp_ariesPaymentConditionUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPaymentConditionUpdate`(
	IN payment_condition_id INT(11), 
	IN name VARCHAR(30),
	IN description VARCHAR(20), 
	IN type_id INT(11), 
	IN total_months INT(10), 
	IN is_paid BIT(1), 
	IN pa_modality VARCHAR(5), 
	IN pa_condition VARCHAR(5), 
	IN auto_closed BIT(1), 
	OUT result INT(11)
)
BEGIN
	
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION;

	SELECT Count(Chiusura_alla_scadenza) 
		INTO Result
	FROM condizione_pagamento 
	WHERE nome = name AND id_condizione != payment_condition_id; 

	IF Result != 0 THEN
		SET Result = -1; -- name already used
	END IF; 

	IF Result = 0 THEN
		SELECT Count(Id_tipo) 
			INTO Result
		FROM Tipo_pagamento
		WHERE id_Tipo = type_id; 
	END IF; 

	IF Result = 0 THEN
		SET Result = -2; -- payment type not found
	END IF; 


	IF result = 1 THEN
		UPDATE condizione_pagamento
		SET 
			Nome = name, 
			Descrizione = description, 
			tipo = type_id, 
			pagato = is_paid,
			mesi = total_months, 
			modalitaPA = pa_modality,
			condizioniPA = pa_condition, 
			Chiusura_alla_scadenza = auto_closed, 
			id_utente = @USER_ID
		WHERE id_condizione = payment_condition_id; 
	END IF; 

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPrinterFormsFormatGetBy
DROP PROCEDURE IF EXISTS sp_ariesPrinterFormsFormatGetBy;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPrinterFormsFormatGetBy`(
	IN document_id INT(11), 
	IN form_id INT(11)
)
BEGIN
	SELECT 
		stampante_moduli_formati.Id, 
		stampante_moduli_formati.Id_modulo,
		stampante_moduli_formati.Id_documento, 
		stampante_moduli_formati.Id_formato, 
		stampante_formati.Nome
	FROM stampante_moduli_formati
		INNER JOIN stampante_formati ON 
		stampante_moduli_formati.Id_formato = stampante_formati.Id
	WHERE stampante_moduli_formati.Id_documento = document_id
		AND stampante_moduli_formati.Id_modulo = form_id; 	
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesPrinterFormsGet
DROP PROCEDURE IF EXISTS sp_ariesPrinterFormsGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPrinterFormsGet`()
BEGIN
	SELECT 
		`id_documento`,
		`modulo`,
		`Id_modulo`,
		`mail`,
		`pdf`,
		`fax`,
		`stampa`,
		`anteprima`,
		IFNULL(`File_name`, '') AS File_name,
		IFNULL(`Report_name`, '') AS Report_name,
		`Attivo`
	FROM stampante_moduli; 	
			
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesPrinterFormsGetByDocumentAndForm
DROP PROCEDURE IF EXISTS sp_ariesPrinterFormsGetByDocumentAndForm;
DELIMITER //
CREATE  PROCEDURE `sp_ariesPrinterFormsGetByDocumentAndForm`(
	IN document_id INT(11), 
	IN form_id INT(11)
)
BEGIN
	SELECT 
		`id_documento`,
		`modulo`,
		`Id_modulo`,
		`mail`,
		`pdf`,
		`fax`,
		`stampa`,
		`anteprima`,
		IFNULL(`File_name`, '') AS File_name,
		IFNULL(`Report_name`, '') AS Report_name,
		`Attivo`
	FROM stampante_moduli
	WHERE Id_documento = document_id
		AND Id_modulo = form_id; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategoryDelete
DROP PROCEDURE IF EXISTS sp_ariesProductCategoryDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategoryDelete`(
	IN ProductCategoryId INT(11),
	OUT result INT(11)
)
BEGIN

	SELECT COUNT(Codice_articolo)
		INTO Result
	FROM Articolo
	WHERE articolo.Categoria = ProductCategoryId; 
	
	IF Result > 0 THEN
		SET Result := -3; 
	ELSE
		DELETE
		FROM categoria_merciologica
		WHERE categoria_merciologica.Id_categoria = ProductCategoryId; 
		
		SET result = 1;
	END IF; 

	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategoryGet
DROP PROCEDURE IF EXISTS sp_ariesProductCategoryGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategoryGet`(
)
BEGIN

	SELECT `Id_categoria`,
		`Nome` ,
		IFNULL(`Descrizione`, '') Descrizione,
		Movimenta_magazzino, 
		Movimenta_impianto, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		IFNULL(`Utente_mod`, 0) Utente_mod,
		STR_TO_DATE(IFNULL(`Data_ins`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_ins,
		Data_mod
	FROM categoria_merciologica; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategoryGetById
DROP PROCEDURE IF EXISTS sp_ariesProductCategoryGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategoryGetById`(
	IN ProductCategoryId INT(11)
)
BEGIN

	SELECT `Id_categoria`,
		`Nome` ,
		IFNULL(`Descrizione`, '') Descrizione,
		Movimenta_magazzino, 
		Movimenta_impianto, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		IFNULL(`Utente_mod`, 0) Utente_mod,
		STR_TO_DATE(IFNULL(`Data_ins`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_ins,
		Data_mod
	FROM categoria_merciologica
	WHERE Id_categoria = ProductCategoryId; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategoryInsert
DROP PROCEDURE IF EXISTS sp_ariesProductCategoryInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategoryInsert`(
	IN Name VARCHAR(50),
	IN Description TEXT,
	IN HasDepositMovement BIT, 
	IN HasSystemMovement BIT,
	OUT Result INT(11)
)
BEGIN

	SET Result = 0;
	
	IF Name = '' THEN
		SET Result = -2; -- name cannot be empty
	 
	ELSE 
	
		SELECT COUNT(categoria_merciologica.Id_categoria) 
			INTO Result
		FROM categoria_merciologica 
		WHERE categoria_merciologica.Nome = Name; 
		
		IF Result > 0 THEN
			SET Result = -1; -- current name is already used
		END IF;
		 
	END IF; 
	
	IF Result >= 0 THEN
	
		INSERT INTO categoria_merciologica 
		SET 
			categoria_merciologica.Nome = Name, 
			categoria_merciologica.Descrizione = Description, 
			categoria_merciologica.Movimenta_magazzino = HasDepositMovement, 
			categoria_merciologica.Movimenta_impianto = HasSystemMovement, 
			categoria_merciologica.Data_ins = NOW(), 
			categoria_merciologica.Utente_ins = @USER_ID, 
			categoria_merciologica.Utente_mod = @USER_ID; 	 
		
		 SET Result  = LAST_INSERT_ID();
		 
	END IF; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategorySearchByName
DROP PROCEDURE IF EXISTS sp_ariesProductCategorySearchByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategorySearchByName`(
	IN name MEDIUMTEXT
)
BEGIN

	SELECT `Id_categoria`,
		`Nome` ,
		IFNULL(`Descrizione`, '') Descrizione,
		Movimenta_magazzino, 
		Movimenta_impianto, 
		IFNULL(`Utente_ins` , 0) Utente_ins,
		IFNULL(`Utente_mod`, 0) Utente_mod,
		STR_TO_DATE(IFNULL(`Data_ins`, '1970-01-01 00:00:00'), '%Y-%m-%d') data_ins,
		Data_mod
	FROM categoria_merciologica
	WHERE Nome Like CONCAT('%', name, '%'); 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductCategoryUpdate
DROP PROCEDURE IF EXISTS sp_ariesProductCategoryUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductCategoryUpdate`(
	IN ProductCategoryId INT(11), 
	IN Name VARCHAR(50),
	IN Description TEXT,
	IN HasDepositMovement BIT, 
	IN HasSystemMovement BIT,
	OUT Result INT(11)
)
BEGIN

	SET Result = 0;
	
	IF Name = '' THEN
		SET Result = -2; -- name cannot be empty
	 
	ELSE 
	
		SELECT COUNT(categoria_merciologica.Id_categoria) 
			INTO Result
		FROM categoria_merciologica 
		WHERE categoria_merciologica.Nome = Name AND categoria_merciologica.Id_categoria != ProductCategoryId; 
		
		IF Result > 0 THEN
			SET Result = -1; -- current name is already used
		END IF;
		 
	END IF; 
	
	IF Result >= 0 THEN
	
		UPDATE categoria_merciologica 
		SET 
			categoria_merciologica.Nome = Name, 
			categoria_merciologica.Descrizione = Description, 
			categoria_merciologica.Movimenta_magazzino = HasDepositMovement, 
			categoria_merciologica.Movimenta_impianto = HasSystemMovement, 
			categoria_merciologica.Utente_mod = @USER_ID 	 
		WHERE categoria_merciologica.Id_categoria = ProductCategoryId; 
		 
		SET Result = 1;
	END IF; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductGet
DROP PROCEDURE IF EXISTS sp_ariesProductGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductGet`( 
)
BEGIN    
	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductGetByBrand
DROP PROCEDURE IF EXISTS sp_ariesProductGetByBrand;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductGetByBrand`( 
	brand VARCHAR(5)
)
BEGIN
  
	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
	WHERE marca  = brand; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductGetByCategoryId
DROP PROCEDURE IF EXISTS sp_ariesProductGetByCategoryId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductGetByCategoryId`( 
category_id INT
)
BEGIN
        

	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
	WHERE Caregoria  = category_id; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductGetById
DROP PROCEDURE IF EXISTS sp_ariesProductGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductGetById`( 
product_code VARCHAR(11)
)
BEGIN
    
	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
	WHERE Codice_articolo = product_code; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductNoteGetByCodeAndDescription
DROP PROCEDURE IF EXISTS sp_ariesProductNoteGetByCodeAndDescription;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductNoteGetByCodeAndDescription`(
	product_code VARCHAR(13), 
	description VARCHAR(40)
)
BEGIN

	SELECT 
		Id_articolo, 
		Descrizione, 
		Nota, 
		data_ult_modifica
	FROM articolo_nota
	WHERE Id_articolo = product_code AND Descrizione = description
	ORDER BY Id_articolo, Descrizione; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductNoteInsertOrUpdate
DROP PROCEDURE IF EXISTS sp_ariesProductNoteInsertOrUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductNoteInsertOrUpdate`(
	product_code VARCHAR(13), 
	description VARCHAR(40), 
	note TEXT
)
BEGIN

	INSERT INTO articolo_nota (Id_articolo, descrizione, nota) VALUES (product_code,description,note)
  		ON DUPLICATE KEY UPDATE nota = note; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductPriceListGetByCode
DROP PROCEDURE IF EXISTS sp_ariesProductPriceListGetByCode;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductPriceListGetByCode`(
	product_code VARCHAR(13)
)
BEGIN

	SELECT 
	`Id_articolo`,
	`Id_listino`,
	`Prezzo`,
	`data_inizio`,
	`Data_mod`
	FROM articolo_listino
	WHERE Id_articolo = product_code 
	ORDER BY Id_articolo, Id_listino; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductRowNumbers
DROP PROCEDURE IF EXISTS sp_ariesProductRowNumbers;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductRowNumbers`( 
)
BEGIN
SELECT
	COUNT(*)
FROM articolo; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductSerchById
DROP PROCEDURE IF EXISTS sp_ariesProductSerchById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSerchById`( 
product_code VARCHAR(11)
)
BEGIN
        

	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
	WHERE Codice_articolo LIKE CONCAT("%", product_code, "%"); 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductSerchById
DROP PROCEDURE IF EXISTS sp_ariesProductSerchById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSerchById`( 
product_code VARCHAR(11)
)
BEGIN
        

	SELECT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
	WHERE Codice_articolo LIKE CONCAT("%", product_code, "%"); 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductFindByCodesOrDescription
DROP PROCEDURE IF EXISTS sp_ariesProductFindByCodesOrDescription;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductFindByCodesOrDescription`( 
	codes MEDIUMTEXT,
	description MEDIUMTEXT
)
BEGIN
			
	SELECT DISTINCT
		Codice_articolo, 
		IFNULL(Desc_Brev, "") AS Desc_brev,
		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 
		IFNULL(Marca, "") AS MArca, 
		Peso, 
		IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,
		IFNULL(Scadenza, 0) AS scadenza, 
		IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 
		Tempo_installazione, 
		IFNULL(Categoria, 0) AS Categoria, 
		IFNULL(SottoCategoria, 0) AS Sottocategoria, 
		IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 
		IFNULL(Barcode, "") AS Barcode, 
		Quantita_massima, 
		Quantita_minima, 
		NUmero_confezione, 
		IFNULL(Unità_misura,  "") AS Unità_misura, 
		IFNULL(ult_vendita, 0) AS ult_vendita, 
		IFNULL(garanzia, 0) AS Garanzia, 
		IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,
		Stato_articolo, 
		Data_inserimento, 
		uso_consumo,
		IFNULL(umidità, 0) as umidità, 
		IFNULL(min, 0) as min, 
		IFNULL(max, 0) AS max,
		IFNULL(l, 0) AS l, 
		IFNULL(h, 0) AS h, 
		IFNULL(p, 0) AS p,
		modifica, 
		kw, 
		litri, 
		kwp, 
		IFNULL(Color, "") AS Color, 
		moltiplicatore, 
		Is_Kit,
		articolo.scaffaliera_magazzino,
		articolo.ripiano_magazzino,
		articolo.descrizione_posizione_magazzino
	FROM articolo
		LEFT JOIN articolo_nota ON articolo.Codice_articolo = articolo_nota.Id_articolo
		LEFT JOIN articolo_codice ON articolo.codice_articolo = articolo_codice.id_articolo
	WHERE FIND_IN_SET(Codice_articolo, codes) > 0
		OR FIND_IN_SET(Codice_fornitore, codes) > 0
		OR FIND_IN_SET(codice, codes) > 0
		OR Desc_Brev = description
		OR Nota = description;
			
END//
DELIMITER ;




-- Dump della struttura di procedura emmebi.sp_ariesProvinceDelete
DROP PROCEDURE IF EXISTS sp_ariesProvinceDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM province 
	WHERE id_provincia = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProvinceGet
DROP PROCEDURE IF EXISTS sp_ariesProvinceGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceGet`( 
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	ORDER BY id_provincia;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProvinceGetById
DROP PROCEDURE IF EXISTS sp_ariesProvinceGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceGetById`( 
	Province_id INT
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE id_provincia = Province_id;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesProvinceGetByAbbreviation
DROP PROCEDURE IF EXISTS sp_ariesProvinceGetByAbbreviation;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceGetByAbbreviation`( 
	abbreviation INT
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE Sigla = abbreviation;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesProvinceGetByName
DROP PROCEDURE IF EXISTS sp_ariesProvinceGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceGetByName`( 
	name VARCHAR(45)
)
BEGIN
	SELECT id_provincia,
	Nome,
	Sigla, 
	Regione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM province
	WHERE Nome = name;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProvinceInsert
DROP PROCEDURE IF EXISTS sp_ariesProvinceInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceInsert`( 
	name VARCHAR(45),
	region_id INTEGER,
	abbreviation VARCHAR(15),
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Regione 
	WHERE id_regione = region_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM province 
		WHERE Nome = Name; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Province name already exists
		END IF;
	ELSE
		SET Result = -2; # region not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO province 
		SET 
			Nome = name,
			Regione = region_id,
			Sigla = abbreviation, 
			Data_ins = NOW(), 
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProvinceUpdate
DROP PROCEDURE IF EXISTS sp_ariesProvinceUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProvinceUpdate`( 
	enter_id INTEGER,
	name VARCHAR(45),
	abbreviation VARCHAR(15),
	region_id INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM regione 
	WHERE id_regione = region_id; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM province 
		WHERE Nome = Name AND id_provincia != enter_id; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Province name already exists
		END IF;
	ELSE
		SET Result = -2; # region not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM province 
			WHERE id_provincia = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Province ID not found							
			END IF; 
	END IF; 
	
	IF Result >0 THEN
		
		START TRANSACTION;
		
		UPDATE Comune 
		SET Provincia = abbreviation
		WHERE Id_provincia = enter_id; 	
		
		UPDATE province 
		SET 
			Nome = name,
			Regione = region_id, 
			Sigla = abbreviation, 
			Utente_mod = @USER_ID
		Where id_provincia = enter_id;
		
		COMMIT;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesQuoteAddDefaultLot
DROP PROCEDURE IF EXISTS sp_ariesQuoteAddDefaultLot;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteAddDefaultLot`(
	quote_id INT(11), 
	quote_year INT(11), 
	review_id INT(11), 
	default_lot_id INT(11), 
	OUT result BIT(1)
)
BEGIN

	DECLARE lot_Id INT(11); 
	DECLARE vat INT(11);
	DECLARE hourly_price DECIMAL(11,2); 
	DECLARE hourly_cost DECIMAL(11,2);
	DECLARE list_id INT(11); 
	DECLARE discount DECIMAL(11,2); 
	DECLARE quote_type_id INT(11);
	DECLARE subscription_id INT(11);
	   
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	
	-- extract next lot id
	SELECT 
		MAX(posizione)+1 
	INTO 
		lot_id
	FROM preventivo_lotto 
	WHERE id_preventivo = quote_id AND anno = quote_year AND ID_revisione = review_id; 
	
	IF lot_id IS NULL THEN 
		SET lot_id = 1; 
	END IF;
	
	
	-- extract vat and others info from Quote review table
	SELECT 
		Prezzo_ora, 
		Costo_ora, 
		Aliquota, 
	    Listino, 
		Sconto_perc, 
		tariffa
	INTO
		hourly_price, 
		hourly_cost, 
		vat, 
		list_id, 
		discount, 
		subscription_id
	FROM revisione_preventivo 
	WHERE id_preventivo = quote_id AND anno = quote_year AND ID_revisione = review_id;  
	
	
	
	IF vat IS NULL THEN 
		SELECT 
			aliquota
		INTO 
			vat
		FROM Tipo_iva
		WHERE normale = 1; 
	ELSE
		SELECT 
			aliquota
		INTO 
			vat
		FROM Tipo_iva
		WHERE Id_iva = vat; 
	END IF;
	
	
	-- extract quote type id
	SELECT 
		tipo_preventivo
	INTO 
		quote_type_id
	FROM preventivo
	WHERE id_preventivo = quote_id AND anno = quote_year;
	
	-- insert new lot
	INSERT INTO preventivo_lotto 
		(id_preventivo, id_lotto,posizione, anno, id_revisione, scon, ora_p, ora_c, iv_lot, id_Abbo) 
	VALUES
		(quote_id, default_lot_id, lot_id, quote_year, review_id, discount, hourly_price, hourly_cost, vat, subscription_id);
		
	
	-- insert products and notes	
	INSERT INTO articolo_preventivo  
	(
		Id_preventivo, 
		Anno,
		Id_revisione,
		Lotto,
		Id_tab,
		id_articolo, 
		quantità,
		Codice_fornitore, 
		Unità_misura,  
		Foto, 
		Prezzo,
		costo, 
		Tempo_installazione,  
		Prezzo_h,
		Costo_h,
		Desc_brev, 
		Listino, 
		Bloccato, 
		Montato, 
		Tipo, 
		Sconto, 
		iva, 
		scontoriga, 
		scontolav, 
		checked, 
		idnota, 
		`Data_ins`,
		`Utente_ins`
	)	

	SELECT 
		quote_id, 
		quote_year,
		review_id,
		lot_id, 
		Id_tab,
		IF(tipo = 'N', NULL, articolo_lotto.Id_articolo), 
		IF(tipo = 'N', NULL, articolo_lotto.quantità), 
		IF(tipo = 'N', NULL, articolo_lotto.codice_fornitore),
		IF(tipo = 'N', NULL, articolo_lotto.Unità_misura),
		'si', 
		IF(tipo = 'N', NULL, listino_prezzi.Prezzo), -- prezzo
		IF(tipo = 'N', NULL, listino_costi.Prezzo), -- costo
		IF(tipo = 'N', NULL, Tempo_installazione),
		IF(tipo = 'N', NULL, hourly_price), -- prezzo ora
		IF(tipo = 'N', NULL, hourly_cost), -- costo ora
		IF(tipo = 'N', desc_brev, IF(articolo_nota.nota IS NOT NULL, articolo_nota.nota, desc_brev)),
		IF(tipo = 'N', NULL, 1), -- listino
		0, -- bloccato
		IF(tipo = 'N', NULL, Montato),
		Tipo, 
		IF(tipo = 'N', NULL, 0), -- product discount
		IF(tipo = 'N', NULL, Vat), 
		discount, 
		0, -- scontolav
		NULL, -- Checked
		IF(tipo = 'N', idnota, NULL), 
		NOW(),
		@USER_ID
		
	FROM articolo_lotto
		LEFT JOIN articolo_nota 
			ON articolo_nota.id_articolo=articolo_lotto.id_articolo AND descrizione="GENERALE"
		LEFT JOIN articolo_listino AS listino_prezzi 
			ON listino_prezzi.id_Articolo=articolo_lotto.id_articolo AND listino_prezzi.id_listino = 2
		LEFT JOIN articolo_listino AS listino_costi 
			ON listino_costi.id_Articolo = articolo_lotto.id_articolo AND listino_costi.id_listino = 1 
	WHERE id_lotto = default_lot_id;
	
	
	
	
	-- insert quote exclusions 
	INSERT INTO lotto_esclusioni 
		(id_lotto, id_revisione, id_preventivo, anno, id_esclusione)
	SELECT 
		lot_id, 
		review_id, 
		quote_id, 
		quote_year,
		esclusioni.id_esclusione
	FROM esclusioni 
		INNER JOIN preventivo_controllo_esclusioni  
		ON preventivo_controllo_esclusioni.id_esclusione = esclusioni.id_esclusione 
			AND preventivo_controllo_esclusioni.tipo = quote_type_id;
	
	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
				
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesQuoteReviewGetByQuote;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteReviewGetByQuote`(
	quote_id INT(11),
	quote_year INT(11)
)
BEGIN
	SELECT `Id_revisione`,
		`Id_preventivo`,
		`Stampato`,
		`Inviato`,
		`data_creazione`,
		`data`,
		`Anno`,
		`Listino`,
		`Sconto_perc`,
		`Prezzo_ora`,
		`costo_ora`,
		`aliquota`,
		`corpo`,
		`cortese`,
		`oggetto`,
		`nota`,
		`tariffa`,
		`sitoin`,
		`Id_riferimento`,
		`id_cliente`,
		`destinazione`,
		`ric_tip`,
		`ric_perc`,
		`corpo_rtf`
	FROM revisione_preventivo
	WHERE id_preventivo = quote_id AND anno = quote_year;
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesQuoteConvertTempProducts
DROP PROCEDURE IF EXISTS sp_ariesQuoteConvertTempProducts;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteConvertTempProducts`(
	enter_id INT(11),
	enter_year INT(11)
)
BEGIN
	
	UPDATE articolo 
		INNER JOIN articolo_preventivo ON articolo.codice_articolo = articolo_preventivo.Id_articolo
	SET articolo.Stato_articolo = 1
	WHERE articolo.Stato_articolo = 10;
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesQuoteLotBodyByLot
DROP PROCEDURE IF EXISTS sp_ariesQuoteLotBodyByLot;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotBodyByLot`(
quote_id INT(11), 
quote_year INT(11), 
review_id INT(11), 
lot_id INT(11)
)
BEGIN

	SELECT 
		Id_preventivo, 
		Anno,
		Id_revisione,
		Lotto,
		Id_tab,
		IFNULL(id_articolo, '') AS 'Id_articolo', 
		IFNULL(quantità, 0) AS 'Quantità', 
		IFNULL(Codice_fornitore, '') AS 'Codice_fornitore', 
		IFNULL(Unità_misura, '') AS 'Unità_misura', 
		Foto, 
		IFNULL(Prezzo, 0) AS 'Prezzo',
		IFNULL(costo, 0) AS 'Costo', 
		IFNULL(Tempo_installazione, 0) AS 'Tempo_installazione',  
		IFNULL(Prezzo_h, 0) AS 'Prezzo_h',
		IFNULL(costo_h, 0) AS 'Costo_h',
		IFNULL(Desc_brev, '') AS 'Desc_brev', 
		IFNULL(Listino, 0) AS 'Listino', 
		IFNULL(Bloccato, false) AS 'Bloccato', 
		IFNULL(Montato, false) AS 'Montato', 
		Tipo, 
		IFNULL(Sconto, 0) AS 'Sconto', 
		IFNULL(iva, 0) AS 'Iva', 
		scontoriga, 
		scontolav, 
		IFNULL(checked, false) AS 'Checked', 
		IFNULL(idnota, 0 ) AS 'IdNota', 
		`Data_ins`,
		`Utente_ins`
	FROM articolo_preventivo
	WHERE Id_preventivo = quote_id 
		and anno = quote_year
		and id_revisione = review_id
		and lotto = lot_id
	ORDER BY Id_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesQuoteLotBodyDeleteByLot
DROP PROCEDURE IF EXISTS sp_ariesQuoteLotBodyDeleteByLot;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotBodyDeleteByLot`(
quote_id INT(11), 
quote_year INT(11), 
review_id INT(11), 
lot_id INT(11)
)
BEGIN

	DELETE FROM articolo_preventivo
	WHERE Id_preventivo = quote_id 
		and anno = quote_year
		and id_revisione = review_id
		and lotto = lot_id; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesQuoteLotBodyGetByLot
DROP PROCEDURE IF EXISTS sp_ariesQuoteLotBodyGetByLot;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotBodyGetByLot`(
quote_id INT(11), 
quote_year INT(11), 
review_id INT(11), 
lot_id INT(11)
)
BEGIN

	SELECT 
		Id_preventivo, 
		Anno,
		Id_revisione,
		Lotto,
		Id_tab,
		IFNULL(id_articolo, '') AS 'Id_articolo', 
		IFNULL(quantità, 0) AS 'Quantità', 
		IFNULL(Codice_fornitore, '') AS 'Codice_fornitore', 
		IFNULL(Unità_misura, '') AS 'Unità_misura', 
		Foto, 
		IFNULL(Prezzo, 0) AS 'Prezzo',
		IFNULL(costo, 0) AS 'Costo', 
		IFNULL(Tempo_installazione, 0) AS 'Tempo_installazione',  
		IFNULL(Prezzo_h, 0) AS 'Prezzo_h',
		IFNULL(costo_h, 0) AS 'Costo_h',
		IFNULL(Desc_brev, '') AS 'Desc_brev', 
		IFNULL(Listino, 0) AS 'Listino', 
		Bloccato, 
		Montato, 
		Tipo, 
		IFNULL(Sconto, 0) AS 'Sconto', 
		IFNULL(iva, 0) AS 'Iva', 
		scontoriga, 
		scontolav, 
		checked, 
		IFNULL(idnota, 0 ) AS 'IdNota', 
		`Data_ins`,
		`Utente_ins`
	FROM articolo_preventivo
	WHERE Id_preventivo = quote_id 
		and anno = quote_year
		and id_revisione = review_id
		and lotto = lot_id
	ORDER BY Id_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesQuoteNewReview
DROP PROCEDURE IF EXISTS sp_ariesQuoteNewReview;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteNewReview`(
	quote_id INT(11), 
	quote_year INT(11), 
	OUT result INT(11)
)
BEGIN

  	DECLARE last_review_id INT(11);
  	DECLARE new_review_id INT(11);
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

	START TRANSACTION;

	SELECT IFNULL(MAX(id_revisione), 0), IFNULL(MAX(id_revisione)+1, 0)
		INTO last_review_id, new_review_id 
	FROM revisione_preventivo 
	WHERE id_preventivo = quote_id AND anno = quote_year;
	
	if last_review_id = new_review_id THEN
		SET Result = -2; 
	ELSE
	
	
		INSERT INTO revisione_preventivo 
			(id_cliente,destinazione, id_revisione, id_preventivo, anno, data_creazione, data,corpo,cortese,oggetto, nota,tariffa,costo_ora, prezzo_ora, listino, CORPO_rtf) 
		SELECT 
			id_cliente,
			destinazione,
			new_review_id, 
			id_preventivo, 
			anno, 
			NOW(), 
			data,
			corpo,
			cortese,
			oggetto,
			nota,
			tariffa, 
			costo_ora, 
			prezzo_ora, 
			listino, 
			corpo_rtf 
		FROM revisione_preventivo 
		WHERE id_revisione = last_review_id AND id_preventivo = quote_id AND anno = quote_year;
	
	  	UPDATE preventivo 
		SET revisione = new_review_id
	   WHERE id_preventivo = quote_id AND anno = quote_year;
	
	  	INSERT INTO preventivo_lotto
			(id_lotto, anno, id_revisione, id_preventivo,posizione, nota, id_impianto, id_abbo,scon,ora_p,ora_c,optional,iv_lot) 
	  	SELECT 
		  id_lotto, 
		  anno,
		  new_review_id,
	     id_preventivo,
		  posizione, 
		  nota, 
		  id_impianto, 
		  id_abbo,
		  scon,
		  ora_p,
		  ora_c,
		  optional,
		  iv_lot  
		FROM preventivo_lotto 
		WHERE id_revisione = last_review_id AND id_preventivo = quote_id AND anno = quote_year;
	
		INSERT INTO lotto_esclusioni
			(id_lotto, id_revisione, id_preventivo, anno, id_esclusione) 
		SELECT 
			id_lotto,
			new_review_id,
			id_preventivo, 
			anno, 
			id_esclusione 
		FROM lotto_esclusioni 
		WHERE id_revisione = last_review_id AND id_preventivo = quote_id AND anno = quote_year;
	
		INSERT INTO articolo_preventivo 
			(id_preventivo, id_revisione, anno,lotto, id_tab, prezzo, costo,sconto, quantità,
			 costo_h, prezzo_h,desc_brev, codice_fornitore, id_articolo, tempo_installazione, listino,
			 montato,bloccato, tipo,unità_misura,scontoriga,scontolav,idnota,iva, Utente_ins) 
		SELECT id_preventivo,
	    	new_review_id, 
			anno,
			lotto,
			id_tab, 
			prezzo, 
			costo,
			sconto,
			quantità,
			costo_h, 
			prezzo_h, 
			desc_brev,
			codice_fornitore,
			articolo_preventivo.id_articolo, 
			tempo_installazione, 
			listino,
			montato,
			bloccato, 
			tipo,
			unità_misura,
			scontoriga,
			scontolav,
			idnota,
			iva, 
			@USER_ID 
		FROM articolo_preventivo 
	    WHERE id_revisione = last_review_id  AND id_preventivo = quote_id AND anno = quote_year;
	
		INSERT INTO preventivo_impianto
			(id_preventivo, anno, revisione, impianto)
		SELECT 
			id_preventivo, 
			anno,
			new_review_id,
			impianto 
		FROM  preventivo_impianto 
		WHERE revisione = last_review_id AND id_preventivo = quote_id  AND anno = quote_year; 

		

		INSERT INTO preventivo_lotto_pdf (
			Id_preventivo, id_revisione, anno, posizione_lotto, posizione, filepath, filename, utente_mod
		)
		SELECT
			Id_preventivo, new_review_id, anno, posizione_lotto, posizione, filepath, filename, @USER_ID
		FROM preventivo_lotto_pdf 
		WHERE Id_preventivo = quote_id 
			AND Anno = quote_year
			AND id_revisione = last_review_id;
		
		UPDATE Preventivo 
		SET stato = 5 
		WHERE id_preventivo = quote_id AND anno = quote_year;
	
		SET Result = new_review_id;
		
	END IF; 
	
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = -1; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionDelete
DROP PROCEDURE IF EXISTS sp_ariesRegionDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM Regione 
	WHERE id_Regione = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionGet
DROP PROCEDURE IF EXISTS sp_ariesRegionGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionGet`( 
)
BEGIN
	SELECT Id_Regione,
	Nome,
	Nazione, 
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Regione
	ORDER BY Id_Regione;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionGetById
DROP PROCEDURE IF EXISTS sp_ariesRegionGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionGetById`( 
	Region_id INT
)
BEGIN
	SELECT Id_Regione,
	Nome,
	Nazione,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Regione
	WHERE Id_Regione = Region_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionGetByName
DROP PROCEDURE IF EXISTS sp_ariesRegionGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionGetByName`( 
	name VARCHAR(30)
)
BEGIN
	SELECT Id_Regione,
	Nome,
	Nazione,
	Data_ins, 
	Data_mod,
	Utente_ins, 
	Utente_mod	
	FROM Regione
	WHERE Nome = name;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionInsert
DROP PROCEDURE IF EXISTS sp_ariesRegionInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionInsert`( 
	name VARCHAR(30),
	country INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Nazione 
	WHERE id_nazione = country; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Regione 
		WHERE Nome = Name; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Region name already exists
		END IF;
	ELSE
		SET Result = -2; # country not found
	END IF;
	
	IF Result = 0 THEN
		INSERT INTO Regione 
		SET 
			Nome = name,
			Nazione = country, 
			Data_ins = NOW(), 
			Data_mod = NOW(),
			Utente_ins = @USER_ID, 
			Utente_mod = @USER_ID;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesRegionUpdate
DROP PROCEDURE IF EXISTS sp_ariesRegionUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesRegionUpdate`( 
	enter_id INTEGER,
	name VARCHAR(30),
	country INTEGER,
	OUT Result INT
)
BEGIN
	
	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Nazione 
	WHERE id_nazione = country; 
	
	IF Result>0 THEN
	
		SELECT Count(Nome) INTO Result
		FROM Regione 
		WHERE Nome = Name AND Id_regione != enter_id; 
		
		IF Result > 0 THEN
			 SET Result = -1; # Region name already exists
		END IF;
	ELSE
		SET Result = -2; # country not found
	END IF;
	
	IF Result = 0 THEN 
			SELECT Count(*) INTO Result
			FROM Regione 
			WHERE id_Regione = enter_id;
			
			IF Result = 0 THEN
				SET Result = -3; # Region ID not found							
			END IF; 
	END IF; 
	
	IF Result > 0 THEN
		UPDATE Regione 
		SET 
			Nome = name,
			Nazione = country, 
			Utente_mod = @USER_ID
		Where id_Regione = enter_id;
			
		SET Result = 1; 
	END IF; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportChangeScanStatusByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesReportChangeScanStatusByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportChangeScanStatusByIdAndYear`(
	report_id INT(11),
	report_year INT(11), 
	scan_status BIT(1), 
	OUT result  TINYINT
)
BEGIN
	SET result = 1; 

	UPDATE rapporto 
	SET	
		scan = scan_status
	WHERE id_rapporto = report_id AND anno = report_year;

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportSetInvoiceData
DROP PROCEDURE IF EXISTS sp_ariesReportSetInvoiceData;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportSetInvoiceData`(
	IN report_id INT(11),
	IN report_year INT(11), 
	IN invoice_id INT(11),
	IN invoice_year INT(11), 
	OUT result  TINYINT
)
BEGIN
	SET result = 1; 

	UPDATE rapporto 
	SET	
		Fattura = invoice_id,
		Anno_fattura = invoice_year
	WHERE id_rapporto = report_id AND anno = report_year;

				
END//
DELIMITER ;

-- Dump della struttura di procedura sp_ariesInvoiceDelete
DROP PROCEDURE IF EXISTS sp_ariesInvoiceDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceDelete`(
	IN enter_id INT(11),
	IN enter_year INT(11),
	OUT result  TINYINT
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;	
		
	START TRANSACTION;

  UPDATE rapporto
	SET stato=1,
		Fattura = NULL,
		Anno_fattura = NULL
	WHERE anno_fattura = enter_year AND Fattura = enter_id;



-- Dump della struttura di procedura emmebi.sp_ariesReportChangeYear
DROP PROCEDURE IF EXISTS sp_ariesReportChangeYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportChangeYear`(
	old_report_id INT(11),
	old_report_year INT(11), 
	new_report_year INT(11), 
	OUT result  INT(11)
)
BEGIN
		
	DECLARE id_rapp INT;
	DECLARE id_rapp_mobile INT;
	
	DECLARE new_report_id INT;
	
	DECLARE job_id INT;
	DECLARE job_year INT; 
	DECLARE job_lot_id INT;

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

	START TRANSACTION; 
	SET result = 1; 

	-- check next report id
	SELECT IFNULL(MAX(a.id_rapporto)+1, 1) INTO id_rapp 
	from rapporto as a 
	where anno=new_report_year;
	
	SELECT IFNULL(max(a.id_rapporto)+1, 1) INTO id_rapp_mobile 
	from rapporto_mobile as a 
	where anno=new_report_year;
	
	if id_rapp>id_rapp_mobile then
	 set new_report_id=id_rapp;
	else
	 set new_report_id=id_rapp_mobile;
	end if;
	
	SET result = new_report_id;
	
	SELECT
		Id_commessa, anno_commessa, id_lotto 
		INTO
		job_id, job_year, job_lot_id
	FROM commessa_rapporto 
	WHERE id_rapporto = old_report_id AND anno_rapporto = old_report_year;

	IF job_id IS NOT NULL THEN
		DELETE FROM commessa_rapporto 
		WHERE id_rapporto = old_report_id AND anno_rapporto = old_report_year;
	END IF; 

	UPDATE rapporto 
	SET id_rapporto = new_report_id, 
		anno = new_report_year, 
		numero =  REPLACE(numero, CONCAT(old_report_id, ''), CONCAT(new_report_id, ''))
	WHERE id_rapporto = old_report_id AND anno = old_report_year;

	IF job_id IS NOT NULL THEN
		INSERT INTO commessa_rapporto (Id_commessa, anno_commessa, id_lotto, id_rapporto, anno_rapporto)
		VALUES (job_id, job_year, job_lot_id, new_report_id, new_report_year);
	END IF; 
	
	
	UPDATE rapporto_tecnico 
	SET id_rapporto = new_report_id, 
		anno = new_report_year
	WHERE id_rapporto = old_report_id AND anno = old_report_year;

	UPDATE rapporto_tecnico_lavoro 
	SET id_rapporto = new_report_id, 
		anno = new_report_year
	WHERE id_rapporto = old_report_id AND anno = old_report_year;

	UPDATE rapporto_materiale 
	SET id_rapporto = new_report_id, 
		anno = new_report_year
	WHERE id_rapporto = old_report_id AND anno = old_report_year;

	UPDATE impianto_reperibilita 
	SET id_rapporto = new_report_id, 
		anno = new_report_year
	WHERE id_rapporto = old_report_id AND anno = old_report_year;
	

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivityGet
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivityGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivityGet`(
)
BEGIN

	SELECT `id`,
		`Id_rapporto_giornaliero`,
		`tipo_lavoro`,
		`descrizione_lavoro`,
		`ora_inizio`,
		`ora_fine`,
		`note`,
		`data_ins`,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		`utente_ins`,
		`utente_mod`	
	FROM rapporto_giornaliero_attivita;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivityGetByEmployeeAndDate
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivityGetByEmployeeAndDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivityGetByEmployeeAndDate`(
	employee_id INT(11), 
	exec_date DATETIME
)
BEGIN

	SELECT rapporto_giornaliero_attivita.`id`,
		`Id_rapporto_giornaliero`,
		`tipo_lavoro`,
		`descrizione_lavoro`,
		`ora_inizio`,
		`ora_fine`,
		rapporto_giornaliero_attivita.`note`,
		rapporto_giornaliero_attivita.`data_ins`,
		 IFNULL(rapporto_giornaliero_attivita.Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		rapporto_giornaliero_attivita.`utente_ins`,
		rapporto_giornaliero_attivita.`utente_mod`	
	FROM rapporto_giornaliero_attivita
		INNER JOIN rapporto_giornaliero 
			ON rapporto_giornaliero_attivita.Id_rapporto_giornaliero = rapporto_giornaliero.Id 
			AND id_operaio = employee_id AND data_rapporto = exec_date
	ORDER BY ora_inizio DESC; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivityGetById
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivityGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivityGetById`(
 enter_id INT(11)
)
BEGIN

	SELECT `id`,
		`Id_rapporto_giornaliero`,
		`tipo_lavoro`,
		`descrizione_lavoro`,
		`ora_inizio`,
		`ora_fine`,
		`note`,
		`data_ins`,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		`utente_ins`,
		`utente_mod`	
	FROM rapporto_giornaliero_attivita
	WHERE id = enter_id;
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivityGetByReport
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivityGetByReport;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivityGetByReport`(
	report_daily_id INT(11)
)
BEGIN

	SELECT `id`,
		`Id_rapporto_giornaliero`,
		`tipo_lavoro`,
		`descrizione_lavoro`,
		`ora_inizio`,
		`ora_fine`,
		`note`,
		`data_ins`,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		`utente_ins`,
		`utente_mod`	
	FROM rapporto_giornaliero_attivita
	WHERE Id_rapporto_giornaliero = report_daily_id
	ORDER BY ora_inizio DESC; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivitySetNote
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivitySetNote;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivitySetNote`(
	enter_id INT(11),
	note TEXT
)
BEGIN

	UPDATE rapporto_giornaliero_attivita
	SET note = note
	WHERE id = enter_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyActivityTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesReportDailyActivityTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyActivityTypeGetById`(
	activity_type_id INT(11)
)
BEGIN

	SELECT `id`,
		`Nome`	
	FROM rapporto_giornaliero_tipo_attivita
	WHERE id = activity_type_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyCountNotSeen
DROP PROCEDURE IF EXISTS sp_ariesReportDailyCountNotSeen;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyCountNotSeen`(
)
BEGIN

	SELECT COUNT(visionato) 
	FROM rapporto_giornaliero
	WHERE visionato = false; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyDeleteById
DROP PROCEDURE IF EXISTS sp_ariesReportDailyDeleteById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyDeleteById`(
	enter_id INT(11)
)
BEGIN

	DELETE FROM rapporto_giornaliero_attivita
	WHERE Id_rapporto_giornaliero  = enter_id; 

	DELETE FROM rapporto_giornaliero
	WHERE id = enter_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyGet
DROP PROCEDURE IF EXISTS sp_ariesReportDailyGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyGet`(
)
BEGIN

	SELECT `id`,
		`id_operaio`,
		`data_rapporto`,
		`stampato`,
		`visionato`,
		`note`,
		`data_ins`,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		`utente_ins`,
		`utente_mod`	
	FROM rapporto_giornaliero
	ORDER BY visionato ASC, data_rapporto desc; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailyGetWithFilter
DROP PROCEDURE IF EXISTS sp_ariesReportDailyGetWithFilter;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailyGetWithFilter`(
	start_date DATE, 
	end_date DATE,
	employee_id INT(11)
)
BEGIN

		-- extract reports by filter
	DROP TABLE IF EXISTS tmp_report_daily_get_by_filter;
	CREATE TEMPORARY TABLE tmp_report_daily_get_by_filter
	SELECT `id`,
		`id_operaio`,
		`data_rapporto`,
		`stampato`,
		`visionato`,
		`note`,
		`data_ins`,
		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_mod,
		`utente_ins`,
		`utente_mod`	
	FROM rapporto_giornaliero
	WHERE (data_rapporto BETWEEN start_date AND end_date)
	ORDER BY visionato ASC, data_rapporto desc; 

	
	IF employee_id IS NOT NULL AND employee_id != 0 THEN
		DELETE FROM tmp_report_daily_get_by_filter 
		WHERE id_operaio != employee_id; 
	END IF; 

	SELECT * 
	FROM tmp_report_daily_get_by_filter;
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailySetNote
DROP PROCEDURE IF EXISTS sp_ariesReportDailySetNote;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailySetNote`(
	enter_id INT(11),
	note TEXT
)
BEGIN

	UPDATE rapporto_giornaliero
	SET note = note
	WHERE id = enter_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailySetPrintStatus
DROP PROCEDURE IF EXISTS sp_ariesReportDailySetPrintStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailySetPrintStatus`(
	enter_id INT(11),
	status BIT
)
BEGIN

	UPDATE rapporto_giornaliero
	SET stampato = status
	WHERE id = enter_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDailySetSeenStatus
DROP PROCEDURE IF EXISTS sp_ariesReportDailySetSeenStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDailySetSeenStatus`(
	enter_id INT(11),
	status BIT
)
BEGIN

	UPDATE rapporto_giornaliero
	SET visionato = status
	WHERE id = enter_id; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportDeleteByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesReportDeleteByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportDeleteByIdAndYear`(
	report_id INT(11),
	report_year INT(11), 
	OUT result  TINYINT
)
BEGIN

 
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION; 
	
	SET result = 1; 
	
	DELETE FROM rapporto_tecnico 
	WHERE id_rapporto = report_id AND anno = report_year;

	DELETE FROM rapporto_tecnico_lavoro 
	WHERE id_rapporto = report_id AND anno = report_year;

	DELETE FROM commessa_rapporto
	WHERE id_rapporto = report_id AND anno_rapporto = report_year;

	DELETE FROM rapporto_materiale 
	WHERE id_rapporto = report_id AND anno = report_year;

	DELETE FROM impianto_reperibilita 
	WHERE id_rapporto = report_id AND anno = report_year;
	
	DELETE FROM rapporto 
	WHERE id_rapporto = report_id AND anno = report_year;

	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGet
DROP PROCEDURE IF EXISTS sp_ariesReportGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGet`(
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc
	LIMIT 1000;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesReportGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByCustomerId`(
	customer_id INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE Id_cliente = customer_id
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByCustomerIdAndDate
DROP PROCEDURE IF EXISTS sp_ariesReportGetByCustomerIdAndDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByCustomerIdAndDate`(
	customer_id INT(11), 
	exec_date DATE
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE Id_cliente = customer_id AND data_esecuzione = exec_date
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesReportGetByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByIdAndYear`(
	report_id INT(11),
	report_year INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE Id_rapporto = report_id AND anno = report_year;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByInterventionType
DROP PROCEDURE IF EXISTS sp_ariesReportGetByInterventionType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByInterventionType`( 
	type INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE tipo_intervento = type
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByReportNumber
DROP PROCEDURE IF EXISTS sp_ariesReportGetByReportNumber;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByReportNumber`(
	report_number VARCHAR(45)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente,
		Id_tipo_rapporto, 
		filename_firma_cliente,
		filename_firma_tecnico,
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE numero = report_number
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByStatus
DROP PROCEDURE IF EXISTS sp_ariesReportGetByStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByStatus`( 
	status INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico,
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE stato = status
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetBySystemId
DROP PROCEDURE IF EXISTS sp_ariesReportGetBySystemId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetBySystemId`(
	system_id INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		filename_firma_cliente,
		filename_firma_tecnico,
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati,
		Id_tipo_rapporto
	FROM rapporto
	WHERE Id_impianto = system_id
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetByYear
DROP PROCEDURE IF EXISTS sp_ariesReportGetByYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByYear`(
	report_year INT(11)
)
BEGIN

	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico,
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE anno = report_year
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGroupDeleteByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesReportGroupDeleteByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGroupDeleteByIdAndYear`(
	enter_id INT(11),
	enter_year INT(11), 
	OUT result  TINYINT
)
BEGIN

	SET result = 0; 
	
	DELETE FROM resoconto 
	WHERE id_resoconto = enter_id AND anno = enter_year;

	SET result = 1; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGroupGetForProductsPrint
DROP PROCEDURE IF EXISTS sp_ariesReportGroupGetForProductsPrint;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGroupGetForProductsPrint`(
	reportGroupId INTEGER, 
	reportGroupYear INTEGER, 
	orderClauses TINYINT
)
BEGIN


  	IF(orderClauses = 0) THEN -- NONE
  		SELECT vw_reportgroupproducts.id_resoconto, 
		  			vw_reportgroupproducts.anno_reso, 
					vw_reportgroupproducts.Id_rapporto,
					vw_reportgroupproducts.anno, 
					vw_reportgroupproducts.Id_materiale,
					articolo.Codice_fornitore,
					marca.Nome as Marca,
					vw_reportgroupproducts.descrizione descrizione_articolo, 
					vw_reportgroupproducts.`quantità`,
					vw_reportgroupproducts.Prezzo,
					vw_reportgroupproducts.Costo, 
					vw_reportgroupproducts.Sconto,
					(vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) Prezzo_scontato, 
					CAST((vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) * vw_reportgroupproducts.`quantità` AS DECIMAL(11,2)) Prezzo_tot_scontato,
					vw_reportgroupproducts.id_magazzino, 
					vw_reportgroupproducts.id_tab, 
					vw_reportgroupproducts.tipo, 
					vw_reportgroupproducts.qeconomia,
					impianto.id_impianto, 
					impianto.Descrizione Descrizione_impianto,
					vw_reportgroupproducts.unita_misura
  		FROm vw_reportgroupproducts
  			LEFT JOIN articolo 
			  ON vw_reportgroupproducts.id_materiale = articolo.Codice_articolo
			LEFT JOIN marca 
				ON articolo.Marca = marca.Id_marca
			INNER JOIN rapporto 
				ON rapporto.Id_rapporto = vw_reportgroupproducts.Id_rapporto
				AND rapporto.anno = vw_reportgroupproducts.anno
			LEFT JOIN Impianto 
				ON rapporto.Id_Impianto = Impianto.Id_Impianto
		WHERE vw_reportgroupproducts.id_resoconto = reportGroupId 
			AND vw_reportgroupproducts.anno_reso = reportGroupYear;
				
	ELSEIF (orderClauses = 1) THEN -- Product Code
	
  		SELECT vw_reportgroupproducts.id_resoconto, 
		  			vw_reportgroupproducts.anno_reso, 
					vw_reportgroupproducts.Id_rapporto,
					vw_reportgroupproducts.anno, 
					vw_reportgroupproducts.Id_materiale,
					articolo.Codice_fornitore,
					marca.Nome as Marca,
					vw_reportgroupproducts.descrizione descrizione_articolo, 
					vw_reportgroupproducts.`quantità`,
					vw_reportgroupproducts.Prezzo,
					vw_reportgroupproducts.Costo, 
					vw_reportgroupproducts.Sconto,
					(vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) Prezzo_scontato, 
					CAST((vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) * vw_reportgroupproducts.`quantità` AS DECIMAL(11,2)) Prezzo_tot_scontato,
					vw_reportgroupproducts.id_magazzino, 
					vw_reportgroupproducts.id_tab, 
					vw_reportgroupproducts.tipo, 
					vw_reportgroupproducts.qeconomia,
					impianto.id_impianto, 
					impianto.Descrizione Descrizione_impianto,
					vw_reportgroupproducts.unita_misura
					
  		FROm vw_reportgroupproducts
  			LEFT JOIN articolo 
			  ON vw_reportgroupproducts.id_materiale = articolo.Codice_articolo
			LEFT JOIN marca 
				ON articolo.Marca = marca.Id_marca
			INNER JOIN rapporto 
				ON rapporto.Id_rapporto = vw_reportgroupproducts.Id_rapporto
				AND rapporto.anno = vw_reportgroupproducts.anno
			LEFT JOIN Impianto 
				ON rapporto.Id_Impianto = Impianto.Id_Impianto
		WHERE vw_reportgroupproducts.id_resoconto = reportGroupId 
			AND vw_reportgroupproducts.anno_reso = reportGroupYear
		ORDER BY vw_reportgroupproducts.Id_materiale;
		
	ELSEIF (orderClauses = 2) THEN -- Supplier Code
	 
  		SELECT vw_reportgroupproducts.id_resoconto, 
		  			vw_reportgroupproducts.anno_reso, 
					vw_reportgroupproducts.Id_rapporto,
					vw_reportgroupproducts.anno, 
					vw_reportgroupproducts.Id_materiale,
					articolo.Codice_fornitore,
					marca.Nome as Marca,
					vw_reportgroupproducts.descrizione descrizione_articolo, 
					vw_reportgroupproducts.`quantità`,
					vw_reportgroupproducts.Prezzo,
					vw_reportgroupproducts.Costo, 
					vw_reportgroupproducts.Sconto,
					(vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) Prezzo_scontato, 
					CAST((vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) * vw_reportgroupproducts.`quantità` AS DECIMAL(11,2)) Prezzo_tot_scontato,
					vw_reportgroupproducts.id_magazzino, 
					vw_reportgroupproducts.id_tab, 
					vw_reportgroupproducts.tipo, 
					vw_reportgroupproducts.qeconomia,
					impianto.id_impianto, 
					impianto.Descrizione Descrizione_impianto,
					vw_reportgroupproducts.unita_misura
					
  		FROm vw_reportgroupproducts
  			LEFT JOIN articolo 
			  ON vw_reportgroupproducts.id_materiale = articolo.Codice_articolo
			LEFT JOIN marca 
				ON articolo.Marca = marca.Id_marca
			INNER JOIN rapporto 
				ON rapporto.Id_rapporto = vw_reportgroupproducts.Id_rapporto
				AND rapporto.anno = vw_reportgroupproducts.anno
			LEFT JOIN Impianto 
				ON rapporto.Id_Impianto = Impianto.Id_Impianto
		WHERE vw_reportgroupproducts.id_resoconto = reportGroupId 
			AND vw_reportgroupproducts.anno_reso = reportGroupYear
		ORDER BY articolo.Codice_fornitore;
		
	ELSEIF (orderClauses = 3) THEN -- BRAND

  		SELECT vw_reportgroupproducts.id_resoconto, 
		  			vw_reportgroupproducts.anno_reso, 
					vw_reportgroupproducts.Id_rapporto,
					vw_reportgroupproducts.anno, 
					vw_reportgroupproducts.Id_materiale,
					articolo.Codice_fornitore,
					marca.Nome as Marca,
					vw_reportgroupproducts.descrizione descrizione_articolo, 
					vw_reportgroupproducts.`quantità`,
					vw_reportgroupproducts.Prezzo,
					vw_reportgroupproducts.Costo, 
					vw_reportgroupproducts.Sconto,
					(vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) Prezzo_scontato, 
					CAST((vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) * vw_reportgroupproducts.`quantità` AS DECIMAL(11,2)) Prezzo_tot_scontato,
					vw_reportgroupproducts.id_magazzino, 
					vw_reportgroupproducts.id_tab, 
					vw_reportgroupproducts.tipo, 
					vw_reportgroupproducts.qeconomia,
					impianto.id_impianto, 
					impianto.Descrizione Descrizione_impianto,
					vw_reportgroupproducts.unita_misura
					
  		FROm vw_reportgroupproducts
  			LEFT JOIN articolo 
			  ON vw_reportgroupproducts.id_materiale = articolo.Codice_articolo
			LEFT JOIN marca 
				ON articolo.Marca = marca.Id_marca
			INNER JOIN rapporto 
				ON rapporto.Id_rapporto = vw_reportgroupproducts.Id_rapporto
				AND rapporto.anno = vw_reportgroupproducts.anno
			LEFT JOIN Impianto 
				ON rapporto.Id_Impianto = Impianto.Id_Impianto
		WHERE vw_reportgroupproducts.id_resoconto = reportGroupId 
			AND vw_reportgroupproducts.anno_reso = reportGroupYear
		ORDER BY marca.Nome, vw_reportgroupproducts.Id_materiale;

	ELSE -- Description
	
	  		SELECT vw_reportgroupproducts.id_resoconto, 
		  			vw_reportgroupproducts.anno_reso, 
					vw_reportgroupproducts.Id_rapporto,
					vw_reportgroupproducts.anno, 
					vw_reportgroupproducts.Id_materiale,
					articolo.Codice_fornitore,
					marca.Nome as Marca,
					vw_reportgroupproducts.descrizione descrizione_articolo, 
					vw_reportgroupproducts.`quantità`,
					vw_reportgroupproducts.Prezzo,
					vw_reportgroupproducts.Costo, 
					vw_reportgroupproducts.Sconto,
					(vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) Prezzo_scontato, 
					CAST((vw_reportgroupproducts.Prezzo + CAST(vw_reportgroupproducts.Prezzo/100*vw_reportgroupproducts.Sconto AS DECIMAL(11,2))) * vw_reportgroupproducts.`quantità` AS DECIMAL(11,2)) Prezzo_tot_scontato,
					vw_reportgroupproducts.id_magazzino, 
					vw_reportgroupproducts.id_tab, 
					vw_reportgroupproducts.tipo, 
					vw_reportgroupproducts.qeconomia,
					impianto.id_impianto, 
					impianto.Descrizione Descrizione_impianto,
					vw_reportgroupproducts.unita_misura
					
  		FROm vw_reportgroupproducts
  			LEFT JOIN articolo 
			  ON vw_reportgroupproducts.id_materiale = articolo.Codice_articolo
			LEFT JOIN marca 
				ON articolo.Marca = marca.Id_marca
			INNER JOIN rapporto 
				ON rapporto.Id_rapporto = vw_reportgroupproducts.Id_rapporto
				AND rapporto.anno = vw_reportgroupproducts.anno
			LEFT JOIN Impianto 
				ON rapporto.Id_Impianto = Impianto.Id_Impianto
		WHERE vw_reportgroupproducts.id_resoconto = reportGroupId 
			AND vw_reportgroupproducts.anno_reso = reportGroupYear
		ORDER BY vw_reportgroupproducts.descrizione, vw_reportgroupproducts.Id_materiale;
	
  	END IF;

END//
DELIMITER ;


-- Dump della struttura dti procedura emmebi.sp_ariesReportMabileInterventionById
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionById`( 
	report_id INT,
	report_year INT
)
BEGIN
	 SELECT       
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,       
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati           
    FROM rapporto_mobile       
    WHERE id_rapporto = report_id AND anno = report_year;       

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMabileInterventionDeleteById
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionDeleteById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionDeleteById`( 
	report_id INT,
	report_year INT,
	OUT Result INT
)
BEGIN

	SET Result = 1; 
	
	SELECT COUNT(*) INTO Result
	FROM Rapporto_mobile 
	WHERE Id_rapporto = report_id AND anno = report_year;  
	
	IF Result = 0 THEN
		SET Result = -2;  
	END IF; 

	IF Result > 0 THEN
		UPDATE rapporto_mobile    
		SET Visionato = 1  
		WHERE Id_rapporto = report_id AND anno = report_year; 
		
		
		SET Result = 1; 
	END IF;     

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMabileInterventionProductByReportId
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionProductByReportId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionProductByReportId`( 
	report_id INT,
	report_year INT
)
BEGIN
	SELECT Id,       
	      codice_articolo,       
	      descrizione,        
	      quantita,       
	      posizione,      
	      id_rapporto,       
	      anno_rapporto       
	
	FROM rapporto_mobile_materiale       
	WHERE Id_rapporto = report_id AND anno_rapporto = report_year;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMabileInterventionTechnicianByReportId
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionTechnicianByReportId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionTechnicianByReportId`( 
	report_id INT,
	report_year INT
)
BEGIN
  SELECT Id,       
      id_tecnico,       
      tempo_lavorato,        
      km,       
      tempo_viaggio,      
      id_rapporto,       
      anno_rapporto       
  FROM rapporto_mobile_tecnico       
  WHERE Id_rapporto = report_id AND anno_rapporto = report_year; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMabileInterventionTicketByReportId
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionTicketByReportId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionTicketByReportId`( 
	report_id INT,
	report_year INT
)
BEGIN
  SELECT Id,       
      id_rapporto,       
      anno_rapporto,        
      id_ticket,       
      anno_ticket       
  FROM rapporto_mobile_ticket       
  WHERE Id_rapporto = report_id AND anno_rapporto = report_year;      

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMabileInterventionWorkByReportId
DROP PROCEDURE IF EXISTS sp_ariesReportMabileInterventionWorkByReportId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMabileInterventionWorkByReportId`( 
	report_id INT,
	report_year INT
)
BEGIN
	SELECT id,       
        id_rapporto,       
        anno_rapporto,       
        controllo_periodico,       
        materiale_uso,       
        diritto_chiamata,       
        viaggio_consuntivo,       
        spese,       
        tecnici,       
        totale_ore,       
        extra_consuntivo,       
        extra_testo,       
        extra       
	FROM rapporto_mobile_lavoro       
	WHERE Id_rapporto = report_id AND anno_rapporto = report_year;     

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGet
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGet`( 

)
BEGIN
	 SELECT      
		  Id, 
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,   
					inviato,
					visionato,    
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt,
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati        
    FROM rapporto_mobile
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetByCustomerId`( 
	customer_id INT(11)
)
BEGIN
	 SELECT      
		  Id, 
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,    
					inviato,
					visionato,       
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
			numero_allegati              
    FROM rapporto_mobile
	WHERE Id_cliente = customer_id AND visionato = false
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetById
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetById`( 
	report_id INT,
	report_year INT
)
BEGIN
	 SELECT    
		  Id,
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,     
					inviato,
					visionato,      
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati             
    FROM rapporto_mobile       
    WHERE id_rapporto = report_id AND anno = report_year;       

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetByInterventionType
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetByInterventionType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetByInterventionType`( 
	type INT(11)
)
BEGIN
	 SELECT      
		  Id, 
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,   
					inviato,
					visionato,        
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati              
    FROM rapporto_mobile
	WHERE tipo_intervento = type  AND visionato = false
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetByReportNumber
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetByReportNumber;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetByReportNumber`( 
	report_number VARCHAR(45)
)
BEGIN
	 SELECT      
		  Id, 
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,   
					inviato,
					visionato,        
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati             
    FROM rapporto_mobile
	WHERE numero = report_number  AND visionato = false
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetBySystemId
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetBySystemId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetBySystemId`( 
	system_id INT(11)
)
BEGIN
	 SELECT      
		  Id, 
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,   
					inviato,
					visionato,        
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati              
    FROM rapporto_mobile
	WHERE id_impianto = system_id AND visionato = false
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileInterventionGetByViewedStatus
DROP PROCEDURE IF EXISTS sp_ariesReportMobileInterventionGetByViewedStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileInterventionGetByViewedStatus`( 
	viewed_status BIT
)
BEGIN
	 SELECT      
		  Id,
          Id_rapporto,       
          Anno,       
          Id_Impianto,       
          id_destinazione,       
          Id_cliente,       
          Richiesto,       
          Mansione,       
          Responsabile,       
          Tipo_intervento,       
          Diritto_chiamata,       
          tipo_diritto_chiamata,       
          relazione,       
          Terminato,       
          CAST(Funzionante AS UNSIGNED) "Funzionante",       
          Stato,       
          Note_Generali,       
          Data,       
          abbonamento,       
          Data_esecuzione,       
          scan,       
          anno_fattura,       
          controllo_periodico,       
          prima,       
          APPUNTI,   
					inviato,
					visionato,        
          CAST(notturno AS UNSIGNED) "notturno",       
          CAST(festivo AS UNSIGNED) "festivo",       
          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       
          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       
          CAST(sost AS UNSIGNED) "sost",       
          CAST(ripar AS UNSIGNED) "ripar",       
          CAST(abbon AS UNSIGNED) "abbon",       
          CAST(garanz AS UNSIGNED) "garanz",       
          CAST(man_ordi AS UNSIGNED) "man_ordi",
			     
          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       
          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       
          CAST(man_straord AS UNSIGNED) "man_straord",   
			   
          tipo_impianto,       
          ragione_sociale,       
          indirizzo,       
          citta,       
          luogo_lavoro,       
          difetto,       
          id_riferimento,       
          da_reperibilita_telefonica, 
		  usa_altra_firma_su_ddt, 
			IFNULL(tipo_rapporto, 0) AS tipo_rapporto,
		  filename_firma_per_ddt, 
		  filename_firma_cliente,
		  filename_firma_tecnico,
			numero_allegati		  
    FROM rapporto_mobile
    WHERE rapporto_mobile.visionato = viewed_status
			AND rapporto_mobile.data IS NOT NULL
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;	

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileRecipientGet
DROP PROCEDURE IF EXISTS sp_ariesReportMobileRecipientGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileRecipientGet`( 
)
BEGIN

	SELECT rapporto_mobile_destinatario.id,
		rapporto_mobile_destinatario.id_rapporto,
		rapporto_mobile_destinatario.anno, 
		rapporto_mobile_destinatario.email, 
		rapporto_mobile_destinatario.tipo_email,
		rapporto_mobile_destinatario.id_mail,
		mail.data_invio AS data_invio_email,
		mail_stato.nome AS stato_invio_email
	FROM rapporto_mobile_destinatario
		LEFT JOIN mail ON mail.id = rapporto_mobile_destinatario.id_mail
		LEFT JOIN mail_stato ON mail.id_stato = mail_stato.id_stato;
	                        
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportMobileRecipientGetByReport
DROP PROCEDURE IF EXISTS sp_ariesReportMobileRecipientGetByReport;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportMobileRecipientGetByReport`( 
	 IN report_id INT(11), 
	 IN report_year INT(11)
)
BEGIN

	SELECT rapporto_mobile_destinatario.id,
		rapporto_mobile_destinatario.id_rapporto,
		rapporto_mobile_destinatario.anno, 
		rapporto_mobile_destinatario.email, 
		rapporto_mobile_destinatario.tipo_email,
		rapporto_mobile_destinatario.id_mail,
		mail.data_invio AS data_invio_email,
		mail_stato.nome AS stato_invio_email
	FROM rapporto_mobile_destinatario
		LEFT JOIN mail ON mail.id = rapporto_mobile_destinatario.id_mail
		LEFT JOIN mail_stato ON mail.id_stato = mail_stato.id_stato
	WHERE id_rapporto = report_id AND anno = report_year;
	                        
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportProductDeleteByReport
DROP PROCEDURE IF EXISTS sp_ariesReportProductDeleteByReport;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportProductDeleteByReport`(
report_id INT(11), 
report_year INT(11)
)
BEGIN

	DELETE FROM rapporto_materiale
	WHERE Id_rapporto = report_id 
		and anno = report_year; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportProductGetByReport
DROP PROCEDURE IF EXISTS sp_ariesReportProductGetByReport;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportProductGetByReport`(
report_id INT(11), 
report_year INT(11)
)
BEGIN

	SELECT 
		Id_rapporto,
		Id_materiale,
		anno,
		IFNULL(quantità, 0) quantità,
		IFNULL(Prezzo, 0) Prezzo,
		IFNULL(costo, 0) costo,
		descrizione,
		IFNULL(sconto, 0) sconto,
		IFNULL(economia, 0) economia,
		IFNULL(id_magazzino, -1) id_magazzino,
		id_tab,
		tipo,
		IFNULL(qeconomia, 0) qeconomia, 
		unita_misura
	FROM rapporto_materiale
	WHERE Id_rapporto = report_id 
		and anno = report_year
	ORDER BY Id_tab; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportSaveSignaturesByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesReportSaveSignaturesByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportSaveSignaturesByIdAndYear`(
	IN `report_id` INT(11),
	IN `report_year` INT(11),
	IN `first_signature` BIT(1),
	IN `second_signature` BIT(1),
	IN `third_signature` BIT(1), IN `status` INT(11), OUT `result` TINYINT
)
BEGIN
	SET result = 1; 

	UPDATE rapporto 
	SET	
		Firma1 = first_signature, 
		Firma2 = second_signature, 
		Firma3 = third_signature, 
		stato = status
	WHERE id_rapporto = report_id AND anno = report_year;			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertConfigUpdate
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertConfigUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertConfigUpdate`( 
	IN service_id INT(11), 
	IN folder_name VARCHAR(100),
	IN interval_type SMALLINT(6), 
	IN interval_value INT(11),
	IN months_number SMALLINT(6),
	IN email_subject VARCHAR(150), 
	IN email_body TEXT,
	OUT result INTEGER
)
BEGIN

	UPDATE servizio_alert_configurazione
	SET
		`Cartella` = folder_name,
		`Tipo_intervallo` = interval_type,
		`Valore` = interval_value,
		`Numero_mesi` = months_number,
		`Oggetto_email` = email_subject,
		`Corpo_email` = email_body
	WHERE Id = service_id;
	
	SET result = 1; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertConfigurationGet
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertConfigurationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertConfigurationGet`(
)
BEGIN
	SELECT `Id`,
		`Nome`,
		`Cartella`,
		`Tipo_intervallo`,
		`Valore`,
		Numero_mesi,
		Oggetto_email, 
		Corpo_email,
		Data_ultima_esecuzione,
		`Data_mod`,
		`Utente_mod`
	FROM servizio_alert_configurazione;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertGeneralConfigInsert
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertGeneralConfigInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertGeneralConfigInsert`( 
	IN `in_email_host` VARCHAR(50),
	IN `in_email_username` VARCHAR(50),
	IN `in_email_password` VARCHAR(50),
	IN `in_email_port` INT(11),
	IN `in_email_ssl` BIT(1),
	IN `in_email_from` VARCHAR(50),
	OUT result INTEGER
)
BEGIN

	SET result = 0;

	INSERT INTO servizio_alert_configurazione_generale
	SET
		`Email_host` = in_email_host,
		`Email_username` = in_email_username,
		`Email_password` = in_email_password,
		`Email_port` = in_email_port,
		`Email_ssl` = in_email_ssl,
		`Email_from` = in_email_from,
		`Data_ins` = NOW(),  
		Utente_ins = @USER_ID;
	
	SET Result = LAST_INSERT_ID();

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertGeneralConfigUpdate
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertGeneralConfigUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertGeneralConfigUpdate`( 
	IN `in_email_host` VARCHAR(50),
	IN `in_email_username` VARCHAR(50),
	IN `in_email_password` VARCHAR(50),
	IN `in_email_port` INT(11),
	IN `in_email_ssl` BIT(1),
	IN `in_email_from` VARCHAR(50),
	IN In_id INT(11),
	OUT result INTEGER
)
BEGIN

	UPDATE servizio_alert_configurazione_generale
	SET
		`Email_host` = in_email_host,
		`Email_username` = in_email_username,
		`Email_password` = in_email_password,
		`Email_port` = in_email_port,
		`Email_ssl` = in_email_ssl,
		`Email_from` = in_email_from, 
		`Data_ins` = NOW(),  
		Utente_ins = @USER_ID
	WHERE Id = In_id;
	
	SET result = 1; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertGeneralConfigurationGetLast
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertGeneralConfigurationGetLast;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertGeneralConfigurationGetLast`(
)
BEGIN
	SELECT
		`Id`,
		`Email_host`,
		`Email_username`,
		`Email_password`,
		`Email_port`,
		`Email_ssl`,
		Email_from,
		`Data_ins`,
		`Utente_ins`
	FROM servizio_alert_configurazione_generale
	ORDER BY Id DESC
	LIMIT 1;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertRecipientDelete
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertRecipientDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertRecipientDelete`(
	IN in_id INT(11), 
	OUT result INTEGER
)
BEGIN
	DELETE FROM servizio_alert_ricevente
	WHERE Id = in_id;
	
	SET result = 1; 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertRecipientGetByService
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertRecipientGetByService;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertRecipientGetByService`(
	IN service_id INT(11)
)
BEGIN
	SELECT
		`Id`,
		`Id_servizio`,
		`Email`,
		`Data_ins`,
		`Utente_ins` 
	FROM servizio_alert_ricevente
	WHERE Id_servizio = service_id
	ORDER BY Email;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertRecipientInsert
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertRecipientInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertRecipientInsert`(
	IN in_email VARCHAR(50), 
	IN service_id INT(11), 
	OUT result INTEGER
)
BEGIN
	SET result = 0;

	SELECT COUNT(Id)
		INTO
		result
	FROM servizio_alert_ricevente
	WHERE Id_servizio = service_id AND Email = in_email;
	
	IF result = 0 THEN
		INSERT INTO servizio_alert_ricevente
		SET Id_servizio = service_id, 
			Email = in_email,
			Data_ins = NOW(), 
			Utente_ins = @USER_ID;
			
		SET Result = LAST_INSERT_ID();
	ELSE
		SET result = -1;
	END IF;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesServiceAlertRecipientUpdate
DROP PROCEDURE IF EXISTS sp_ariesServiceAlertRecipientUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceAlertRecipientUpdate`(
	IN in_id INT(11),
	IN in_email VARCHAR(50), 
	IN service_id INT(11), 
	OUT result INTEGER
)
BEGIN

	UPDATE servizio_alert_ricevente
	SET Id_servizio = service_id, 
		Email = in_email
	WHERE Id = in_id;
	
	SET result = 1; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePaymentGetById
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePaymentGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePaymentGetById`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11)
)
BEGIN


	SELECT 
		IF(fornfattura_pagamenti.id_fattura IS NULL, false, True) AS 'Exists',
		fornfattura.id_fattura,
		fornfattura.anno, 
		fornfattura.id_fornitore,
		ifNULL(id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fornfattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d') AS UNSIGNED)) as id_pagamento_fix,
		fornfattura_pagamenti.nota,
		IFNULL(fornfattura_pagamenti.tipo_pagamento, a.tipo) as 'tipo_pagamento',
		fornfattura_pagamenti.insoluto,
		fornfattura_pagamenti.id_prima_nota,
		fornfattura_pagamenti.anno_prima_nota,
		fornfattura_pagamenti.id_trasferimento_verso,
		fornfattura_pagamenti.anno_trasferimento_verso,
		ROUND(totiva +(((trasporto/100)*(100+IFNULL(tipo_iva_BTI.aliquota, 0))) + ((bollo/100)*(100+if(iva_bollo=0, 0,
			  	IFNULL(tipo_iva_BTI.aliquota, 0)))) + ((incasso/100)*(100+if(iva_incasso=0, 0,
				IFNULL(tipo_iva_BTI.aliquota, 0)))) ), 2)/a.mesi  AS "importo_rata", 

		IFNULL(fornfattura_pagamenti.`data`, LAST_DAY(fornfattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY) AS "data"
		
	FROM fornfattura
		LEFT JOIN Tipo_iva AS tipo_iva_BTI ON tipo_iva_BTI.id_iva = aliquota_iva_BTI
		INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione
		INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione
		LEFT JOIN fornfattura_pagamenti ON fornfattura.id_fattura=fornfattura_pagamenti.id_fattura AND fornfattura_pagamenti.anno=fornfattura.anno AND fornfattura_pagamenti.id_pagamento= DATE_FORMAT(LAST_DAY(fornfattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d')
	WHERE fornfattura.id_fattura = invoice_id 
		AND fornfattura.anno = invoice_year 
		AND IfNULL(id_pagamento, CAST(DATE_FORMAT(LAST_DAY(fornfattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY,'%Y%m%d') AS UNSIGNED)) = payment_id
	GROUP BY fornfattura.id_fattura, fornfattura.anno, id_pagamento_fix
	ORDER BY fornfattura.anno desc, fornfattura.id_fattura desc;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePaymentInsert
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePaymentInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePaymentInsert`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11), 
	IN payment_date DATE, 
	IN notes TEXT, 
	IN payment_type INT(11), 
	IN unsolved BIT(1),
	OUT result INT(11)
)
BEGIN
	INSERT INTO fornfattura_pagamenti
	SET id_fattura = invoice_id, 
		anno = invoice_year, 
		id_pagamento = payment_id, 
		nota = notes, 
		tipo_pagamento = payment_type, 
		insoluto = unsolved,
		data = payment_date; 

	SET result = 1;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePaymentUpdate
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePaymentUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePaymentUpdate`( 
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `payment_id` INT(11), 
	IN payment_date DATE, 
	IN notes TEXT, 
	IN payment_type INT(11), 
	IN unsolved BIT(1),
	OUT result INT(11)
)
BEGIN
	DECLARE last_payment_date DATE; 
	
	IF (payment_date IS NULL OR (payment_type <> 4 AND payment_type <> 3)) THEN
		CALL sp_ariesFirstNoteDeleteBySupplierInvoice(invoice_id, invoice_year, payment_id, result);
	ELSE 
		SELECT data INTO last_payment_date 
		FROM fornfattura_pagamenti 
		WHERE id_fattura = invoice_id AND 
			anno = invoice_year AND 
			id_pagamento = payment_id;
			
		IF last_payment_date <> payment_date THEN
		
			UPDATE prima_nota
			SET Data = payment_date		
			WHERE id_fornfattura = invoice_id AND 
				anno_fornfattura = invoice_year AND 
				id_pagamento = payment_id;
			
		END IF; 
	END IF;

	UPDATE fornfattura_pagamenti
	SET  nota = notes, 
		tipo_pagamento = payment_type, 
		insoluto = unsolved,
		data = payment_date
	WHERE id_fattura = invoice_id AND 
		anno = invoice_year AND 
		id_pagamento = payment_id; 

	SET result = 1;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePrepaymentGet
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePrepaymentGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePrepaymentGet`( 

)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fornfattura_acconto;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePrepaymentGetById
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePrepaymentGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePrepaymentGetById`( 
	IN prepayment_id INT(11)
)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fornfattura_acconto
	WHERE id_acconto = prepayment_id;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoicePrepaymentGetByPayment
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoicePrepaymentGetByPayment;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoicePrepaymentGetByPayment`( 
	IN invoice_id INT(11), 
	IN invoice_year INT(11), 
	IN payment_id INT(11)
)
BEGIN
	SELECT 
		`id_acconto`,
		`id_fattura`,
		`anno`,
		`id_pagamento`,
		`importo`,
		`data`,
		`modo`
	FROM fornfattura_acconto
	WHERE id_fattura = invoice_id
		AND anno = invoice_year
		AND id_pagamento = payment_id;
 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGet
DROP PROCEDURE IF EXISTS sp_ariesSystemGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGet`( )
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) AS Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetById
DROP PROCEDURE IF EXISTS sp_ariesSystemGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetById`( 
  systemId INT
)
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) AS Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	WHERE (Id_impianto = systemId); 
		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetByManagerId
DROP PROCEDURE IF EXISTS sp_ariesSystemGetByManagerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetByManagerId`( 
  manager_id INT
)
BEGIN
      
	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) AS Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	WHERE (id_cliente = manager_id); 	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetByIds
DROP PROCEDURE IF EXISTS sp_ariesSystemGetByIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetByIds`(
	IN idArray MEDIUMTEXT)
BEGIN

SELECT DISTINCT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,"1970-01-01") AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,"1970-01-01") AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,"1970-01-01") AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, "") As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,"1970-01-01") AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,"1970-01-01") AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) AS Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	  WHERE FIND_IN_SET(Id_impianto, idArray) > 0; 
  
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetByTicketStatus
DROP PROCEDURE IF EXISTS sp_ariesSystemGetByTicketStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetByTicketStatus`( 
	statusTicket INT(11)
)
BEGIN
        

	SELECT DISTINCT impianto.Id_impianto,
		impianto.id_cliente, 
		impianto.id_gestore, 
		impianto.id_occupante, 
		CAST(IFNULL(impianto.Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(impianto.Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(impianto.altro, "") AS altro, 
		IFNULL(impianto.Abbonamento, 0) abbonamento, 
		impianto.Tipo_impianto,  
		IFNULL(impianto.Stato, 0) AS Stato , 
		CAST(IFNULL(impianto.Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(impianto.Descrizione, '') As Descrizione, 
		IFNULL(impianto.Destinazione, 0) AS Destinazione , 
		IFNULL(impianto.Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(impianto.Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(impianto.Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(impianto.Persone, 0) AS Persone, 
		impianto.Data_modifica, 
		impianto.Contr, 
		IFNULL(impianto.sub, 0) AS sub, 
		IFNULL(impianto.orario_prog, 0) AS orario_prog, 
		IFNULL(impianto.id_utente, 0) AS id_utente, 
		IFNULL(impianto.auto, 0) AS Auto, 
		IFNULL(impianto.condizione, 0) AS condizione, 
		IFNULL(impianto.eta, 0) AS eta, 
		IFNULL(impianto.Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(impianto.Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(impianto.Checklist, 0) Checklist,
		IFNULL(impianto.Centrale, "") AS Centrale, 
		IFNULL(impianto.gsm, "") AS gsm, 
		IFNULL(impianto.combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(impianto.flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(impianto.flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
		INNER JOIN Ticket 
		ON Impianto.Id_impianto = Ticket.Id_impianto AND Ticket.Stato_ticket = statusTicket;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetCustomerInfoForPrint
DROP PROCEDURE IF EXISTS sp_ariesSystemGetCustomerInfoForPrint;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetCustomerInfoForPrint`()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tmpReports; 
	CREATE TEMPORARY TABLE tmpReports
	(
		id_rapporto BIGINT, 
		anno INT, 
		id_impianto INT,
		Relazione TEXT,
		data_esecuzione DATE
		
	);
	
	INSERT INTO tmpReports
	SELECT * 
	FROM 
		(SELECT
			Rapporto.id_rapporto,
			Rapporto.anno,
			Rapporto.id_impianto, 
			rapporto.relazione,
			Rapporto.data_esecuzione
		FROM Rapporto 
		WHERE ID_impianto IS NOT NULL
		ORDER BY Rapporto.data_esecuzione DESC) as tmp
	GROUP BY id_impianto;

	DROP TEMPORARY TABLE IF EXISTS tmpSystemSubscription; 
	CREATE TEMPORARY TABLE tmpSystemSubscription
	(
		Id_impianto INT, 
		id_abbonamento INT, 
		descrizione_abbonamento VARCHAR(150),
		Anno INT		
	);
	
	INSERT INTO tmpSystemSubscription
	SELECT * 
	FROM 
		(SELECT
			impianto_abbonamenti_mesi.impianto id_impianto,
			impianto_abbonamenti_mesi.abbonamenti id_abbonemnto,
			abbonamento.Nome, 
			impianto_abbonamenti_mesi.anno
		FROM impianto_abbonamenti_mesi
			INNER JOIN impianto
				ON impianto.Id_impianto = impianto_abbonamenti_mesi.impianto
			INNER JOIN Abbonamento 
				ON abbonamento.Id_abbonamento = impianto_abbonamenti_mesi.abbonamenti  
		WHERE ID_impianto IS NOT NULL
		ORDER BY impianto_abbonamenti_mesi.anno DESC,
			impianto_abbonamenti_mesi.mese DESC) As tmp
	GROUP BY id_impianto;


	DROP TEMPORARY TABLE IF EXISTS tmpCustomersInfo; 
	CREATE TEMPORARY TABLE tmpCustomersInfo
	(
		id_cliente INT, 
		Ragione_sociale VARCHAR(100), 
		Indirizzo VARCHAR(250),  
		teleono VARCHAR(20), 
		cellulare VARCHAR(20), 
		email VARCHAR(100),
		partita_iva VARCHAR(11), 
		codice_fiscale VARCHAR(20)
	);
	
	INSERT INTO tmpCustomersInfo 
	SELECT Clienti.Id_CLiente, 
		Clienti.ragione_sociale,
		CONCAT(destinazione_cliente.Indirizzo, ", ", destinazione_cliente.numero_civico, " - ", 
			comune.cap," ", 
			IF(Frazione.nome IS NULL, "", Concat(Frazione.nome , " di ")), 
			IFNULL(comune.Nome, "")) AS Indirizzo, 
		riferimento_clienti.Telefono, 
		riferimento_clienti.altro_telefono, 
		riferimento_clienti.mail,
		clienti.Partita_iva, 
		clienti.Codice_Fiscale
	FROM Clienti
		INNER JOIN destinazione_cliente 
			ON Clienti.Id_Cliente = destinazione_cliente.Id_Cliente AND Sede_principale = 1
		INNER JOIN riferimento_clienti
			ON Clienti.id_Cliente = riferimento_clienti.Id_Cliente and riferimento_clienti.Id_riferimento = 1
		LEFT JOIN Comune ON
			destinazione_cliente.Comune = comune.Id_comune
		LEFT JOIN frazione ON
			destinazione_cliente.Frazione = frazione.Id_frazione 
	WHERE clienti.Stato_cliente NOT IN ('clGray', 'clBlack','$004A4AFF');

	select * from tmpCustomersInfo;
	select * from tmpReports;
	select * from tmpSystemSubscription; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemGetOrderByDescription
DROP PROCEDURE IF EXISTS sp_ariesSystemGetOrderByDescription;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemGetOrderByDescription`( )
BEGIN
        

	SELECT Id_impianto,
		id_cliente, 
		id_gestore, 
		id_occupante, 
		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,
		IFNULL(altro, "") AS altro, 
		IFNULL(Abbonamento, 0) abbonamento, 
		Tipo_impianto,  
		IFNULL(Stato, 0) AS Stato , 
		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,
		IFNULL(Descrizione, '') As Descrizione, 
		IFNULL(Destinazione, 0) AS Destinazione , 
		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 
		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 
		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,
		IFNULL(Persone, 0) AS Persone, 
		Data_modifica, 
		Contr, 
		IFNULL(sub, 0) AS sub, 
		IFNULL(orario_prog, 0) AS orario_prog, 
		IFNULL(id_utente, 0) AS id_utente, 
		IFNULL(auto, 0) AS Auto, 
		IFNULL(condizione, 0) AS condizione, 
		IFNULL(eta, 0) AS eta, 
		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 
		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,
		IFNULL(Checklist, 0) AS Checklist,
		IFNULL(Centrale, "") AS Centrale, 
		IFNULL(gsm, "") AS gsm, 
		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 
		IFNULL(flag_abbonamento, 0) As flag_abbonamento,
		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno
	FROM Impianto
	ORDER BY Descrizione ASC;
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringDeleteById
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringDeleteById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringDeleteById`(
	enter_id INT,
	OUT Result INT
)
BEGIN

	SELECT Id
		INTO
		Result 
	FROM Impianto_abbonamenti_mesi
	WHERE id = enter_id;

	
	IF Result THEN
		DELETE FROM  impianto_abbonamenti_mesi 
		WHERE Id = enter_id;  
		
		DELETE FROM Evento 
		WHERE Id_tipo_evento = 1
			AND Id_riferimento = enter_id; 
				
		SET Result = 1; 
	
	ELSE
		SET Result = -5; -- record not found
			
	END IF; 
	
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringGet
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringGet`()
BEGIN
	SELECT Id,
		impianto AS Id_impianto,
		anno, 
		abbonamenti AS id_abbonamento, 
		mese, 
		Eseguito_il, 
		IFNULL(Id_rapp, 0) AS id_rapporto, 
		IFNULL(anno_rapp, 0) AS anno_rapporto, 
		da_eseguire,
		IFNULL(prezzo, 0 ) AS prezzo, 
		IFNULL(nota_mese, "") AS note,
		IFNULL(modifica_mese, 0) AS modifica_mese,
		IFNULL(modifica_anno, 0) AS modifica_anno
	FROM Impianto_abbonamenti_mesi; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringGetById
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringGetById`(
	enter_id INT
)
BEGIN
	SELECT Id,
		impianto AS Id_impianto,
		anno, 
		abbonamenti AS id_abbonamento, 
		mese, 
		Eseguito_il, 
		IFNULL(Id_rapp, 0) AS id_rapporto, 
		IFNULL(anno_rapp, 0) AS anno_rapporto, 
		da_eseguire,
		IFNULL(prezzo, 0 ) AS prezzo, 
		IFNULL(nota_mese, "") AS note,
		IFNULL(modifica_mese, 0) AS modifica_mese,
		IFNULL(modifica_anno, 0) AS modifica_anno
	FROM Impianto_abbonamenti_mesi
	WHERE Id = enter_id; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringGetNextToExecutedForEachSystem
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringGetNextToExecutedForEachSystem;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringGetNextToExecutedForEachSystem`(
)
BEGIN
	SELECT Impianto_abbonamenti_mesi.Id,
		Impianto_abbonamenti_mesi.impianto AS Id_impianto,
		Impianto_abbonamenti_mesi.anno, 
		Impianto_abbonamenti_mesi.abbonamenti AS id_abbonamento, 
		Impianto_abbonamenti_mesi.mese, 
		Impianto_abbonamenti_mesi.Eseguito_il, 
		IFNULL(Impianto_abbonamenti_mesi.Id_rapp, 0) AS id_rapporto, 
		IFNULL(Impianto_abbonamenti_mesi.anno_rapp, 0) AS anno_rapporto, 
		Impianto_abbonamenti_mesi.da_eseguire,
		IFNULL(Impianto_abbonamenti_mesi.prezzo, 0 ) AS prezzo, 
		IFNULL(Impianto_abbonamenti_mesi.nota_mese, "") AS note,
		IFNULL(Impianto_abbonamenti_mesi.modifica_mese, 0) AS modifica_mese,
		IFNULL(Impianto_abbonamenti_mesi.modifica_anno, 0) AS modifica_anno
	FROM Impianto_abbonamenti_mesi
	WHERE  Eseguito_il IS NULL 
		AND CONCAT(Anno, "-", mese, "-01") >= DATE_FORMAT(NOW() - INTERVAL 1 YEAR, '%Y-%m-%d')
	GROUP BY Id_impianto
	ORDER BY Impianto_abbonamenti_mesi.Anno ASC, Impianto_abbonamenti_mesi.mese ASC ;  
	 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringGetToScheduled
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringGetToScheduled;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringGetToScheduled`(
	IN group_id INT(11)
)
BEGIN

	DROP TABLE IF EXISTS tmp_events_period;
	CREATE TEMPORARY TABLE tmp_events_period
	SELECT Evento.* 
	FROM Evento
		INNER JOIN Evento_gruppo_evento ON Evento_gruppo_evento.Id_evento = Evento.Id AND Evento_gruppo_evento.Id_gruppo_evento != group_id
	WHERE evento.Id_tipo_evento = 1; 			

	SELECT Impianto_abbonamenti_mesi.Id,
		Impianto_abbonamenti_mesi.impianto AS Id_impianto,
		Impianto_abbonamenti_mesi.anno, 
		Impianto_abbonamenti_mesi.abbonamenti AS id_abbonamento, 
		Impianto_abbonamenti_mesi.mese, 
		Impianto_abbonamenti_mesi.Eseguito_il, 
		IFNULL(Impianto_abbonamenti_mesi.Id_rapp, 0) AS id_rapporto, 
		IFNULL(Impianto_abbonamenti_mesi.anno_rapp, 0) AS anno_rapporto, 
		Impianto_abbonamenti_mesi.da_eseguire,
		IFNULL(Impianto_abbonamenti_mesi.prezzo, 0 ) AS prezzo, 
		IFNULL(Impianto_abbonamenti_mesi.nota_mese, "") AS note,
		IFNULL(Impianto_abbonamenti_mesi.modifica_mese, 0) AS modifica_mese,
		IFNULL(Impianto_abbonamenti_mesi.modifica_anno, 0) AS modifica_anno
	FROM Impianto_abbonamenti_mesi
	LEFT JOIN 
		tmp_events_period as evento
	  ON evento.Id_tipo_evento = 1 AND Impianto_abbonamenti_mesi.Id = evento.Id_riferimento 
	WHERE  Impianto_abbonamenti_mesi.Eseguito_il IS NULL AND (evento.Id IS NULL OR Evento.eliminato)
	 ORDER BY Impianto_abbonamenti_mesi.Anno ASC, Impianto_abbonamenti_mesi.mese ASC ;  
	 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringInsert
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringInsert`(
	system_id INT, 
	enter_year INT, 
	subscription_id INT,
	enter_month INT, 
	real_execution_date DATETIME, 
	theorical_execution_date DATETIME, 
	report_id INT, 
	report_year INT, 
	price DECIMAL(11,2), 
	notes TEXT,
	OUT insertId INT, 
	OUT Result INT
)
BEGIN

	SELECT Id_Impianto
		INTO
		Result 
	FROM Impianto 
	WHERE Id_impianto = system_id;
	
	

	IF Result THEN  
		
		SELECT Id_Impianto
			INTO
				Result 
		FROM Impianto_abbonamenti 
		WHERE Id_impianto = system_id AND Anno = enter_year 
			AND Id_abbonamenti = subscription_id;
		
	ELSE
	
		SET Result = -2; -- System Id Not found 
				
	END IF; 
	
	
	
	IF Result THEN  
		
		SELECT Id_Impianto
			INTO
				Result 
		FROM Impianto_abbonamenti_mesi
		WHERE  impianto = system_id AND Anno = enter_year 
			AND mesi = enter_month ;
		
	ELSE
		SET Result = -3; -- Subscription not found in enter year		
	END IF; 
	
	
	IF Result THEN
	
		SET Result = -1; -- Periodic Monitoring already exists
	
	ELSE
		SET Result = 1; 
	 
	END IF; 
	
	IF Result THEN 
		IF report_year <> 0 AND report_id <> 0  THEN  
			
			SELECT Id_Rapporto
				INTO
					Result 
			FROM rapporto 
			WHERE Id_rapporto = report_id AND anno_Rapporto = report_id;
			
				
			IF NOT Result THEN
				SET Result = -4; -- Report id not found 
			END IF; 
				
		END IF; 
	END IF; 	

	

	
	
	IF Result THEN
	
		INSERT INTO impianto_abbonamenti_mesi 
		SET 	impianto = system_id, 
				anno = enter_year,
				mese = enter_month,
				abbonamenti = subscription_id,
				eseguito_il = real_execution_date, 
				da_eseguire = theorical_execution_date, 
				id_rapp = report_id, 
				anno_rapp = report_year, 
				prezzo = price, 
				nota_mese = notes,
				modifica_mese = 0, 
				modifica_anno = 0; 
		
				
		SET InsertId = LAST_INSERT_ID();
		
		
		IF InsertId THEN
			SET Result = 1;
			
		ELSE
			SET Result = 0; 
		END IF; 
		
	END IF; 
	
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemPeriodicMonitoringUpdate
DROP PROCEDURE IF EXISTS sp_ariesSystemPeriodicMonitoringUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemPeriodicMonitoringUpdate`(
	system_id INT,
	enter_year INT, 
	subscription_id INT,
	enter_month INT, 
	real_execution_date DATETIME, 
	theorical_execution_date DATETIME, 
	report_id INT, 
	report_year INT, 
	price DECIMAL(11,2), 
	notes TEXT,
	enter_id INT, 
	OUT Result INT
)
BEGIN

	SELECT Id_Impianto
		INTO
		Result 
	FROM Impianto 
	WHERE Id_impianto = system_id;
	
	

	IF Result THEN  
		
		SELECT Id_Impianto
			INTO
				Result 
		FROM Impianto_abbonamenti 
		WHERE Id_impianto = system_id AND Anno = enter_year 
			AND Id_abbonamenti = subscription_id;
		
	ELSE
		SET Result = -2; -- System Id Not found 		
	END IF; 
	
	
	
	IF Result THEN  
		
		SELECT Id
			INTO
				Result 
		FROM Impianto_abbonamenti_mesi
		WHERE  Id = enter_id ;
	ELSE
		SET Result = -3; -- Subscription not found in enter year		
	END IF; 
	
	
	IF Result THEN
		IF report_year <> 0 AND report_id <> 0 THEN  
			
			SELECT Id_Rapporto
				INTO
					Result 
			FROM rapporto 
			WHERE Id_rapporto = report_id AND anno_Rapporto = report_id;

		END IF; 
		
		IF NOT Result THEN
			SET Result = -4; -- Report id not found 
		END IF; 
				
				
	ELSE
		SET Result = -5; -- Periodic Monitoring not found
	END IF;  

	
	IF Result THEN
	
		UPDATE impianto_abbonamenti_mesi 
		SET 	impianto = system_id, 
				anno = enter_year,
				mese = enter_month,
				abbonamenti = subscription_id,
				eseguito_il = real_execution_date, 
				da_eseguire = theorical_execution_date, 
				id_rapp = report_id, 
				anno_rapp = report_year, 
				prezzo = price, 
				nota_mese = notes,
				modifica_mese = 0, 
				modifica_anno = 0
		WHERE Id = Enter_id;
		
		
				
		
		IF InsertId THEN
			SET Result = 1;
			
		ELSE
			SET Result = 0; 
		END IF;  
		
	END IF; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSystemTypeGetById
DROP PROCEDURE IF EXISTS sp_ariesSystemTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemTypeGetById`(
type_id INT(11)
)
BEGIN

	SELECT Id_tipo, 
		Nome, 
		Descrizione,
		Utente_mod, 
		Data_mod
	FROM Tipo_impianto
	WHERE Id_tipo = type_id; 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTabletConfigurationGetLastInsert
DROP PROCEDURE IF EXISTS sp_ariesTabletConfigurationGetLastInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTabletConfigurationGetLastInsert`( 
)
BEGIN
      
SELECT
	Id_tablet, 
	IFNULL(mail, "") AS mail, 
	IFNULL(testo_mail, "") AS testo_mail, 
	IFNULL(Host, "") AS host, 
	IFNULL(Password, "") AS Password, 
	IFNULL(porta, 0) AS Porta, 
	IFNULL(Username, "") AS Username, 
	IFNULL(DIsplay_name, "") AS Display_name, 
	messaggio_non_abbonato,
	admin_password,
	email_ufficio,
	IFNULL(Data_ins, Data_Mod) AS Data_ins,
	Data_Mod
FROM tablet_configurazione ORDER BY id_tablet DESC LIMIT 1; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTabletConfigurationInsert
DROP PROCEDURE IF EXISTS sp_ariesTabletConfigurationInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTabletConfigurationInsert`( 
	email_sender VARCHAR(100),
	email_body TEXT,
	email_host VARCHAR(50), 
	email_port INT, 
	email_display_name VARCHAR(30), 
	email_username VARCHAR(45), 
	email_password VARCHAR(45),
	no_subscriber_message TEXT,
	admin_password VARCHAR(20), 
	office_email VARCHAR(100), 
	OUT result BIT
)
BEGIN

	SET result = 1; 
	
   INSERT INTO tablet_configurazione 
   	SET mail = email_sender, 
   	username = email_username,
   	password = email_password, 
   	host = email_host, 
   	porta = email_port, 
   	testo_mail = email_body, 
   	display_name =  email_display_name, 
		messaggio_non_abbonato = no_subscriber_message, 
		admin_password = admin_password, 
		email_ufficio = office_email,
   	Data_ins = CURDATE(); 
   
   SELECT ROW_COUNT() INTO result; 
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGet
DROP PROCEDURE IF EXISTS sp_ariesTicketGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGet`( )
BEGIN
        

	SELECT 
		Id,
		Id_ticket, 
		Anno,
		IFNULL(Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Id_cliente, 0) AS Id_cliente, 
		IFNULL(Descrizione, "") AS Descrizione, 
		IFNULL(Causale, 0) As Causale, 
		IFNULL(Urgenza, 0) AS Urgenza, 
		IFNULL(intervento, 0) As Intervento, 
		IFNULL(comunicazione, 0) AS comunicazione, 
		IFNULL(id_destinazione, 0) AS Id_destinazione,  
		IFNULL(sede_principale, 0) AS sede_principale, 
		IFNULL(stato_ticket, 0) AS stato_ticket, 
		IFNULL(tempo, 0) As Tempo, 
		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(id_utente, 0) AS Id_utente, 
		IFNULL(stampato, 0) As Stampato, 
		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(num_tick, 0) As num_tick,
		IFNULL(inviato, 0) As inviato,
		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		
	FROM Ticket;  
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesTicketGetByCustomerId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetByCustomerId`( 
  CustomerId INT
)
BEGIN
        

	SELECT 
		Id,
		Id_ticket, 
		Anno,
		IFNULL(Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Id_cliente, 0) AS Id_cliente, 
		IFNULL(Descrizione, "") AS Descrizione, 
		IFNULL(Causale, 0) As Causale, 
		IFNULL(Urgenza, 0) AS Urgenza, 
		IFNULL(intervento, 0) As Intervento, 
		IFNULL(comunicazione, 0) AS comunicazione, 
		IFNULL(id_destinazione, 0) AS Id_destinazione,  
		IFNULL(sede_principale, 0) AS sede_principale, 
		IFNULL(stato_ticket, 0) AS stato_ticket, 
		IFNULL(tempo, 0) As Tempo, 
		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(id_utente, 0) AS Id_utente, 
		IFNULL(stampato, 0) As Stampato, 
		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(num_tick, 0) As num_tick,
		IFNULL(inviato, 0) As inviato,
		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		
	FROM Ticket
	WHERE (Id_cliente = customerid); 
		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetById
DROP PROCEDURE IF EXISTS sp_ariesTicketGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetById`( 
  ticketid INT
)
BEGIN
        

	SELECT 
		Id,
		Id_ticket, 
		Anno,
		IFNULL(Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Id_cliente, 0) AS Id_cliente, 
		IFNULL(Descrizione, "") AS Descrizione, 
		IFNULL(Causale, 0) As Causale, 
		IFNULL(Urgenza, 0) AS Urgenza, 
		IFNULL(intervento, 0) As Intervento, 
		IFNULL(comunicazione, 0) AS comunicazione, 
		IFNULL(id_destinazione, 0) AS Id_destinazione,  
		IFNULL(sede_principale, 0) AS sede_principale, 
		IFNULL(stato_ticket, 0) AS stato_ticket, 
		IFNULL(tempo, 0) As Tempo, 
		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(id_utente, 0) AS Id_utente, 
		IFNULL(stampato, 0) As Stampato, 
		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(num_tick, 0) As num_tick,
		IFNULL(inviato, 0) As inviato,
		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		
	FROM Ticket
	WHERE (Id = ticketid); 
		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetByStatus
DROP PROCEDURE IF EXISTS sp_ariesTicketGetByStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetByStatus`( 
	ticketsStatus MEDIUMTEXT
)
BEGIN

  SELECT DISTINCT Ticket.Id,
		Ticket.Id_ticket, 
		Ticket.Anno,
		IFNULL(Ticket.Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(Ticket.data_ora, "1970-01-01") AS DATETIME) As data_ora,
		IFNULL(Ticket.Id_cliente, 0) AS Id_cliente, 
		IFNULL(Ticket.Descrizione, "") AS Descrizione, 
		IFNULL(Ticket.Causale, 0) As Causale, 
		IFNULL(Ticket.Urgenza, 0) AS Urgenza, 
		IFNULL(Ticket.intervento, 0) As Intervento, 
		IFNULL(Ticket.comunicazione, 0) AS comunicazione, 
		IFNULL(Ticket.id_destinazione, 0) AS Id_destinazione,  
		IFNULL(Ticket.sede_principale, 0) AS sede_principale, 
		IFNULL(Ticket.stato_ticket, 0) AS stato_ticket, 
		IFNULL(Ticket.tempo, 0) As Tempo, 
		CAST(IFNULL(Ticket.scadenza, "1970-01-01") AS DATETIME) AS scadenza,
		IFNULL(Ticket.id_utente, 0) AS Id_utente, 
		IFNULL(Ticket.stampato, 0) As Stampato, 
		CAST(IFNULL(Ticket.data_ticket, "1970-01-01") AS DATETIME) AS data_ticket,
		IFNULL(Ticket.num_tick, 0) As num_tick,
		IFNULL(Ticket.inviato, 0) As inviato,
		CAST(IFNULL(Ticket.data_promemoria, "1970-01-01") AS DATETIME) AS data_promemoria		 
	 FROM Ticket
	 WHERE  FIND_IN_SET(ticket.Stato_ticket ,ticketsStatus) > 0;  
  
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetBySystemId
DROP PROCEDURE IF EXISTS sp_ariesTicketGetBySystemId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetBySystemId`( 
  SystemId INT
)
BEGIN
        

	SELECT 
		Id,
		Id_ticket, 
		Anno,
		IFNULL(Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Id_cliente, 0) AS Id_cliente, 
		IFNULL(Descrizione, "") AS Descrizione, 
		IFNULL(Causale, 0) As Causale, 
		IFNULL(Urgenza, 0) AS Urgenza, 
		IFNULL(intervento, 0) As Intervento, 
		IFNULL(comunicazione, 0) AS comunicazione, 
		IFNULL(id_destinazione, 0) AS Id_destinazione,  
		IFNULL(sede_principale, 0) AS sede_principale, 
		IFNULL(stato_ticket, 0) AS stato_ticket, 
		IFNULL(tempo, 0) As Tempo, 
		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(id_utente, 0) AS Id_utente, 
		IFNULL(stampato, 0) As Stampato, 
		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(num_tick, 0) As num_tick,
		IFNULL(inviato, 0) As inviato,
		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		
	FROM Ticket
	WHERE (id_impianto = systemid); 
		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetByUrgencyStatus
DROP PROCEDURE IF EXISTS sp_ariesTicketGetByUrgencyStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetByUrgencyStatus`( 
	urgencyStatus MEDIUMTEXT
)
BEGIN

  SELECT DISTINCT Ticket.Id,
		Ticket.Id_ticket, 
		Ticket.Anno,
		IFNULL(Ticket.Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(Ticket.data_ora, "1970-01-01") AS DATETIME) As data_ora,
		IFNULL(Ticket.Id_cliente, 0) AS Id_cliente, 
		IFNULL(Ticket.Descrizione, "") AS Descrizione, 
		IFNULL(Ticket.Causale, 0) As Causale, 
		IFNULL(Ticket.Urgenza, 0) AS Urgenza, 
		IFNULL(Ticket.intervento, 0) As Intervento, 
		IFNULL(Ticket.comunicazione, 0) AS comunicazione, 
		IFNULL(Ticket.id_destinazione, 0) AS Id_destinazione,  
		IFNULL(Ticket.sede_principale, 0) AS sede_principale, 
		IFNULL(Ticket.stato_ticket, 0) AS stato_ticket, 
		IFNULL(Ticket.tempo, 0) As Tempo, 
		CAST(IFNULL(Ticket.scadenza, "1970-01-01") AS DATETIME) AS scadenza,
		IFNULL(Ticket.id_utente, 0) AS Id_utente, 
		IFNULL(Ticket.stampato, 0) As Stampato, 
		CAST(IFNULL(Ticket.data_ticket, "1970-01-01") AS DATETIME) AS data_ticket,
		IFNULL(Ticket.num_tick, 0) As num_tick,
		IFNULL(Ticket.inviato, 0) As inviato,
		CAST(IFNULL(Ticket.data_promemoria, "1970-01-01") AS DATETIME) AS data_promemoria		 
	 FROM Ticket
	 WHERE  FIND_IN_SET(ticket.Urgenza, urgencyStatus) > 0;  
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketGetToScheduled
DROP PROCEDURE IF EXISTS sp_ariesTicketGetToScheduled;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetToScheduled`( 
	IN group_id INT(11)
)
BEGIN

	DROP TABLE IF EXISTS tmp_events_ticket;
	CREATE TEMPORARY TABLE tmp_events_ticket
	SELECT Evento.* 
	FROM Evento
		INNER JOIN Evento_gruppo_evento ON Evento_gruppo_evento.Id_evento = Evento.Id AND Evento_gruppo_evento.Id_gruppo_evento != group_id
	WHERE evento.Id_tipo_evento = 2; 
				


	SELECT DISTINCT Ticket.Id,
		Ticket.Id_ticket, 
		Ticket.Anno,
		IFNULL(Ticket.Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(Ticket.data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Ticket.Id_cliente, 0) AS Id_cliente, 
		IFNULL(Ticket.Descrizione, "") AS Descrizione, 
		IFNULL(Ticket.Causale, 0) As Causale, 
		IFNULL(Ticket.Urgenza, 0) AS Urgenza, 
		IFNULL(Ticket.intervento, 0) As Intervento, 
		IFNULL(Ticket.comunicazione, 0) AS comunicazione, 
		IFNULL(Ticket.id_destinazione, 0) AS Id_destinazione,  
		IFNULL(Ticket.sede_principale, 0) AS sede_principale, 
		IFNULL(Ticket.stato_ticket, 0) AS stato_ticket, 
		IFNULL(Ticket.tempo, 0) As Tempo, 
		CAST(IFNULL(Ticket.scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(Ticket.id_utente, 0) AS Id_utente, 
		IFNULL(Ticket.stampato, 0) As Stampato, 
		CAST(IFNULL(Ticket.data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(Ticket.num_tick, 0) As num_tick,
		IFNULL(Ticket.inviato, 0) As inviato,
		CAST(IFNULL(Ticket.data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		 
	 FROM Ticket
		LEFT JOIN tmp_events_ticket as evento 
		  ON evento.Id_tipo_evento = 2 AND ticket.Id = evento.Id_riferimento 
	 WHERE  ticket.Stato_ticket IN (1,2) AND (evento.Id IS NULL OR Evento.eliminato)
	 ORDER BY Ticket.data_ora ;  
 
 END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesTicketGetByTagId
DROP PROCEDURE IF EXISTS sp_ariesTicketGetByTagId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketGetByTagId`( 
  tag_id INT
)
BEGIN
        

	SELECT 
		Id,
		Ticket.Id_ticket, 
		Anno,
		IFNULL(Id_impianto, 0) AS id_impianto, 
		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,
		IFNULL(Id_cliente, 0) AS Id_cliente, 
		IFNULL(Descrizione, "") AS Descrizione, 
		IFNULL(Causale, 0) As Causale, 
		IFNULL(Urgenza, 0) AS Urgenza, 
		IFNULL(intervento, 0) As Intervento, 
		IFNULL(comunicazione, 0) AS comunicazione, 
		IFNULL(id_destinazione, 0) AS Id_destinazione,  
		IFNULL(sede_principale, 0) AS sede_principale, 
		IFNULL(stato_ticket, 0) AS stato_ticket, 
		IFNULL(tempo, 0) As Tempo, 
		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,
		IFNULL(id_utente, 0) AS Id_utente, 
		IFNULL(stampato, 0) As Stampato, 
		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,
		IFNULL(num_tick, 0) As num_tick,
		IFNULL(inviato, 0) As inviato,
		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		
	FROM Ticket
		INNER JOIN ticket_tag ON Ticket.id_ticket = ticket_tag.id_ticket AND Ticket.anno = ticket_tag.anno_ticket
	WHERE ticket_tag.id_tag = tag_id; 
		
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesUnitsOfMeasureGet
DROP PROCEDURE IF EXISTS sp_ariesUnitsOfMeasureGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesUnitsOfMeasureGet`()
BEGIN

	SELECT 
		Id, 
		Sigla, 
		nome
	FROM unita_misura
	ORDER BY Nome; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesUserCheckAdminPassword
DROP PROCEDURE IF EXISTS sp_ariesUserCheckAdminPassword;
DELIMITER //
CREATE  PROCEDURE `sp_ariesUserCheckAdminPassword`(IN `pass` VARCHAR(50), OUT `result` BIT(1))
BEGIN
	
	SELECT COUNT(id_utente) > 0
	INTO result
	FROM utente
	WHERE nome = 'admin' AND password = CONVERT(SHA1(CONCAT(pass, salt)) USING latin1);
		
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesUserGet
DROP PROCEDURE IF EXISTS sp_ariesUserGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesUserGet`()
BEGIN
SELECT 

		id_utente, 
		Nome, 
		password,
		IFNULL(Descrizione,"") as descrizione,
		IFNULL(mail, "") AS mail, 
		IFNULL(Firma,"") as firma, 
		calendario,  
		IFNULL(smtp, "") as smtp, 
		IFNULL(porta, "0") as porta, 
		IFNULL(mssl, 0) as mssl,
		IFNULL(nome_utente_mail, "") as nome_utente_mail,
		IFNULL(password_mail, "") as password_mail, 
		tipo_utente, 
		conferma, 
		salt
		
	  
		FROM utente;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesUserGetById
DROP PROCEDURE IF EXISTS sp_ariesUserGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesUserGetById`(
user_id INT)
BEGIN
SELECT 

		id_utente, 
		Nome, 
		password,
		IFNULL(Descrizione,"") as descrizione,
		IFNULL(mail, "") as mail, 
		IFNULL(Firma,"") as firma, 
		calendario,  
		IFNULL(smtp, "") as smtp, 
		IFNULL(porta, "0") as porta, 
		IFNULL(mssl, 0) as mssl,
		IFNULL(nome_utente_mail, "") as nome_utente_mail,
		IFNULL(password_mail, "") as password_mail, 
		tipo_utente, 
		conferma, 
		salt
		
	  
		FROM utente
		WHERE id_utente = user_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesUserLogin
DROP PROCEDURE IF EXISTS sp_ariesUserLogin;
DELIMITER //
CREATE  PROCEDURE `sp_ariesUserLogin`(IN `username` VARCHAR(50), IN `pass` VARCHAR(50), OUT `userId` INT)
BEGIN
	DECLARE company_id INT; 
	
	SELECT id_utente 
	INTO userId 
	FROM utente
	WHERE nome = username 
		AND password = CONVERT(SHA1(CONCAT(pass, salt)) USING latin1);
		
	SET userId = IFNULL(userId, 0);
	
	SELECT Id_azienda INTO company_id
	FROM azienda  
	ORDER BY id_azienda DESC
	LIMIT 1;
	
	
	SET @USER_ID = userId; 
	SET @COMPANY_ID = IFNULL(company_id, 0);
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalGetById
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalGetById`( 
enter_id INT, 
enter_year INT
)
BEGIN
        
	SELECT 
		`Id_lista`,
		`Anno`,
		cliente,
		`id_destinazione`,
		`Id_operaio`,
		`rientro`,
		`causale`,
		`Data`,
		`Tipo_materiale`,
		`Nota`,
		`colli`,
		`id_principale`,
		`Id_ddt`,
		`id_anno`,
		`id_utente`,
		`timestamp`
	FROM lista_prelievo
	WHERE Id_lista = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalInsert
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalInsert`(
	enter_year INT(11),
	customer_id INT(11),
	destination_id INT(11),
	employee_id INT(11),
	is_return BIT, 
	causal_id INT(11),
	exec_date DATE, 
	material_type INT(11), 
	notes TEXT, 
	packages INT(11), 
	main_id INT(11), 
	ddt_id INT(11), 
	ddt_year INT(11), 
	OUT result INTEGER
)
MainLabel:BEGIN


	DECLARE new_id INT(11); 
	SET Result = 1; 

	SELECT IFNULL(MAX(id_lista) + 1, 1) 
	INTO new_id
	FROM lista_prelievo 
	WHERE Anno = enter_year; 
	
	IF Result 
	THEN

		INSERT INTO lista_prelievo
		SET 
			Id_lista = new_id,
			Anno = enter_year,
			cliente = customer_id,
			id_destinazione = destination_id,
			Id_operaio = employee_id,
			rientro = is_return,
			causale = causal_id,
			Data = exec_date,
			Tipo_materiale = material_type,
			Nota = notes,
			colli = packages,
			id_principale = main_id,
			id_ddt = ddt_id,
			id_anno = ddt_year,
			id_utente = @USER_ID;

		SET Result = new_id; 
	END IF;  
			
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalLookDeleteByWithdrawal
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalLookDeleteByWithdrawal;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalLookDeleteByWithdrawal`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	DELETE FROM lista_aspetto
	WHERE Id_lista = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalLookGetByWithdrawal
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalLookGetByWithdrawal;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalLookGetByWithdrawal`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	SELECT 
		`id_lista`,
		`anno`,
		vista
	FROM lista_aspetto
	WHERE Id_lista = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalRowDeleteByWithdrawal
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalRowDeleteByWithdrawal;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalRowDeleteByWithdrawal`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	DELETE FROM lista_articoli
	WHERE Id_lista = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalRowGetByWithdrawal
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalRowGetByWithdrawal;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalRowGetByWithdrawal`( 
	enter_id INT, 
	enter_year INT
)
BEGIN
        
	SELECT 
		`id_articolo`,
		`id_lista`,
		`Desc_breve`,
		`anno`,
		`codice_fornitore`,
		`numero_tab`,
		`quantità`,
		`Unità_misura`,
		`Serial_number`,
		`non_consegnati`,
		`data_consegna`,
		`causale_scarico`, 
		foto_filename
	FROM lista_articoli
	WHERE Id_lista = enter_id AND Anno = enter_year; 
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesWithdrawalUpdate
DROP PROCEDURE IF EXISTS sp_ariesWithdrawalUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesWithdrawalUpdate`(
	enter_id INT(11),
	enter_year INT(11),
	customer_id INT(11),
	destination_id INT(11),
	employee_id INT(11),
	is_return BIT, 
	causal_id INT(11),
	exec_date DATE, 
	material_type INT(11), 
	notes TEXT, 
	packages INT(11), 
	main_id INT(11), 
	ddt_id INT(11), 
	ddt_year INT(11), 
	OUT result INTEGER
)
MainLabel:BEGIN
	SET Result = 1; 
	
	IF Result 
	THEN
		UPDATE lista_prelievo
		SET 
			cliente = customer_id,
			id_destinazione = destination_id,
			Id_operaio = employee_id,
			rientro = is_return,
			causale = causal_id,
			Data = exec_date,
			Tipo_materiale = material_type,
			Nota = notes,
			colli = packages,
			id_principale = main_id,
			id_ddt = ddt_id,
			id_anno = ddt_year

		WHERE Id_lista = enter_id AND Anno = enter_year; 
		
		SET Result = 1; 
			
	END IF;  
		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ddtAssociate
DROP PROCEDURE IF EXISTS sp_ddtAssociate;
DELIMITER //
CREATE  PROCEDURE `sp_ddtAssociate`(
	ddtId INT, ddtYear INT, docId INT, docYear INT, docType VARCHAR(20),
	OUT ddtAssociateResult INT
)
BEGIN

	DECLARE res TINYINT;
	DECLARE ddtStatusResult INT;

	IF docId < 0 OR docYear < 0 THEN
		SET docId = NULL;
		SET docYear = NULL;
	END IF;
	IF docType = 'INVOICE' THEN
		UPDATE ddt SET
			fattura = docId,
			anno_fattura = docYear
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
	END IF;

	IF docType = 'SUPPLIERINVOICE' THEN
		UPDATE ddt SET 
			fatturaf = docId,
			anno_fatturaf = docYear
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
	END IF;
	
	IF docType = 'RECEIVED_DDT' THEN
		IF NOT ISNULL(docId) THEN
			INSERT INTO ddt_ricevuti_emessi SET 
				id_r = docId, 
				anno_r = docYear, 
				anno_e = ddtYear, 
				id_e = ddtId, 
				tipo = "1";
		END IF;
	END IF;
	
	
	CALL sp_onDdtDeterminingStatus(ddtId, ddtYear, CONCAT('ASSOC ', docType), ddtStatusResult);
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ddtDissociate
DROP PROCEDURE IF EXISTS sp_ddtDissociate;
DELIMITER //
CREATE  PROCEDURE `sp_ddtDissociate`(
	ddtId INT, ddtYear INT, docId INT, docYear INT, docType VARCHAR(20),
	OUT ddtDissociateResult INT
)
BEGIN

	DECLARE ddtStatusResult INT;

	IF docId < 0 OR docYear < 0 THEN
		SET docId = NULL;
		SET docYear = NULL;
	END IF;

	IF docType = 'INVOICE' THEN
		UPDATE ddt SET
			fattura = NULL,
			anno_fattura = NULL
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
	END IF;

	IF docType = 'SUPPLIERINVOICE' THEN
		UPDATE ddt SET 
			fatturaf = NULL,
			anno_fatturaf = NULL
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
	END IF;
	
	IF docType = 'RECEIVED_DDT' THEN
		DELETE FROM ddt_ricevuti_emessi
		WHERE id_r = docId
			AND anno_r = docYear 
			AND anno_e = ddtYear 
			AND id_e = ddtId;
	END IF;

	CALL sp_onDdtDeterminingStatus(ddtId, ddtYear, CONCAT('DISSOC ', docType), ddtStatusResult);
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ddtGetPrintInformationsToBeBilled
DROP PROCEDURE IF EXISTS sp_ddtGetPrintInformationsToBeBilled;
DELIMITER //
CREATE  PROCEDURE `sp_ddtGetPrintInformationsToBeBilled`(
	ddtYear SMALLINT, OUT ddtsNumbers MEDIUMINT, OUT ddtsTotalPrice DECIMAL(11,2), OUT ddtsTotalCost DECIMAL(11,2))
BEGIN

	SELECT * 
	FROM
	(
		
		SELECT 
			ddt.id_ddt AS "DdtId", 
			data_documento AS "Date", 
			clienti.ragione_sociale AS "CompanyName",
			causale_trasporto.causale AS "CausalTransport", 
			IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  
			IFNULL(ddt.fattura, "") AS "InvoiceId",
			IFNULL(impianto.descrizione, "") AS "SystemDescription", 
			CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 
			CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost,
			IF(commessa_ddt.Id_commessa IS NOT NULL, "in_job", "open") AS "Status"
		FROM ddt
			LEFT JOIN causale_trasporto ON ddt.causale=id_causale
			INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
			LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
			LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
			LEFT JOIN impianto ON id_impianto=impianto
			LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
			LEFT JOIN commessa_ddt ON commessa_ddt.Id_ddt=ddt.id_ddt AND commessa_ddt.Anno_ddt=ddt.anno 
		WHERE ddt.Stato IN (1,2)  AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno)
		GROUP BY ddt.Id_ddt, ddt.anno
		
		UNION 
		
		
		SELECT
			ddt.id_ddt AS "DdtId", 
			data_documento AS "Date", 
			clienti.ragione_sociale AS "CompanyName",
			causale_trasporto.causale AS "CausalTransport", 
			IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  
			IFNULL(ddt.fattura, "") AS "InvoiceId",
			IFNULL(impianto.descrizione, "") AS "SystemDescription", 
			CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 
			CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost,
			"in_pre_invoice" AS "Status"
		FROM ddt
			LEFT JOIN causale_trasporto ON ddt.causale=id_causale
			INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
			LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione
			LEFT JOIN comune AS b1 ON b1.id_comune=b.comune
			LEFT JOIN impianto ON id_impianto=impianto
			LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
			INNER JOIN fattura ON fattura.Id_fattura = ddt.fattura AND fattura.anno = ddt.anno_fattura AND fattura.anno = 0
		WHERE ddt.anno = IF(ddtYear, ddtYear, ddt.anno) 
		GROUP BY ddt.Id_ddt, ddt.anno
	) AS a	
	ORDER BY YEAR(Date) DESC, DdtId;
	
	SELECT COUNT(ddt.id_ddt),
		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)), 
		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2))
		INTO 
		ddtsNumbers,
		ddtsTotalPrice,
		ddtsTotalCost
	FROM ddt
		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno
	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno);
			

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ddtInsert
DROP PROCEDURE IF EXISTS sp_ddtInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ddtInsert`(
	ddtId INT, ddtYear INT, ddtDate DATE, aspect SMALLINT, personId INT, isCustomer BOOL, 
	destinationId INT, paymentCondition INT, deliveryCare INT, deliveryCompany INT, 
	deliveryMethod INT, timestampStart TIMESTAMP, timestampEnd TIMESTAMP, causalId VARCHAR(10),
	amount INT, note TEXT, description TEXT, mainId INT, systemId INT, 
	weight DECIMAL(11,2), printHours BIT(1), printTimestampEnd BIT(1),
	recipient_signature_filename VARCHAR(50),
	driver_signature_filename VARCHAR(50),	
	OUT ddtInsertResult INT)
BEGIN
	
	DECLARE ddtStatusResult INT DEFAULT 0;
	SET ddtInsertResult = -1;
	
	IF IFNULL(ddtId, 0) <= 0 THEN
		SELECT IFNULL(MAX(id_ddt), 0) + 1
		INTO ddtId
		FROM ddt
		WHERE ddt.anno = ddtYear;
	END IF;
	
	IF (SELECT COUNT(*) FROM ddt WHERE id_ddt = ddtId AND anno = ddtYear) <= 0 THEN
	
		SET ddtYear = IFNULL(ddtYear, YEAR(CURRENT_DATE));
		SET timestampStart = IFNULL(timestampStart, CURRENT_TIMESTAMP);
		SET ddtDate = IFNULL(ddtDate, CURRENT_DATE);
		SET amount = IFNULL(amount, 0);
		
		INSERT INTO ddt SET
			id_utente = @USER_ID,
			id_ddt = ddtId,
			anno = ddtYear,
			condizione_pagamento = paymentCondition,
			trasport_a_cura = deliveryCare,
			vettore = deliveryCompany,
			data_ora_ritiro = timestampEnd,
			data_ora_inizio = timestampStart,
			porto_resa = deliveryMethod,
			data_documento = ddtDate,
			causale = causalId,
			colli = amount,
			nota = note,
			descrizione = description,
			impianto = systemId,
			peso = weight,
			stampa_ora = printHours,
			stato = 1, -- set as open by default
			stampa_data_ora_ritiro = printTimestampEnd,
			filename_firma_conducente = driver_signature_filename,
			filename_firma_destinatario = recipient_signature_filename;
			
		IF isCustomer THEN
			UPDATE ddt SET 
				id_cliente = personId,
				id_destinazione = destinationId,
				id_principale = mainId
			WHERE id_ddt = ddtId
				AND anno = ddtYear;
		ELSE
			UPDATE ddt SET
				id_fornitore = personId,
				principale_forn = mainId , 
				destinazione_forn = destinationId
			WHERE id_ddt = ddtId
				AND anno = ddtYear;
		END IF;
		
		-- Inserimento aspetto merce 
		
		IF aspect & 1 THEN -- Alla Rinfusa [1]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "ar");
		END IF;
		IF aspect & 2 THEN -- A Vista [2]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "av");
		END IF;
		IF aspect & 4 THEN -- Matasse [4]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "ma");
		END IF;
		IF aspect & 8 THEN -- Scatole [8]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "sc");
		END IF;
		IF aspect & 16 THEN -- Sacco [16]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "sn");
		END IF;
		IF aspect & 32 THEN -- Busta [32]
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "bu");
		END IF;
		
		-- Returning Result
		SET ddtInsertResult = ddtId;
	
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ddtUpdate
DROP PROCEDURE IF EXISTS sp_ddtUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ddtUpdate`(
	newDdtId INT, newDdtYear INT, oldDdtId INT, oldDdtYear INT,ddtDate DATE, aspect SMALLINT, personId INT, isCustomer BOOL, 
	destinationId INT, paymentCondition INT, deliveryCare INT, deliveryCompany INT, 
	deliveryMethod INT, timestampStart TIMESTAMP, timestampEnd TIMESTAMP, causalId VARCHAR(10),
	amount INT, note TEXT, description TEXT, mainId INT, systemId INT, 
	weight DECIMAL(11,2), printHours BIT(1), IN printTimestampEnd BIT(1), OUT ddtUpdateResult INT)
BEGIN
	
	DECLARE ddtStatusResult INT DEFAULT 0;
	SET ddtUpdateResult = -1;
	
	SET newDdtYear = IFNULL(newDdtYear, YEAR(CURRENT_DATE));
	SET timestampStart = IFNULL(timestampStart, CURRENT_TIMESTAMP);
	SET ddtDate = IFNULL(ddtDate, CURRENT_DATE);
	SET amount = IFNULL(amount, 0);
	
	UPDATE ddt SET
		id_ddt = newDdtId,
		anno = newDdtYear,
		id_cliente = NULL,
		id_destinazione = NULL,
		id_principale = NULL,
		id_fornitore = NULL,
		principale_forn = NULL, 
		destinazione_forn = NULL, 
		condizione_pagamento = paymentCondition,
		trasport_a_cura = deliveryCare,
		vettore = deliveryCompany,
		data_ora_ritiro = timestampEnd,
		data_ora_inizio = timestampStart,
		porto_resa = deliveryMethod,
		data_documento = ddtDate,
		causale = causalId,
		colli = amount,
		nota = note,
		descrizione = description,
		impianto = systemId,
		peso = weight,
		stampa_ora = printHours,
		stampa_data_ora_ritiro = printTimestampEnd
	WHERE id_ddt = oldDdtId 
		AND anno = oldDdtYear;
		
	IF ROW_COUNT() > 0 THEN
		SET ddtUpdateResult = newDdtId;
	END IF;

	IF isCustomer THEN
		UPDATE ddt SET 
			id_cliente = personId,
			id_destinazione = destinationId,
			id_principale = mainId
		WHERE id_ddt = newDdtId
			AND anno = newDdtYear;
	ELSE
		UPDATE ddt SET
			id_fornitore = personId,
				principale_forn = mainId , 
				destinazione_forn = destinationId
		WHERE id_ddt = newDdtId
			AND anno = newDdtYear;
	END IF;
	
	-- Insert Product Aspect
	
	DELETE FROM ddt_aspetto 
	WHERE id_ddt = oldDdtId
		AND anno = oldDdtYear;
	
	IF aspect & 1 THEN -- Alla Rinfusa [1]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "ar");
	END IF;
	IF aspect & 2 THEN -- A Vista [2]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "av");
	END IF;
	IF aspect & 4 THEN -- Matasse [4]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "ma");
	END IF;
	IF aspect & 8 THEN -- Scatole [8]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "sc");
	END IF;
	IF aspect & 16 THEN -- Sacco [16]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "sn");
	END IF;
	IF aspect & 32 THEN -- Busta [32]
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(newDdtId, newDdtYear, "bu");
	END IF;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_getDdtProductsRemaining
DROP PROCEDURE IF EXISTS sp_getDdtProductsRemaining;
DELIMITER //
CREATE  PROCEDURE `sp_getDdtProductsRemaining`(
	ddtId INT, ddtYear INT)
BEGIN

	
	DROP TEMPORARY TABLE IF EXISTS tmpTblDdtProductsRiceived;
	CREATE TEMPORARY TABLE tmpTblDdtProductsRiceived (
			product_id VARCHAR(11) NOT NULL PRIMARY KEY,
			quantity DECIMAL(11,2)
	) ENGINE = innoDB;

	INSERT INTO tmpTblDdtProductsRiceived 
	SELECT Id_articolo AS product_id, SUM(Quantita) AS quantity
	FROM (
			SELECT ff.id_materiale AS Id_articolo, ff.`quantità` AS Quantita
			FROM articoli_ddt de
				INNER JOIN fornfattura_articoli ff 
					ON de.id_ddt = ff.id_rif
					AND de.anno = ff.anno_rif
					AND de.Id_articolo = ff.id_materiale
					AND ff.tipo = '+'
			WHERE de.id_ddt = ddtId
			AND de.anno = ddtYear
			UNION ALL 
			SELECT dr.id_articolo, dr.`quantità`
			FROM articoli_ddt de
				INNER JOIN articoli_ddt_ricevuti dr 
					ON de.id_ddt = dr.id_rif
					AND de.anno = dr.anno_rif
					AND de.Id_articolo = dr.id_articolo
					AND dr.tipo = '+'
			WHERE de.id_ddt = ddtId
			AND de.anno = ddtYear
			) AS DdtProductsRiceived
	GROUP BY Id_articolo;

	SELECT id_articolo, desc_breve, codice_fornitore, serial_number, if(quantity IS NULL, quantità, quantità-quantity) as quantità ,unità_misura, prezzo, costo, id_Ddt, anno, idnota, 
	causale_scarico,sconto
	FROM articoli_ddt de
		LEFT JOIN tmpTblDdtProductsRiceived 
			ON de.Id_articolo = tmpTblDdtProductsRiceived.product_id
	WHERE de.id_ddt = ddtId
	AND de.anno = ddtYear
	AND (tmpTblDdtProductsRiceived.product_id IS NULL
	OR de.`quantità`>tmpTblDdtProductsRiceived.quantity)
	ORDER BY numero_tab;

		
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_getInvoicePeriodicTotals
DROP PROCEDURE IF EXISTS sp_getInvoicePeriodicTotals;
DELIMITER //
CREATE  PROCEDURE `sp_getInvoicePeriodicTotals`(IN `AnnoFatture` INT, IN `MeseFatture` INT, OUT `FatturaPrezzoNetto` DECIMAL(11,2), OUT `FatturaPrezzoLordo` DECIMAL(11,2), OUT `FatturaPrezzoIva` DECIMAL(11,2), OUT `FatturaCosto` DECIMAL(11,2), OUT `PrefatturaPrezzoLordo` DECIMAL(11,2), OUT `PrefatturaCosto` DECIMAL(11,2), OUT `TotalePrezzoLordo` DECIMAL(11,2), OUT `TotaleCosto` DECIMAL(11,2)
)
BEGIN

	SELECT
		SUM(importo_imponibile), 
		SUM(costo_totale), 
		SUM(importo_iva), 
		SUM(importo_totale)
	INTO
		FatturaPrezzoNetto,
		FatturaCosto,
		FatturaPrezzoIva,
		FatturaPrezzoLordo
	FROM fattura f 
	WHERE f.anno = AnnoFatture
		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);
		
	SELECT SUM(costo_totale), 
		SUM(importo_totale)
	INTO
		PrefatturaCosto,
		PrefatturaPrezzoLordo
	FROM fattura f
	WHERE f.anno = 0
		AND YEAR(f.data) = AnnoFatture
		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);
		
		
	SET FatturaPrezzoNetto = IFNULL(FatturaPrezzoNetto, 0);
	SET FatturaPrezzoLordo = IFNULL(FatturaPrezzoLordo, 0);
	SET FatturaPrezzoIva = IFNULL(FatturaPrezzoIva, 0);
	SET FatturaCosto = IFNULL(FatturaCosto, 0);
	
	SET PrefatturaPrezzoLordo = IFNULL(PrefatturaPrezzoLordo, 0);
	SET PrefatturaCosto = IFNULL(PrefatturaCosto, 0);

	SET TotalePrezzoLordo = FatturaPrezzoLordo + PrefatturaPrezzoLordo;
	SET TotaleCosto = FatturaCosto + PrefatturaCosto;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_getJobTotals
DROP PROCEDURE IF EXISTS sp_getJobTotals;
DELIMITER //
CREATE  PROCEDURE `sp_getJobTotals`(
	IN `id_job` INT,
	IN `year_job` INT,
	IN `sub_job_id` INT,
	IN `id_lot` INT,
	OUT `total_cost_quote` Decimal(11,2),
	OUT `total_price_quote` Decimal(11,2),
	OUT `total_cost` Decimal(11,2),
	OUT `total_hours_worked_economy` Decimal(11,2),
	OUT `total_hours_worked` Decimal(11,2),
	OUT `Total_hours_quote` Decimal(11,2),
	OUT `total_hours_travel` Decimal(11,2),
	OUT `Total_hours` Decimal(11,2),
	OUT `total_cost_quote_body_products` Decimal(11,2),
	OUT `total_price_quote_body_products` Decimal(11,2),
	OUT `total_cost_body_products_economy` Decimal(11,2),
	OUT `total_cost_worked_economy` Decimal(11,2),
	OUT `total_cost_body_products` Decimal(11,2),
	OUT `total_cost_worked` Decimal(11,2),
	OUT `total_km` Decimal(11,2),
	OUT `total_cost_hours_travel` Decimal(11,2),
	OUT `total_cost_km` Decimal(11,2),
	OUT `total_cost_transfert` Decimal(11,2),
	OUT `total_cost_extra` Decimal(11,2),
	OUT `total_cost_parking` Decimal(11.2),
	OUT `total_cost_speedway` Decimal(11,2),
	OUT `total_price_body_products` Decimal(11,2),
	OUT `total_price_worked` Decimal(11,2),
	OUT `total_price_hours_travel` Decimal(11,2),
	OUT `total_price_km` Decimal(11,2),
	OUT `total_price_transfert` Decimal(11,2),
	OUT `total_price_extra` Decimal(11,2),
	OUT `total_price_parking` Decimal(11.2),
	OUT `total_price_speedway` Decimal(11,2),
	OUT `total_price_body_products_economy` Decimal(11,2),
	OUT `total_price_worked_economy` Decimal(11,2),
	OUT `total_price` Decimal(11,2),
	OUT `total_cost_quote_worked` Decimal(11,2),
	OUT `total_price_quote_worked` Decimal(11,2)
)
BEGIN

	SELECT 
		SUM(CAST((jb.costo * jb.Qta_economia) AS DECIMAL(11,2))),
		SUM(CAST((jb.costo * jb.Qta_utilizzata) AS DECIMAL(11,2))),
		SUM(CAST((jb.prezzo * jb.Qta_economia)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
		SUM(CAST((jb.prezzo * jb.Qta_utilizzata)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2)))
	INTO 
		total_cost_body_products_economy,
		total_cost_body_products,
		total_price_body_products_economy,
		total_price_body_products
		
	FROM vw_jobbody jb
	WHERE jb.id_commessa = id_job
		AND jb.anno = year_job
		AND IF(sub_job_id > 0, jb.id_sottocommessa = sub_job_id, TRUE)
		AND IF(id_lot > 0, jb.lotto = id_lot, TRUE);

	
	SELECT 
		SUM(preventivo_totale_ore),
		SUM(preventivo_costo_materiale) + SUM(preventivo_costo_lavoro),
		SUM(preventivo_costo_materiale),
		SUM(preventivo_costo_lavoro),
		SUM(preventivo_prezzo_materiale) + SUM(preventivo_prezzo_lavoro),
		SUM(preventivo_prezzo_materiale),
		SUM(preventivo_prezzo_lavoro)
	INTO 
		total_hours_quote,
		total_cost_quote,
		total_cost_quote_body_products,
		total_cost_quote_worked,
		total_price_quote,
		total_price_quote_body_products,
		total_price_quote_worked
	FROM commessa_preventivo cp
	WHERE cp.id_commessa = id_job
		AND cp.anno = year_job
		AND IF(sub_job_id > 0, cp.id_sottocommessa = sub_job_id, TRUE)
		AND IF(id_lot > 0, cp.lotto = id_lot, TRUE);

	SELECT 
		CAST(IF(SUM(twi.totale_ore_lavorate) IS NULL, 0 , SUM(twi.totale_ore_lavorate))AS DECIMAL(11,2)),
		CAST(IF(SUM(twi.totale_costo_lavoro) IS NULL, 0 , SUM(twi.totale_costo_lavoro))AS DECIMAL(11,2)),
	    CAST(IF(SUM(twi.totale_prezzo_lavoro) IS NULL, 0 , SUM(twi.totale_prezzo_lavoro))AS DECIMAL(11,2))
	INTO
		total_hours_worked,
		Total_cost_worked,
		Total_price_worked
	FROM vw_jobtotalworkinterventions twi 
	WHERE twi.Economia = 0 
		AND twi.id_commessa = id_job
		AND twi.anno_commessa = year_job
		AND IF(sub_job_id > 0, twi.id_sottocommessa = sub_job_id, TRUE)
		AND IF(id_lot > 0, twi.id_lotto = id_lot, TRUE);
		
	SELECT 
		CAST(if(SUM(twi.totale_ore_lavorate) IS NULL, 0,SUM(twi.totale_ore_lavorate))  AS DECIMAL(11,2)),
		CAST(if(SUM(twi.totale_costo_lavoro) IS NULL, 0,SUM(twi.totale_costo_lavoro)) AS DECIMAL(11,2)), 
		CAST(if(SUM(twi.totale_prezzo_lavoro) IS NULL,0, SUM(twi.totale_prezzo_lavoro)) AS DECIMAL(11,2)) 
	INTO 
		total_hours_worked_economy,
		total_cost_worked_economy,
		total_price_worked_economy
	FROM vw_jobtotalworkinterventions twi 
	WHERE twi.Economia = 1
		AND twi.id_commessa = id_job
		AND twi.anno_commessa = year_job
		AND IF(sub_job_id > 0, twi.id_sottocommessa = sub_job_id, TRUE)
		AND IF(id_lot > 0, twi.id_lotto = id_lot, TRUE);
	
	SELECT 
		CAST(IF(SUM(tti.Totale_tempo_viaggio) IS NULL, 0, SUM(tti.Totale_tempo_viaggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_KM) IS NULL, 0,SUM(tti.Totale_KM)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_costo_KM) IS NULL, 0,SUM(tti.Totale_costo_KM)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_costo_tempo_viaggio) IS NULL, 0, SUM(tti.Totale_costo_tempo_viaggio))AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_spese_trasferta) IS NULL, 0, SUM(tti.Totale_spese_trasferta)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_autostrada) IS NULL, 0,SUM(tti.Totale_autostrada)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_parcheggio) IS NULL, 0, SUM(tti.Totale_parcheggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_altro) IS NULL, 0,SUM(tti.Totale_altro)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_prezzo_tempo_viaggio) IS NULL, 0,SUM(tti.Totale_prezzo_tempo_viaggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_prezzo_KM) IS NULL, 0, SUM(tti.Totale_prezzo_KM)) AS DECIMAL(11,2))
	INTO 
		total_hours_travel,
		total_km,
		total_cost_km,
		total_cost_hours_travel,
		total_cost_transfert,
		total_cost_speedway,
		total_cost_parking,
		total_cost_extra,
		total_price_km,
		total_price_hours_travel
	FROM vw_jobtotaltravelinterventions tti
	WHERE tti.id_commessa = id_job
		AND tti.anno_commessa = year_job
		AND IF(sub_job_id > 0, tti.id_sottocommessa = sub_job_id, TRUE)
		AND IF(id_lot > 0, tti.id_lotto = id_lot, TRUE);
		
	SET total_price_parking = total_cost_parking;
	SET total_price_extra = total_cost_extra;	
	SET total_price_speedway = total_cost_speedway;
	SET total_price_transfert = total_cost_transfert;
		
	SET total_price_quote = IFNULL(total_price_quote, 0); 
	SET total_cost_quote = IFNULL(total_cost_quote, 0); 
	SET total_cost = IFNULL(total_cost, 0); 
	SET total_hours_worked_economy = IFNULL(total_hours_worked_economy, 0); 
	SET total_hours_worked = IFNULL(total_hours_worked, 0); 
	SET Total_hours_quote = IFNULL(Total_hours_quote, 0); 
	SET total_hours_travel = IFNULL(total_hours_travel, 0); 
	SET total_price_quote_body_products = IFNULL(total_price_quote_body_products, 0); 
	SET total_cost_body_products_economy = IFNULL(total_cost_body_products_economy, 0); 
	SET total_cost_worked_economy = IFNULL(total_cost_worked_economy, 0); 
	SET total_cost_body_products = IFNULL(total_cost_body_products, 0); 
	SET total_cost_worked = IFNULL(total_cost_worked, 0); 
	SET total_km = IFNULL(total_km, 0); 
	SET total_cost_hours_travel = IFNULL(total_cost_hours_travel, 0); 
	SET total_cost_km = IFNULL(total_cost_km, 0); 
	SET total_cost_transfert = IFNULL(total_cost_transfert, 0); 
	SET total_cost_extra = IFNULL(total_cost_extra, 0); 
	SET total_cost_parking  = IFNULL(total_cost_parking , 0); 
	SET total_cost_speedway = IFNULL(total_cost_speedway, 0); 
	SET total_cost_quote_body_products = IFNULL(total_cost_quote_body_products, 0); 
	SET total_cost_quote_worked = IFNULL(total_cost_quote_worked, 0); 
	SET total_price_body_products = IFNULL(total_price_body_products, 0); 
	SET total_price_worked = IFNULL(total_price_worked, 0); 
	SET total_price_hours_travel = IFNULL(total_price_hours_travel, 0); 
	SET total_price_km = IFNULL(total_price_km, 0); 
	SET total_price_transfert = IFNULL(total_price_transfert, 0); 
	SET total_price_extra = IFNULL(total_price_extra, 0); 
	SET total_price_parking  = IFNULL(total_price_parking , 0); 
	SET total_price_speedway = IFNULL(total_price_speedway, 0); 
	SET total_price_body_products_economy = IFNULL(total_price_body_products_economy, 0); 
	SET total_price_worked_economy = IFNULL(total_price_worked_economy, 0); 
	SET total_price = IFNULL(total_price, 0);	
	SET total_price_quote_worked = IFNULL(total_price_quote_worked, 0);
		
		
	SET total_cost = total_cost_body_products_economy
				+ total_cost_worked_economy
				+ total_cost_body_products
				+ total_cost_worked
				+ total_cost_hours_travel
				+ total_cost_km
				+ total_cost_transfert
				+ total_cost_extra
				+ total_cost_parking
				+ total_cost_speedway ;
			
	SET total_price = total_price_body_products_economy
				+ total_price_worked_economy
				+ total_price_body_products
				+ total_price_worked
				+ total_price_hours_travel
				+ total_price_km
				+ total_cost_transfert
				+ total_cost_extra
				+ total_cost_parking
				+ total_cost_speedway ;
				
							
	SET total_hours = total_hours_travel
				+ total_hours_worked
				+ total_hours_worked_economy;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_getQuoteTotals
DROP PROCEDURE IF EXISTS sp_getQuoteTotals;
DELIMITER //
CREATE  PROCEDURE `sp_getQuoteTotals`(IN `quote_id` INT, IN `quote_year` INT, IN `quote_revision_id` INT, IN `quote_lot_id` INT,  OUT `total_price_material` DECIMAL(11,2), OUT `total_cost_material` DECIMAL(11,2), OUT `total_profit_material` DECIMAL(11, 2), OUT `total_price_work` DECIMAL(11, 2), OUT `total_cost_work` DECIMAL(11, 2), OUT `total_profit_work` DECIMAL(11, 2), OUT `total_hours` DECIMAL(11, 2), OUT `total_price` DECIMAL(11, 2), OUT `total_cost` DECIMAL(11, 2), OUT `total_profit` DECIMAL(11, 2), OUT `total_sale` DECIMAL(11, 2)
)
BEGIN

	SELECT SUM(CAST(ROUND(prezzo * (100 - IF(preventivo_lotto.tipo_ricar = 1, 0, sconto)) / 100, 2) * (100 - IFNULL(NULLIF(scontoriga, ""), 0)) / 100 AS DECIMAL(11, 2)) * quantità)
		INTO total_price_material
	FROM articolo_preventivo 
		LEFT JOIN preventivo_lotto ON preventivo_lotto.id_preventivo = articolo_preventivo.id_preventivo 
			AND preventivo_lotto.anno = articolo_preventivo.anno 
			AND preventivo_lotto.id_revisione = articolo_preventivo.id_revisione 
			AND articolo_preventivo.lotto = preventivo_lotto.posizione 
	WHERE articolo_preventivo.id_preventivo = quote_id
		AND articolo_preventivo.anno = quote_year
		AND articolo_preventivo.id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, articolo_preventivo.lotto) = articolo_preventivo.lotto;

	SELECT SUM(costo * quantità)
		INTO total_cost_material
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, articolo_preventivo.lotto) = articolo_preventivo.lotto;

	SELECT SUM(CAST((IF(montato = "0", 0, ap.tempo_installazione / 60 * prezzo_h * (100 - scontolav) / 100) * ((100 - IFNULL(scontoriga, 0)) / 100)) AS DECIMAL(11, 2)) * quantità)
		INTO total_price_work
	FROM articolo_preventivo ap
		LEFT JOIN preventivo_lotto pl ON pl.id_preventivo = ap.id_preventivo
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND ap.lotto = pl.posizione 
	WHERE ap.id_preventivo = quote_id
		AND ap.anno = quote_year
		AND ap.id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, ap.lotto) = ap.lotto;

	SELECT SUM(IF(montato = "0", 0, quantità * (tempo_installazione / 60 * costo_h)))
		INTO total_cost_work
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, articolo_preventivo.lotto) = articolo_preventivo.lotto;

	SELECT SUM(IF(montato = "0", 0, quantità) * tempo_installazione / 60)
		INTO total_hours
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, articolo_preventivo.lotto) = articolo_preventivo.lotto;

	SELECT SUM(((ROUND(ROUND((prezzo-(sconto/100*prezzo)),2)*scontoriga/100,2)*quantità)+((IF(montato="0",0,quantità*((tempo_installazione/60*prezzo_h) - ((tempo_installazione/60*prezzo_h)*scontolav/100)))))*scontoriga/100))
		INTO total_sale
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id
		AND IF (quote_lot_id IS NOT NULL AND quote_lot_id >= 0, quote_lot_id, articolo_preventivo.lotto) = articolo_preventivo.lotto;
	
	SET total_price_material = IFNULL(total_price_material, 0);
	SET total_cost_material = IFNULL(total_cost_material, 0);
	SET total_price_work = IFNULL(total_price_work, 0);
	SET total_cost_work = IFNULL(total_cost_work, 0);
	SET total_sale = IFNULL(total_sale, 0);
	SET total_hours = IFNULL(total_hours, 0);
	SET total_cost = IFNULL(total_cost_material, 0) + IFNULL(total_cost_work, 0);
	SET total_price = IFNULL(total_price_material, 0) + IFNULL(total_price_work, 0);
	SET total_profit_material = IFNULL(total_price_material, 0) - IFNULL(total_cost_material, 0);
	SET total_profit_work = IFNULL(total_price_work, 0) - IFNULL(total_cost_work, 0);
	SET total_profit = total_profit_material + total_profit_work;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_onDdtDeterminingStatus
DROP PROCEDURE IF EXISTS sp_onDdtDeterminingStatus;
DELIMITER //
CREATE  PROCEDURE `sp_onDdtDeterminingStatus`(
	ddtId INT, ddtYear INT, source VARCHAR(20), OUT status INT)
BEGIN

	DECLARE DDT_STATUS_OPEN INT DEFAULT 1; 
	DECLARE DDT_STATUS_PARTIAL INT DEFAULT 2;
	DECLARE DDT_STATUS_CLOSED INT DEFAULT 3;
	DECLARE DDT_STATUS_IN_JOB INT DEFAULT 4; 
	DECLARE res INT;

	
	SET status = NULL;
	

	IF source = 'INSERT' THEN
		SET status = DDT_STATUS_OPEN;
	END IF;
	
	IF source = 'UPDATE' THEN 
	
		SELECT id_cliente IS NOT NULL 
		INTO res
		FROM ddt
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
			
		if res THEN
		
			SELECT DDT_STATUS_CLOSED
			INTO status
			FROM DDT 
			WHERE id_ddt = ddtId
				AND anno = ddtYear 
				AND Fattura IS NOT NULL;
			
		END IF; 
		
	END IF; 
	

	
	-- When associating with an Invoice or a Supplier Invoice, CLOSE
	-- When dissociating from them, re-OPEN it
	IF source LIKE '%INVOICE' AND NOT source LIKE '%SUPPLIER%' THEN
		IF source LIKE 'ASSOC%' THEN
			SET status = DDT_STATUS_CLOSED;
		ELSEIF source LIKE 'DISSOC%' THEN
			SET status = DDT_STATUS_OPEN;
		END IF;
	END IF;
	
	
	IF source LIKE '%JOB' THEN
		IF source LIKE 'ASSOC%' THEN
			SET status = DDT_STATUS_IN_JOB;
		ELSEIF source LIKE 'DISSOC%' THEN
			SET status = DDT_STATUS_OPEN;
		END IF;
	END IF;

	
	-- If "Autoconvalidazione" is checked, automatically CLOSE
	SELECT (causale_trasporto.garanzia = 2)
	INTO res
	FROM ddt
		LEFT JOIN causale_trasporto ON causale_trasporto.Id_causale = ddt.Causale
	WHERE ddt.id_ddt = ddtId
		AND ddt.anno = ddtYear;
	
	IF res THEN
		SET status = DDT_STATUS_CLOSED;
	END IF;

	-- If the document is opened to a supplier
	-- If there is also a received document, and some products are given back
	-- set it as PARTIAL, if nothing has been given back, set it as OPEN, if everything has been given back set CLOSE
	
	SELECT id_fornitore IS NOT NULL 
	INTO res
	FROM ddt
	WHERE id_ddt = ddtId
		AND anno = ddtYear;
	
	IF res THEN -- The document refers a supplier

		DROP TABLE IF EXISTS tmp_ddt_det_status;
		CREATE TEMPORARY TABLE tmp_ddt_det_status
		(
			id_articolo VARCHAR(11) PRIMARY KEY, 
			ddt_quantity DECIMAL(11,2), 
			supplier_quantity DECIMAL(11,2)
		);  
				
		INSERT INTO tmp_ddt_det_status	
		SELECT  de.Id_articolo, 
		  de.quantità, 
		  SUM(IFNULL(dr.quantità, 0))
		-- INTO res
		FROM articoli_ddt de
			LEFT JOIN articoli_ddt_ricevuti dr 
				ON de.id_ddt = dr.id_rif
				AND de.anno = dr.anno_rif
				AND de.Id_articolo = dr.id_articolo
				AND dr.tipo = '+'
		WHERE de.id_articolo IS NOT NULL
			AND de.id_ddt = ddtId
			AND de.anno = ddtYear
		GROUP BY de.Id_articolo;
		
		
		INSERT INTO tmp_ddt_det_status
		SELECT de.Id_articolo, 
		  de.quantità, 
		  SUM(IFNULL(ff.quantità, 0)) as "ff_sum"
		FROM articoli_ddt de
			LEFT JOIN fornfattura_articoli ff 
				ON de.id_ddt = ff.id_rif
				AND de.anno = ff.anno_rif
				AND de.Id_articolo = ff.id_materiale
				AND ff.tipo = '+'
		WHERE de.id_articolo IS NOT NULL
			AND de.id_ddt = ddtId
			AND de.anno = ddtYear
		GROUP BY de.Id_articolo
		ON DUPLICATE KEY UPDATE 
			supplier_quantity=supplier_quantity + VALUES(supplier_quantity);
			
				
		SELECT COUNT(*) 
		INTO res
		FROM tmp_ddt_det_status
		WHERE supplier_quantity<ddt_quantity; 
		
		
		IF IFNULL(res , 0) = 0  THEN 
		
			SET status = DDT_STATUS_CLOSED; 
	
		ELSE 
			SELECT 
			IF(COUNT(*) = 0, 
				DDT_STATUS_OPEN,  -- I have received all the products, CLOSE document
				DDT_STATUS_PARTIAL  -- I haven't received all the products, set it PARTIAL
			) 
			INTO status 
			FROM tmp_ddt_det_status
			WHERE supplier_quantity != 0; 
		END IF;
	END IF;
	
	IF status IS NOT NULL THEN
		UPDATE ddt	
			SET stato = status
		WHERE id_ddt = ddtId
			AND anno = ddtYear;
	END IF;
	
END//
DELIMITER ;


DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesReportGroupSearch;
CREATE  PROCEDURE `sp_ariesReportGroupSearch`(
	product_txt VARCHAR(200), 
	customer_name VARCHAR(200), 
	doc_id INT(11), 
	doc_year INT(11), 
	customer_id INT(11), 
	description TEXT,
	notes TEXT, 
	status INT(11), 
	doc_date DATETIME, 
	doc_type INT(11),
	final_note TEXT
)
BEGIN
	DECLARE has_product BIT; 
	SET has_product = product_txt <> '' AND product_txt IS NOT NULL; 	

	DROP TABLE IF EXISTS tmp_resoconto_con_articoli;
	
	CREATE TEMPORARY TABLE tmp_resoconto_con_articoli (
		id_resoconto INT(11),
		anno_reso INT(11)
	);
	
	IF has_product THEN
		INSERT INTO tmp_resoconto_con_articoli 
		SELECT DISTINCT id_resoconto, 
			anno_reso
		FROM resoconto_rapporto
			INNER JOIN rapporto_materiale 
			ON resoconto_rapporto.id_rapporto = rapporto_materiale.Id_rapporto 
				AND resoconto_rapporto.anno = rapporto_materiale.anno
			LEFT JOIN articolo 
				ON articolo.Codice_articolo = rapporto_materiale.Id_materiale
		WHERE rapporto_materiale.Id_materiale LIKE CONCAT('%', product_txt, '%')
			OR rapporto_materiale.descrizione LIKE CONCAT('%', product_txt, '%')
			OR articolo.Codice_fornitore LIKE CONCAT('%', product_txt, '%');
	ELSE
		INSERT INTO tmp_resoconto_con_articoli 
		SELECT id_resoconto, 
			anno
		FROM resoconto;
	END IF; 
	
	SELECT resoconto.id_resoconto AS "ID", 
		data, 
		resoconto.descrizione, 
		clienti.ragione_sociale AS "Cliente", 
		nota, tipo_resoconto, 
		tipo_resoconto.nome AS "tipo", 
		stato AS "Stato", 
		resoconto.anno, anno_fattura, 
		Inviato, 
		nota_fine,
		stm AS "Stampato",
		colore,
		fat_speseRap,
		resoconto_totali.costo_totale,
		resoconto_totali.prezzo_totale
	FROM resoconto 
		INNER JOIN tipo_resoconto ON id_tipo = resoconto.tipo_resoconto 
		INNER JOIN clienti ON resoconto.id_cliente=clienti.id_cliente 
		INNER JOIN stato_resoconto ON stato_resoconto.id_stato = resoconto.stato
		INNER JOIN resoconto_totali
			ON resoconto_totali.id_resoconto = resoconto.id_resoconto 
				AND resoconto_totali.anno = resoconto.anno
		INNER JOIN tmp_resoconto_con_articoli 
			ON tmp_resoconto_con_articoli.id_resoconto = resoconto.id_resoconto 
				AND tmp_resoconto_con_articoli.anno_reso = resoconto.anno
	WHERE
		clienti.ragione_sociale LIKE CONCAT('%', IFNULL(customer_name, ''), '%')
		AND IF(doc_id IS NULL, true, resoconto.id_resoconto) = IFNULL(doc_id, true) 
		AND IF(doc_year IS NULL, true, resoconto.anno) = IFNULL(doc_year, true) 
		AND IF(customer_id IS NULL, true, resoconto.id_cliente) = IFNULL(customer_id, true) 
		AND resoconto.descrizione LIKE CONCAT('%', IFNULL(description, ''), '%')
		AND resoconto.nota LIKE CONCAT('%', IFNULL(notes, ''), '%') 
		AND IF(status IS NULL, true, resoconto.stato) = IFNULL(status, true) 
		AND IF(doc_date IS NULL, true, resoconto.data) = IFNULL(doc_date, true) 
		AND IF(doc_type IS NULL, true, resoconto.tipo_resoconto) = IFNULL(doc_type, true) 
		AND (resoconto.nota_fine LIKE CONCAT('%', IFNULL(final_note, ''), '%') OR final_note IS NULL)
	ORDER BY anno desc,id Desc;
END//
DELIMITER ;




DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesReportGroupConfigsGet;
CREATE  PROCEDURE `sp_ariesReportGroupConfigsGet`()
BEGIN
	SELECT
		id,
		abbonamento,
		impianto,
		ticket,
		titolo,
		testo,
		ordine,
		lavorazione,
		mail,
		spese,
		stampa_desc_estesa
	FROM configurazione_resoconto
	ORDER BY id Desc
	LIMIT 1;
END//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesReportGroupConfigsInsert;
CREATE  PROCEDURE `sp_ariesReportGroupConfigsInsert`(
	subscription INT(11), 
	system INT(11), 
	ticket INT(11), 
	title TEXT,
	end_text TEXT, 
	order_text TEXT, 
	email_text TEXT,
	manufacture  INT(11), 
	expenses TINYINT(11), 
	print_desc_ext BIT(1), 
	out result INT(11)
)
BEGIN
	INSERT INTO configurazione_resoconto
	SET 
		abbonamento = subscription,
		impianto = system,
		ticket = ticket,
		titolo = title,
		testo = end_text,
		ordine = order_text,
		lavorazione = manufacture,
		mail = email_text,
		spese = expenses,
		stampa_desc_estesa = print_desc_ext;
	
	SET Result = LAST_INSERT_ID(); 
END//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_ariesReportGroupConfigsUpdate;
CREATE  PROCEDURE `sp_ariesReportGroupConfigsUpdate`(
	enter_id INT(11),
	subscription INT(11), 
	system INT(11), 
	ticket INT(11), 
	title TEXT,
	end_text TEXT, 
	order_text TEXT, 
	email_text TEXT,
	manufacture INT(11), 
	expenses TINYINT(11), 
	print_desc_ext BIT(1), 
	out result INT(11)
)
BEGIN
	UPDATE configurazione_resoconto
	SET 
		abbonamento = subscription,
		impianto = system,
		ticket = ticket,
		titolo = title,
		testo = end_text,
		ordine = order_text,
		lavorazione = manufacture,
		mail = email_text,
		spese = expenses,
		stampa_desc_estesa = print_desc_ext
	WHERE Id = enter_id;
	
	SET Result = 1; 
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesVatTypeGetDefault;
DELIMITER //
CREATE  PROCEDURE `sp_ariesVatTypeGetDefault`(
)
BEGIN

	SELECT
		`Id_iva`,
		`Nome`,
		`Descrizione`,
		`aliquota`,
		`MESSAGGIO`,
		`normale`,
		`esigibilita`,
		`in_uso`
	FROM tipo_iva
	WHERE normale = 1;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesVatTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesVatTypeGetById`(
	vat_id INT(11)
)
BEGIN

	SELECT
		`Id_iva`,
		`Nome`,
		`Descrizione`,
		`aliquota`,
		`MESSAGGIO`,
		`normale`,
		`esigibilita`,
		`in_uso`
	FROM tipo_iva
	WHERE Id_iva = vat_id;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesVatTypeGetByValue;
DELIMITER //
CREATE  PROCEDURE `sp_ariesVatTypeGetByValue`(
	vat_value INT(11)
)
BEGIN

	SELECT
		`Id_iva`,
		`Nome`,
		`Descrizione`,
		`aliquota`,
		`MESSAGGIO`,
		`normale`,
		`esigibilita`,
		`in_uso`
	FROM tipo_iva
	WHERE aliquota = vat_value
	ORDER BY in_uso desc;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesInvoiceTypeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceTypeGet`(
)
BEGIN
	SELECT
		`Id_tipo`,
		`Nome`,
		`Descrizione`,
		`tipo_PA`
	FROM tipo_fattura;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesInvoiceTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceTypeGetById`(
	type_id INT(11)
)
BEGIN

	SELECT
		`Id_tipo`,
		`Nome`,
		`Descrizione`,
		`tipo_PA`
	FROM tipo_fattura
	WHERE id_tipo = type_id;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesInvoiceTypeGetByEInvoiceType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceTypeGetByEInvoiceType`(
	e_invoice_type VARCHAR(5)
)
BEGIN

	SELECT
		`Id_tipo`,
		`Nome`,
		`Descrizione`,
		`tipo_PA`
	FROM tipo_fattura
	WHERE tipo_PA = e_invoice_type;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDdtSaveSignaturesRefs;
DELIMITER //
CREATE PROCEDURE sp_ariesDdtSaveSignaturesRefs
(
	ddt_id INT(11),
	ddt_year INT(11),
	recipient_signature_filename VARCHAR(50), 
	driver_signature_filename VARCHAR(50)
)
BEGIN

	UPDATE ddt
	SET 
		`filename_firma_destinatario` = recipient_signature_filename,
		`filename_firma_conducente` = driver_signature_filename
	WHERE Id_ddt = ddt_id AND anno = ddt_year; 
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedGet;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedGet
( )
BEGIN

	SELECT  
		`id`,
		`nome`,
		`nome_rif`,
		`nome_emittente`,
		`email`,
		`data_inizio_validita`,
		`data_fine_validita`,
		`serial_number`,
		`pin`,
		`smart_device`,
		`attivo`,
		`data_mod`,
		`utente_mod`
	FROM certificato_importato;
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedGetById;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedGetById
( IN in_id INT(11) )
BEGIN

	SELECT  
		`id`,
		`nome`,
		`nome_rif`,
		`nome_emittente`,
		`email`,
		`data_inizio_validita`,
		`data_fine_validita`,
		`serial_number`,
		`pin`,
		`smart_device`,
		`attivo`,
		`data_mod`,
		`utente_mod`
	FROM certificato_importato
	WHERE id = in_id;
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedGetByIssuerAndSerialNumber;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedGetByIssuerAndSerialNumber
( IN in_issuer VARCHAR(150), IN serial_number VARCHAR(150) )
BEGIN

	SELECT  
		`id`,
		`nome`,
		`nome_rif`,
		`nome_emittente`,
		`email`,
		`data_inizio_validita`,
		`data_fine_validita`,
		`serial_number`,
		`pin`,
		`smart_device`,
		`attivo`,
		`data_mod`,
		`utente_mod`
	FROM certificato_importato
	WHERE nome_emittente = in_issuer AND nome_emittente = in_serial_number;
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedInsert;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedInsert
( 	
	IN `in_name` VARCHAR(150),
	IN `in_ref_name` VARCHAR(150),
	IN `in_issuer_name` VARCHAR(150),
	IN `in_email` VARCHAR(150),
	IN `in_valid_from` DATETIME,
	IN `in_valid_to` DATETIME,
	IN `in_serial_number` VARCHAR(150),
	IN `in_pin` VARCHAR(50),
	IN `in_smart_device` BIT(1),
	IN `in_is_active` BIT(1),
	IN `in_user` INT(11), 
	OUT `result` INT(11)
)
BEGIN

	INSERT INTO certificato_importato 
	SET
		`nome` = in_name,
		`nome_rif` = in_ref_name,
		`nome_emittente` = in_issuer_name,
		`email` = in_email,
		`data_inizio_validita` = in_valid_from,
		`data_fine_validita` = in_valid_to,
		`serial_number` = in_serial_number,
		`pin` = in_pin,
		`smart_device` = in_serial_number,
		`attivo` = in_is_active,
		`utente_mod` = IFNULL(in_user, @USER_ID);
		
	SET Result = LAST_INSERT_ID(); 
	
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedUpdate;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedUpdate
( 	
	IN `in_name` VARCHAR(150),
	IN `in_ref_name` VARCHAR(150),
	IN `in_issuer_name` VARCHAR(150),
	IN `in_email` VARCHAR(150),
	IN `in_valid_from` DATETIME,
	IN `in_valid_to` DATETIME,
	IN `in_serial_number` VARCHAR(150),
	IN `in_pin` VARCHAR(50),
	IN `in_smart_device` BIT(1),
	IN `in_is_active` BIT(1),
	IN `in_user` INT(11), 
	IN `in_id` INT(11), 
	OUT `result` BIT(1)
)
BEGIN

	UPDATE certificato_importato 
	SET
		`nome` = in_name,
		`nome_rif` = in_ref_name,
		`nome_emittente` = in_issuer_name,
		`email` = in_email,
		`data_inizio_validita` = in_valid_from,
		`data_fine_validita` = in_valid_to,
		`serial_number` = in_serial_number,
		`pin` = in_pin,
		`smart_device` = in_serial_number,
		`attivo` = in_is_active,
		`utente_mod` = IFNULL(in_user, @USER_ID)
	WHERE id = in_id;
		
	SET Result = True; 
	
	
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesCertificateImportedDelete;
DELIMITER //
CREATE PROCEDURE sp_ariesCertificateImportedDelete
(
	IN `in_id` INT(11), 
	OUT `result` BIT(1)
)
BEGIN

	DELETE FROM certificato_importato
	WHERE id = in_id;
		
	SET Result = True; 
	
	
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesInvoiceSettingsGetLast;
DELIMITER //
CREATE PROCEDURE sp_ariesInvoiceSettingsGetLast
(  )
BEGIN

	SELECT 
		`id`,
		`colonna1`,
		`colonna3`,
		`nota_fissa`,
		`nome_col3`,
		`jjoin`,
		`nota_mail`,
		`nome_col1`,
		`imp_rap`,
		`ddt_prezzorap`,
		`scontozero`,
		`prezzozero`,
		`impianto`,
		`id_certificato_firma`,
		`email_sdi`,
		`utente_mod`,
		`data_mod`
	FROM fattura_configurazione
	ORDER BY id DESC 
	LIMIT 1;
	
END; //
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesSupplierContactsGet
DROP PROCEDURE IF EXISTS sp_ariesSupplierContactsGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierContactsGet`()
BEGIN
	SELECT 
		`Id_fornitore`,
		`Id_riferimento`,
		`Nome`,
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM riferimento_fornitore;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerContactsGetByCustomerId
DROP PROCEDURE IF EXISTS sp_ariesSupplierContactsGetBySupplierId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierContactsGetBySupplierId`(
	IN supplier_id INT
)
BEGIN
	SELECT  
		`Id_fornitore`,
		`Id_riferimento`,
		`Nome`,
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM riferimento_fornitore
	WHERE Id_fornitore = supplier_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierContactsGetBySupplierIdAndContactsId
DROP PROCEDURE IF EXISTS sp_ariesSupplierContactsGetBySupplierIdAndContactsId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierContactsGetBySupplierIdAndContactsId`(
	IN supplier_id INT,
	IN contacts_id INT
)
BEGIN
	SELECT  
		`Id_fornitore`,
		`Id_riferimento`,
		`Nome`,
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM riferimento_fornitore
	WHERE Id_fornitore = supplier_id AND Id_riferimento = contacts_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierContactsGetBySuppplierIds
DROP PROCEDURE IF EXISTS sp_ariesSupplierContactsGetBySupplierIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierContactsGetBySupplierIds`(
	IN supplier_ids MEDIUMTEXT
)
BEGIN

	SELECT 
		`Id_fornitore`,
		`Id_riferimento`,
		`Nome`,
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM riferimento_fornitore
	WHERE FIND_IN_SET(Id_fornitore, supplier_ids) > 0;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierContactsGetByEmailGroupToSend
DROP PROCEDURE IF EXISTS sp_ariesSupplierContactsGetByEmailGroupToSend;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierContactsGetByEmailGroupToSend`(
	IN email_group_id INT(11), 
	IN email_id INT(11)
)
BEGIN

	SELECT 
		riferimento_fornitore.Id_fornitore, 
		riferimento_fornitore.Id_riferimento, 
		riferimento_fornitore.Nome, 
		`figura`,
		`Telefono`,
		`altro_telefono`,
		`telefono2`,
		`fax`,
		`mail`,
		`centralino`,
		`fatturazione`,
		`nota`,
		`titolo`,
		`esterno`,
		`sito`,
		`skype`,
		`rif_esterno`,
		`sito_utente`,
		`sito_passwd`,
		`mail_pec`
	FROM mail_gruppo_fornitore
		INNER JOIN riferimento_fornitore ON mail_gruppo_fornitore.id_fornitore = riferimento_fornitore.id_fornitore
			AND mail_gruppo_fornitore.Id_riferimento = riferimento_fornitore.Id_riferimento
			
		LEFT JOIN mail_gruppo_inviate_fornitore ON mail_gruppo_inviate_fornitore.id_mail = email_id
			AND mail_gruppo_fornitore.id_fornitore = mail_gruppo_inviate_fornitore.id_fornitore
			AND mail_gruppo_fornitore.Id_riferimento = mail_gruppo_inviate_fornitore.Id_riferimento	
				
	WHERE mail_gruppo_fornitore.id_gruppo = email_group_id AND mail_gruppo_inviate_fornitore.stato IS NULL; 
		
	
END//
DELIMITER ;




-- Dump della struttura di procedura emmebi.sp_ariesSupplierGroupEmailSentGet
DROP PROCEDURE IF EXISTS sp_ariesSupplierGroupEmailSentGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGroupEmailSentGet`()
BEGIN
	SELECT 
		Id_mail, 
		Id_riferimento, 
		id_fornitore, 
		Stato, 
		IFNULL(Codice_errore, 0) Codice_errore,
		Messaggio_errore, 
		Timestamp
	FROM mail_gruppo_inviate;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierGroupEmailSentGetByEmailId
DROP PROCEDURE IF EXISTS sp_ariesSupplierGroupEmailSentGetByEmailId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGroupEmailSentGetByEmailId`(
	IN email_id INT(11) 
)
BEGIN
	SELECT 
		Id_mail, 
		Id_riferimento, 
		id_fornitore, 
		Stato, 
		IFNULL(Codice_errore, 0) Codice_errore,
		Messaggio_errore, 
		Timestamp
	FROM mail_gruppo_inviate_fornitore
	WHERE Id_mail = email_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierGroupEmailSentInsert
DROP PROCEDURE IF EXISTS sp_ariesSupplierGroupEmailSentInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGroupEmailSentInsert`(
	IN email_id INT(11), 
	IN contact_id INT(11), 
	IN supplier_id INT(11), 
	IN is_sent BIT(1), 
	IN error_code INT(11), 
	IN error_message VARCHAR(200), 
	OUT result SMALLINT
)
BEGIN

	
	INSERT INTO mail_gruppo_inviate_fornitore
	SET
		Id_mail = email_id, 
		Id_riferimento = contact_id, 
		id_fornitore = supplier_id, 
		Stato = is_sent, 
		Codice_errore = error_code,
		Messaggio_errore = error_message;
		
	SET result = 1; 	
	
	
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceGet
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceGet`(

)
BEGIN

	SELECT
		`Id_fattura`,
		`anno`,
		`id_fornitore`,
		`Data_registrazione`,
		`data_modifica`,
		`data`,
		`cond_pagamento`,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`ricevuto`,
		`pagato_il`,
		`tramite`,
		`insoluto`,
		`fattura_fornitore`,
		`totale`,
		`totiva`,
		`scan`,
		`modifica`,
		`costo_cavi`,
		`uso_consumo`,
		`id_attività`,
		`iva_incasso`,
		`iva_bollo`,
		`aliquota_iva_BTI`,
		`formato_trasmissione`,
		`progressivo_invio`,
		`codice_destinatario`,
		`pec_destinatario`,
		tipo_fattura_elettronica,
		sorgente_documento,
		e_fattura_filename,
		movimenta_magazzino
	FROM fornfattura;
	
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceGetByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceGetByIdAndYear`(
	IN enter_id INT(11), 
	IN enter_year INT(11)
)
BEGIN

	SELECT
		`Id_fattura`,
		`anno`,
		`id_fornitore`,
		`Data_registrazione`,
		`data_modifica`,
		`data`,
		`cond_pagamento`,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`ricevuto`,
		`pagato_il`,
		`tramite`,
		`insoluto`,
		`fattura_fornitore`,
		`totale`,
		`totiva`,
		`scan`,
		`modifica`,
		`costo_cavi`,
		`uso_consumo`,
		`id_attività`,
		`iva_incasso`,
		`iva_bollo`,
		`aliquota_iva_BTI`,
		`formato_trasmissione`,
		`progressivo_invio`,
		`codice_destinatario`,
		`pec_destinatario`,
		tipo_fattura_elettronica,
		sorgente_documento,
		e_fattura_filename,
		movimenta_magazzino
	FROM fornfattura
	WHERE fornfattura.Id_fattura = enter_id AND fornfattura.anno = enter_year;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceGetByExternalId
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceGetByExternalId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceGetByExternalId`(
	IN external_id VARCHAR(150),
	IN invoice_year VARCHAR(150),
	IN supplier_id VARCHAR(150)
)
BEGIN

	SELECT
		`Id_fattura`,
		`anno`,
		`id_fornitore`,
		`Data_registrazione`,
		`data_modifica`,
		`data`,
		`cond_pagamento`,
		`annotazioni`,
		`Stato`,
		`causale_fattura`,
		`nota_interna`,
		`tipo_fattura`,
		`incasso`,
		`bollo`,
		`trasporto`,
		`ricevuto`,
		`pagato_il`,
		`tramite`,
		`insoluto`,
		`fattura_fornitore`,
		`totale`,
		`totiva`,
		`scan`,
		`modifica`,
		`costo_cavi`,
		`uso_consumo`,
		`id_attività`,
		`iva_incasso`,
		`iva_bollo`,
		`aliquota_iva_BTI`,
		`formato_trasmissione`,
		`progressivo_invio`,
		`codice_destinatario`,
		`pec_destinatario`,
		tipo_fattura_elettronica,
		sorgente_documento,
		e_fattura_filename,
		movimenta_magazzino
	FROM fornfattura
	WHERE fornfattura.fattura_fornitore = external_id AND fornfattura.anno = invoice_year AND fornfattura.id_fornitore = IF(supplier_id > 0, supplier_id, fornfattura.id_fornitore) ;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceDeleteByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceDeleteByIdAndYear;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceDeleteByIdAndYear`(
	IN enter_id INT(11), 
	IN enter_year INT(11),
	OUT Result INT(11)
)
BEGIN

	DELETE FROM fornfattura
	WHERE Id_fattura = enter_id AND anno = enter_year;
	
	SET Result = 1;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceSetScan;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceSetScan`(
	IN enter_id INT(11), 
	IN enter_year INT(11),
	IN scan_value BIT(1),
	OUT Result INT(11)
	
)
BEGIN

	UPDATE fornfattura
	SET scan = scan_value
	WHERE Id_fattura = enter_id AND anno = enter_year;
	SET Result = 1;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceProductGetBySupplierInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceProductGetBySupplierInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN
	SELECT
		`id_fattura`,
		`Anno`,
		`n_tab`,
		`Descrizione`,
		`um`,
		`quantità`,
		`prezzo_unitario`,
		`sconto`,
		`costo`,
		`serial_number`,
		`id_materiale`,
		`Iva`,
		`codice_fornitore`,
		`anno_rif`,
		`id_rif`,
		`tipo`L,
		`anomalo`,
		`corretto`,
		`id_nota`,
		`corretto2`,
		`riparazione`
	FROM fornfattura_articoli
	WHERE id_fattura = invoice_id AND Anno = invoice_year;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesSupplierInvoiceGetByIdAndYear
DROP PROCEDURE IF EXISTS sp_ariesSupplierGetByVatNumber;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGetByVatNumber`(
	vat_number VARCHAR(50)
)
BEGIN

	SELECT
		`Id_fornitore`,
		`Ragione_Sociale`,
		`Ragione_Sociale2`,
		`Partita_iva`,
		`Codice_Fiscale`,
		`Data_inserimento`,
		`Stato_Fornitore`,
		`stato_economico`,
		`condizione_pagamento`,
		`Sito_internet`,
		`password`,
		`Utente_sito`,
		`iva`,
		`tipo_fornitore`,
		`modi`,
		`id_tiporapp`,
		`id_utente`,
		`costruttore`,
		`id_attività`,
		`cod_fornitore`
	FROM fornitore
	WHERE Partita_iva = vat_number;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesSupplierGetById
DROP PROCEDURE IF EXISTS sp_ariesSupplierGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGetById`(
	enter_id INT(11)
)
BEGIN

	SELECT
		`Id_fornitore`,
		`Ragione_Sociale`,
		`Ragione_Sociale2`,
		`Partita_iva`,
		`Codice_Fiscale`,
		`Data_inserimento`,
		`Stato_Fornitore`,
		`stato_economico`,
		`condizione_pagamento`,
		`Sito_internet`,
		`password`,
		`Utente_sito`,
		`iva`,
		`tipo_fornitore`,
		`modi`,
		`id_tiporapp`,
		`id_utente`,
		`costruttore`,
		`id_attività`,
		`cod_fornitore`
	FROM fornitore
	WHERE Id_fornitore = enter_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierGetByCompanyName
DROP PROCEDURE IF EXISTS sp_ariesSupplierGetByCompanyName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierGetByCompanyName`(
	company_name VARCHAR(100)
)
BEGIN

	SELECT
		`Id_fornitore`,
		`Ragione_Sociale`,
		`Ragione_Sociale2`,
		`Partita_iva`,
		`Codice_Fiscale`,
		`Data_inserimento`,
		`Stato_Fornitore`,
		`stato_economico`,
		`condizione_pagamento`,
		`Sito_internet`,
		`password`,
		`Utente_sito`,
		`iva`,
		`tipo_fornitore`,
		`modi`,
		`id_tiporapp`,
		`id_utente`,
		`costruttore`,
		`id_attività`,
		`cod_fornitore`
	FROM fornitore
	WHERE Ragione_sociale = company_name 
		OR Ragione_sociale2 = company_name;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesSupplierDestinationGet
DROP PROCEDURE IF EXISTS sp_ariesSupplierDestinationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierDestinationGet`()
BEGIN
	SELECT 
	`id_fornitore`,
	`Id_destinazione`,
	`Provincia`,
	`Comune`,
	`Frazione`,
	`Indirizzo`,
	`numero_civico`,
	`Descrizione`,
	`scala`,
	`Altro`,
	`attivo`,
	`Note`,
	`Sede_principale`,
	`piano`,
	`interno`,
	`fcap`,
	`id_autostrada`
	FROM destinazione_fornitore;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierDestinationGetBySupplierId
DROP PROCEDURE IF EXISTS sp_ariesSupplierDestinationGetBySupplierId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierDestinationGetBySupplierId`(
	IN supplier_id INT
)
BEGIN
	SELECT 
	`id_fornitore`,
	`Id_destinazione`,
	`Provincia`,
	`Comune`,
	`Frazione`,
	`Indirizzo`,
	`numero_civico`,
	`Descrizione`,
	`scala`,
	`Altro`,
	`attivo`,
	`Note`,
	`Sede_principale`,
	`piano`,
	`interno`,
	`fcap`,
	`id_autostrada`
	FROM destinazione_fornitore
	WHERE Id_fornitore = supplier_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierDestinationGetBySupplierIdAndContactsId
DROP PROCEDURE IF EXISTS sp_ariesSupplierDestinationGetBySupplierIdAndContactsId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierDestinationGetBySupplierIdAndContactsId`(
	IN supplier_id INT,
	IN contacts_id INT
)
BEGIN
	SELECT 
	`id_fornitore`,
	`Id_destinazione`,
	`Provincia`,
	`Comune`,
	`Frazione`,
	`Indirizzo`,
	`numero_civico`,
	`Descrizione`,
	`scala`,
	`Altro`,
	`attivo`,
	`Note`,
	`Sede_principale`,
	`piano`,
	`interno`,
	`fcap`,
	`id_autostrada`
	FROM destinazione_fornitore
	WHERE Id_fornitore = supplier_id AND Id_riferimento = contacts_id;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesSupplierDestinationGetBySupplierIds
DROP PROCEDURE IF EXISTS sp_ariesSupplierDestinationGetBySupplierIds;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierDestinationGetBySupplierIds`(
	IN supplier_ids MEDIUMTEXT
)
BEGIN

	SELECT 
	`id_fornitore`,
	`Id_destinazione`,
	`Provincia`,
	`Comune`,
	`Frazione`,
	`Indirizzo`,
	`numero_civico`,
	`Descrizione`,
	`scala`,
	`Altro`,
	`attivo`,
	`Note`,
	`Sede_principale`,
	`piano`,
	`interno`,
	`fcap`,
	`id_autostrada`
	FROM destinazione_fornitore
	WHERE FIND_IN_SET(Id_fornitore, supplier_ids) > 0;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGroupGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesReportGroupGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGroupGetByInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN

	SELECT `id_resoconto`,
		`anno`,
		`data`,
		`Descrizione`,
		`Numero_ordine`,
		`Id_cliente`,
		`stato`,
		`Nota`,
		`fattura`,
		`anno_fattura`,
		`id_utente`,
		`tipo_resoconto`,
		`inviato`,
		`nota_fine`,
		`stm`,
		`fat_SpeseRap`
	FROM resoconto
	WHERE fattura = invoice_id
		AND anno_fattura = invoice_year;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGroupGetSingle
DROP PROCEDURE IF EXISTS sp_ariesReportGroupGetSingle;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGroupGetSingle`(
	IN enter_id INT(11), 
	IN enter_year INT(11)
)
BEGIN

	SELECT `id_resoconto`,
		`anno`,
		`data`,
		`Descrizione`,
		`Numero_ordine`,
		`Id_cliente`,
		`stato`,
		`Nota`,
		`fattura`,
		`anno_fattura`,
		`id_utente`,
		`tipo_resoconto`,
		`inviato`,
		`nota_fine`,
		`stm`,
		`fat_SpeseRap`
	FROM resoconto
	WHERE id_resoconto = enter_id
		AND anno = enter_year;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProxiesConfigurationGetByType
DROP PROCEDURE IF EXISTS sp_ariesProxiesConfigurationGetByType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProxiesConfigurationGetByType`(
	IN in_type INT(11)
)
BEGIN
	SELECT
		`id`,
		`tipo`,
		`base_host`,
		`basic_auth`,
		`timestamp`
	FROM proxies_configurazione
	WHERE tipo = in_type;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePurchaseOrderInsert
DROP PROCEDURE IF EXISTS sp_ariesInvoicePurchaseOrderInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePurchaseOrderInsert`(
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	IN document_id VARCHAR(20),
	IN in_date DATE,
	IN cig_code VARCHAR(15),
	IN cup_code VARCHAR(15),
	OUT Result INT(11)
)
BEGIN
	INSERT INTO fattura_ordine_acquisto
	SET `Id_fattura` = invoice_id,
		`Anno_fattura` = invoice_year,
		`Id_documento` = document_id,
		`Data` = in_date,
		`Codice_cig` = cig_code,
		`Codice_cup` = cup_code;	

	SET Result = LAST_INSERT_ID(); 
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesInvoicePurchaseOrderGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoicePurchaseOrderGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePurchaseOrderGetByInvoice`(
	IN invoice_id INT(11),
	IN invoice_year INT(11)
)
BEGIN
	SELECT
		`Id`,
		`Id_fattura`,
		`Anno_fattura`,
		`Id_documento`,
		`Data`,
		`Codice_cig`,
		`Codice_cup`,
		`Timestamp`
	FROM fattura_ordine_acquisto
	WHERE Id_fattura = invoice_id AND Anno_fattura = invoice_year;	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePurchaseOrderUpdate
DROP PROCEDURE IF EXISTS sp_ariesInvoicePurchaseOrderUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePurchaseOrderUpdate`(
	IN in_id INT(11),
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	IN document_id VARCHAR(20),
	IN in_date DATE,
	IN cig_code VARCHAR(15),
	IN cup_code VARCHAR(15),
	OUT Result INT(11)
)
BEGIN
	UPDATE fattura_ordine_acquisto
	SET `Id_fattura` = invoice_id,
		`Anno_fattura` = invoice_year,
		`Id_documento` = document_id,
		`Data` = in_date,
		`Codice_cig` = cig_code,
		`Codice_cup` = cup_code
	WHERE id = in_id;	

	SET Result = 1; 
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePurchaseOrderDelete
DROP PROCEDURE IF EXISTS sp_ariesInvoicePurchaseOrderDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoicePurchaseOrderDelete`(
	IN in_id INT(11)
)
BEGIN
	DELETE FROM fattura_ordine_acquisto
	WHERE Id = in_id;	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePurchaseOrderDelete
DROP PROCEDURE IF EXISTS sp_ariesReceivedDdtGetByCodeAndDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReceivedDdtGetByCodeAndDate`(
	IN ext_code VARCHAR(20), 
	IN ddt_date DATE
)
BEGIN
	SELECT 	
		`Id_ddt`,
		`anno`,
		`id_cliente`,
		`id_fornitore`,
		`Id_destinazione`,
		`condizione_pagamento`,
		`Porto_resa`,
		`data_documento`,
		`Vettore`,
		`data_ora_ritiro`,
		`data_ora_inizio`,
		`trasport_a_cura`,
		`Causale`,
		`Fattura`,
		`Anno_fattura`,
		`colli`,
		`Peso`,
		`Nota`,
		`Descrizione`,
		`id_principale`,
		`impianto`,
		`scan`,
		`destinazione_forn`,
		`principale_forn`,
		`numero_ddt`,
		`id_utente`
	FROM ddt_ricevuti
	WHERE numero_ddt = ext_code AND data_documento = ddt_date;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesQuoteClone;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteClone`( 
	IN quote_id INT(11),
	IN quote_year INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
  	DECLARE new_id INT(11); 
  	DECLARE curr_year INT(11);
  	DECLARE last_review_id INT(11);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;	
		
	START TRANSACTION;

	SET curr_year = YEAR(CURDATE());
	
	SELECT IFNULL(MAX(id_preventivo) + 1, 1) 
		INTO new_id
	FROM preventivo
	WHERE anno = curr_year; 
	
	SELECT MAX(id_revisione)
		INTO last_review_id
	FROM revisione_preventivo 
	WHERE Id_preventivo = quote_id AND Anno = quote_year;
	
	SET Result = new_id; 
	
	INSERT INTO preventivo(id_preventivo, anno, data_creazione, stato, note, tipo_preventivo, agente, revisione) 
	SELECT new_id,
		curr_year,
		NOW(),
		5, -- Stato preventivo
		CONCAT(note, " DUPLICATO DA ", quote_id, " - ", quote_year),
		tipo_preventivo,
		agente,
		0
	FROM preventivo
	WHERE Id_preventivo = quote_id AND Anno = quote_year;
	
	INSERT INTO revisione_preventivo(id_riferimento, id_cliente, destinazione, id_revisione, id_preventivo, anno, data_creazione, data, listino,sconto_perc,
		prezzo_ora, costo_ora,aliquota,corpo,cortese,oggetto, nota,tariffa,sitoin, corpo_rtf)
	SELECT id_riferimento,
		id_cliente,
		destinazione,
		0,
		new_id,
		curr_year,
		NOW(),
		NOW(),
		listino,sconto_perc,
		prezzo_ora,
		costo_ora,
		aliquota,
		corpo,
		cortese,
		oggetto,
		nota,
		tariffa,
		sitoin,
		corpo_rtf
	FROM revisione_preventivo
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND id_revisione = last_review_id;
	
		
	INSERT INTO preventivo_lotto(id_lotto, anno, id_preventivo, id_revisione, posizione, nota, prefazione, id_impianto,
		id_Abbo, scon, ora_p, ora_c, optional, iv_lot, tipo_ricar, perc_ric)
	SELECT id_lotto,
		curr_year,
		new_id,
		0,
		posizione,
		nota,prefazione,
		id_impianto,
		id_Abbo,
		scon,
		ora_p,
		ora_c,
		optional,
		iv_lot,
		tipo_ricar,
		perc_ric
	FROM preventivo_lotto
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND id_revisione = last_review_id;
	
	INSERT INTO preventivo_impianto(anno, id_preventivo, revisione, impianto)
	SELECT curr_year,
		new_id,
		0,
		impianto
	FROM preventivo_impianto
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND revisione = last_review_id;

	INSERT INTO lotto_esclusioni (id_lotto, id_revisione, id_preventivo, anno, id_esclusione)
	SELECT id_lotto,
		0,
		new_id,
		curr_year,
		id_esclusione
    FROM lotto_esclusioni
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND id_revisione = last_review_id;

	INSERT INTO articolo_preventivo (id_preventivo, id_revisione, anno, lotto, id_tab, prezzo, costo, sconto, quantità,
		costo_h, prezzo_h, desc_brev, codice_fornitore, id_articolo, tempo_installazione, listino,
		montato, bloccato, tipo, unità_misura, scontoriga, scontolav, idnota, Utente_ins)
	SELECT
		new_id,
		0,
		curr_year,
		lotto,
		id_tab,
		prezzo,
		costo,
		sconto,
		quantità,
		costo_h,
		prezzo_h, 
		IF(articolo_nota.descrizione IS NULL,desc_brev, nota),
		codice_fornitore,
		articolo_preventivo.id_articolo,
		tempo_installazione,
		listino,
		montato,
		bloccato,
		tipo,
		unità_misura,
		scontoriga,
		scontolav,
		idnota,
		@USER_ID
	FROM articolo_preventivo 
	LEFT JOIN articolo_nota ON articolo_preventivo.id_articolo = articolo_nota.id_Articolo AND descrizione = "Generale"
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND id_revisione = last_review_id;


	INSERT INTO preventivo_lotto_pdf (
		Id_preventivo, id_revisione, anno, posizione_lotto, posizione, filepath, filename, utente_mod
	)
	SELECT
		new_id, 0, curr_year, posizione_lotto, posizione, filepath, filename, @USER_ID
	FROM preventivo_lotto_pdf 
	WHERE Id_preventivo = quote_id 
		AND Anno = quote_year
		AND id_revisione = last_review_id;


	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesInvoiceClone;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceClone`( 
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
  	DECLARE new_id INT(11); 
  	DECLARE new_year INT(11);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;	
		
	START TRANSACTION;
	SET result = 1;
	SET new_year = 0;
	
	SELECT IFNULL(MAX(id_fattura) + 1, 1) 
		INTO new_id
	FROM fattura
	WHERE anno = 0; 

	INSERT INTO fattura (
		Id_fattura, anno, id_cliente, id_destinazione, destinazione, Data_registrazione, data_modifica, DATA,
		cond_pagamento, banca, annotazioni, Stato, causale_fattura, nota_interna, iban, abi, cab, tipo_fattura,
		incasso, bollo, trasporto, pagato_il, tramite, insoluto, stampato, subappalto, id_utente, scont_mat, id_iv,
		movimenta_magazzino, id_documento_ricezione, id_tipo_natura_iva, area_attivita,
		importo_imponibile, importo_iva, importo_totale, costo_totale
	)
	SELECT new_id, new_year, id_cliente, id_destinazione, destinazione, NOW(), NOW(), NOW(),
		cond_pagamento, banca, annotazioni, 5, causale_fattura, nota_interna, iban, abi, cab, tipo_fattura,
		incasso, bollo, trasporto, pagato_il, tramite, 0, 0, subappalto, @USER_ID, scont_mat, id_iv,
		movimenta_magazzino, id_documento_ricezione, id_tipo_natura_iva, area_attivita,
		importo_imponibile, importo_iva, importo_totale, costo_totale
	FROM fattura
	WHERE id_fattura = invoice_id AND anno = invoice_year;

	INSERT INTO fattura_articoli (
		id_fattura, Anno, n_tab, Descrizione, um, quantità, prezzo_unitario, sconto, costo, serial_number,
		id_materiale, Iva, codice_fornitore, anno_rif, id_rif, tipo, idnota
	)
	SELECT new_id, new_year, n_tab, Descrizione, um, quantità, prezzo_unitario, sconto, costo, serial_number,
		id_materiale, Iva, codice_fornitore, anno_rif, id_rif, tipo, idnota
	FROM fattura_articoli
	WHERE id_fattura = invoice_id AND anno = invoice_year;
	
	INSERT INTO fattura_totali_iva (
		id_fattura, Anno, id_iva, importo_imponibile, importo_iva, importo_totale
	)
	SELECT new_id, new_year, id_iva, importo_imponibile, importo_iva, importo_totale
	FROM fattura_totali_iva
	WHERE id_fattura = invoice_id AND anno = invoice_year;


	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesQuoteLinkToTicket;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLinkToTicket`( 
	IN quote_id INT(11),
	IN quote_year INT(11),
	IN ticket_id INT(11),
	IN ticket_year INT(11),
	IN internal_note LONGTEXT,
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE customer_id INT(11);
	DECLARE review_id INT(11);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;	
		
	START TRANSACTION;
	
	SET Result = 1; 
	
	SELECT id_cliente
		INTO customer_id
	FROM ticket
	WHERE Id_ticket = ticket_id
		AND anno = ticket_year;
	
	SELECT revisione
		INTO review_id
	FROM preventivo
	WHERE Id_preventivo = quote_id
		AND anno = quote_year;
	
	INSERT INTO preventivo_ticket (id_preventivo, anno_preventivo, id_ticket, anno_ticket)
		VALUES (quote_id, quote_year, ticket_id, ticket_year);
		
	UPDATE preventivo
	SET stato = 6,
		Note = internal_note
	WHERE Id_preventivo = quote_id AND anno = quote_year;
	
	UPDATE revisione_preventivo
	SET id_cliente = customer_id 
	WHERE Id_preventivo = quote_id AND anno = quote_year AND Id_revisione = review_id;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoicePrepaymentGetById
DROP PROCEDURE IF EXISTS sp_ariesInvoiceChangeSentStatus;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceChangeSentStatus`( 
	IN invoice_id INT(11),
	IN invoice_year INT(11),
	IN is_sent BIT(1)
)
BEGIN
	UPDATE fattura
	SET inviato = is_sent
	WHERE id_fattura = invoice_id AND anno = invoice_year;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesSupplierPriceListGetByProductAndSupplier
DROP PROCEDURE IF EXISTS sp_ariesSupplierPriceListGetByProductAndSupplier;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierPriceListGetByProductAndSupplier`( 
	IN code VARCHAR(11),
	IN supplier_id INT(11)
)
BEGIN
	
  DROP TABLE IF EXISTS  temp_articolo_listino; 
  
	CREATE TABLE temp_articolo_listino (
		`Id_listino` INT(11) NOT NULL,
		`Prezzo` DECIMAL(11,4) NOT NULL,
		PRIMARY KEY (`Id_listino`)
	);
	
	INSERT INTO temp_articolo_listino
	SELECT Id_listino,
		Prezzo
	FROM articolo_listino
	WHERE Id_articolo = code;
	
	
	SELECT DISTINCT
		fornitore_listino.id_listino, 
		id_fornitore, 
		code as Id_articolo, 
		acquisto.prezzo as Prezzo, 
		acquisto.id_listino as Id_prezzo,
		netto.prezzo as Netto, 
		netto.id_listino as Id_netto, 
		speciale.prezzo as Speciale, 
		speciale.id_listino as Id_speciale,
		ultimo.prezzo as Ultimo, 
		ultimo.id_listino as Id_ultimo
	FROM fornitore_listino
		LEFT JOIN temp_articolo_listino AS acquisto ON acquisto.Id_listino = fornitore_listino.acquisto
		LEFT JOIN temp_articolo_listino AS netto ON netto.Id_listino = fornitore_listino.netto
		LEFT JOIN temp_articolo_listino AS speciale ON speciale.Id_listino = fornitore_listino.speciale
		LEFT JOIN temp_articolo_listino AS ultimo ON ultimo.Id_listino = fornitore_listino.ultimo
	WHERE id_fornitore = supplier_id;
	
	DROP TABLE IF EXISTS  temp_articolo_listino; 
END//

DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesInvoiceAmountByTaxDeleteByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoiceAmountByTaxDeleteByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceAmountByTaxDeleteByInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11),
	OUT result INT(11)
)
BEGIN
	DELETE FROM fattura_totali_iva
	WHERE id_fattura = invoice_id AND anno = invoice_year;	
	
	SET result = 1;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoiceAmountByTaxGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoiceAmountByTaxGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceAmountByTaxGetByInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN
	SELECT 	`id`,
		`id_fattura`,
		`anno`,
		`id_iva` ,
		`importo_imponibile`,
		`importo_iva`,
		`importo_totale`
	FROM fattura_totali_iva
	WHERE id_fattura = invoice_id AND anno = invoice_year;
END//
DELIMITER ;



-- Dump della struttura di procedura sp_ariesInvoiceDelete
DROP PROCEDURE IF EXISTS sp_ariesInvoiceDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceDelete`(
	IN enter_id INT(11),
	IN enter_year INT(11),
	OUT result  TINYINT
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;	
		
	START TRANSACTION;

  UPDATE rapporto
	SET stato=1,
		Fattura = NULL,
		Anno_fattura = NULL
	WHERE anno_fattura = enter_year AND Fattura = enter_id;

	UPDATE resoconto 
	SET stato=1,
		Fattura = NULL,
		Anno_fattura = NULL
	WHERE anno_fattura = enter_year AND Fattura = enter_id;

  DELETE FROM commessa_fattura 
	WHERE anno_fattura = enter_year AND id_fattura = enter_id;

  UPDATE ddt 
	SET Fattura = NULL, 
		Anno_fattura = NULL, 
		Stato = 1
	WHERE anno_fattura = enter_year AND Fattura = enter_id;

  DELETE FROM fattura_totali_iva 
	WHERE anno = enter_year AND id_fattura = enter_id;

  DELETE FROM fattura_acconto
	WHERE anno = enter_year AND id_fattura = enter_id;
	
  DELETE FROM fattura_articoli 
	WHERE anno = enter_year AND id_fattura = enter_id;

  DELETE FROM fattura_pagamenti
	WHERE anno = enter_year AND id_fattura = enter_id;

	DELETE FROM fattura_sollecito_numeri
	WHERE anno_fattura = enter_year AND Fattura = enter_id;

	DELETE FROM fattura_studi
	WHERE anno = enter_year AND Id_fattura = enter_id;

	DELETE FROM fattura_ordine_acquisto
	WHERE anno_fattura = enter_year AND id_Fattura = enter_id;
	
  DELETE FROM fattura 
	WHERE anno = enter_year AND id_fattura = enter_id;

	SET result = 1;
					
	IF `_rollback` THEN
	  ROLLBACK;
	  SET result = -10; 
	ELSE
		COMMIT; 
	END IF;
END//
DELIMITER ;

-- Dump della struttura di procedura sp_ariesSupplierInvoiceAttachsGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesSupplierInvoiceAttachsGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSupplierInvoiceAttachsGetByInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN
	SELECT
		`id`,
		`id_fattura`,
		`Anno_fattura`,
		`Nome` ,
		`Descrizione`,
		`Formato`,
		`Algoritmo`,
		`File_path`,
		`Timestamp`
	FROM fornfattura_allegati
	WHERE id_fattura = invoice_id AND Anno_fattura = invoice_year;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesReportGetNotInvoicedByJob
DROP PROCEDURE IF EXISTS sp_ariesReportGetNotInvoicedByJob;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetNotInvoicedByJob`( 
job_id INT, 
job_year INT,
sub_job_id INT, 
job_lot_id INT
)
BEGIN
         
	SELECT 
		Id, 
		r.Id_rapporto,
		r.Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto r
		INNER JOIN commessa_rapporto cr
			ON r.id_rapporto = cr.id_rapporto AND r.anno = cr.anno_rapporto
			AND cr.id_commessa = job_id AND cr.anno_commessa = job_year
			AND cr.id_sottocommessa = sub_job_id AND IF(job_lot_id = -1, True, cr.id_lotto = job_lot_id)
	WHERE Fattura IS NULL OR Fattura = 0;

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesReportGetByInvoiceId
DROP PROCEDURE IF EXISTS sp_ariesReportGetByInvoiceId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportGetByInvoiceId`( 
enter_id INT, 
enter_year INT
)
BEGIN
        
	SELECT 
		Id, 
		Id_rapporto,
		Anno,
		IFNULL(Id_impianto, 0) Id_impianto,
		IFNULL(Id_cliente, 0) Id_cliente,
		id_destinazione,
		IFNULL(fattura, 0) Fattura,
		IFNULL(anno_fattura, 0) anno_fattura,
		IFNULL(Id_utente, 0) id_utente,
		Data,
		IFNULL(dest_cli,0) dest_cli,
		IFNULL(Richiesto, "") Richiesto,
		IFNULL(Mansione, "") Mansione,
		IFNULL(Responsabile, "") Responsabile,
		Tipo_intervento,
		Diritto_chiamata,
		tipo_diritto_chiamata,
		relazione,
		Terminato,
		CAST(Funzionante AS UNSIGNED) Funzionante,
		stato,
		Note_generali,
		abbonamento,
		Totale,
		Nr_rapporto,
		Data_esecuzione,
		Costo,
		scan,
		controllo_periodico,
		controllo_periodico_costo,
		controllo_periodico_quantita,
		numero,
		prima,
		cost_lav,
		prez_lav,
		appunti,
		firma1,
		firma2,
		firma3, 
		Id_tipo_sorgente, 
		Id_tipo_rapporto,
		filename_firma_cliente,
		filename_firma_tecnico, 
		usa_firma_su_ddt, 
		filename_firma_per_ddt,
		numero_allegati
	FROM rapporto
	WHERE Fattura = enter_id AND Anno_fattura = enter_year
	ORDER BY anno desc, data_esecuzione desc, Id_rapporto desc;

END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesInvoiceUpdateDate
DROP PROCEDURE IF EXISTS sp_ariesInvoiceUpdateDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceUpdateDate`(
	IN `invoice_id` INT(11),
	IN `invoice_year` INT(11),
	IN `invoice_date` DATE,
	OUT result BIT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	SET Result = 1; 
	
	START TRANSACTION;
	
	UPDATE fattura
	SET `Data` = invoice_date 
	WHERE id_fattura = invoice_id AND anno = invoice_year;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesXmlSpecialCharsReplaceGet
DROP PROCEDURE IF EXISTS sp_ariesXmlSpecialCharsReplaceGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesXmlSpecialCharsReplaceGet`( 
)
BEGIN
	SELECT `Id`,
		`search_string`,
		`replace_string`,
		`is_regexp`,
		`enabled`
	FROM xml_caratteri_speciali_replacement
	WHERE enabled = 1;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_quoteCreateJob;
DELIMITER $$
CREATE PROCEDURE sp_quoteCreateJob(
	QuoteId INT, QuoteYear INT, QuoteRevision INT,
	OUT JobId INT, OUT JobYear INT
)
BEGIN
	DECLARE CurrentYear INT DEFAULT YEAR(CURRENT_DATE);
	
	SET JobYear = CurrentYear;
	
	SELECT IFNULL(MAX(id_commessa), 0) + 1
	INTO JobId
	FROM commessa 
	WHERE anno = CurrentYear;

	INSERT INTO commessa(id_utente, id_commessa, anno, id_cliente, data_inizio, stato_commessa, tipo_commessa, descrizione, Data_ins, Utente_ins) 
	SELECT @USER_ID, JobId, JobYear, rp.id_cliente, CURRENT_DATE, 1, 1, note, NOW(), @USER_ID
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo 
			AND rp.anno = p.anno 
			AND rp.id_revisione = p.revisione 
	WHERE p.id_preventivo = QuoteId 
		AND p.anno = QuoteYear;
		
	INSERT INTO commessa_sotto(id_commessa, anno, id_sotto, stato, nome, destinazione, inizio) 
	SELECT JobId, JobYear, 1, 1, "SOTTOCOMMESSA PRINCIPALE", destinazione, CURRENT_DATE 
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo
			AND p.anno = rp.anno 
			AND p.revisione = rp.id_revisione 
	WHERE p.id_preventivo = QuoteId
		AND p.anno = QuoteYear;

	CALL sp_quoteAddToSubJob(QuoteId, QuoteYear, 
		QuoteRevision, JobId, JobYear, 1);
	
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_quoteAssociateToJob;
DELIMITER $$
CREATE PROCEDURE sp_quoteAssociateToJob(
	QuoteId INT, QuoteYear INT, QuoteRevision INT,
	JobId INT, JobYear INT, OUT SubJobId INT
)
BEGIN
	SELECT IFNULL(MAX(id_sotto), 0) + 1
			INTO SubJobId
	FROM commessa_sotto
	WHERE id_commessa = JobId AND anno = JobYear;

		
	INSERT INTO commessa_sotto(id_commessa, anno, id_sotto, stato, nome, destinazione, inizio) 
	SELECT JobId, JobYear, SubJobId, 1, CONCAT("SOTTOCOMMESSA PREVENTIVO ", QuoteId, "/", QuoteYear), destinazione, CURRENT_DATE 
	FROM preventivo p
		LEFT JOIN revisione_preventivo rp ON p.id_preventivo = rp.id_preventivo
			AND p.anno = rp.anno 
			AND p.revisione = rp.id_revisione 
	WHERE p.id_preventivo = QuoteId
		AND p.anno = QuoteYear;


	CALL sp_quoteAddToSubJob(QuoteId, QuoteYear, 
		QuoteRevision, JobId, JobYear, SubJobId);	
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_quoteAddToSubJob;
DELIMITER $$
CREATE PROCEDURE sp_quoteAddToSubJob(
	QuoteId INT, QuoteYear INT, QuoteRevision INT,
	JobId INT, JobYear INT, SubJobId INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_lot_id INT;
	DECLARE V_curA CURSOR FOR SELECT posizione
		FROM preventivo_lotto
		WHERE id_preventivo = QuoteId 
			AND anno = QuoteYear 
			AND id_revisione = QuoteRevision;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	INSERT INTO commessa_lotto(id_commessa, anno, id_sottocommessa, stato, descrizione, data_inizio, id_lotto, impianto, csora, prora, sc) 
	SELECT JobId, JobYear, SubJobId, 1, l.nome, CURRENT_DATE, posizione, id_impianto, ora_p, ora_c, scon 
	FROM preventivo_lotto pl
		INNER JOIN lotto l ON l.id_lotto = pl.id_lotto 
	WHERE pl.id_preventivo = QuoteId 
		AND pl.anno = QuoteYear 
		AND id_revisione = QuoteRevision;

	INSERT INTO commessa_articoli(preventivati, id_commessa, anno, id_sottocommessa, descrizione, id_lotto, quantità, codice_articolo, codice_fornitore, 
		um, id_tab, prezzo, tempo, costo_ora, costo, prezzo_ora, sconto, iva) 
	SELECT SUM(ap.quantità),
		JobId,
		JobYear,
		SubJobId,
		IFNULL(a.desc_brev, ap.desc_brev), 
		lotto,
		SUM(quantità),
		id_articolo,
		ap.codice_fornitore,
		ap.unità_misura,
		id_tab, 
		ROUND(prezzo-prezzo * IF(pl.tipo_ricar = 1, 0, sconto)/100, 2), IF(montato, ap.tempo_installazione, "0"), 
		costo_h, costo, (prezzo_h-prezzo_h * scontolav/100), scontoriga, iva 
	FROM articolo_preventivo ap
		LEFT JOIN articolo a ON id_articolo = codice_articolo 
		LEFT JOIN preventivo_lotto pl ON pl.posizione = ap.lotto 
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND pl.id_preventivo = ap.id_preventivo 
	WHERE ap.id_preventivo = QuoteId 
		AND ap.anno = QuoteYear 
		AND ap.id_revisione = QuoteRevision 
		AND tipo IN("A", "AL") 
		AND id_articolo IS NOT NULL 
	GROUP BY id_articolo, lotto 
	UNION ALL 
	SELECT ap.quantità,
		JobId,
		JobYear,
		SubJobId,
		ap.desc_brev,
		lotto, 
		quantità, id_articolo, ap.codice_fornitore, ap.unità_misura, id_tab, 
		ROUND(prezzo-prezzo * IF(pl.tipo_ricar = 1, 0, sconto)/100, 2), IF(montato, ap.tempo_installazione, "0"), 
		costo_h, costo, (prezzo_h-prezzo_h * scontolav/100), scontoriga, iva 
	FROM articolo_preventivo ap 
		LEFT JOIN preventivo_lotto pl ON pl.posizione = ap.lotto 
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND pl.id_preventivo = ap.id_preventivo 
	WHERE ap.id_preventivo = QuoteId 
		AND ap.anno = QuoteYear 
		AND ap.id_revisione = QuoteRevision 
		AND tipo IN("A", "AL") 
		AND id_articolo IS NULL
	HAVING id_tab IS NOT NULL; -- for some reason we get one row with all null result, this having is a workaround to avoid it

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_lot_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		CALL sp_getQuoteTotals(QuoteId, QuoteYear, QuoteRevision, v_lot_id, @total_price_material, @total_cost_material, @total_profit_material, @total_price_work, @total_cost_work, @total_profit_work, @total_hours, @total_price, @total_cost, @total_profit, @total_sale);

		INSERT INTO commessa_preventivo(id_commessa, anno, id_sottocommessa,
			preventivo, anno_prev, rev, lotto, pidlotto,
			preventivo_prezzo_materiale,
			preventivo_costo_materiale,
			preventivo_prezzo_lavoro,
			preventivo_costo_lavoro,
			preventivo_totale_ore,
			preventivo_sconto
		) 
		SELECT JobId,
			JobYear,
			SubJobId,
			id_preventivo,
			anno,
			id_revisione,
			posizione AS "lotto_commessa",
			posizione AS "1otto_preventivo",
			@total_price_material,
			@total_cost_material,
			@total_price_work,
			@total_cost_work,
			@total_hours,
			@total_sale
		FROM preventivo_lotto pl
		WHERE id_preventivo = QuoteId 
			AND anno = QuoteYear 
			AND id_revisione = QuoteRevision
			AND posizione = V_lot_id;

	END LOOP;
	CLOSE V_curA;

	UPDATE preventivo SET 
		stato = 7 
	WHERE anno = QuoteYear 
		AND id_preventivo = QuoteId;
	
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobScaleReportProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobScaleReportProduct(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, report_id INT, report_year INT, tab_id INT
)
BEGIN
	DECLARE should_scale TINYINT;
	DECLARE has_ddt_link INT(11);
	DECLARE has_product INT(11);
	DECLARE product_description TEXT;
	DECLARE quantity DECIMAL(11, 2);
	DECLARE quantity_economy DECIMAL(11, 2);
	DECLARE price DECIMAL(11, 2);
	DECLARE cost DECIMAL(11, 2);
	DECLARE discount DECIMAL(11, 2);
	DECLARE hour_price DECIMAL(11, 2);
	DECLARE hour_cost DECIMAL(11, 2);
	DECLARE product_code VARCHAR(16);
	DECLARE supplier_product_code VARCHAR(40);
	DECLARE iva_value INT(11);
	DECLARE inst_time INT(11);
	DECLARE product_tab_id INT(11);
	DECLARE prod_length INT(11);
	DECLARE measure_unit VARCHAR(5);

	SELECT fnc_jobscaleproductsfromreports(job_id, job_year)
		INTO should_scale;

	SELECT COUNT(id_ddt)
		INTO  has_ddt_link
	FROM ddt_rapporto
	WHERE id_rapporto = report_id AND anno_rapporto = report_year;
	
	IF should_scale = 1 AND has_ddt_link = 0  THEN
		SELECT quantità - IFNULL(qeconomia, 0),
			qeconomia,
			Id_materiale,
			descrizione,
			prezzo,
			costo,
			sconto,
			unita_misura
		INTO quantity,
			quantity_economy,
			product_code,
			product_description,
			price,
			cost,
			discount,
			measure_unit
		FROM rapporto_materiale
		WHERE id_rapporto = report_id
			AND anno = report_year
			AND id_tab = tab_id;
			
		IF product_code IS NOT NULL THEN

			SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
				INTO product_tab_id, has_product
			FROM commessa_articoli 
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND codice_articolo = product_code
				AND prezzo = price;

			IF product_tab_id IS NULL
			THEN
				SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
					INTO product_tab_id, has_product
				FROM commessa_articoli 
				WHERE id_commessa = job_id
					AND anno = job_year
					AND id_sottocommessa = sub_job_id
					AND id_lotto = lot_id
					AND codice_articolo = product_code
				LIMIT 1;
			END IF;
				
			IF has_product > 0 then
				UPDATE commessa_articoli
				SET portati = portati + IFNULL(quantity, 0),
					economia = economia + IFNULL(quantity_economy, 0)
				WHERE id_commessa = job_id
					AND anno = job_year
					AND id_sottocommessa = sub_job_id
					AND id_lotto = lot_id
					AND id_tab = product_tab_id;
			ELSE
				SELECT fnc_jobGetVatValueByJob(job_id, job_year, sub_job_id, lot_id) INTO iva_value;
				SELECT fnc_jobGetNextIdTab(job_id, job_year, sub_job_id, lot_id) INTO product_tab_id;
				SELECT fnc_jobGetCostHourByJob(job_id, job_year, sub_job_id, lot_id) INTO hour_cost;
				SELECT fnc_jobGetPriceHourByJob(job_id, job_year, sub_job_id, lot_id) INTO hour_price;

				SELECT codice_fornitore,
					tempo_installazione,
					l
				INTO supplier_product_code,
					inst_time,
					prod_length 
				FROM articolo
				WHERE codice_articolo = product_code;
				
				INSERT INTO commessa_articoli
				SET `id_commessa` = job_id,
					`anno` = job_year,
					`id_sottocommessa` = sub_job_id,
					`descrizione` = product_description,
					`quantità` = quantity,
					`codice_articolo` = product_code,
					`codice_fornitore` = supplier_product_code,
					`UM` = measure_unit,
					`id_tab` = product_tab_id,
					`economia` =  IFNULL(quantity_economy, 0),
					`id_lotto` = lot_id,
					`prezzo` = price,
					`costo` = cost,
					`costo_ora` = hour_cost,
					`tempo` = inst_time,
					`sconto` = discount,
					`prezzo_ora` = hour_price,
					`preventivati` = 0,
					`portati` = quantity,
					`Lunghezza` = prod_length,
					`iva` = iva_value;
			END IF;
		END IF;
			
	END IF;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobScaleDdtProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobScaleDdtProduct(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, ddt_id INT, ddt_year INT, tab_id INT
)
BEGIN
	DECLARE has_product INT(11);
	DECLARE product_description TEXT;
	DECLARE quantity DECIMAL(11, 2);
	DECLARE quantity_economy DECIMAL(11, 2);
	DECLARE price DECIMAL(11, 2);
	DECLARE cost DECIMAL(11, 2);
	DECLARE discount DECIMAL(11, 2);
	DECLARE hour_price DECIMAL(11, 2);
	DECLARE hour_cost DECIMAL(11, 2);
	DECLARE product_code VARCHAR(16);
	DECLARE supplier_product_code VARCHAR(40);
	DECLARE iva_value INT(11);
	DECLARE inst_time INT(11);
	DECLARE product_tab_id INT(11);
	DECLARE prod_length INT(11);
	DECLARE measure_unit VARCHAR(5);
	

	SELECT quantità - IFNULL(economia, 0),
		economia,
		Id_articolo,
		codice_fornitore,
		Desc_breve,
		prezzo,
		costo,
		sconto,
		Unità_misura
	INTO quantity,
		quantity_economy,
		product_code,
		supplier_product_code,
		product_description,
		price,
		cost,
		discount,
		measure_unit
	FROM articoli_ddt
	WHERE id_ddt = ddt_id
		AND anno = ddt_year
		AND numero_tab = tab_id;
		
	IF product_code IS NOT NULL THEN
	
		SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
			INTO product_tab_id, has_product
		FROM commessa_articoli 
		WHERE id_commessa = job_id
			AND anno = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = lot_id
			AND codice_articolo = product_code
			AND prezzo = price;

		IF product_tab_id IS NULL
		THEN
			SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
				INTO product_tab_id, has_product
			FROM commessa_articoli 
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND codice_articolo = product_code
			LIMIT 1;
		END IF;
			
		IF has_product > 0 then
			UPDATE commessa_articoli
			SET portati = portati + IFNULL(quantity, 0),
				economia = economia + IFNULL(quantity_economy, 0)
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND id_tab = product_tab_id;
		ELSE
			SELECT fnc_jobGetVatValueByJob(job_id, job_year, sub_job_id, lot_id) INTO iva_value;
			SELECT fnc_jobGetNextIdTab(job_id, job_year, sub_job_id, lot_id) INTO product_tab_id;
			SELECT fnc_jobGetCostHourByJob(job_id, job_year, sub_job_id, lot_id) INTO hour_cost;
			SELECT fnc_jobGetPriceHourByJob(job_id, job_year, sub_job_id, lot_id) INTO hour_price;

			SELECT 
				tempo_installazione,
				l
			INTO
				inst_time,
				prod_length 
			FROM articolo
			WHERE codice_articolo = product_code;
			
			INSERT INTO commessa_articoli
			SET `id_commessa` = job_id,
				`anno` = job_year,
				`id_sottocommessa` = sub_job_id,
				`descrizione` = product_description,
				`quantità` = quantity,
				`codice_articolo` = product_code,
				`codice_fornitore` = supplier_product_code,
				`UM` = measure_unit,
				`id_tab` = product_tab_id,
				`economia` = IFNULL(quantity_economy, 0),
				`id_lotto` = lot_id,
				`prezzo` = price,
				`costo` = cost,
				`costo_ora` = hour_cost,
				`tempo` = inst_time,
				`sconto` = discount,
				`prezzo_ora` = hour_price,
				`preventivati` = 0,
				`portati` = quantity,
				`Lunghezza` = prod_length,
				`iva` = iva_value;
		END IF;
	END IF;
	
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobUndoScaleReportProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobUndoScaleReportProduct(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, report_id INT, report_year INT, tab_id INT
)
BEGIN
	DECLARE has_product INT(11);
	DECLARE has_ddt_link INT(11);
	DECLARE quantity DECIMAL(11, 2);
	DECLARE quantity_economy DECIMAL(11, 2);
	DECLARE price DECIMAL(11, 2);
	DECLARE product_code VARCHAR(16);
	DECLARE product_tab_id INT(11);

	
	SELECT COUNT(id_ddt)
		INTO  has_ddt_link
	FROM ddt_rapporto
	WHERE id_rapporto = report_id AND anno_rapporto = report_year;
	
	IF has_ddt_link = 0 THEN
		SELECT quantità - IFNULL(qeconomia, 0),
			qeconomia,
			Id_materiale,
			prezzo
		INTO quantity,
			quantity_economy,
			product_code,
			price
		FROM rapporto_materiale
		WHERE id_rapporto = report_id
			AND anno = report_year
			AND id_tab = tab_id;
			
		IF product_code IS NOT NULL THEN

			SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
				INTO product_tab_id, has_product
			FROM commessa_articoli 
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND codice_articolo = product_code
				AND prezzo = price;

			IF product_tab_id IS NULL
			THEN
				SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
					INTO product_tab_id, has_product
				FROM commessa_articoli 
				WHERE id_commessa = job_id
					AND anno = job_year
					AND id_sottocommessa = sub_job_id
					AND id_lotto = lot_id
					AND codice_articolo = product_code
				LIMIT 1;
			END IF;
				
			IF has_product > 0 then
				UPDATE commessa_articoli
				SET portati = portati - IFNULL(quantity, 0),
					economia = economia - IFNULL(quantity_economy, 0)
				WHERE id_commessa = job_id
					AND anno = job_year
					AND id_sottocommessa = sub_job_id
					AND id_lotto = lot_id
					AND id_tab = product_tab_id;
			END IF;
		END IF;
	END IF;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobUndoScaleDdtProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobUndoScaleDdtProduct(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, ddt_id INT, ddt_year INT, tab_id INT
)
BEGIN
	DECLARE has_product INT(11);
	DECLARE quantity DECIMAL(11, 2);
	DECLARE quantity_economy DECIMAL(11, 2);
	DECLARE price DECIMAL(11, 2);
	DECLARE product_code VARCHAR(16);
	DECLARE product_tab_id INT(11);
	

	SELECT quantità  - IFNULL(economia, 0),
		economia,
		Id_articolo,
		prezzo
	INTO quantity,
		quantity_economy,
		product_code,
		price
	FROM articoli_ddt
	WHERE id_ddt = ddt_id
		AND anno = ddt_year
		AND numero_tab = tab_id;
		
	IF product_code IS NOT NULL THEN
	
		SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
			INTO product_tab_id, has_product
		FROM commessa_articoli 
		WHERE id_commessa = job_id
			AND anno = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = lot_id
			AND codice_articolo = product_code
			AND prezzo = price;

		IF product_tab_id IS NULL
		THEN
			SELECT id_tab, IFNULL(COUNT(id_commessa), 0)
				INTO product_tab_id, has_product
			FROM commessa_articoli 
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND codice_articolo = product_code
			LIMIT 1;
		END IF;
			
		IF has_product > 0 then
			UPDATE commessa_articoli
			SET portati = portati - IFNULL(quantity, 0),
				economia = economia - IFNULL(quantity_economy, 0)
			WHERE id_commessa = job_id
				AND anno = job_year
				AND id_sottocommessa = sub_job_id
				AND id_lotto = lot_id
				AND id_tab = product_tab_id;
		END IF;
	END IF;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobUndoScaleDdt;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobUndoScaleDdt(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, ddt_id INT, ddt_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_curA CURSOR FOR SELECT numero_tab
		FROM articoli_ddt
		WHERE id_ddt = ddt_id AND anno = ddt_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesJobUndoScaleDdtProduct(job_id, job_year, sub_job_id, lot_id, ddt_id, ddt_year, V_id_tab);
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobUndoScaleReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobUndoScaleReport(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, report_id INT, report_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_curA CURSOR FOR SELECT Id_tab
		FROM rapporto_materiale
		WHERE id_rapporto = report_id AND anno = report_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesJobUndoScaleReportProduct(job_id, job_year, sub_job_id, lot_id, report_id, report_year, V_id_tab);
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobInitSettings;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobInitSettings(
	job_id INT, job_year INT
)
BEGIN
	INSERT IGNORE INTO commessa_impostazioni
	SELECT job_id,
		job_year,
		tipo,
		valore
	FROM commessa_impostazioni_default;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobScaleDdt;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobScaleDdt(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, ddt_id INT, ddt_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_curA CURSOR FOR SELECT numero_tab
		FROM articoli_ddt
		WHERE id_ddt = ddt_id AND anno = ddt_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesJobScaleDdtProduct(job_id, job_year, sub_job_id, lot_id, ddt_id, ddt_year, V_id_tab);
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobScaleReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobScaleReport(
	job_id INT, job_year INT, sub_job_id INT,
	lot_id INT, report_id INT, report_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_curA CURSOR FOR SELECT Id_tab
		FROM rapporto_materiale
		WHERE id_rapporto = report_id AND anno = report_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesJobScaleReportProduct(job_id, job_year, sub_job_id, lot_id, report_id, report_year, V_id_tab);
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesJobInvoiceLinkGetByInvoice;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobInvoiceLinkGetByInvoice(
	enter_id INT, enter_year INT
)
BEGIN
	SELECT 
		`Id_commessa`,
		`Id_fattura`,
		`anno_fattura`,
		`anno_commessa`,
		`id_sottocommessa`,
		`id_lotto`,
		`tipo`
	FROM commessa_fattura
	WHERE id_fattura = enter_id
		AND anno_fattura = enter_year;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobDdtLinkGetByDdt;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobDdtLinkGetByDdt(
	ddt_id INT, ddt_year INT
)
BEGIN
	SELECT 
		`Id_commessa`,
		`id_ddt`,
		`anno_commessa`,
		`anno_ddt`,
		`id_sottocommessa`,
		`id_lotto`
	FROM commessa_ddt
	WHERE id_ddt = ddt_id
		AND anno_ddt = ddt_year;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobReportLinkGetByReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobReportLinkGetByReport(
	report_id INT, report_year INT
)
BEGIN
	SELECT 
		`Id_commessa`,
		`id_rapporto`,
		`anno_commessa`,
		`anno_rapporto`,
		`id_sottocommessa`,
		`id_lotto`
	FROM commessa_rapporto
	WHERE id_rapporto = report_id
		AND anno_rapporto = report_year;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobInvoiceLinkDeleteByInvoice;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobInvoiceLinkDeleteByInvoice(
	enter_id INT, enter_year INT
)
BEGIN
	DELETE FROM commessa_fattura
	WHERE id_fattura = enter_id
		AND anno_fattura = enter_year;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobDdtLinkDeleteByDdt;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobDdtLinkDeleteByDdt(
	ddt_id INT, ddt_year INT
)
BEGIN
	DELETE FROM commessa_ddt
	WHERE id_ddt = ddt_id
		AND anno_ddt = ddt_year;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobReportLinkDeleteByReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobReportLinkDeleteByReport(
	report_id INT, report_year INT
)
BEGIN
	DELETE FROM commessa_rapporto
	WHERE id_rapporto = report_id
		AND anno_rapporto = report_year;
END $$
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_ariesJobInvoiceLinkInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobInvoiceLinkInsert(
	enter_id INT, enter_year INT, job_id INT, job_year INT, sub_job_id INT, lot_id INT, link_type INT
)
BEGIN
	INSERT INTO commessa_fattura
	SET 
		`Id_commessa` = job_id,
		`Id_fattura` = enter_id,
		`anno_fattura` = enter_year,
		`anno_commessa` = job_year,
		`id_sottocommessa` = sub_job_id,
		`id_lotto` = lot_id,
		`tipo` = link_type;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobDdtLinkInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobDdtLinkInsert(
	ddt_id INT, ddt_year INT, job_id INT, job_year INT, sub_job_id INT, lot_id INT
)
BEGIN
	INSERT INTO commessa_ddt
	SET 
		`Id_commessa` = job_id,
		`id_ddt` = ddt_id,
		`anno_ddt` = ddt_year,
		`anno_commessa` = job_year,
		`id_sottocommessa` = sub_job_id,
		`id_lotto` = lot_id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesJobReportLinkInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobReportLinkInsert(
	report_id INT, report_year INT, job_id INT, job_year INT, sub_job_id INT, lot_id INT
)
BEGIN
	INSERT INTO commessa_rapporto
	SET 
		`Id_commessa` = job_id,
		`id_rapporto` = report_id,
		`anno_rapporto` = report_year,
		`anno_commessa` = job_year,
		`id_sottocommessa` = sub_job_id,
		`id_lotto` = lot_id;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesDdtReportLinkInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDdtReportLinkInsert(
	report_id INT, report_year INT, ddt_id INT, ddt_year INT
)
BEGIN
	INSERT INTO ddt_rapporto
	SET 
		`Id_ddt` = ddt_id,
		`id_rapporto` = report_id,
		`anno_rapporto` = report_year,
		`anno_ddt` = ddt_year;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesDdtReportLinkDeleteByDdt;
DELIMITER $$
CREATE PROCEDURE sp_ariesDdtReportLinkDeleteByDdt(
	ddt_id INT, ddt_year INT
)
BEGIN
	DELETE FROM ddt_rapporto
	WHERE `Id_ddt` = ddt_id AND `anno_ddt` = ddt_year;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobDelete(
	job_id INT, job_year INT
)
BEGIN
	DELETE FROM commessa_articolo_comp
	WHERE id_commessa = job_id AND anno = job_year;

	DELETE FROM commessa_fattura
	WHERE id_commessa = job_id AND anno_commessa = job_year;
	
	DELETE FROM commessa_rapporto
	WHERE id_commessa = job_id AND anno_commessa = job_year;
	
	DELETE FROM commessa_ddt
	WHERE id_commessa = job_id AND anno_commessa = job_year;
	
	DELETE FROM commessa_ddtr
	WHERE id_commessa = job_id AND anno_commessa = job_year;

	UPDATE preventivo p
		INNER JOIN commessa_preventivo cp
			ON p.id_preventivo = cp.preventivo AND p.anno = cp.anno_prev
				AND cp.id_commessa = job_id AND cp.anno = job_year
	SET stato = 1;
	
	DELETE FROM commessa_preventivo
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_riferimento
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_articoli
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_lotto
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_note
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_sotto
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa_impostazioni
	WHERE id_commessa = job_id AND anno = job_year;
	
	DELETE FROM commessa
	WHERE id_commessa = job_id AND anno = job_year;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesSubJobDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesSubJobDelete(
	job_id INT, job_year INT, sub_job_id INT
)
BEGIN
	DELETE FROM commessa_fattura
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id;
	
	DELETE FROM commessa_rapporto
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id;
	
	DELETE FROM commessa_ddt
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id;
	
	DELETE FROM commessa_ddtr
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id;
	
	UPDATE preventivo p
	INNER JOIN commessa_preventivo cp
		ON p.id_preventivo = cp.preventivo AND p.anno = cp.anno_prev
			AND cp.id_commessa = job_id AND cp.anno = job_year
			AND cp.id_sottocommessa = sub_job_id
	SET stato = 1;
	
	DELETE FROM commessa_preventivo
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id;
	
	DELETE FROM commessa_articoli
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id;
	
	DELETE FROM commessa_lotto
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id;

	DELETE FROM commessa_sotto
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sotto = sub_job_id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesJobLotDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesJobLotDelete(
	job_id INT, job_year INT, 
	sub_job_id INT,  lot_id INT
)
BEGIN
	DELETE FROM commessa_fattura
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;
	
	DELETE FROM commessa_rapporto
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;
	
	DELETE FROM commessa_ddt
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;
	
	DELETE FROM commessa_ddtr
	WHERE id_commessa = job_id
		AND anno_commessa = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;

	DELETE FROM commessa_preventivo
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id
		AND lotto = lot_id;
	
	DELETE FROM commessa_articoli
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;

	
	DELETE FROM commessa_lotto
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsReportProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReportProductInsert(
	report_id INT,
	report_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE causal_id INT(11);
	DECLARE report_execution_date DATE;

	SELECT data_esecuzione
	INTO report_execution_date
	FROM rapporto
	WHERE id_rapporto = report_id AND anno = report_year;

	SELECT id_causale
	INTO causal_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = 2;

	CALL sp_ariesDepotOperationsInsert(
		quantity * -1,
		product_code,
		depot_id,
		report_execution_date,
		2,
		causal_id,
		operation_id
	); 

	SET operation_id = LAST_INSERT_ID(); 

	INSERT INTO magazzino_rapporto_materiale (id_operazione, id_rapporto, anno_rapporto, id_tab)
		VALUES (operation_id, report_id, report_year, tab_id);

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsScaleByReportProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsScaleByReportProduct(
	report_id INT, report_year INT, tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16)
)
BEGIN
	DECLARE has_ddt_link BIT(1);
	DECLARE has_depot_link BIT(1);
	DECLARE depot_id INT(11);
	DECLARE operation_id BIGINT(11);
	DECLARE causal_id INT(11);
	DECLARE reso_id INT(11);
	
	SELECT fnc_reportHasDdtLink(report_id, report_year)
		INTO has_ddt_link;

	IF has_ddt_link = 0 THEN
		SELECT
			id_magazzino
		INTO
			depot_id
		FROM rapporto_materiale
		WHERE id_rapporto = report_id
			AND anno = report_year
			AND id_tab = tab_id;
			
		IF product_code IS NOT NULL AND depot_id IS NOT NULL THEN
			CALL sp_ariesDepotsReportProductInsert(report_id, report_year, tab_id, quantity,
				product_code, depot_id);
		END IF;
	END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsReportProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReportProductDelete(
	report_id INT, report_year INT, tab_id INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione
		FROM magazzino_rapporto_materiale
		WHERE id_rapporto = report_id and anno_rapporto = report_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsSupplierInvoiceProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsSupplierInvoiceProductDelete(
	invoice_id INT, invoice_year INT, tab_id INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione
		FROM magazzino_fornfattura
		WHERE id_fattura = invoice_id and anno = invoice_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsInvoiceProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsInvoiceProductDelete(
	invoice_id INT, invoice_year INT, tab_id INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione
		FROM magazzino_fattura
		WHERE id_fattura = invoice_id and anno = invoice_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsUndoScaleByReportProduct;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsUndoScaleByReportProduct(
	report_id INT, report_year INT, tab_id INT
)
BEGIN
	DECLARE has_ddt_link BIT(1);
	DECLARE has_depot_link BIT(1);
	DECLARE quantity DECIMAL(11, 2);
	DECLARE product_code VARCHAR(16);
	DECLARE depot_id INT(11);
	
	SELECT fnc_reportHasDdtLink(report_id, report_year)
		INTO has_ddt_link;

	IF has_ddt_link = 0 THEN
		
		SELECT fnc_reportProductHasDepotLink(report_id, report_year, tab_id)
			INTO has_depot_link;

		IF has_depot_link = 1 THEN

			SELECT quantità,
				Id_materiale,
				id_magazzino
			INTO quantity,
				product_code,
				depot_id
			FROM rapporto_materiale
			WHERE id_rapporto = report_id
				AND anno = report_year
				AND id_tab = tab_id;
				
			IF product_code IS NOT NULL AND depot_id IS NOT NULL THEN
				CALL sp_ariesDepotsReportProductDelete(report_id, report_year, tab_id);
			END IF;
		END IF;
	END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsUndoScaleByReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsUndoScaleByReport(
	report_id INT, report_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_curA CURSOR FOR SELECT Id_tab
		FROM magazzino_rapporto_materiale
		WHERE id_rapporto = report_id AND anno_rapporto = report_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesDepotsUndoScaleByReportProduct(report_id, report_year, V_id_tab);
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesDepotsScaleByReport;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsScaleByReport(
	report_id INT, report_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_id_tab INT;
	DECLARE V_id_materiale INT;
	DECLARE allow_insert BIT(1);
	DECLARE V_curA CURSOR FOR SELECT Id_tab, id_materiale
		FROM rapporto_materiale
		WHERE id_rapporto = report_id AND anno = report_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_id_tab, V_id_materiale;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF V_id_materiale IS NOT NULL THEN
			SELECT  fnc_productAllowDepotsScale(V_id_materiale)
				INTO allow_insert;

			IF allow_insert THEN
				CALL sp_ariesDepotsScaleByReportProduct(report_id, report_year, V_id_tab);
			END IF;
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotsSupplierInvoiceProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsSupplierInvoiceProductInsert(
	invoice_id INT,
	invoice_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE causal_id INT(11);
	DECLARE reso_id INT(11);
	DECLARE doc_date DATE;

	SELECT id_causale,
		reso
	INTO causal_id,
		reso_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = 1;

	SELECT `data`
		INTO doc_date
	FROM fornfattura
	WHERE id_fattura = invoice_id
		AND anno = invoice_year;

	CALL sp_ariesDepotOperationsInsert(
		quantity,
		product_code,
		depot_id,
		doc_date,
		6,
		causal_id,
		operation_id
	);

	INSERT INTO magazzino_fornfattura(id_operazione,anno,id_fattura,id_tab)
		VALUES (operation_id, invoice_year, invoice_id, tab_id);
  
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsInvoiceProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsInvoiceProductInsert(
	invoice_id INT,
	invoice_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE causal_id INT(11);
	DECLARE reso_id INT(11);
	DECLARE doc_date DATE;

	SELECT id_causale,
		reso
	INTO causal_id,
		reso_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = 2;

	SELECT `data`
		INTO doc_date
	FROM fattura
	WHERE id_fattura = invoice_id
		AND anno = invoice_year;

	CALL sp_ariesDepotOperationsInsert(
		quantity * -1,
		product_code,
		depot_id,
		doc_date,
		7,
		causal_id,
		operation_id
	);

	INSERT INTO magazzino_fattura(id_operazione,anno,id_fattura,id_tab)
		VALUES (operation_id, invoice_year, invoice_id, tab_id);

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsReceivedDdtProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReceivedDdtProductInsert(
	ddt_id INT,
	ddt_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE reso_id BIGINT(11);
	
	DECLARE transport_causal_id VARCHAR(10);
	DECLARE causal_id INT(11);
	DECLARE operation_type INT(11);
	DECLARE new_quantity DECIMAL(11, 2);
	DECLARE doc_date DATE;
	DECLARE move_depot_id INT(11);

  -- get document date and transport causal id
	SELECT `data_documento`,
			causale
		INTO doc_date,
			transport_causal_id
	FROM ddt_ricevuti
	WHERE id_ddt = ddt_id
		AND anno = ddt_year;

	-- retrieve operation tpe and other depot id to trasfer if needed ( carico o scarico)
	SELECT operazione,
			ID_MAGA
		INTO operation_type,
			move_depot_id
	FROM causale_trasporto 
	WHERE id_causale = transport_causal_id;

	-- if operation is 2 or 4 it means it need to remove product from depot
	IF (operation_type = 2) OR (operation_type = 4) THEN 
		SET new_quantity = quantity * -1;
	ELSE
		SET new_quantity = quantity;
	END IF;

	-- get depot causal info
	SELECT id_causale,
		reso
	INTO causal_id,
		reso_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = IF(operation_type > 2, operation_type - 2, operation_type);

	-- scale from depot
	CALL sp_ariesDepotOperationsInsert(
		new_quantity,
		product_code,
		depot_id,
		doc_date,
		8,
		causal_id,
		operation_id
	);

	INSERT INTO magazzino_ddt_ricevuti(id_operazione,id_anno,id_ddt,id_tab)
		VALUES (operation_id, ddt_year, ddt_id, tab_id);

	-- IF ooperation type is 3 or 4 we are moving produt between depots, scale from other depot
	IF (operation_type = 3) OR (operation_type = 4) THEN 
		CALL sp_ariesDepotOperationsInsert(
			new_quantity * -1,
			product_code,
			move_depot_id,
			doc_date,
			8,
			causal_id,
			operation_id
		);

		UPDATE magazzino_ddt_ricevuti
		SET id_reso = operation_id
		WHERE id_anno = ddt_year AND id_ddt = ddt_id  AND id_tab = tab_id;
	END IF;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsDdtProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsDdtProductDelete(
	ddt_id INT, ddt_year INT, tab_id INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	DECLARE reso_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione,
			id_reso
		FROM magazzino_ddt_emessi
		WHERE id_ddt = ddt_id and anno_ddt = ddt_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id, reso_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		IF reso_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(reso_id);
		END IF;
		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesSystemsDdtProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesSystemsDdtProductDelete(
	ddt_id INT, ddt_year INT, tab_id INT, product_code VARCHAR(16)
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	DECLARE reso_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione,
			id_reso
		FROM magazzino_ddt_emessi
		WHERE id_ddt = ddt_id and anno_ddt = ddt_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id, reso_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		IF reso_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(reso_id);
		END IF;
		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsReceivedDdtProductDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReceivedDdtProductDelete(
	ddt_id INT, ddt_year INT, tab_id INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE operation_id BIGINT;
	DECLARE reso_id BIGINT;
	
	DECLARE V_curA CURSOR FOR
		SELECT
			id_operazione,
			id_reso
		FROM magazzino_ddt_ricevuti
		WHERE id_ddt = ddt_id and id_anno = ddt_year and id_tab = tab_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO operation_id, reso_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		IF reso_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(reso_id);
		END IF;
		IF operation_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(operation_id);
		END IF;
	END LOOP;
	CLOSE V_curA;
	
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsDdtProductInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsDdtProductInsert(
	ddt_id INT,
	ddt_year INT,
	tab_id INT,
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT
)
BEGIN
	DECLARE operation_id BIGINT(11);
	DECLARE reso_id BIGINT(11);
	
	DECLARE transport_causal_id VARCHAR(10);
	DECLARE causal_id INT(11);
	DECLARE operation_type INT(11);
	DECLARE new_quantity DECIMAL(11, 2);
	DECLARE doc_date DATE;
	DECLARE move_depot_id INT(11);

  -- get document date and transport causal id
	SELECT `data_documento`,
			causale
		INTO doc_date,
			transport_causal_id
	FROM ddt
	WHERE id_ddt = ddt_id
		AND anno = ddt_year;

	-- retrieve operation tpe and other depot id to trasfer if needed ( carico o scarico)
	SELECT operazione,
			ID_MAGA
		INTO operation_type,
			move_depot_id
	FROM causale_trasporto 
	WHERE id_causale = transport_causal_id;

	-- if operation is 2 or 4 it means it need to remove product from depot
	IF (operation_type = 2) OR (operation_type = 4) THEN 
		SET new_quantity = quantity * -1;
	ELSE
		SET new_quantity = quantity;
	END IF;

	-- get depot causal info
	SELECT id_causale,
		reso
	INTO causal_id,
		reso_id
	FROM causale_magazzino
	WHERE tipo_magazzino = depot_id
		AND Operazione = IF(operation_type > 2, operation_type - 2, operation_type);

	-- scale from depot
	CALL sp_ariesDepotOperationsInsert(
			new_quantity,
			product_code,
			depot_id,
			doc_date,
			3,
			causal_id,
			operation_id
		); 
	INSERT INTO magazzino_ddt_emessi(id_operazione, anno_ddt, id_ddt, id_tab)
		VALUES (operation_id, ddt_year, ddt_id, tab_id);

	-- IF ooperation type is 3 or 4 we are moving produt between depots, scale from other depot
	IF (operation_type = 3) OR (operation_type = 4) THEN
		CALL sp_ariesDepotOperationsInsert(
			new_quantity * -1,
			product_code,
			move_depot_id,
			doc_date,
			3,
			causal_id,
			operation_id
		);

		UPDATE magazzino_ddt_emessi
		SET id_reso = operation_id
		WHERE anno_ddt = ddt_year AND id_ddt = ddt_id  AND id_tab = tab_id;
	END IF;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotsReceivedDdtDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotsReceivedDdtDelete(
	ddt_id INT, ddt_year INT
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_operation_id BIGINT(11);
	DECLARE V_reso_id BIGINT(11);
	DECLARE V_curA CURSOR FOR SELECT id_operazione, id_reso
		FROM magazzino_ddt_emessi 
		WHERE id_ddt = ddt_id AND anno_ddt = ddt_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_operation_id, V_reso_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;
		
		CALL sp_ariesDepotOperationsDelete(V_operation_id);
		IF V_reso_id IS NOT NULL THEN
			CALL sp_ariesDepotOperationsDelete(V_reso_id);
		END IF;
	END LOOP;
	CLOSE V_curA;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotOperationsDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotOperationsDelete(
	operation_id INT
)
BEGIN

	DECLARE source_id INT(11);
	DECLARE is_kit BIT(1); 
	DECLARE product_code VARCHAR(16);

	SELECT sorgente
		INTO source_id
	FROM magazzino_operazione
  WHERE magazzino_operazione.id_operazione = operation_id;

	IF source_id IS NOT NULL THEN

		IF source_id = 2 THEN -- rapporto		
			DELETE FROM magazzino_rapporto_materiale
			WHERE id_operazione = operation_id;
		END IF;

		IF source_id = 3 THEN -- ddt		
			-- delete ddt product ref to the operation
			UPDATE magazzino_ddt_emessi
			SET id_reso = NULL
			WHERE id_reso = operation_id;

			DELETE FROM magazzino_ddt_emessi 
			WHERE id_operazione = operation_id;
		END IF;

		IF source_id = 6 THEN -- fattura forn
			-- delete invoice product ref to the operation
			DELETE FROM magazzino_fornfattura 
			WHERE id_operazione = operation_id;
		END IF;

		IF source_id = 7 THEN -- fattura		
			-- delete invoice product ref to the operation
			DELETE FROM magazzino_fattura 
			WHERE id_operazione = operation_id;
		END IF;

		IF source_id = 8 THEN -- ddt ricevuto
			-- delete received ddt product ref to the operation
			UPDATE magazzino_ddt_ricevuti
			SET id_reso = NULL
			WHERE id_reso = operation_id;

			DELETE FROM magazzino_ddt_ricevuti
			WHERE id_operazione = operation_id;
		END IF;
	END IF;

	SET is_kit = fnc_productIsKit(product_code);
	IF is_kit = 1 AND source_id IS NOT NULL THEN
		SET max_sp_recursion_depth = 255;
		CALL sp_ariesDepotOperationsUnscaleKitProducts(operation_id, source_id);
		SET max_sp_recursion_depth = 0;
	END IF;

  DELETE magazzino_operazione
	FROM magazzino_operazione
  WHERE magazzino_operazione.id_operazione = operation_id;
	
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotOperationsInsert;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotOperationsInsert(
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT(11),
	doc_date DATE,
	source_id SMALLINT,
	causal_id INT(11),
	OUT result BIGINT(11)
)
BEGIN

	DECLARE is_kit BIT(1);

	INSERT INTO magazzino_operazione (`Data`, causale, articolo, quantità, id_magazzino, sorgente)
		VALUES (doc_date,  causal_id, product_code, quantity, depot_id, source_id);

	SET result = LAST_INSERT_ID();

	SET is_kit = fnc_productIsKit(product_code);
	IF is_kit = 1 AND source_id IS NOT NULL THEN
		SET max_sp_recursion_depth = 255;
		CALL sp_ariesDepotOperationsScaleKitProducts(
			quantity,
			product_code,
			depot_id,
			source_id,
			doc_date,
		  result,
			causal_id
		);
		SET max_sp_recursion_depth = 0;
	END IF;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotOperationsUpdate;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotOperationsUpdate(
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT(11),
	doc_date DATE,
	causal_id INT(11),
	operation_id INT(11),
	OUT result INT(11)
)
BEGIN

	UPDATE magazzino_operazione 
		SET `Data` = doc_date,
			causale = causal_id,
			articolo = product_code,
			quantità = quantity, 
			id_magazzino = dapot_id
	WHERE id_operazione = operation_id;

	SET result = 1;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotOperationsScaleKitProducts;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotOperationsScaleKitProducts
(
	quantity DECIMAL(11, 2),
	product_code VARCHAR(16),
	depot_id INT(11),
	source_id SMALLINT,
	doc_date DATE,
	kit_operation_id BIGINT(11),
	kit_causal_id INT(11)
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE single_insert_result INT(11);
	DECLARE causal_id INT(11);
	DECLARE kit_depot_operation INT(11);
	DECLARE V_quantity DECIMAL(11,2);
	DECLARE V_product_code VARCHAR(16);
	DECLARE V_curA CURSOR FOR SELECT id_articolo, quantita
		FROM riferimento_kit_articoli
		WHERE id_kit = product_code;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	IF source_id = 1 THEN -- WE WANT TO SCALED ONLY FOR MANUAL OPERATION
		SELECT Operazione
			INTO kit_depot_operation
		FROM causale_magazzino
		WHERE Id_causale = kit_causal_id;
		
		SELECT Id_causale
			INTO causal_id
		FROM causale_magazzino
		WHERE tipo_magazzino = depot_id
			AND operazione = IF(kit_depot_operation = 1, 2, 1);

		OPEN V_curA;
		loopA: LOOP
			FETCH V_curA INTO V_product_code, V_quantity;
			IF done = 1 THEN 
				LEAVE loopA;
			END IF;
			
			CALL sp_ariesDepotOperationsInsert(
				(V_quantity * quantity) * -1,
				v_product_code,
				depot_id,
				doc_date,
				source_id,
				causal_id,
				single_insert_result
			);

			INSERT INTO magazzino_kit_riferimento
			SET Id_operazione_kit = kit_operation_id,
				Id_operazione_articolo = LAST_INSERT_ID();
		END LOOP;
		CLOSE V_curA;
	END IF;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesDepotOperationsUnscaleKitProducts;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotOperationsUnscaleKitProducts
(
	IN kit_operation_id BIGINT(11),
	IN kit_source_id INT(11)
)
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_product_operation_id BIGINT(11);
	DECLARE V_id INT(11);
	DECLARE V_curA CURSOR FOR SELECT id, Id_operazione_articolo
		FROM magazzino_kit_riferimento
		WHERE Id_operazione_kit = kit_operation_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	IF kit_source_id = 1 THEN -- WE WANT TO UNSCALE ONLY FOR MANUAL OPERATION
		OPEN V_curA;
		loopA: LOOP
			FETCH V_curA INTO V_id, V_product_operation_id;
			IF done = 1 THEN 
				LEAVE loopA;
			END IF;
			
			DELETE FROM magazzino_kit_riferimento WHERE Id = V_id;
			DELETE FROM magazzino_operazione WHERE Id_operazione = V_product_operation_id;
		END LOOP;
		CLOSE V_curA;
	END IF;
END $$
DELIMITER ; 

DROP PROCEDURE IF EXISTS ddt_impianto_componenti;
DROP PROCEDURE IF EXISTS sp_ariesSystemsDdtProductInsert;
DELIMITER $$
CREATE  PROCEDURE `sp_ariesSystemsDdtProductInsert`(
	in ddt_id int,
	in ddt_year int,
	in product_code varchar(14),
	IN qt DECIMAL(11,2),
	IN tab_id INT(11),
	IN serial_number VARCHAR(150)
)
BEGIN

	DECLARE int_quantity INT;
	DECLARE system_id INT;
	DECLARE next_component_id INT;
	DECLARE ddt_date DATE;
	DECLARE product_expiration_months INT;
	DECLARE product_warranty_months INT;
	DECLARE customer_type_id INT;

	-- Get ddt informations such as system id, customer type, etc
	SELECT data_documento,
		impianto,
		tipo_cliente
	INTO
		ddt_date,
		system_id,
		customer_type_id
	FROM ddt
		INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente
	WHERE id_ddt=ddt_id and anno=ddt_year;

	-- set a new quantity var to iterate on
	SET int_quantity = ROUND(qt);

	IF (system_id IS NOT NULL) AND (product_code IS NOT NULL) THEN
		
		-- Get product data that we need to use n the next while
		SELECT IFNULL(scadenza, 0),
				IFNULL(garanzia, 0)
			INTO product_expiration_months,
				product_warranty_months
		FROM articolo
		WHERE codice_articolo = product_code;

		WHILE int_quantity > 0 DO
			SELECT
				IF(max(id) IS NOT NULL, max(id+1), 0)
			INTO
				next_component_id
			FROM impianto_componenti
			WHERE id_impianto = system_id
				AND impianto_componenti.id_articolo=product_code;

			INSERT INTO impianto_componenti
			SET id = next_component_id,
				id_impianto = system_id,
				id_articolo = product_code,
				data_scadenza = IF(product_expiration_months = 0, NULL,  ddt_date + INTERVAL product_expiration_months month),
				data_installazione = ddt_date,
				fine_garanzia = ddt_date + INTERVAL if(customer_type_id=1, 1, 2) year,
				checked = 2,
				garanzia_fornitore =  IF(product_warranty_months = 0, NULL,  ddt_date + INTERVAL product_warranty_months month);


			IF (serial_number IS NOT NULL AND serial_number <> "") THEN
				INSERT INTO impianto_componenti_codice
				SET 
					id_impianto = system_id,
					id_articolo = product_code,
					codice = next_component_id,
					seriale = serial_number,
					tipo = 4;
			END IF;


			INSERT INTO impianto_componenti_ddt
			SET id_impianto = system_id,
				id_articolo = product_code,
				codice = next_component_id,
				id_ddt = ddt_id,
				anno = ddt_year,
				id_tab = tab_id;

			SET int_quantity = int_quantity - 1;


		END WHILE;
	END IF;		

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesSystemsDdtProductDelete;
DELIMITER $$
CREATE  PROCEDURE `sp_ariesSystemsDdtProductDelete`(
	in ddt_id int,
	in ddt_year int,
	in product_code varchar(14),
	IN tab_id INT(11)
)
BEGIN
	DELETE 	impianto_componenti 
	FROM 		impianto_componenti 
				INNER JOIN impianto_componenti_ddt ON
					 impianto_componenti.id_articolo=impianto_componenti_ddt.id_articolo
					 AND impianto_componenti_ddt.id_impianto=impianto_componenti.id_impianto
					 AND id=codice
					 AND anno=ddt_year
					 AND id_ddt=ddt_id
					 AND id_tab=tab_id
	WHERE impianto_componenti.id_articolo=product_code; 

	-- Delete system components - ddt associations
	DELETE FROM impianto_componenti_ddt 
	WHERE id_ddt=ddt_id and anno=ddt_year and id_tab=tab_id;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotMovementInOutComing;
DELIMITER $$
CREATE PROCEDURE sp_ariesDepotMovementInOutComing(
	OUT outComing DECIMAL(11, 2),
	OUT inComing DECIMAL(11, 2)
)
BEGIN

END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesQuoteSettingsGet;
DELIMITER $$
CREATE PROCEDURE sp_ariesQuoteSettingsGet()
BEGIN
	SELECT tipo,
		valore
	FROM preventivo_impost;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesQuoteSettingsGetByKey;
DELIMITER $$
CREATE PROCEDURE sp_ariesQuoteSettingsGetByKey(
 IN in_key VARCHAR(100)
)
BEGIN
	SELECT tipo,
		valore
	FROM preventivo_impost
	WHERE tipo = in_key;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesQuoteSettingsDelete;
DELIMITER $$
CREATE PROCEDURE sp_ariesQuoteSettingsDelete()
BEGIN
	DELETE FROM preventivo_impost;
END $$
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesProductSubCategoryGet
DROP PROCEDURE IF EXISTS sp_ariesProductSubCategoryGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSubCategoryGet`(
	IN level_id INT(11)
)
BEGIN
	SELECT `Id_categoria`,
		`id_sottocategoria`,
		id_sottocategoria_padre,
		`Nome`,
		`Descrizione`,
			livello
	FROM vw_product_sub_categories
	WHERE livello = level_id;
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesProductSubCategoryGetByCategory
DROP PROCEDURE IF EXISTS sp_ariesProductSubCategoryGetByCategory;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSubCategoryGetByCategory`(
	IN level_id INT(11),
	IN category_id INT(11)
)
BEGIN
	SELECT `Id_categoria`,
		`id_sottocategoria`,
		id_sottocategoria_padre,
		`Nome`,
		`Descrizione`,
			livello
	FROM vw_product_sub_categories
	WHERE livello = level_id AND id_categoria = category_id;
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesProductSubCategoryGetById
DROP PROCEDURE IF EXISTS sp_ariesProductSubCategoryGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSubCategoryGetById`(
	IN subcategory_id INT(11),
	IN level_id INT(11)
)
BEGIN

	SELECT `Id_categoria`,
		`id_sottocategoria`,
		id_sottocategoria_padre,
		`Nome`,
		`Descrizione`,
			livello
	FROM vw_product_sub_categories
	WHERE livello = level_id
		AND id_sottocategoria = subcategory_id;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesProductSubCategorySearchByName
DROP PROCEDURE IF EXISTS sp_ariesProductSubCategorySearchByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductSubCategorySearchByName`(
	IN level_id INT(11),
	IN name MEDIUMTEXT
)
BEGIN

	SELECT `Id_categoria`,
		`id_sottocategoria`,
		id_sottocategoria_padre,
		`Nome`,
		`Descrizione`,
			livello
	FROM vw_product_sub_categories
	WHERE livello = level_id
		AND Nome Like CONCAT('%', name, '%');
	
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesProductSubCategorySearchByName
DROP PROCEDURE IF EXISTS sp_ariesProductUpdateCategories;
DELIMITER //
CREATE  PROCEDURE `sp_ariesProductUpdateCategories`(
	IN product_code VARCHAR(11),
	IN category_id INT(11),
	IN sub_category_id1 INT(11),
	IN sub_category_id2 INT(11)
)
BEGIN

	UPDATE articolo
	SET Categoria = category_id,
		Sottocategoria = sub_category_id1,
		Sottocategoria2 = sub_category_id2
	WHERE codice_articolo = product_code;
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesReportsGenerateDefaultSessionId
DROP PROCEDURE IF EXISTS sp_ariesReportsGenerateDefaultSessionId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesReportsGenerateDefaultSessionId`(
	OUT result INT(11)
)
BEGIN

	DECLARE supp_date DATE; 
	SET supp_date = DATE_SUB(DATE(now()), INTERVAL  2 day);
	
  DELETE FROM rapporto_tecnico_app WHERE data <= supp_date;
  DELETE FROM rapporto_tecnico_lavoro_app WHERE data <= supp_date;
  DELETE FROM session_rap WHERE data <= supp_date;

  SELECT IFNULL(MAX(id), 0) + 1
		INTO result
	FROM (
		SELECT MAX(id) AS "id" FROM session_rap
		UNION ALL 
		SELECT MAX(id) AS "id" FROM rapporto_tecnico_lavoro_app
		UNION ALL
		SELECT MAX(id) AS "id" FROM rapporto_tecnico_app
	) AS temp;

	INSERT INTO session_rap SET id = result;
	
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerReminderConfigUpdate
DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerReminderConfigUpdate`( 
	IN service_id INT(11), 
	IN interval_type SMALLINT(6), 
	IN interval_value INT(11),
	IN email_subject VARCHAR(150), 
	IN email_body TEXT,
	IN sms_text TEXT,
	IN sms_enabled BIT(1),
	IN email_enabled BIT(1),
	OUT result INTEGER
)
BEGIN

	UPDATE cliente_promemoria_configurazione
	SET
		`Tipo_intervallo` = interval_type,
		`Valore` = interval_value,
		`Oggetto_email` = email_subject,
		`Corpo_email` = email_body,
		Testo_sms = sms_text,
		abilita_sms = sms_enabled,
		abilita_email = email_enabled
	WHERE Id = service_id;
	
	SET result = 1; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerReminderConfigurationGet
DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderConfigurationGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerReminderConfigurationGet`(
)
BEGIN
	SELECT `Id`,
		`Nome`,
		`Tipo_intervallo`,
		`Valore`,
		Oggetto_email, 
		Corpo_email,
		Testo_sms,
		abilita_sms,
		abilita_email,
		Data_ultima_esecuzione,
		`Data_mod`,
		`Utente_mod`
	FROM cliente_promemoria_configurazione;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerReminderGeneralConfigInsert
DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderGeneralConfigInsert;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerReminderGeneralConfigInsert`( 
	IN `in_email_host` VARCHAR(50),
	IN `in_email_username` VARCHAR(50),
	IN `in_email_password` VARCHAR(50),
	IN `in_email_port` INT(11),
	IN `in_email_ssl` BIT(1),
	IN `in_email_from` VARCHAR(50),
	IN `in_sms_host` VARCHAR(50),
	OUT result INTEGER
)
BEGIN
	DECLARE in_sms_endpoint VARCHAR(150) DEFAULT '';
	DECLARE in_sms_password VARCHAR(150) DEFAULT '';

	SELECT sms_endpoint,
		sms_password
	INTO
		in_sms_endpoint,
		in_sms_password
	FROM cliente_promemoria_configurazione_generale
	ORDER BY ID desc
	LIMIT 1;

	SET result = 0;

	INSERT INTO cliente_promemoria_configurazione_generale
	SET
		`Email_host` = in_email_host,
		`Email_username` = in_email_username,
		`Email_password` = in_email_password,
		`Email_port` = in_email_port,
		`Email_ssl` = in_email_ssl,
		`Email_from` = in_email_from,
		`Sms_host` = in_sms_host,
		`Sms_endpoint` = in_sms_endpoint,
		`Sms_password` = in_sms_password,
		`Data_ins` = NOW(),  
		Utente_ins = @USER_ID;
	
	SET Result = LAST_INSERT_ID();

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerReminderGeneralConfigUpdate
DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderGeneralConfigUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerReminderGeneralConfigUpdate`( 
	IN `in_email_host` VARCHAR(50),
	IN `in_email_username` VARCHAR(50),
	IN `in_email_password` VARCHAR(50),
	IN `in_email_port` INT(11),
	IN `in_email_ssl` BIT(1),
	IN `in_email_from` VARCHAR(50),
	IN `in_sms_host` VARCHAR(50),
	IN In_id INT(11),
	OUT result INTEGER
)
BEGIN

	UPDATE cliente_promemoria_configurazione_generale
	SET
		`Email_host` = in_email_host,
		`Email_username` = in_email_username,
		`Email_password` = in_email_password,
		`Email_port` = in_email_port,
		`Email_ssl` = in_email_ssl,
		`Email_from` = in_email_from, 
		`Sms_host` = in_sms_host, 
		`Data_ins` = NOW(),  
		Utente_ins = @USER_ID
	WHERE Id = In_id;
	
	SET result = 1; 

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerReminderGeneralConfigurationGetLast
DROP PROCEDURE IF EXISTS sp_ariesCustomerReminderGeneralConfigurationGetLast;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerReminderGeneralConfigurationGetLast`(
)
BEGIN
	SELECT
		`Id`,
		`Email_host`,
		`Email_username`,
		`Email_password`,
		`Email_port`,
		`Email_ssl`,
		Email_from,
		Sms_host,
		`Data_ins`,
		`Utente_ins`
	FROM cliente_promemoria_configurazione_generale
	ORDER BY Id DESC
	LIMIT 1;
	
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesQuoteLotPdfGetByQuoteLot;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotPdfGetByQuoteLot`(
	IN `quote_id` INT(11),
	IN `quote_year` INT(11),
	IN `quote_review_id` INT(11),
	IN `lot_position` INT(11)
)
BEGIN
	SELECT
		`id`,
		`id_preventivo`,
		`id_revisione`,
		`anno`,
		`posizione_lotto`,
		`posizione`,
		`filepath`,
		`filename`
	FROM preventivo_lotto_pdf
	WHERE id_preventivo = quote_id
		AND id_revisione = quote_review_id
		AND anno = quote_year
		AND posizione_lotto = lot_position;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesQuoteLotPdfGetByQuoteReview;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotPdfGetByQuoteReview`(
	IN `quote_id` INT(11),
	IN `quote_year` INT(11),
	IN `quote_review_id` INT(11)
)
BEGIN
	SELECT
		`id`,
		`id_preventivo`,
		`id_revisione`,
		`anno`,
		`posizione_lotto`,
		`posizione`,
		`filepath`,
		`filename`
	FROM preventivo_lotto_pdf
	WHERE id_preventivo = quote_id
		AND id_revisione = quote_review_id
		AND anno = quote_year;
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesQuoteLotPdfInsertOrUpdate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotPdfInsertOrUpdate`(
	IN `quote_id` INT(11),
	IN `quote_year` INT(11),
	IN `quote_review_id` INT(11),
	IN `lot_position` INT(11),
	IN `in_position` INT(11),
	IN `in_filepath` MEDIUMTEXT,
	IN `in_filename` VARCHAR(250),
	OUT result INT(11)
)
BEGIN

	DECLARE current_id INT(11) DEFAULT NULL;
	
	SELECT id
		INTO current_id
	FROM preventivo_lotto_pdf
	WHERE id_preventivo = quote_id
		AND id_revisione = quote_review_id
		AND anno = quote_year
		AND posizione_lotto = lot_position
		AND posizione = in_position;

	IF current_id IS NULL THEN
		INSERT INTO preventivo_lotto_pdf
		SET id_preventivo = quote_id,
			id_revisione = quote_review_id,
			anno = quote_year,
			posizione_lotto = lot_position,
			posizione = in_position,
			filename = in_filename,
			filepath = in_filepath,
			utente_mod = @USER_ID;
			
		SET current_id = LAST_INSERT_ID(); 
	ELSE
		UPDATE preventivo_lotto_pdf
		SET filename = in_filename,
			filepath = in_filepath,
			utente_mod = @USER_ID
		WHERE id = current_id;
	END IF;

	SET result = current_id;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesQuoteLotPdfDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesQuoteLotPdfDelete`(
	IN `in_id` INT(11)
)
BEGIN

	DELETE FROM preventivo_lotto_pdf
	WHERE Id = in_id;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEInvoiceVersionGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEInvoiceVersionGet`(
)
BEGIN

	SELECT `id_fattura_elettronica_versione`,
		`versione`,
		`codice_versione_pa`,
		`codice_versione_privato`,
		`styles_versione_pa`,
		`local_styles_versione_pa`,
		`styles_versione_privato`,
		`local_styles_versione_privato`,
		`data_inizio`,
		`data_fine`,
		`corrente`,
		`data_mod`
	FROM fattura_elettronica_versione;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEInvoiceVersionGetByDate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesEInvoiceVersionGetByDate`(
		IN `in_date` DATE
)
BEGIN

	SELECT `id_fattura_elettronica_versione`,
		`versione`,
		`codice_versione_pa`,
		`codice_versione_privato`,
		`styles_versione_pa`,
		`local_styles_versione_pa`,
		`styles_versione_privato`,
		`local_styles_versione_privato`,
		`data_inizio`,
		`data_fine`,
		`corrente`,
		`data_mod`
	FROM fattura_elettronica_versione
	WHERE (in_date >= data_inizio) AND (in_date <= data_fine OR data_fine IS NULL);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesVatNatureTypeGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesVatNatureTypeGet`(
		IN `in_include_disabled` BIT(1)
)
BEGIN

	SELECT `id_tipo_natura_iva`,
		`nome`,
		`descrizione`,
		`tipo_PA`,
		`abilitato`,
		`data_mod`
	FROM tipo_natura_iva
	WHERE abilitato = true or (abilitato = false and in_include_disabled = true);

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesVatNatureTypeGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesVatNatureTypeGetById`(
		IN `in_id` INT(11)
)
BEGIN

	SELECT `id_tipo_natura_iva`,
		`nome`,
		`descrizione`,
		`tipo_PA`,
		`abilitato`,
		`data_mod`
	FROM tipo_natura_iva
	WHERE id_tipo_natura_iva = in_id;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesDepotTypeDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeDelete`(
	IN `depot_id` INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	DELETE FROM magazzino_azzera WHERE id_tipo_magazzino = depot_id;
	DELETE FROM magazzino_operazione WHERE id_magazzino = depot_id;
	DELETE FROM magazzino_stored WHERE tipo_magazzino = depot_id;
	DELETE FROM causale_magazzino WHERE tipo_magazzino = depot_id;
	DELETE FROM magazzino WHERE tipo_magazzino = depot_id;
	DELETE FROM tipo_magazzino WHERE Id_tipo = depot_id;
	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
END//
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesDepotTypeDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotTypeDelete`(
	IN `depot_id` INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	
	START TRANSACTION;
	
	DELETE FROM magazzino_azzera WHERE id_tipo_magazzino = depot_id;
	DELETE FROM magazzino_operazione WHERE id_magazzino = depot_id;
	DELETE FROM magazzino_stored WHERE tipo_magazzino = depot_id;
	DELETE FROM causale_magazzino WHERE tipo_magazzino = depot_id;
	DELETE FROM magazzino WHERE tipo_magazzino = depot_id;
	DELETE FROM tipo_magazzino WHERE Id_tipo = depot_id;
	
	SET Result = 1;
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET Result = 0; 
	ELSE
		COMMIT; 
	END IF;
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesJobProductDelete
DROP PROCEDURE IF EXISTS sp_ariesJobProductDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductDelete`(
	IN job_id INT, 
	IN job_year SMALLINT, 
	IN lot_id INT,
	IN sub_job_id INT,
	IN tab_id INT
)
BEGIN

	DECLARE quoted_quantity DECIMAL(11,2);

	SELECT preventivati INTO quoted_quantity
	FROM commessa_articoli
	WHERE Id_commessa = job_id
		AND Anno = job_year
		AND id_sottocommessa = sub_job_id
		AND id_lotto = lot_id
		AND id_tab = tab_id;
		
	DELETE FROM commessa_articolo_comp
	WHERE Id_commessa = job_id
		AND Anno = job_year
		AND id_sottocommessa = sub_job_id
		AND lotto = lot_id
		AND id_dettaglio = tab_id;

	IF (quoted_quantity IS NOT NULL) AND (quoted_quantity > 0) THEN
		UPDATE commessa_articoli
		SET quantità = 0
		WHERE Id_commessa = job_id
			AND Anno = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = lot_id
			AND id_tab = tab_id;
	ELSE
		DELETE FROM commessa_articoli
		WHERE Id_commessa = job_id
			AND Anno = job_year
			AND id_sottocommessa = sub_job_id
			AND id_lotto = lot_id
			AND id_tab = tab_id;
			
	END IF; 

END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesJobProductDelete
DROP PROCEDURE IF EXISTS sp_ariesCustomerMarkAsVaried;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerMarkAsVaried`(
	IN customer_id INT, 
	OUT new_customer_id INT
)
BEGIN

  DECLARE `_rollback` BOOL DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
	

  INSERT INTO clienti(
		Ragione_Sociale, Ragione_sociale2, Partita_iva, Codice_Fiscale, e_codice_destinatario,
		Cortese_attenzione, Data_inserimento, Stato_cliente, Tipo_Cliente, stato_economico,
		condizione_pagamento, Sito_internet, password, Utente_sito, iva, modi, rc, posta, ex, tipo_rapporto,
		id_utente, id_agente, id_abbona, id_attività, pec
	)
	SELECT Ragione_Sociale, Ragione_sociale2, Partita_iva, Codice_Fiscale, e_codice_destinatario,
		Cortese_attenzione, Data_inserimento, Stato_cliente, Tipo_Cliente, stato_economico,
		condizione_pagamento, Sito_internet, password, Utente_sito, iva, modi, rc, posta, ex, 
		tipo_rapporto, @USER_ID, id_agente, id_abbona, id_attività, pec
	FROM clienti
	WHERE id_cliente = customer_id;

	SET new_customer_id = LAST_INSERT_ID();

 
  INSERT INTO destinazione_cliente(
		id_cliente, Id_destinazione, Provincia, Comune, Frazione, Indirizzo, numero_civico, Descrizione, 
		scala, Altro, Km_sede, Pedaggio, Tempo_strada, attivo, ztl, Note, Autostrada, 
		Sede_principale, dalle1, alle1, dalle2, alle2, piano, interno, id_autostrada, Data_ins, Utente_ins, Utente_mod
	)
	SELECT new_customer_id, Id_destinazione, Provincia, Comune, Frazione, Indirizzo, numero_civico, Descrizione,
		scala, Altro, Km_sede, Pedaggio, Tempo_strada, attivo, ztl, Note, Autostrada, 
		Sede_principale, dalle1, alle1, dalle2, alle2, piano, interno, id_autostrada, NOW(), @USER_ID, @USER_ID
	FROM destinazione_cliente
	WHERE id_cliente = customer_id;


  INSERT INTO riferimento_clienti(
		Id_cliente, Id_riferimento, Nome, figura, Telefono, altro_telefono,
		fax, mail, centralino, Fatturazione, titolo, nota_cli, esterno, sito, skype, rif_esterno, sito_utente, sito_passwd,
		mail_pec, riferimento_clienti.mod,idut
	)
	SELECT new_customer_id, Id_riferimento, Nome, figura, Telefono, altro_telefono,
		fax, mail, centralino, Fatturazione, titolo, nota_cli, esterno, sito, skype, rif_esterno, sito_utente, sito_passwd,
		mail_pec, riferimento_clienti.mod, @USER_ID
	FROM riferimento_clienti
	WHERE id_cliente = customer_id;

  INSERT INTO clienti_banche (Id_cliente, Id_filiale, data_inizio, data_fine, Iban)
	select new_customer_id, Id_filiale, data_inizio, data_fine, Iban
	FROM clienti_banche
	WHERE id_cliente = customer_id;

  INSERT INTO cliente_nota (Id_cliente, Id_nota, Descrizione, data_ult_modifica)
	SELECT new_customer_id, Id_nota, Descrizione, data_ult_modifica
	FROM cliente_nota
	WHERE id_cliente = customer_id;

  UPDATE impianto SET id_cliente = new_customer_id WHERE id_cliente = customer_id;
  UPDATE impianto SET id_occupante = new_customer_id WHERE id_occupante = customer_id;
  UPDATE impianto SET id_gestore = new_customer_id WHERE id_gestore = customer_id;


  UPDATE ticket SET id_cliente = new_customer_id WHERE id_cliente = customer_id;


  UPDATE clienti
	SET stato_cliente=(SELECT id_stato FROM stato_clienti WHERE nome="VARIATO")
	WHERE id_cliente = customer_id;

		
	
	IF `_rollback` THEN
	  ROLLBACK;
	  SET new_customer_id = 0; 
	ELSE
		COMMIT; 
	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesTagGet;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTagGet`(
)
BEGIN

	SELECT 
		`id_tag`,
		`tag`,
		`tipo_documento`,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod`
	FROM tag;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesTagSearch;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTagSearch`(
	IN tag_value VARCHAR(250),
	IN document_type INT
)
BEGIN

	SELECT 
		`id_tag`,
		`tag`,
		`tipo_documento`,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod`
	FROM tag
	WHERE tipo_documento = document_type
		AND tag LIKE CONCAT("%", tag_value, "%")
	ORDER BY tag;

END//
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesTagGetByDocumentType;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTagGetByDocumentType`(
	IN document_type INT
)
BEGIN

	SELECT 
		`id_tag`,
		`tag`,
		`tipo_documento`,
		`utente_ins`,
		`utente_mod`,
		`data_ins`,
		`data_mod`
	FROM tag
	WHERE tipo_documento = document_type;

END//
DELIMITER ;




DROP PROCEDURE IF EXISTS sp_ariesCustomerTagGetByCustomer;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerTagGetByCustomer`(
	IN customer_id INT
)
BEGIN
	SELECT 
		`id_cliente`,
		cliente_tag.id_tag,
		tag.tag
	FROM cliente_tag
		INNER JOIN tag ON tag.id_tag = cliente_tag.id_tag
	WHERE id_cliente = customer_id;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesTicketTagGetByTicket;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketTagGetByTicket`(
	IN ticket_id INT,
	IN ticket_year INT
)
BEGIN
	SELECT 
		`id_ticket`,
		anno_ticket,
		ticket_tag.id_tag,
		tag.tag
	FROM ticket_tag
		INNER JOIN tag ON tag.id_tag = ticket_tag.id_tag
	WHERE id_ticket = ticket_id
		AND anno_ticket = ticket_year;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesInvoiceTagGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceTagGetByInvoice`(
	IN invoice_id INT,
	IN invoice_year INT
)
BEGIN
	SELECT 
		`id_fattura`,
		anno_fattura,
		fattura_tag.id_tag,
		tag.tag
	FROM fattura_tag
		INNER JOIN tag ON tag.id_tag = fattura_tag.id_tag
	WHERE id_fattura = invoice_id
		AND anno_fattura = invoice_year;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTagInsert
DROP PROCEDURE IF EXISTS `sp_ariesTagInsert`;
DELIMITER //
CREATE PROCEDURE `sp_ariesTagInsert`(
	IN tag_value VARCHAR(50),
	IN document_type INT(11),
	IN user_id INT(11),
	OUT result INT(11)
)
BEGIN

	INSERT INTO tag
	SET 
		`tag` = tag_value,
		`tipo_documento` = document_type,
		`utente_ins` = user_id,
		`utente_mod` = user_id,
		`data_ins` = NOW(),
		`data_mod` = NOW();


	SET Result = LAST_INSERT_ID(); 

				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTagUpdate
DROP PROCEDURE IF EXISTS sp_ariesTagUpdate;
DELIMITER //
CREATE PROCEDURE `sp_ariesTagUpdate`(
	IN enter_id INT(11),
	IN tag_value VARCHAR(50),
	IN user_id INT(11),
	OUT result INT(11)
)
BEGIN

	UPDATE tag
	SET `tag` = tag_value,
		`utente_mod` = user_id,
		`data_mod` = NOW()
	WHERE id_tag = enter_id;


	SET Result = 1; 
				
END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTagDelete
DROP PROCEDURE IF EXISTS sp_ariesTagDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTagDelete`( 
	enter_id INTEGER
)
BEGIN

	DELETE FROM tag 
	WHERE id_tag = enter_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesTicketTagDeleteByTicket
DROP PROCEDURE IF EXISTS sp_ariesTicketTagDeleteByTicket;
DELIMITER //
CREATE  PROCEDURE `sp_ariesTicketTagDeleteByTicket`( 
	IN ticket_id INT(11),
	IN ticket_year INT(11)
)
BEGIN

	DELETE FROM ticket_tag 
	WHERE id_ticket = ticket_id
		AND anno_ticket = ticket_year;

END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesInvoiceTagDeleteByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoiceTagDeleteByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceTagDeleteByInvoice`( 
	IN invoice_id INT(11),
	IN invoice_year INT(11)
)
BEGIN

	DELETE FROM fattura_tag
	WHERE id_fattura = invoice_id
		AND anno_fattura = invoice_year;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesCustomerTagDeleteByCustomer
DROP PROCEDURE IF EXISTS sp_ariesCustomerTagDeleteByCustomer;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerTagDeleteByCustomer`( 
	IN customer_id INT(11)
)
BEGIN

	DELETE FROM cliente_tag
	WHERE id_cliente = customer_id;

END//
DELIMITER ;


-- Dump della struttura di procedura emmebi.sp_ariesOrderSupplierUnmarkAsComplete
DROP PROCEDURE IF EXISTS sp_ariesOrderSupplierValidate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesOrderSupplierValidate`( 
	enter_id INT, 
	enter_year INT,
	use_current_date BIT,
	OUT result INT(11)
)
BEGIN

	DECLARE creation_date DATE;
	DECLARE new_order_year INT;
	DECLARE new_order_id INT;

	DECLARE V_supplier_id INT;

	DECLARE `_rollback` BOOL DEFAULT 0;
	DECLARE exit_loop BOOLEAN;
	DECLARE order_cursor CURSOR FOR
		SELECT DISTINCT id_fornitore
		FROM ordine_dettaglio
		WHERE id_ordine = enter_id AND anno = enter_year;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;


	IF enter_year = 0 THEN
		
		-- init result to success 
		SET result = 1;

		IF use_current_date = 1 THEN
			SET creation_date = CURDATE();
		ELSE
			SELECT data_creazione INTO creation_date
			FROM ordine_fornitore
			WHERE id_ordine = enter_id AND anno = enter_year;
		END IF;

		-- Get new id-year for validated order
		SET new_order_year = YEAR(creation_date);
		SELECT IFNULL(MAX(id_ordine)+1, 1) INTO new_order_id
		FROM ordine_fornitore
		WHERE anno = new_order_year;

		START TRANSACTION;

			-- Delete inconsistent rows
			DELETE FROM ordine_dettaglio
			WHERE id_ordine = enter_id AND anno = enter_year AND qt = 0;
		
			OPEN order_cursor;
			order_loop: LOOP
				FETCH order_cursor INTO V_supplier_id;
				IF exit_loop = 1 THEN 
					LEAVE order_loop;
				END IF;

				INSERT INTO ordine_fornitore (id_ordine, descrizione, data_ordine, data_creazione, nota_interna, nota,
						id_fornitore, condizione_pagamento, id_utente, data_ultima_modifica, anno, destinazione,
						id_cliente, vettore, porto_reso, trasporto_cura, stato, inviato, stampato)
				SELECT new_order_id,
					descrizione,
					data_ordine,
					creation_date,
					nota_interna,
					nota,
					V_supplier_id,
					condizione_pagamento,
					id_utente,
					data_ultima_modifica, 
					new_order_year,
					destinazione,
					id_cliente,
					vettore,
					porto_reso,
					trasporto_cura,
					1,
					0,
					0
				FROM ordine_fornitore
				WHERE id_ordine = enter_id AND anno = enter_year;

				INSERT INTO ordine_dettaglio(id_ordine, anno, numero_tab, id_Articolo, desc_breve,
					codice_fornitore, id_cliente, id_fornitore, qt, scadenza, prez, tipo, iva,
					id_commessa, anno_commessa, id_sottocommessa, com_lotto)
				SELECT new_order_id,
					new_order_year,
					numero_tab,
					id_Articolo,
					desc_breve,
					codice_fornitore,
					id_cliente,
					NULL,
					qt,
					scadenza,
					prez,
					tipo,
					iva,
					id_commessa,
					anno_commessa,
					id_sottocommessa,
					com_lotto
				FROM ordine_dettaglio
				WHERE id_ordine = enter_id
					AND anno = enter_year
					AND id_fornitore = V_supplier_id;

				SET new_order_id = new_order_id + 1;

			END LOOP order_loop;


			-- Remoove previous order	
			DELETE FROM ordine_dettaglio
			WHERE id_ordine = enter_id
				AND anno = enter_year;

			DELETE FROM ordine_fornitore
			WHERE id_ordine = enter_id
				AND anno = enter_year;


			
		IF `_rollback` THEN
			ROLLBACK;
			SET Result = 0; 
		ELSE
			COMMIT; 
		END IF;
	ELSE
		SET Result = -1; -- Input order year is not zero
	END IF;

END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEnvVariablesGetByKey;
DELIMITER $$
CREATE PROCEDURE sp_ariesEnvVariablesGetByKey(
 IN in_key VARCHAR(100)
)
BEGIN
	SELECT var_key,
		var_value
	FROM environment_variables
	WHERE var_key = in_key;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEnvVariablesUpdate;
DELIMITER $$
CREATE PROCEDURE sp_ariesEnvVariablesUpdate(
 IN in_key VARCHAR(100),
 IN in_value VARCHAR(100)
)
BEGIN
	UPDATE environment_variables
	SET var_value = in_value
	WHERE var_key = in_key;
END $$
DELIMITER ;

-- Dump della struttura di procedura sp_ariesInvoiceAttachsGetByInvoice
DROP PROCEDURE IF EXISTS sp_ariesInvoiceAttachsGetByInvoice;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceAttachsGetByInvoice`(
	IN invoice_id INT(11), 
	IN invoice_year INT(11)
)
BEGIN
	SELECT
		`id`,
		`id_fattura`,
		`Anno_fattura`,
		`Nome` ,
		`Descrizione`,
		`Formato`,
		`File_path`,
		`Timestamp`
	FROM fattura_allegati
	WHERE id_fattura = invoice_id AND Anno_fattura = invoice_year;
END//
DELIMITER ;

-- Dump della struttura di procedura sp_ariesInvoiceAttachsDelete
DROP PROCEDURE IF EXISTS sp_ariesInvoiceAttachsDelete;
DELIMITER //
CREATE  PROCEDURE `sp_ariesInvoiceAttachsDelete`(
	IN input_id INT(11)
)
BEGIN
	DELETE FROM fattura_allegati
	WHERE id = input_id;
END//
DELIMITER ;


-- Dump della struttura di procedura sp_ariesJobProductHistoryCreate
DROP PROCEDURE IF EXISTS sp_ariesJobProductHistoryCreate;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobProductHistoryCreate`(
	IN job_id INT(11),
	IN job_year INT(11),
	IN subjob_id INT(11),
	IN lot_id INT(11),
	IN tab_id INT(11)
)
BEGIN

	DECLARE user_id INT(11);
	SET user_id = @USER_ID;

	IF user_id IS NULL THEN
		SELECT id_utente
		INTO user_id
		FROM utente
		WHERE Nome = 'admin';
	END IF;

	INSERT INTO commessa_articoli_storico (
		`id_commessa`,
		`anno`,
		`id_sottocommessa`,
		`descrizione`,
		`quantità`,
		`codice_articolo`,
		`codice_fornitore`,
		`UM`,
		`id_tab`,
		`economia`,
		`id_lotto`,
		`prezzo`,
		`costo`,
		`costo_ora`,
		`tempo`,
		`sconto`,
		`prezzo_ora`,
		`preventivati`,
		`portati`,
		`Lunghezza`,
		`iva`,
		`id_utente`,
		`timestamp`
	) SELECT `id_commessa`,
		`anno`,
		`id_sottocommessa`,
		`descrizione`,
		`quantità`,
		`codice_articolo`,
		`codice_fornitore`,
		`UM`,
		`id_tab`,
		`economia`,
		`id_lotto`,
		`prezzo`,
		`costo`,
		`costo_ora`,
		`tempo`,
		`sconto`,
		`prezzo_ora`,
		`preventivati`,
		`portati`,
		`Lunghezza`,
		`iva`,
		user_id,
		NOW()
	FROM commessa_articoli
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_sottocommessa = subjob_id
		AND id_lotto = lot_id
		AND id_tab = tab_id;
END//
DELIMITER ;


-- Dump della struttura di procedura sp_ariesCoursesDeleteEvents
DROP PROCEDURE IF EXISTS sp_ariesCoursesDeleteEvents;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCoursesDeleteEvents`(
	IN course_id INT(11),
	OUT result INT(11)
)
BEGIN
	DECLARE event_id INT;
	DECLARE event_group_id INT;
	DECLARE done INT DEFAULT 0;


	DECLARE V_curA CURSOR FOR
		SELECT id_evento
		FROM evento_gruppo_evento
		WHERE id_gruppo_evento = (
			SELECT 
				`id_evento_gruppo`
			FROM corso
			WHERE id_corso = course_id
		);
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO event_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		IF event_id IS NOT NULL THEN
			CALL sp_ariesEventEmployeeDeleteByEventId(event_id, result);
			CALL sp_ariesEventDelete(event_id, result);
		END IF;
	END LOOP;
	CLOSE V_curA;
	
	SELECT 
		`id_evento_gruppo`
	INTO
		event_group_id
	FROM corso
	WHERE id_corso = course_id;
	
	IF event_group_id IS NOT NULL THEN
		CALL sp_ariesEventGroupDelete(event_group_id, result);
		UPDATE corso SET id_evento_gruppo = NULL WHERE id_corso = course_id; 
	END IF;
	
	SET result = 1;
END//
DELIMITER ;


-- Dump della struttura di procedura sp_ariesCoursesCreateEvents
DROP PROCEDURE IF EXISTS sp_ariesCoursesCreateEvents;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCoursesCreateEvents`(
	IN course_id INT(11),
	OUT result INT (11)
)
BEGIN
	DECLARE event_group_id INT;
	DECLARE event_id INT;
	DECLARE resul BIT;
	DECLARE course_description VARCHAR(145);
	DECLARE course_topics MEDIUMTEXT;
	DECLARE course_speaker VARCHAR(45);
	DECLARE course_start_date DATE;
	DECLARE course_end_date DATE;
	DECLARE course_start_time TIME;
	DECLARE course_end_time TIME;
	DECLARE course_duration_months INT;
	DECLARE course_expiration_date DATE;
	DECLARE course_date_loop DATE;

	SELECT 
		corso.`descrizione`,
		corso.`argomenti`,
		corso.`relatore`,
		corso.`data_inizio`,
		corso.`data_fine`,
		corso.`ora_inizio`,
		corso.`ora_fine`,
		tipo_corso.`durata`
	INTO
		course_description,
		course_topics,
		course_speaker,
		course_start_date,
		course_end_date,
		course_start_time,
		course_end_time,
		course_duration_months
	FROM corso
		INNER JOIN tipo_corso ON corso.id_tipo = tipo_corso.id_tipo
	WHERE id_corso = course_id;

	IF (course_duration_months IS NOT NULL AND course_duration_months != 0) THEN

		SET course_expiration_date = DATE_ADD(course_end_date, INTERVAL course_duration_months MONTH);

		CALL sp_ariesEventGroupInsert(
			CONCAT('CORSO: ', course_description),
			CONCAT(
				'CORSO: ', course_description, '\n',
				'RELATORE: ', IFNULL(course_speaker, ''), '\n',
				'ARGOMENTI: ', IFNULL(course_topics, ''), '\n'
			),
			5, 
			1, -- opened 
			CONCAT(course_start_date, ' ', course_start_time),
			CONCAT(course_end_date, ' ', course_end_time),
			null,
			null,
			event_group_id
		);

		CALL sp_ariesEventInsert(
			CONCAT('PROMEM. SCADENZA CORSO 1 MESE', course_description),
			CONCAT('La validità del corso "', course_description, '" scadrà tra un mese.'),
			NULL,
			event_group_id,
			5,
			0,
			0,
			0,
			0,
			DATE_ADD(course_expiration_date, INTERVAL -1 MONTH),
			'09:00:00',
			'10:00:00',
			NULL,
			result,
			event_id
		);
		INSERT INTO evento_operaio (id_evento, id_operaio, Utente_ins, Utente_mod, Data_ins, Data_mod)
		SELECT event_id, id_operaio, @USER_ID, @USER_ID, NOW(), NOW() FROM operaio_corso WHERE id_corso = course_id;

		
		CALL sp_ariesEventInsert(
			CONCAT('PROMEM. SCADENZA CORSO 3 MESI', course_description),
			CONCAT('La validità del corso "', course_description, '" scadrà tra tre mesi.'),
			NULL,
			event_group_id,
			5,
			0,
			0,
			0,
			0,
			DATE_ADD(course_expiration_date, INTERVAL -3 MONTH),
			'09:00:00',
			'10:00:00',
			NULL,
			result,
			event_id
		);
		INSERT INTO evento_operaio (id_evento, id_operaio, Utente_ins, Utente_mod, Data_ins, Data_mod)
		SELECT event_id, id_operaio, @USER_ID, @USER_ID, NOW(), NOW() FROM operaio_corso WHERE id_corso = course_id;

		CALL sp_ariesEventInsert(
			CONCAT('SCADENZA CORSO ', course_description),
			CONCAT('La validità del corso "', course_description, '" è scaduta.'),
			NULL,
			event_group_id,
			5,
			0,
			0,
			0,
			0,
			course_expiration_date,
			'09:00:00',
			'10:00:00',
			NULL,
			result,
			event_id
		);
		INSERT INTO evento_operaio (id_evento, id_operaio, Utente_ins, Utente_mod, Data_ins, Data_mod)
		SELECT event_id, id_operaio, @USER_ID, @USER_ID, NOW(), NOW() FROM operaio_corso WHERE id_corso = course_id;


		SET course_date_loop = course_start_date;

		WHILE(course_date_loop <= course_end_date) DO

			CALL sp_ariesEventInsert(
				CONCAT('CORSO: ', course_description),
				CONCAT(
					'CORSO: ', course_description, '\n',
					'RELATORE: ', IFNULL(course_speaker, ''), '\n',
					'ARGOMENTI: ', IFNULL(course_topics, ''), '\n'
				),
				NULL,
				event_group_id,
				5,
				0,
				0,
				0,
				0,
				course_date_loop,
				course_start_time,
				course_end_time,
				NULL,
				result,
				event_id
			);

			INSERT INTO evento_operaio (id_evento, id_operaio, Utente_ins, Utente_mod, Data_ins, Data_mod)
			SELECT event_id, id_operaio, @USER_ID, @USER_ID, NOW(), NOW() FROM operaio_corso WHERE id_corso = course_id;

			SET course_date_loop = DATE_ADD(course_date_loop, INTERVAL 1 DAY);
		END WHILE;

		UPDATE corso SET id_evento_gruppo = event_group_id WHERE id_corso = course_id; 
	END IF;

	SET result = 1;
END //
DELIMITER ;


-- Dump della struttura di procedura sp_ariesDepotRebuildAll
DROP PROCEDURE IF EXISTS sp_ariesDepotRebuildAll;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDepotRebuildAll`(
	OUT result INT (11)
)
BEGIN
	DECLARE quantity FLOAT(11,2);
	DECLARE product_code VARCHAR(100);
	DECLARE depot_id INT(11);
	DECLARE done INT DEFAULT 0;


	DECLARE V_curA CURSOR FOR
		SELECT `quantità`, articolo, id_magazzino
		FROM magazzino_operazione;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	UPDATE magazzino SET giacenza = 0;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO quantity, product_code, depot_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		UPDATE magazzino
		SET 
			giacenza = giacenza + quantity
		WHERE id_articolo = product_code AND tipo_magazzino = depot_id;
		
	END LOOP;
	CLOSE V_curA;
	
	SET result = 1;
END //
DELIMITER ;


-- Dump della struttura di procedura sp_ariesCoursesUpdateVerification
DROP PROCEDURE IF EXISTS sp_ariesCoursesUpdateVerification;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCoursesUpdateVerification`(
	IN course_id INT (11),
	OUT is_verified BIT(1)
)
BEGIN
	DECLARE current_is_verified BIT(1);
	DECLARE new_is_verified BIT(1) DEFAULT 0;
	DECLARE verification_required BIT (1);

	DECLARE number_of_employees INT(11) DEFAULT 0;
	DECLARE number_of_verified_employees INT(11) DEFAULT 0;

	SELECT richiede_verifica,
		verificato
	INTO
		verification_required,
		current_is_verified
	FROM corso
	WHERE id_corso = course_id;

	IF verification_required = False THEN
		SET new_is_verified = 1;
	ELSE 

		SELECT COUNT(passato),
			SUM(IF(passato = 1, 1, 0))
		INTO
			number_of_employees,
			number_of_verified_employees
		FROM operaio_corso
		WHERE id_corso = course_id;

		SET new_is_verified = (number_of_employees = number_of_verified_employees);

	END IF;

	IF new_is_verified != current_is_verified THEN
		UPDATE corso
		SET verificato = new_is_verified
		WHERE id_corso = course_id;
	END IF;

	SET is_verified = new_is_verified;

END //
DELIMITER ;

-- Dump della struttura di procedura sp_ariesJobLotFindSingle
DROP PROCEDURE IF EXISTS sp_ariesJobLotFindSingle;
DELIMITER //
CREATE  PROCEDURE `sp_ariesJobLotFindSingle`(
	IN job_id INT (11),
	IN job_year INT (11),
	IN lot_id INT (11),
	IN sub_job_id INT (11)
)
BEGIN
	SELECT `id_lotto`,
		`id_commessa`,
		`id_sottocommessa`,
		`anno`,
		`descrizione`,
		`impianto`,
		`numero`,
		`codice`,
		`data_inizio`,
		`data_fine`,
		`scadenza`,
		`stato`,
		`nota`,
		`csora`,
		`prora`,
		`sc`
	FROM commessa_lotto
	WHERE id_commessa = job_id
		AND anno = job_year
		AND id_lotto = lot_id
		AND id_sottocommessa = sub_job_id;
END //
DELIMITER ;


-- Dump della struttura di procedura sp_ariesDefaultLotGetByName
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotGetByName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotGetByName`(
	IN lot_name VARCHAR(255)
)
BEGIN
	SELECT `id_lotto`,
		`nome`,
		`descrizione`,
		`stato`
	FROM lotto
	WHERE nome = lot_name
	ORDER BY id_lotto DESC;
END //
DELIMITER ;


-- Dump della struttura di procedura sp_ariesDefaultLotExclusionGetByLotId
DROP PROCEDURE IF EXISTS sp_ariesDefaultLotExclusionGetByLotId;
DELIMITER //
CREATE  PROCEDURE `sp_ariesDefaultLotExclusionGetByLotId`(
	IN lot_id INT(11)
)
BEGIN
	SELECT `id_lotto`,
		`id_esc`
	FROM lotto_escass
	WHERE id_lotto = lot_id
	ORDER BY id_esc DESC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesSubJobGetByJob;
DELIMITER //
CREATE PROCEDURE `sp_ariesSubJobGetByJob`(
	IN job_id INT(11),
	IN job_year INT(11)
)
BEGIN
	SELECT
		`id_sotto`,
		`id_commessa`,
		`anno`,
		`destinazione`,
		`descrizione`,
		`scadenza`,
		`inizio`,
		`fine`,
		`numero`,
		`codice`,
		`stato`,
		`nome`
	FROM commessa_sotto
	WHERE id_commessa = job_id AND anno = job_year;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesSubJobGetById;
DELIMITER //
CREATE PROCEDURE `sp_ariesSubJobGetById`(
	IN job_id INT(11),
	IN job_year INT(11),
	IN sub_job_id INT(11)
)
BEGIN
	SELECT
		`id_sotto`,
		`id_commessa`,
		`anno`,
		`destinazione`,
		`descrizione`,
		`scadenza`,
		`inizio`,
		`fine`,
		`numero`,
		`codice`,
		`stato`,
		`nome`
	FROM commessa_sotto
	WHERE id_commessa = job_id AND anno = job_year AND id_sotto = sub_job_id;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesReportGroupTotalsRefreshByReport;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportGroupTotalsRefreshByReport`(
	IN report_id INT(11),
	IN report_year INT(11)
)
BEGIN
	DECLARE report_group_id INT(11);
	DECLARE report_group_year INT(11);

	SELECT id_resoconto, anno_reso
	INTO report_group_id, report_group_year
	FROM resoconto_rapporto
	WHERE id_rapporto = report_id
		AND anno = report_year;


	IF report_group_id IS NOT NULL THEN
		CALL sp_ariesReportGroupTotalsRefresh(report_group_id, report_group_year);
	END IF;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesReportGroupTotalsRefresh;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportGroupTotalsRefresh`(
	IN report_group_id INT(11),
	IN report_group_year INT(11)
)
BEGIN

	DECLARE total_trip_price DECIMAL(11,2);
	DECLARE total_trip_cost DECIMAL(11,2);
	DECLARE total_work_price DECIMAL(11,2);
	DECLARE total_work_cost DECIMAL(11,2);
	DECLARE total_products_price DECIMAL(11,2);
	DECLARE total_products_cost DECIMAL(11,2);
	DECLARE total_price DECIMAL(11,2);
	DECLARE total_cost DECIMAL(11,2);
	DECLARE total_maintenance_price DECIMAL(11,2);
	DECLARE total_maintenance_cost DECIMAL(11,2);
	DECLARE right_of_call_cost DECIMAL(11,2);
	DECLARE right_of_call_price DECIMAL(11,2);

	
	SELECT
		SUM(prezzo_manutenzione),
		SUM(costo_manutenzione),
		SUM(costo_diritto_chiamata),
		SUM(prezzo_diritto_chiamata),
		SUM(costo_lavoro),
		SUM(prezzo_lavoro),
		SUM(costo_viaggio),
		SUM(prezzo_viaggio),
		SUM(costo_materiale),
		SUM(prezzo_materiale),
		SUM(costo_totale),
		SUM(prezzo_totale)
	INTO
		total_maintenance_price,
		total_maintenance_cost,
		right_of_call_cost,
		right_of_call_price,
		total_work_cost,
		total_work_price,
		total_trip_cost,
		total_trip_price,
		total_products_cost,
		total_products_price,
		total_cost,
		total_price
	FROM resoconto_rapporto
		LEFT JOIN rapporto_totali ON resoconto_rapporto.id_rapporto = rapporto_totali.id_rapporto and resoconto_rapporto.anno = rapporto_totali.anno
	WHERE resoconto_rapporto.id_resoconto = report_group_id AND anno_reso = report_group_year;



	SET total_maintenance_price = IFNULL(total_maintenance_price, 0);
	SET total_maintenance_cost = IFNULL(total_maintenance_cost, 0);
	SET right_of_call_cost = IFNULL(right_of_call_cost, 0);
	SET right_of_call_price = IFNULL(right_of_call_price, 0);
	SET total_work_cost = IFNULL(total_work_cost, 0);
	SET total_work_price = IFNULL(total_work_price, 0);
	SET total_trip_cost = IFNULL(total_trip_cost, 0);
	SET total_trip_price = IFNULL(total_trip_price, 0);
	SET total_products_cost = IFNULL(total_products_cost, 0);
	SET total_products_price = IFNULL(total_products_price, 0);
	SET total_cost = IFNULL(total_cost, 0);
	SET total_price = IFNULL(total_price, 0);

	UPDATE resoconto_totali
	SET 
		prezzo_manutenzione = total_maintenance_price,
		costo_manutenzione = total_maintenance_cost,
		costo_diritto_chiamata = right_of_call_cost,
		prezzo_diritto_chiamata = right_of_call_price,
		costo_lavoro = total_work_cost,
		prezzo_lavoro = total_work_price,
		costo_viaggio = total_trip_cost,
		prezzo_viaggio = total_trip_price,
		costo_materiale = total_products_cost,
		prezzo_materiale = total_products_price,
		costo_totale = total_cost,
		prezzo_totale = total_price
	WHERE resoconto_totali.id_resoconto = report_group_id AND resoconto_totali.anno = report_group_year;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesReportRestoreStatus;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportRestoreStatus`(
	IN report_id INT(11),
	IN report_year INT(11)
)
main_proc:BEGIN
	DECLARE is_locked_status BIT(1);
	DECLARE invoice_id INT(11);
	DECLARE invoice_year INT(11);
	DECLARE has_job_link BIT(1);
	DECLARE new_status_id INT(11);
	DECLARE status_id INT(11);

	SELECT stato, Fattura, anno_fattura INTO status_id, invoice_id, invoice_year
	FROM Rapporto
	WHERE id_rapporto = report_id AND anno = report_year;

	SELECT bloccato INTO is_locked_status
	FROM stato_rapporto
	WHERE id_stato = status_id;


	IF is_locked_status THEN
		LEAVE main_proc;
	END IF;

	
	
	SELECT fnc_reportHasJobLink(report_id, report_year) INTO has_job_link;

	IF invoice_id > 0 AND invoice_id IS NOT NULL THEN
		IF invoice_year = 0 THEN
			SELECT id_stato INTO new_status_id 
			FROM stato_rapporto
			WHERE nome LIKE "%PREFATTURA"
			LIMIT 1;
		ELSE
			SELECT id_stato INTO new_status_id 
			FROM stato_rapporto
			WHERE nome LIKE "%FATTURATO%"
			LIMIT 1;
		END IF;
	ELSEIF has_job_link THEN
		SELECT id_stato INTO new_status_id 
		FROM stato_rapporto
		WHERE nome LIKE "%COMMESSA%"
		LIMIT 1;
	END IF;


	IF new_status_id IS NULL THEN
		SET new_status_id = 1;
	END IF;
	
	UPDATE rapporto
	SET stato = new_status_id 
	WHERE id_rapporto = report_id AND anno = report_year;

END //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesReportTotalsRefresh;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportTotalsRefresh`(
	IN report_id INT(11),
	IN report_year INT(11)
)
BEGIN
	DECLARE total_maintenance_price DECIMAL(11,2);
	DECLARE total_maintenance_cost DECIMAL(11,2);
	DECLARE total_trip_price DECIMAL(11,2);
	DECLARE total_trip_cost DECIMAL(11,2);
	DECLARE total_work_price DECIMAL(11,2);
	DECLARE total_work_cost DECIMAL(11,2);
	DECLARE total_products_price DECIMAL(11,2);
	DECLARE total_products_cost DECIMAL(11,2);
	DECLARE total_price DECIMAL(11,2);
	DECLARE total_cost DECIMAL(11,2);
	DECLARE default_hourly_price DECIMAL(11, 2);
	DECLARE default_hourly_cost DECIMAL(11, 2);
	DECLARE default_hourly_cost_extra DECIMAL(11, 2);
	DECLARE default_km_cost DECIMAL(11,2);
	DECLARE right_of_call_chargeable BIT(1);
	DECLARE right_of_call_cost DECIMAL(11,2);
	DECLARE right_of_call_price DECIMAL(11,2);
	DECLARE is_under_warranty BIT(1);
	DECLARE is_price_predefined BIT(1);

	SELECT costo_h, straordinario_c, costo_km, prezzo
		INTO default_hourly_cost, default_hourly_cost_extra, default_km_cost, default_hourly_price
	FROM tariffario
	ORDER BY normale DESC
	LIMIT 1;

	SELECT fnc_reportIsRightOfCallChargeable(report_id, report_year) INTO right_of_call_chargeable;

	IF right_of_call_chargeable THEN
		SELECT
			CAST(
				IFNULL(IF(rapporto.tipo_diritto_chiamata = 1, abbonamento.diritto_chiamata, abbonamento.diritto_chiamata_straordinario), 0)
			AS DECIMAL(10, 2)),
			CAST(
				ROUND(IFNULL(IF(rapporto.tipo_diritto_chiamata = 1, abbonamento.diritto_chiamata, abbonamento.diritto_chiamata_straordinario), 0) / 2, 2)
			AS DECIMAL(10, 2))
		INTO right_of_call_price,
			right_of_call_cost
		FROM rapporto
			LEFT JOIN abbonamento ON id_abbonamento=abbonamento
		WHERE rapporto.id_rapporto = report_id AND rapporto.anno = report_year ;
	ELSE
		SET right_of_call_cost = 0;
		SET right_of_call_price = 0;
	END IF;

	SELECT
		controllo_periodico * controllo_periodico_quantita,
		controllo_periodico_costo * controllo_periodico_quantita
	INTO
		total_maintenance_price,
		total_maintenance_cost
	FROM rapporto
	WHERE id_rapporto = report_id AND anno = report_year;
	

	SELECT SUM(CAST(ROUND(IFNULL(ora_normale, 0) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'prezzo_lavoro',
		SUM(CAST(ROUND(IF(straordinario = 1, IFNULL(straordinario_c, default_hourly_cost_extra), IFNULL(costo_h, default_hourly_cost)) * (totale / 60), 2) AS DECIMAL(10, 2))) as 'costo_lavoro'
		INTO total_work_price, total_work_cost
	FROM rapporto_tecnico_lavoro
		INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico_lavoro.tecnico
		LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
	WHERE id_rapporto = report_id AND anno = report_year
	GROUP BY id_rapporto, anno;


	SELECT SUM(CAST(ROUND((km * IFNULL(costo_km, default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (Tempo_viaggio/ 60 * IFNULL(costo_h, default_hourly_cost)), 2) AS DECIMAL(11,2))) as costo_viaggio,
		SUM(CAST(ROUND((km * IFNULL(IFNULL(prezzo_strada, costo_km), default_km_cost)) + autostrada + parcheggio + spesa_trasferta + altro + (Tempo_viaggio/ 60 *  IFNULL(IFNULL(abbonamento.ora_normale, prezzo), default_hourly_price)), 2) AS DECIMAL(11,2))) as prezzo_viaggio
		INTO total_trip_cost, total_trip_price
	FROM rapporto_tecnico
		INNER JOIN operaio ON operaio.Id_operaio = rapporto_tecnico.tecnico
		LEFT JOIN tariffario ON operaio.Tariffario = tariffario.Id_tariffario
		INNER JOIN rapporto ON rapporto.id_rapporto=rapporto_tecnico.id_rapporto AND rapporto.anno=rapporto_tecnico.anno
		LEFT JOIN abbonamento ON id_abbonamento=abbonamento
	WHERE rapporto_tecnico.id_rapporto = report_id AND rapporto_tecnico.anno = report_year
	GROUP BY rapporto_tecnico.id_rapporto, rapporto_tecnico.anno;

	SELECT SUM(CAST(ROUND(ROUND(IFNULL(prezzo, 0) * (100 - IFNULL(sconto, 0)) / 100, 2) * IFNULL(quantità, 0), 2)  AS DECIMAL(11, 2))) as Prezzo_materiale,
		SUM(CAST(ROUND(ROUND(IFNULL(costo, 0), 2) * IFNULL(quantità, 0), 2)  AS DECIMAL(11, 2))) as Costo_materiale
		INTO total_products_price,
		total_products_cost
	FROM rapporto_materiale
	WHERE id_rapporto = report_id AND anno = report_year
	GROUP BY id_rapporto, anno;

	SET total_work_cost = IFNULL(total_work_cost, 0);
	SET total_work_price = IFNULL(total_work_price, 0);
	SET total_trip_cost = IFNULL(total_trip_cost, 0);
	SET total_trip_price = IFNULL(total_trip_price, 0);
	SET total_products_cost = IFNULL(total_products_cost, 0);
	SET total_products_price = IFNULL(total_products_price, 0);
	SET right_of_call_cost = IFNULL(right_of_call_cost, 0);
	SET right_of_call_price = IFNULL(right_of_call_price, 0);
	SET total_maintenance_price = IFNULL(total_maintenance_price, 0);
	SET total_maintenance_cost = IFNULL(total_maintenance_cost, 0);
	SET total_cost = total_work_cost + total_trip_cost + total_products_cost + right_of_call_cost * total_maintenance_cost;
	SET total_price = total_work_price + total_trip_price + total_products_price + right_of_call_price + total_maintenance_price;

	UPDATE rapporto_totali
	SET 
			prezzo_manutenzione = total_maintenance_price,
			costo_manutenzione = total_maintenance_cost,
			prezzo_diritto_chiamata = right_of_call_price,
			costo_diritto_chiamata = right_of_call_cost,
			costo_lavoro = total_work_cost,
			prezzo_lavoro = total_work_price,
			costo_viaggio = total_trip_cost,
			prezzo_viaggio = total_trip_price,
			costo_materiale = total_products_cost,
			prezzo_materiale = total_products_price,
			costo_totale = total_cost,
			prezzo_totale = total_price
	WHERE id_rapporto = report_id AND anno = report_year;

END //
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesCustomerStatusGetById
DROP PROCEDURE IF EXISTS sp_ariesCustomerStatusGetById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesCustomerStatusGetById`(
	status_id VARCHAR(10)
)
BEGIN

	SELECT Id_stato,
		nome,
		descrizione,
		bloccato
	FROM stato_clienti
	WHERE Id_stato = status_id; 
	
END//
DELIMITER ;



-- Dump della struttura di procedura emmebi.sp_ariesServiceUserGetByAppName
DROP PROCEDURE IF EXISTS sp_ariesServiceUserGetByAppName;
DELIMITER //
CREATE  PROCEDURE `sp_ariesServiceUserGetByAppName`(
	record_app_name VARCHAR(60)
)
BEGIN

	SELECT
		`id`,
		`nome`,
		`app_name`,
		`email`,
		`firma`,
		`smtp`,
		`porta`,
		`mssl`,
		`email_username`,
		`email_password`,
		`display_name`
	FROM utente_servizio
	WHERE utente_servizio.app_name = record_app_name; 
	
END//
DELIMITER ;

-- Dump della struttura di procedura emmebi.sp_ariesGetCustomerTypeById
DROP PROCEDURE IF EXISTS sp_ariesGetCustomerTypeById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetCustomerTypeById`(
	type_id VARCHAR(60)
)
BEGIN

	SELECT
		`id_tipo`,
		`nome`,
		`descrizione`
	FROM tipo_cliente
	WHERE id_tipo = type_id; 
	
END//
DELIMITER ;




-- Dump della struttura di procedura emmebi.sp_ariesGetCustomerRelationTypeById
DROP PROCEDURE IF EXISTS sp_ariesGetCustomerRelationTypeById;
DELIMITER //
CREATE  PROCEDURE `sp_ariesGetCustomerRelationTypeById`(
	type_id VARCHAR(60)
)
BEGIN

	SELECT
		`id_tipo`,
		`nome`,
		`descrizione`
	FROM tipo_rapclie
	WHERE id_tipo = type_id; 
	
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesSystemCurrentSubscriptionRefresh;
DELIMITER //
CREATE  PROCEDURE `sp_ariesSystemCurrentSubscriptionRefresh`(
	system_id INT(11)
)
BEGIN

	DECLARE default_subscription_id INT(11);
	DECLARE last_system_subscription_id INT(11);

	SELECT id_abbonamento
	INTO default_subscription_id
	FROM abbonamento
	WHERE generale = 1
	ORDER BY anno DESC
	LIMIT 1;

	SELECT id_abbonamenti
	INTO last_system_subscription_id
	FROM impianto_abbonamenti
	WHERE id_impianto = system_id
	ORDER BY anno DESC
	LIMIT 1;

	UPDATE impianto
	SET abbonamento = IFNULL(last_system_subscription_id, default_subscription_id)
	WHERE id_impianto = system_id;
	
END//
DELIMITER ;


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

DROP PROCEDURE IF EXISTS sp_ariesSystemsExpirationsCounter;
DELIMITER //
CREATE PROCEDURE sp_ariesSystemsExpirationsCounter (
	IN start_date DATE,
	IN end_date DATE,
	IN system_id INT,
	IN customer_id INT,
	IN entity_type VARCHAR(100),
	IN reminder_status VARCHAR(20) -- sent, to_be_sent, to_handle
)
BEGIN
	SELECT COUNT(*)
	FROM vw_systems_expirations_summary
	WHERE
		data_scadenza >= iFNULL(start_date, '1970-01-01') 
		AND data_scadenza <= iFNULL(end_date, '2100-01-01') 
		AND id_impianto = iFNULL(system_id, id_impianto) 
		AND id_cliente = iFNULL(customer_id, id_cliente)
		AND tipo_entita = iFNULL(entity_type, tipo_entita)
		AND IF(reminder_status = 'to_handle', richiedi_invio_promemoria = false, True)
		AND IF(reminder_status = 'to_be_sent', richiedi_invio_promemoria = true AND data_promemoria > CURRENT_DATE, True)
		AND IF(reminder_status = 'sent', data_promemoria <= CURRENT_DATE AND data_ultimo_promemoria IS NOT NULL, True)
		AND IF(reminder_status = 'handled', data_promemoria IS NOT NULL, True);
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesSystemsExpirationsSearch;
DELIMITER //
CREATE PROCEDURE sp_ariesSystemsExpirationsSearch (
	IN start_date DATE,
	IN end_date DATE,
	IN system_id INT,
	IN customer_id INT,
	IN entity_type VARCHAR(100),
	IN reminder_status VARCHAR(20) -- sent, to_be_sent, handled, to_handle
)
BEGIN
	SELECT 
		ses.id_riferimento,
		tipo_entita,
		tipo_scadenza,
		ses.id_impianto,
		ses.id_cliente,
		clienti.ragione_sociale,
		Stato_clienti.Nome AS "stato_cliente",
		Tipo_impianto.nome AS "tipo_impianto",
		stato_impianto.Nome AS "stato_impianto",
		ses.descrizione,
		data_scadenza,
		richiedi_invio_promemoria,
		data_promemoria,
		data_ultimo_promemoria,
		quantita,
		CONCAT(CONCAT(dc.indirizzo,' n.',dc.numero_civico, dc.altro),' - ',concat(IF(f.nome IS NOT NULL AND f.nome <> '', concat(f.nome,' di '), ''), c.nome,' (',c.provincia,')')) AS 'Indirizzo',
		CONCAT(c.nome,' (',c.provincia,')') AS 'citta',
		dc.Km_sede AS "km_viaggio",
		dc.Tempo_strada AS tempo_viaggio,
		rc.id_riferimento AS id_riferimento_promemoria,
		CONCAT(rc.nome, ' - ', rc.mail, '/', rc.altro_telefono) AS riferimento_promemoria
	FROM vw_systems_expirations_summary AS ses
		INNER JOIN impianto ON ses.id_impianto = impianto.Id_impianto
		INNER JOIN clienti ON ses.Id_cliente = clienti.Id_cliente
		INNER JOIN stato_impianto ON impianto.Stato = stato_impianto.Id_stato
		INNER JOIN tipo_impianto ON impianto.Tipo_impianto = tipo_impianto.Id_tipo
		INNER JOIN stato_clienti ON clienti.Stato_cliente = stato_clienti.Id_stato
		INNER JOIN destinazione_cliente AS dc ON dc.id_cliente = ses.id_cliente
			AND impianto.destinazione = dc.Id_destinazione
		INNER JOIN comune AS c ON c.id_comune=dc.Comune
		LEFT JOIN frazione AS f ON f.id_frazione=dc.frazione
		LEFT JOIN riferimento_clienti AS rc ON rc.id_cliente=ses.id_cliente AND Promemoria_cliente=1
	WHERE
		ses.data_scadenza >= iFNULL(start_date, CAST('1970-01-01' AS DATE)) 
		AND ses.data_scadenza <= iFNULL(end_date, CAST('2100-01-01' AS DATE)) 
		AND ses.id_impianto = iFNULL(system_id, ses.id_impianto) 
		AND ses.id_cliente = iFNULL(customer_id, ses.id_cliente)
		AND ses.tipo_entita = iFNULL(entity_type, CAST(ses.tipo_entita AS CHAR(100)))
		AND IF(reminder_status = 'to_handle', richiedi_invio_promemoria = false AND data_ultimo_promemoria IS NULL, True)
		AND IF(reminder_status = 'to_be_sent', richiedi_invio_promemoria = true AND data_promemoria > CURRENT_DATE, True)
		AND IF(reminder_status = 'sent', data_promemoria <= CURRENT_DATE AND data_ultimo_promemoria IS NOT NULL, True)
		AND IF(reminder_status = 'handled', data_promemoria IS NOT NULL, True)
	ORDER BY data_scadenza DESC;
END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesSystemsExpirationsEntityTypes;
DELIMITER //
CREATE PROCEDURE sp_ariesSystemsExpirationsEntityTypes ()
BEGIN
	SELECT 
		tipo_entita,
		tipo_scadenza AS descrizione
	FROM vw_systems_expirations_summary AS ses
	GROUP BY tipo_entita
	ORDER BY tipo_scadenza DESC;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesSystemsExpirationsSetReminderInfo;
DELIMITER //
CREATE PROCEDURE sp_ariesSystemsExpirationsSetReminderInfo (
	IN reference_id INT,
	IN entity_type VARCHAR(100),
	IN system_id INT,
	IN require_reminder_to_be_sent BIT,
	IN reminder_send_date DATETIME,
	IN contact_id INT
)
BEGIN
	DECLARE product_code VARCHAR(100);
	DECLARE expiration_date DATE;

	UPDATE riferimento_clienti
	SET promemoria_cliente = 1
	WHERE id = contact_id;

	if entity_type = 'ticket_expiration' THEN
		
		UPDATE Ticket
		SET richiedi_invio_promemoria = require_reminder_to_be_sent,
			data_promemoria = CAST(reminder_send_date AS DATE)
		WHERE Id = reference_id;

	ELSEIF entity_type = 'system_sim_expiration' THEN
		
		UPDATE impianto_ricarica_tipo
		SET richiedi_invio_promemoria = require_reminder_to_be_sent,
			data_promemoria = reminder_send_date
		WHERE id = reference_id;

	ELSEIF entity_type = 'system_sim_renew' THEN
			
		UPDATE impianto_ricarica_tipo
		SET richiedi_invio_promemoria = require_reminder_to_be_sent,
			data_promemoria = reminder_send_date
		WHERE id = reference_id;

	ELSEIF entity_type = 'system_maintenance_month' THEN
			
		UPDATE impianto_abbonamenti_mesi
		SET richiedi_invio_promemoria = require_reminder_to_be_sent,
			data_promemoria = reminder_send_date
		WHERE id = reference_id;

	ELSEIF entity_type = 'system_warrantzy' THEN
			
		UPDATE impianto
		SET richiedi_invio_promemoria_garanzia = require_reminder_to_be_sent,
			data_promemoria_garanzia = reminder_send_date
		WHERE id_impianto = reference_id;

	ELSEIF entity_type = 'systems_components' THEN	
		
		SELECT Id_articolo, Data_scadenza
			INTO product_code, expiration_date
		FROM impianto_componenti
		WHERE id_impianto = system_id
			AND id_impianto_componenti = reference_id;

		UPDATE impianto_componenti
		SET richiedi_invio_promemoria = require_reminder_to_be_sent,
			data_promemoria = reminder_send_date
		WHERE id_impianto = system_id
			AND Id_articolo = product_code
			AND Data_scadenza = expiration_date;

	END IF;


END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesTicketEnsureReminderEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesTicketEnsureReminderEvent (
	IN ticket_id INT,
	IN ticket_year INT,
	IN system_id INT,
	IN customer_id INT,
	IN urgency_id INT,
	IN reminder_date DATE,
	IN reminder_event_id INT,
	IN expiration_date DATE,
	IN expiration_event_id INT,
	IN ticket_description TEXT,
	OUT event_id INT(11)
)
BEGIN
	DECLARE event_group_id INT(11);
	DECLARE urgency VARCHAR(50);
	DECLARE customer_name VARCHAR(250);
	DECLARE phone_number VARCHAR(250);
	DECLARE email VARCHAR(250);
	DECLARE system_description TEXT;
	DECLARE event_description TEXT;
	DECLARE event_subject TEXT;

	SET event_id = reminder_event_id;

	SELECT
		ragione_sociale,
		IFNULL(telefono, altro_telefono),
		mail
	INTO
		customer_name,
		phone_number,
		email
	FROM clienti 
		INNER JOIN riferimento_clienti
			ON clienti.id_cliente = riferimento_clienti.id_cliente AND id_riferimento = 1
	WHERE clienti.id_cliente = customer_id;

	SELECT
		impianto.descrizione
	INTO
		system_description
	FROM impianto
	WHERE id_impianto = system_id;

	SELECT
		IFNULL(urgenza.nome, 'NESSUNA')
	INTO
		urgency
	FROM urgenza
	WHERE id_urgenza = urgency_id;


	SELECT 
		evento_gruppo.id
	INTO
		event_group_id
	FROM evento_gruppo
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_promemoria ON evento_gruppo_evento_promemoria.id_evento = reminder_event_id
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_scadenza ON evento_gruppo_evento_scadenza.id_evento = expiration_event_id
	WHERE evento_gruppo.id IN (evento_gruppo_evento_promemoria.id_gruppo_evento, evento_gruppo_evento_scadenza.id_gruppo_evento);


	IF event_group_id IS NULL THEN
		INSERT INTO evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA TICKET ', ticket_id, '/', ticket_year),
			descrizione = CONCAT(
				'TICKET: ', ticket_description, '\n',
				'CLIENTE: ', IFNULL(customer_name, ''), '\n',
				'IMPIANTO: ', IFNULL(system_description, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			data_ora_fine = CONCAT(GREATEST(reminder_date, expiration_date), ' ', '20:00:00'),
			Data_ins = NOW(),
			Data_mod = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
		
 		SELECT LAST_INSERT_ID() INTO event_group_id;

	ELSE
		UPDATE evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA TICKET ', ticket_id, '/', ticket_year),
			descrizione = CONCAT(
				'TICKET: ', ticket_description, '\n',
				'CLIENTE: ', IFNULL(customer_name, ''), '\n',
				'IMPIANTO: ', IFNULL(system_description, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			Data_mod = NOW(),
			Utente_mod = @USER_ID
		WHERE id = event_group_id;

	END IF;

	
	SET event_subject = CONCAT('PROMEMORIA TICKET ', ticket_id, '/', ticket_year);
	SET event_description = CONCAT(
		'TICKET: ', ticket_description, '\n',
		'CLIENTE: ', IFNULL(customer_name, ''), '\n',
		'IMPIANTO: ', IFNULL(system_description, ''), '\n',
		'URGENZA: ', IFNULL(urgency, ''), '\n',
		'TELEFONO: ', IFNULL(phone_number, ''), '\n',
		'EMAIL: ', IFNULL(email, ''), '\n'
	);

	IF event_id IS NULL THEN
		INSERT INTO Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Id_riferimento = NULL, 
			id_tipo_evento = 60, 
			Eseguito = 0, 
			Ricorrente = 0,
			giorni_ricorrenza = 0,
			Data_esecuzione = reminder_date, 
			Sveglia = 0, 
			Data_sveglia = '1970-01-01 00:00:00',
			Ora_inizio_esecuzione = '09:00:00',
			ora_fine_esecuzione = '10:00:00',
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID;
			
 		SELECT LAST_INSERT_ID() INTO event_id;
		
		INSERT INTO Evento_gruppo_evento (Id_evento, Id_gruppo_evento, Tipo_associazione, Timestamp)
			VALUES (event_id, event_group_id, 1, CURRENT_TIMESTAMP);
	ELSE
		UPDATE Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Data_esecuzione = reminder_date, 
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
	END IF;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesTicketEnsureExpirationEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesTicketEnsureExpirationEvent (
	IN ticket_id INT,
	IN ticket_year INT,
	IN system_id INT,
	IN customer_id INT,
	IN urgency_id INT,
	IN reminder_date DATE,
	IN reminder_event_id INT,
	IN expiration_date DATE,
	IN expiration_event_id INT,
	IN ticket_description TEXT,
	OUT event_id INT(11)
)
BEGIN
	DECLARE event_group_id INT(11);
	DECLARE urgency VARCHAR(50);
	DECLARE customer_name VARCHAR(250);
	DECLARE phone_number VARCHAR(250);
	DECLARE email VARCHAR(250);
	DECLARE system_description TEXT;
	DECLARE event_description TEXT;
	DECLARE event_subject TEXT;

	SET event_id = expiration_event_id;

	SELECT
		ragione_sociale,
		IFNULL(telefono, altro_telefono),
		mail
	INTO
		customer_name,
		phone_number,
		email
	FROM clienti 
		INNER JOIN riferimento_clienti
			ON clienti.id_cliente = riferimento_clienti.id_cliente AND id_riferimento = 1
	WHERE clienti.id_cliente = customer_id;

	SELECT
		impianto.descrizione
	INTO
		system_description
	FROM impianto
	WHERE id_impianto = system_id;

	SELECT
		IFNULL(urgenza.nome, 'NESSUNA')
	INTO
		urgency
	FROM urgenza
	WHERE id_urgenza = urgency_id;


	SELECT 
		evento_gruppo.id
	INTO
		event_group_id
	FROM evento_gruppo
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_promemoria ON evento_gruppo_evento_promemoria.id_evento = reminder_event_id
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_scadenza ON evento_gruppo_evento_scadenza.id_evento = expiration_event_id
	WHERE evento_gruppo.id IN (evento_gruppo_evento_promemoria.id_gruppo_evento, evento_gruppo_evento_scadenza.id_gruppo_evento);


	IF event_group_id IS NULL THEN
		INSERT INTO evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA TICKET ', ticket_id, '/', ticket_year),
			descrizione = CONCAT(
				'TICKET: ', ticket_description, '\n',
				'CLIENTE: ', IFNULL(customer_name, ''), '\n',
				'IMPIANTO: ', IFNULL(system_description, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			data_ora_fine = CONCAT(GREATEST(reminder_date, expiration_date), ' ', '20:00:00'),
			Data_ins = NOW(),
			Data_mod = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
		
 		SELECT LAST_INSERT_ID() INTO event_group_id;

	ELSE
		UPDATE evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA TICKET ', ticket_id, '/', ticket_year),
			descrizione = CONCAT(
				'TICKET: ', ticket_description, '\n',
				'CLIENTE: ', IFNULL(customer_name, ''), '\n',
				'IMPIANTO: ', IFNULL(system_description, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			Data_mod = NOW(),
			Utente_mod = @USER_ID
		WHERE id = event_group_id;

	END IF;
	
	SET event_subject = CONCAT('SCADENZA TICKET ', ticket_id, '/', ticket_year);
	SET event_description = CONCAT(
		'TICKET: ', ticket_description, '\n',
		'CLIENTE: ', IFNULL(customer_name, ''), '\n',
		'IMPIANTO: ', IFNULL(system_description, ''), '\n',
		'URGENZA: ', IFNULL(urgency, ''), '\n',
		'TELEFONO: ', IFNULL(phone_number, ''), '\n',
		'EMAIL: ', IFNULL(email, ''), '\n'
	);


	IF event_id IS NULL THEN
		INSERT INTO Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Id_riferimento = NULL, 
			id_tipo_evento = 60, 
			Eseguito = 0, 
			Ricorrente = 0,
			giorni_ricorrenza = 0,
			Data_esecuzione = expiration_date, 
			Sveglia = 0, 
			Data_sveglia = '1970-01-01 00:00:00',
			Ora_inizio_esecuzione = '09:00:00',
			ora_fine_esecuzione = '10:00:00',
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID;
			
 		SELECT LAST_INSERT_ID() INTO event_id;
		
		INSERT INTO Evento_gruppo_evento (Id_evento, Id_gruppo_evento, Tipo_associazione, Timestamp)
			VALUES (event_id, event_group_id, 1, CURRENT_TIMESTAMP);
	ELSE
		UPDATE Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Data_esecuzione = expiration_date, 
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
	END IF;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesTicketDeleteReminderEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesTicketDeleteReminderEvent (
	IN ticket_id INT,
	IN ticket_year INT
)
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);
	DECLARE event_group_id INT(11);

	SELECT id_evento_promemoria, id_evento_scadenza
		INTO reminder_event_id, expiration_event_id
	FROM ticket
	WHERE id_ticket = ticket_id AND anno = ticket_year;


	IF reminder_event_id IS NOT NULL THEN
		SELECT id_gruppo_evento
			INTO event_group_id
		FROM evento_gruppo_evento 
		WHERE id_evento = reminder_event_id;

		UPDATE evento
		SET Eliminato = 1,
			Utente_mod = @USER_ID
		WHERE id = reminder_event_id;

		IF expiration_event_id IS NULL THEN
			UPDATE evento_gruppo
			SET Eliminato = 1,
				Utente_mod = @USER_ID
			WHERE id = event_group_id;
		END IF;
	END IF;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesTicketDeleteExpirationEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesTicketDeleteExpirationEvent (
	IN ticket_id INT,
	IN ticket_year INT
)
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);
	DECLARE event_group_id INT(11);

	SELECT id_evento_promemoria, id_evento_scadenza
		INTO reminder_event_id, expiration_event_id
	FROM ticket
	WHERE id_ticket = ticket_id AND anno = ticket_year;
	

	IF expiration_event_id IS NOT NULL THEN
		SELECT id_gruppo_evento
			INTO event_group_id
		FROM evento_gruppo_evento 
		WHERE id_evento = expiration_event_id;

		UPDATE evento
		SET Eliminato = 1,
			Utente_mod = @USER_ID
		WHERE id = expiration_event_id;

		IF reminder_event_id IS NULL THEN
			
			UPDATE evento_gruppo
			SET Eliminato = 1,
				Utente_mod = @USER_ID
			WHERE id = event_group_id;

		END IF;
	END IF;

END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesEmployeeDpiDeleteReminderEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesEmployeeDpiDeleteReminderEvent (
	IN employee_dpi_id INT
)
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);
	DECLARE event_group_id INT(11);

	SELECT id_evento_promemoria, id_evento_scadenza
		INTO reminder_event_id, expiration_event_id
	FROM operaio_dpi
	WHERE id_dpi = employee_dpi_id;


	IF reminder_event_id IS NOT NULL THEN
		SELECT id_gruppo_evento
			INTO event_group_id
		FROM evento_gruppo_evento 
		WHERE id_evento = reminder_event_id;

		UPDATE evento
		SET Eliminato = 1,
			Utente_mod = @USER_ID
		WHERE id = reminder_event_id;

		IF expiration_event_id IS NULL THEN
			UPDATE evento_gruppo
			SET Eliminato = 1,
				Utente_mod = @USER_ID
			WHERE id = event_group_id;
		END IF;
	END IF;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEmployeeDpiDeleteExpirationEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesEmployeeDpiDeleteExpirationEvent (
	IN employee_dpi_id INT
)
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);
	DECLARE event_group_id INT(11);

	SELECT id_evento_promemoria, id_evento_scadenza
		INTO reminder_event_id, expiration_event_id
	FROM operaio_dpi
	WHERE id_dpi = employee_dpi_id;
	

	IF expiration_event_id IS NOT NULL THEN
		SELECT id_gruppo_evento
			INTO event_group_id
		FROM evento_gruppo_evento 
		WHERE id_evento = expiration_event_id;

		UPDATE evento
		SET Eliminato = 1,
			Utente_mod = @USER_ID
		WHERE id = expiration_event_id;

		IF reminder_event_id IS NULL THEN
			
			UPDATE evento_gruppo
			SET Eliminato = 1,
				Utente_mod = @USER_ID
			WHERE id = event_group_id;

		END IF;
	END IF;

END; //
DELIMITER ;



DROP PROCEDURE IF EXISTS sp_ariesEmployeeDpiEnsureReminderEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesEmployeeDpiEnsureReminderEvent (
	IN employee_dpi_id INT,
	IN employee_id INT,
	IN product_id VARCHAR(11),
	IN reminder_date DATE,
	IN reminder_event_id INT,
	IN expiration_date DATE,
	IN expiration_event_id INT,
	OUT event_id INT(11)
)
BEGIN
	DECLARE event_group_id INT(11);
	DECLARE employee_name TEXT;
	DECLARE product_name TEXT;
	DECLARE event_description TEXT;
	DECLARE event_subject TEXT;

	SET event_id = reminder_event_id;

	SELECT
		ragione_sociale
	INTO
		employee_name
	FROM operaio
	WHERE id_operaio = employee_id;

	SELECT
		desc_brev
	INTO
		product_name
	FROM articolo
	WHERE codice_articolo = product_id;

	SELECT 
		evento_gruppo.id
	INTO
		event_group_id
	FROM evento_gruppo
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_promemoria ON evento_gruppo_evento_promemoria.id_evento = reminder_event_id
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_scadenza ON evento_gruppo_evento_scadenza.id_evento = expiration_event_id
	WHERE evento_gruppo.id IN (evento_gruppo_evento_promemoria.id_gruppo_evento, evento_gruppo_evento_scadenza.id_gruppo_evento);


	IF event_group_id IS NULL THEN
		INSERT INTO evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA DPI ', employee_name),
			descrizione = CONCAT(
				'OPERAIO: ', employee_name, '\n',
				'DPI: ', IFNULL(product_name, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			data_ora_fine = CONCAT(GREATEST(reminder_date, expiration_date), ' ', '20:00:00'),
			Data_ins = NOW(),
			Data_mod = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
		
 		SELECT LAST_INSERT_ID() INTO event_group_id;

	ELSE
		UPDATE evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA DPI ', employee_name),
			descrizione = CONCAT(
				'OPERAIO: ', employee_name, '\n',
				'DPI: ', IFNULL(product_name, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			Data_mod = NOW(),
			Utente_mod = @USER_ID
		WHERE id = event_group_id;

	END IF;

	
	SET event_subject = CONCAT('PROMEMORIA DPI ', employee_name);
	SET event_description = CONCAT(
		'OPERAIO: ', employee_name, '\n',
		'DPI: ', IFNULL(product_name, ''), '\n',
		'SCADENZA: ', IFNULL(expiration_date, ''), '\n'
	);

	IF event_id IS NULL THEN
		INSERT INTO Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Id_riferimento = NULL, 
			id_tipo_evento = 70, 
			Eseguito = 0, 
			Ricorrente = 0,
			giorni_ricorrenza = 0,
			Data_esecuzione = reminder_date, 
			Sveglia = 0, 
			Data_sveglia = '1970-01-01 00:00:00',
			Ora_inizio_esecuzione = '09:00:00',
			ora_fine_esecuzione = '10:00:00',
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID;
			
 		SELECT LAST_INSERT_ID() INTO event_id;
		
		INSERT INTO Evento_gruppo_evento (Id_evento, Id_gruppo_evento, Tipo_associazione, Timestamp)
			VALUES (event_id, event_group_id, 1, CURRENT_TIMESTAMP);
	ELSE
		UPDATE Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Data_esecuzione = reminder_date, 
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
	END IF;

END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesEmployeeDpiEnsureExpirationEvent;
DELIMITER //
CREATE PROCEDURE sp_ariesEmployeeDpiEnsureExpirationEvent (
	IN employee_dpi_id INT,
	IN employee_id INT,
	IN product_id VARCHAR(11),
	IN reminder_date DATE,
	IN reminder_event_id INT,
	IN expiration_date DATE,
	IN expiration_event_id INT,
	OUT event_id INT(11)
)
BEGIN
	DECLARE event_group_id INT(11);
	DECLARE employee_name TEXT;
	DECLARE product_name TEXT;
	DECLARE event_description TEXT;
	DECLARE event_subject TEXT;

	SET event_id = expiration_event_id;

	SELECT
		ragione_sociale
	INTO
		employee_name
	FROM operaio
	WHERE id_operaio = employee_id;

	SELECT
		desc_brev
	INTO
		product_name
	FROM articolo
	WHERE codice_articolo = product_id;

	SELECT 
		evento_gruppo.id
	INTO
		event_group_id
	FROM evento_gruppo
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_promemoria ON evento_gruppo_evento_promemoria.id_evento = reminder_event_id
		LEFT JOIN evento_gruppo_evento as evento_gruppo_evento_scadenza ON evento_gruppo_evento_scadenza.id_evento = expiration_event_id
	WHERE evento_gruppo.id IN (evento_gruppo_evento_promemoria.id_gruppo_evento, evento_gruppo_evento_scadenza.id_gruppo_evento);


	IF event_group_id IS NULL THEN
		INSERT INTO evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA DPI ', employee_name),
			descrizione = CONCAT(
				'OPERAIO: ', employee_name, '\n',
				'DPI: ', IFNULL(product_name, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			data_ora_fine = CONCAT(GREATEST(reminder_date, expiration_date), ' ', '20:00:00'),
			Data_ins = NOW(),
			Data_mod = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID;
		
 		SELECT LAST_INSERT_ID() INTO event_group_id;

	ELSE
		UPDATE evento_gruppo
		SET
			oggetto = CONCAT('PROMEMORIA/SCADENZA DPI ', employee_name),
			descrizione = CONCAT(
				'OPERAIO: ', employee_name, '\n',
				'DPI: ', IFNULL(product_name, ''), '\n'
			),
			data_ora_inizio = CONCAT(LEAST(reminder_date, expiration_date), ' ', '08:00:00'),
			data_ora_fine = CONCAT(GREATEST(reminder_date, expiration_date), ' ', '20:00:00'),
			Data_mod = NOW(),
			Utente_mod = @USER_ID
		WHERE id = event_group_id;

	END IF;
	
	SET event_subject = CONCAT('SCADENZA DPI ', employee_name);
	SET event_description = CONCAT(
		'OPERAIO: ', employee_name, '\n',
		'DPI: ', IFNULL(product_name, ''), '\n'
	);


	IF event_id IS NULL THEN
		INSERT INTO Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Id_riferimento = NULL, 
			id_tipo_evento = 70, 
			Eseguito = 0, 
			Ricorrente = 0,
			giorni_ricorrenza = 0,
			Data_esecuzione = expiration_date, 
			Sveglia = 0, 
			Data_sveglia = '1970-01-01 00:00:00',
			Ora_inizio_esecuzione = '09:00:00',
			ora_fine_esecuzione = '10:00:00',
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_ins = @USER_ID;
			
 		SELECT LAST_INSERT_ID() INTO event_id;
		
		INSERT INTO Evento_gruppo_evento (Id_evento, Id_gruppo_evento, Tipo_associazione, Timestamp)
			VALUES (event_id, event_group_id, 1, CURRENT_TIMESTAMP);
	ELSE
		UPDATE Evento
		SET 
			Oggetto = event_subject, 
			Descrizione = event_description, 
			Data_esecuzione = expiration_date, 
			Data_mod = CURRENT_TIMESTAMP, 
			Utente_mod = @USER_ID
		WHERE Id = event_id; 
	END IF;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS  sp_userHasModuleAccess;
DELIMITER // 
CREATE PROCEDURE sp_userHasModuleAccess(user_id INT(11), module_name VARCHAR(100), OUT result BIT(1))
BEGIN   

	DECLARE val BIT(1) DEFAULT 0;
   	DECLARE user_type_id INT(11) default 0;

	DECLARE `_has_exception` BOOL DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_has_exception` = 1;

   	SELECT tipo_utente INTO user_type_id FROM utente WHERE id_utente = user_id;

	SET @query_stmt = CONCAT('SELECT ',module_name,' > 0 FROM tipo_utente WHERE id_tipo = ', user_type_id);
   
	PREPARE stmt FROM @query_stmt;
	EXECUTE stmt;
	
	
	DEALLOCATE PREPARE stmt;

	IF _has_exception THEN
		SET val = 0;
	END IF;

	SET result = val;
END // 
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesHomeNotifications;
DELIMITER //
CREATE PROCEDURE sp_ariesHomeNotifications (IN user_id INT(11))
BEGIN
	DECLARE roles TEXT DEFAULT '';
	DECLARE is_admin BIT(1) DEFAULT 0;
	DECLARE user_type_id INT(11) default 0;

	DECLARE days_quotes_sent_reminder INT(11) default 0;
	DECLARE days_quotes_sent_expiration INT(11) default 0;

	DECLARE has_email_access BIT(1) DEFAULT 0;
	DECLARE has_quote_access BIT(1) DEFAULT 0;
	DECLARE has_report_access BIT(1) DEFAULT 0;
	DECLARE has_invoice_access BIT(1) DEFAULT 0;
	DECLARE has_supplier_invoice_access BIT(1) DEFAULT 0;
	DECLARE has_report_group_access BIT(1) DEFAULT 0;
	DECLARE has_customer_access BIT(1) DEFAULT 0;
	DECLARE has_supplier_access BIT(1) DEFAULT 0;
	DECLARE has_system_access BIT(1) DEFAULT 0;
	DECLARE has_product_access BIT(1) DEFAULT 0;
	DECLARE has_subscription_access BIT(1) DEFAULT 0;
	DECLARE has_ticket_access BIT(1) DEFAULT 0;

	DECLARE days_reminder_payment_invoices INT(11) DEFAULT 30;
	DECLARE days_reminder_subscription_requests INT(11) DEFAULT 30;

	SET roles = (SELECT GROUP_CONCAT(ur.app_name)
		FROM utente_utente_roles uur
			INNER JOIN utente_roles ur ON uur.id_utente_roles = ur.id
		WHERE uur.id_utente = user_id);
	
	SET is_admin = FIND_IN_SET('aries_admin', roles) > 0;

	SELECT
		IFNULL(giorni_promemoria, 30),
		IFNULL(notifica_attesa, 30)
	INTO 
		days_reminder_payment_invoices,
		days_reminder_subscription_requests
	FROM Azienda
	ORDER BY id_azienda DESC
	LIMIT 1;

	
   SELECT tipo_utente INTO user_type_id FROM utente WHERE id_utente = user_id;
	SELECT 
		mail,
		preventivo,
		rapporto,
		fattura,
		fatturar,
		resoconto,
		clienti,
		fornitore,
		impianto OR impianto_tecnico,
		articolo,
		abbonamento,
		ticket,
		rapporto
	INTO
		has_email_access,
		has_quote_access,
		has_report_access,
		has_invoice_access,
		has_supplier_invoice_access,
		has_report_group_access,
		has_customer_access,
		has_supplier_access,
		has_system_access,
		has_product_access,
		has_subscription_access,
		has_ticket_access,
		has_report_access
	FROM tipo_utente
	WHERE id_tipo = user_type_id;

	
	DROP TABLE IF EXISTS temp_notifications;
	CREATE TEMPORARY TABLE temp_notifications (
	  	`tipo_notifica` VARCHAR(50) NOT NULL,
	  	`colore` VARCHAR(50) NOT NULL,
	  	`data_notifica` DATE NULL,
	  	`descrizione` VARCHAR(255) NOT NULL,
	  	`nome` VARCHAR(100) NOT NULL,
		immagine INT(11) NOT NULL,
		giorni INT(11) NOT NULL,
		giorni_scaduto INT(11) NOT NULL
	);
	
  	## EMAIL WITH SENDING ERROR OR INIFITE SENDING
	IF has_email_access THEN
		INSERT INTO temp_notifications
		SELECT "failed_emails" AS tipo_notifica,
			"clYellow" As colore,
			NULL as data,
			CONCAT(count(Id)," mail non inviate ") AS descrizione,
			"MAIL FALLITE",
			21 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM mail
			WHERE mail.Id_stato=2 OR ((NOW() - data_invio) div 60 > 20 AND mail.Id_stato=0 AND mail.tipo="1") AND mail.tipo="1" 
		HAVING count(Id) > 0;
	END IF;
   
  	## REPORTS
	IF has_report_access THEN
		INSERT INTO temp_notifications
		SELECT "new_reports" AS "tipo_notifica",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," nuovi rapporti inviati da mobile") AS "descrizione",
			"NUOVI RAPPORTI",
			8 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM rapporto_mobile
		WHERE visionato = 0 AND inviato = 1 AND data IS NOT NULL
		HAVING count(*) > 0

		
   		## CHECKLISTS MOBILE - NEW
		UNION ALL
		SELECT "new_checklists" AS "tipo_notifica",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," nuove checklist inviate da mobile") AS "descrizione",
			"NUOVE CHECKLISTS",
			3 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM checklist
		WHERE visionata = 0 
		HAVING count(*) > 0;
	END IF;



 
	## Invoices payments
	IF has_invoice_access THEN
		INSERT INTO temp_notifications
		SELECT "invoice_payments_reminder" AS "tipo_notifica",
			"clyellow" AS "colore",
			NULL AS "data", 
			CONCAT(count(*)," in scadenza entro ", days_reminder_payment_invoices, " giorni") AS "descrizione",
			"PAGAMENTI FATTURE",
			34 as immagine,
			days_reminder_payment_invoices as giorni,
			90 as giorni_scaduto
		FROM (
			SELECT concat (fattura.id_fattura," ",fattura.anno) AS "gruppa"
			FROM fattura 
				INNER JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione 
				LEFT JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione 
			WHERE DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY, "%Y%m%d") >=  DATE_FORMAT(CURRENT_DATE - INTERVAL 0  day, "%Y%m%d")
				AND DATE_FORMAT(LAST_DAY(fattura.DATA + INTERVAL g.mesi MONTH)+ INTERVAL g.giorni DAY, "%Y%m%d") <= DATE_FORMAT(CURRENT_DATE + INTERVAL days_reminder_payment_invoices  day, "%Y%m%d")
				AND fattura.stato IN (1, 4) 
				AND (fattura.data_invio_promemoria IS NULL OR data_invio_promemoria="0002-02-02")
			GROUP BY gruppa) AS app
		HAVING count(*)>0;
	END IF;

	# Quotes waiting for reply
	IF has_quote_access THEN
		SELECT IFNULL(valore + 0, 30) INTO days_quotes_sent_reminder
		FROM preventivo_impost
		WHERE tipo = 'promem_invio';
		
		SELECT IFNULL(valore + 0, 60) INTO days_quotes_sent_expiration
		FROM preventivo_impost
		WHERE tipo = 'scad_invio';

		INSERT INTO temp_notifications
		SELECT "quotes_sent_reminder" AS "tipo_notifica",
			"clyellow" AS "colore",
			NULL AS "data", 
			CONCAT(count(*)," preventivi in attesa di risposta. ") AS "descrizione",
			"PREVENTIVI INVIATI",
			1 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM preventivo
		WHERE (
				(data_invio IS NOT NULL AND primo_sollecito IS NULL AND DATEDIFF(curdate(), data_invio) > days_quotes_sent_reminder)
				OR (primo_sollecito IS NOT NULL AND secondo_sollecito IS NULL AND DATEDIFF(curdate(), primo_sollecito) > days_quotes_sent_expiration)
			)
		HAVING count(*)>0;
	END IF;


  	# CUSTOMER - INSERTED TO DOUBLE CHECK
	IF has_customer_access THEN
		INSERT INTO temp_notifications
   		SELECT "customer_to_handle" AS "Id_evento",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," nuovi clienti inseriti da gestire.") AS "descrizione",
			"CLIENTI INSERITI",
			13 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM clienti
		WHERE modi = 5
		HAVING count(*) > 0;
	END IF;


  	# Subscriptions
	IF has_subscription_access THEN
		INSERT INTO temp_notifications
		SELECT "subscription_requests_reminder" AS "Id_evento",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," in attesa di risposta da piu di ", days_reminder_subscription_requests, " giorni.") AS "descrizione",
			"RICHIESTE DI ABBONAMENTO",
			19 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM impianto
		WHERE DATEDIFF(CURRENT_DATE, impianto.data_invio_doc) > days_reminder_subscription_requests
			AND impianto.stato_invio_doc="clyellow"
		HAVING count(*) > 0;
	END IF;

	IF has_system_access THEN
		INSERT INTO temp_notifications
		SELECT "expiring_systems_warranty" AS "Id_evento",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," in scadenza entro 60 giorni.") AS "descrizione",
			"GARANZIE IMPIANTI",
			35 as immagine,
			60 as giorni,
			30 as giorni_scaduto
		FROM impianto
			INNER JOIN stato_impianto ON stato_impianto.id_stato = impianto.stato
		WHERE DATEDIFF(impianto.scadenza_garanzia,CURRENT_DATE) BETWEEN -30 AND 60
			AND stato_impianto.bloccato = 0
		HAVING count(*)>0

		UNION ALL
		SELECT "system_subscriptions_to_renew" AS "Id_evento",
			"ClYellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," impianti in attesa di rinnovo abbonamento per l''anno ",  IF(MONTH(CURRENT_DATE()) >= 11, YEAR(CURRENT_DATE()) + 1,  YEAR(CURRENT_DATE())), ".") AS descrizione,
			"RINNOVO ABBONAMENTI",
			28 as immagine,
			0 as giorni,
			0 as giorni_scaduto
		FROM (
			SELECT IFNULL(flag_abbonamento, 0 ) as flag_abbonamento, impianto.id_impianto, impianto.descrizione,
				clienti.ragione_sociale, abbonamento.nome AS "abbonamento", tipo_impianto.nome AS "tipo_impianto", ia.anno,
				iu.manutenzione, iu.importo_abbonamento, impianto.persone, round(tempo_manutenzione/60,2) AS "Tempo_manutenzione", Costo_manutenzione
			FROM impianto
				LEFT JOIN impianto_abbonamenti AS ia ON ia.id_impianto=impianto.id_impianto
				LEFT JOIN abbonamento ON abbonamento.id_abbonamento=id_abbonamenti
				LEFT JOIN clienti ON clienti.id_cliente = impianto.id_cliente
				LEFT JOIN tipo_impianto ON id_tipo=tipo_impianto
				LEFT JOIN stato_impianto ON impianto.stato = id_stato
				LEFT JOIN impianto_uscita AS iu ON iu.id_impianto=ia.id_impianto AND iu.anno=ia.anno AND ia.id_abbonamenti=iu.id_abbonamento
			WHERE non_abbonato = 0
				AND ia.id_impianto IS NOT NULL
				AND ((flag_abbonamento_anno IS NULL) 
				AND stato_impianto.bloccato = 0
				OR (flag_abbonamento_anno <> year(curdate()) + 1 AND month(curdate()) >= 11)
				OR (flag_abbonamento_anno <> year(curdate()) AND month(curdate()) < 11))
			GROUP by ia.id_impianto) AS sub_exp_subquery
		HAVING count(*)>0

		UNION ALL
		SELECT "expiring_system_components",
			"clYellow",
			NULL, 
			CONCAT(count(*)," componenti impianto in scadenza entro 30 giorni") AS "descrizione",
			"COMPONENII IMPIANTI" ,
			17 as immagine,
			30 as giorni,
			60 as giorni_scaduto
		FROM impianto_componenti 
			INNER JOIN articolo ON impianto_componenti.id_articolo = articolo.codice_articolo 
			INNER JOIN impianto ON impianto_componenti.id_impianto = impianto.id_impianto
			INNER JOIN stato_impianto ON stato_impianto.id_stato = impianto.stato
		WHERE DATEDIFF(curdate(), data_scadenza) BETWEEN -60 AND 30
			AND data_scadenza IS NOT NULL
			AND data_dismesso IS NULL
			AND impianto_componenti.stato = 1
			AND stato_impianto.bloccato = 0
		HAVING count(*)>0

		UNION ALL
		SELECT "expiring_system_sims",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," in scadenza entro 30 giorni.") AS "descrizione",
			"RICARICHE IMPIANTI",
			36 as immagine,
			30 as giorni,
			60 as giorni_scaduto
		FROM impianto_ricarica_tipo
			INNER JOIN impianto ON impianto.Id_impianto = impianto_ricarica_tipo.id_impianto
			INNER JOIN stato_impianto ON stato_impianto.id_stato = impianto.stato
		WHERE DATEDIFF(impianto_ricarica_tipo.data_scadenza, CURRENT_DATE) BETWEEN -60 AND 30
			AND stato_impianto.bloccato = 0
		HAVING count(*)>0
		

		UNION ALL
		SELECT "system_maintenance_list",
			"clyellow" AS "colore",
			NULL AS "data",
			CONCAT(count(*)," in scadenza entro 30 giorni.") AS "descrizione",
			"CONTROLLI PERIODICI",
			23 as immagine,
			30 as giorni,
			60 as giorni_scaduto
		FROM impianto_abbonamenti_mesi
			INNER JOIN impianto ON impianto.Id_impianto = impianto_abbonamenti_mesi.impianto
			INNER JOIN stato_impianto ON stato_impianto.id_stato = impianto.stato
		WHERE eseguito_il IS NULL
			AND DATEDIFF(
				IFNULL(da_eseguire, DATE_ADD(MAKEDATE(impianto_abbonamenti_mesi.anno, 1), INTERVAL (impianto_abbonamenti_mesi.mese)-1 MONTH)),
				CURRENT_DATE
			) BETWEEN -60 AND 30
			AND stato_impianto.bloccato = 0
		HAVING COUNT(*)>0;
	END IF;
    
	
	IF has_ticket_access THEN
		INSERT INTO temp_notifications 
		SELECT "expiring_tickets",
			"clyellow"  AS "colore",
			NULL AS "data",
			CONCAT(count(*)," in scadenza entro 30 giorni.") AS descrizione ,
			"SCADENZA TICKET" AS "tipo",
			7 as immagine,
			30 as giorni,
			60 as giorni_scaduto
		FROM ticket
		WHERE DATEDIFF(scadenza, CURRENT_DATE) BETWEEN -60 AND 30
			AND scadenza IS NOT NULL
			AND data_soluzione IS NULL
			AND stato_ticket IN (1, 2)
		HAVING count(*)>0;
	END IF;
      
  	## List corsi in scadenza
	INSERT INTO temp_notifications 
	SELECT "expiring_courses",
		"clWhite" AS colore,
		NULL AS data_inizio,
		CONCAT(count(*)," in scadenza entro 30 giorni.") AS descrizione,
		"CORSI SCADUTI",
		0 as immagine,
		30 as giorni,
		60 as giorni_scaduto
	FROM corso
			LEFT JOIN operaio_corso ON corso.id_corso = operaio_corso.id_corso
		LEFT JOIN operaio ON operaio.id_operaio = operaio_corso.id_operaio
		LEFT JOIN tipo_evento ON tipo_evento = tipo_evento.id_tipo
	WHERE DATEDIFF(data_fine, CURRENT_DATE) BETWEEN -60 AND 30
		AND corso.stato = 1
	HAVING COUNT(*) > 0;
	
	
	SELECT * FROM temp_notifications ORDER BY nome;

END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesReportAttachmentGetByReport;
DELIMITER //
CREATE PROCEDURE sp_ariesReportAttachmentGetByReport (IN report_id INT(11), IN report_year INT(11))
BEGIN
	SELECT *
	FROM rapporto_allegati
	WHERE id_rapporto = report_id AND anno_rapporto = report_year;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesReportAttachmentRename;
DELIMITER //
CREATE PROCEDURE sp_ariesReportAttachmentRename (IN in_id INT(11), IN in_file_name VARCHAR(500), IN in_file_path VARCHAR(500))
BEGIN
	UPDATE rapporto_allegati
	SET file_name = in_file_name,
		file_path = in_file_path
	WHERE id = in_id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_ariesReportAttachmentDelete;
DELIMITER //
CREATE PROCEDURE sp_ariesReportAttachmentDelete (IN in_id INT(11))
BEGIN
	DECLARE report_id INT(11);
	DECLARE report_year INT(11);

	SELECT id_rapporto, anno_rapporto INTO report_id, report_year
	FROM rapporto_allegati
	WHERE id = in_id;

	UPDATE rapporto
	SET numero_allegati = numero_allegati - 1
	WHERE id_rapporto = report_id AND anno = report_year;

	DELETE FROM rapporto_allegati
	WHERE id = in_id;
END; //
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_ariesReportAttachmentGetById;
DELIMITER //
CREATE PROCEDURE sp_ariesReportAttachmentGetById (IN in_id INT(11))
BEGIN
	SELECT *
	FROM rapporto_allegati
	WHERE id = in_id;
END; //
DELIMITER ;
