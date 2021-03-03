ALTER TABLE `commessa_lotto`
	CHANGE COLUMN `csora` `csora` DECIMAL(11,2) NULL DEFAULT '0' AFTER `nota`,
	CHANGE COLUMN `prora` `prora` DECIMAL(11,2) NULL DEFAULT '0' AFTER `csora`,
	CHANGE COLUMN `sc` `sc` DECIMAL(11,2) NULL DEFAULT '0' AFTER `prora`;

DROP PROCEDURE IF EXISTS tmp_alignment_job_lot;
DELIMITER $$
CREATE PROCEDURE `tmp_alignment_job_lot`()
begin
	DROP TABLE IF EXISTS tmp_tbl_alignment_job_lot; 
	CREATE TEMPORARY TABLE tmp_tbl_alignment_job_lot(
	
		id_commessa INTEGER, 
		anno_commessa INTEGER, 
		id_lotto INTEGER, 
		id_sottocommessa INTEGER,
		prezzo_ora DECIMAL(11,2),
		costo_ora DECIMAL(11,2),
		PRIMARY KEY (anno_commessa, id_commessa, id_sottocommessa, id_lotto)
			
	);
	
	INSERT INTO tmp_tbl_alignment_job_lot
	SELECT commessa_Lotto.id_commessa,
		commessa_Lotto.anno, 
		commessa_Lotto.id_lotto, 
		commessa_Lotto.id_sottocommessa, 
		commessa_Lotto.csora, 
		commessa_Lotto.prora
	FROM commessa_Lotto; 
	
	UPDATE commessa_Lotto
	INNER JOIN tmp_tbl_alignment_job_lot
		on commessa_Lotto.id_commessa = tmp_tbl_alignment_job_lot.id_commessa AND
			commessa_Lotto.anno = tmp_tbl_alignment_job_lot.anno_commessa AND 
		 	commessa_Lotto.id_lotto = tmp_tbl_alignment_job_lot.id_lotto AND  
		 	commessa_Lotto.id_sottocommessa =  tmp_tbl_alignment_job_lot.id_sottocommessa 
	SET  commessa_Lotto.prora = tmp_tbl_alignment_job_lot.prezzo_ora,
			commessa_lotto.csora = tmp_tbl_alignment_job_lot.costo_ora; 
		 
	
END $$
DELIMITER ;
CALL tmp_alignment_job_lot(); 
DROP PROCEDURE IF EXISTS tmp_alignment_job_lot;


insert ignore into stato_ddt VALUES (1, 'Aperto', 'Ddt aperto.'); 
insert ignore into stato_ddt VALUES (2, 'Parziale', 'Ddt aperto parzialmente.'); 
insert ignore into stato_ddt VALUES (3, 'Chiuso', 'Ddt chiuso.'); 
