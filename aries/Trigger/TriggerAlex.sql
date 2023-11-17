DROP TRIGGER IF EXISTS del_mag_ar_em;

DROP TRIGGER IF EXISTS ins_art_fatturaforn; 
DROP TRIGGER IF EXISTS trg_afterSupplierInvoiceProductInsert;
DELIMITER //
CREATE TRIGGER `trg_afterSupplierInvoiceProductInsert` AFTER INSERT ON `fornfattura_articoli` FOR EACH ROW BEGIN
	DECLARE allow_insert BIT;
	DECLARE depot_type INT;
	
	SELECT fnc_supplierInvoiceProductAllowDepotsScale(NEW.id_fattura, NEW.anno, NEW.id_materiale) INTO allow_insert;
	
	-- make insert IF allow
	IF allow_insert = 1 THEN
		SET depot_type = 1; -- MAGAZZINO
		CALL sp_ariesDepotsSupplierInvoiceProductInsert(NEW.id_fattura, NEW.anno, NEW.n_tab, NEW.quantità,
			NEW.id_materiale, depot_type);
	END IF;
END 
//
DELIMITER ; 

DROP TRIGGER IF EXISTS ins_art_fattura; 
DROP TRIGGER IF EXISTS trg_afterInvoiceProductInsert; 
delimiter //
CREATE TRIGGER `trg_afterInvoiceProductInsert` AFTER INSERT ON `fattura_articoli` FOR EACH ROW
BEGIN
	DECLARE allow_insert BIT;
	DECLARE depot_type INT;
	
	SELECT fnc_invoiceProductAllowDepotsScale(NEW.id_fattura, NEW.anno, NEW.id_materiale) INTO allow_insert;

	-- make insert IF allow
	IF allow_insert = 1 THEN
		SET depot_type = 1; -- MAGAZZINO
		CALL sp_ariesDepotsInvoiceProductInsert(NEW.id_fattura, NEW.anno, NEW.n_tab, NEW.quantità,
				NEW.id_materiale, depot_type);
	END IF;
END 
//
delimiter ; 

DROP TRIGGER IF EXISTS ins_art_ddt_ric;  
DROP TRIGGER IF EXISTS trg_afterReceivedDdtProductInsert;
DELIMITER //
CREATE TRIGGER `trg_afterReceivedDdtProductInsert` AFTER INSERT ON `articoli_ddt_ricevuti` FOR EACH ROW BEGIN

	DECLARE allow_movement BIT(1); 
	
	SELECT  fnc_productAllowDepotsScale(NEW.id_articolo)
			INTO allow_movement;

	IF (allow_movement = 1) AND (NEW.causale_scarico IS NOT NULL) THEN
		CALL sp_ariesDepotsReceivedDdtProductInsert(NEW.id_Ddt, NEW.anno, NEW.numero_tab, NEW.quantità,
			NEW.id_articolo, NEW.causale_scarico);
	END IF; 
END 
//
delimiter ; 


DROP TRIGGER IF EXISTS del_art_fatturaforn; 
DROP TRIGGER IF EXISTS trg_beforeSupplierInvoiceProductDelete;
delimiter //
CREATE TRIGGER `trg_beforeSupplierInvoiceProductDelete` BEFORE DELETE ON `fornfattura_articoli` FOR EACH ROW 
BEGIN
	CALL sp_ariesDepotsSupplierInvoiceProductDelete(OLD.id_fattura, OLD.anno, OLD.n_tab);
END 
//
delimiter ; 


DROP TRIGGER IF EXISTS del_art_fattura; 
DROP TRIGGER IF EXISTS trg_beforeInvoiceProductDelete; 
delimiter //
CREATE TRIGGER `trg_beforeInvoiceProductDelete` BEFORE DELETE ON `fattura_articoli` FOR EACH ROW 
BEGIN
	CALL sp_ariesDepotsInvoiceProductDelete(OLD.id_fattura, OLD.anno, OLD.n_tab);
END 
//
delimiter ; 

DROP TRIGGER IF EXISTS del_art_ddt_ric; 
DROP TRIGGER IF EXISTS trg_beforeReceivedDdtProductDelete; 
delimiter //
CREATE TRIGGER `trg_beforeReceivedDdtProductDelete` BEFORE DELETE ON `articoli_ddt_ricevuti` FOR EACH ROW 
BEGIN
	CALL sp_ariesDepotsReceivedDdtProductDelete(OLD.id_ddt, OLD.anno, OLD.numero_tab);
END 
//
delimiter ; 


DROP TRIGGER IF EXISTS delmag; 
DROP TRIGGER IF EXISTS trg_afterDepotOperationDelete; 
delimiter //
CREATE TRIGGER `trg_afterDepotOperationDelete` AFTER DELETE ON `magazzino_operazione` FOR EACH ROW 
BEGIN
	DECLARE LastDepotBlockDate DATE; 
	
	SELECT magazzino_blocco.data 
		INTO LastDepotBlockDate
	FROM magazzino_blocco 
	ORDER BY id_blocco DESC 
	LIMIT 1; 
	
	IF (old.data >= LastDepotBlockDate OR LastDepotBlockDate IS NULL) THEN
		INSERT INTO magazzino 
		SET 
			giacenza = (0 - old.quantità),
			id_articolo = old.articolo,
			tipo_magazzino = old.id_magazzino,
			Data_ins = NOW(), 
			Data_ultimo_movimento = NOW(),
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID
		ON DUPLICATE KEY
		UPDATE
			giacenza=giacenza-old.quantità,
			Data_ultimo_movimento = NOW(),
			Utente_mod = @USER_ID;
	END IF;
END 
//
delimiter ;  


DROP TRIGGER IF EXISTS modmag; 
DROP TRIGGER IF EXISTS trg_afterInsertOperationDelete; 
DROP TRIGGER IF EXISTS trg_afterDepotOperationInsert; 
delimiter //
CREATE TRIGGER `trg_afterDepotOperationInsert` AFTER INSERT ON `magazzino_operazione` FOR EACH ROW 
BEGIN
	DECLARE LastDepotBlockDate DATE; 
	
	SELECT magazzino_blocco.data 
		INTO LastDepotBlockDate
	FROM magazzino_blocco 
	ORDER BY id_blocco DESC 
	LIMIT 1;
	
	IF (new.data >= LastDepotBlockDate OR LastDepotBlockDate IS NULL) THEN
		INSERT INTO magazzino 
		SET 
			giacenza = (0 + new.quantità),
			id_articolo = new.articolo,
			tipo_magazzino = new.id_magazzino,
			Data_ultimo_movimento = NOW(),
			Data_ins = NOW(), 
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID
		ON DUPLICATE KEY
		UPDATE
			giacenza=giacenza+new.quantità,
			Data_ultimo_movimento = NOW(),
			Utente_mod = @USER_ID;
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS upmag; 
DROP TRIGGER IF EXISTS trg_afterDepotOperationUpdate;
DROP TRIGGER IF EXISTS trg_afterInsertOperationUpdate;
delimiter //
CREATE TRIGGER `trg_afterDepotOperationUpdate` AFTER UPDATE ON `magazzino_operazione` FOR EACH ROW 
BEGIN
	DECLARE LastDepotBlockDate DATE; 
	
	SELECT magazzino_blocco.data 
		INTO LastDepotBlockDate
	FROM magazzino_blocco 
	ORDER BY id_blocco DESC 
	LIMIT 1; 
	
	IF (new.data>=LastDepotBlockDate OR LastDepotBlockDate IS NULL) THEN
		INSERT INTO magazzino 
		SET 
			giacenza = new.quantità-old.quantità,
			id_articolo = new.articolo,
			tipo_magazzino = new.id_magazzino,
			Data_ultimo_movimento = NOW(),
			Data_ins = NOW(), 
			Utente_ins = @USER_ID,
			Utente_mod = @USER_ID
		ON DUPLICATE KEY
		UPDATE
			giacenza = giacenza+new.quantità-old.quantità,
			Data_ultimo_movimento = NOW(),
			Utente_mod = @USER_ID;
	END IF;
END
//
delimiter ; 


DROP TRIGGER IF EXISTS ins_maga; 
DROP TRIGGER IF EXISTS trg_afterDepotTypeInsert; 
delimiter //
CREATE TRIGGER `trg_afterDepotTypeInsert` AFTER INSERT ON `tipo_magazzino` FOR EACH ROW 
BEGIN
	INSERT INTO causale_magazzino
	(
		nome,
		operazione,
		tipo_magazzino,
		reso
	)
	VALUES
	(
		CONCAT(new.nome," CARICO"),
		1,
		new.id_tipo,
		new.reso
	),(
		CONCAT(new.nome," SCARICO"),
		2,
		new.id_tipo,
		new.reso
	);
END

//
delimiter ; 



-- ############################# DDT PRODuCT ############################################################################## 
DROP TRIGGER IF EXISTS del_Art_ddt_bf;
DROP TRIGGER IF EXISTS sp_beforeDdtProductDelete; 
DROP TRIGGER IF EXISTS trg_beforeDdtProductDelete; 
delimiter //
CREATE TRIGGER `trg_beforeDdtProductDelete` BEFORE DELETE ON `articoli_ddt` FOR EACH ROW 
BEGIN
	DECLARE has_job_link BIT(1);

	-- ## CHECK JOB STATE
	SELECT fnc_ddtHasJobLink(OLD.id_ddt, OLD.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot insert ddt product becacuse of the job link must be delete before.';
	END IF;

	-- ## RESET DEPOTS STATE
	CALL sp_ariesDepotsDdtProductDelete(OLD.id_ddt, OLD.anno, OLD.numero_tab);

	-- ## RESET SYSTEM PRODUCTS
	CALL sp_ariesSystemsDdtProductDelete(OLD.id_ddt, OLD.anno,
		OLD.id_Articolo, OLD.numero_tab);

END
//
delimiter ; 


DROP TRIGGER IF EXISTS sp_afterDdtProductInsert;
DROP TRIGGER IF EXISTS trg_afterDdtProductInsert;  
DELIMITER //
CREATE TRIGGER `trg_afterDdtProductInsert` AFTER INSERT ON `articoli_ddt` FOR EACH ROW BEGIN		

	DECLARE allow_depots_movement BIT; 
	DECLARE allow_system_movement BIT; 
	DECLARE system_id INT(11);
	
	
	SELECT  fnc_productAllowDepotsScale(NEW.id_articolo)
		INTO allow_depots_movement;


	IF (allow_depots_movement = 1) AND (NEW.causale_scarico IS NOT NULL) THEN
		CALL sp_ariesDepotsDdtProductInsert(NEW.id_Ddt, NEW.anno, NEW.numero_tab, NEW.quantità,
				NEW.id_articolo, NEW.causale_scarico);
	END IF; 

	SELECT fnc_productAllowSystemScale(NEW.id_articolo)
		INTO allow_system_movement;

	IF (allow_system_movement OR allow_system_movement IS NULL) THEN	
		
		SELECT ddt.impianto
			INTO 
			system_id
		FROM ddt 
		WHERE Id_ddt =  NEW.id_ddt AND anno = NEW.anno; 
		
		IF system_id IS NOT NULL AND system_id > 0 THEN
			CALL sp_ariesSystemsDdtProductInsert(NEW.id_Ddt,NEW.anno,NEW.id_articolo,NEW.quantità,NEW.numero_tab,NEW.serial_number);
		END IF;
	END IF;
END 
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_beforeDdtProductInsert;
delimiter //
CREATE TRIGGER `trg_beforeDdtProductInsert` BEFORE INSERT ON `articoli_ddt` FOR EACH ROW 
BEGIN
	DECLARE has_job_link BIT(1);

	SELECT fnc_ddtHasJobLink(NEW.id_ddt, NEW.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot update ddt product becacuse of the job link already exists.';
	END IF;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_beforeDdtProductUpdate;
delimiter //
CREATE TRIGGER `trg_beforeDdtProductUpdate` BEFORE UPDATE ON `articoli_ddt` FOR EACH ROW 
BEGIN
	DECLARE has_job_link BIT(1);

	SELECT fnc_ddtHasJobLink(NEW.id_ddt, NEW.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot update ddt product becacuse of the job link already exists.';
	END IF;
END;
//
DELIMITER ;


DROP TRIGGER IF EXISTS trg_afterDdtProductUpdate;
delimiter //
CREATE TRIGGER `trg_afterDdtProductUpdate` AFTER UPDATE ON `articoli_ddt` FOR EACH ROW 
BEGIN
	DECLARE allow_depots_movement BIT; 
	DECLARE allow_system_movement BIT; 
	DECLARE system_id INT(11);

	-- UNDO PREVIOUS STATE
	CALL sp_ariesDepotsDdtProductDelete(OLD.id_ddt, OLD.anno, OLD.numero_tab);
	CALL sp_ariesSystemsDdtProductDelete(OLD.id_ddt, OLD.anno,
	  OLD.id_Articolo, OLD.numero_tab);

	
	-- SCALE BASED ON NEW PRODUCT
	SELECT  fnc_productAllowDepotsScale(NEW.id_articolo)
		INTO allow_depots_movement;

	IF (allow_depots_movement = 1) AND (NEW.causale_scarico IS NOT NULL) THEN
		CALL sp_ariesDepotsDdtProductInsert(NEW.id_Ddt, NEW.anno, NEW.numero_tab, NEW.quantità,
				NEW.id_articolo, NEW.causale_scarico);
	END IF; 

	SELECT fnc_productAllowSystemScale(NEW.id_articolo)
		INTO allow_system_movement;

	IF (allow_system_movement OR allow_system_movement IS NULL) THEN	
		
		SELECT ddt.impianto
			INTO 
			system_id
		FROM ddt 
		WHERE Id_ddt =  NEW.id_ddt AND anno = NEW.anno; 
		
		IF system_id IS NOT NULL AND system_id > 0 THEN
			CALL sp_ariesSystemsDdtProductInsert(NEW.id_Ddt,NEW.anno,NEW.id_articolo,NEW.quantità,NEW.numero_tab,NEW.serial_number);
		END IF;
	END IF;
END;
//
DELIMITER ;

-- ############################# REPORT PRODuCT ############################################################################## 
DROP TRIGGER IF EXISTS trg_beforeReportProductUpdate;
delimiter //
CREATE TRIGGER `trg_beforeReportProductUpdate` BEFORE UPDATE ON `rapporto_materiale` FOR EACH ROW 
BEGIN
	DECLARE has_job_link BIT(1);

	SELECT fnc_reportHasJobLink(NEW.id_rapporto, NEW.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot update report product becacuse of the job link already exists.';
	END IF;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_afterReportProductUpdate;
delimiter //
CREATE TRIGGER `trg_afterReportProductUpdate` AFTER UPDATE ON `rapporto_materiale` FOR EACH ROW 
BEGIN
	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS ins_rap_art;
DROP TRIGGER IF EXISTS trg_beforeReportProductInsert;
delimiter //
CREATE TRIGGER `trg_beforeReportProductInsert` BEFORE INSERT ON `rapporto_materiale` FOR EACH ROW 
BEGIN

	DECLARE report_exec_date DATE;
	DECLARE has_job_link BIT(1);

	SELECT fnc_reportHasJobLink(NEW.id_rapporto, NEW.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot insert report product becacuse of the job link already exists.';
	END IF;

END
//
DELIMITER ;

delimiter //
DROP TRIGGER IF EXISTS trg_afterReportProductInsert;
CREATE TRIGGER `trg_afterReportProductInsert` AFTER INSERT ON `rapporto_materiale` FOR EACH ROW 
BEGIN
	DECLARE allow_insert BIT(1);
	DECLARE is_kit BIT(1);

	IF new.id_materiale IS NOT NULL THEN

		SELECT  fnc_productAllowDepotsScale(new.id_materiale)
			INTO allow_insert;

			
		-- CHECK IF IS PRODCUT AND HAI DEPOTS ID
		IF (allow_insert = 1) AND (new.id_magazzino IS NOT NULL) THEN
			CALL sp_ariesDepotsScaleByReportProduct(new.id_rapporto, new.anno, new.id_tab,
				new.quantità, new.id_materiale);
		END IF;
	END IF;

	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END
//
DELIMITER ;

DROP TRIGGER IF EXISTS del_rap_mat;
DROP TRIGGER IF EXISTS trg_beforeReportProductDelete;
delimiter //
CREATE TRIGGER `trg_beforeReportProductDelete` BEFORE DELETE ON `rapporto_materiale` FOR EACH ROW
BEGIN
	DECLARE has_job_link BIT(1);

	SELECT fnc_reportHasJobLink(OLD.id_rapporto, OLD.anno)
		INTO has_job_link;
	IF has_job_link = 1 THEN
		SIGNAL SQLSTATE '45000'
     	SET MESSAGE_TEXT = 'Cannot insert report product becacuse of the job link must be delete before.';
	END IF;
	
	CALL sp_ariesDepotsReportProductDelete(old.id_rapporto, old.anno, old.id_tab);
END
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_afterReportProductDelete;
delimiter //
CREATE TRIGGER `trg_afterReportProductDelete` AFTER DELETE ON `rapporto_materiale` FOR EACH ROW
BEGIN
	CALL sp_ariesReportTotalsRefresh(OLD.id_rapporto, OLD.anno);
END
//
DELIMITER ;



-- ############################# CUSTOMERS ############################################################################## 

DROP TRIGGER IF EXISTS trg_afterCustomerInsert; 
DELIMITER //
CREATE TRIGGER `trg_afterCustomerInsert` AFTER INSERT ON clienti FOR EACH ROW 
BEGIN

		
END
//
DELIMITER ; 

DROP TRIGGER IF EXISTS trg_afterCustomerUpdate; 
DELIMITER //
CREATE TRIGGER `trg_afterCustomerUpdate` AFTER UPDATE ON clienti FOR EACH ROW 
BEGIN

		
END
//
DELIMITER ; 

DROP TRIGGER IF EXISTS trg_afterCustomerDelete; 
DELIMITER //
CREATE TRIGGER `trg_afterCustomerDelete` AFTER DELETE ON clienti FOR EACH ROW 
BEGIN

		
END
//
DELIMITER ; 

-- ############################# INVOICES ############################################################################## 

DELIMITER //
DROP TRIGGER IF EXISTS paga_update; 
CREATE TRIGGER `paga_update` AFTER UPDATE ON `fattura_pagamenti` FOR EACH ROW 
BEGIN

	CALL sp_ariesInvoiceEvaluateStatus(new.Id_fattura, new.anno); 

END
//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS paga_insert; 
CREATE TRIGGER `paga_insert` AFTER INSERT ON `fattura_pagamenti` FOR EACH ROW 
BEGIN

	CALL sp_ariesInvoiceEvaluateStatus(new.Id_fattura, new.anno); 
	
END
//
DELIMITER ;



DELIMITER //
DROP TRIGGER IF EXISTS trg_afterQuoteUpdate; 
CREATE TRIGGER `trg_afterQuoteUpdate` AFTER UPDATE ON `preventivo` FOR EACH ROW 
BEGIN
	if (old.Stato <> new.Stato) AND (new.Stato IN (1,6,7,8)) THEN
	
		CALL sp_ariesQuoteConvertTempProducts(new.Id_preventivo, new.anno); 
	
	END IF;
END
//
DELIMITER ;

-- ############################# JOBS ############################################################################## 
DELIMITER //
DROP TRIGGER IF EXISTS trg_afterJobInsert; 
CREATE TRIGGER `trg_afterJobInsert` AFTER INSERT ON `commessa` FOR EACH ROW 
BEGIN
	CALL sp_ariesJobInitSettings(NEW.id_commessa, NEW.anno);
END
//
DELIMITER ;


-- ############################# JOB DDT LINK ############################################################################## 
DELIMITER //
DROP TRIGGER IF EXISTS trg_afterJobDdtLinkDelete; 
CREATE TRIGGER `trg_afterJobDdtLinkDelete` AFTER DELETE ON `commessa_ddt` FOR EACH ROW 
BEGIN
	CALL sp_ariesJobUndoScaleDdt(OLD.id_commessa, OLD.anno_commessa, OLD.id_sottocommessa, OLD.id_lotto, OLD.id_ddt, OLD.anno_ddt);
END
//
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS trg_afterJobDdtLinkInsert; 
DROP TRIGGER IF EXISTS stat_com; 
CREATE TRIGGER `trg_afterJobDdtLinkInsert` AFTER INSERT ON `commessa_ddt` FOR EACH ROW 
BEGIN
	CALL sp_ariesJobScaleDdt(NEW.id_commessa, NEW.anno_commessa, NEW.id_sottocommessa, NEW.id_lotto, NEW.id_ddt, NEW.anno_ddt);
	
	UPDATE commessa
	SET stato_commessa=3 
		WHERE stato_commessa = 1 AND id_commessa = NEW.id_commessa
		AND anno = NEW.anno_commessa;
END
//
DELIMITER ;

-- ############################# JOB REPORT LINK ############################################################################## 
DELIMITER //
DROP TRIGGER IF EXISTS trg_afterJobReportLinkDelete; 
CREATE TRIGGER `trg_afterJobReportLinkDelete` AFTER DELETE ON `commessa_rapporto` FOR EACH ROW 
BEGIN
	CALL sp_ariesJobUndoScaleReport(OLD.id_commessa, OLD.anno_commessa, OLD.id_sottocommessa, OLD.id_lotto, OLD.id_rapporto, OLD.anno_rapporto);
END
//
DELIMITER ;


DELIMITER //
DROP TRIGGER IF EXISTS trg_afterJobReportLinkInsert; 
CREATE TRIGGER `trg_afterJobReportLinkInsert` AFTER INSERT ON `commessa_rapporto` FOR EACH ROW 
BEGIN
	CALL sp_ariesJobScaleReport(NEW.id_commessa, NEW.anno_commessa, NEW.id_sottocommessa, NEW.id_lotto, NEW.id_rapporto, NEW.anno_rapporto);
END
//
DELIMITER ;


-- ############################# JOB PRODUCTS ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterJobProductsUpdate; 
DELIMITER //
CREATE TRIGGER `trg_afterJobProductsUpdate` BEFORE UPDATE ON commessa_articoli FOR EACH ROW 
BEGIN
	IF (NEW.preventivati <> OLD.preventivati)
		OR (NEW.`quantità` <> OLD.`quantità`)
		OR (NEW.`costo_ora` <> OLD.`costo_ora`)
		OR (NEW.`prezzo_ora` <> OLD.`prezzo_ora`)
		OR (NEW.`costo` <> OLD.`costo`)
		OR (NEW.`prezzo` <> OLD.`prezzo`)
		OR (NEW.`tempo` <> OLD.`tempo`)
		OR (NEW.`sconto` <> OLD.`sconto`)
		OR (NEW.`portati` <> OLD.`portati`)
	THEN
		CALL sp_ariesJobProductHistoryCreate(NEW.id_commessa, NEW.anno, NEW.id_sottocommessa, NEW.id_lotto, NEW.id_tab);
	END IF;
END
//
DELIMITER ; 

-- ############################# DDT REPORT LINK ############################################################################## 
DELIMITER //
DROP TRIGGER IF EXISTS trg_afterDdtReportLinkDelete; 
CREATE TRIGGER `trg_afterDdtReportLinkDelete` AFTER DELETE ON `ddt_rapporto` FOR EACH ROW 
BEGIN

	-- check for job scale
	DECLARE job_id INT(11);
	DECLARE job_year INT(11);
	DECLARE sub_job_id INT(11);
	DECLARE lot_id INT(11);

	SELECT id_commessa,
		anno_commessa,
		id_sottocommessa,
		id_lotto
	INTO job_id,
		job_year,
		sub_job_id,
		lot_id
	FROM commessa_rapporto
	WHERE id_rapporto = OLD.id_rapporto AND anno_rapporto = OLD.anno_rapporto;

	IF job_id IS NOT NULL THEN
		CALL sp_ariesJobScaleReport(job_id, job_year, sub_job_id, lot_id, OLD.id_rapporto, OLD.anno_rapporto);
	END IF;
	
	-- check for depots scale
	CALL sp_ariesDepotsScaleByReport(OLD.id_rapporto, OLD.anno_rapporto);
END
//
DELIMITER ;


DELIMITER //
DROP TRIGGER IF EXISTS trg_afterDdtReportLinkInsert; 
CREATE TRIGGER `trg_afterDdtReportLinkInsert` BEFORE INSERT ON `ddt_rapporto` FOR EACH ROW 
BEGIN
	-- check for job scale
	DECLARE job_id INT(11);
	DECLARE job_year INT(11);
	DECLARE sub_job_id INT(11);
	DECLARE lot_id INT(11);

	SELECT id_commessa,
		anno_commessa,
		id_sottocommessa,
		id_lotto
	INTO job_id,
		job_year,
		sub_job_id,
		lot_id
	FROM commessa_rapporto
	WHERE id_rapporto = NEW.id_rapporto AND anno_rapporto = NEW.anno_rapporto;

	IF job_id IS NOT NULL THEN
		CALL sp_ariesJobUndoScaleReport(job_id, job_year, sub_job_id, lot_id, NEW.id_rapporto, NEW.anno_rapporto);
	END IF;

	-- check for depots scale
	CALL sp_ariesDepotsUndoScaleByReport(NEW.id_rapporto, NEW.anno_rapporto);
END
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_afterSystemComponentVersionInsert; 
delimiter //
CREATE TRIGGER `trg_afterSystemComponentVersionInsert` AFTER INSERT ON `impianto_componenti_versione` FOR EACH ROW 
BEGIN
	UPDATE impianto_componenti
	SET id_versione = new.id_versione
	WHERE id_impianto = new.id_impianto AND id_articolo = new.id_articolo AND id = new.codice;
END

//
delimiter ; 


DROP TRIGGER IF EXISTS trg_afterSystemComponentVersionDelete; 
delimiter //
CREATE TRIGGER `trg_afterSystemComponentVersionDelete` AFTER DELETE ON `impianto_componenti_versione` FOR EACH ROW 
BEGIN
	DECLARE version_id INT(11) DEFAULT NULL;

	SELECT MAX(id_versione)
		INTO version_id
	FROM impianto_componenti_versione
	WHERE id_impianto = old.id_impianto AND id_articolo = old.id_articolo AND codice = old.codice;

	
	UPDATE impianto_componenti
	SET id_versione = version_id
	WHERE id_impianto = old.id_impianto AND id_articolo = old.id_articolo AND id = old.codice;
END

//
delimiter ; 


-- ############################# SUPPLIERS ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterSupplierInsert; 
DROP TRIGGER IF EXISTS insforn; 
DELIMITER //
CREATE TRIGGER `trg_afterSupplierInsert` AFTER INSERT ON `fornitore` FOR EACH ROW
BEGIN
	DECLARE price_name VARCHAR(150);
	DECLARE net_name VARCHAR(150);
	DECLARE last_name VARCHAR(150);
	DECLARE special_name VARCHAR(150);

	SET price_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Prezzo");
	SET net_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Netto");
	SET last_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Ultimo");
	SET special_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Speciale");

	INSERT INTO listino(nome) values (price_name), (net_name), (last_name), (special_name);

	INSERT into fornitore_listino (id_fornitore,acquisto,netto,ultimo,speciale,nome)
	select
		NEW.id_fornitore,
		(select id_listino from listino where nome = price_name),
		(select id_listino from listino where nome = net_name),
		(select id_listino from listino where nome = last_name),
		(select id_listino from listino where nome = special_name),
		NEW.ragione_sociale;

END
//
DELIMITER ;

DROP TRIGGER IF EXISTS trg_afterSupplierUpdate; 
DELIMITER //
CREATE TRIGGER `trg_afterSupplierUpdate` AFTER UPDATE ON `fornitore` FOR EACH ROW
BEGIN
	DECLARE price_name VARCHAR(150);
	DECLARE net_name VARCHAR(150);
	DECLARE last_name VARCHAR(150);
	DECLARE special_name VARCHAR(150);

	DECLARE old_price_name VARCHAR(150);
	DECLARE old_net_name VARCHAR(150);
	DECLARE old_last_name VARCHAR(150);
	DECLARE old_special_name VARCHAR(150);

	IF NEW.ragione_sociale <> OLD.ragione_sociale THEN
		SET price_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Prezzo");
		SET net_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Netto");
		SET last_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Ultimo");
		SET special_name = CONCAT(NEW.id_fornitore,substring(NEW.ragione_sociale,1,8),"Speciale");
		
		SET old_price_name = CONCAT(OLD.id_fornitore,substring(OLD.ragione_sociale,1,8),"Prezzo");
		SET old_net_name = CONCAT(OLD.id_fornitore,substring(OLD.ragione_sociale,1,8),"Netto");
		SET old_last_name = CONCAT(OLD.id_fornitore,substring(OLD.ragione_sociale,1,8),"Ultimo");
		SET old_special_name = CONCAT(OLD.id_fornitore,substring(OLD.ragione_sociale,1,8),"Speciale");

		UPDATE listino SET nome = price_name WHERE nome = old_price_name;
		UPDATE listino SET nome = net_name WHERE nome = old_net_name;
		UPDATE listino SET nome = last_name WHERE nome = old_last_name;
		UPDATE listino SET nome = special_name WHERE nome = old_special_name;

		UPDATE fornitore_listino
		SET nome =NEW.ragione_sociale
		WHERE id_fornitore = new.id_fornitore;
	END IF;
END
//
DELIMITER ;


DROP TRIGGER IF EXISTS trg_afterSupplerPriceListDelete; 
DELIMITER //
CREATE TRIGGER `trg_afterSupplerPriceListDelete` AFTER DELETE ON `fornitore_listino` FOR EACH ROW 
BEGIN
	DELETE FROM listino WHERE id_listino IN (OLD.netto,OLD.ultimo,OLD.speciale);	
END
//
DELIMITER ;


-- ############################# REPORTS  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportInsert` AFTER INSERT ON `rapporto` FOR EACH ROW 
BEGIN	
	INSERT INTO  rapporto_totali (id_rapporto, anno, costo_manutenzione, costo_lavoro, prezzo_lavoro, costo_viaggio, prezzo_viaggio, costo_materiale, prezzo_materiale, costo_totale, prezzo_totale)
	VALUES (NEW.id_rapporto, NEW.anno, 0, 0, 0, 0, 0, 0, 0, 0, 0);
END
//
delimiter ; 

-- ############################# REPORT WORK  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportWorkInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportWorkInsert` AFTER INSERT ON `rapporto_tecnico_lavoro` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportWorkUpdate; 
delimiter //
CREATE TRIGGER `trg_afterReportWorkUpdate` AFTER UPDATE ON `rapporto_tecnico_lavoro` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportWorkDelete; 
delimiter //
CREATE TRIGGER `trg_afterReportWorkDelete` AFTER DELETE ON `rapporto_tecnico_lavoro` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(OLD.id_rapporto, OLD.anno);
END
//
delimiter ; 

-- ############################# REPORT TECHNICIAN  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportTechnicianInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportTechnicianInsert` AFTER INSERT ON `rapporto_tecnico` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportTechnicianUpdate; 
delimiter //
CREATE TRIGGER `trg_afterReportTechnicianUpdate` AFTER UPDATE ON `rapporto_tecnico` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportTechnicianDelete; 
delimiter //
CREATE TRIGGER `trg_afterReportTechnicianDelete` AFTER DELETE ON `rapporto_tecnico` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportTotalsRefresh(OLD.id_rapporto, OLD.anno);
END
//
delimiter ; 

-- ############################# REPORT TOTALS  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportTotalsInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportTotalsInsert` AFTER INSERT ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportTotalsUpdate; 
delimiter //
CREATE TRIGGER `trg_afterReportTotalsUpdate` AFTER UPDATE ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(NEW.id_rapporto, NEW.anno);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportTotalsDelete; 
delimiter //
CREATE TRIGGER `trg_afterReportTotalsDelete` AFTER DELETE ON `rapporto_totali` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefreshByReport(OLD.id_rapporto, OLD.anno);
END
//
delimiter ; 

-- ############################# REPORT GROUP REPORT LINK  ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkInsert` AFTER INSERT ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(NEW.id_resoconto, NEW.anno_reso);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkUpdate; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkUpdate` AFTER UPDATE ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(NEW.id_resoconto, NEW.anno_reso);
	
	IF (OLD.id_resoconto <> NEW.id_resoconto OR OLD.anno_reso <> NEW.anno_reso) THEN
		CALL sp_ariesReportGroupTotalsRefresh(OLD.id_resoconto, OLD.anno_reso);
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterReportGroupReportLinkDelete; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupReportLinkDelete` AFTER DELETE ON `resoconto_rapporto` FOR EACH ROW 
BEGIN	
	CALL sp_ariesReportGroupTotalsRefresh(OLD.id_resoconto, OLD.anno_reso);
END
//
delimiter ; 



-- ############################# REPORTS GROUPS ############################################################################## 
DROP TRIGGER IF EXISTS trg_afterReportGroupInsert; 
delimiter //
CREATE TRIGGER `trg_afterReportGroupInsert` AFTER INSERT ON `resoconto` FOR EACH ROW 
BEGIN	
	INSERT INTO  resoconto_totali (id_resoconto, anno, prezzo_manutenzione, costo_manutenzione, costo_diritto_chiamata, prezzo_diritto_chiamata, costo_lavoro, prezzo_lavoro, costo_viaggio, prezzo_viaggio, costo_materiale, prezzo_materiale, costo_totale, prezzo_totale)
	VALUES (NEW.id_resoconto, NEW.anno, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
END

//
delimiter ; 


-- ############################# SYSTEM SUBSCRIPTIONS ##################################################################### 
DROP TRIGGER IF EXISTS trg_afterSystemSubscriptionInsert; 
delimiter //
CREATE TRIGGER `trg_afterSystemSubscriptionInsert` AFTER INSERT ON `impianto_abbonamenti` FOR EACH ROW 
BEGIN	
	CALL sp_ariesSystemCurrentSubscriptionRefresh(NEW.id_impianto);
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterSystemSubscriptionUpdate; 
delimiter //
CREATE TRIGGER `trg_afterSystemSubscriptionUpdate` AFTER UPDATE ON `impianto_abbonamenti` FOR EACH ROW 
BEGIN
	IF (OLD.id_impianto <> NEW.id_impianto) THEN
		CALL sp_ariesSystemCurrentSubscriptionRefresh(OLD.id_impianto);
		CALL sp_ariesSystemCurrentSubscriptionRefresh(NEW.id_impianto);
	ELSEIF (OLD.id_abbonamenti <> NEW.id_abbonamenti) THEN
		CALL sp_ariesSystemCurrentSubscriptionRefresh(OLD.id_impianto);
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterSystemSubscriptionDelete; 
delimiter //
CREATE TRIGGER `trg_afterSystemSubscriptionDelete` AFTER DELETE ON `impianto_abbonamenti` FOR EACH ROW 
BEGIN	
	CALL sp_ariesSystemCurrentSubscriptionRefresh(OLD.id_impianto);
END
//
delimiter ; 


-- ############################# TICKETS ##################################################################### 
DROP TRIGGER IF EXISTS trg_beforeTicketInsert; 
delimiter //
CREATE TRIGGER `trg_beforeTicketInsert` BEFORE INSERT ON `ticket` FOR EACH ROW 
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);

	IF NEW.data_promemoria IS NOT NULL THEN
		CALL sp_ariesTicketEnsureReminderEvent(
			NEW.id_ticket,
			NEW.anno,
			NEW.id_impianto,
			NEW.id_cliente,
			NEW.urgenza,
			NEW.data_promemoria,
			NEW.id_evento_promemoria,
			NEW.scadenza,
			NEW.id_evento_scadenza,
			NEW.descrizione,
			reminder_event_id
		);
		SET NEW.id_evento_promemoria = reminder_event_id;
	END IF;

	
	IF NEW.scadenza IS NOT NULL THEN
		CALL sp_ariesTicketEnsureExpirationEvent(
			NEW.id_ticket,
			NEW.anno,
			NEW.id_impianto,
			NEW.id_cliente,
			NEW.urgenza,
			NEW.data_promemoria,
			NEW.id_evento_promemoria,
			NEW.scadenza,
			NEW.id_evento_scadenza,
			NEW.descrizione,
			expiration_event_id
		);
		SET NEW.id_evento_scadenza = expiration_event_id;
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_beforeTicketUpdate; 
delimiter //
CREATE TRIGGER `trg_beforeTicketUpdate` BEFORE UPDATE ON `ticket` FOR EACH ROW 
BEGIN
	DECLARE reminder_event_id INT(11);
	DECLARE expiration_event_id INT(11);

	IF NEW.stato_ticket != OLD.stato_ticket AND NEW.stato_ticket IN (3, 4) THEN
		CALL sp_ariesTicketDeleteReminderEvent(NEW.id_ticket, NEW.anno);
		CALL sp_ariesTicketDeleteExpirationEvent(NEW.id_ticket, NEW.anno);

		SET NEW.id_evento_promemoria = NULL;
		SET NEW.id_evento_scadenza = NULL;
	ELSE
		IF NEW.data_promemoria IS NULL THEN
			CALL sp_ariesTicketDeleteReminderEvent(NEW.id_ticket, NEW.anno);
			SET NEW.id_evento_promemoria = NULL;
		ELSE
			CALL sp_ariesTicketEnsureReminderEvent(
				NEW.id_ticket,
				NEW.anno,
				NEW.id_impianto,
				NEW.id_cliente,
				NEW.urgenza,
				NEW.data_promemoria,
				NEW.id_evento_promemoria,
				NEW.scadenza,
				NEW.id_evento_scadenza,
				NEW.descrizione,
				reminder_event_id
			);
			SET NEW.id_evento_promemoria = reminder_event_id;
		END IF;
		
		IF NEW.scadenza IS NULL THEN
			CALL sp_ariesTicketDeleteExpirationEvent(NEW.id_ticket, NEW.anno);
			SET NEW.id_evento_scadenza = NULL;
		ELSE
			CALL sp_ariesTicketEnsureExpirationEvent(
				NEW.id_ticket,
				NEW.anno,
				NEW.id_impianto,
				NEW.id_cliente,
				NEW.urgenza,
				NEW.data_promemoria,
				NEW.id_evento_promemoria,
				NEW.scadenza,
				NEW.id_evento_scadenza,
				NEW.descrizione,
				expiration_event_id
			);
			SET NEW.id_evento_scadenza = expiration_event_id;
		END IF;
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_beforeTicketDelete; 
delimiter //
CREATE TRIGGER `trg_beforeTicketDelete` BEFORE DELETE ON `ticket` FOR EACH ROW 
BEGIN	
	CALL sp_ariesTicketDeleteReminderEvent(OLD.id_ticket, OLD.anno);
	CALL sp_ariesTicketDeleteExpirationEvent(OLD.id_ticket, OLD.anno);
END
//

delimiter ; 

-- ############################# CONTRACTS ##################################################################### 
DROP TRIGGER IF EXISTS trg_beforeContractInsert; 
delimiter //
CREATE TRIGGER `trg_beforeContractInsert` BEFORE INSERT ON `contratto` FOR EACH ROW 
BEGIN
	SET NEW.data_inserimento = NOW();
	SET NEW.data=NOW();

	IF NEW.tipo_stampa IS NULL THEN
		SET NEW.tipo_stampa = (SELECT CAST(var_value AS UNSIGNED) FROM environment_variables WHERE var_key = 'DEFAULT_CONTRACT_PRINT_TYPE');
	END IF;

	IF NEW.iban IS NULL THEN
		SET NEW.iban = (SELECT iban FROM azienda ORDER BY id_azienda DESC LIMIT 1);
	END IF;

	IF NEW.pagamento IS NULL THEN
		SET NEW.pagamento = (SELECT condizione_pagamento FROM clienti WHERE id_cliente=NEW.id_cliente);
	END IF;

	IF NEW.id_destinazione IS NULL THEN
		SET NEW.id_destinazione = (SELECT destinazione FROM revisione_preventivo WHERE id_preventivo = NEW.id_preventivo AND anno = NEW.anno AND id_revisione = NEW.id_revisione);
	END IF;
	
	IF NEW.signor IS NULL THEN
		SET NEW.signor = (SELECT cortese FROM revisione_preventivo WHERE id_preventivo = NEW.id_preventivo AND anno = NEW.anno AND id_revisione = NEW.id_revisione);
	END IF;

	IF (NEW.signor IS NOT NULL) AND (NEW.telefono IS NULL) THEN
		SET NEW.telefono = (SELECT IF(altro_telefono = '' OR altro_telefono IS NULL, telefono, altro_telefono) FROM riferimento_clienti rc WHERE rc.Nome = NEW.signor AND id_cliente = NEW.id_cliente);
	END IF;
END
//
delimiter ; 

DROP TRIGGER IF EXISTS trg_afterContractInsert; 
delimiter //
CREATE TRIGGER `trg_afterContractInsert` AFTER INSERT ON `contratto` FOR EACH ROW 
BEGIN
	IF NEW.tipo_contratto = 2 THEN
		INSERT INTO contratto_impianto_mese(id_contratto, id_impianto, id_mese)
		SELECT NEW.id_contratto,
			id_impianto,
			numero
		FROM preventivo_articolo_abbonamento
        	INNER JOIN preventivo_lotto ON posizione=preventivo_articolo_abbonamento.id_lotto
				AND preventivo_articolo_abbonamento.anno=preventivo_lotto.anno
        		AND preventivo_articolo_abbonamento.id_Preventivo=preventivo_lotto.id_preventivo
				AND preventivo_articolo_abbonamento.revisione=preventivo_lotto.id_revisione
        WHERE preventivo_articolo_abbonamento.id_preventivo = NEW.id_preventivo
        	AND preventivo_articolo_abbonamento.anno = NEW.anno
    		AND preventivo_articolo_abbonamento.revisione = NEW.id_revisione
        	AND numero <= 12; 

			


		INSERT INTO contratto_paragrafo (id_contratto, id_tipo, id_paragrafo, nome, descrizione)
		SELECT NEW.id_contratto,
			2,
			id_paragrafo,
			nome,
			descrizione
		FROM contratto_modello_paragrafo
		WHERE id_tipo = 3;

	END IF;
END
//
delimiter ; 
