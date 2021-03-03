ALTER TABLE `condizione_pagamento`
	CHANGE COLUMN `pagato` `pagato` BIT NOT NULL DEFAULT b'0' AFTER `mesi`;
