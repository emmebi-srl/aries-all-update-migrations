DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN


	DECLARE done INT DEFAULT FALSE;
	DECLARE ddtId INT;
	DECLARE ddtYear INT;
	DECLARE curA CURSOR FOR SELECT Id_ddt, anno FROM ddt;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	UPDATE ddt SET stato = 1 WHERE TRUE;
	
	OPEN curA;
	loopA: LOOP
		FETCH curA INTO ddtId, ddtYear;
		IF done THEN
			LEAVE loopA;
		END IF;
		CALL sp_onDdtDeterminingStatus(ddtId, ddtYear, 'UPDATE', @a);
	END LOOP;
	CLOSE curA;
	
	UPDATE ddt 
	INNER JOIN (
		SELECT id_ddt, anno_ddt AS anno 
		FROM commessa_ddt
		UNION SELECT id_ddt, anno 
		FROM ddt 
			WHERE fattura IS NOT NULL
	) a ON ddt.id_ddt = a.id_ddt AND ddt.anno = a.anno
	SET stato = 3;

END $$
DELIMITER ;
CALL tmp;