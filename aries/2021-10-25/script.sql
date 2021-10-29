DROP PROCEDURE IF EXISTS sp_tmp; 
DELIMITER $$

CREATE PROCEDURE sp_tmp()
BEGIN

	DECLARE is_siantel BIT(1) DEFAULT 0;


	SELECT COUNT(*)
	INTO is_siantel
	FROM azienda 
	WHERE partita_iva = '03173480967';

	IF is_siantel THEN
		insert into preventivo_impost VALUES ('note_editor_default_width', '625');
	ELSE
		insert into preventivo_impost VALUES ('note_editor_default_width', '665');
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 