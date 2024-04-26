drop view liste_article;
CREATE or REPLACE VIEW liste_article AS
SELECT 
    m.IDARTICLE,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION
FROM 
    ARTICLE m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL;

drop view liste_typemateriel;
CREATE or REPLACE VIEW liste_typemateriel AS
SELECT 
    t.IDTYPEMATERIEL,
    t.TYPEMATERIEL,
    c.IDCATEGORIEMATERIEL,
    c.CATEGORIEMATERIEL
FROM 
    TYPEMATERIEL T
JOIN 
    CATEGORIEMATERIEL C ON T.IDCATEGORIEMATERIEL = C.IDCATEGORIEMATERIEL;


DROP VIEW liste_materiel;
CREATE or REPLACE VIEW liste_materiel AS
SELECT 
    m.IDMATERIEL,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    m.MARQUE,
    m.MODELE,
    m.NUMSERIE,
    m.DESCRIPTION,
    m.PRIXVENTE,
    m.CAUTION,
    m.SIGNATURE,
    m.STATUT AS ETAT,
    CASE 
    STATUT
        WHEN 0 THEN 'LIBRE'
        ELSE 'OCCUPE'
    END AS STATUT
FROM 
    materiel m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL;


drop view mouvement_physique;
CREATE or replace view mouvement_physique as
select dmp.IDDETAILMOUVEMENTPHYSIQUE,
       dmp.DATEDEPOT,
       dmp.TYPEMOUVEMENT,
       case dmp.TYPEMOUVEMENT WHEN 1 THEN
           'ENTREE'
           WHEN -1 THEN
            'SORTIE'
        END as MOUVEMENT,
        nm.IDNATUREMOUVEMENT,
       nm.NATUREMOUVEMENT,
       a.IDARTICLE,
       a.MARQUE,
       a.MODELE,
        dmp.QUANTITE,
       dmp.PU,
       dmp.TOTAL,
       d.IDDEPOT,
       d.DEPOT,
        dmp.DESCRIPTION,
       dmp.COMMENTAIRE,
       dmp.STATUT
from  DETAILMOUVEMENTPHYSIQUE dmp
          join liste_article A on A.IDARTICLE = dmp.IDARTICLE
          join DEPOT d on dmp.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on dmp.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT
          ORDER BY dmp.DATEDEPOT DESC;




CREATE OR REPLACE view mouvement_stock as
SELECT
        MS.IDMOUVEMENTSTOCK,
        MS.DATEDEPOT,
        ms.TYPEMOUVEMENT as TYPE,
       case ms.TYPEMOUVEMENT WHEN 1 THEN
                                 'ENTREE'
                             WHEN -1 THEN
                                 'SORTIE'
        END as MOUVEMENT,
        N.IDNATUREMOUVEMENT,
        N.TYPEMOUVEMENT,
        N.NATUREMOUVEMENT,
        E.ID as IDETUDIANT,
        E.NOM,
        E.PRENOM,
        E.MAIL,
        E.CONTACT,
        E.ADRESSE,
        MS.STATUT
FROM MOUVEMENTSTOCK MS join NATUREMOUVEMENT N on ms.IDNATUREMOUVEMENT=N.IDNATUREMOUVEMENT join ETUDIANT E on E.ID=MS.IDETUDIANT ORDER BY MS.DATEDEPOT DESC;


DROP VIEW liste_etudiant;
CREATE OR REPLACE VIEW liste_etudiant AS
SELECT
    e.ID as IDETUDIANT,
    e.NOM,
    e.PRENOM,
    e.MAIL,
    s.VAL as SEXE
FROM ETUDIANT e join SEXE s on e.SEXE=S.ID;


drop view mouvement_fictif;
Create or replace view mouvement_fictif as
select dmf.IDDETAILMOUVEMENTFICTIF,
       ms.IDMOUVEMENTSTOCK,
       ms.DATEDEPOT,
       ms.TYPEMOUVEMENT,
       case ms.TYPEMOUVEMENT WHEN 1 THEN
                                 'ENTREE'
                             WHEN -1 THEN
                                 'SORTIE'
           END as MOUVEMENT,
       nm.NATUREMOUVEMENT,
       nm.IDNATUREMOUVEMENT,
       m.MARQUE,
       m.MODELE,
       m.NUMSERIE,
       d.DEPOT,
       m.CAUTION,
       dmf.IDDEPOT,
       dmf.DATEDEB,
       dmf.DATEFIN,
       dmf.IDMATERIEL,
       dmf.COMMENTAIRE,
       dmf.DESCRIPTION,
       dmf.STATUT
from  DETAILMOUVEMENTFICTIF dmf
          join MOUVEMENTSTOCK ms on ms.IDMOUVEMENTSTOCK = dmf.IDMOUVEMENT
          join LISTE_MATERIEL m on m.IDMATERIEL = dmf.IDMATERIEL
          join DEPOT d on dmf.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on ms.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT ORDER BY ms.DATEDEPOT DESC;


-- Facture
drop view client_facture;
Create or replace view client_facture as
select fm.IDFACTUREMATERIEL,
       fm.IDDETAILMOUVEMENTPHYSIQUE,
       fm.DATEFACTURE,
       c.NOM,
       c.TELEPHONE,
       c.NIF,
       c.NUMSTAT,
       c.ADRESSE,
       c.QUITTANCE,
       fm.STATUT
from FACTUREMATERIEL fm
         join client c on fm.IDCLIENT = c.IDCLIENT ORDER BY fm.DATEFACTURE DESC;


drop view detail_facture;
Create or replace  view detail_facture  as
select df.IDDETAILSFACTUREMATERIEL,
       df.IDFACTUREMATERIEL,
       df.IDARTICLE,
       a.MARQUE,
       a.MODELE,
       df.PU,
       df.QUANTITE,
       df.TOTAL
from DETAILSFACTUREMATERIEL df
         join article a on df.IDARTICLE = a.IDARTICLE;

-- Vue paiement
drop view paiement_facture;
Create or  REPLACE view  paiement_facture as
select p.id,
       p.IDFACTUREMATERIEL,
       c.NOM,
       c.ADRESSE,
       c.FAX,
       c.NUMSTAT,
       c.NIF,
       c.TELEPHONE,
       c.RC,
       mp.VAL,
       p.DATEPAIEMENT
from PAIEMENT p
         join CLIENT c on p.IDCLIENT = c.IDCLIENT
         join MODEPAIEMENT mp on p.IDMODEPAIEMENT = mp.ID;

select * from paiement_facture;



-- Devis
drop view client_devis;
CREATE OR REPLACE view client_devis as
SELECT
        d.IDDEVIS,
        c.NOM,
        c.ADRESSE,
        c.NUMSTAT,
        c.NIF,
        c.TELEPHONE,
        d.LIBELLE,
        d.DATEDEVIS
     FROM  DEVIS D  join CLIENT c  on c.IDCLIENT=d.IDCLIENT LEFT OUTER JOIN  proforma p on d.iddevis=p.iddevis WHERE  p.IDDEVIS IS NULL;    

Drop view detail_devis;
Create or replace view detail_devis as
select dv.IDDETAILDEVIS,
       c.IDDEVIS,
       a.MARQUE,
       a.MODELE,
        CASE 
        WHEN dv.DESCRIPTION IS NULL OR dv.DESCRIPTION = '' THEN N'Aucune description'
        ELSE dv.DESCRIPTION
        END AS DESCRIPTION,
       dv.QUANTITE,
       dv.PU,
       dv.TOTAL
from DETAILDEVIS dv
         join ARTICLE a on dv.IDARTICLE = a.IDARTICLE
         join DEVIS c on dv.IDDEVIS = c.IDDEVIS;


-- Proforma
drop view client_proforma;
CREATE OR REPLACE view client_proforma as
SELECT
        p.IDPROFORMA,
        d.IDDEVIS,
        c.NOM,
        c.ADRESSE,
        c.NUMSTAT,
        c.NIF,
        c.TELEPHONE,
        d.LIBELLE,
        p.datevalidation
     FROM PROFORMA P join devis D on p.IDDEVIS=d.IDDEVIS join CLIENT c  on c.IDCLIENT=d.IDCLIENT left outer join BONCOMMANDE b on  b.IDPROFORMA=P.IDPROFORMA WHERE  b.IDPROFORMA IS NULL;


drop view detail_proforma;
CREATE OR REPLACE view detail_proforma as
SELECT
    p.IDPROFORMA,
    d.*
FROM PROFORMA P join DETAIL_DEVIS D on p.IDDEVIS=d.IDDEVIS;


-- Commande
drop view client_commande;
CREATE OR REPLACE view client_commande as
SELECT
        b.IDBONCOMMANDE,
        b.DATEBONCOMMANDE,
        CP.IDPROFORMA,
        C.NOM,
        C.NIF,
        C.NUMSTAT,
        C.ADRESSE,
        C.TELEPHONE,
        CP.DATEVALIDATION
FROM BONCOMMANDE B join PROFORMA CP on b.IDPROFORMA=CP.IDPROFORMA  join devis D on CP.IDDEVIS=d.IDDEVIS join CLIENT c  on c.IDCLIENT=d.IDCLIENT left outer join BONLIVRAISON l on b.IDBONCOMMANDE=l.IDBONCOMMANDE WHERE  l.IDBONCOMMANDE IS NULL;


-- Livraison
drop view client_livraison;
CREATE OR REPLACE view client_livraison as
SELECT
        l.IDBONLIVRAISON,
        l.DATEBONLIVRAISON,
        b.IDBONCOMMANDE,
        CP.IDPROFORMA,
        C.NOM,
        C.NIF,
        C.NUMSTAT,
        C.ADRESSE,
        C.TELEPHONE,
        CP.DATEVALIDATION
FROM BONLIVRAISON L join BONCOMMANDE B on b.IDBONCOMMANDE=l.IDBONCOMMANDE  join PROFORMA CP on b.IDPROFORMA=CP.IDPROFORMA  join devis D on CP.IDDEVIS=d.IDDEVIS join CLIENT c  on c.IDCLIENT=d.IDCLIENT;



-- Stock par article
CREATE OR REPLACE VIEW stock_article as 
WITH dates AS (
    SELECT 
        TRUNC(SYSDATE, 'YYYY') + LEVEL - 1 AS date_day
    FROM 
        dual
    CONNECT BY 
        LEVEL <= ADD_MONTHS(TRUNC(SYSDATE, 'YYYY'), 12) - TRUNC(SYSDATE, 'YYYY')
)
SELECT 
    la.idarticle,
    la.marque,
    la.modele,
    la.description,
    la.IDTYPEMATERIEL,
    la.TYPEMATERIEL,
    EXTRACT(MONTH FROM d.date_day) AS mois,
    TO_CHAR(d.date_day, 'Month') AS mois_nom,
    EXTRACT(YEAR FROM d.date_day) AS annee,
    COALESCE(SUM(quantite), 0) AS quantite
FROM 
    liste_article la
CROSS JOIN 
    dates d
LEFT JOIN 
    detailmouvementphysique dm ON la.idarticle = dm.idarticle AND dm.DATEDEPOT = d.date_day
GROUP BY 
    la.idarticle,
    la.marque,
    la.modele,
    la.description,
    la.IDTYPEMATERIEL,
    la.TYPEMATERIEL,
    TO_CHAR(d.date_day, 'Month'),
    EXTRACT(MONTH FROM d.date_day),
    EXTRACT(YEAR FROM d.date_day);

-- select coalesce(sum(quantite),0) as quantite,la.idarticle,la.marque,la.modele,la.description,la.IDTYPEMATERIEL,la.TYPEMATERIEL
-- from detailmouvementphysique dm  right join liste_article la on la.idarticle=dm.idarticle  group by la.idarticle,la.marque,la.modele,la.description,la.IDTYPEMATERIEL,la.TYPEMATERIEL;

-- Total des articles par depot
CREATE OR REPLACE VIEW stock_article_depot as 
select coalesce(sum(quantite),0)as quantite,d.iddepot,d.depot from mouvement_physique mp right join depot d on mp.iddepot=d.iddepot group by d.iddepot,d.depot;



-- Total des articles par type de materiel par depot
CREATE OR REPLACE VIEW stock_typemateriel_depot as
SELECT COALESCE(SUM(mp.quantite), 0) AS nombre,
       tp.idtypemateriel,
       tp.typemateriel,
       d.iddepot,
       d.depot
FROM typemateriel tp 
CROSS JOIN depot d 
LEFT JOIN liste_article la ON tp.idtypemateriel = la.idtypemateriel 
LEFT JOIN mouvement_physique mp ON la.idarticle = mp.idarticle AND mp.iddepot = d.iddepot
GROUP BY tp.idtypemateriel, tp.typemateriel,d.iddepot,d.depot;


-- Total des articles en entree et en sortie
CREATE OR REPLACE view total_article_entree as 
SELECT 
    EXTRACT(YEAR FROM datedepot) AS annee,
    EXTRACT(MONTH FROM datedepot) AS mois,
    TO_CHAR(datedepot, 'Month') AS nom_mois,
    SUM(CASE WHEN typeMouvement = 1 THEN quantite ELSE 0 END) AS total
FROM 
    detailmouvementphysique
GROUP BY 
    EXTRACT(YEAR FROM datedepot),
    EXTRACT(MONTH FROM datedepot),
    TO_CHAR(datedepot, 'Month')
ORDER BY 
    annee, mois;



CREATE OR REPLACE view total_article_sortie as 
SELECT 
    EXTRACT(YEAR FROM datedepot) AS annee,
    EXTRACT(MONTH FROM datedepot) AS mois,
    TO_CHAR(datedepot, 'Month') AS nom_mois,
    SUM(CASE WHEN typeMouvement = -1 THEN quantite ELSE 0 END) AS total
FROM 
    detailmouvementphysique
GROUP BY 
    EXTRACT(YEAR FROM datedepot),
    EXTRACT(MONTH FROM datedepot),
    TO_CHAR(datedepot, 'Month')
ORDER BY 
    annee, mois;



CREATE OR REPLACE view total_article_mouvement AS
select coalesce(sum(mp.quantite),0) as total,n.idnatureMouvement,n.natureMouvement from detailmouvementphysique mp right join naturemouvement n on mp.idnatureMouvement=n.idnatureMouvement where mp.typeMouvement=1 group by n.idnatureMouvement,n.naturemouvement;


CREATE OR REPLACE view total_materiel AS
select count(*) from liste_materiel;





CREATE OR REPLACE view stat_naturemouvement as 
WITH DateMinMax AS (
    SELECT 
        TO_CHAR(MIN(DATEDEPOT), 'YYYY') AS min_year,
        TO_CHAR(MAX(DATEDEPOT), 'YYYY') AS max_year
    FROM mouvement_physique
),
AllYears AS (
    SELECT 
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || min_year), 12 * (LEVEL - 1)), 'YYYY') AS annee
    FROM DateMinMax
    CONNECT BY LEVEL <= CEIL(MONTHS_BETWEEN(TO_DATE(max_year, 'YYYY'), TO_DATE(min_year, 'YYYY')) / 12) + 1
),
AllMonths AS (
    SELECT 
        CAST(TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || annee), LEVEL - 1), 'MM') AS INT) AS mois,
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || annee), LEVEL - 1), 'MONTH') AS mois_nom,
        CAST(annee AS INT) AS annee
    FROM AllYears
    CONNECT BY LEVEL <= 12
)
SELECT 
    AllMonths.annee,
    AllMonths.mois,
    AllMonths.mois_nom,
    NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.total ELSE 0 END), 0) AS gain,
    NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.total ELSE 0 END), 0) AS depense,
    NVL(SUM(mp.total), 0) AS benefice,
    nm.IDNATUREMOUVEMENT,
    nm.NATUREMOUVEMENT
FROM 
    AllMonths
CROSS JOIN 
    NATUREMOUVEMENT nm
LEFT JOIN 
    mouvement_physique mp ON EXTRACT(MONTH FROM mp.DATEDEPOT) = AllMonths.mois 
                            AND EXTRACT(YEAR FROM mp.DATEDEPOT) = AllMonths.annee 
                            AND nm.IDNATUREMOUVEMENT = mp.IDNATUREMOUVEMENT
GROUP BY 
    AllMonths.annee, AllMonths.mois, AllMonths.mois_nom, nm.IDNATUREMOUVEMENT, nm.NATUREMOUVEMENT
ORDER BY 
    AllMonths.annee, AllMonths.mois, nm.IDNATUREMOUVEMENT;


-- Chiffre d'affaires par jour
-- Depart
WITH TousLesJours AS (
    SELECT 
        TRUNC(LAST_DAY(TO_DATE('01-02-2024', 'DD-MM-YYYY')) - LEVEL + 1) AS jour
    FROM DUAL
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('01-02-2024', 'DD-MM-YYYY')), 'DD'))
)
SELECT 
    TousLesJours.jour,
    SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.total ELSE 0 END) AS gain,
    SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.total ELSE 0 END) AS depense,
    SUM(mp.total) AS chiffre_affaires_total
FROM 
    TousLesJours
LEFT JOIN 
    mouvement_physique mp ON TRUNC(mp.DATEDEPOT) = TousLesJours.jour
GROUP BY 
    TousLesJours.jour
ORDER BY 
    TousLesJours.jour;


-- Liste nature mouvement
Create or replace view liste_nature as 
select IDNATUREMOUVEMENT,
    case TYPEMOUVEMENT WHEN 1 THEN 'PHYSIQUE' WHEN 0 THEN 'FICTIF' END as TYPEMOUVEMENT,
    TYPEMOUVEMENT as TYPE,
    NATUREMOUVEMENT 
    from NATUREMOUVEMENT;


-- Stock par materiel
CREATE OR REPLACE VIEW stock_materiel as 
select (select count(idtypemateriel) from materiel where statut=0 AND idtypemateriel=t.idtypemateriel) as libre,(select count(idtypemateriel) from materiel where statut=1 AND idtypemateriel=t.idtypemateriel) as occupe,(select count(idtypemateriel) from materiel  WHERE idtypemateriel=t.idtypemateriel) as total,t.idtypemateriel,t.typemateriel from liste_materiel lm right join typemateriel t on lm.idtypemateriel=t.idtypemateriel group by t.idtypemateriel,t.typemateriel;


-- Stock materiel par depot
Create OR REPLACE VIEW utilisation_materiel as 
SELECT 
    d.iddepot,
    d.depot,
    COUNT(m.idmateriel) AS totalmateriels,
    COUNT(df.idmateriel) AS materielsutilises,
    CASE 
        WHEN COUNT(m.idmateriel) = 0 THEN 0
        ELSE (COUNT(df.idmateriel) / NULLIF(COUNT(m.idmateriel), 0)) * 100 
    END AS pourcentage_utilisation
FROM 
    depot d
LEFT JOIN 
    DETAILMOUVEMENTFICTIF df ON df.iddepot = d.iddepot
LEFT JOIN 
    liste_materiel m ON m.idmateriel = df.idmateriel
GROUP BY
    d.iddepot, 
    d.depot;
    

-- Cycle des mouvements des articles
Create OR REPLACE VIEW cycle_mouvement as 
WITH DateMinMax AS (
    SELECT 
        TO_CHAR(MIN(DATEDEPOT), 'YYYY') AS min_year,
        TO_CHAR(MAX(DATEDEPOT), 'YYYY') AS max_year
    FROM mouvement_physique
),
AllYears AS (
    SELECT 
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || min_year), 12 * (LEVEL - 1)), 'YYYY') AS annee
    FROM DateMinMax
    CONNECT BY LEVEL <= CEIL(MONTHS_BETWEEN(TO_DATE(max_year, 'YYYY'), TO_DATE(min_year, 'YYYY')) / 12) + 1
),
AllMonths AS (
    SELECT 
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || annee), LEVEL - 1), 'MM') AS mois,
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || annee), LEVEL - 1), 'MONTH') AS mois_nom,
        annee
    FROM AllYears
    CONNECT BY LEVEL <= 12
)
SELECT 
    AllMonths.annee,
    AllMonths.mois,
    AllMonths.mois_nom,
    TO_CHAR(NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.quantite ELSE 0 END), 0), '9999999999999') AS sortie,
    TO_CHAR(NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.quantite ELSE 0 END), 0), '9999999999999') AS entree,
    nm.IDNATUREMOUVEMENT,
    nm.NATUREMOUVEMENT
FROM 
    AllMonths
CROSS JOIN 
    NATUREMOUVEMENT nm
LEFT JOIN 
    mouvement_physique mp ON EXTRACT(MONTH FROM mp.DATEDEPOT) = AllMonths.mois 
                            AND EXTRACT(YEAR FROM mp.DATEDEPOT) = AllMonths.annee 
                            AND nm.IDNATUREMOUVEMENT = mp.IDNATUREMOUVEMENT
GROUP BY 
    AllMonths.annee, AllMonths.mois, AllMonths.mois_nom, nm.IDNATUREMOUVEMENT, nm.NATUREMOUVEMENT
ORDER BY 
    AllMonths.annee, AllMonths.mois, nm.IDNATUREMOUVEMENT;


-- Statistiques type materiel
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



-- Calcul du temps de rupture chaque article en mouvement de chaque un article
CREATE OR REPLACE  view temps_rupture_stock_article as
WITH stock_movements AS (
    SELECT 
        idarticle,
        datedepot,
        typeMouvement,
        quantite as stock_change
    FROM 
        detailmouvementphysique
),    
stock_levels AS (
    SELECT 
        idarticle,
        datedepot,
        SUM(stock_change) OVER (PARTITION BY idarticle ORDER BY datedepot) AS stock_level
    FROM 
        stock_movements
),
sales AS (
    SELECT 
        idarticle,
        datedepot AS sale_date
    FROM 
        stock_movements
    WHERE 
        typeMouvement = -1
),
stock_sales AS (
    SELECT 
        s.idarticle,
        s.sale_date,
        MAX(l.datedepot) AS last_entry_date
    FROM 
        sales s
    JOIN 
        stock_levels l ON s.idarticle = l.idarticle AND l.stock_level > 0
    GROUP BY 
        s.idarticle, s.sale_date
)
SELECT 
    la.IDARTICLE,
    la.IDTYPEMATERIEL,
    la.TYPEMATERIEL,
    la.MARQUE,
    la.MODELE,
    la.DESCRIPTION,
    AVG(EXTRACT(DAY FROM (ss.sale_date - ss.last_entry_date))) as moyenne_jour,
FROM 
    liste_article la
LEFT JOIN 
    stock_sales ss ON la.IDARTICLE = ss.idarticle
GROUP BY 
    la.IDARTICLE, la.IDTYPEMATERIEL, la.TYPEMATERIEL, la.MARQUE, la.MODELE, la.DESCRIPTION;





-- Calcul du taux de rupture de stock de chaque article
CREATE OR REPLACE  view taux_rupture_article as
WITH CTE_Rupture AS (
    SELECT 
        dm.IDARTICLE,
        a.MARQUE,
        a.MODELE,
        dm.DATEDEPOT AS debut_rupture,
        LEAD(dm.DATEDEPOT) OVER (PARTITION BY dm.IDARTICLE ORDER BY dm.DATEDEPOT) - INTERVAL '1' DAY AS fin_rupture
    FROM 
        detailmouvementphysique dm
    JOIN 
        article a ON dm.IDARTICLE = a.IDARTICLE
    WHERE 
        dm.QUANTITE <= 0
),
CTE_Duree AS (
    SELECT 
        IDARTICLE,
        MARQUE,
        MODELE,
        COUNT(*) AS jours_rupture
    FROM 
        CTE_Rupture
    GROUP BY 
        IDARTICLE, MARQUE, MODELE
),
CTE_Total AS (
    SELECT 
        dm.IDARTICLE,
        a.MARQUE,
        a.MODELE,
        COUNT(*) AS jours_total
    FROM 
        detailmouvementphysique dm
    JOIN 
        article a ON dm.IDARTICLE = a.IDARTICLE
    GROUP BY 
        dm.IDARTICLE, a.MARQUE, a.MODELE
)
SELECT 
    la.IDARTICLE,
    la.MARQUE,
    la.MODELE,
    la.DESCRIPTION,
    COALESCE(ROUND((r.jours_rupture / t.jours_total) * 100, 2), 0) AS Taux_Rupture_Stock
FROM 
    liste_article la
LEFT JOIN 
    CTE_Duree r ON la.IDARTICLE = r.IDARTICLE AND la.MARQUE = r.MARQUE AND la.MODELE = r.MODELE
LEFT JOIN 
    CTE_Total t ON la.IDARTICLE = t.IDARTICLE AND la.MARQUE = t.MARQUE AND la.MODELE = t.MODELE;





-- Rotation de stock par mois/annee (Quantite et monetaires)
-- Atao amin'ity rotation de stock ny LIFO sy FIFO 




-- Exemple de requête pour calculer le coût des articles vendus en utilisant FIFO
CREATE OR REPLACE VIEW v_FIFO AS
SELECT 
    m.IDARTICLE,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION,
    EXTRACT(YEAR FROM d.datedepot) AS Annee,
    EXTRACT(MONTH FROM d.datedepot) AS Mois,
    TO_CHAR(d.datedepot, 'Month') AS Nom_Mois,
    COALESCE(SUM(CASE WHEN d.typeMouvement = 1 THEN d.quantite ELSE 0 END), 0) AS total_achetes,
    COALESCE(SUM(CASE WHEN d.typeMouvement = -1 THEN d.quantite ELSE 0 END), 0) AS total_vendus,
    COALESCE(SUM(CASE WHEN d.typeMouvement = 1 THEN d.quantite * d.PU ELSE 0 END), 0) AS total_achetes_valeur,
    COALESCE(SUM(CASE WHEN d.typeMouvement = -1 THEN d.quantite * d.PU ELSE 0 END), 0) AS total_vendus_valeur,
    COALESCE(SUM(d.quantite), 0) AS quantite_stock
FROM 
    liste_article m
LEFT JOIN 
    detailmouvementphysique d ON m.IDARTICLE = d.idarticle
GROUP BY 
    m.IDARTICLE,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION,
    EXTRACT(YEAR FROM d.datedepot),
    EXTRACT(MONTH FROM d.datedepot),
    TO_CHAR(d.datedepot, 'Month');

-- Exemple de requête pour calculer le coût des articles vendus en utilisant LIFO
CREATE OR REPLACE VIEW v_LIFO AS
WITH achats AS (
    SELECT 
        idarticle,
        datedepot,
        quantite,
        PU,
        ROW_NUMBER() OVER (PARTITION BY idarticle ORDER BY datedepot DESC) AS rn
    FROM 
        detailmouvementphysique
    WHERE 
        typeMouvement = 1
),
vendus AS (
    SELECT 
        a.idarticle,
        a.quantite,
        a.PU,
        a.datedepot,
        ROW_NUMBER() OVER (PARTITION BY a.idarticle ORDER BY a.datedepot DESC) AS rn
    FROM 
        achats a
    WHERE 
        a.rn <= (SELECT SUM(d.quantite) FROM detailmouvementphysique d WHERE d.typeMouvement = -1 AND d.idarticle = a.idarticle AND TRUNC(d.datedepot, 'MM') = TRUNC(a.datedepot, 'MM'))
)
SELECT 
    m.IDARTICLE,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION,
    EXTRACT(YEAR FROM v.datedepot) AS Annee,
    EXTRACT(MONTH FROM v.datedepot) AS Mois,
    TO_CHAR(v.datedepot, 'Month') AS Nom_Mois,
    COALESCE(SUM(v.quantite * v.PU), 0) AS cout_vendu
FROM 
    liste_article m
LEFT JOIN 
    vendus v ON m.IDARTICLE = v.idarticle
GROUP BY 
    m.IDARTICLE,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION,
    EXTRACT(YEAR FROM v.datedepot),
    EXTRACT(MONTH FROM v.datedepot),
    TO_CHAR(v.datedepot, 'Month');




DROP VIEW liste_article;
DROP VIEW liste_typemateriel;
DROP VIEW liste_materiel;
DROP VIEW mouvement_physique;
DROP VIEW mouvement_fictif;
DROP VIEW client_facture;
DROP VIEW detail_facture;
DROP VIEW paiement_facture;
DROP VIEW mouvement_stock;
DROP VIEW liste_etudiant;
DROP VIEW client_devis;
DROP VIEW detail_devis;
DROP VIEW client_proforma;
DROP VIEW detail_proforma;
DROP VIEW client_commande;
DROP VIEW client_livraison;
DROP VIEW stock_article;
DROP VIEW stock_materiel;
DROP VIEW stock_article_depot;
DROP VIEW stock_typemateriel_depot;
DROP VIEW stat_naturemouvement;
DROP VIEW liste_nature;
DROP VIEW utilisation_materiel;
DROP VIEW cycle_mouvement;
DROP VIEW stat_typemateriel;
DROP VIEW temps_rupture_stock_article;
DROP VIEW taux_rupture_article;
DROP VIEW rotation_stock;
DROP VIEW v_FIFO;
DROP VIEW v_LIFO;




