ALTER TABLE `condizione_pagamento`
	ADD COLUMN `temporanea` BIT(1) NOT NULL DEFAULT b'0' AFTER `pagato`;


UPDATE condizione_pagamento set temporanea = 1 where nome = 'DA DEFINIRE';