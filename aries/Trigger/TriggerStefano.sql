-- MySQL dump 10.13  Distrib 5.5.46, for Win64 (x86)
--
-- Host: localhost    Database: siantel
-- ------------------------------------------------------
-- Server version	5.5.46-log
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `modlist` BEFORE UPDATE ON `articolo_listino` FOR EACH ROW begin

if new.prezzo<>old.prezzo then

insert into articolo_listino_prezzo (id_Articolo,id_listino,prezzo,data_inizio,data_fine)values

(new.id_articolo,new.id_listino,old.prezzo,old.data_inizio,new.data_inizio);

end if;



end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `furg_ins_mag` BEFORE INSERT ON `automezzo` FOR EACH ROW begin

  insert into tipo_magazzino set nome = new.modello, descrizione = null, prior = 2, id_master = null, reso = null;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `furg_mod_mag` BEFORE UPDATE ON `automezzo` FOR EACH ROW begin

  update tipo_magazzino set nome = new.modello where id_tipo = new.id_magazzino;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_ddt` BEFORE DELETE ON `ddt` FOR EACH ROW begin

delete from articolI_ddt where id_ddt=old.id_ddt and anno=old.anno;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_ddt_ric` BEFORE DELETE ON `ddt_ricevuti` FOR EACH ROW delete from articolI_ddt_ricevuti

where id_ddt=old.id_ddt and anno=old.anno */;;
DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_contro` AFTER INSERT ON `impianto_abbonamenti_mesi` FOR EACH ROW begin

if (select max(anno) from impianto_abbonamenti where id_impianto=new.impianto limit 1 )<=new.anno  then

update impianto set costo_manutenzione=(Select if(new.prezzo is not null,new.prezzo,manutenzione) from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.impianto)

  where new.impianto=id_Impianto;

end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_contro` AFTER UPDATE ON `impianto_abbonamenti_mesi` FOR EACH ROW begin

if (select max(anno) from impianto_abbonamenti where id_impianto=new.impianto limit 1 )<=new.anno  then





    update impianto set costo_manutenzione=(Select if(new.prezzo is not null,new.prezzo,manutenzione) from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.impianto)





  where new.impianto=impianto.id_Impianto;







end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_abbo_imp` AFTER INSERT ON `impianto_uscita` FOR EACH ROW begin

if (select max(anno) from impianto_uscita where id_impianto=new.id_impianto) <=new.anno  then

update impianto set costo_manutenzione=(Select new.manutenzione from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.id_impianto) where impianto.id_impianto=new.id_impianto;

end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_abbo_imp` AFTER UPDATE ON `impianto_uscita` FOR EACH ROW begin

if (select max(anno) from impianto_uscita where id_impianto=new.id_impianto) <=new.anno  then

update impianto set costo_manutenzione=(Select new.manutenzione from impianto_uscita where anno=New.anno and impianto_uscita.id_impianto=new.id_impianto) where impianto.id_impianto=new.id_impianto;

end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_art_lis` AFTER DELETE ON `lista_articoli` FOR EACH ROW begin





delete from magazzino_operazione where id_operazione=(Select id_operazione_del from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab);

delete from magazzino_operazione where id_operazione=(Select id_operazione_ins from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab);



delete from magazzino_liste where id_lista=old.id_lista and anno=old.anno and id_tab=old.numero_tab;





end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_lis` BEFORE DELETE ON `lista_prelievo` FOR EACH ROW begin

delete from lista_articoli where id_Lista=old.id_lista and anno=old.anno;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `insmarc` AFTER INSERT ON `marca` FOR EACH ROW begin

    insert into listino(nome)values(new.nome);

    insert into marca_listino (id_listino,id_marca) select id_listino,new.id_marca from listino where nome =new.nome;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `marca_list_del` BEFORE DELETE ON `marca` FOR EACH ROW begin



  delete from listino where listino.id_listino = (select id_listino from marca_listino where id_marca=old.id_marca);

  delete from marca_listino where marca_listino.id_marca = old.id_marca;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_note_mobile` AFTER DELETE ON `note_mobile` FOR EACH ROW BEGIN

        insert into note_mobile_old (id_cliente, ragione_sociale, desc_brev, id_impianto, id_articolo, id_nota_old, testo, tipo_nota, id_tecnico, id_utente, data)

                      values  (old.id_cliente, old.ragione_sociale, old.desc_brev, old.id_impianto, old.id_articolo, old.id_nota, old.testo, old.tipo_nota,old.id_tecnico, old.id_utente, old.data);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `del_rapp` BEFORE DELETE ON `rapporto` FOR EACH ROW delete from rapporto_materiale where id_rapporto=old.id_rapporto and anno=old.anno */;;
DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `ins_maga` AFTER INSERT ON `tipo_magazzino` FOR EACH ROW insert into causale_magazzino(nome,operazione,tipo_magazzino,reso)values(

concat(new.nome," CARICO"),1,new.id_TIPO,new.reso),

(

concat(new.nome," SCARICO"),2,new.id_TIPO,new.reso) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `mod_tipo_maga` AFTER UPDATE ON `tipo_magazzino` FOR EACH ROW begin

  update causale_magazzino set nome = if(causale_magazzino.operazione = 1,concat(new.nome," CARICO"),concat(new.nome," SCARICO")) where causale_magazzino.tipo_magazzino = new.id_tipo;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `CollaudoToRapporto`(ID INT, ANNOP INT)
BEGIN



  DECLARE  i INT;

  SET i=0;



    insert into rapporto_mobile

    (stato, scan, id_rapporto, anno,     id_impianto, id_destinazione, id_cliente, richiesto, email_invio, tipo_intervento, Diritto_chiamata, dir_ric_fatturato, relazione,  Note_Generali, `data`, data_esecuzione, festivo, su_chiamata, eff_giorn, sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, fuoriabbon, man_straord, tipo_impianto, ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, id_riferimento, mail_responsabile, appunti, tecnici, inviato, visionato, id_utente, numero, Nr_rapporto  )

    select

    "1", "1", id_collaudo_invio, anno,id_impianto, if(id_impianto is null, "1", (select destinazione from impianto where impianto.id_impianto=collaudo.id_impianto)), id_cliente, if(richiesto is null , "", richiesto) , mail, "7", "0","0", "Generato da Rapporto di Collaudo",note,  `data`,`data`, 0, 0,0,0,0,"",0,0,0,0,0,0,0, if(furto=1, "furto", if(incendio=1, "incendio",if(tvcc=1, "circuito chiuso",  "macro" ))), cliente, "","","","",id_riferimento,mail_responsabile, appunti, tecnici, 1, 0, id_utente, id_collaudo_invio, id_collaudo_invio from collaudo where id_collaudo_invio=ID and anno=ANNOP ;



    insert into rapporto_tecnico_mobile select id_collaudo_invio, anno, tecnici, "a contratto", 0,0,0, km , orespo1,0, "",null, null,oreint1, null, null,  0,"","",nviaggi from collaudo where id_collaudo_invio=ID and anno=ANNOP ;



  WHILE i<=6 DO

    insert into rapporto_materiali_mobile values (ID, ANNOP, i, "","");

    SET i=i+1;

  END WHILE;





END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `CreaBozza`(mittente INT,  id_utenteP int, OUT ID_MAILP INT)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `ricanni`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerContactGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerDestinationDaysToAvoidGet`()
BEGIN   

	SELECT id_destinazione,

		id_cliente, 

		id_giorno

	FROM destinazione_giorni; 	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerDestinationGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerDestinationGetById`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerDestinationGetBySystemId`(system_id INT)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiCustomerGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiEventEmployeeGet`()
BEGIN   

	SELECT Id, 

		Id_evento,

		id_operaio

	FROM Evento_operaio; 	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiEventGet`()
BEGIN

        

	SELECT Id,

		Oggetto, 

		Descrizione, 

		Id_riferimento, 

		id_tipo_evento, 

		Eseguito, 

		Data_esecuzione, 

		Ora_inizio_esecuzione, 

		Ora_fine_esecuzione, 

		Sveglia, 

		Data_sveglia,

		Data_ins, 

		Data_mod

	FROM Evento; 



	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiEventGetFromDate`(	from_date DATETIME )
BEGIN

        

	SELECT Id,

		Oggetto, 

		Descrizione, 

		Id_riferimento, 

		id_tipo_evento, 

		Eseguito, 

		Data_esecuzione, 

		Ora_inizio_esecuzione, 

		Ora_fine_esecuzione, 

		Sveglia, 

		Data_sveglia,

		Data_ins, 

		Data_mod

	FROM Evento

	WHERE IFNULL(Data_mod, Data_Ins) >= from_date; 



	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiEventTypeGet`()
BEGIN   

	SELECT id_tipo, 

			nome

	FROM Tipo_evento; 	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiInvoiceOpenedGet`()
BEGIN

	SELECT 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiProductGet`()
BEGIN

	SELECT codice_articolo,

		IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

		Desc_brev,

		Tempo_installazione,

		stato_articolo, 

		CAST(Data_inserimento as Datetime) Data_ins, 

		modifica, 

		unità_misura

	 FROM articolo ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiProductStatusGet`()
BEGIN

	SELECT id_stato, 

	nome, 

	bloccato

	FROM articolo_stato; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportGet`()
BEGIN

	SELECT Id_rapporto,

	anno, 

	Id_impianto, 

	id_destinazione, 

	id_cliente, 

	CAST(Data AS DATETIME) Data_esecuzione, 

	relazione, 

	note_generali

	FROM  rapporto

	WHERE id_impianto IS NOT NULL;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportGetIds`(quantity INT)
BEGIN



	DECLARE id_rapp INT;

	DECLARE id_rapp_mobile INT;

	DECLARE id_coll INT;

	

	DECLARE start_report_id INT;

	DECLARE counter INT;

	

	DECLARE current_year INT; 

	

	SET current_year = YEAR(CURDATE()); 

	SET counter = 0; 

	

	DROP TABLE IF EXISTS ReportIds;

	CREATE TEMPORARY TABLE ReportIds

	(

		id_rapporto INT, 

		anno INT

	);

	

	SELECT IFNULL(MAX(a.id_rapporto)+1, 1) INTO id_rapp 

	from rapporto as a 

	where anno=current_year;

	

	SELECT IFNULL(max(a.id_rapporto)+1, 1) INTO id_rapp_mobile 

	from rapporto_mobile as a 

	where anno=current_year;

	

	SELECT IFNULL(max(a.id_collaudo_invio)+1, 1) into id_coll 

	from collaudo as a 

	where anno=current_year;

	

	if id_rapp>id_rapp_mobile then

	 set start_report_id=id_rapp;

	else

	 set start_report_id=id_rapp_mobile;

	end if;

	

	if id_coll>start_report_id then

	 set start_report_id=id_coll;

	end if;

	

   WHILE(counter < quantity) DO

    INSERT INTO ReportIds VALUES (start_report_id + counter, current_year);

    SET counter = counter + 1; 

   END WHILE;



	INSERT INTO rapporto_mobile (id_rapporto, anno, diritto_chiamata, dir_ric_fatturato, festivo, su_chiamata, eff_giorn,sost, ripar, `not`, c_not, abbon, garanz, man_ordi, fuorigaranz, man_straord, tipo_impianto,ragione_sociale, indirizzo, citta, luogo_lavoro, difetto, inviato, visionato, fuoriabbon, id_tecnico)

	SELECT id_rapporto ,

			  anno, 

			  "0",

			  "0",

			  "0",

			  "0",

			  "0",

			  "0","0","0", "0","0","0","0","0","0","0","0","0","0","0","0","0",'1', 0 , 0 

	FROM ReportIds;



	SELECT id_rapporto, 

		anno

	FROM ReportIds; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionCancelInsertOperation`(

	id INT, 

	`year` INT

)
BEGIN	

	CALL sp_apiReportMobileInterventionProductDeleteByReport(id, `year`); 

	CALL sp_apiReportMobileInterventionTicketDeleteByReport(id, `year`); 

	CALL sp_apiReportMobileInterventionWorkDelete(id, `year`); 

	CALL sp_apiReportMobileInterventionDelete(id, `year`); 

	CALL sp_apiReportMobileInterventionTechnicianDelete(id, `year`); 

	CALL sp_apiReportMobileInterventionSignatureDeleteByReport(id, `year`); 

	

	INSERT INTO rapporto_mobile 

	(id_rapporto, anno, diritto_chiamata, dir_ric_fatturato, 

	festivo, su_chiamata, eff_giorn,sost, ripar, `not`, c_not, 

	abbon, garanz, man_ordi, fuorigaranz, man_straord, 

	tipo_impianto,ragione_sociale, indirizzo, citta, 

	luogo_lavoro, difetto, inviato, visionato)

	VALUES

	(id ,`year`, "0","0","0","0","0","0","0","0", "0","0","0","0","0","0","0","0","0","0","0","0","0",'1' );



	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionCheckExistence`(

	id INT, 

	`year` INT,

	OUT result BIT 

)
BEGIN

   	

	SELECT IFNULL(COUNT(id_rapporto),0)

	INTO

	result 

	FROM rapporto_mobile 

	WHERE id_rapporto= id AND anno = `year` AND inviato = 1; 



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionDelete`(

	id INT, 

	`year` INT

)
BEGIN

 	

	DELETE 

	FROM rapporto_mobile 

	WHERE id_rapporto= id AND anno = `year`; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionInsert`(

	id INT, 

	`year` INT,

	system_id INT,  

	customer_id INT,  

	requesting_intervention VARCHAR(30),

	responsible_job VARCHAR(30),

	responsible VARCHAR(30), 

	intervention_type TINYINT, 

	right_call BIT, 

	technical_report TEXT, 

	notes_highlights TEXT, 

	is_work_finished BIT, 

	system_conditions TINYINT,

	execution_date DATE, 

	report_number INT, 

	user_id INT, 

	email_company VARCHAR(45),

	is_nocturnal BIT, 

	is_public_holiday BIT, 

	is_on_call BIT, 

	is_carried_out_in_day BIT, 

	is_replaced BIT, 

	is_repair BIT, 

	is_custom BIT,

	intervention_detail_custom_text VARCHAR(45),

	is_under_warranty BIT,

	is_subscribed BIT, 

	is_not_under_warranty BIT,

	is_not_subscribed BIT, 

	ordinary_maintenance BIT, 

	extra_ordinary_maintenance BIT, 

	system_type INT, 

	company_name VARCHAR(60), 

	address VARCHAR(100), 

	city VARCHAR(100),  

	work_place VARCHAR(100), 

	problem_detected VARCHAR(100),

	email_responsible VARCHAR(100), 

	responsible_id INT,

	send_to_technician INT,

	clipboard TEXT,

	is_telephone_avaibility BIT,

	technician_sender_id MEDIUMINT

)
BEGIN

	DECLARE subscription_id INT; 

	DECLARE destination_id INT;

	

	SET subscription_id = 0; 

	SET destination_id = 0; 

	

	IF(system_id>0) THEN 

		SELECT abbonamento, destinazione

		INTO subscription_id, destination_id

		FROM Impianto 

		WHERE id_impianto = system_id; 

	END IF; 

	

	IF(destination_id=0) THEN 

		SET destination_id = 1;  

	END IF; 

	

	INSERT INTO rapporto_mobile SET 

		id_rapporto = id,

		anno = year, 

		id_impianto = system_id, 

		id_destinazione = destination_id, 

		id_cliente = customer_id, 

		Richiesto = requesting_intervention, 

		mansione = responsible_job, 

		responsabile = responsible,

		tipo_intervento = intervention_type, 

		Diritto_chiamata = right_call, 

		dir_ric_fatturato = 0, 

		relazione = technical_report, 

		terminato = is_work_finished, 

		funzionante = system_conditions, 

		stato = 1, 

		Note_generali = notes_highlights,

		Fattura = NULL, 

		Data = CURDATE(), 

		Commessa = NULL, 

		abbonamento = NULL, 

		Numero_ordine = NULL, 

		Totale = 0, 

		Nr_rapporto = report_number, 

		Data_esecuzione = execution_date, 

		costo = 0, 

		materiale = 0, 

		scan = 0, 

		anno_fattura = NULL, 

		controllo_periodico = NULL,

		prima = 0, 

		numero = report_number,

		id_utente = user_id, 

		cost_lav = NULL, 

		prez_lav = NULL, 

		dest_cli = customer_id, 

		email_invio = email_company,

		inviato = 0, 

		visionato = 0, 

		id_ticket = NULL, 

		tecnici = NULL, 

		appunti = clipboard, 

		notturno = is_nocturnal, 

		festivo = is_public_holiday, 

		su_chiamata = is_on_call, 

		eff_giorn = is_carried_out_in_day, 

		sost = is_replaced, 

		ripar = is_repair, 

		`not` = intervention_detail_custom_text, 

		c_not = is_custom, 

		abbon = is_subscribed, 

		garanz = is_under_warranty,

		man_ordi = ordinary_maintenance, 

		fuoriabbon = is_not_subscribed, 

		fuorigaranz = is_not_under_warranty,

		man_straord = extra_ordinary_maintenance, 

		tipo_impianto = system_type,

		ragione_sociale = company_name, 

		indirizzo = address, 

		citta = city, 

		luogo_lavoro = work_place, 

		difetto = problem_detected, 

		id_riferimento = responsible_id,

		mail_responsabile = email_responsible, 

		invia_a_tecnico = send_to_technician,

		da_reperibilita_telefonica = is_telephone_avaibility,

		id_tecnico = technician_sender_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionProductDeleteByReport`(

	id INT, 

	`year` INT

)
BEGIN	

	DELETE 

	FROM rapporto_mobile_materiale 

	WHERE id_rapporto= id AND anno_rapporto = `year`; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionSignatureDeleteByReport`(

	id INT, 

	`year` INT

)
BEGIN	

	DELETE FROM rapporto_mobile_firma

	WHERE id_rapporto = id AND anno_rapporto = `year`;

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionSignatureInsert`(

	id INT, 

	`year` INT,

	technician_signature BLOB, 

	customer_signature BLOB

)
BEGIN	



	INSERT INTO rapporto_mobile_firma

	SET id_rapporto = id,

	  anno_rapporto = `year`,

	  firma_tecnico = technician_signature, 

	  firma_cliente = customer_signature; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionTechnicianDelete`(

	id INT, 

	`year` INT

)
BEGIN	

	DELETE 

	FROM rapporto_mobile_tecnico

	WHERE id_rapporto= id AND anno_rapporto = `year`; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionTicketDeleteByReport`(

	id INT, 

	`year` INT

)
BEGIN

	

	DELETE 

	FROM rapporto_mobile_ticket 

	WHERE id_rapporto= id AND anno_rapporto = `year`; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionWorkDelete`(

	id INT, 

	`year` INT

)
BEGIN 	

	DELETE 

	FROM rapporto_mobile_lavoro 

	WHERE id_rapporto= id AND anno_rapporto = `year`; 		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiReportMobileInterventionWorkInsert`(

	id INT, 

	`year` INT,

	work_description TINYINT,

	material_use DeCIMAL(11,2), 

	right_call BIT, 

	travel_consuntive BIT, 

	expense_consuntive BIT, 

	expense DECIMAL(11,2), 

	first_period_start TIME,

	second_period_start TIME, 

	first_period_end TIME, 

	second_period_end TIME, 

	technicians VARCHAR(100), 

	total_hours VARCHAR(45) , 

	extra_consuntive  BIT, 

	extra_text VARCHAR(35), 

	extra_expense DECIMAL(11,2),

	vans_number TINYINT

)
BEGIN

        

		

	INSERT INTO rapporto_mobile_lavoro

	SET id_rapporto = id,

		anno_rapporto = `year`, 

		controllo_periodico = work_description,

		materiale_uso = material_use, 

		diritto_chiamata = right_call, 

		viaggio_consuntivo = travel_consuntive,

		spese_consuntivo = expense_consuntive, 

		spese = expense, 

		ora_inizio_primo_periodo = first_period_start, 

		ora_fine_primo_periodo = first_period_end,

		ora_inizio_secondo_periodo = second_period_start, 

		ora_fine_secondo_periodo = second_period_end,

		tecnici = technicians, 

		totale_ore = total_hours, 

		extra_consuntivo = extra_consuntive, 

		extra_testo = extra_text,

		extra = extra_expense,

		numero_furgoni = vans_number;

		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSupervisionGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSupervisionTypeGet`()
BEGIN

	SELECT Id_tipo, 

	Nome 

	FROM tipo_vigilante;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemGetById`(id INT)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemNoteGet`()
BEGIN

	SELECT  impianto_note.Id_impianto, 

		impianto_note.Id_nota, 

		impianto_note.Testo

	FROM impianto_note;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemNoteTypeGet`()
BEGIN

	SELECT impianto_note_descrizione.Id_descrizione, 

		Nome

	FROM impianto_note_descrizione;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemProductGet`()
BEGIN

	SELECT Id_impianto, 

		Id_articolo,

		count(id_articolo) "quantita"

	FROM impianto_componenti

	WHERE Data_dismesso IS NULL

	GROUP BY id_impianto, id_articolo;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemReferenceContactGet`()
BEGIN

SELECT id_impianto,

id_cliente,

id_riferimento

	FROM impianto_riferimento ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemSupervisionGet`()
BEGIN

	SELECT iv.Id_impianto, 

	iv.Id_vigilante, 

	IFNULL(tipo, 0) as Tipo

	FROM impianto_vigilante AS iv 

	LEFT JOIN impianto_vigilante_collegamenti AS ivc 

	ON iv.Id_impianto = ivc.id_impianto AND iv.Id_vigilante = ivc.id_vigilante; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiSystemTypeGet`()
BEGIN

	SELECT id_tipo,

		nome

	FROM tipo_impianto;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiTechnicianGet`()
BEGIN

	SELECT id_operaio, 

	ragione_sociale, 

	mail_account 

	FROM  Operaio 

	WHERE Data_licenziamento is null and Is_tecnico=1;	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiTicketGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_apiUserGet`()
BEGIN

	SELECT id_utente, 

	nome, 

	`password` ,

	salt

	FROM  Utente;	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM banca 

	WHERE id_banca = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankGetByName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesBankUpdate`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCompanyGet`( 

)
BEGIN

	SELECT id_azienda as "id_azienda",

	IFNULL(titolare, "") as "titolare",

	IFNULL(ragione_sociale, "") as "ragione_sociale",

	IFNULL(settore, "") as "settore",

	IFNULL(indirizzo, "") as "indirizzo",

	IFNULL(comune, "") as "comune",

	IFNULL(provincia, "") as "provincia",

	IFNULL(telefono, "") as "telefono",

	cellulare as "cellulare",

	IFNULL(partita_iva, "") as "partita_iva",

	IFNULL(regImprese, 0) as "regImprese",

	IFNULL(alboProvinciale, 0) as "alboProvinciale",

	IFNULL(ciaa, "") as "ciaa",

	IFNULL(ciaa_n, "") as "ciaa_n",

	IFNULL(albo_provincia, "") as "albo_provincia",

	IFNULL(albo_n, "") as "albo_n",

	IFNULL(numero, "") as "numero",

	IFNULL(sito_internet, "") as "sito_internet",

	IFNULL(fax, "") as "fax",

	IFNULL(e_mail, "") as "e_mail",

	IFNULL(cod_fis, "") as "cod_fis",

	IFNULL(numero_rea, "") as "numero_rea",

	IFNULL(posizione_inps, "") as "posizione_inps",

	IFNULL(posizione_inail, "") as "posizione_inail",

	IFNULL(codice_ateco, "") as "codice_ateco",

	IFNULL(assicu_rct, "") as "assicu_rct",

	IFNULL(frazione, "") as "frazione",

	IFNULL(capi_soc, "") as "capi_soc",

	data as "data",

	IFNULL(abilitazione, "") as "abilitazione",

	IFNULL(smtp, "") as "smtp",

	IFNULL(porta, 0) as "porta",

	mssl as "mssl",

	IFNULL(utente_mail, "") as "utente_mail",

	IFNULL(password, "") as "password",

	IFNULL(nome_mail, "") as "nome_mail",

	IFNULL(banca, "") as "banca",

	IFNULL(iban, "") as "iban",

	listino as "listino",

	sconto as "sconto",

	tipo_sconto as "tipo_sconto",

	stampa_ragione as "stampa_ragione",

	stampa_ri as "stampa_ri",

	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",

	IFNULL(cap2, "") as "cap2",

	IFNULL(stampante_promemoria, "") as "stampante_promemoria",

	IFNULL(mail_amministrazione, "") as "mail_amministrazione",

	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",

	IFNULL(host_caldav, "") as "host_caldav",

	IFNULL(nome_caldav, "") as "nome_caldav",

	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",

	IFNULL(license, "") as "license",

	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",

	IFNULL(tele_fatt, "") as "tele_fatt",

	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",

	IFNULL(notifica_attesa, 0) as "notifica_attesa",

	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",

	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",

	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",

	IFNULL(regime_fiscale, "") as "regime_fiscale",

	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine, 

	Data_ins, 

	Data_mod, 

	Utente_ins,

	Utente_mod

	FROM Azienda; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCompanyGetById`( 

	company_id INT

)
BEGIN

	SELECT id_azienda as "id_azienda",

	IFNULL(titolare, "") as "titolare",

	IFNULL(ragione_sociale, "") as "ragione_sociale",

	IFNULL(settore, "") as "settore",

	IFNULL(indirizzo, "") as "indirizzo",

	IFNULL(comune, "") as "comune",

	IFNULL(provincia, "") as "provincia",

	IFNULL(telefono, "") as "telefono",

	cellulare as "cellulare",

	IFNULL(partita_iva, "") as "partita_iva",

	IFNULL(regImprese, 0) as "regImprese",

	IFNULL(alboProvinciale, 0) as "alboProvinciale",

	IFNULL(ciaa, "") as "ciaa",

	IFNULL(ciaa_n, "") as "ciaa_n",

	IFNULL(albo_provincia, "") as "albo_provincia",

	IFNULL(albo_n, "") as "albo_n",

	IFNULL(numero, "") as "numero",

	IFNULL(sito_internet, "") as "sito_internet",

	IFNULL(fax, "") as "fax",

	IFNULL(e_mail, "") as "e_mail",

	IFNULL(cod_fis, "") as "cod_fis",

	IFNULL(numero_rea, "") as "numero_rea",

	IFNULL(posizione_inps, "") as "posizione_inps",

	IFNULL(posizione_inail, "") as "posizione_inail",

	IFNULL(codice_ateco, "") as "codice_ateco",

	IFNULL(assicu_rct, "") as "assicu_rct",

	IFNULL(frazione, "") as "frazione",

	IFNULL(capi_soc, "") as "capi_soc",

	data as "data",

	IFNULL(abilitazione, "") as "abilitazione",

	IFNULL(smtp, "") as "smtp",

	IFNULL(porta, 0) as "porta",

	mssl as "mssl",

	IFNULL(utente_mail, "") as "utente_mail",

	IFNULL(password, "") as "password",

	IFNULL(nome_mail, "") as "nome_mail",

	IFNULL(banca, "") as "banca",

	IFNULL(iban, "") as "iban",

	listino as "listino",

	sconto as "sconto",

	tipo_sconto as "tipo_sconto",

	stampa_ragione as "stampa_ragione",

	stampa_ri as "stampa_ri",

	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",

	IFNULL(cap2, "") as "cap2",

	IFNULL(stampante_promemoria, "") as "stampante_promemoria",

	IFNULL(mail_amministrazione, "") as "mail_amministrazione",

	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",

	IFNULL(host_caldav, "") as "host_caldav",

	IFNULL(nome_caldav, "") as "nome_caldav",

	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",

	IFNULL(license, "") as "license",

	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",

	IFNULL(tele_fatt, "") as "tele_fatt",

	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",

	IFNULL(notifica_attesa, 0) as "notifica_attesa",

	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",

	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",

	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",

	IFNULL(regime_fiscale, "") as "regime_fiscale",

	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine, 

	Data_ins, 

	Data_mod, 

	Utente_ins,

	Utente_mod

	FROM Azienda WHERE Id_azienda = company_id; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCompanyGetMostRecent`( 

)
BEGIN

	SELECT id_azienda as "id_azienda",

	IFNULL(titolare, "") as "titolare",

	IFNULL(ragione_sociale, "") as "ragione_sociale",

	IFNULL(settore, "") as "settore",

	IFNULL(indirizzo, "") as "indirizzo",

	IFNULL(comune, "") as "comune",

	IFNULL(provincia, "") as "provincia",

	IFNULL(telefono, "") as "telefono",

	cellulare as "cellulare",

	IFNULL(partita_iva, "") as "partita_iva",

	IFNULL(regImprese, 0) as "regImprese",

	IFNULL(alboProvinciale, 0) as "alboProvinciale",

	IFNULL(ciaa, "") as "ciaa",

	IFNULL(ciaa_n, "") as "ciaa_n",

	IFNULL(albo_provincia, "") as "albo_provincia",

	IFNULL(albo_n, "") as "albo_n",

	IFNULL(numero, "") as "numero",

	IFNULL(sito_internet, "") as "sito_internet",

	IFNULL(fax, "") as "fax",

	IFNULL(e_mail, "") as "e_mail",

	IFNULL(cod_fis, "") as "cod_fis",

	IFNULL(numero_rea, "") as "numero_rea",

	IFNULL(posizione_inps, "") as "posizione_inps",

	IFNULL(posizione_inail, "") as "posizione_inail",

	IFNULL(codice_ateco, "") as "codice_ateco",

	IFNULL(assicu_rct, "") as "assicu_rct",

	IFNULL(frazione, "") as "frazione",

	IFNULL(capi_soc, "") as "capi_soc",

	data as "data",

	IFNULL(abilitazione, "") as "abilitazione",

	IFNULL(smtp, "") as "smtp",

	IFNULL(porta, 0) as "porta",

	mssl as "mssl",

	IFNULL(utente_mail, "") as "utente_mail",

	IFNULL(password, "") as "password",

	IFNULL(nome_mail, "") as "nome_mail",

	IFNULL(banca, "") as "banca",

	IFNULL(iban, "") as "iban",

	listino as "listino",

	sconto as "sconto",

	tipo_sconto as "tipo_sconto",

	stampa_ragione as "stampa_ragione",

	stampa_ri as "stampa_ri",

	IFNULL(giorni_promemoria, 0) as "giorni_promemoria",

	IFNULL(cap2, "") as "cap2",

	IFNULL(stampante_promemoria, "") as "stampante_promemoria",

	IFNULL(mail_amministrazione, "") as "mail_amministrazione",

	IFNULL(intestazione_promemoria, "") as "intestazione_promemoria",

	IFNULL(host_caldav, "") as "host_caldav",

	IFNULL(nome_caldav, "") as "nome_caldav",

	IFNULL(email_provider_caldav, 0) as "email_provider_caldav",

	IFNULL(license, "") as "license",

	IFNULL(abilita_convalida_rapporto, 0) as "abilita_convalida_rapporto",

	IFNULL(tele_fatt, "") as "tele_fatt",

	IFNULL(circolare_per_garanzia, "") as "circolare_per_garanzia",

	IFNULL(notifica_attesa, 0) as "notifica_attesa",

	IFNULL(passaggio_nonaccettato, 0) as "passaggio_nonaccettato",

	IFNULL(percorso_default_aggiornamento, "") as "percorso_default_aggiornamento",

	IFNULL(giorni_avviso_rapporto, 0) as "giorni_avviso_rapporto",

	IFNULL(regime_fiscale, "") as "regime_fiscale",

	IFNULL(Data_fine, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Data_fine, 

	Data_ins, 

	Data_mod, 

	Utente_ins,

	Utente_mod

	FROM Azienda ORDER BY Id_azienda DESC LIMIT 1; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Nazione 

	WHERE id_Nazione = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryGetByName`( 

	name VARCHAR(30)

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

	WHERE Nome = name

	ORDER BY Id_nazione;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryInsert`( 

	name VARCHAR(45),

	abbreviation varchar(10),

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT Count(id_nazione) INTO Result

	FROM Nazione 

	WHERE Nome = Name; 

	

	IF Result > 0 THEN

		 SET Result = -1; 
	END IF;



	

	IF Result = 0 THEN

		INSERT INTO Nazione 

		SET 

			Nome = name,

			sigla = Abbreviation, 

			Data_ins = NOW(), 

			Data_mod = NOW(), 

			Utente_ins = @USER_ID, 

			Utente_mod = @USER_ID;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesCountryUpdate`( 

	enter_id INTEGER,

	name VARCHAR(45),

	abbreviation varchar(10),

	OUT Result INT

)
BEGIN

	

	SET Result = 1; 

	

	SELECT Count(Id_nazione) INTO Result

	FROM Nazione 

	WHERE Nome = Name AND Id_nazione != enter_id; 

	

	IF Result > 0 THEN

		 SET Result = -1; 
	END IF;



	

	IF Result = 0 THEN 

			SELECT Count(*) INTO Result

			FROM Nazione 

			WHERE id_Nazione = enter_id;

			

			IF Result = 0 THEN

				SET Result = -2; 
			END IF; 

	END IF; 

	

	IF Result >0 THEN

		UPDATE Nazione 

		SET 

			Nome = name,

			sigla = Abbreviation, 

			Utente_mod = @USER_ID

		Where id_Nazione = enter_id;

			

		SET Result = 1; 

	END IF; 

END ;;
DELIMITER ;

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEmployeeGetById`( 

employee_id INT

)
BEGIN

        

	SELECT Id_operaio,

		 IFNULL(Ragione_sociale, "" ) AS Ragione_sociale,

		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,

		 IFNULL(Provincia, "" ) AS Provincia,

		 IFNULL(Comune, 0) AS Comune,

		 IFNULL(Frazione, 0) AS Frazione ,

		 IFNULL(Codice_Fiscale, "" ) AS Codice_Fiscale,

		 IFNULL(Indirizzo, "" ) AS  Indirizzo,

		 IFNULL(Iban, "" ) AS Iban,

		 IFNULL(livello_associato, 0 ) AS  livello_associato,

		 IFNULL(N_matricola,0 ) AS N_matricola,

		 IFNULL(Scade_contratto, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS Scade_contratto,

		 IFNULL(Telefono, "" ) AS Telefono,

		 IFNULL(Telefono_abitazione, "" ) AS Telefono_abitazione,

		 IFNULL(altro_telefono, "" ) AS altro_telefono,

		 IFNULL(E_mail, "" ) AS E_mail,

		 IFNULL(qualifica, 0 ) AS qualifica,

		 IFNULL(Data_assunzione, CAST("1970-01-01" AS DATE) ) AS Data_assunzione,

		 IFNULL(Data_licenziamento, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS   Data_licenziamento,

		 IFNULL(Tariffario, 0 ) AS Tariffario,

		 IFNULL(collaboratore, 0 ) AS collaboratore,

		 IFNULL(id_filiale, 0 ) AS id_filiale,

		 IFNULL(l_nas, 0 ) AS l_nas,

		 IFNULL(d_nas, CAST("1970-01-01 00:00:00" AS DATETIME) ) AS d_nas,

		 IFNULL(tipo_operaio, 0 ) AS tipo_operaio,

		 IFNULL(agente, 0 ) AS agente,

		 IFNULL(id_utente, 0 ) AS id_utente,

		 IFNULL(is_cassa, 0 ) AS is_cassa,

		 IFNULL(is_tecnico, 0 ) AS  is_tecnico,

		 IFNULL(mail_account, "" ) AS mail_account,

		 IFNULL(password, "" ) AS password,

		 IFNULL(username, "" ) AS username,

		 IFNULL(sigla_operaio, "" ) AS sigla_operaio,

		 IFNULL(Data_ins, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_ins,

		 IFNULL(Data_mod, CAST("1970-01-01 00:00:00" AS DATETIME)) AS Data_mod,

		 IFNULL(Utente_ins, 0 ) AS Utente_ins,

		 IFNULL(Utente_mod, 0 ) AS Utente_mod

	FROM Operaio

	WHERE Id_operaio = employee_id; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventDelete`(

enter_id INT,

OUT result BIT

)
BEGIN

	DECLARE event_type INT;

	DECLARE refer_id INT;



	SET Result = 1; 



	If enter_id <= 0 OR enter_id IS NULL

	THEN

		SET Result = 0;  

	END IF; 	

	

	IF Result 

	THEN		 

	

		
		SELECT id_tipo_evento, 

			id_riferimento 

		INTO

			event_type, 

			refer_id 

		FROM Evento

		WHERE Id = enter_id; 

		

		IF event_type = 1 

		THEN

			DELETE FROM Impianto_abbonamenti_mesi 

			WHERE Id = refer_id; 

		END IF; 

		

		DELETE FROM evento WHERE Id = enter_id; 

	END IF; 

		

	

		

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventEmployeeDeleteByEventId`( 

event_Id INT,

OUT result BIT

)
BEGIN

        

	SET Result = 1; 



	If event_Id <= 0 OR event_Id IS NULL

	THEN

		SET Result = 0;  

	END IF; 	

	

	IF Result 

	THEN

		 	DELETE

			FROM Evento_Operaio

			WHERE id_evento = event_id;

	END IF; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventEmployeeGet`( )
BEGIN

        

	SELECT Id, 

		Id_evento, 

		id_operaio,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento_Operaio; 



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventEmployeeGetByEmployeeId`( 

employee_Id INT

)
BEGIN

        

	SELECT Id, 

		id_evento, 

		id_operaio,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento_Operaio

	WHERE id_operaio = employee_id; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventEmployeeGetByEventId`( 

event_Id INT

)
BEGIN

        

	SELECT Id, 

		id_evento, 

		id_operaio,

		Data_ins, 

		Data_mod, 

		Utente_ins, 

		Utente_mod

	FROM Evento_Operaio

	WHERE id_evento = event_id; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavDelete`( 

	enter_id INT

)
BEGIN

	DELETE FROM evento_file_associati_caldav WHERE id = enter_id; 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavGet`( 

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

	FROM evento_file_associati_caldav;   



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavGetByEventId`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavGetByEventIdAndEmployeeId`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavGetByFileName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventFileAssociatedCaldavInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventGet`( )
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventGetByTypeAndReferId`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventInsert`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventSetWasPermormed`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventTypeGet`( 

)
BEGIN

        

	SELECT Id_tipo, 

	Nome, 

	Colore

	FROM Tipo_evento; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesEventUpdate`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`utente`@`%` PROCEDURE IF NOT EXISTS `sp_ariesGetUser`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM frazione 

	WHERE id_frazione = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletGetByName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesHamletUpdate`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Comune 

	WHERE id_comune = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityGetByName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesMunicipalityUpdate`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductGet`( 

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Categoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductGetByBrand`( 

brand VARCHAR(5)

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Categoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo

WHERE marca  = brand; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductGetByCategoryId`( 

category_id INT

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Categoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo

WHERE Caregoria  = category_id; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductGetById`( 

product_code VARCHAR(11)

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Categoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo

WHERE Codice_articolo = product_code; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductRowNumbers`( 

)
BEGIN

SELECT

	COUNT(*)

FROM articolo; 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductSearchById`( 

product_code VARCHAR(11)

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Caregoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo

WHERE Codice_prodotto LIKE CONCAT("%", product_code, "%"); 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProductSerchById`( 

product_code VARCHAR(11)

)
BEGIN

        



SELECT

	Codice_articolo, 

	IFNULL(Desc_Brev, "") AS Desc_brev,

	IFNULL(Codice_fornitore, "") AS Codice_fornitore, 

	IFNULL(Marca, "") AS MArca, 

	Peso, 

	IFNULL(Altre_Caratteristiche, "") AS Altre_Caratteristiche,

	IFNULL(Scadenza, 0) AS scadenza, 

	IFNULL(Fornitore_priv, 0) AS Fornitore_priv, 

	Tempo_installazione, 

	IFNULL(Categoria, 0) AS Categoria, 

	IFNULL(SottoCategoria, 0) AS Sottocategoria, 

	IFNULL(Sottocategoria2, 0) AS Sottocategoria2, 

	IFNULL(Barcode, "") AS Barcode, 

	Quantita_massima, 

	Quantita_minima, 

	NUmero_confezione, 

	IFNULL(Unità_misura,  "") AS Unità_misura, 

	IFNULL(ult_vendita, 0) AS ult_vendita, 

	IFNULL(garanzia, 0) AS Garanzia, 

	IFNULL(Minuti_Manutenzione, 0) AS Minuti_Manutenzione,

	Stato_articolo, 

	Data_inserimento, 

	uso_consumo,

	IFNULL(umidità, 0) as umidità, 

	IFNULL(min, 0) as min, 

	IFNULL(max, 0) AS max,

	IFNULL(l, 0) AS l, 

	IFNULL(h, 0) AS h, 

	IFNULL(p, 0) AS p,

	modifica, 

	kw, 

	litri, 

	kwp, 

	IFNULL(Color, "") AS Color, 

	moltiplicatore, 

	Is_Kit

FROM articolo

WHERE Codice_articolo LIKE CONCAT("%", product_code, "%"); 

			

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM province 

	WHERE id_provincia = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceGetByName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesProvinceUpdate`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionDelete`( 

	enter_id INTEGER

)
BEGIN



	DELETE FROM Regione 

	WHERE id_Regione = enter_id;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionGet`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionGetByName`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesRegionUpdate`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionById`( 

	report_id INT,

	report_year INT

)
BEGIN

	 SELECT       

          Id_rapporto,       

          Anno,       

          Id_Impianto,       

          id_destinazione,       

          Id_cliente,       

          Richiesto,       

          Mansione,       

          Responsabile,       

          Tipo_intervento,       

          Diritto_chiamata,       

          dir_ric_fatturato,       

          relazione,       

          Terminato,       

          CAST(Funzionante AS UNSIGNED) "Funzionante",       

          Stato,       

          Note_Generali,       

          Data,       

          abbonamento,       

          Data_esecuzione,       

          scan,       

          anno_fattura,       

          controllo_periodico,       

          prima,       

          APPUNTI,       

          CAST(notturno AS UNSIGNED) "notturno",       

          CAST(festivo AS UNSIGNED) "festivo",       

          CAST(su_chiamata AS UNSIGNED) "su_chiamata",       

          CAST(eff_giorn AS UNSIGNED) "eff_giorn",       

          CAST(sost AS UNSIGNED) "sost",       

          CAST(ripar AS UNSIGNED) "ripar",       

          CAST(abbon AS UNSIGNED) "abbon",       

          CAST(garanz AS UNSIGNED) "garanz",       

          CAST(man_ordi AS UNSIGNED) "man_ordi",

			     

          CAST(fuoriabbon AS UNSIGNED) "fuoriabbon",       

          CAST(fuorigaranz AS UNSIGNED) "fuorigaranz",       

          CAST(man_straord AS UNSIGNED) "man_straord",   

			   

          tipo_impianto,       

          ragione_sociale,       

          indirizzo,       

          citta,       

          luogo_lavoro,       

          difetto,       

          id_riferimento,       

          da_reperibilita_telefonica       

    FROM rapporto_mobile       

    WHERE id_rapporto = report_id AND anno = report_year;       



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionDeleteById`( 

	report_id INT,

	report_year INT,

	OUT Result INT

)
BEGIN



	SET Result = 1; 

	

	SELECT COUNT(*) INTO Result

	FROM Rapporto_mobile 

	WHERE Id_rapporto = report_id AND anno = report_year;  

	

	IF Result = 0 THEN

		SET Result = -2;  

	END IF; 



	IF Result > 0 THEN

		UPDATE rapporto_mobile    

		SET Visionato = 1  

		WHERE Id_rapporto = report_id AND anno = report_year; 

		

		

		SET Result = 1; 

	END IF;     



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionProductByReportId`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionTechnicianByReportId`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionTicketByReportId`( 

	report_id INT,

	report_year INT

)
BEGIN

  SELECT Id,       

      id_rapporto,       

      anno_rapporto,        

      id_ticket,       

      anno_ticket       

  FROM rapporto_mobile_ticket       

  WHERE Id_rapporto = report_id AND anno_rapporto = report_year;      



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesReportMabileInterventionWorkByReportId`( 

	report_id INT,

	report_year INT

)
BEGIN

	SELECT id,       

        id_rapporto,       

        anno_rapporto,       

        controllo_periodico,       

        materiale_uso,       

        diritto_chiamata,       

        viaggio_consuntivo,       

        spese,       

        tecnici,       

        totale_ore,       

        extra_consuntivo,       

        extra_testo,       

        extra       

	FROM rapporto_mobile_lavoro       

	WHERE Id_rapporto = report_id AND anno_rapporto = report_year;     



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemGet`( )
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemPeriodicMonitoringDeleteById`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemPeriodicMonitoringGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemPeriodicMonitoringGetById`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemPeriodicMonitoringInsert`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesSystemPeriodicMonitoringUpdate`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesTabletConfigurationGetLastInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesTabletConfigurationInsert`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesTicketGet`( )
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesTicketGetById`( 

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesUserGet`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesUserGetById`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ariesUserLogin`(IN `username` VARCHAR(50), IN `pass` VARCHAR(50), OUT `userId` INT)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ddtAssociate`(

	ddtId INT, ddtYear INT, docId INT, docYear INT, docType VARCHAR(20), jobLotId INT,

	OUT ddtAssociateResult INT

)
BEGIN



	DECLARE res TINYINT;

	DECLARE ddtStatusResult INT;



	IF docId < 0 OR docYear < 0 THEN

		SET docId = NULL;

		SET docYear = NULL;

	END IF;

	IF jobLotId <= 0 THEN

		SET jobLotId = NULL;

	END IF;



	IF docType = 'INVOICE' THEN

		UPDATE ddt SET

			fattura = docId,

			anno_fattura = docYear

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

	END IF;



	IF docType = 'SUPPLIERINVOICE' THEN

		UPDATE ddt SET 

			fatturaf = docId,

			anno_fatturaf = docYear

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

	END IF;

	

	IF docType = 'RECEIVED_DDT' THEN

		IF NOT ISNULL(docId) THEN

			INSERT INTO ddt_ricevuti_emessi SET 

				id_r = docId, 

				anno_r = docYear, 

				anno_e = ddtYear, 

				id_e = ddtId, 

				tipo = "1";

		END IF;

	END IF;

	

	IF docType = 'JOB' THEN

	

		
		DELETE FROM commessa_ddt

		WHERE id_ddt = ddtId

			AND anno_ddt = ddtYear;



		

		
		IF docId IS NOT NULL AND jobLotId IS NOT NULL THEN

			INSERT INTO commessa_ddt SET 

				id_ddt = ddtId, 

				anno_ddt = ddtYear, 

				anno_commessa = docYear, 

				id_lotto = jobLotId, 

				id_commessa = docId;

		END IF;

	END IF; 

	

	CALL sp_onDdtDeterminingStatus(ddtId, ddtYear, CONCAT('ASSOC ', docType), ddtStatusResult);

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ddtDissociate`(

	ddtId INT, ddtYear INT, docId INT, docYear INT, docType VARCHAR(20), jobLotId INT,

	OUT ddtDissociateResult INT

)
BEGIN



	DECLARE ddtStatusResult INT;



	IF docId < 0 OR docYear < 0 THEN

		SET docId = NULL;

		SET docYear = NULL;

	END IF;



	IF docType = 'INVOICE' THEN

		UPDATE ddt SET

			fattura = NULL,

			anno_fattura = NULL

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

	END IF;



	IF docType = 'SUPPLIERINVOICE' THEN

		UPDATE ddt SET 

			fatturaf = NULL,

			anno_fatturaf = NULL

		WHERE id_ddt = ddtId

			AND anno = ddtYear;

	END IF;

	

	IF docType = 'RECEIVED_DDT' THEN

		DELETE FROM ddt_ricevuti_emessi

		WHERE id_r = docId

			AND anno_r = docYear 

			AND anno_e = ddtYear 

			AND id_e = ddtId;

	END IF;

	

	IF docType = 'JOB' THEN

		DELETE FROM commessa_ddt

		WHERE id_ddt = ddtId

			AND anno_ddt = ddtYear;

	END IF;

	

	CALL sp_onDdtDeterminingStatus(ddtId, ddtYear, CONCAT('DISSOC ', docType), ddtStatusResult);

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_ddtGetPrintInformationsToBeBilled`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ddtInsert`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_ddtUpdate`(

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

/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_getInvoicePeriodicTotals`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE IF NOT EXISTS `sp_getJobTotals`(

        id_job INT, year_job INT, id_lot INT,

		OUT total_price_quote Decimal(11,2), OUT total_cost Decimal(11,2), OUT total_hours_worked_economy Decimal(11,2), 

        OUT total_hours_worked Decimal(11,2), OUT Total_hours Decimal(11,2), OUT total_hours_travel Decimal(11,2),

        OUT total_price_quote_body_products Decimal(11,2), OUT total_cost_body_products_economy Decimal(11,2), 

		OUT total_cost_worked_economy Decimal(11,2),

        OUT total_cost_body_products Decimal(11,2), OUT total_cost_worked Decimal(11,2), OUT total_km Decimal(11,2),

        OUT total_cost_hours_travel Decimal(11,2), OUT total_cost_km Decimal(11,2), OUT total_cost_transfert Decimal(11,2),

        OUT total_cost_extra Decimal(11,2), OUT total_cost_parking Decimal(11.2), OUT total_cost_speedway Decimal(11,2),

        OUT total_price_body_products Decimal(11,2), OUT total_price_worked Decimal(11,2), 

        OUT total_price_hours_travel Decimal(11,2), OUT total_price_km Decimal(11,2), OUT total_price_transfert Decimal(11,2),

        OUT total_price_extra Decimal(11,2), OUT total_price_parking Decimal(11.2), OUT total_price_speedway Decimal(11,2),

		OUT total_price_body_products_economy Decimal(11,2), OUT total_price_worked_economy Decimal(11,2), 	

		OUT total_price Decimal(11,2),

		OUT total_price_quote_worked Decimal(11,2)

		

)
BEGIN

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



	SELECT 

		CAST(IF(SUM(twi.totale_ore_lavorate) IS NULL, 0 , SUM(twi.totale_ore_lavorate))AS DECIMAL(11,2)),

		CAST(IF(SUM(twi.totale_costo_lavoro) IS NULL, 0 , SUM(twi.totale_costo_lavoro))AS DECIMAL(11,2)),

	    CAST(IF(SUM(twi.totale_prezzo_lavoro) IS NULL, 0 , SUM(twi.totale_prezzo_lavoro))AS DECIMAL(11,2))

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

		CAST(if(SUM(twi.totale_ore_lavorate) IS NULL, 0,SUM(twi.totale_ore_lavorate))  AS DECIMAL(11,2)),

		CAST(if(SUM(twi.totale_costo_lavoro) IS NULL, 0,SUM(twi.totale_costo_lavoro)) AS DECIMAL(11,2)), 

		CAST(if(SUM(twi.totale_prezzo_lavoro) IS NULL,0, SUM(twi.totale_prezzo_lavoro)) AS DECIMAL(11,2)) 

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

		

	SET total_cost = if(total_cost_body_products_economy IS NULL, 0, total_cost_body_products_economy)

				+ if(total_cost_worked_economy IS NULL, 0, total_cost_worked_economy)

				+ if(total_cost_body_products IS NULL, 0, total_cost_body_products)

				+ if(total_cost_worked IS NULL, 0, total_cost_worked)

				+ if(total_cost_hours_travel IS NULL, 0, total_cost_hours_travel)

				+ if(total_cost_km IS NULL, 0, total_cost_km)

				+ if(total_cost_transfert IS NULL, 0, total_cost_transfert)

				+ if(total_cost_extra IS NULL, 0, total_cost_extra)

				+ if(total_cost_parking IS NULL, 0, total_cost_parking)

				+ if(total_cost_speedway IS NULL, 0,total_cost_speedway) ;

				

	SET total_price = if(total_price_body_products_economy IS NULL, 0, total_price_body_products_economy)

				+ if(total_price_worked_economy IS NULL, 0, total_price_worked_economy)

				+ if(total_price_body_products IS NULL, 0, total_price_body_products)

				+ if(total_price_worked IS NULL, 0, total_price_worked)

				+ if(total_price_hours_travel IS NULL, 0, total_price_hours_travel)

				+ if(total_price_km IS NULL, 0, total_price_km)

				+ if(total_cost_transfert IS NULL, 0, total_cost_transfert)

				+ if(total_cost_extra IS NULL, 0, total_cost_extra)

				+ if(total_cost_parking IS NULL, 0, total_cost_parking)

				+ if(total_cost_speedway IS NULL, 0, total_cost_speedway) ;

				

	SET total_price_quote_worked = total_price_quote-total_price_quote_body_products;

				

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_getQuoteTotals`(IN `quote_id` INT, IN `quote_year` INT, IN `quote_revision_id` INT, OUT `total_price_material` DECIMAL(11,2), OUT `total_cost_material` DECIMAL(11,2), OUT `total_profit_material` DECIMAL(11, 2), OUT `total_price_work` DECIMAL(11, 2), OUT `total_cost_work` DECIMAL(11, 2), OUT `total_profit_work` DECIMAL(11, 2), OUT `total_hours` DECIMAL(11, 2), OUT `total_price` DECIMAL(11, 2), OUT `total_cost` DECIMAL(11, 2), OUT `total_profit` DECIMAL(11, 2), OUT `total_sale` DECIMAL(11, 2)

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

	SET total_hours = IFNULL(total_hours, 0);



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_getTokenID`(id_utente INT, deadline DATETIME,

        OUT id_token INT)
BEGIN



  INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);

  SELECT LAST_INSERT_ID() INTO id_token;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_mobileAddTechnicianGPSCoordinates`(IN `MACAddress` VARCHAR(17), IN `Latitude` DOUBLE, IN `Longitude` DOUBLE, IN `DetectionDate` DATETIME, IN `DetectionSource` TINYINT, OUT `SuccessfullInsert` BIT)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_mobileGetAriesCallInformations`(IN `DateLastExecution` DATETIME)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_onDdtDeterminingStatus`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_serverBackupSettingsGet`(

)
BEGIN

	

    SELECT id_impostazioni, 

	 	valore 

    FROM impostazioni_backup; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_serverParhConfigurationGet`(

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_serverParhConfigurationGetByKey`(

	path_type VARCHAR(50)

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi

	 WHERE tipo_percorso = path_type; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_serverPathConfigurationGetByKey`(

	path_type VARCHAR(50)

)
BEGIN

	

    SELECT tipo_percorso, 

	 	Percorso 

    FROM configurazione_percorsi

	 WHERE tipo_percorso = path_type; 

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_serverReportMobileInterventionProductGetForPrint`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_splitArray`(serializedArray VARCHAR(1024))
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_tknGetIDToken`(IN `id_utente` INT, IN `deadline` DATETIME, OUT `id_token` INT)
BEGIN



  INSERT INTO TokenRefresh (id_utente,deadline) values (id_utente, deadline);

  SELECT LAST_INSERT_ID() INTO id_token;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_tknRefreshTokenExists`(IN `id_token` INT, OUT `FlagFind` BOOL)
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_tmp`()
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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_userInsert`(

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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE IF NOT EXISTS `sp_userUpdate`(

	userId INT, userName VARCHAR(60) , userPassword VARCHAR(60), description TEXT, email VARCHAR(100),

	emailSignature TEXT, calendar INT(11), smtp VARCHAR(45), port VARCHAR (45),

	emailUsername VARCHAR(45), emailPassword VARCHAR(45), 

	emailRequestConfirm BIT, emailUseSSL BIT, userType TINYINT(4))
BEGIN



	DECLARE allowUpdate BIT DEFAULT 1; 

	

	SET allowUpdate = CONCAT(userId, userName, userPassword) IS NOT NULL;

	

	


	IF allowUpdate THEN



		SELECT IFNULL(userName, `nome`), IFNULL(CAST(SHA1(CONCAT(userPassword, salt)) AS CHAR(40) CHARACTER SET latin1), `password`), 

			IFNULL(description, `descrizione`), IFNULL(email, `mail`), IFNULL(emailSignature, `firma`), IFNULL(calendar, `calendario`),

			IFNULL(smtp, `smtp`), IFNULL(port, `porta`), IFNULL(emailUsername, `nome_utente_mail`), IFNULL(emailPassword, `password_mail`), 

			IFNULL(userType, `tipo_utente`), IFNULL(emailUseSSL, `mssl`), IFNULL(emailRequestConfirm,`conferma`)

		INTO userName, userPassword, description, email, emailSignature, calendar, smtp,

			port, emailUsername, emailPassword, userType, emailUseSSL, emailRequestConfirm

		FROM utente

		WHERE id_utente = userId;

	

		UPDATE utente SET 

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

			`mssl` = emailUseSSL,

			`conferma` = emailRequestConfirm,

			`tipo_utente` = userType

		WHERE id_utente = userId;

		

	END IF;

	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_usrGetIDByUsername`(IN `username` VARCHAR(60), OUT `id_utente` INT)
BEGIN

SELECT utente.id_utente INTO id_utente

FROM utente

WHERE utente.Nome = username;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE IF NOT EXISTS `sp_usrLogin`(IN username VARCHAR(60), IN password VARCHAR(60), OUT success BIT(1))
BEGIN

	SELECT COUNT(utente.id_utente) INTO success 

	FROM utente 

	WHERE utente.Nome = username 

		AND utente.Password = password;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-06 17:20:43
