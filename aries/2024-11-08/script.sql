ALTER TABLE `stato_ticket`
	ADD COLUMN `aperto` BIT NOT NULL DEFAULT 0 AFTER `colore`;

	
UPDATE stato_ticket SET aperto = 1 WHERE id_stato IN (1,2);

DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_emmebi BIT(1) DEFAULT 0;


	SELECT COUNT(*) > 0
	INTO is_emmebi
	FROM azienda 
	WHERE partita_iva = '04371390263';

	IF is_emmebi THEN
		UPDATE tipo_natura_iva SET abilitato = 0 WHERE tipo_pa not in ('N6.3', 'N6.7');
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
