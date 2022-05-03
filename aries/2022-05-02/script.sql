SET @USER_ID = (SELECT id_utente FROM utente WHERE Nome = "admin");


INSERT INTO `tipo_iva` (`Nome`, `aliquota`, `esigibilita`) VALUES ('IVA 05%', 5, 'I');

UPDATE magazzino_operazione mo
INNER JOIN magazzino_rapporto_materiale mrm ON mo.id_operazione = mrm.id_operazione
SET mo.sorgente = 2;
