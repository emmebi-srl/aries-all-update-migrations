DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `modlist` BEFORE UPDATE ON `articolo_listino` FOR EACH ROW begin

if new.prezzo<>old.prezzo then

insert into articolo_listino_prezzo (id_Articolo,id_listino,prezzo,data_inizio,data_fine)values

(new.id_articolo,new.id_listino,old.prezzo,old.data_inizio,new.data_inizio);

end if;



end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `furg_ins_mag` BEFORE INSERT ON `automezzo` FOR EACH ROW begin

  insert into tipo_magazzino set nome = new.modello, descrizione = null, prior = 2, id_master = null, reso = null;

end */;;
DELIMITER ;

DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `furg_mod_mag` BEFORE UPDATE ON `automezzo` FOR EACH ROW begin

  update tipo_magazzino set nome = new.modello where id_tipo = new.id_magazzino;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `com_comp` AFTER INSERT ON `commessa_articolo_comp` FOR EACH ROW update commessa_Articoli inner join commessa_Articolo_comp on 

commessa_articoli.id_commessa=commessa_articolo_comp.id_commessa and 

commessa_articoli.anno=commessa_articolo_comp.anno and

commessa_articoli.id_lotto=commessa_Articolo_comp.lotto and

commessa_articoli.id_tab=commessa_articolo_comp.id_forfait

inner join commessa_Articoli as a on 

a.id_commessa=commessa_articolo_comp.id_commessa and 

a.anno=commessa_articolo_comp.anno and

a.id_lotto=commessa_Articolo_comp.lotto and

a.id_tab=commessa_articolo_comp.id_dettaglio

set commessa_Articoli.prezzo=commessa_Articoli.prezzo-((a.prezzo+a.tempo/60*a.prezzo_ora)-((a.prezzo+a.tempo/60*a.prezzo_ora)*(a.sconto/100))*

a.quantità)

where commessa_articolo_comp.id_commessa=new.id_commessa and

commessa_Articolo_comp.anno=new.anno and 

commessa_Articolo_comp.lotto=new.lotto and

commessa_Articolo_comp.id_Dettaglio=new.id_dettaglio */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `com_comp_bf_dl` BEFORE DELETE ON `commessa_articolo_comp` FOR EACH ROW update commessa_Articoli inner join commessa_Articolo_comp on 

commessa_articoli.id_commessa=commessa_articolo_comp.id_commessa and 

commessa_articoli.anno=commessa_articolo_comp.anno and

commessa_articoli.id_lotto=commessa_Articolo_comp.lotto and

commessa_articoli.id_tab=commessa_articolo_comp.id_forfait

inner join commessa_Articoli as a on 

a.id_commessa=commessa_articolo_comp.id_commessa and 

a.anno=commessa_articolo_comp.anno and

a.id_lotto=commessa_Articolo_comp.lotto and

a.id_tab=commessa_articolo_comp.id_dettaglio

set commessa_Articoli.prezzo=commessa_Articoli.prezzo+((a.prezzo+a.tempo/60*a.prezzo_ora)-((a.prezzo+a.tempo/60*a.prezzo_ora)*(a.sconto/100))*

a.quantità)

where commessa_articolo_comp.id_commessa=old.id_commessa and

commessa_Articolo_comp.anno=old.anno and

commessa_Articolo_comp.lotto=old.lotto and

commessa_Articolo_comp.id_Dettaglio=old.id_dettaglio */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_ddt` BEFORE DELETE ON `ddt` FOR EACH ROW begin

delete from articolI_ddt where id_ddt=old.id_ddt and anno=old.anno;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_ddt_ric` BEFORE DELETE ON `ddt_ricevuti` FOR EACH ROW delete from articolI_ddt_ricevuti

where id_ddt=old.id_ddt and anno=old.anno */;;
DELIMITER ;


DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `pagaForn_insert` AFTER INSERT ON `fornfattura_pagamenti` FOR EACH ROW begin

update fornfattura inner join (select if( (select mesi from fornfattura as rata INNER  JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione

where rata.id_fattura=new.id_fattura and rata.anno=new.anno

)=(

select count(*) from fornfattura as rata INNER  JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione

INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione

   inner join fornfattura_pagamenti as pag on rata.id_fattura=pag.id_fattura and

  pag.anno=rata.anno and pag.id_pagamento= date_format(last_day(rata.DATA + INTERVAL g.mesi MONTH )+ interval g.giorni day,'%Y%m%d') and pag.data is not null

where rata.id_fattura=new.id_fattura and rata.anno=new.anno),"3","1") as "con" ) as conta set stato=con where fornfattura.id_fattura=new.id_fattura and fornfattura.anno=new.anno;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `pagaForn_update` AFTER UPDATE ON `fornfattura_pagamenti` FOR EACH ROW update fornfattura inner join (select if( (select mesi from fornfattura as rata INNER  JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione

where rata.id_fattura=new.id_fattura and rata.anno=new.anno

)=(

select count(*) from fornfattura as rata INNER  JOIN condizione_pagamento AS a ON cond_pagamento = a.id_condizione

INNER JOIN condizioni_giorno AS g ON g.id_condizione = a.id_condizione

   inner join fornfattura_pagamenti as pag on rata.id_fattura=pag.id_fattura and

  pag.anno=rata.anno and pag.id_pagamento= date_format(last_day(rata.DATA + INTERVAL g.mesi MONTH )+ interval g.giorni day,'%Y%m%d') and pag.data is not null

where rata.id_fattura=new.id_fattura and rata.anno=new.anno),"3","1") as "con" ) as conta set stato=con where fornfattura.id_fattura=new.id_fattura and fornfattura.anno=new.anno */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_contro` AFTER INSERT ON `impianto_abbonamenti_mesi` FOR EACH ROW begin

if (select max(anno) from impianto_abbonamenti where id_impianto=new.impianto limit 1 )<=new.anno  then

update impianto set costo_manutenzione=(Select if(new.prezzo is not null,new.prezzo,manutenzione) from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.impianto)

  where new.impianto=id_Impianto;

end if;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_contro` AFTER UPDATE ON `impianto_abbonamenti_mesi` FOR EACH ROW begin

if (select max(anno) from impianto_abbonamenti where id_impianto=new.impianto limit 1 )<=new.anno  then





    update impianto set costo_manutenzione=(Select if(new.prezzo is not null,new.prezzo,manutenzione) from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.impianto)





  where new.impianto=impianto.id_Impianto;







end if;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_abbo_imp` AFTER INSERT ON `impianto_uscita` FOR EACH ROW begin

if (select max(anno) from impianto_uscita where id_impianto=new.id_impianto) <=new.anno  then

update impianto set costo_manutenzione=(Select new.manutenzione from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.id_impianto) where impianto.id_impianto=new.id_impianto;

end if;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_abbo_imp` AFTER UPDATE ON `impianto_uscita` FOR EACH ROW begin

if (select max(anno) from impianto_uscita where id_impianto=new.id_impianto) <=new.anno  then

update impianto set costo_manutenzione=(Select new.manutenzione from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.id_impianto) where impianto.id_impianto=new.id_impianto;

end if;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_art_lis` AFTER INSERT ON `lista_articoli` FOR EACH ROW if (new.id_Articolo is not null)and(new.causale_scarico is not null) then



insert into magazzino_operazione (data,articolo,quantità,id_magazzino,causale)values(

 (select data from lista_prelievo where id_lista=new.id_lista and anno=new.anno),new.id_articolo,concat('-',new.quantità),new.causale_scarico

 ,(select id_causale from causale_magazzino where operazione=2 and tipo_magazzino=new.causale_scarico));



insert into magazzino_operazione (data,articolo,quantità,id_magazzino,causale)values(

 (select data from lista_prelievo where id_lista=new.id_lista and anno=new.anno),new.id_articolo,new.quantità,(select tipo_magazzino from

causale_magazzino where id_causale=(select causale from lista_prelievo where id_lista=new.id_lista and new.anno=anno))

 ,(select causale from lista_prelievo where id_lista=new.id_lista and new.anno=anno));



insert into magazzino_liste(id_lista,id_operazione_del,id_operazione_ins,anno,id_tab)values(new.id_lista,(Select max(id_operazione)-1 from magazzino_operazione ),

(Select max(id_operazione) from magazzino_operazione ),new.anno,new.numero_tab);





end if */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_art_lis` AFTER DELETE ON `lista_articoli` FOR EACH ROW begin





delete from magazzino_operazione where id_operazione=(Select id_operazione_del from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab);

delete from magazzino_operazione where id_operazione=(Select id_operazione_ins from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab);



delete from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab;





end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_lis` BEFORE DELETE ON `lista_prelievo` FOR EACH ROW begin

delete from lista_articoli where id_Lista=old.id_lista and anno=old.anno;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `insmarc` AFTER INSERT ON `marca` FOR EACH ROW begin

    insert into listino(nome)values(new.nome);

    insert into marca_listino (id_listino,id_marca) select id_listino,new.id_marca from listino where nome =new.nome;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `marca_list_del` BEFORE DELETE ON `marca` FOR EACH ROW begin



  delete from listino where listino.id_listino = (select id_listino from marca_listino where id_marca=old.id_marca);

  delete from marca_listino where marca_listino.id_marca = old.id_marca;

end */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_note_mobile` AFTER DELETE ON `note_mobile` FOR EACH ROW BEGIN

        insert into note_mobile_old (id_cliente, ragione_sociale, desc_brev, id_impianto, id_articolo, id_nota_old, testo, tipo_nota, id_tecnico, id_utente, data)

                      values  (old.id_cliente, old.ragione_sociale, old.desc_brev, old.id_impianto, old.id_articolo, old.id_nota, old.testo, old.tipo_nota,old.id_tecnico, old.id_utente, old.data);

END */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_rapp` BEFORE DELETE ON `rapporto` FOR EACH ROW delete from rapporto_materiale where id_rapporto=old.id_rapporto and anno=old.anno */;;
DELIMITER ;

DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_maga` AFTER INSERT ON `tipo_magazzino` FOR EACH ROW insert into causale_magazzino(nome,operazione,tipo_magazzino,reso)values(

concat(new.nome," CARICO"),1,new.id_TIPO,new.reso),

(

concat(new.nome," SCARICO"),2,new.id_TIPO,new.reso) */;;
DELIMITER ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_tipo_maga` AFTER UPDATE ON `tipo_magazzino` FOR EACH ROW begin

  update causale_magazzino set nome = if(causale_magazzino.operazione = 1,concat(new.nome," CARICO"),concat(new.nome," SCARICO")) where causale_magazzino.tipo_magazzino = new.id_tipo;

end */;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `CollaudoToRapporto`(ID INT, ANNOP INT)
BEGIN



  DECLARE  i INT;

  SET i=0;



    insert into rapporto_mobile

    (stato, scan, id_rapporto, anno,     id_impianto, id_destinazione, id_cliente, richiesto, email_invio, tipo_intervento, Diritto_chiamata, tipo_diritto_chiamata, relazione,  Note_Generali, `data`, data_esecuzione, festivo, su_chiamata, eff_giorn, sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, fuoriabbon, man_straord, tipo_impianto, ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, id_riferimento, mail_responsabile, appunti, tecnici, inviato, visionato, id_utente, numero, Nr_rapporto  )

    select

    "1", "1", id_collaudo_invio, anno,id_impianto, if(id_impianto is null, "1", (select destinazione from impianto where impianto.id_impianto=collaudo.id_impianto)), id_cliente, if(richiesto is null , "", richiesto) , mail, "7", "0","0", "Generato da Rapporto di Collaudo",note,  `data`,`data`, 0, 0,0,0,0,"",0,0,0,0,0,0,0, if(furto=1, "furto", if(incendio=1, "incendio",if(tvcc=1, "circuito chiuso",  "macro" ))), cliente, "","","","",id_riferimento,mail_responsabile, appunti, tecnici, 1, 0, id_utente, id_collaudo_invio, id_collaudo_invio from collaudo where id_collaudo_invio=ID and anno=ANNOP ;



    insert into rapporto_tecnico_mobile select id_collaudo_invio, anno, tecnici, "a contratto", 0,0,0, km , orespo1,0, "",null, null,oreint1, null, null,  0,"","",nviaggi from collaudo where id_collaudo_invio=ID and anno=ANNOP ;



  WHILE i<=6 DO

    insert into rapporto_materiali_mobile values (ID, ANNOP, i, "","");

    SET i=i+1;

  END WHILE;





END ;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `CreaBozza`(mittente INT,  id_utenteP int, OUT ID_MAILP INT)
BEGIN

  DECLARE ID int;

  SET ID=-1;

  select max(id_mail)+1 INTO ID from mail;

  IF(ID=-1) then

    SET ID=1;

  END IF ;



  INSERT INTO MAIL (id_mail, oggetto, stato, mittente, data_ora_sped, tentativo, id_utente)

        values (ID, "", 5, mittente, now(), 0 , id_utenteP );



  SET ID_MAILP=ID;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `ricanni`(

        IN   id_ric                    INT(11)       ,

        IN   star                    int(11),

        IN  n_anni                      VARCHAR(15),

        in tip int(11)

     )
BEGIN

declare i int(11);



SET i = 0;



 WHILE i < n_anni DO

if tip=1 then

insert into evento(ora_fine,ora_inizio,ricorrenza,descrizione,data_inizio,data_fine,tipo)

 select ora_fine,ora_inizio,id_ricorrenza,nota,STR_TO_DATE(concat(date_format(giorno_inizio,'%d/%m/'),date_format(now()+interval i+star year,'%Y')),'%d/%m/%Y') as "data_inizio",

STR_TO_DATE(concat(date_format(giorno_inizio,'%d/%m/'),date_format(now()+interval i+star year,'%Y')),'%d/%m/%Y') as "data_fine",tipo

from evento_ricorrenza where id_ricorrenza=id_ric;

end if;



if tip=2 then

insert into evento(ora_fine,ora_inizio,ricorrenza,descrizione,data_inizio,data_fine,tipo)

 select ora_fine,ora_inizio,id_ricorrenza,nota,(giorno_inizio+interval i+star month) as "data_inizio",

(giorno_fine+interval i+star month) as "data_fine",tipo

from evento_ricorrenza where id_ricorrenza=id_ric;

end if;



if tip=3 then

insert into evento(ora_fine,ora_inizio,ricorrenza,descrizione,data_inizio,data_fine,tipo)

 select ora_fine,ora_inizio,id_ricorrenza,nota,(giorno_inizio+ interval i+star week) as "data_inizio",

(giorno_fine+ interval i+star week) as "data_fine",tipo

from evento_ricorrenza where id_ricorrenza=id_ric;

end if;



if tip=4 then

insert into evento(ora_fine,ora_inizio,ricorrenza,descrizione,data_inizio,data_fine,tipo)

 select ora_fine,ora_inizio,id_ricorrenza,nota,(giorno_inizio+ interval i*anno+star day) as "data_inizio",

(giorno_fine+ interval i*anno+star day) as "data_fine",tipo

from evento_ricorrenza where id_ricorrenza=id_ric;

end if;





  SET i = i + 1;

 END WHILE;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerContactGet`()
BEGIN



	SELECT DISTINCT id_riferimento, 

		clienti.id_cliente, 

		IFNULL(nome, "") 'nome', 

		IFNULL(riferimento_figura.Figura, "") 'figura',

		IFNULL(riferimento_clienti.Telefono, "") 'telefono', 

		IFNULL(riferimento_clienti.altro_telefono, "") 'altro_telefono', 

		IFNULL(riferimento_clienti.mail, "") 'mail'	

	FROM clienti 

		INNER JOIN impianto ON 

			clienti.Id_cliente = impianto.Id_cliente

		INNER JOIN riferimento_clienti ON 

			clienti.Id_cliente = riferimento_clienti.Id_cliente

		INNER JOIN riferimento_figura ON 

			riferimento_clienti.figura = riferimento_figura.Id_figura;

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerDestinationDaysToAvoidGet`()
BEGIN   

	SELECT id_destinazione,

		id_cliente, 

		id_giorno

	FROM destinazione_giorni; 	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerDestinationGet`()
BEGIN



	SELECT DISTINCT id_destinazione, 

		clienti.id_cliente,

		IFNULL(destinazione_cliente.provincia, "") 'provincia',

		IFNULL(comune.nome, "") 'comune',

		IFNULL(frazione.nome, "") 'frazione',

		IFNULL(indirizzo, "") 'indirizzo', 

		IFNULL(numero_civico, 0) 'numero_civico', 

		IFNULL(destinazione_cliente.altro, "") 'altro', 

		km_sede, 

		tempo_strada

	FROM clienti 

		INNER JOIN impianto ON 

			clienti.Id_cliente = impianto.Id_cliente

		INNER JOIN destinazione_cliente  ON 

			clienti.Id_cliente = destinazione_cliente.Id_cliente

		LEFT JOIN comune ON

			destinazione_cliente.comune = id_comune

		LEFT JOIN frazione ON

			destinazione_cliente.Frazione = id_frazione;

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerDestinationGetById`(

customer_id INT,

destination_id INT

)
BEGIN



	SELECT DISTINCT id_destinazione, 

		clienti.id_cliente,

		IFNULL(destinazione_cliente.provincia, "") 'provincia',

		IFNULL(comune.nome, "") 'comune',

		IFNULL(frazione.nome, "") 'frazione',

		IFNULL(indirizzo, "") 'indirizzo', 

		IFNULL(numero_civico, 0) 'numero_civico', 

		IFNULL(destinazione_cliente.altro, "") 'altro', 

		km_sede, 

		tempo_strada

	FROM clienti 

		INNER JOIN impianto ON 

			clienti.Id_cliente = impianto.Id_cliente

		INNER JOIN destinazione_cliente  ON 

			clienti.Id_cliente = destinazione_cliente.Id_cliente

		LEFT JOIN comune ON

			destinazione_cliente.comune = id_comune

		LEFT JOIN frazione ON

			destinazione_cliente.Frazione = id_frazione

	WHERE clienti.id_cliente = customer_id AND id_destinazione = destination_id; 

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerDestinationGetBySystemId`(system_id INT)
BEGIN



	DECLARE customer_id INT; 

	DECLARE destination_id INT; 

	

	SELECT id_cliente, 

	impianto.Destinazione

	INTO customer_id, destination_id

	FROM IMPIANTO 

	WHERE impianto.Id_impianto = system_id; 



	SELECT DISTINCT id_destinazione, 

		clienti.id_cliente,

		IFNULL(destinazione_cliente.provincia, "") 'provincia',

		IFNULL(comune.nome, "") 'comune',

		IFNULL(frazione.nome, "") 'frazione',

		IFNULL(indirizzo, "") 'indirizzo', 

		IFNULL(numero_civico, 0) 'numero_civico', 

		IFNULL(destinazione_cliente.altro, "") 'altro', 

		km_sede, 

		tempo_strada

	FROM clienti 

		INNER JOIN impianto ON 

			clienti.Id_cliente = impianto.Id_cliente

		INNER JOIN destinazione_cliente  ON 

			clienti.Id_cliente = destinazione_cliente.Id_cliente

		LEFT JOIN comune ON

			destinazione_cliente.comune = id_comune

		LEFT JOIN frazione ON

			destinazione_cliente.Frazione = id_frazione

	WHERE clienti.id_cliente = customer_id AND id_destinazione = destination_id; 

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiCustomerGet`()
BEGIN



	SELECT DISTINCT clienti.id_cliente, 

		ragione_sociale,

		IFNULL(partita_iva , "") 'partita_iva', 

		IFNULL(codice_fiscale, "") 'codice_fiscale'			

	FROM clienti 

		INNER JOIN impianto ON 

			clienti.Id_cliente IN (impianto.Id_cliente, impianto.Id_gestore, impianto.Id_occupante);

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiEventEmployeeGet`()
BEGIN   

	SELECT Id, 

		Id_evento,

		id_operaio

	FROM Evento_operaio; 	

END ;;
DELIMITER ;



DELIMITER ;;
CREATE PROCEDURE `sp_apiSupervisionGet`()
BEGIN

	SELECT Id_vigilante,

	IFNULL(tipo, 0) AS Tipo, 

	IFNULL(Descrizione, "") AS Descrizione,

	IFNULL(telefono, "") AS Telefono, 

	IFNULL(altro_telefono, "") AS Altro_telefono,

	IFNULL(cellulare, "") Cellulare, 

	IFNULL(mail,"") Email

	FROM vigilante;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSupervisionTypeGet`()
BEGIN

	SELECT Id_tipo, 

	Nome 

	FROM tipo_vigilante;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemGet`()
BEGIN

	SELECT `impianto`.`Id_impianto` AS `id_impianto`,

	`impianto`.`Id_cliente` AS `id_cliente`,

	IFNULL(`impianto`.`Abbonamento`,0) AS `id_abbonamento`, 

	impianto.Destinazione AS Id_destinazione, 

	IFNULL(`impianto`.`Data_Funzione`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `data_funzione`, 

	IFNULL(`impianto`.`scadenza_garanzia`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `Scadenza_Garanzia`,

	`impianto`.`Tipo_impianto` AS `tipo_impianto`,

	`impianto`.`Stato` AS `stato`,

	`impianto`.`Descrizione` AS `descrizione`, 

	IFNULL(`impianto`.`centrale`,'') AS `centrale`, 

	IFNULL(`impianto`.`gsm`,'') AS `gsm`, 

	IFNULL(`impianto`.`combinatore_telefonico`,'') AS `combinatore_telefonico`,

	`impianto`.`orario_prog` AS `orario_prog`

	FROM `impianto`

	WHERE ((`impianto`.`Stato` < 4) OR (`impianto`.`Stato` > 7))

	GROUP BY `impianto`.`Id_impianto`;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemGetById`(id INT)
BEGIN

	SELECT `impianto`.`Id_impianto` AS `id_impianto`,

	`impianto`.`Id_cliente` AS `id_cliente`,

	IFNULL(`impianto`.`Abbonamento`,0) AS `id_abbonamento`, 

	impianto.Destinazione AS Id_destinazione, 

	IFNULL(`impianto`.`Data_Funzione`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `data_funzione`, 

	IFNULL(`impianto`.`scadenza_garanzia`, CAST('0000-00-00 00:00:00' AS DATETIME)) AS `Scadenza_Garanzia`,

	`impianto`.`Tipo_impianto` AS `tipo_impianto`,

	`impianto`.`Stato` AS `stato`,

	`impianto`.`Descrizione` AS `descrizione`, 

	IFNULL(`impianto`.`centrale`,'') AS `centrale`, 

	IFNULL(`impianto`.`gsm`,'') AS `gsm`, 

	IFNULL(`impianto`.`combinatore_telefonico`,'') AS `combinatore_telefonico`,

	`impianto`.`orario_prog` AS `orario_prog`

	FROM `impianto`

	WHERE impianto.id_impianto = id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemNoteGet`()
BEGIN

	SELECT  impianto_note.Id_impianto, 

		impianto_note.Id_nota, 

		impianto_note.Testo

	FROM impianto_note;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemNoteTypeGet`()
BEGIN

	SELECT impianto_note_descrizione.Id_descrizione, 

		Nome

	FROM impianto_note_descrizione;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemProductGet`()
BEGIN

	SELECT Id_impianto, 

		Id_articolo,

		count(id_articolo) "quantita"

	FROM impianto_componenti

	WHERE Data_dismesso IS NULL

	GROUP BY id_impianto, id_articolo;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemReferenceContactGet`()
BEGIN

SELECT id_impianto,

id_cliente,

id_riferimento

	FROM impianto_riferimento ;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemSupervisionGet`()
BEGIN

	SELECT iv.Id_impianto, 

	iv.Id_vigilante, 

	IFNULL(tipo, 0) as Tipo

	FROM impianto_vigilante AS iv 

	LEFT JOIN impianto_vigilante_collegamenti AS ivc 

	ON iv.Id_impianto = ivc.id_impianto AND iv.Id_vigilante = ivc.id_vigilante; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiSystemTypeGet`()
BEGIN

	SELECT id_tipo,

		nome

	FROM tipo_impianto;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiTechnicianGet`()
BEGIN

	SELECT id_operaio, 

	ragione_sociale, 

	mail_account 

	FROM  Operaio 

	WHERE Data_licenziamento is null and Is_tecnico=1;	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiTicketGet`()
BEGIN

	SELECT `ticket`.`Id_ticket` AS `id_ticket`,

		`ticket`.`anno` AS `anno`,

		`ticket`.`Id_impianto` AS `id_impianto`,

		`ticket`.`Id_cliente` AS `id_cliente`,

		ticket.id_destinazione,

		`ticket`.`Urgenza` AS `urgenza`,

		`ticket`.`Descrizione` AS `ticket_descrizione`

	FROM ticket

	WHERE ((`ticket`.`Stato_ticket` = '1' OR `ticket`.`Stato_ticket` = '2') AND (`ticket`.`Id_impianto` IS NOT NULL)); 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_apiUserGet`()
BEGIN

	SELECT id_utente, 

	nome, 

	`password` ,

	salt

	FROM  Utente;	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM banca 

	WHERE id_banca = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankGet`( 

)
BEGIN

	SELECT id_banca,

	Nome,

	IFNULL(abi, '') AS 'abi',  

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM banca

	ORDER BY id_banca;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankGetById`( 

	Bank_id INT

)
BEGIN

	SELECT id_banca,

	Nome,

	IFNULL(abi, '') AS 'abi',  

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM banca

	WHERE id_banca = Bank_id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankGetByName`( 

	name VARCHAR(45)

)
BEGIN

	SELECT id_banca,

	Nome,

	IFNULL(abi, '') AS 'abi',  

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM banca

	WHERE Nome = name;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankInsert`( 

	name VARCHAR(45),

	enter_abi VARCHAR(5),

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	



	SELECT Count(Nome) INTO Result

	FROM Banca 

	WHERE Nome = Name; 

	

	IF Result > 0 THEN

		 SET Result = -1; 
	END IF;



	

	IF Result = 0 THEN

		INSERT INTO Banca 

		SET 

			Nome = name,

			abi = enter_abi, 

			Data_ins = NOW(), 

			Data_mod = NOW(),

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesBankUpdate`( 

	enter_id INTEGER,

	name VARCHAR(45),

	enter_abi VARCHAR(5),

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	



	SELECT Count(Nome) INTO Result

	FROM banca 

	WHERE Nome = Name AND id_banca != enter_id; 

	

	IF Result > 0 THEN

		 SET Result = -1; 
	END IF;



	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM Banca 

			WHERE id_banca = enter_id;

			

			IF Result = 0 THEN

				SET Result = -2; 
			END IF; 

	END IF; 

	

	IF Result >0 THEN

		

		

		UPDATE Banca 

		SET 

			Nome = name,

			abi = enter_abi, 

			Utente_mod = @USER_ID

		Where id_banca = enter_id;

		

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `sp_ariesCountryDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Nazione 

	WHERE id_Nazione = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesCountryGet`( 

)
BEGIN

	SELECT Id_nazione,

	Nome,

	sigla,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Nazione

	ORDER BY Id_nazione;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesCountryGetById`( 

	Country_id INT

)
BEGIN

	SELECT Id_nazione,

	Nome,

	sigla,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Nazione

	WHERE Id_nazione = Country_id

	ORDER BY Id_nazione;

END ;;
DELIMITER ;



DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByEventId`( 

	event_id Integer

)
BEGIN



		SELECT Id, 

		File_name, 

		id_evento, 

		id_operaio, 

		data_ins, 

		data_mod, 

		utente_ins, 

		utente_mod	

	FROM evento_file_associati_caldav  

	WHERE id_evento = event_id; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByEventIdAndEmployeeId`( 

	event_id Integer,

	employee_id integer

)
BEGIN



		SELECT Id, 

		File_name, 

		id_evento, 

		id_operaio, 

		data_ins, 

		data_mod, 

		utente_ins, 

		utente_mod	

	FROM evento_file_associati_caldav  

	WHERE id_evento = event_id AND id_operaio = employee_id; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventFileAssociatedCaldavGetByFileName`( 

	enter_file_name VARCHAR(150)

)
BEGIN



		SELECT Id, 

		File_name, 

		id_evento, 

		id_operaio, 

		data_ins, 

		data_mod, 

		utente_ins, 

		utente_mod	

	FROM evento_file_associati_caldav  

	WHERE file_name = enter_file_name; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventFileAssociatedCaldavGetById`( 

	enter_id INT

)
BEGIN



		SELECT Id, 

		File_name, 

		id_evento, 

		id_operaio, 

		data_ins, 

		data_mod, 

		utente_ins, 

		utente_mod	

	FROM evento_file_associati_caldav  

	WHERE id = enter_id; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventFileAssociatedCaldavInsert`( 

	event_id INT, 

	input_file_name VARCHAR(150), 

	employee_id INT

)
BEGIN





	IF event_id IS NULL 

	THEN

		SET event_id = 1; 

	END IF; 



	 INSERT INTO evento_file_associati_caldav 

	 SET 

		File_name = input_file_name, 

		id_evento = event_id, 

		id_operaio = employee_id, 

		data_ins = NOW(), 

		utente_ins = @USER_ID, 

		utente_mod = @USER_ID;   



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventGet`( )
BEGIN

        

	SELECT Id,

		Oggetto, 

		Descrizione, 

		Id_riferimento, 

		id_tipo_evento, 

		Eseguito, 

		Ricorrente, 

		Giorni_ricorrenza,

		Data_esecuzione, 

		Ora_inizio_esecuzione, 

		Ora_fine_esecuzione, 

		Sveglia, 

		Data_sveglia,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento

	ORDER BY Id; 



	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventGetById`( 

enter_id INT

)
BEGIN

        

	SELECT Id,

		Oggetto, 

		Descrizione, 

		Id_riferimento, 

		id_tipo_evento, 

		Eseguito, 

		Ricorrente, 

		Giorni_ricorrenza,

		Data_esecuzione, 

		Ora_inizio_esecuzione, 

		Ora_fine_esecuzione,

		Sveglia,  

		Data_sveglia,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento

	WHERE Id = enter_id; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventGetByTypeAndReferId`( 

refer_id INT,

event_type TINYINT

)
BEGIN

        

	SELECT Id,

		Oggetto, 

		Descrizione, 

		Id_riferimento, 

		id_tipo_evento, 

		Eseguito, 

		Ricorrente, 

		Giorni_ricorrenza,

		Data_esecuzione, 

		Ora_inizio_esecuzione, 

		Ora_fine_esecuzione,

		Sveglia,  

		Data_sveglia,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento

	WHERE id_riferimento = refer_id

		AND id_tipo_evento = event_type; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventInsert`(

subject VARCHAR(50),

Description TEXT,

refer_id INT, 

event_type TINYINT, 

was_performed BIT,

is_recurs BIT, 

recurrence_days INT,

has_alarm BIT, 

execution_date DATE, 

execution_start_time TIME,

execution_end_time TIME,

alarm DATETIME,

OUT result BIT,

OUT InsertId INTEGER

)
BEGIN

	SET Result = 1; 

	SET InsertId = 0;



	If subject = "" OR subject IS NULL

	THEN

		SET Result = 0;  

	END IF; 	

	

	If Description = "" OR Description IS NULL

	THEN

		SET Result = 0;  

	END IF;

	

	If execution_date IS NULL

	THEN 

		SET Result = 0;  

	END IF;

	

	IF Result 

	THEN

		INSERT INTO Evento

		SET 

			Oggetto = Subject, 

			Descrizione = Description, 

			Id_riferimento = refer_id, 

			id_tipo_evento = event_type, 

			Eseguito = was_performed, 

			Ricorrente = is_recurs,

			giorni_ricorrenza = recurrence_days,

			Data_esecuzione = execution_date, 

			Sveglia = has_alarm, 

			Data_sveglia = alarm,

			Ora_inizio_esecuzione = execution_start_time, 

			ora_fine_esecuzione = execution_end_time,

			Data_mod = CURRENT_TIMESTAMP, 

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID; 

			

		SET InsertId = LAST_INSERT_ID();

		SET Result = 1; 

	END IF;  

		

	

		

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventSetWasPermormed`(

event_id INT,

was_performed BIT,

is_recurs BIT, 

OUT result INT

)
BEGIN

	DECLARE execution_date DATE; 

	DECLARE event_type TINYINT; 

	DECLARE refer_id INT; 

	

	SET Result = 1; 



	

	IF Result 

	THEN

		UPDATE Evento

		SET 

			Eseguito = was_performed, 

			Data_mod = CURRENT_TIMESTAMP, 

			Utente_mod = @USER_ID

		WHERE Id = event_id; 

		

		
		SELECT Data_esecuzione,

			id_tipo_evento, 

			id_riferimento 

		INTO

			execution_date, 

			event_type, 

			refer_id 

		FROM Evento

		WHERE Id = event_id; 

		

		IF was_performed AND event_type = 1 

		THEN

			UPDATE Impianto_abbonamenti_mesi 

			SET eseguito_il = execution_date

			WHERE Id = refer_id; 

		ELSE

			IF event_type = 1  THEN	

				UPDATE Impianto_abbonamenti_mesi 

				SET eseguito_il = execution_date

				WHERE Id = refer_id; 

			END IF; 	

		END IF; 

			

		IF is_recurs

		THEN

			INSERT INTO EVENTO 

			(

				oggetto, 

				Descrizione, 

				Id_riferimento, 

				id_tipo_evento, 

				Eseguito, 

				Ricorrente, 

				Giorni_ricorrenza,

				Data_esecuzione, 

				Ora_inizio_esecuzione, 

				Ora_fine_esecuzione,

				Sveglia,  

				Data_sveglia,

				Data_ins, 

				Data_mod, 

				Utente_ins, 

				Utente_mod

			) 

			SELECT oggetto, 

				Descrizione, 

				Id_riferimento, 

				id_tipo_evento, 

				0, 

				Ricorrente, 

				Giorni_ricorrenza,

				DATE_ADD(Data_esecuzione, INTERVAL Giorni_ricorrenza DAY), 

				Ora_inizio_esecuzione, 

				Ora_fine_esecuzione,

				Sveglia,  

				Data_sveglia,

				CURRENT_TIMESTAMP, 

				CURRENT_TIMESTAMP, 

				@USER_ID, 

				@USER_ID

			FROM Evento 

			WHERE Id = event_id;		

			

			SET Result = 0; 

			

			SET Result = LAST_INSERT_ID();

				

		END IF;	

		

	END IF;  

		

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventTypeGet`( 

)
BEGIN

        

	SELECT Id_tipo, 

	Nome, 

	Colore

	FROM Tipo_evento; 

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesEventUpdate`(

event_id INT,

subject VARCHAR(50),

Description TEXT,

refer_id INT, 

event_type TINYINT, 

was_performed BIT,

is_recurs BIT, 

recurrence_days INT,

has_alarm BIT, 

execution_date DATE, 

execution_start_time TIME,

execution_end_time TIME,

alarm DATETIME,

OUT result BIT

)
BEGIN

	SET Result = 1; 





	If subject = "" OR subject IS NULL

	THEN

		SET Result = 0;  

	END IF; 	

	

	If Description = "" OR Description IS NULL

	THEN

		SET Result = 0;  

	END IF;

	

	If execution_date IS NULL

	THEN 

		SET Result = 0;  

	END IF;

	

	IF Result 

	THEN

		UPDATE Evento

		SET 

			Oggetto = Subject, 

			Descrizione = Description, 

			Id_riferimento = refer_id, 

			id_tipo_evento = event_type, 

			Eseguito = was_performed, 

			Ricorrente = is_recurs,

			giorni_ricorrenza = recurrence_days,

			Data_esecuzione = execution_date, 

			Sveglia = has_alarm, 

			Data_sveglia = alarm,

			Ora_inizio_esecuzione = execution_start_time, 

			ora_fine_esecuzione = execution_end_time,

			Data_mod = CURRENT_TIMESTAMP, 

			Utente_mod = @USER_ID

		WHERE Id = event_id; 

		

		IF was_performed AND event_type = 1 

		THEN

			UPDATE Impianto_abbonamenti_mesi 

			SET eseguito_il = execution_date

			WHERE Id = refer_id; 

		ELSE

			IF event_type = 1  THEN	

				UPDATE Impianto_abbonamenti_mesi 

				SET eseguito_il = NULL

				WHERE Id = refer_id; 

			END IF; 	

		END IF; 

		

			

	END IF;  

		

	

		

END ;;
DELIMITER ;

DELIMITER ;;
CREATE DEFINER=`utente`@`%` PROCEDURE `sp_ariesGetUser`()
BEGIN

SELECT 



		id_utente, 

		Nome, 

		password,

		IFNULL(Descrizione,"") as descrizione,

		IFNULL(mail, "") AS mail, 

		IFNULL(Firma,"") as firma, 

		calendario,  

		IFNULL(smtp, "") as smtp, 

		IFNULL(porta, "0") as porta, 

		IFNULL(mssl, "") as mssl,

		IFNULL(nome_utente_mail, "") as nome_utente_mail,

		IFNULL(password_mail, "") as password_mail, 

		tipo_utente, 

		conferma, 

		salt

		

	  

		FROM utente;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM frazione 

	WHERE id_frazione = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletGet`( 

)
BEGIN

	SELECT Id_frazione,

	Nome,

	id_comune, 

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM frazione

	ORDER BY Id_frazione;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletGetById`( 

	Hamlet_id INT

)
BEGIN

	SELECT Id_frazione,

	Nome,

	id_comune,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM frazione

	WHERE Id_frazione = Hamlet_id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletGetByName`( 

	name VARCHAR(30)

)
BEGIN

	SELECT Id_frazione,

	Nome,

	id_comune,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM frazione

	WHERE Nome = name;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletInsert`( 

	name VARCHAR(30),

	municipality_id INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM comune 

	WHERE id_comune = municipality_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM frazione 

		WHERE Nome = Name; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN

		INSERT INTO frazione 

		SET 

			Nome = name,

			id_comune = municipality_id, 

			Data_ins = NOW(), 

			Data_mod = NOW(),

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesHamletUpdate`( 

	enter_id INTEGER,

	name VARCHAR(30),

	municipality_id INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM comune 

	WHERE id_comune = municipality_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM frazione 

		WHERE Nome = Name AND Id_frazione != enter_id; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM frazione 

			WHERE id_frazione = enter_id;

			

			IF Result = 0 THEN

				SET Result = -3; 
			END IF; 

	END IF; 

	

	IF Result >0 THEN

		UPDATE frazione 

		SET 

			Nome = name,

			id_comune = municipality_id, 

			Utente_mod = @USER_ID

		Where id_frazione = enter_id;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Comune 

	WHERE id_comune = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityGet`( 

)
BEGIN

	SELECT Id_comune,

	Nome,

	Provincia, 

	Cap, 

	Id_Provincia,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Comune

	ORDER BY Id_comune;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityGetById`( 

	municipality_id INT

)
BEGIN

	SELECT Id_comune,

	Nome,

	Provincia, 

	Cap, 

	Id_Provincia,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Comune

	WHERE Id_Comune = municipality_id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityGetByName`( 

	name VARCHAR(30)

)
BEGIN

	SELECT Id_comune,

	Nome,

	Provincia, 

	Cap, 

	Id_Provincia,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Comune

	WHERE Nome = name;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityInsert`( 

	name VARCHAR(30),

	province varchar(5),

	postal_code varchar(10),

	province_id INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Province 

	WHERE sigla = province AND id_provincia = province_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM Comune 

		WHERE Nome = Name AND Cap = postal_code; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN

		INSERT INTO Comune 

		SET 

			Nome = name,

			Provincia = province , 

			Cap = postal_code, 

			Id_Provincia = province_id,

			Data_ins = NOW(),  

			Data_mod = NOW(),

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesMunicipalityUpdate`( 

	enter_id INTEGER,

	name VARCHAR(30),

	province varchar(5),

	postal_code varchar(10),

	province_id INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Province 

	WHERE sigla = province AND id_provincia = province_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM Comune 

		WHERE Nome = Name AND Cap = postal_code AND id_comune != enter_id;

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM Comune 

			WHERE id_comune = enter_id;

			

			IF Result = 0 THEN

				SET Result = -3; 
			END IF; 

	END IF; 

	

	IF Result >0 THEN

		UPDATE Comune 

		SET 

			Nome = name,

			Provincia = province , 

			Cap = postal_code, 

			Id_Provincia = province_id,

			Utente_mod = @USER_ID

		Where id_comune = enter_id;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM province 

	WHERE id_provincia = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceGet`( 

)
BEGIN

	SELECT id_provincia,

	Nome,

	Sigla, 

	Regione, 

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM province

	ORDER BY id_provincia;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceGetById`( 

	Province_id INT

)
BEGIN

	SELECT id_provincia,

	Nome,

	Sigla, 

	Regione, 

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM province

	WHERE id_provincia = Province_id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceGetByName`( 

	name VARCHAR(45)

)
BEGIN

	SELECT id_provincia,

	Nome,

	Sigla, 

	Regione, 

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM province

	WHERE Nome = name;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceInsert`( 

	name VARCHAR(45),

	region_id INTEGER,

	abbreviation VARCHAR(5),

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Regione 

	WHERE id_regione = region_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM province 

		WHERE Nome = Name; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN

		INSERT INTO province 

		SET 

			Nome = name,

			Regione = region_id,

			Sigla = abbreviation, 

			Data_ins = NOW(), 

			Data_mod = NOW(),

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesProvinceUpdate`( 

	enter_id INTEGER,

	name VARCHAR(45),

	abbreviation VARCHAR(5),

	region_id INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM regione 

	WHERE id_regione = region_id; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM province 

		WHERE Nome = Name AND id_provincia != enter_id; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM province 

			WHERE id_provincia = enter_id;

			

			IF Result = 0 THEN

				SET Result = -3; 
			END IF; 

	END IF; 

	

	IF Result >0 THEN

		

		START TRANSACTION;

		

		UPDATE Comune 

		SET Provincia = abbreviation

		WHERE Id_provincia = enter_id; 	

		

		UPDATE province 

		SET 

			Nome = name,

			Regione = region_id, 

			Sigla = abbreviation, 

			Utente_mod = @USER_ID

		Where id_provincia = enter_id;

		

		COMMIT;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Regione 

	WHERE id_Regione = enter_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionGet`( 

)
BEGIN

	SELECT Id_Regione,

	Nome,

	Nazione, 

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Regione

	ORDER BY Id_Regione;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionGetById`( 

	Region_id INT

)
BEGIN

	SELECT Id_Regione,

	Nome,

	Nazione,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Regione

	WHERE Id_Regione = Region_id;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionGetByName`( 

	name VARCHAR(30)

)
BEGIN

	SELECT Id_Regione,

	Nome,

	Nazione,

	Data_ins, 

	Data_mod,

	Utente_ins, 

	Utente_mod	

	FROM Regione

	WHERE Nome = name;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionInsert`( 

	name VARCHAR(30),

	country INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Nazione 

	WHERE id_nazione = country; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM Regione 

		WHERE Nome = Name; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN

		INSERT INTO Regione 

		SET 

			Nome = name,

			Nazione = country, 

			Data_ins = NOW(), 

			Data_mod = NOW(),

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesRegionUpdate`( 

	enter_id INTEGER,

	name VARCHAR(30),

	country INTEGER,

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Nazione 

	WHERE id_nazione = country; 

	

	IF Result>0 THEN

	

		SELECT Count(Nome) INTO Result

		FROM Regione 

		WHERE Nome = Name AND Id_regione != enter_id; 

		

		IF Result > 0 THEN

			 SET Result = -1; 
		END IF;

	ELSE

		SET Result = -2; 
	END IF;

	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM Regione 

			WHERE id_Regione = enter_id;

			

			IF Result = 0 THEN

				SET Result = -3; 
			END IF; 

	END IF; 

	

	IF Result > 0 THEN

		UPDATE Regione 

		SET 

			Nome = name,

			Nazione = country, 

			Utente_mod = @USER_ID

		Where id_Regione = enter_id;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `sp_ariesReportMabileInterventionProductByReportId`( 

	report_id INT,

	report_year INT

)
BEGIN

	SELECT Id,       

	      codice_articolo,       

	      descrizione,        

	      quantita,       

	      posizione,      

	      id_rapporto,       

	      anno_rapporto       

	

	FROM rapporto_mobile_materiale       

	WHERE Id_rapporto = report_id AND anno_rapporto = report_year;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesReportMabileInterventionTechnicianByReportId`( 

	report_id INT,

	report_year INT

)
BEGIN

  SELECT Id,       

      id_tecnico,       

      tempo_lavorato,        

      km,       

      tempo_viaggio,      

      id_rapporto,       

      anno_rapporto       

  FROM rapporto_mobile_tecnico       

  WHERE Id_rapporto = report_id AND anno_rapporto = report_year; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemGet`( )
BEGIN

        



	SELECT Id_impianto,

		id_cliente, 

		id_gestore, 

		id_occupante, 

		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,

		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,

		IFNULL(altro, "") AS altro, 

		IFNULL(Abbonamento, 0) abbonamento, 

		Tipo_impianto,  

		IFNULL(Stato, 0) AS Stato , 

		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,

		IFNULL(Descrizione, '') As Descrizione, 

		IFNULL(Destinazione, 0) AS Destinazione , 

		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 

		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 

		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,

		IFNULL(Persone, 0) AS Persone, 

		Data_modifica, 

		Contr, 

		IFNULL(sub, 0) AS sub, 

		IFNULL(orario_prog, 0) AS orario_prog, 

		IFNULL(id_utente, 0) AS id_utente, 

		IFNULL(auto, 0) AS Auto, 

		IFNULL(condizione, 0) AS condizione, 

		IFNULL(eta, 0) AS eta, 

		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 

		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,

		IFNULL(Checklist, 0) Checklist,

		IFNULL(Centrale, "") AS Centrale, 

		IFNULL(gsm, "") AS gsm, 

		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 

		IFNULL(flag_abbonamento, 0) As flag_abbonamento,

		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno

	FROM Impianto;

		

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemGetById`( 

  systemId INT

)
BEGIN

        



	SELECT Id_impianto,

		id_cliente, 

		id_gestore, 

		id_occupante, 

		CAST(IFNULL(Data_funzione,'1970-01-01') AS DATE) AS Data_funzione,

		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS Data_terminazione,

		IFNULL(altro, "") AS altro, 

		IFNULL(Abbonamento, 0) abbonamento, 

		Tipo_impianto,  

		IFNULL(Stato, 0) AS Stato , 

		CAST(IFNULL(Data_terminazione,'1970-01-01') AS DATE) AS scadenza_garanzia,

		IFNULL(Descrizione, '') As Descrizione, 

		IFNULL(Destinazione, 0) AS Destinazione , 

		IFNULL(Tempo_manutenzione, 0) AS Tempo_manutenzione, 

		IFNULL(Costo_Manutenzione, 0) AS Costo_Manutenzione, 

		CAST(IFNULL(Data_registrazione ,'1970-01-01') AS DATE) AS Data_registrazione,

		IFNULL(Persone, 0) AS Persone, 

		Data_modifica, 

		Contr, 

		IFNULL(sub, 0) AS sub, 

		IFNULL(orario_prog, 0) AS orario_prog, 

		IFNULL(id_utente, 0) AS id_utente, 

		IFNULL(auto, 0) AS Auto, 

		IFNULL(condizione, 0) AS condizione, 

		IFNULL(eta, 0) AS eta, 

		IFNULL(Stato_invio_doc, "") As stato_invio_doc, 

		CAST(IFNULL(Data_invio_doc,'1970-01-01') AS DATE) AS Data_invio_doc,

		IFNULL(Checklist, 0) Checklist,

		IFNULL(Centrale, "") AS Centrale, 

		IFNULL(gsm, "") AS gsm, 

		IFNULL(combinatore_telefonico, "") AS combinatore_telefonico, 

		IFNULL(flag_abbonamento, 0) As flag_abbonamento,

		IFNULL(flag_abbonamento_anno, 0) AS flag_abbonamento_anno

	FROM Impianto

	WHERE (Id_impianto = systemId); 

		

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemPeriodicMonitoringDeleteById`(

	enter_id INT,

	OUT Result INT

)
BEGIN



	SELECT Id

		INTO

		Result 

	FROM Impianto_abbonamenti_mesi

	WHERE id = enter_id;



	

	IF Result THEN

		DELETE FROM  impianto_abbonamenti_mesi 

		WHERE Id = enter_id;  

		

		DELETE FROM Evento 

		WHERE Id_tipo_evento = 1

			AND Id_riferimento = enter_id; 

				

		SET Result = 1; 

	

	ELSE

		SET Result = -5; 
			

	END IF; 

	

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemPeriodicMonitoringGet`()
BEGIN

	SELECT Id,

		impianto AS Id_impianto,

		anno, 

		abbonamenti AS id_abbonamento, 

		mese, 

		Eseguito_il, 

		IFNULL(Id_rapp, 0) AS id_rapporto, 

		IFNULL(anno_rapp, 0) AS anno_rapporto, 

		da_eseguire,

		IFNULL(prezzo, 0 ) AS prezzo, 

		IFNULL(nota_mese, "") AS note,

		IFNULL(modifica_mese, 0) AS modifica_mese,

		IFNULL(modifica_anno, 0) AS modifica_anno

	FROM Impianto_abbonamenti_mesi; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemPeriodicMonitoringGetById`(

	enter_id INT

)
BEGIN

	SELECT Id,

		impianto AS Id_impianto,

		anno, 

		abbonamenti AS id_abbonamento, 

		mese, 

		Eseguito_il, 

		IFNULL(Id_rapp, 0) AS id_rapporto, 

		IFNULL(anno_rapp, 0) AS anno_rapporto, 

		da_eseguire,

		IFNULL(prezzo, 0 ) AS prezzo, 

		IFNULL(nota_mese, "") AS note,

		IFNULL(modifica_mese, 0) AS modifica_mese,

		IFNULL(modifica_anno, 0) AS modifica_anno

	FROM Impianto_abbonamenti_mesi

	WHERE Id = enter_id; 



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemPeriodicMonitoringInsert`(

	system_id INT, 

	enter_year INT, 

	subscription_id INT,

	enter_month INT, 

	real_execution_date DATETIME, 

	theorical_execution_date DATETIME, 

	report_id INT, 

	report_year INT, 

	price DECIMAL(11,2), 

	notes TEXT,

	OUT insertId INT, 

	OUT Result INT

)
BEGIN



	SELECT Id_Impianto

		INTO

		Result 

	FROM Impianto 

	WHERE Id_impianto = system_id;

	

	



	IF Result THEN  

		

		SELECT Id_Impianto

			INTO

				Result 

		FROM Impianto_abbonamenti 

		WHERE Id_impianto = system_id AND Anno = enter_year 

			AND Id_abbonamenti = subscription_id;

		

	ELSE

	

		SET Result = -2; 
				

	END IF; 

	

	

	

	IF Result THEN  

		

		SELECT Id_Impianto

			INTO

				Result 

		FROM Impianto_abbonamenti_mesi

		WHERE  impianto = system_id AND Anno = enter_year 

			AND mesi = enter_month ;

		

	ELSE

		SET Result = -3; 
	END IF; 

	

	

	IF Result THEN

	

		SET Result = -1; 
	

	ELSE

		SET Result = 1; 

	 

	END IF; 

	

	IF Result THEN 

		IF report_year <> 0 AND report_id <> 0  THEN  

			

			SELECT Id_Rapporto

				INTO

					Result 

			FROM rapporto 

			WHERE Id_rapporto = report_id AND anno_Rapporto = report_id;

			

				

			IF NOT Result THEN

				SET Result = -4; 
			END IF; 

				

		END IF; 

	END IF; 	



	



	

	

	IF Result THEN

	

		INSERT INTO impianto_abbonamenti_mesi 

		SET 	impianto = system_id, 

				anno = enter_year,

				mese = enter_month,

				abbonamenti = subscription_id,

				eseguito_il = real_execution_date, 

				da_eseguire = theorical_execution_date, 

				id_rapp = report_id, 

				anno_rapp = report_year, 

				prezzo = price, 

				nota_mese = notes,

				modifica_mese = 0, 

				modifica_anno = 0; 

		

				

		SET InsertId = LAST_INSERT_ID();

		

		

		IF InsertId THEN

			SET Result = 1;

			

		ELSE

			SET Result = 0; 

		END IF; 

		

	END IF; 

	

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesSystemPeriodicMonitoringUpdate`(

	system_id INT,

	enter_year INT, 

	subscription_id INT,

	enter_month INT, 

	real_execution_date DATETIME, 

	theorical_execution_date DATETIME, 

	report_id INT, 

	report_year INT, 

	price DECIMAL(11,2), 

	notes TEXT,

	enter_id INT, 

	OUT Result INT

)
BEGIN



	SELECT Id_Impianto

		INTO

		Result 

	FROM Impianto 

	WHERE Id_impianto = system_id;

	

	



	IF Result THEN  

		

		SELECT Id_Impianto

			INTO

				Result 

		FROM Impianto_abbonamenti 

		WHERE Id_impianto = system_id AND Anno = enter_year 

			AND Id_abbonamenti = subscription_id;

		

	ELSE

		SET Result = -2; 
	END IF; 

	

	

	

	IF Result THEN  

		

		SELECT Id

			INTO

				Result 

		FROM Impianto_abbonamenti_mesi

		WHERE  Id = enter_id ;

	ELSE

		SET Result = -3; 
	END IF; 

	

	

	IF Result THEN

		IF report_year <> 0 AND report_id <> 0 THEN  

			

			SELECT Id_Rapporto

				INTO

					Result 

			FROM rapporto 

			WHERE Id_rapporto = report_id AND anno_Rapporto = report_id;



		END IF; 

		

		IF NOT Result THEN

			SET Result = -4; 
		END IF; 

				

				

	ELSE

		SET Result = -5; 
	END IF;  



	

	IF Result THEN

	

		UPDATE impianto_abbonamenti_mesi 

		SET 	impianto = system_id, 

				anno = enter_year,

				mese = enter_month,

				abbonamenti = subscription_id,

				eseguito_il = real_execution_date, 

				da_eseguire = theorical_execution_date, 

				id_rapp = report_id, 

				anno_rapp = report_year, 

				prezzo = price, 

				nota_mese = notes,

				modifica_mese = 0, 

				modifica_anno = 0

		WHERE Id = Enter_id;

		

		

				

		

		IF InsertId THEN

			SET Result = 1;

			

		ELSE

			SET Result = 0; 

		END IF;  

		

	END IF; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesTabletConfigurationGetLastInsert`( 

)
BEGIN

      

SELECT

	Id_tablet, 

	IFNULL(mail, "") AS mail, 

	IFNULL(testo_mail, "") AS testo_mail, 

	IFNULL(Host, "") AS host, 

	IFNULL(Password, "") AS Password, 

	IFNULL(porta, 0) AS Porta, 

	IFNULL(Username, "") AS Username, 

	IFNULL(DIsplay_name, "") AS Display_name, 

	IFNULL(Data_ins, Data_Mod) AS Data_ins,

	Data_Mod

FROM tablet_configurazione ORDER BY id_tablet DESC LIMIT 1; 

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesTabletConfigurationInsert`( 

	email_sender VARCHAR(100),

	email_body TEXT,

	email_host VARCHAR(50), 

	email_port INT, 

	email_display_name VARCHAR(30), 

	email_username VARCHAR(45), 

	email_password VARCHAR(45)	,

	OUT result BIT

)
BEGIN



	SET result = 1; 

	

   INSERT INTO tablet_configurazione 

   	SET mail = email_sender, 

   	username = email_username,

   	password = email_password, 

   	host = email_host, 

   	porta = email_port, 

   	testo_mail = email_body, 

   	display_name =  email_display_name, 

   	Data_ins = CURDATE(); 

   

   SELECT ROW_COUNT() INTO result; 

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesTicketGet`( )
BEGIN

        



	SELECT 

		Id,

		Id_ticket, 

		Anno,

		IFNULL(Id_impianto, 0) AS id_impianto, 

		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,

		IFNULL(Id_cliente, 0) AS Id_cliente, 

		IFNULL(Descrizione, "") AS Descrizione, 

		IFNULL(Causale, 0) As Causale, 

		IFNULL(Urgenza, 0) AS Urgenza, 

		IFNULL(intervento, 0) As Intervento, 

		IFNULL(comunicazione, 0) AS comunicazione, 

		IFNULL(id_destinazione, 0) AS Id_destinazione,  

		IFNULL(sede_principale, 0) AS sede_principale, 

		IFNULL(stato_ticket, 0) AS stato_ticket, 

		IFNULL(tempo, 0) As Tempo, 

		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,

		IFNULL(id_utente, 0) AS Id_utente, 

		IFNULL(stampato, 0) As Stampato, 

		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,

		IFNULL(num_tick, 0) As num_tick,

		IFNULL(inviato, 0) As inviato,

		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		

	FROM Ticket;  

		

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesTicketGetById`( 

  ticketid INT

)
BEGIN

        



	SELECT 

		Id,

		Id_ticket, 

		Anno,

		IFNULL(Id_impianto, 0) AS id_impianto, 

		CAST(IFNULL(data_ora, '1970-01-01') AS DATETIME) As data_ora,

		IFNULL(Id_cliente, 0) AS Id_cliente, 

		IFNULL(Descrizione, "") AS Descrizione, 

		IFNULL(Causale, 0) As Causale, 

		IFNULL(Urgenza, 0) AS Urgenza, 

		IFNULL(intervento, 0) As Intervento, 

		IFNULL(comunicazione, 0) AS comunicazione, 

		IFNULL(id_destinazione, 0) AS Id_destinazione,  

		IFNULL(sede_principale, 0) AS sede_principale, 

		IFNULL(stato_ticket, 0) AS stato_ticket, 

		IFNULL(tempo, 0) As Tempo, 

		CAST(IFNULL(scadenza, '1970-01-01') AS DATETIME) AS scadenza,

		IFNULL(id_utente, 0) AS Id_utente, 

		IFNULL(stampato, 0) As Stampato, 

		CAST(IFNULL(data_ticket, '1970-01-01') AS DATETIME) AS data_ticket,

		IFNULL(num_tick, 0) As num_tick,

		IFNULL(inviato, 0) As inviato,

		CAST(IFNULL(data_promemoria, '1970-01-01') AS DATETIME) AS data_promemoria		

	FROM Ticket

	WHERE (Id = ticketid); 

		

			

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesUserGet`()
BEGIN

SELECT 



		id_utente, 

		Nome, 

		password,

		IFNULL(Descrizione,"") as descrizione,

		IFNULL(mail, "") AS mail, 

		IFNULL(Firma,"") as firma, 

		calendario,  

		IFNULL(smtp, "") as smtp, 

		IFNULL(porta, "0") as porta, 

		IFNULL(mssl, "") as mssl,

		IFNULL(nome_utente_mail, "") as nome_utente_mail,

		IFNULL(password_mail, "") as password_mail, 

		tipo_utente, 

		conferma, 

		salt

		

	  

		FROM utente;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesUserGetById`(

user_id INT)
BEGIN

SELECT 



		id_utente, 

		Nome, 

		password,

		IFNULL(Descrizione,"") as descrizione,

		IFNULL(mail, "") as mail, 

		IFNULL(Firma,"") as firma, 

		calendario,  

		IFNULL(smtp, "") as smtp, 

		IFNULL(porta, "0") as porta, 

		IFNULL(mssl, "") as mssl,

		IFNULL(nome_utente_mail, "") as nome_utente_mail,

		IFNULL(password_mail, "") as password_mail, 

		tipo_utente, 

		conferma, 

		salt

		

	  

		FROM utente

		WHERE id_utente = user_id;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ariesUserLogin`(IN `username` VARCHAR(50), IN `pass` VARCHAR(50), OUT `userId` INT)
BEGIN

	DECLARE company_id INT; 

	

	SELECT id_utente 

	INTO userId 

	FROM utente

	WHERE nome = username 

		AND password = CONVERT(SHA1(CONCAT(pass, salt)) USING latin1);

		

	SET userId = IFNULL(userId, 0);

	

	SELECT Id_azienda INTO company_id

	FROM azienda  

	ORDER BY id_azienda DESC

	LIMIT 1;

	

	

	SET @USER_ID = userId; 

	SET @COMPANY_ID = IFNULL(company_id, 0);

	

END ;;
DELIMITER ;


DELIMITER ;;
CREATE  PROCEDURE `sp_ddtGetPrintInformationsToBeBilled`(

	ddtYear SMALLINT, OUT ddtsNumbers MEDIUMINT, OUT ddtsTotalPrice DECIMAL(11,2), OUT ddtsTotalCost DECIMAL(11,2))
BEGIN



	SELECT 

		ddt.id_ddt AS "DdtId", 

		data_documento AS "Date", 

		clienti.ragione_sociale AS "CompanyName",

		causale_trasporto.causale AS "CausalTransport", 

		IFNULL(CONCAT(b1.cap," - ",b1.nome,"(", b.provincia,")"), "") AS "Municipality",  

		IFNULL(ddt.fattura, "") AS "InvoiceId",

		IFNULL(impianto.descrizione, "") AS "SystemDescription", 

		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalPrice, 

		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2)) AS TotalCost

	FROM ddt

		LEFT JOIN causale_trasporto ON ddt.causale=id_causale

		INNER JOIN clienti ON clienti.id_cliente=ddt.id_cliente

		LEFT JOIN destinazione_cliente AS b ON b.id_cliente=ddt.id_cliente AND b.id_destinazione=ddt.id_destinazione

		LEFT JOIN comune AS b1 ON b1.id_comune=b.comune

		LEFT JOIN impianto ON id_impianto=impianto

		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno

	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno)

	GROUP BY ddt.Id_ddt, ddt.anno

	ORDER BY ddt.anno DESC, ddt.Id_ddt; 

	

	SELECT COUNT(ddt.id_ddt),

		CAST(IFNULL(SUM(prezzo*quantità-(prezzo*quantità/100*sconto)),2) AS DECIMAL(11,2)), 

		CAST(IFNULL(SUM(costo*quantità-(costo*quantità/100*sconto)),2) AS DECIMAL(11,2))

		INTO 

		ddtsNumbers,

		ddtsTotalPrice,

		ddtsTotalCost

	FROM ddt

		LEFT JOIN articoli_ddt ON articoli_ddt.id_ddt=ddt.id_ddt AND articoli_ddt.anno=ddt.anno

	WHERE (ddt.Stato = 1 OR (ddt.Stato=3 AND ddt.fattura IS NULL)) AND ddt.anno = IF(ddtYear, ddtYear, ddt.anno);

			



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ddtInsert`(

	ddtId INT, ddtYear INT, ddtDate DATE, aspect SMALLINT, personId INT, isCustomer BOOL, 

	destinationId INT, paymentCondition INT, deliveryCare INT, deliveryCompany INT, 

	deliveryMethod INT, timestampStart TIMESTAMP, timestampEnd TIMESTAMP, causalId VARCHAR(10),

	amount INT, note TEXT, description TEXT, mainId INT, systemId INT, 

	weight DECIMAL(11,2), printHours BOOL, OUT ddtInsertResult INT)
BEGIN

	

	DECLARE ddtStatusResult INT DEFAULT 0;

	SET ddtInsertResult = -1;

	

	IF IFNULL(ddtId, 0) <= 0 THEN

		SELECT IFNULL(MAX(id_ddt), 0) + 1

		INTO ddtId

		FROM ddt

		WHERE ddt.anno = ddtYear;

	END IF;

	

	IF (SELECT COUNT(*) FROM ddt WHERE id_ddt = ddtId AND anno = ddtYear) <= 0 THEN

	

		SET ddtYear = IFNULL(ddtYear, YEAR(CURRENT_DATE));

		SET timestampStart = IFNULL(timestampStart, CURRENT_TIMESTAMP);

		SET ddtDate = IFNULL(ddtDate, CURRENT_DATE);

		SET amount = IFNULL(amount, 0);

		

		INSERT INTO ddt SET

			id_utente = @USER_ID,

			id_ddt = ddtId,

			anno = ddtYear,

			condizione_pagamento = paymentCondition,

			trasport_a_cura = deliveryCare,

			vettore = deliveryCompany,

			data_ora_ritiro = timestampEnd,

			data_ora_inizio = timestampStart,

			porto_resa = deliveryMethod,

			data_documento = ddtDate,

			causale = causalId,

			colli = amount,

			nota = note,

			descrizione = description,

			impianto = systemId,

			peso = weight,

			stampa_ora = printHours;

			

		IF isCustomer THEN

			UPDATE ddt SET 

				id_cliente = personId,

				id_destinazione = destinationId,

				id_principale = mainId

			WHERE id_ddt = ddtId

				AND anno = ddtYear;

		ELSE

			UPDATE ddt SET

				id_fornitore = personId,

				principale_forn = mainId , 

				destinazione_forn = destinationId

			WHERE id_ddt = ddtId

				AND anno = ddtYear;

		END IF;

		

		
		

		IF aspect & 1 THEN 
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "ar");

		END IF;

		IF aspect & 2 THEN 
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "av");

		END IF;

		IF aspect & 4 THEN 
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "ma");

		END IF;

		IF aspect & 8 THEN 
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "sc");

		END IF;

		IF aspect & 16 THEN 
			INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES(ddtId, ddtYear, "sn");

		END IF;

		

		
		SET ddtInsertResult = ddtId;

	

	END IF;

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_ddtUpdate`(

	newDdtId INT, newDdtYear INT, oldDdtId INT, oldDdtYear INT,ddtDate DATE, aspect SMALLINT, personId INT, isCustomer BOOL, 

	destinationId INT, paymentCondition INT, deliveryCare INT, deliveryCompany INT, 

	deliveryMethod INT, timestampStart TIMESTAMP, timestampEnd TIMESTAMP, causalId VARCHAR(10),

	amount INT, note TEXT, description TEXT, mainId INT, systemId INT, 

	weight DECIMAL(11,2), printHours BOOL, OUT ddtUpdateResult INT)
BEGIN

	

	DECLARE ddtStatusResult INT DEFAULT 0;

	SET ddtUpdateResult = -1;

	

	SET newDdtYear = IFNULL(newDdtYear, YEAR(CURRENT_DATE));

	SET timestampStart = IFNULL(timestampStart, CURRENT_TIMESTAMP);

	SET ddtDate = IFNULL(ddtDate, CURRENT_DATE);

	SET amount = IFNULL(amount, 0);

	

	UPDATE ddt SET

		id_ddt = newDdtId,

		anno = newDdtYear,

		id_cliente = NULL,

		id_destinazione = NULL,

		id_principale = NULL,

		id_fornitore = NULL,

		principale_forn = NULL, 

		destinazione_forn = NULL, 

		condizione_pagamento = paymentCondition,

		trasport_a_cura = deliveryCare,

		vettore = deliveryCompany,

		data_ora_ritiro = timestampEnd,

		data_ora_inizio = timestampStart,

		porto_resa = deliveryMethod,

		data_documento = ddtDate,

		causale = causalId,

		colli = amount,

		nota = note,

		descrizione = description,

		impianto = systemId,

		peso = weight,

		stampa_ora = printHours

	WHERE id_ddt = oldDdtId 

		AND anno = oldDdtYear;

		

	IF ROW_COUNT() > 0 THEN

		SET ddtUpdateResult = newDdtId;

	END IF;



	IF isCustomer THEN

		UPDATE ddt SET 

			id_cliente = personId,

			id_destinazione = destinationId,

			id_principale = mainId

		WHERE id_ddt = newDdtId

			AND anno = newDdtYear;

	ELSE

		UPDATE ddt SET

			id_fornitore = personId,

				principale_forn = mainId , 

				destinazione_forn = destinationId

		WHERE id_ddt = newDdtId

			AND anno = newDdtYear;

	END IF;

	

	
	

	DELETE FROM ddt_aspetto 

	WHERE id_ddt = oldDdtId

		AND anno = oldDdtYear;

	

	IF aspect & 1 THEN 
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "ar");

	END IF;

	IF aspect & 2 THEN 
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "av");

	END IF;

	IF aspect & 4 THEN 
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "ma");

	END IF;

	IF aspect & 8 THEN 
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "sc");

	END IF;

	IF aspect & 16 THEN 
		INSERT INTO ddt_aspetto(id_ddt, anno, vista) VALUES (newDdtId, newDdtYear, "sn");

	END IF;

	

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `sp_getInvoicePeriodicTotals`(

	IN AnnoFatture INT,

	IN MeseFatture INT,

	OUT FatturaPrezzoNetto DECIMAL(11,2),

	OUT FatturaPrezzoLordo DECIMAL(11,2),

	OUT FatturaPrezzoIva DECIMAL(11,2),

	OUT FatturaCosto DECIMAL(11,2),

	OUT PrefatturaPrezzoLordo DECIMAL(11,2),

	OUT PrefatturaCosto DECIMAL(11,2),

	OUT TotalePrezzoLordo DECIMAL(11,2),

	OUT TotaleCosto DECIMAL(11,2)

)
BEGIN



	SELECT

		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità), 2), 

		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 

		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva / 100), 2), 

		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)

	INTO

		FatturaPrezzoNetto,

		FatturaCosto,

		FatturaPrezzoIva,

		FatturaPrezzoLordo

	FROM fattura_articoli fa 

		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 

			AND f.anno = fa.anno 

	WHERE f.anno = AnnoFatture

		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);

		

	SELECT

		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 

		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)

	INTO

		PrefatturaCosto,

		PrefatturaPrezzoLordo

	FROM fattura_articoli fa 

		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 

			AND f.anno = fa.anno 

	WHERE f.anno = 0

		AND YEAR(f.data) = AnnoFatture

		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);

		

	SELECT

		ROUND(SUM(ROUND(costo, 2) * quantità), 2), 

		ROUND(SUM(ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità + ROUND(prezzo_unitario * (100-sconto) / 100, 2) * quantità * iva/100), 2)

	INTO

		TotaleCosto,

		TotalePrezzoLordo

	FROM fattura_articoli fa 

		LEFT JOIN fattura f ON fa.id_fattura = f.id_fattura 

			AND f.anno = fa.anno 

	WHERE YEAR(f.data) = AnnoFatture

		AND IF(MeseFatture > 0, MONTH(f.data) = MeseFatture, TRUE);

		

	SET FatturaPrezzoNetto = IFNULL(FatturaPrezzoNetto, 0);

	SET FatturaPrezzoLordo = IFNULL(FatturaPrezzoLordo, 0);

	SET FatturaPrezzoIva = IFNULL(FatturaPrezzoIva, 0);

	SET FatturaCosto = IFNULL(FatturaCosto, 0);

	SET PrefatturaPrezzoLordo = IFNULL(PrefatturaPrezzoLordo, 0);

	SET PrefatturaCosto = IFNULL(PrefatturaCosto, 0);

	SET TotalePrezzoLordo = IFNULL(TotalePrezzoLordo, 0);

	SET TotaleCosto = IFNULL(TotaleCosto, 0);

	

END ;;
DELIMITER ;


DELIMITER ;;
CREATE PROCEDURE `sp_getTokenID`(id_utente INT, deadline DATETIME,

        OUT id_token INT)
BEGIN



  INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);

  SELECT LAST_INSERT_ID() INTO id_token;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `sp_mobileAddTechnicianGPSCoordinates`(IN `MACAddress` VARCHAR(17), IN `Latitude` DOUBLE, IN `Longitude` DOUBLE, IN `DetectionDate` DATETIME, IN `DetectionSource` TINYINT, OUT `SuccessfullInsert` BIT)
BEGIN

	DECLARE TabletId INT;

	SELECT Id INTO TabletId FROM Tablet WHERE tablet.mec_address=MACAddress;

	IF TabletId IS NULL

	THEN

		SELECT 0 INTO SuccessfullInsert;

	ELSE

		INSERT INTO tablet_posizioni (id_tablet, posizione, Data_Rilevazione, Sorgente_Rilevazione) 

			VALUES (TabletId,POINT(Latitude, Longitude), DetectionDate, DetectionSource);

		SELECT ROW_COUNT() INTO SuccessfullInsert;

	END IF;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `sp_mobileGetAriesCallInformations`(IN `DateLastExecution` DATETIME)
BEGIN



	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscribers;

	CREATE TEMPORARY TABLE TempCustomerSubscribers 

		SELECT c.id_cliente AS IDCostumer,

			c.ragione_sociale AS CompanyName, 

			IF(ia.id_impianto IS NOT NULL, true, false) AS IsSubscriber

		FROM clienti AS c

			INNER JOIN impianto AS i ON i.id_cliente = c.id_cliente

			LEFT JOIN impianto_abbonamenti AS ia ON ia.anno = YEAR(CURDATE()) 

				AND ia.data_ultima_modifica >= DateLastExecution

			AND i.id_impianto = ia.id_impianto

				

		GROUP BY C.ID_Cliente;

	

	DROP TEMPORARY TABLE IF EXISTS TempCustomerSubscriberUnsolved;

	CREATE TEMPORARY TABLE TempCustomerSubscriberUnsolved 

		SELECT c.id_cliente AS IDCostumer, 

			c.ragione_sociale AS CompanyName,

			IF(vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL, TRUE, FALSE) AS IsUnsolved,

			IF(IsSubscriber = TRUE, TRUE, FALSE) AS IsSubscriber

		FROM clienti AS c

			LEFT JOIN vw_mobileinvoicesoutstanding ON vw_mobileinvoicesoutstanding.id_cliente = c.id_cliente

			LEFT JOIN TempCustomerSubscribers ON TempCustomerSubscribers.idcostumer = c.id_cliente

		WHERE vw_mobileinvoicesoutstanding.id_cliente IS NOT NULL 

			OR TempCustomerSubscribers.idcostumer IS NOT NULL;

	

	SELECT CompanyName,

		riferimento_clienti.Nome AS ReferenceType,

		IsUnsolved,

		IsSubscriber,

		Telefono AS Phone, 

		Altro_Telefono AS MobilePhone 

	FROM TempCustomerSubscriberUnsolved 

		INNER JOIN Riferimento_Clienti ON idcostumer = id_cliente

			AND Riferimento_Clienti.`mod` >= DateLastExecution 

	WHERE ((Telefono IS NOT NULL AND telefono <> '')

		OR (altro_telefono IS NOT NULL AND altro_telefono <> ''));



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_onDdtDeterminingStatus`(

	ddtId INT, ddtYear INT, source VARCHAR(20), OUT status INT)
BEGIN



	DECLARE DDT_STATUS_OPEN INT DEFAULT 1; 

	DECLARE DDT_STATUS_PARTIAL INT DEFAULT 2;

	DECLARE DDT_STATUS_CLOSED INT DEFAULT 3;

	DECLARE res INT;



	

	SET status = NULL;

	



	IF source = 'INSERT' THEN

		SET status = DDT_STATUS_OPEN;

	END IF;

	

	IF source = 'UPDATE' THEN 

	

		SELECT id_cliente IS NOT NULL 

		INTO res

		FROM ddt

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

			

		if res THEN

		

			SELECT DDT_STATUS_CLOSED

			INTO status

			FROM DDT 

			WHERE id_ddt = ddtId

				AND anno = ddtYear 

				AND Fattura IS NOT NULL;

			

		END IF; 

		

	END IF; 

	



	

	
	
	IF source LIKE '%INVOICE' AND NOT source LIKE '%SUPPLIER%' THEN

		IF source LIKE 'ASSOC%' THEN

			SET status = DDT_STATUS_CLOSED;

		ELSEIF source LIKE 'DISSOC%' THEN

			SET status = DDT_STATUS_OPEN;

		END IF;

	END IF;

	

	

	IF source LIKE '%JOB' THEN

		IF source LIKE 'ASSOC%' THEN

			SET status = DDT_STATUS_CLOSED;

		ELSEIF source LIKE 'DISSOC%' THEN

			SET status = DDT_STATUS_OPEN;

		END IF;

	END IF;



	

	
	SELECT (causale_trasporto.garanzia = 2)

	INTO res

	FROM ddt

		LEFT JOIN causale_trasporto ON causale_trasporto.Id_causale = ddt.Causale

	WHERE ddt.id_ddt = ddtId

		AND ddt.anno = ddtYear;

	

	IF res THEN

		SET status = DDT_STATUS_CLOSED;

	END IF;



	
	
	
	

	SELECT id_fornitore IS NOT NULL 

	INTO res

	FROM ddt

	WHERE id_ddt = ddtId

		AND anno = ddtYear;

	

	IF res THEN 


		DROP TABLE IF EXISTS tmp_ddt_det_status;

		CREATE TEMPORARY TABLE tmp_ddt_det_status

		(

			id_articolo VARCHAR(11) PRIMARY KEY, 

			ddt_quantity DECIMAL(11,2), 

			supplier_quantity DECIMAL(11,2)

		);  

				

		INSERT INTO tmp_ddt_det_status	

		SELECT  de.Id_articolo, 

		  SUM(de.quantità), 

		  SUM(dr.quantità)

		
		FROM articoli_ddt de

			INNER JOIN articoli_ddt_ricevuti dr 

				ON de.id_ddt = dr.id_rif

				AND de.anno = dr.anno_rif

				AND de.Id_articolo = dr.id_articolo

				AND dr.tipo = '+'

		WHERE de.id_articolo IS NOT NULL

			AND de.id_ddt = ddtId

			AND de.anno = ddtYear

		GROUP BY de.Id_articolo;

		

		

		INSERT INTO tmp_ddt_det_status

		SELECT de.Id_articolo, 

		  SUM(de.quantità), 

		  SUM(ff.quantità) as "ff_sum"

		FROM articoli_ddt de

			INNER JOIN fornfattura_articoli ff 

				ON de.id_ddt = ff.id_rif

				AND de.anno = ff.anno_rif

				AND de.Id_articolo = ff.id_materiale

				AND ff.tipo = '+'

		WHERE de.id_articolo IS NOT NULL

			AND de.id_ddt = ddtId

			AND de.anno = ddtYear

		GROUP BY de.Id_articolo

		ON DUPLICATE KEY UPDATE 

			supplier_quantity=supplier_quantity + VALUES(supplier_quantity);

			

				

		SELECT COUNT(*) 

		INTO res

		FROM tmp_ddt_det_status

		WHERE supplier_quantity<ddt_quantity; 

		

		

		IF IFNULL(res , 0) = 0  THEN 

		

			SET status = DDT_STATUS_CLOSED; 

	

		ELSE 

			SELECT 

			IF(COUNT(*) = 0, 

				DDT_STATUS_OPEN,  
				DDT_STATUS_PARTIAL  
			) 

			INTO status 

			FROM tmp_ddt_det_status

			WHERE supplier_quantity != 0; 

		END IF;

	END IF;

	

	IF status IS NOT NULL THEN

		UPDATE ddt	

			SET stato = status

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

	END IF;

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_serverBackupSettingsGet`(

)
BEGIN

	

    SELECT id_impostazioni, 

	 	valore 

    FROM impostazioni_backup; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_serverParhConfigurationGet`(

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_serverParhConfigurationGetByKey`(

	path_type VARCHAR(50)

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi

	 WHERE tipo_percorso = path_type; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_serverPathConfigurationGetByKey`(

	path_type VARCHAR(50)

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi

	 WHERE tipo_percorso = path_type; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_serverReportMobileInterventionProductGetForPrint`(

	id MEDIUMINT,

	`year` SMALLINT

)
BEGIN

	

    SELECT descrizione as "nome_materiale",

		CONCAT("", quantita,"") as "quantita" 

    FROM rapporto_mobile_materiale

    WHERE id_rapporto = id

		AND anno_rapporto = `year` 

    ORDER BY descrizione 

    LIMIT 7; 

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_splitArray`(serializedArray VARCHAR(1024))
BEGIN



	SET @stmt = CONCAT("INSERT INTO splitArrayData(array_values) VALUES", serializedArray, ";");

	

	DROP TEMPORARY TABLE IF EXISTS splitArrayData;

	CREATE TEMPORARY TABLE splitArrayData (

		array_index INT NOT NULL AUTO_INCREMENT PRIMARY KEY,

		array_values VARCHAR(64) NOT NULL DEFAULT ""

	) ENGINE = innoDB;

	

	PREPARE sttmnt FROM @stmt;

	EXECUTE sttmnt;

	DEALLOCATE PREPARE sttmnt;

	

	SET @stmt = "";

	

	SELECT array_values FROM splitArrayData;

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_tknGetIDToken`(IN `id_utente` INT, IN `deadline` DATETIME, OUT `id_token` INT)
BEGIN



  INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);

  SELECT LAST_INSERT_ID() INTO id_token;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_tknRefreshTokenExists`(IN `id_token` INT, OUT `FlagFind` BOOL)
BEGIN

  SET @rowno = 0;

  SELECT @rowno=@rowno+1, id_token FROM TokenRefresh WHERE TokenRefresh.id_token=id_token;

  IF @rowno = 0 then

    SET FlagFind=false;

  ELSE

    DELETE FROM TokenRefresh Where TokenRefresh.id_token=id_token;

    SET FlagFind=true;

  end if;



END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_tmp`()
BEGIN



	UPDATE ddt SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE articoli_ddt SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE ddt_aspetto SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE riferimento_sn_ddt_kit SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_acconto SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_articoli SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_pagamenti SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_pagamenti_comunicazione SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_studi SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	UPDATE fattura_pa SET ANNO = SUBSTRING(ANNO,3,2) WHERE LENGTH(ANNO) = 4;

	

	DELETE FROM ddt WHERE LENGTH(ANNO) > 4;

	DELETE FROM articoli_ddt WHERE LENGTH(ANNO) > 4;

	DELETE FROM ddt_aspetto WHERE LENGTH(ANNO) > 4;

	DELETE FROM riferimento_sn_ddt_kit WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_acconto WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_articoli WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_pagamenti WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_pagamenti_comunicazione WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_studi WHERE LENGTH(ANNO) > 4;

	DELETE FROM fattura_pa WHERE LENGTH(ANNO) > 4;

	

	DELETE FROM ddt WHERE LENGTH(ID_ddt) > 4;

	DELETE FROM articoli_ddt WHERE LENGTH(ID_ddt) > 4;

	DELETE FROM ddt_aspetto WHERE LENGTH(ID_ddt) > 4;

	DELETE FROM riferimento_sn_ddt_kit WHERE LENGTH(id_ddt) > 4;

	DELETE FROM fattura WHERE LENGTH(id_fattura) > 4;

	DELETE FROM fattura_acconto WHERE LENGTH(id_fattura) > 4;

	DELETE FROM fattura_articoli WHERE LENGTH(id_fattura) > 4;

	DELETE FROM fattura_pagamenti WHERE LENGTH(id_fattura) > 4;

	DELETE FROM fattura_pagamenti_comunicazione WHERE LENGTH(id_fattura) >4;

	DELETE FROM fattura_studi WHERE LENGTH(id_fattura) > 4;

	DELETE FROM fattura_pa WHERE LENGTH(id_fattura) > 4;





END ;;
DELIMITER ;

DELIMITER ;;
CREATE  PROCEDURE `sp_userInsert`(

	userName VARCHAR(60) , userPassword VARCHAR(60), description TEXT, email VARCHAR(100),

	emailSignature TEXT, calendar INT(11), smtp VARCHAR(45), port VARCHAR (45),

	emailUsername VARCHAR(45), emailPassword VARCHAR(45), userType TINYINT(4), 

	emailRequestConfirm BIT, emailUseSSL BIT, OUT userId INT)
BEGIN



	DECLARE allowInsert TINYINT DEFAULT 1; 



	DECLARE _salt CHAR(8) DEFAULT CAST(LEFT(SHA1(FLOOR(RAND() * POW(2, 32))), 8) AS CHAR(8) CHARACTER SET latin1);

	

	SET allowInsert = CONCAT(userName, userPassword) IS NOT NULL;

	SET userId = 0;

	

	SET emailRequestConfirm = IFNULL(emailRequestConfirm, 0);

	SET emailUseSSL = IFNULL(emailUseSSL, 0);

	

	IF allowInsert THEN

	

		SET userPassword = CAST(SHA1(CONCAT(userPassword, _salt)) AS CHAR(40) CHARACTER SET latin1);

	

		INSERT INTO utente SET 

			`nome` = userName, 

			`password`= userPassword, 

			`descrizione` = description, 

			`mail` = email,

			`firma` = emailSignature,

			`calendario` = calendar,

			`smtp` = smtp,

			`porta` = port,

			`nome_utente_mail` = emailUsername,

			`password_mail` = emailPassword,

			`tipo_utente` = userType,

			`mssl` = emailUseSSL,

			`conferma` = emailRequestConfirm,

			`salt` = _salt;

		

		SELECT LAST_INSERT_ID() INTO userId;

		

	END IF;

	

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_usrGetIDByUsername`(IN `username` VARCHAR(60), OUT `id_utente` INT)
BEGIN

SELECT utente.id_utente INTO id_utente

FROM utente

WHERE utente.Nome = username;

END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE `sp_usrLogin`(IN username VARCHAR(60), IN password VARCHAR(60), OUT success BIT(1))
BEGIN

	SELECT COUNT(utente.id_utente) INTO success 

	FROM utente 

	WHERE utente.Nome = username 

		AND utente.Password = password;

END ;;
DELIMITER ;
