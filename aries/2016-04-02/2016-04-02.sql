ALTER TABLE `clienti`
	ADD COLUMN `Insolvente` BIT NULL DEFAULT b'0' AFTER `codice_univoco`;

	
	