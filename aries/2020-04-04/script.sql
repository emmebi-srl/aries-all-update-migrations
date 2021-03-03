DROP PROCEDURE IF EXISTS tmp;
DELIMITER $$
CREATE PROCEDURE tmp()
BEGIN
	DECLARE category_id INT;
	DECLARE old_name VARCHAR(40);
	
	SELECT Nome INTO old_name
	FROM categoria_merciologica
	WHERE id_categoria = 0;
	
	INSERT INTO Categoria_merciologica (`Nome`, `Descrizione`, `Movimenta_magazzino`,
		`Movimenta_impianto`, `Data_ins`, `Data_mod`, `Utente_ins`, `Utente_mod`)
	SELECT 	'some-random', `Descrizione`, `Movimenta_magazzino`,
		`Movimenta_impianto`, `Data_ins`, `Data_mod`, `Utente_ins`, `Utente_mod`
	FROM Categoria_merciologica
	WHERE id_categoria = 0;
	
 	SELECT LAST_INSERT_ID() INTO category_id;
 	
 	UPDATE sottocategoria SET id_categoria = category_id WHERE id_categoria = 0;
 	
 	UPDATE articolo
 	SET categoria = category_id
 	WHERE categoria = 0;
 	
 	DELETE FROM Categoria_merciologica
 	WHERE id_categoria = 0;
 	
 	UPDATE categoria_merciologica
 	SET nome = old_name
 	WHERE id_categoria = category_id;
END $$
DELIMITER ;
CALL tmp;


