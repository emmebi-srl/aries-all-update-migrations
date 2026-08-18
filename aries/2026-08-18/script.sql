UPDATE resoconto
SET costo_extra = 0
WHERE costo_extra IS NULL;

UPDATE resoconto
SET prezzo_extra = 0
WHERE prezzo_extra IS NULL;

ALTER TABLE resoconto
    MODIFY COLUMN costo_extra DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    MODIFY COLUMN prezzo_extra DECIMAL(10, 2) NOT NULL DEFAULT 0.00;

UPDATE resoconto_totali totals
INNER JOIN resoconto report_group
        ON report_group.id_resoconto = totals.id_resoconto
       AND report_group.anno = totals.anno
SET totals.costo_extra = report_group.costo_extra,
    totals.prezzo_extra = report_group.prezzo_extra;

DROP TRIGGER IF EXISTS trg_afterReportGroupInsert;
DELIMITER //
CREATE TRIGGER trg_afterReportGroupInsert
AFTER INSERT ON resoconto
FOR EACH ROW
BEGIN
    INSERT INTO resoconto_totali
    (
        id_resoconto,
        anno,
        prezzo_manutenzione,
        costo_manutenzione,
        costo_diritto_chiamata,
        prezzo_diritto_chiamata,
        costo_lavoro,
        prezzo_lavoro,
        costo_viaggio,
        prezzo_viaggio,
        costo_materiale,
        prezzo_materiale,
        costo_totale,
        prezzo_totale,
        costo_extra,
        prezzo_extra
    )
    VALUES
    (
        NEW.id_resoconto,
        NEW.anno,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        NEW.costo_extra,
        NEW.prezzo_extra
    );
END//
DELIMITER ;
