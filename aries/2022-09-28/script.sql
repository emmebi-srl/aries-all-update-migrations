ALTER TABLE `commessa_preventivo`
	COMMENT='',
	ADD COLUMN `preventivo_prezzo_materiale` DECIMAL(11, 2) NOT NULL AFTER `Pidlotto`,
	ADD COLUMN `preventivo_costo_materiale` DECIMAL(11, 2) NOT NULL AFTER `preventivo_prezzo_materiale`,
	ADD COLUMN `preventivo_prezzo_lavoro` DECIMAL(11, 2) NOT NULL AFTER `preventivo_costo_materiale`,
	ADD COLUMN `preventivo_costo_lavoro` DECIMAL(11, 2) NOT NULL AFTER `preventivo_prezzo_lavoro`,
	ADD COLUMN `preventivo_totale_ore` DECIMAL(11, 2) NOT NULL AFTER `preventivo_costo_lavoro`,
	ADD COLUMN `preventivo_sconto` DECIMAL(11, 2) NOT NULL AFTER `preventivo_totale_ore`;




DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE V_quote_id INT;
	DECLARE V_quote_year INT;
	DECLARE V_revision_id INT;
	DECLARE V_lot_id INT;
	DECLARE V_curA CURSOR FOR SELECT preventivo, anno_prev, rev, pidlotto
		FROM commessa_preventivo;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN V_curA;
	loopA: LOOP
		FETCH V_curA INTO V_quote_id, V_quote_year, V_revision_id, V_lot_id;
		IF done = 1 THEN 
			LEAVE loopA;
		END IF;

		CALL sp_getQuoteTotals(V_quote_id, V_quote_year, V_revision_id, V_lot_id, @total_price_material, @total_cost_material, @total_profit_material, @total_price_work, @total_cost_work, @total_profit_work, @total_hours, @total_price, @total_cost, @total_profit, @total_sale);

		UPDATE commessa_preventivo
		SET preventivo_prezzo_materiale = @total_price_material,
			preventivo_costo_materiale = @total_cost_material,
			preventivo_prezzo_lavoro = @total_price_work,
			preventivo_costo_lavoro = @total_price_work,
			preventivo_totale_ore = @total_hours,
			preventivo_sconto = @total_sale
		WHERE preventivo = V_quote_id
			AND anno_prev = V_quote_year
			AND rev = V_revision_id
			AND pidlotto = V_lot_id;

	END LOOP;

END $$
DELIMITER ;
CALL tmp;