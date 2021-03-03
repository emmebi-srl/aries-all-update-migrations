ALTER TABLE `fornfattura_pagamenti`
	ALTER `tipo_pagamento` DROP DEFAULT;
ALTER TABLE `fornfattura_pagamenti`
	CHANGE COLUMN `tipo_pagamento` `tipo_pagamento` INT(11) NOT NULL AFTER `id_pagamento`;

SELECT id_utente INTO @USER_ID FROM utente where nome = 'admin';

DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN

	UPDATE magazzino_operazione
    INNER JOIN magazzino_liste AS a ON a.id_operazione_ins = magazzino_operazione.id_operazione
	SET sorgente = 9;

END $$
DELIMITER ;
CALL tmp;
