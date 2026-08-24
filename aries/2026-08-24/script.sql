UPDATE rapporto AS report
INNER JOIN rapporto_mobile AS mobile_report
    ON mobile_report.id_rapporto = report.id_rapporto
    AND mobile_report.anno = report.anno
SET
    report.relazione = IFNULL(mobile_report.relazione, ''),
    report.note_generali = IFNULL(mobile_report.note_generali, ''),
    report.appunti = IFNULL(mobile_report.appunti, '')
WHERE report.Id_tipo_sorgente = 2
    AND mobile_report.timestamp_invio >= '2026-08-19 00:00:00'
    AND (
        NOT (report.relazione <=> IFNULL(mobile_report.relazione, ''))
        OR NOT (report.note_generali <=> IFNULL(mobile_report.note_generali, ''))
        OR NOT (report.appunti <=> IFNULL(mobile_report.appunti, ''))
    );
