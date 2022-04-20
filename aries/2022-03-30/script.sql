INSERT INTO `tipo_documento` (`Id_tipo`, `Nome`) VALUES (28, 'ABBONAMENTO');
INSERT INTO `stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `fax`, `Data_mod`) VALUES (28, 'DOCUMENTO', 0, b'0', b'0',  NOW());
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (0, 28, 1, NOW());


INSERT INTO .`stampante_moduli` (`id_documento`, `modulo`, `Id_modulo`, `mail`, `fax`, `Data_mod`) VALUES (6, 'IN SCADENZA', 5, b'0', b'0', NOW());
INSERT INTO `stampante_moduli_formati` (`Id_modulo`, `Id_documento`, `Id_formato`, `Timestamp`) VALUES (5, 6, 2,  NOW());


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
		insert into environment_variables VALUES ('ENABLE_JOB_REQUIREMENTS_SECOND_PAGE', '1', NOW());
	ELSE
		insert into environment_variables VALUES ('ENABLE_JOB_REQUIREMENTS_SECOND_PAGE', '0', NOW());
	END IF;

END
$$

DELIMITER ;

CALL sp_tmp();

DROP PROCEDURE IF EXISTS sp_tmp; 
