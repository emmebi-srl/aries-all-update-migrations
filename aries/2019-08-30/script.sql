ALTER TABLE `commessa_articoli`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno`;

DELETE FROM commessa_sotto WHERE id_sotto > 1;
DELETE FROM commessa_lotto WHERE id_sottocommessa > 1;

UPDATE commessa_articoli
    INNER JOIN commessa_lotto b 
        ON commessa_articoli.id_commessa = b.id_commessa
            AND commessa_articoli.anno = b.anno
            And commessa_articoli.id_lotto = b.id_lotto
SET commessa_articoli.id_sottocommessa = b.id_sottocommessa;


ALTER TABLE `commessa_articoli`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id_commessa`, `anno`, `id_lotto`, `id_tab`, `id_sottocommessa`) USING BTREE,
	DROP INDEX `lotto_fk`,
	ADD INDEX `lotto_fk` (`id_lotto`, `id_commessa`, `anno`, `id_sottocommessa`) USING BTREE;

ALTER TABLE `commessa_articoli`
	DROP INDEX `com`,
	ADD INDEX `com` (`id_commessa`, `anno`, `id_tab`, `id_lotto`, `id_sottocommessa`);

ALTER TABLE `commessa_preventivo`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno`;

UPDATE commessa_preventivo 
	INNER JOIN commessa_lotto as cl 
		ON commessa_preventivo.id_commessa = cl.id_commessa
			AND commessa_preventivo.anno = cl.anno
			AND commessa_preventivo.lotto = cl.id_lotto
SET commessa_preventivo.id_sottocommessa = cl.id_sottocommessa;

ALTER TABLE `commessa_preventivo`
	DROP FOREIGN KEY `compre`;

 ALTER TABLE commessa_preventivo ENGINE=InnoDB;
ALTER TABLE commessa_lotto ENGINE=InnoDB;

ALTER TABLE `commessa_preventivo`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id_commessa`, `anno`, `preventivo`, `anno_prev`, `lotto`, `Pidlotto`, `id_sottocommessa`) USING BTREE;

ALTER TABLE `commessa_ddtr`
	DROP FOREIGN KEY `FK_commessa_ddtr_1_commessa`;
ALTER TABLE `commessa_ddtr`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno_commessa`;

ALTER TABLE `commessa_ddtr`
	DROP INDEX `FK_commessa_ddtr_1_commessa`,
	ADD INDEX `FK_commessa_ddtr_1_commessa` (`id_lotto`, `id_commessa`, `anno_commessa`, `id_sottocommessa`);

ALTER TABLE `rapporto_mobile`
	ADD COLUMN `tipo_rapporto` SMALLINT NULL DEFAULT NULL COMMENT '2 Customer, 1  Internal' AFTER `usa_firma_su_ddt`;

ALTER TABLE `commessa_rapporto`
	DROP FOREIGN KEY `lot`;
ALTER TABLE `commessa_rapporto`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno_commessa`,
	DROP INDEX `lot`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`anno_rapporto`, `id_rapporto`, `id_commessa`, `anno_commessa`, `id_lotto`, `id_sottocommessa`);
ALTER TABLE `commessa_rapporto`
	ADD INDEX `lot` (`id_commessa`, `anno_rapporto`, `id_sottocommessa`, `id_lotto`);
	
UPDATE commessa_rapporto 
	INNER JOIN commessa_lotto as cl 
		ON commessa_rapporto.id_commessa = cl.id_commessa
			AND commessa_rapporto.anno_commessa = cl.anno
			AND commessa_rapporto.id_lotto = cl.id_lotto
SET commessa_rapporto.id_sottocommessa = cl.id_sottocommessa;

ALTER TABLE `commessa_rapporto`
	DROP INDEX `lot`,
	ADD INDEX `lot` (`id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`);



ALTER TABLE `commessa_ddt`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno_commessa`,
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`Id_commessa`, `Id_ddt`, `Anno_ddt`, `anno_commessa`, `id_lotto`, `id_sottocommessa`) USING BTREE;

ALTER TABLE `commessa_ddt`
	DROP INDEX `commessa_ddt_ibfk_1`,
	ADD INDEX `ibfk_commessa_ddt_commessa` (`id_lotto`, `Id_commessa`, `anno_commessa`, `id_sottocommessa`);

ALTER TABLE `commessa_ddt`
	DROP FOREIGN KEY `artcomme`;


UPDATE commessa_ddt 
	INNER JOIN commessa_lotto as cl 
		ON commessa_ddt.id_commessa = cl.id_commessa
			AND commessa_ddt.anno_commessa = cl.anno
			AND commessa_ddt.id_lotto = cl.id_lotto
SET commessa_ddt.id_sottocommessa = cl.id_sottocommessa;

ALTER TABLE `commessa_fattura`
	ADD COLUMN `id_sottocommessa` INT(11) NOT NULL AFTER `anno_commessa`;


ALTER TABLE `commessa_fattura`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`anno_fattura`, `Id_fattura`, `Id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`);

UPDATE commessa_fattura 
	INNER JOIN commessa_lotto as cl 
		ON commessa_fattura.id_commessa = cl.id_commessa
			AND commessa_fattura.anno_commessa = cl.anno
			AND commessa_fattura.id_lotto = cl.id_lotto
SET commessa_fattura.id_sottocommessa = cl.id_sottocommessa;

ALTER TABLE `commessa_fattura`
	DROP FOREIGN KEY `lottt`;


ALTER TABLE commessa_fattura ENGINE = INNODB;
ALTER TABLE commessa_lotto ENGINE = INNODB;

ALTER TABLE `commessa_lotto`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`);

ALTER TABLE `commessa_fattura`
	ADD CONSTRAINT `FK_commessa_fattura_commessa_lotto` FOREIGN KEY (`Id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `commessa_rapporto`
	ADD CONSTRAINT `FK_commessa_rapporto_commessa_lotto` FOREIGN KEY (`Id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `commessa_ddt`
	ADD CONSTRAINT `FK_commessa_ddt_commessa_lotto` FOREIGN KEY (`Id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `commessa_ddtr`
	ADD CONSTRAINT `FK_commessa_ddtr_commessa_lotto` FOREIGN KEY (`Id_commessa`, `anno_commessa`, `id_sottocommessa`, `id_lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `commessa_preventivo`
	ADD CONSTRAINT `FK_commessa_preventivo_commessa_lotto` FOREIGN KEY (`Id_commessa`, `anno`, `id_sottocommessa`, `lotto`) REFERENCES `commessa_lotto` (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) ON UPDATE CASCADE ON DELETE NO ACTION;

ALTER TABLE `commessa_articoli`
	ADD CONSTRAINT `PK_commessa_articoli_lotto` FOREIGN KEY (`id_commessa`, `anno`, `id_sottocommessa`, `id_lotto`) REFERENCES `commessa_lotto` ( `id_commessa`,  `anno`, `id_sottocommessa`,`id_lotto`);
