CREATE OR REPLACE VIEW stat_typemateriel AS
WITH AllMonths AS (
    SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYY') || '-01-01', 'YYYY-MM-DD') + LEVEL - 1 AS MonthStart
    FROM dual
    CONNECT BY LEVEL <= 365 -- ajustez le nombre de jours pour couvrir toute l'année actuelle
)
SELECT 
    TO_CHAR(AllMonths.MonthStart, 'Month') AS mois,
    tm.TYPEMATERIEL,
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
    TO_CHAR(AllMonths.MonthStart, 'Month'), tm.TYPEMATERIEL, nm.NATUREMOUVEMENT
ORDER BY 
    mois, tm.TYPEMATERIEL, nm.NATUREMOUVEMENT;

