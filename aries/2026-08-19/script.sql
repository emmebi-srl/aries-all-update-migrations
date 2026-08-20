UPDATE resoconto
SET Nota = ''
WHERE Nota IS NULL;

DROP PROCEDURE IF EXISTS sp_ariesReportGroupSearch;
DELIMITER //
CREATE PROCEDURE `sp_ariesReportGroupSearch`(
    product_txt VARCHAR(200),
    customer_name VARCHAR(200),
    doc_id INT(11),
    doc_year INT(11),
    customer_id INT(11),
    description TEXT,
    notes TEXT,
    status INT(11),
    doc_date DATETIME,
    doc_type INT(11),
    final_note TEXT
)
BEGIN
    DECLARE has_product BIT;
    SET has_product = product_txt <> '' AND product_txt IS NOT NULL;

    DROP TABLE IF EXISTS tmp_resoconto_con_articoli;

    CREATE TEMPORARY TABLE tmp_resoconto_con_articoli (
        id_resoconto INT(11),
        anno_reso INT(11)
    );

    IF has_product THEN
        INSERT INTO tmp_resoconto_con_articoli
        SELECT DISTINCT id_resoconto,
            anno_reso
        FROM resoconto_rapporto
            INNER JOIN rapporto_materiale
            ON resoconto_rapporto.id_rapporto = rapporto_materiale.Id_rapporto
                AND resoconto_rapporto.anno = rapporto_materiale.anno
            LEFT JOIN articolo
                ON articolo.Codice_articolo = rapporto_materiale.Id_materiale
        WHERE rapporto_materiale.Id_materiale LIKE CONCAT('%', product_txt, '%')
            OR rapporto_materiale.descrizione LIKE CONCAT('%', product_txt, '%')
            OR articolo.Codice_fornitore LIKE CONCAT('%', product_txt, '%');
    ELSE
        INSERT INTO tmp_resoconto_con_articoli
        SELECT id_resoconto,
            anno
        FROM resoconto;
    END IF;

    SELECT resoconto.id_resoconto AS "ID",
        data,
        resoconto.descrizione,
        clienti.ragione_sociale AS "Cliente",
        nota, tipo_resoconto,
        tipo_resoconto.nome AS "tipo",
        stato AS "Stato",
        resoconto.anno, anno_fattura,
        Inviato,
        nota_fine,
        stm AS "Stampato",
        colore,
        fat_speseRap,
        resoconto_totali.costo_totale,
        resoconto_totali.prezzo_totale
    FROM resoconto
        INNER JOIN tipo_resoconto ON id_tipo = resoconto.tipo_resoconto
        INNER JOIN clienti ON resoconto.id_cliente = clienti.id_cliente
        INNER JOIN stato_resoconto ON stato_resoconto.id_stato = resoconto.stato
        INNER JOIN resoconto_totali
            ON resoconto_totali.id_resoconto = resoconto.id_resoconto
                AND resoconto_totali.anno = resoconto.anno
        INNER JOIN tmp_resoconto_con_articoli
            ON tmp_resoconto_con_articoli.id_resoconto = resoconto.id_resoconto
                AND tmp_resoconto_con_articoli.anno_reso = resoconto.anno
    WHERE
        clienti.ragione_sociale LIKE CONCAT('%', IFNULL(customer_name, ''), '%')
        AND IF(doc_id IS NULL, true, resoconto.id_resoconto) = IFNULL(doc_id, true)
        AND IF(doc_year IS NULL, true, resoconto.anno) = IFNULL(doc_year, true)
        AND IF(customer_id IS NULL, true, resoconto.id_cliente) = IFNULL(customer_id, true)
        AND resoconto.descrizione LIKE CONCAT('%', IFNULL(description, ''), '%')
        AND IFNULL(resoconto.nota, '') LIKE CONCAT('%', IFNULL(notes, ''), '%')
        AND IF(status IS NULL, true, resoconto.stato) = IFNULL(status, true)
        AND IF(doc_date IS NULL, true, resoconto.data) = IFNULL(doc_date, true)
        AND IF(doc_type IS NULL, true, resoconto.tipo_resoconto) = IFNULL(doc_type, true)
        AND (resoconto.nota_fine LIKE CONCAT('%', IFNULL(final_note, ''), '%') OR final_note IS NULL)
    ORDER BY anno DESC, id DESC;
END//
DELIMITER ;
