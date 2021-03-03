INSERT INTO configurazione_percorsi 
	VALUES (CONCAT((SELECT a.Percorso FROM configurazione_percorsi as a WHERE a.Tipo_percorso = 'REPORT'), 'FAST REPORT\\'), 'FAST_REPORT'); 