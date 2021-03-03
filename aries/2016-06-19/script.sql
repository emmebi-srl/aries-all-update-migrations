ALTER TABLE `preventivo_confcost`
	CHANGE COLUMN `conservare` `conservare` DECIMAL(11,2) NULL DEFAULT '0.00' AFTER `id`;
