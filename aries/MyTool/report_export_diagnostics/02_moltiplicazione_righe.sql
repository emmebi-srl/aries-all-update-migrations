-- Read-only sample: multiplicative effect of the ORIGINAL detail joins.
-- The corrected procedure aggregates each detail family separately.
SELECT conteggi.*,
    GREATEST(n_tecnici, 1) * GREATEST(n_lavori, 1)
        * GREATEST(n_materiali, 1) AS righe_prima_group_by_per_resoconto,
    GREATEST(n_tecnici, 1) * GREATEST(n_lavori, 1)
        * GREATEST(n_materiali, 1) * GREATEST(n_resoconti, 1) AS righe_prima_group_by_totali,
    GREATEST(n_tecnici, 1) * GREATEST(n_materiali, 1) AS fattore_duplicazione_tempo_lavoro,
    GREATEST(n_lavori, 1) * GREATEST(n_materiali, 1) AS fattore_duplicazione_tempo_viaggio,
    GREATEST(n_tecnici, 1) * GREATEST(n_lavori, 1) AS ripetizioni_per_materiale
FROM (
    SELECT campione.id_rapporto, campione.anno, campione.data_esecuzione,
        (SELECT COUNT(*) FROM rapporto_tecnico t
         WHERE t.id_rapporto = campione.id_rapporto AND t.anno = campione.anno) AS n_tecnici,
        (SELECT COUNT(*) FROM rapporto_tecnico_lavoro l
         WHERE l.id_rapporto = campione.id_rapporto AND l.anno = campione.anno) AS n_lavori,
        (SELECT COUNT(*) FROM rapporto_materiale m
         WHERE m.id_rapporto = campione.id_rapporto AND m.anno = campione.anno) AS n_materiali,
        (SELECT COUNT(*) FROM resoconto_rapporto rr
         WHERE rr.id_rapporto = campione.id_rapporto AND rr.anno = campione.anno) AS n_resoconti
    FROM (
        SELECT id_rapporto, anno, data_esecuzione
        FROM rapporto ORDER BY id_rapporto DESC, anno DESC LIMIT 100
    ) AS campione
) AS conteggi
ORDER BY righe_prima_group_by_totali DESC, id_rapporto DESC, anno DESC;
