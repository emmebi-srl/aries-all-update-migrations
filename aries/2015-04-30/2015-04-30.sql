
--

SOSTITUIRE REPORT ORDINE.RAV, PREVENTIVO.RAV, commessa


			DROP TRIGGER IF EXISTS ins_art_ddt;
			delimiter //
			CREATE
				TRIGGER ins_art_ddt
				after insert
				ON articoli_ddt FOR EACH ROW
			BEGIN

			if (new.id_Articolo IS NOT NULL) AND (new.causale_scarico IS NOT NULL) then


				if(SELECT operazione FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))="1" then

					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino,causale) VALUES(
					(SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("+",new.quantità),
					new.causale_scarico, (SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=new.causale_scarico AND operazione=1));

					INSERT INTO magazzino_ddt_emessi(id_operazione, anno_ddt, id_ddt, id_tab) VALUES((SELECT MAX(id_operazione) FROM magazzino_operazione),new.anno,new.id_Ddt,new.numero_tab);
				end if;
				
				if(SELECT operazione FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))="2" then
					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino,causale) VALUES(
					(SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("-",new.quantità),
					new.causale_scarico, (SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=new.causale_scarico AND operazione=2));
					INSERT INTO magazzino_ddt_emessi(id_operazione, anno_ddt, id_ddt, id_tab) VALUES((SELECT MAX(id_operazione) FROM magazzino_operazione),new.anno,new.id_Ddt,new.numero_tab);
				end if;
				
				if (SELECT operazione FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))="3" then
					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino, causale)
					values((SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("+",new.quantità),new.causale_scarico, (SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=new.causale_scarico AND operazione=1));

					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino,causale)
					values((SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("-",new.quantità), (SELECT ID_MAGA FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno)),
					(SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=(SELECT ID_MAGA FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))
					and operazione=2));

					INSERT INTO magazzino_ddt_emessi(id_operazione, id_reso, anno_ddt, id_ddt, id_tab) VALUES(
					(SELECT MAX(id_operazione)-1 FROM magazzino_operazione), (SELECT MAX(id_operazione) FROM magazzino_operazione),new.anno,new.id_Ddt,new.numero_tab);
				end if;
				
				if (SELECT operazione FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))="4" then
					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino, causale)
					values((SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("-",new.quantità),new.causale_scarico, (SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=new.causale_scarico AND operazione=2));

					INSERT INTO magazzino_operazione (data,articolo,quantità, id_magazzino,causale)
					values((SELECT data_documento FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno),new.id_articolo, CONCAT("+",new.quantità), (SELECT ID_MAGA FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno)),
					(SELECT id_causale FROM causale_magazzino WHERE tipo_magazzino=(SELECT ID_MAGA FROM causale_trasporto WHERE id_causale=(SELECT causale FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno))
					and operazione=1));

					INSERT INTO magazzino_ddt_emessi(id_operazione, id_reso, anno_ddt, id_ddt, id_tab) VALUES(
					(SELECT MAX(id_operazione)-1 FROM magazzino_operazione), (SELECT MAX(id_operazione) FROM magazzino_operazione),new.anno,new.id_Ddt,new.numero_tab);
				end if;



			end if;


			if (SELECT codice_articolo  FROM articolo WHERE codice_articolo=new.id_articolo AND not(categoria=17 or categoria=18 or categoria=85 or categoria=80 or categoria=99
			or categoria=89 or categoria=91 or categoria=90 or categoria=92 or categoria=93 or categoria=94 or categoria=95 or categoria=96 or categoria=97 or categoria=98
			or categoria=51))<>"" then
			if (new.quantità<99) AND ((SELECT IF(new.quantità mod 1=0,"1","0"))="1") then

			if (SELECT impianto FROM ddt WHERE id_ddt=new.id_ddt AND anno=new.anno)<>"" then
			call sp_ariesSystemsDdtProductInsert(new.id_Ddt,new.anno,new.id_articolo,new.quantità,new.numero_tab);

			end if;
			end if;
			end if;

			end
			//DELIMITER;
			
	
			INSERT INTO mail_stato VALUES(5, "BOZZA");
			alter table evento add column oggetto varchar(100);
			alter table collaudo add column tecnici TEXT after mail_responsabile;
			
drop procedure  CollaudoToRapporto ;
delimiter //

CREATE PROCEDURE CollaudoToRapporto (ID INT, ANNOP INT)
BEGIN

  DECLARE  i INT;
  SET i=0;

    INSERT INTO rapporto_mobile
    (stato, scan, id_rapporto, anno, id_impianto, id_destinazione, id_cliente, richiesto, email_invio, tipo_intervento, Diritto_chiamata, dir_ric_fatturato, relazione, Note_Generali, `data`, data_esecuzione, festivo, su_chiamata, eff_giorn, sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, fuoriabbon, man_straord, tipo_impianto, ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, id_riferimento, mail_responsabile, appunti, tecnici, inviato, visionato, id_utente, numero, Nr_rapporto )
    select
    "1", "1", id_collaudo_invio, anno, id_impianto, IF(id_impianto IS NULL, "1", (SELECT destinazione FROM impianto WHERE impianto.id_impianto=collaudo.id_impianto)), id_cliente, IF(richiesto IS NULL, "", richiesto), mail, "7", "0","0", "Generato da Rapporto di Collaudo",note, `data`,`data`, 0, 0,0,0,0, "",0,0,0,0,0,0,0, IF(furto=1, "furto", IF(incendio=1, "incendio", IF(tvcc=1, "circuito chiuso", "macro"))), cliente, "", "","", "", id_riferimento, mail_responsabile, appunti, tecnici, 1, 0, id_utente, id_collaudo_invio, id_collaudo_invio FROM collaudo WHERE id_collaudo_invio=ID AND anno=ANNOP ;

    INSERT INTO rapporto_tecnico_mobile SELECT id_collaudo_invio, anno, tecnici, "a contratto", 0,0,0, km, orespo1,0, "", NULL, NULL,oreint1, NULL, NULL, 0, "","",nviaggi FROM collaudo WHERE id_collaudo_invio=ID AND anno=ANNOP ;

  WHILE i<=6 DO
    INSERT INTO rapporto_materiali_mobile VALUES(ID, ANNOP, i, "","");
    SET i=i+1;
  END WHILE;


END
// delimiter ;

drop procedure CreaBozza;
delimiter //

CREATE PROCEDURE CreaBozza (mittente INT, id_utenteP int, OUT ID_MAILP INT)
BEGIN
  DECLARE ID int;
  SET ID=-1;
  SELECT MAX(id_mail)+1 INTO ID FROM mail;
  IF(ID=-1) then
    SET ID=1;
  END IF ;

  INSERT INTO MAIL (id_mail, oggetto, stato, mittente, data_ora_sped, tentativo, id_utente)
        VALUES(ID, "", 5, mittente, NOW(), 0, id_utenteP);

  SET ID_MAILP=ID;

END
// delimiter ;



alter table abbonamento add column materiali_fatt integer(11) default 0;



-- FUTURE

CREATE TABLE if not exists collaudo_tecnici(
 id_collaudo varchar(15),
 anno varchar(15),
 id_tecnico varchar(15),
 PRIMARY KEY (id_collaudo, anno, id_tecnico)
       )
		
	

		
		


		
		DELIMITER $$

DROP PROCEDURE IF EXISTS `max_id_rapporto` $$
CREATE DEFINER=`root`@`%` PROCEDURE `max_id_rapporto`(OUT id_rapportoo INT)
BEGIN
  declare id_rapp INT;
  declare id_rapp_mobile INT;
  declare id_coll INT;

  SELECT MAX(a.id_rapporto)+1 INTO id_rapp FROM rapporto AS a WHERE anno=year(curdate());
  SELECT MAX(a.id_rapporto)+1 INTO id_rapp_mobile FROM rapporto_mobile AS a WHERE anno=year(curdate());
  SELECT MAX(a.id_collaudo_invio)+1 into id_coll FROM collaudo AS a WHERE anno=year(curdate());

  if id_rapp>id_rapp_mobile then
    SET id_rapportoo=id_rapp;
  else
    SET id_rapportoo=id_rapp_mobile;
  end if;

  if id_coll>id_rapportoo then
    SET id_rapportoo=id_coll;
  end if;

  if id_rapportoo IS NULL then
    SET id_rapportoo=1;
  end if;


  INSERT INTO rapporto_mobile (id_rapporto, anno, diritto_chiamata, dir_ric_fatturato, festivo, su_chiamata, eff_giorn,sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, man_straord, tipo_impianto, ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, inviato, visionato) VALUES(id_rapportoo,year(curdate()), "0","0","0","0","0","0","0","0", "0","0","0","0","0","0","0","0","0","0","0","0","1",'1');


     END $$

DELIMITER ;

ALTER TABLE `preventivo_impost` MODIFY COLUMN `valore` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL;
}

-- 2015-03-12
DROP PROCEDURE IF EXISTS sp_usrLogin;
DELIMITER $$
CREATE PROCEDURE sp_usrLogin (IN username VARCHAR(60), IN password VARCHAR(60), OUT success BIT(1))
BEGIN
	SELECT COUNT(utente.id_utente) INTO success 
	FROM utente 
	WHERE utente.Nome = username 
		AND utente.Password = password;
END $$
DELIMITER ;

ALTER TABLE `impianto_abbonamenti`
	DROP FOREIGN KEY `abb`;

ALTER TABLE `impianto_abbonamenti` ADD CONSTRAINT `abb` FOREIGN KEY `abb` (`Id_abbonamenti`)
 REFERENCES `abbonamento` (`Id_abbonamento`)
 ON DELETE CASCADE
 ON UPDATE CASCADE;
	
-- 2015-03-14
CREATE TABLE IF NOT EXISTS `TokenRefresh` (
	`id_token` INTEGER NOT NULL AUTO_INCREMENT,
	`id_utente` INT(11) NOT NULL,
	`deadline` DATETIME NOT NULL,
	PRIMARY KEY (`id_token`),
	CONSTRAINT `FK_TokenRefresh_id_utente` FOREIGN KEY `FK_TokenRefresh_id_utente` (`id_utente`)
	REFERENCES `utente` (`id_utente`) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE = InnoDB;

/*** VIEW FOR MOBILE REPORTS HEADER ***/
CREATE OR REPLACE VIEW vw_mobileRapportoIntestazione AS
SELECT impianto.id_impianto, impianto.tipo_impianto, IF(d1.id_destinazione <> d2.id_destinazione, 
	CONCAT(CONCAT(d2.indirizzo, ' n.', d2.numero_civico, d2.altro), ' - ', CONCAT(IFNULL(CONCAT(NULLIF(f2.nome, ''), ' di '), ''), c2.nome, ' (', c2.provincia, ')'), ' - ', impianto.Descrizione),
	'') AS 'luogo', ragione_sociale, CONCAT(d1.indirizzo, ' n.', d1.numero_civico, d1.altro) AS indirizzo, 
	CONCAT(IFNULL(CONCAT(NULLIF(frazione.nome, ''), ' di '), ''), comune.nome, ' (', comune.provincia, ')') AS citta, 
	mail, clienti.id_cliente, telefono, fax, codice_fiscale, partita_iva, impianto.descrizione, tipo_impianto.nome
FROM impianto
	INNER JOIN clienti ON clienti.id_cliente = impianto.id_cliente
	INNER JOIN destinazione_cliente AS d1 ON d1.id_cliente = clienti.id_cliente 
		AND d1.id_destinazione = 1
	INNER JOIN comune ON comune.id_comune = d1.Comune
	LEFT JOIN frazione ON frazione.id_frazione = d1.frazione
	LEFT JOIN tipo_impianto ON tipo_impianto.id_tipo = impianto.tipo_impianto
	LEFT JOIN destinazione_cliente AS d2 ON d2.id_cliente = clienti.id_cliente 
		AND d2.id_destinazione = impianto.destinazione
	INNER JOIN comune AS c2 ON c2.id_comune = d2.Comune
	LEFT JOIN frazione AS f2 ON f2.id_frazione = d2.frazione
	LEFT JOIN riferimento_clienti AS r1 ON r1.id_cliente = clienti.id_cliente 
		AND id_riferimento = '1'
GROUP BY impianto.id_impianto;
 
-- 2015-03-22
/*** VIEW JOB BODY PRODUCTS ***/
CREATE OR REPLACE VIEW vw_jobBodyProducts AS
SELECT ca.id_commessa AS "Id_commessa", ca.anno AS "Anno", ca.id_lotto AS "Lotto", ca.codice_articolo AS "Codice_articolo", 
	ca.codice_fornitore AS "Codice_fornitore", ca.descrizione AS "Descrizione", CAST(SUM(ROUND(ad.quantità-ad.economia, 2)) AS DECIMAL(11, 2)) AS "Qta_utilizzata", 
	CAST(ca.Quantità AS DECIMAL(11, 2)) AS "Qta_commessa", CAST(ca.Preventivati AS DECIMAL(11, 2)) AS "Qta_preventivati", ca.Um AS "UM", 
	CAST(ca.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ca.costo AS DECIMAL(11, 2)) AS "Costo", CAST(ca.prezzo_ora AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(ca.costo_ora AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ca.sconto AS DECIMAL(11, 2)) AS "Sconto", ca.tempo AS "Tempo_Installazione", 
	CAST("0" AS DECIMAL(11, 2)) AS "Qta_economia", CAST(ca.id_tab AS SIGNED) AS "Posizionamento"
FROM commessa_ddt AS cd
	INNER JOIN ddt AS d ON d.id_ddt = cd.id_ddt 
		AND d.anno = cd.anno_ddt
	INNER JOIN articoli_ddt AS ad ON d.id_Ddt = ad.id_ddt 
		AND d.anno = ad.anno
		AND (ad.tipo <> "E" 
			AND ad.tipo <> "N" 
			OR ad.tipo IS NULL)
	LEFT JOIN commessa_articoli AS ca ON cd.id_commessa = ca.id_commessa 
		AND cd.anno_commessa = ca.anno 
		AND cd.id_lotto = ca.id_lotto 
		AND id_articolo = codice_Articolo
WHERE ca.codice_articolo IS NOT NULL
GROUP BY Id_commessa, anno, lotto, ad.id_articolo, Posizionamento
UNION ALL 
SELECT cd.id_commessa AS "Id_commessa", cd.anno_commessa AS "Anno", cd.id_lotto AS "Lotto", ad.id_articolo AS "Codice_articolo", 
	ad.codice_fornitore AS "Codice_fornitore", ad.desc_breve AS "Descrizione", "" AS "Qta_utilizzata", 
	"" AS "Qta_commessa", "" AS "Qta_preventivati", ad.unità_misura AS "UM", 
	CAST(ad.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ad.costo AS DECIMAL(11, 2)) AS "Costo", CAST(0 AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(0 AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ad.sconto AS DECIMAL(11, 2)) AS "Sconto", tempo_installazione AS "Tempo_Installazione", 
	CAST(SUM(ROUND(ad.Economia, 2)) AS DECIMAL(11, 2)) AS "Qta_economia", CAST("999" AS SIGNED) AS "Posizionamento"
FROM commessa_ddt AS cd
	INNER JOIN ddt AS d ON d.id_ddt = cd.id_ddt 
		AND d.anno = cd.anno_ddt
	INNER JOIN articoli_ddt AS ad ON d.id_Ddt = ad.id_ddt 
		AND d.anno = ad.anno
		AND (ad.tipo <> "N" 
			OR ad.tipo IS NULL)
	LEFT JOIN articolo AS a ON a.codice_articolo = id_articolo
WHERE id_articolo IS NOT NULL
GROUP BY Id_commessa, anno, lotto, ad.id_articolo
UNION ALL 
SELECT ca.id_commessa AS "Id_commessa", ca.anno AS "Anno", ca.id_lotto AS "Lotto", ca.codice_articolo AS "Codice_articolo", 
	ca.codice_fornitore AS "Codice_fornitore", ca.descrizione AS "Descrizione", CAST(0 AS DECIMAL(11, 2)) AS "Qta_utilizzata", 
	CAST(ca.quantità AS DECIMAL(11, 2)) AS "Qta_commessa", CAST(ca.preventivati AS DECIMAL(11, 2)) AS "Qta_preventivati", ca.Um AS "UM", 
	CAST(ca.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ca.costo AS DECIMAL(11, 2)) AS "Costo", CAST(ca.prezzo_ora AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(ca.costo_ora AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ca.sconto AS DECIMAL(11, 2)) AS "Sconto", ca.tempo AS "Tempo_installazione", 
	CAST(0 AS DECIMAL(11, 2)) AS "Qta_conomia", CAST(id_tab AS SIGNED) AS "Posizionamento"
FROM commessa_articoli AS ca
WHERE codice_articolo IS NOT NULL;
	 
/*** VIEW JOB BODY NOTES WITH AMOUNT***/
CREATE OR REPLACE VIEW vw_jobBodyNotesWithAmount AS
SELECT ca.id_commessa AS "Id_commessa", ca.anno AS "Anno", ca.id_lotto AS "Lotto", CAST(ca.id_tab AS SIGNED) AS "Posizionamento", 
	ca.codice_articolo AS "Codice_articolo", ca.codice_fornitore AS "Codice_fornitore", ca.descrizione AS "Descrizione", 
	CAST(ca.quantità AS DECIMAL(11, 2)) AS "Qta_utilizzata", CAST(ca.quantità AS DECIMAL(11, 2)) AS "Qta_Commessa", 
	CAST(ca.preventivati AS DECIMAL(11, 2)) AS "Qta_Preventivati", ca.Um AS "UM", CAST(ca.prezzo AS DECIMAL(11, 2)) AS "Prezzo", 
	CAST(ca.costo AS DECIMAL(11, 2)) AS "Costo", CAST(ca.prezzo_ora AS DECIMAL(11, 2)) AS "Prezzo_ora", CAST(ca.costo_ora AS DECIMAL(11, 2)) AS "Costo_ora", 
	CAST(ca.sconto AS DECIMAL(11, 2)) AS "Sconto", ca.tempo AS "Tempo_installazione", ROUND(0, 2) AS "Qta_economia"
FROM commessa_articoli AS ca
WHERE codice_articolo IS NULL
GROUP BY Id_commessa, anno, lotto, posizionamento;

/*** VIEW FOR COMPLETE JOB BODY ***/
CREATE OR REPLACE VIEW vw_jobBody AS
SELECT Id_commessa, Anno, Lotto, Posizionamento, Codice_articolo, Codice_fornitore, Descrizione, Qta_utilizzata, 
	Qta_commessa, Qta_preventivati, UM, Prezzo, Costo, Prezzo_ora, Costo_ora, Sconto, 
	CAST(Tempo_installazione/60 AS DECIMAL(11, 2)) AS "Tempo_installazione", SUM(Qta_economia) AS Qta_economia
FROM vw_jobBodyProducts AS JobProducts
GROUP BY Id_commessa, anno, lotto, Codice_articolo
UNION 
SELECT Id_commessa, Anno, Lotto, Posizionamento, Codice_articolo, Codice_fornitore, Descrizione, Qta_utilizzata, 
	Qta_commessa, Qta_preventivati, UM, Prezzo, Costo, Prezzo_ora, Costo_ora, Sconto, 
	CAST(Tempo_installazione/60 AS DECIMAL(11, 2)) AS "Tempo_installazione", Qta_economia
FROM vw_jobBodyNotesWithAmount;


/*** VIEW JOB TOTAL WORK ***/


/*** ADD SIGLA_OPERAIO IN TABLE OPERAIO ***/
ALTER TABLE Operaio ADD COLUMN Sigla_Operaio VARCHAR(10) DEFAULT "";


DROP PROCEDURE IF EXISTS sp_tknGetIDToken;
DELIMITER $$
CREATE PROCEDURE sp_tknGetIDToken (
	id_utente INT, 
	deadline DATETIME,
	OUT id_token INT)
BEGIN
	INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);
	SELECT LAST_INSERT_ID() INTO id_token;
END $$
DELIMITER;


DROP PROCEDURE IF EXISTS sp_tknRefreshTokenExists;
DELIMITER $$
CREATE PROCEDURE sp_tknRefreshTokenExists (
	IN id_token INT, 
	OUT FlagFind BOOL
)
BEGIN
	SET @rowno = 0;
	
	SELECT @rowno = @rowno+1, id_token
	FROM TokenRefresh 
	WHERE TokenRefresh.id_token=id_token;
	
	IF @rowno = 0 THEN
		SET FlagFind = FALSE;
	ELSE
		DELETE FROM TokenRefresh WHERE TokenRefresh.id_token=id_token;
		SET FlagFind = TRUE;
	END IF;

END $$
DELIMITER


DROP PROCEDURE IF EXISTS sp_usrGetIDByUsername;
DELIMITER $$
CREATE PROCEDURE sp_usrGetIDByUsername (
	IN username VARCHAR(60), 
	OUT id_utente INT)
BEGIN

	SELECT utente.id_utente INTO id_utente
	FROM utente
	WHERE utente.Nome = username;

END $$
DELIMITER


-- 2015-03-22

CREATE OR REPLACE VIEW vw_jobTotalTravelInterventions AS
SELECT cr.id_commessa, cr.anno_commessa, cr.id_lotto,
	CAST(SUM(spesa_trasferta) AS DECIMAL(11,2)) AS "Totale_spese_trasferta",
	CAST(SUM(Autostrada) AS DECIMAL(11,2)) AS "Totale_autostrada",
	CAST(SUM(parcheggio) AS DECIMAL(11,2)) AS "Totale_parcheggio",
	CAST(SUM(Altro) AS DECIMAL(11,2)) AS "Totale_altro",
	CAST(IF(SUM(KM) IS NULL, 0,SUM(KM) ) AS UNSIGNED) AS "Totale_KM",
	CAST(IF(SUM(KM*costo_km) IS NULL, 0,SUM(km*costo_km) ) AS DECIMAL(11,2)) AS "Totale_costo_KM",
	CAST(IF(SUM(KM*prezzo_strada) IS NULL, 0,SUM(km*prezzo_strada) ) AS DECIMAL(11,2)) AS "Totale_prezzo_KM",
	CAST(SUM(tempo_viaggio/60) AS DECIMAL(11,2)) AS "Totale_tempo_viaggio",
	CAST(IF(SUM((tempo_viaggio/60)*costo_h) IS NULL, 0, SUM((tempo_viaggio/60)*costo_h)) AS DECIMAL(11,2)) AS "Totale_costo_tempo_viaggio",
	CAST(IF(SUM((tempo_viaggio/60)*ora_normale) IS NULL, 0, SUM((tempo_viaggio/60)*Ora_normale)) AS DECIMAL(11,2)) AS "Totale_prezzo_tempo_viaggio"
FROM rapporto_tecnico AS rt
	INNER JOIN commessa_rapporto AS cr ON cr.id_rapporto=rt.id_rapporto 
		AND rt.anno=anno_rapporto
	LEFT JOIN operaio_contratto AS oc ON oc.id_operaio=rt.tecnico
	LEFT JOIN tariffario AS t ON t.id_tariffario=oc.id_tariffario
	INNER JOIN rapporto AS r ON r.id_rapporto=rt.id_rapporto 
		AND r.anno=rt.anno
	LEFT JOIN ABBONAMENTO AS a ON r.abbonamento= a.id_abbonamento
GROUP BY id_commessa, anno_commessa, id_lotto;


CREATE OR REPLACE VIEW vw_jobTotalWorkInterventions AS
SELECT cr.id_commessa, cr.anno_commessa, cr.id_lotto,
	CAST(IFNULL(SUM(totale/60*ora_normale), 0) AS DECIMAL(11,2)) AS "Totale_prezzo_lavoro",
	CAST(IFNULL(SUM(totale/60*costo_h), 0) AS DECIMAL(11,2)) AS "Totale_costo_lavoro",
	CAST(SUM(totale/60) AS DECIMAL(11,2)) AS "Totale_ore_lavorate",
	IF(r.straordinario = 3 OR r.straordinario = 4, 1, 0) AS "Economia",
	IF(r.straordinario = 1 OR r.straordinario = 4, 1, 0) AS "Straordinario"
FROM rapporto_tecnico_lavoro AS r
	INNER JOIN commessa_rapporto AS cr ON cr.id_rapporto = r.id_rapporto 
		AND r.anno = anno_rapporto
	LEFT JOIN operaio_contratto AS oc ON oc.id_operaio = r.tecnico
	LEFT JOIN tariffario AS t ON t.id_tariffario = oc.id_tariffario
GROUP BY id_commessa, anno_commessa, id_lotto, r.straordinario;

-- 2015-03-25

CREATE TABLE IF NOT EXISTS `TokenRefresh` (
	`id_token` INTEGER NOT NULL AUTO_INCREMENT,
	`id_utente` INT(11) NOT NULL,
	`deadline` DATETIME NOT NULL,
	PRIMARY KEY (`id_token`),
	CONSTRAINT `FK_TokenRefresh_id_utente` FOREIGN KEY `FK_TokenRefresh_id_utente` (`id_utente`)
	REFERENCES `utente` (`id_utente`) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE = InnoDB;

ALTER TABLE `tipo_iva`
	ADD COLUMN `in_uso` TINYINT(4) NOT NULL DEFAULT '1' AFTER `esigibilita`;

DELIMITER //
DROP PROCEDURE IF EXISTS sp_getTokenID;
CREATE PROCEDURE sp_getTokenID (id_utente INT, deadline DATETIME,
 OUT id_token INT)
BEGIN

 INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);
 SELECT LAST_INSERT_ID() INTO id_token;
END; //
DELIMITER ;

DROP VIEW IF EXISTS vw_mobileRapportoIntestazione;
CREATE VIEW vw_mobileRapportoIntestazione AS
	SELECT
		impianto.id_impianto,
		impianto.tipo_impianto,
		IF(d1.id_destinazione <> d2.id_destinazione,concat(concat(d2.indirizzo,' n.',d2.numero_civico, d2.altro),' - ',concat(IF(f2.nome IS NOT NULL AND f2.nome <> '', concat(f2.nome,' di '), ''), c2.nome,' (',c2.provincia,')'),' - ',impianto.Descrizione),'') AS 'luogo',
		ragione_sociale,
		concat(d1.indirizzo,' n.', d1.numero_civico, d1.altro) AS indirizzo,
		concat(IF(frazione.nome IS NOT NULL AND frazione.nome <> '', concat(frazione.nome,' di '), ''), comune.nome,' (',comune.provincia,')') AS citta,
		mail,
		clienti.id_cliente,
		telefono,
		fax,
		codice_fiscale,
		partita_iva,
		impianto.descrizione,
		tipo_impianto.nome
	FROM impianto
		INNER JOIN clienti ON clienti.id_cliente=impianto.id_cliente
		INNER JOIN destinazione_cliente AS d1 ON d1.id_cliente=clienti.id_cliente AND d1.id_destinazione=1
		INNER JOIN comune ON comune.id_comune=d1.Comune
		LEFT JOIN frazione ON frazione.id_frazione=d1.frazione
		LEFT JOIN tipo_impianto ON tipo_impianto.id_tipo=impianto.tipo_impianto
		LEFT JOIN destinazione_cliente AS d2 ON d2.id_cliente=clienti.id_cliente AND d2.id_destinazione=impianto.destinazione
		INNER JOIN comune AS c2 ON c2.id_comune=d2.Comune
		LEFT JOIN frazione AS f2 ON f2.id_frazione=d2.frazione
		LEFT JOIN riferimento_clienti AS r1 ON r1.id_cliente=clienti.id_cliente AND id_riferimento='1'

	GROUP BY impianto.id_impianto ;

-- QUERY FOR JOB'S BODY WITH SCALE REPORTS WITHOUT ECONOMY PRODUCTS
CREATE OR REPLACE VIEW subvw_JobBodyProductsWithReportsWithoutEconomy AS
SELECT ca.id_commessa AS "Id_commessa", ca.anno AS "Anno", ca.id_lotto AS "Lotto", ca.codice_articolo AS "Codice_articolo", 
	ca.codice_fornitore AS "Codice_fornitore", ca.descrizione AS "Descrizione", CAST(SUM(ROUND(ad.quantità-ad.economia, 2)) AS DECIMAL(11, 2)) AS "Qta_utilizzata", 
	CAST(ca.Quantità AS DECIMAL(11, 2)) AS "Qta_commessa", CAST(ca.Preventivati AS DECIMAL(11, 2)) AS "Qta_preventivati", ca.Um AS "UM", 
	CAST(ca.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ca.costo AS DECIMAL(11, 2)) AS "Costo", CAST(ca.prezzo_ora AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(ca.costo_ora AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ca.sconto AS DECIMAL(11, 2)) AS "Sconto", ca.tempo AS "Tempo_Installazione", 
	CAST("0" AS DECIMAL(11, 2)) AS "Qta_economia", CAST(ca.id_tab AS SIGNED) AS "Posizionamento"
FROM commessa_ddt AS cd
	INNER JOIN ddt AS d ON d.id_ddt = cd.id_ddt 
		AND d.anno = cd.anno_ddt
	INNER JOIN articoli_ddt AS ad ON d.id_Ddt = ad.id_ddt 
		AND d.anno = ad.anno
		AND (ad.tipo <> "E" 
			AND ad.tipo <> "N" 
			OR ad.tipo IS NULL)
	LEFT JOIN commessa_articoli AS ca ON cd.id_commessa = ca.id_commessa 
		AND cd.anno_commessa = ca.anno 
		AND cd.id_lotto = ca.id_lotto 
		AND id_articolo = codice_Articolo
WHERE ca.codice_articolo IS NOT NULL
GROUP BY Id_commessa, anno, lotto, ad.id_articolo, Posizionamento
UNION ALL
SELECT ca.id_commessa AS "Id_commessa", ca.anno AS "Anno", ca.id_lotto AS "Lotto", ca.codice_articolo AS "Codice_articolo", 
	ca.codice_fornitore AS "Codice_fornitore", ca.descrizione AS "Descrizione", CAST(SUM(ROUND(rm.quantità-rm.economia, 2)) AS DECIMAL(11, 2)) AS "Qta_utilizzata", 
	CAST(ca.Quantità AS DECIMAL(11, 2)) AS "Qta_commessa", CAST(ca.Preventivati AS DECIMAL(11, 2)) AS "Qta_preventivati", ca.Um AS "UM", 
	CAST(ca.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ca.costo AS DECIMAL(11, 2)) AS "Costo", CAST(ca.prezzo_ora AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(ca.costo_ora AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ca.sconto AS DECIMAL(11, 2)) AS "Sconto", ca.tempo AS "Tempo_Installazione", 
	CAST("0" AS DECIMAL(11, 2)) AS "Qta_economia", CAST(ca.id_tab AS SIGNED) AS "Posizionamento"
FROM commessa_rapporto AS cr
	INNER JOIN rapporto AS r ON r.id_rapporto = cr.id_rapporto 
		AND r.anno = cr.anno_rapporto
	INNER JOIN rapporto_materiale AS rm ON rm.id_rapporto = cr.id_rapporto
		AND rm.anno = cr.anno_rapporto
		AND (rm.economia <> "1" 
			AND rm .tipo <> "N" )
	LEFT JOIN commessa_articoli AS ca ON cr.id_commessa = ca.id_commessa
		AND cr.anno_commessa = ca.anno
		AND cr.id_lotto = ca.id_lotto
		AND id_materiale = codice_Articolo
	LEFT JOIN ddt_rapporto AS dr ON dr.id_rapporto = r.id_rapporto
		AND dr.anno_rapporto = r.anno
WHERE codice_articolo IS NOT NULL 
	AND dr.id_ddt IS NULL
GROUP BY Id_commessa, anno, Lotto, Posizionamento;

-- QUERY FOR JOB'S BODY WITH QUERY REPORTS ONLY ECONOMY PRODUCTS
CREATE OR REPLACE VIEW subvw_JobBodyProductsWithReportsOnlyEconomy AS
	SELECT cd.id_commessa AS "Id_commessa", cd.anno_commessa AS "Anno", cd.id_lotto AS "Lotto", ad.id_articolo AS "Codice_articolo", 
	ad.codice_fornitore AS "Codice_fornitore", ad.desc_breve AS "Descrizione", "" AS "Qta_utilizzata", 
	"" AS "Qta_commessa", "" AS "Qta_preventivati", ad.unità_misura AS "UM", 
	CAST(ad.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(ad.costo AS DECIMAL(11, 2)) AS "Costo", CAST(0 AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(0 AS DECIMAL(11, 2)) AS "Costo_ora", CAST(ad.sconto AS DECIMAL(11, 2)) AS "Sconto", tempo_installazione AS "Tempo_Installazione", 
	CAST(SUM(ROUND(ad.Economia, 2)) AS DECIMAL(11, 2)) AS "Qta_economia", CAST("999" AS SIGNED) AS "Posizionamento"
FROM commessa_ddt AS cd
	INNER JOIN ddt AS d ON d.id_ddt = cd.id_ddt 
		AND d.anno = cd.anno_ddt
	INNER JOIN articoli_ddt AS ad ON d.id_Ddt = ad.id_ddt 
		AND d.anno = ad.anno
		AND (ad.tipo <> "N" 
			OR ad.tipo IS NULL)
	LEFT JOIN articolo AS a ON a.codice_articolo = id_articolo
WHERE id_articolo IS NOT NULL
GROUP BY Id_commessa, anno, lotto, ad.id_articolo
UNION ALL
SELECT cr.id_commessa AS "Id_commessa", cr.anno_commessa AS "Anno", cr.id_lotto AS "Lotto", rm.id_materiale AS "Codice_articolo", 
	a.codice_fornitore AS "Codice_fornitore", rm.descrizione AS "Descrizione", "" AS "Qta_utilizzata", 
	"" AS "Qta_commessa", "" AS "Qta_preventivati", a.unità_misura AS "UM", 
	CAST(rm.prezzo AS DECIMAL(11, 2)) AS "Prezzo", CAST(rm.costo AS DECIMAL(11, 2)) AS "Costo", CAST(0 AS DECIMAL(11, 2)) AS "Prezzo_ora", 
	CAST(0 AS DECIMAL(11, 2)) AS "Costo_ora", CAST(rm.sconto AS DECIMAL(11, 2)) AS "Sconto", tempo_installazione AS "Tempo_Installazione", 
	CAST(SUM(ROUND(rm.qeconomia, 2)) AS DECIMAL(11, 2)) AS "Qta_economia", CAST("999" AS SIGNED) AS "Posizionamento"
FROM commessa_rapporto AS cr
	INNER JOIN rapporto AS r ON r.id_rapporto = cr.id_rapporto 
		AND r.anno = cr.anno_rapporto
	INNER JOIN rapporto_materiale AS rm ON rm.id_rapporto = cr.id_rapporto 
		AND rm.anno = cr.anno_rapporto 
		AND ( rm.tipo <> "N")
	LEFT JOIN ddt_rapporto AS dr ON dr.id_rapporto = r.id_rapporto 
		AND dr.anno_rapporto = r.anno
	INNER JOIN articolo AS a ON a.codice_articolo = id_materiale
WHERE id_materiale IS NOT NULL 
	AND dr.id_ddt IS NULL 
	AND rm.economia = 1
GROUP BY Id_commessa, anno, lotto, id_materiale;

-- QUERY FOR JOBS BODY PRODUCTS WITH REPORTS

CREATE OR REPLACE VIEW vw_jobbodyproductswithreports AS
SELECT Id_commessa, Anno, Lotto, Posizionamento, Codice_articolo, Codice_fornitore, Descrizione, Qta_utilizzata, Qta_commessa, Qta_preventivati, UM, Prezzo, Costo, Prezzo_ora, Costo_ora, 
	Sconto, CAST(Tempo_installazione / 60 AS DECIMAL(11, 2)) AS "Tempo_installazione", Qta_economia
FROM subvw_jobbodyproductswithreportswithouteconomy
UNION ALL
SELECT Id_commessa, Anno, Lotto, Posizionamento, Codice_articolo, Codice_fornitore, Descrizione, Qta_utilizzata, Qta_commessa, Qta_preventivati, UM, Prezzo, Costo, Prezzo_ora, Costo_ora, 
	Sconto, CAST(Tempo_installazione / 60 AS DECIMAL(11, 2)) AS "Tempo_installazione", Qta_economia
FROM subvw_jobbodyproductswithreportsonlyeconomy 
UNION ALL
SELECT ca.id_commessa, ca.anno, ca.id_lotto, CAST(ca.id_tab AS signed), ca.codice_articolo, ca.codice_fornitore, ca.descrizione, CAST(0 AS DECIMAL(11,  2)), 
	CAST(ca.quantità AS DECIMAL(11,  2)), CAST(ca.preventivati AS DECIMAL(11,  2)), ca.UM, CAST(ca.prezzo AS DECIMAL(11,  2)), CAST(ca.costo AS DECIMAL(11,  2)), 
	CAST(ca.prezzo_ora AS DECIMAL(11,  2)), CAST(ca.costo_ora AS DECIMAL(11,  2)), CAST(ca.sconto AS DECIMAL(11,  2)), ca.tempo/60, CAST(0 AS DECIMAL(11,  2))
FROM commessa_articoli ca
WHERE ca.codice_articolo IS NOT NULL;
			
CREATE OR REPLACE VIEW vw_jobbodywithreports AS
SELECT `vw_jobbodyproductswithreports`.`Id_commessa` AS `Id_commessa`
		,`vw_jobbodyproductswithreports`.`Anno` AS `Anno`
		,`vw_jobbodyproductswithreports`.`Lotto` AS `Lotto`
		,`vw_jobbodyproductswithreports`.`Posizionamento` AS `Posizionamento`
		,`vw_jobbodyproductswithreports`.`Codice_articolo` AS `Codice_articolo`
		,`vw_jobbodyproductswithreports`.`Codice_fornitore` AS `Codice_fornitore`
		,`vw_jobbodyproductswithreports`.`Descrizione` AS `Descrizione`
		,CAST(SUM(`vw_jobbodyproductswithreports`.`Qta_utilizzata`)AS DECIMAL(11, 2)) AS `Qta_utilizzata`
		,`vw_jobbodyproductswithreports`.`Qta_commessa` AS `Qta_commessa`
		,`vw_jobbodyproductswithreports`.`Qta_preventivati` AS `Qta_preventivati`
		,`vw_jobbodyproductswithreports`.`UM` AS `UM`
		,`vw_jobbodyproductswithreports`.`Prezzo` AS `Prezzo`
		,`vw_jobbodyproductswithreports`.`Costo` AS `Costo`
		,`vw_jobbodyproductswithreports`.`Prezzo_ora` AS `Prezzo_ora`
		,`vw_jobbodyproductswithreports`.`Costo_ora` AS `Costo_ora`
		,`vw_jobbodyproductswithreports`.`Sconto` AS `Sconto`
		,`vw_jobbodyproductswithreports`.`Tempo_installazione` AS `Tempo_installazione`
		,CAST(SUM(`vw_jobbodyproductswithreports`.`Qta_economia`) AS DECIMAL(11, 2)) AS `Qta_economia`
	FROM `vw_jobbodyproductswithreports`
	GROUP BY `vw_jobbodyproductswithreports`.`Id_commessa`
		,`vw_jobbodyproductswithreports`.`Anno`
		,`vw_jobbodyproductswithreports`.`Lotto`
		,`vw_jobbodyproductswithreports`.`Codice_articolo`
	UNION ALL 
	SELECT `ca`.`id_commessa` AS `Id_commessa`
		,`ca`.`anno` AS `Anno`
		,`ca`.`id_lotto` AS `Lotto`
		,CAST(`ca`.`id_tab` AS signed) AS `Posizionamento`
		,`ca`.`codice_articolo` AS `Codice_articolo`
		,`ca`.`codice_fornitore` AS `Codice_fornitore`
		,`ca`.`descrizione` AS `Descrizione`
		,CAST(`ca`.`quantità` AS DECIMAL(11, 2)) AS `Qta_utilizzata`
		,CAST(`ca`.`quantità` AS DECIMAL(11, 2)) AS `Qta_commessa`
		,CAST(`ca`.`preventivati` AS DECIMAL(11, 2)) AS `Qta_preventivati`
		,`ca`.`UM` AS `UM`
		,CAST(`ca`.`prezzo` AS DECIMAL(11, 2)) AS `Prezzo`
		,CAST(`ca`.`costo` AS DECIMAL(11, 2)) AS `Costo`
		,CAST(`ca`.`prezzo_ora` AS DECIMAL(11, 2)) AS `Prezzo_ora`
		,CAST(`ca`.`costo_ora` AS DECIMAL(11, 2)) AS `Costo_ora`
		,CAST(`ca`.`sconto` AS DECIMAL(11, 2)) AS `Sconto`
		,`ca`.`tempo`/60 AS `Tempo_installazione`
		,CAST(0 AS DECIMAL(11, 2)) AS `Qta_conomia`
	FROM `commessa_articoli` `ca`
	WHERE (`ca`.`codice_articolo` IS NULL) ;

DROP PROCEDURE IF EXISTS sp_getjobtotals;
DELIMITER //
CREATE PROCEDURE sp_getJobTotals (
	id_job INT, 
	year_job INT, 
	id_lot INT, 
	scale_from_reports INT,
	OUT total_price_quote DECIMAL(11,2), 
	OUT total_cost DECIMAL(11,2), 
	OUT total_hours_worked_economy DECIMAL(11,2), 
	OUT total_hours_worked DECIMAL(11,2), 
	OUT Total_hours DECIMAL(11,2), 
	OUT total_hours_travel DECIMAL(11,2),
	OUT total_price_quote_body_products DECIMAL(11,2), 
	OUT total_cost_body_products_economy DECIMAL(11,2), 
	OUT total_cost_worked_economy DECIMAL(11,2),
	OUT total_cost_body_products DECIMAL(11,2), 
	OUT total_cost_worked DECIMAL(11,2), 
	OUT total_km DECIMAL(11,2),
	OUT total_cost_hours_travel DECIMAL(11,2), 
	OUT total_cost_km DECIMAL(11,2), 
	OUT total_cost_transfert DECIMAL(11,2),
	OUT total_cost_extra DECIMAL(11,2), 
	OUT total_cost_parking DECIMAL(11.2), 
	OUT total_cost_speedway DECIMAL(11,2),
	OUT total_price_body_products DECIMAL(11,2), 
	OUT total_price_worked DECIMAL(11,2), 
	OUT total_price_hours_travel DECIMAL(11,2), 
	OUT total_price_km DECIMAL(11,2), 
	OUT total_price_transfert DECIMAL(11,2),
	OUT total_price_extra DECIMAL(11,2), 
	OUT total_price_parking DECIMAL(11.2), 
	OUT total_price_speedway DECIMAL(11,2),
	OUT total_price_body_products_economy DECIMAL(11,2), 
	OUT total_price_worked_economy DECIMAL(11,2), 	
	OUT total_price DECIMAL(11,2),
	OUT total_price_quote_worked DECIMAL(11,2)
)
BEGIN
	IF scale_from_reports = 1 THEN
		SELECT 
			CAST(SUM(jb.Tempo_installazione*jb.Qta_preventivati) AS DECIMAL(11,2)),
			SUM(CAST((jb.Prezzo * jb.Qta_preventivati + jb.Qta_preventivati* jb.Tempo_installazione * jb.Prezzo_ora ) * (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.Prezzo * jb.Qta_preventivati) * (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.costo * jb.Qta_economia) AS DECIMAL(11,2))),
			SUM(CAST((jb.costo * jb.Qta_utilizzata) AS DECIMAL(11,2))),
			SUM(CAST((jb.prezzo * jb.Qta_economia)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.prezzo * jb.Qta_utilizzata)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2)))
		INTO 
			total_hours,
			total_price_quote,
			total_price_quote_body_products,
			total_cost_body_products_economy,
			total_cost_body_products,
			total_price_body_products_economy,
			total_price_body_products
		FROM vw_jobbodywithreports jb
		WHERE jb.id_commessa = id_job
			AND jb.anno = year_job
			AND IF(id_lot > 0, jb.lotto = id_lot, TRUE);
	ELSE
		SELECT 
			CAST(SUM(jb.Tempo_installazione*jb.Qta_preventivati) AS DECIMAL(11,2)),
			SUM(CAST((jb.Prezzo * jb.Qta_preventivati + jb.Qta_preventivati* jb.Tempo_installazione * jb.Prezzo_ora ) * (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.Prezzo * jb.Qta_preventivati)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.costo * jb.Qta_economia) AS DECIMAL(11,2))),
			SUM(CAST((jb.costo * jb.Qta_utilizzata) AS DECIMAL(11,2))),
			SUM(CAST((jb.prezzo * jb.Qta_economia)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2))),
			SUM(CAST((jb.prezzo * jb.Qta_utilizzata)* (100 - jb.Sconto) / 100 AS DECIMAL(11,2)))
		INTO 
			total_hours,
			total_price_quote,
			total_price_quote_body_products,
			total_cost_body_products_economy,
			total_cost_body_products,
			total_price_body_products_economy,
			total_price_body_products
			
		FROM vw_jobbody jb
		WHERE jb.id_commessa = id_job
			AND jb.anno = year_job
			AND IF(id_lot > 0, jb.lotto = id_lot, TRUE);
	END IF;

	SELECT 
		CAST(IF(SUM(twi.totale_ore_lavorate) IS NULL, 0, SUM(twi.totale_ore_lavorate))AS DECIMAL(11,2)),
		CAST(IF(SUM(twi.totale_costo_lavoro) IS NULL, 0, SUM(twi.totale_costo_lavoro))AS DECIMAL(11,2)),
	 CAST(IF(SUM(twi.totale_prezzo_lavoro) IS NULL, 0, SUM(twi.totale_prezzo_lavoro))AS DECIMAL(11,2))
	INTO
		total_hours_worked,
		Total_cost_worked,
		Total_price_worked
	FROM vw_jobtotalworkinterventions twi 
	WHERE twi.Economia = 0 
		AND twi.id_commessa = id_job
		AND twi.anno_commessa = year_job
		AND IF(id_lot > 0, twi.id_lotto = id_lot, TRUE);
		
	SELECT 
		CAST(IF(SUM(twi.totale_ore_lavorate) IS NULL, 0,SUM(twi.totale_ore_lavorate)) AS DECIMAL(11,2)),
		CAST(IF(SUM(twi.totale_costo_lavoro) IS NULL, 0,SUM(twi.totale_costo_lavoro)) AS DECIMAL(11,2)), 
		CAST(IF(SUM(twi.totale_prezzo_lavoro) IS NULL,0, SUM(twi.totale_prezzo_lavoro)) AS DECIMAL(11,2)) 
	INTO 
		total_hours_worked_economy,
		total_cost_worked_economy,
		total_price_worked_economy
	FROM vw_jobtotalworkinterventions twi 
	WHERE twi.Economia = 1
		AND twi.id_commessa = id_job
		AND twi.anno_commessa = year_job
		AND IF(id_lot > 0, twi.id_lotto = id_lot, TRUE);
	
	SELECT 
		CAST(IF(SUM(tti.Totale_tempo_viaggio) IS NULL, 0, SUM(tti.Totale_tempo_viaggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_KM) IS NULL, 0,SUM(tti.Totale_KM)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_costo_KM) IS NULL, 0,SUM(tti.Totale_costo_KM)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_costo_tempo_viaggio) IS NULL, 0, SUM(tti.Totale_costo_tempo_viaggio))AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_spese_trasferta) IS NULL, 0, SUM(tti.Totale_spese_trasferta)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_autostrada) IS NULL, 0,SUM(tti.Totale_autostrada)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_parcheggio) IS NULL, 0, SUM(tti.Totale_parcheggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_altro) IS NULL, 0,SUM(tti.Totale_altro)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_prezzo_tempo_viaggio) IS NULL, 0,SUM(tti.Totale_prezzo_tempo_viaggio)) AS DECIMAL(11,2)),
		CAST(IF(SUM(tti.Totale_prezzo_KM) IS NULL, 0, SUM(tti.Totale_prezzo_KM)) AS DECIMAL(11,2))
	INTO 
		total_hours_travel,
		total_km,
		total_cost_km,
		total_cost_hours_travel,
		total_cost_transfert,
		total_cost_speedway,
		total_cost_parking,
		total_cost_extra,
		total_price_km,
		total_price_hours_travel
	FROM vw_jobtotaltravelinterventions tti
	WHERE tti.id_commessa = id_job
		AND tti.anno_commessa = year_job
		AND IF(id_lot > 0, tti.id_lotto = id_lot, TRUE);
		
	SET total_price_parking = total_cost_parking;
	SET total_price_extra = total_cost_extra;	
	SET total_price_speedway = total_cost_speedway;
	SET total_price_transfert = total_cost_transfert;
		
	SET total_cost = IF(total_cost_body_products_economy IS NULL, 0, total_cost_body_products_economy)
				+ IF(total_cost_worked_economy IS NULL, 0, total_cost_worked_economy)
				+ IF(total_cost_body_products IS NULL, 0, total_cost_body_products)
				+ IF(total_cost_worked IS NULL, 0, total_cost_worked)
				+ IF(total_cost_hours_travel IS NULL, 0, total_cost_hours_travel)
				+ IF(total_cost_km IS NULL, 0, total_cost_km)
				+ IF(total_cost_transfert IS NULL, 0, total_cost_transfert)
				+ IF(total_cost_extra IS NULL, 0, total_cost_extra)
				+ IF(total_cost_parking IS NULL, 0, total_cost_parking)
				+ IF(total_cost_speedway IS NULL, 0,total_cost_speedway) ;
				
	SET total_price = IF(total_price_body_products_economy IS NULL, 0, total_price_body_products_economy)
				+ IF(total_price_worked_economy IS NULL, 0, total_price_worked_economy)
				+ IF(total_price_body_products IS NULL, 0, total_price_body_products)
				+ IF(total_price_worked IS NULL, 0, total_price_worked)
				+ IF(total_price_hours_travel IS NULL, 0, total_price_hours_travel)
				+ IF(total_price_km IS NULL, 0, total_price_km)
				+ IF(total_cost_transfert IS NULL, 0, total_cost_transfert)
				+ IF(total_cost_extra IS NULL, 0, total_cost_extra)
				+ IF(total_cost_parking IS NULL, 0, total_cost_parking)
				+ IF(total_cost_speedway IS NULL, 0, total_cost_speedway) ;
				
	SET total_price_quote_worked = total_price_quote-total_price_quote_body_products;
	
END //
DELIMITER ;


ALTER TABLE `lotto`
	CHANGE COLUMN `Descrizione` `Descrizione` LONGTEXT NOT NULL DEFAULT '' AFTER `Nome`,
	ADD INDEX `Nome` (`Nome`);

ALTER TABLE `articolo_preventivo`
	CHANGE COLUMN `Listino` `Listino` INT(11) NULL DEFAULT NULL AFTER `codice_fornitore`;

ALTER TABLE `tipo_iva`
	ADD COLUMN `in_uso` BIT(1) NOT NULL DEFAULT b'1' AFTER `esigibilita`;

ALTER TABLE `articoli_ddt`
	CHANGE COLUMN `idnota` `idnota` INT(11) NULL DEFAULT NULL AFTER `tipo`;


CREATE OR REPLACE VIEW vw_mapsMarkersInformation AS
SELECT 	
	Impianto.Id_Impianto, 
	Ticket.Id_Cliente, 
	Ragione_Sociale, 
	concat(indirizzo,",",numero_civico)as "Indirizzo",
	concat(comune.cap," - ",comune.nome,"(",destinazione_cliente.provincia,")") AS "Provincia", 
	IMPIANTO.descrizione AS "Impianto_Descrizione",
	IF(IMpianto.stato=1, 1, 0) AS "Abbonato",
	IF(stato_invio_doc='clblue', 0, IF(stato_invio_doc='clYellow',1,2)) AS 'Stato_invio_richiesta_abbonamento',
	max(Data_Ticket) AS Data_Ticket,
	max(urgenza) AS "Urgenza",
	Ticket.Descrizione AS "Ticket_Descrizione",
	Telefono, 
	Altro_telefono AS "Cellulare", 
	Mail,
	CONVERT(REPLACE(Latitudine, ',','.'),DECIMAL(21,16)) AS Latitudine, 
	CONVERT(REPLACE(Longitudine, ',','.'), DECIMAL(21,16)) AS Longitudine
	 
FROM ticket 
INNER JOIN clienti ON clienti.id_cliente=ticket.id_cliente 
	LEFT JOIN causale_ticket ON id_causale=causale 
	LEFT JOIN tipo_intervento ON id_tipo=intervento 
	INNER JOIN riferimento_clienti ON clienti.id_cliente=riferimento_clienti.id_cliente 
	LEFT JOIN impianto ON impianto.id_impianto=ticket.id_impianto 
	INNER JOIN destinazione_cliente ON clienti.id_cliente=destinazione_cliente.id_cliente AND impianto.destinazione=destinazione_cliente.id_destinazione 
	INNER JOIN comune ON comune.id_comune=destinazione_cliente.comune 
WHERE stato_ticket=1 AND latitudine <> "" AND longitudine <> "" AND latitudine IS NOT NULL AND longitudine IS NOT NULL
GROUP BY Id_impianto
ORDER BY Id_impianto;

DROP PROCEDURE IF EXISTS sp_mobileGetAriesCallInformations;
DELIMITER //
CREATE PROCEDURE sp_mobileGetAriesCallInformations ()
BEGIN

	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscribers;
	CREATE TEMPORARY TABLE TempCustomerSubscribers 
		SELECT C.ID_Cliente AS IDCostumer,
			C.Ragione_sociale AS CompanyName, 
			IF(IA.Id_impianto IS NOT NULL, true, false) AS IsSubscriber
		FROM CLIENTI AS C
			INNER JOIN IMPIANTO AS I ON I.ID_Cliente = C.ID_Cliente
			LEFT JOIN impianto_abbonamenti AS IA ON IA.ANNO = YEAR(CURDATE()) 
				AND I.id_Impianto = IA.ID_impianto
		GROUP BY C.ID_Cliente;
	
	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscriberUnsolved;
	CREATE TEMPORARY TABLE TempCustomerSubscriberUnsolved 
		SELECT C.ID_cliente AS IDCostumer, 
			c.ragione_sociale AS CompanyName,
			IF(vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL, TRUE, FALSE) AS IsUnsolved,
			IF(IsSubscriber = True, TRUE, FALSE) AS IsSubscriber
		FROM CLIENTI AS C
			LEFT JOIN vw_mobileinvoicesoutstanding ON vw_mobileinvoicesoutstanding.id_cliente=c.id_cliente
			LEFT JOIN TempCustomerSubscribers ON TempCustomerSubscribers.IDCostumer=c.id_cliente
		WHERE vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL 
			OR TempCustomerSubscribers.IDCostumer IS NOT NULL;
	
	SELECT CompanyName,
		riferimento_clienti.Nome AS ReferenceType,
		IsUnsolved,
		IsSubscriber,
		Telefono AS Phone, 
		Altro_Telefono AS MobilePhone 
	FROM TempCustomerSubscriberUnsolved 
		INNER JOIN Riferimento_Clienti ON IDCostumer=ID_Cliente
	WHERE ((Telefono IS NOT NULL AND telefono <> '') 
		OR (altro_telefono IS NOT NULL AND altro_telefono <> ''));


END; //
DELIMITER ;


-- 2015-04-23 ~ Nicola Paro

ALTER TABLE `clienti`
	ADD COLUMN `data_ultima_modifica` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE `fattura`
	ADD COLUMN `data_ultima_modifica` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE destinazione_cliente
	ADD COLUMN `data_ultima_modifica` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE impianto_abbonamenti
	ADD COLUMN `data_ultima_modifica` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


-- 2015-04-26 ~ Alex Gola

CREATE OR REPLACE VIEW subvw_ProductsUnionSearch AS
SELECT codice_articolo AS "id_articolo", codice_fornitore, barcode, "" AS codice, desc_brev, unità_misura, codice_articolo, 
	ars.colore AS "colore", codice_articolo AS "ID", codice_fornitore AS "Cod. Fornitore",desc_brev AS "Descrizione",
	unità_misura AS "U.M.", ars.colore "stato_articolo", m.nome AS "marca", tempo_installazione, is_kit
FROM articolo ar
	LEFT JOIN marca m ON m.id_marca = ar.marca
	INNER JOIN articolo_stato ars ON id_stato = ar.stato_articolo 
UNION ALL
SELECT id_articolo, codice AS "codice_fornitore", barcode, codice, desc_brev, unità_misura, codice_articolo, 
	ars.colore AS "colore", codice_articolo AS "ID", codice_fornitore AS "Cod. Fornitore",desc_brev AS "Descrizione",
	unità_misura AS "U.M.",ars.colore "stato_articolo", m.nome AS "marca", tempo_installazione, is_kit
FROM articolo ar
	INNER JOIN articolo_codice arc ON ar.codice_articolo = arc.id_articolo
	LEFT JOIN marca m ON m.id_marca = ar.marca
	INNER JOIN articolo_stato ars ON id_stato = ar.stato_articolo;

CREATE OR REPLACE VIEW vw_ProductsSearch AS
SELECT codice_articolo AS "Codice_articolo", 
	IFNULL(codice_fornitore, "") AS "Codice_fornitore",
	IFNULL(barcode, "") AS "Barcode",
	desc_brev AS "Descrizione", unità_misura AS "UM", colore "Stato_articolo", 
	IFNULL(marca, "") AS "Marca", 
	IFNULL(c.Prezzo, 0) AS "Costo", 
	IFNULL(p.Prezzo, 0) AS "Prezzo",
	Tempo_installazione, Is_kit
FROM subvw_ProductsUnionSearch pus
	LEFT JOIN articolo_listino p ON p.id_articolo = codice_Articolo 
		AND id_listino = 2 
	LEFT JOIN articolo_listino c ON c.id_listino = 1 
		AND c.id_articolo = codice_articolo
GROUP BY Codice_articolo, pus.Codice_fornitore;


-- 2015-04-27 ~ Nicola Paro

DROP PROCEDURE IF EXISTS sp_getQuoteTotals;
DELIMITER //
CREATE PROCEDURE sp_getQuoteTotals(
	IN quote_id INT, 
	IN quote_year INT, 
	IN quote_revision_id INT, 
	OUT total_price_material DECIMAL(11,2), 
	OUT total_cost_material DECIMAL(11,2), 
	OUT total_profit_material DECIMAL(11, 2),
	OUT total_price_work DECIMAL(11, 2),
	OUT total_cost_work DECIMAL(11, 2),
	OUT total_profit_work DECIMAL(11, 2),
	OUT total_hours DECIMAL(11, 2),
	OUT total_price DECIMAL(11, 2),
	OUT total_cost DECIMAL(11, 2),
	OUT total_profit DECIMAL(11, 2),
	OUT total_sale DECIMAL(11, 2)
)
BEGIN

	SELECT SUM(CAST(ROUND(prezzo * (100 - IF(preventivo_lotto.tipo_ricar = 1, 0, sconto)) / 100, 2) * (100 - IFNULL(NULLIF(scontoriga, ""), 0)) / 100 AS DECIMAL(11, 2)) * quantità)
		INTO total_price_material
	FROM articolo_preventivo 
		LEFT JOIN preventivo_lotto ON preventivo_lotto.id_preventivo = articolo_preventivo.id_preventivo 
			AND preventivo_lotto.anno = articolo_preventivo.anno 
			AND preventivo_lotto.id_revisione = articolo_preventivo.id_revisione 
			AND articolo_preventivo.lotto = preventivo_lotto.posizione 
	WHERE articolo_preventivo.id_preventivo = quote_id
		AND articolo_preventivo.anno = quote_year
		AND articolo_preventivo.id_revisione = quote_revision_id;

	SELECT SUM(costo * quantità)
		INTO total_cost_material
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(CAST((IF(montato = "0", 0, ap.tempo_installazione / 60 * prezzo_h * (100 - scontolav) / 100) * ((100 - IFNULL(scontoriga, 0)) / 100)) AS DECIMAL(11, 2)) * quantità)
		INTO total_price_work
	FROM articolo_preventivo ap
		LEFT JOIN preventivo_lotto pl ON pl.id_preventivo = ap.id_preventivo
			AND pl.anno = ap.anno 
			AND pl.id_revisione = ap.id_revisione 
			AND ap.lotto = pl.posizione 
	WHERE ap.id_preventivo = quote_id
		AND ap.anno = quote_year
		AND ap.id_revisione = quote_revision_id;

	SELECT SUM(IF(montato = "0", 0, quantità * (tempo_installazione / 60 * costo_h)))
		INTO total_cost_work
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(IF(montato = "0", 0, quantità) * tempo_installazione / 60)
		INTO total_hours
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;

	SELECT SUM(((ROUND(ROUND((prezzo-(sconto/100*prezzo)),2)*scontoriga/100,2)*quantità)+((IF(montato="0",0,quantità*((tempo_installazione/60*prezzo_h) - ((tempo_installazione/60*prezzo_h)*scontolav/100)))))*scontoriga/100))
		INTO total_sale
	FROM articolo_preventivo 
	WHERE id_preventivo = quote_id
		AND anno = quote_year
		AND id_revisione = quote_revision_id;
	
	SET total_price_material = IFNULL(total_price_material, 0);
	SET total_cost_material = IFNULL(total_cost_material, 0);
	SET total_price_work = IFNULL(total_price_work, 0);
	SET total_cost_work = IFNULL(total_cost_work, 0);
	SET total_sale = IFNULL(total_sale, 0);
	SET total_cost = IFNULL(total_cost_material, 0) + IFNULL(total_cost_work, 0);
	SET total_price = IFNULL(total_price_material, 0) + IFNULL(total_price_work, 0);
	SET total_profit_material = IFNULL(total_price_material, 0) - IFNULL(total_cost_material, 0);
	SET total_profit_work = IFNULL(total_price_work, 0) - IFNULL(total_cost_work, 0);
	SET total_profit = total_profit_material + total_profit_work;

END //
DELIMITER ; 

-- 2015-04-2015 ~ Nicola Paro

ALTER TABLE `tablet`
	ADD INDEX `mec_address` (`mec_address`);

CREATE TABLE `tablet_posizioni` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`id_tablet` INT(11) NOT NULL DEFAULT '0',
	`posizione` POINT NOT NULL,
	`data_rilevazione` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	INDEX `id_tablet` (`id_tablet`)
) ENGINE = InnoDB;

-------------------------------------------- EMMEBI 