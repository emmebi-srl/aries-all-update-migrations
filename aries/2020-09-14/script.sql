DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_siantel BIT(1) DEFAULT 0;
	DECLARE report_filename VARCHAR(150);

	SELECT COUNT(*)
	INTO is_siantel
	FROM azienda 
	WHERE partita_iva = '03173480967';

	IF is_siantel THEN
		SET report_filename = 'preventivo_siantel.rav';
	ELSE
		SET report_filename = 'preventivo.rav';
	END IF;

	UPDATE stampante_moduli
	SET File_name = report_filename
	WHERE id_documento = 3 AND id_modulo = 0;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 