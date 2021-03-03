DROP PROCEDURE IF EXISTS sp_splitArray;
DELIMITER $$
CREATE PROCEDURE sp_splitArray(serializedArray VARCHAR(1024))
BEGIN

	SET @stmt = CONCAT("INSERT INTO splitArrayData(array_values) VALUES", serializedArray, ";");
	
	DROP TEMPORARY TABLE IF EXISTS splitArrayData;
	CREATE TEMPORARY TABLE splitArrayData (
		array_index INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		array_values VARCHAR(64) NOT NULL DEFAULT ""
	) ENGINE = innoDB;
	
	PREPARE sttmnt FROM @stmt;
	EXECUTE sttmnt;
	DEALLOCATE PREPARE sttmnt;
	
	SET @stmt = "";
	
	SELECT array_values FROM splitArrayData;
	
END $$
DELIMITER ;