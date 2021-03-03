DROP PROCEDURE IF EXISTS sp_apiTranslationGet; 
DELIMITER //
CREATE PROCEDURE `sp_apiTranslationGet`(
)
BEGIN

	SELECT Id, 
		Lcid,
		Translation_id,
		Value
	FROM translation; 

END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS sp_apiTranslationGetByProject; 
DELIMITER //
CREATE PROCEDURE `sp_apiTranslationGetByProject`(
 IN enter_project_id INT
)
BEGIN

SELECT translation.Id, 
		translation.Lcid,
		translation.Translation_id,
		translation.Value
	FROM translation
		INNER JOIN project_translation 
		ON translation.translation_id = project_translation.id_translation
			AND project_translation.id_project = enter_project_id; 

END
//
DELIMITER ; 

DROP PROCEDURE IF EXISTS sp_apiTranslationGetByIds; 
DELIMITER $$

CREATE PROCEDURE sp_apiTranslationGetByIds(IN idArray VARCHAR(255))
BEGIN

  SET @sql = CONCAT('SELECT translation.Id, 
		translation.Lcid,
		translation.Translation_id,
		translation.Value
	FROM translation
	WHERE Translation_id IN (',idArray,'); ');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

END
$$

DELIMITER ;