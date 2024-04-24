CREATE OR REPLACE VIEW vue_stock_initial_debut_mois AS
SELECT 
    EXTRACT(YEAR FROM dm.datedepot) AS annee,
    EXTRACT(MONTH FROM dm.datedepot) AS mois,
    coalesce(SUM(quantite),0) AS stockinitial,
    coalesce(SUM(total),0) AS prixinitial
FROM 
    detailmouvementphysique dm
WHERE
    NOT EXISTS (
        SELECT 1
        FROM detailmouvementphysique dm2
        WHERE dm2.datedepot < dm.datedepot
        AND EXTRACT(YEAR FROM dm2.datedepot) = EXTRACT(YEAR FROM dm.datedepot)
        AND EXTRACT(MONTH FROM dm2.datedepot) = EXTRACT(MONTH FROM dm.datedepot)
    )
GROUP BY 
    EXTRACT(YEAR FROM dm.datedepot),
    EXTRACT(MONTH FROM dm.datedepot);




CREATE OR REPLACE VIEW vue_stock_final_fin_mois AS
SELECT 
    EXTRACT(YEAR FROM dm.datedepot) AS annee,
    EXTRACT(MONTH FROM dm.datedepot) AS mois,
    coalesce(SUM(quantite),0) AS stockfinal,
    coalesce(SUM(total),0) AS prixfinal
FROM 
    detailmouvementphysique dm
WHERE
    NOT EXISTS (
        SELECT 1
        FROM detailmouvementphysique dm2
        WHERE dm2.datedepot > dm.datedepot
        AND EXTRACT(YEAR FROM dm2.datedepot) = EXTRACT(YEAR FROM dm.datedepot)
        AND EXTRACT(MONTH FROM dm2.datedepot) = EXTRACT(MONTH FROM dm.datedepot)
    )
GROUP BY 
    EXTRACT(YEAR FROM dm.datedepot),
    EXTRACT(MONTH FROM dm.datedepot);



CREATE OR REPLACE VIEW quantite_vendu_Mois AS 
SELECT 
    EXTRACT(YEAR FROM dm.datedepot) AS annee,
    EXTRACT(MONTH FROM dm.datedepot) AS mois,
    SUM(CASE WHEN dm.typeMouvement = -1 THEN dm.quantite ELSE 0 END) AS quantitevendue,
    SUM(CASE WHEN dm.typeMouvement = -1 THEN dm.total ELSE 0 END) AS prixtotalvendus
FROM 
    detailmouvementphysique dm
WHERE
    NOT EXISTS (
        SELECT 1
        FROM detailmouvementphysique dm2
        WHERE dm2.datedepot > dm.datedepot
        AND EXTRACT(YEAR FROM dm2.datedepot) = EXTRACT(YEAR FROM dm.datedepot)
        AND EXTRACT(MONTH FROM dm2.datedepot) = EXTRACT(MONTH FROM dm.datedepot)
    )
GROUP BY 
    EXTRACT(YEAR FROM dm.datedepot),
    EXTRACT(MONTH FROM dm.datedepot);



