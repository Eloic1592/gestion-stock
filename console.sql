

CREATE OR REPLACE VIEW stat_typemateriel AS
WITH AllMonths AS (
    SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-01-01', 'YYYY-MM-DD') + LEVEL - 1 AS MonthStart
    FROM dual
    CONNECT BY LEVEL <= 365 -- ajustez le nombre de jours pour couvrir toute l'année actuelle
)
SELECT 
    EXTRACT(MONTH FROM AllMonths.MonthStart) AS mois_numero, -- Ajout du numéro du mois
    TO_CHAR(AllMonths.MonthStart, 'Month') AS mois,
    tm.TYPEMATERIEL,
    nm.idnaturemouvement,
    nm.NATUREMOUVEMENT,
    COALESCE(SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.TOTAL ELSE 0 END), 0) AS DEPENSE,
    COALESCE(SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.TOTAL ELSE 0 END), 0) AS GAIN
FROM 
    AllMonths
CROSS JOIN 
    TYPEMATERIEL tm
CROSS JOIN 
    NATUREMOUVEMENT nm
LEFT JOIN 
    mouvement_physique mp ON EXTRACT(MONTH FROM mp.DATEDEPOT) = EXTRACT(MONTH FROM AllMonths.MonthStart)
                            AND EXTRACT(YEAR FROM mp.DATEDEPOT) = EXTRACT(YEAR FROM AllMonths.MonthStart)
                            AND nm.IDNATUREMOUVEMENT = mp.IDNATUREMOUVEMENT
LEFT JOIN 
    article a ON a.IDARTICLE = mp.IDARTICLE AND tm.IDTYPEMATERIEL = a.IDTYPEMATERIEL
WHERE 
    EXTRACT(YEAR FROM AllMonths.MonthStart) = EXTRACT(YEAR FROM SYSDATE) -- Ajout de la condition pour l'année actuelle
GROUP BY 
    EXTRACT(MONTH FROM AllMonths.MonthStart), TO_CHAR(AllMonths.MonthStart, 'Month'), tm.TYPEMATERIEL, nm.NATUREMOUVEMENT,nm.idnaturemouvement
ORDER BY 
    mois_numero, tm.TYPEMATERIEL, nm.NATUREMOUVEMENT;









CREATE OR REPLACE VIEW stat_typemateriel AS
WITH AllMonths AS (
    SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-01-01', 'YYYY-MM-DD') + LEVEL - 1 AS MonthStart
    FROM dual
    CONNECT BY LEVEL <= 365 -- ajustez le nombre de jours pour couvrir toute l'année actuelle
)
SELECT 
    EXTRACT(MONTH FROM AllMonths.MonthStart) AS mois_numero, -- Ajout du numéro du mois
    TO_CHAR(AllMonths.MonthStart, 'Month') AS mois,
    tm.TYPEMATERIEL,
    a.idtypeMateriel, -- Ajout de l'id du type de matériel
    nm.idnaturemouvement,
    nm.NATUREMOUVEMENT,
    COALESCE(SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.TOTAL ELSE 0 END), 0) AS DEPENSE,
    COALESCE(SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.TOTAL ELSE 0 END), 0) AS GAIN
FROM 
    AllMonths
CROSS JOIN 
    TYPEMATERIEL tm
CROSS JOIN 
    NATUREMOUVEMENT nm
LEFT JOIN 
    mouvement_physique mp ON EXTRACT(MONTH FROM mp.DATEDEPOT) = EXTRACT(MONTH FROM AllMonths.MonthStart)
                            AND EXTRACT(YEAR FROM mp.DATEDEPOT) = EXTRACT(YEAR FROM AllMonths.MonthStart)
                            AND nm.IDNATUREMOUVEMENT = mp.IDNATUREMOUVEMENT
LEFT JOIN 
    article a ON a.IDARTICLE = mp.IDARTICLE
LEFT JOIN 
    typeMateriel t ON a.idtypeMateriel = t.idtypeMateriel 
WHERE 
    EXTRACT(YEAR FROM AllMonths.MonthStart) = EXTRACT(YEAR FROM SYSDATE) 
GROUP BY 
    EXTRACT(MONTH FROM AllMonths.MonthStart), TO_CHAR(AllMonths.MonthStart, 'Month'), tm.TYPEMATERIEL, a.idtypeMateriel, nm.NATUREMOUVEMENT, nm.idnaturemouvement
ORDER BY 
    mois_numero, tm.TYPEMATERIEL, nm.NATUREMOUVEMENT;




CREATE OR REPLACE VIEW stat_typemateriel AS
WITH AllMonths AS (
    SELECT TO_CHAR(TO_DATE('2024-01-01', 'YYYY-MM-DD') + INTERVAL '1' MONTH * (LEVEL - 1), 'YYYY-MM') AS MonthStart
    FROM dual
    CONNECT BY TO_DATE('2024-01-01', 'YYYY-MM-DD') + INTERVAL '1' MONTH * (LEVEL - 1) <= TRUNC(SYSDATE, 'MM')
)
SELECT 
    EXTRACT(YEAR FROM TO_DATE(AllMonths.MonthStart, 'YYYY-MM')) AS annee,
    EXTRACT(MONTH FROM TO_DATE(AllMonths.MonthStart, 'YYYY-MM')) AS mois_numero,
    TO_CHAR(TO_DATE(AllMonths.MonthStart, 'YYYY-MM'), 'Month') AS mois,
    nm.idnatureMouvement,
    nm.natureMouvement,
    a.idtypeMateriel,
    tm.typeMateriel,
    COALESCE(SUM(CASE WHEN dmp.typeMouvement = 1 THEN dmp.total ELSE 0 END), 0) AS depense,
    COALESCE(SUM(CASE WHEN dmp.typeMouvement = -1 THEN dmp.total ELSE 0 END), 0) AS gain
FROM 
    AllMonths
CROSS JOIN 
    natureMouvement nm
CROSS JOIN 
    article a
LEFT JOIN 
    detailmouvementphysique dmp ON TO_CHAR(dmp.datedepot, 'YYYY-MM') = AllMonths.MonthStart
                            AND nm.idnatureMouvement = dmp.idnatureMouvement
                            AND a.idarticle = dmp.idarticle
LEFT JOIN 
    typeMateriel tm ON a.idtypeMateriel = tm.idtypeMateriel
GROUP BY 
    EXTRACT(YEAR FROM TO_DATE(AllMonths.MonthStart, 'YYYY-MM')),
    EXTRACT(MONTH FROM TO_DATE(AllMonths.MonthStart, 'YYYY-MM')),
    TO_CHAR(TO_DATE(AllMonths.MonthStart, 'YYYY-MM'), 'Month'),
    nm.idnatureMouvement,
    a.idtypeMateriel,
    tm.typeMateriel
ORDER BY 
    annee, mois_numero, nm.idnatureMouvement,nm.natureMouvement, a.idtypeMateriel;

