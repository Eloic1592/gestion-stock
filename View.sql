drop view liste_article;
CREATE or REPLACE VIEW liste_article AS
SELECT 
    m.IDARTICLE,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    tm.val,
    m.MARQUE,
    m.MODELE,
    m.DESCRIPTION,
    m.codearticle,
    m.prix,
    m.quantitestock
FROM 
    ARTICLE m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL;


drop view liste_materiel;
CREATE or REPLACE VIEW liste_materiel AS
SELECT 
    m.IDMATERIEL,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    tm.val,
    m.MARQUE,
    m.MODELE,
    m.numSerie,
    m.prixvente,
    m.caution,
    m.signature,
    m.statut as statutmateriel,
    CASE
        m.STATUT
        WHEN 0 THEN 'LIBRE'
        ELSE 'OCCUPE'
    END AS STATUT
FROM 
    materiel m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL;


drop view liste_typemateriel;
CREATE or REPLACE VIEW liste_typemateriel AS
SELECT 
    t.IDTYPEMATERIEL,
    t.TYPEMATERIEL,
    t.VAL,
    c.IDCATEGORIEMATERIEL,
    c.CATEGORIEMATERIEL,
    c.val as codecat
FROM 
    TYPEMATERIEL T
JOIN 
    CATEGORIEMATERIEL C ON T.IDCATEGORIEMATERIEL = C.IDCATEGORIEMATERIEL;

drop view liste_emplacement;
CREATE or REPLACE VIEW liste_emplacement AS
SELECT 
    t.idemplacement,
    d.depot,
    d.iddepot,
    d.codedep,
    t.codeemp,
    t.capacite,
    t.codebarre
FROM 
    EMPLACEMENT T
JOIN 
    depot d ON T.iddepot = d.iddepot;



DROP VIEW liste_etudiant;
CREATE OR REPLACE VIEW liste_etudiant AS
SELECT
    e.ID as IDETUDIANT,
    e.NOM,
    e.PRENOM,
    e.MAIL,
    e.ADRESSE,
    e.Contact,
    s.VAL as SEXE
FROM ETUDIANT e join SEXE s on e.SEXE=S.ID;


-- Liste nature
Create OR REPLACE VIEW liste_nature AS
SELECT 
    n.idnatureMouvement,
    n.naturemouvement
FROM
    natureMouvement n;


-- Commande
drop view client_commande;
CREATE OR REPLACE view vue_commande as
SELECT
        CD.idcommande,
        CD.datecommande,
        CD.libelle,
        CD.STATUT,
        C.NOM,
        C.NIF,
        C.NUMSTAT,
        C.ADRESSE,
        C.TELEPHONE
FROM COMMANDE  CD JOIN CLIENT C on CD.IDCLIENT=C.IDCLIENT order by CD.datecommande desc; 

-- Detailcommande
drop view detail_commande;
CREATE OR REPLACE view detail_commande as
SELECT
        dc.iddetailcommande,
        dc.idcommande,
        a.marque,
        a.modele,
        a.codearticle,
        a.description as descarticle,
        dc.description,
        dc.quantite,
        dc.pu,
        dc.total
FROM detailcommande dc 
join commande cd on dc.idcommande=cd.idcommande 
join article a on dc.idarticle=a.idarticle ; 


-- Reception des commandes
drop view vue_reception;
CREATE OR REPLACE view vue_reception as
SELECT
    r.idreception,
    r.datereception,
    r.statut,
    r.idcommande
FROM reception r 
join commande cd on r.idcommande=cd.idcommande order by r.datereception desc; 

-- Stockage des commandes
drop view vue_stockage;
CREATE OR REPLACE view vue_stockage as
SELECT
    s.idstockage,
    s.datestockage,
    s.quantite,
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    s.statut,
    CASE 
    s.etatstocke
        WHEN 0 THEN 'ABIME'
        ELSE 'BON ETAT'
    END AS etat
FROM stockage s
join article a on s.idarticle=a.idarticle order by  s.datestockage desc; 


-- Distribution
drop view vue_distribution;
CREATE OR REPLACE view vue_distribution as
SELECT
    d.iddistribution,
    d.datedistribution,
    d.quantite,
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    de.iddepot,
    de.codedep,
    de.depot,
    e.idemplacement,
    e.codeemp,
    d.statut,
    CASE 
    d.etatdistribue
        WHEN 0 THEN 'ABIME'
        ELSE 'BON ETAT'
    END AS etat
FROM distribution d
join article a on d.idarticle=a.idarticle 
left join depot de on de.iddepot=d.iddepot
left join emplacement e on e.idemplacement=d.idemplacement order by d.datedistribution desc;  

-- Inventaire
drop view vue_inventaire;
CREATE OR REPLACE view vue_inventaire as
SELECT
    i.idinventaire,
    i.dateinventaire,
    i.quantitereel,
    i.quantitetheorique,
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    i.statut,
    i.etatinventaire,
    CASE 
    i.etatinventaire
        WHEN 0 THEN 'ABIME'
        ELSE 'BON ETAT'
    END AS etat
FROM inventaire i
join article a on i.idarticle=a.idarticle order by i.dateinventaire desc;



-- Stock reel des produits via stockage et distribution
CREATE OR REPLACE VIEW stock_article as 
SELECT 
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    coalesce(sum(d.quantite),0) as quantitestock,
    a.idtypeMateriel,
    a.TYPEMATERIEL,
    a.val,
    d.etat
    FROM vue_distribution d
    join liste_article a on d.idarticle=a.idarticle group by 
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    a.idtypeMateriel,
    a.TYPEMATERIEL,
    a.val,
    d.etat;

-- Stock par materiel
CREATE OR REPLACE VIEW stock_materiel as 
SELECT 
    m.IDMATERIEL,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    tm.val,
    m.MARQUE,
    m.MODELE,
    m.numSerie,
    m.prixvente,
    m.caution,
    m.signature,
    m.statut as statutmateriel,
    CASE
        m.STATUT
        WHEN 0 THEN 'LIBRE'
        ELSE 'OCCUPE'
    END AS STATUT
FROM 
    materiel m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL
ORDER BY  
    m.statut;


-- Stock par type de materiel
CREATE OR REPLACE VIEW stock_typemateriel as 
select (select count(idtypemateriel) from materiel where statut=0 AND idtypemateriel=t.idtypemateriel) as libre,(select count(idtypemateriel) from materiel where statut=1 AND idtypemateriel=t.idtypemateriel) as occupe,(select count(idtypemateriel) from materiel  WHERE idtypemateriel=t.idtypemateriel) as total,t.idtypemateriel,t.typemateriel from liste_materiel lm right join typemateriel t on lm.idtypemateriel=t.idtypemateriel group by t.idtypemateriel,t.typemateriel;


-- Stock via a l'inventaire des produits
CREATE OR REPLACE VIEW vue_distribution as 
SELECT
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    a.typeMateriel,
    i.quantitereel,
    SUM(CASE WHEN i.etatinventaire = 0 THEN i.quantitereel ELSE 0 END) articleabime,
    SUM(CASE WHEN i.etatinventaire = 1 THEN i.quantitereel ELSE 0 END) articlebonetat,
    i.dateinventaire,
    i.statut,
    i.etat
    FROM vue_inventaire i 
    join liste_article a 
    on i.idarticle=a.idarticle
    group by 
    i.dateinventaire,
    i.etat,
    a.idarticle,
    a.marque,
    a.modele,
    a.codearticle,
    a.typeMateriel,
    i.statut,
    i.quantitereel
    order by i.dateinventaire desc;



-- Etat de stock par annee
CREATE OR REPLACE VIEW etat_stock_annee as 
SELECT 
    EXTRACT(YEAR FROM dateinventaire) AS annee,
    EXTRACT(MONTH FROM dateinventaire) AS mois,
    TO_CHAR(dateinventaire, 'Month') AS moisnom,
    SUM(quantitereel) AS quantitetotale,
    SUM(CASE WHEN s.etatinventaire = 0 THEN s.quantitereel ELSE 0 END) AS articleabime,
    SUM(CASE WHEN s.etatinventaire = 0 THEN s.quantitereel * a.prix ELSE 0 END) AS totalprixabime,
    SUM(CASE WHEN s.etatinventaire = 1 THEN s.quantitereel ELSE 0 END) AS articlebonetat,
    SUM(CASE WHEN s.etatinventaire = 1 THEN s.quantitereel * a.prix ELSE 0 END) AS totalprixbonetat
FROM 
    inventaire s join article a on s.idarticle=a.idarticle 
GROUP BY 
    EXTRACT(YEAR FROM dateinventaire),
    TO_CHAR(dateinventaire, 'Month'),
    EXTRACT(MONTH FROM dateinventaire)
order by EXTRACT(YEAR FROM dateinventaire);

-- Detail etat_stock_annee
CREATE OR REPLACE VIEW etat_detailstock_annee AS 
SELECT 
    tm.idtypeMateriel,
    tm.typeMateriel,
    tm.val,
    EXTRACT(YEAR FROM i.dateinventaire) AS annee,
    EXTRACT(MONTH FROM i.dateinventaire) AS mois,
    TO_CHAR(i.dateinventaire, 'Month') AS moisnom,
    SUM(quantitereel) AS quantitetotale,
    SUM(CASE WHEN i.etatinventaire = 0 THEN i.quantitereel ELSE 0 END) AS articleabime,
    SUM(CASE WHEN i.etatinventaire = 0 THEN i.quantitereel * ia.prix ELSE 0 END) AS totalprixabime,
    SUM(CASE WHEN i.etatinventaire = 1 THEN i.quantitereel ELSE 0 END) AS articlebonetat,
    SUM(CASE WHEN i.etatinventaire = 1 THEN i.quantitereel * ia.prix ELSE 0 END) AS totalprixbonetat
FROM 
    inventaire i
JOIN
    article ia ON i.idarticle = ia.idarticle
JOIN 
    typeMateriel tm ON ia.idtypeMateriel = tm.idtypeMateriel
GROUP BY 
    tm.idtypeMateriel, 
    tm.typeMateriel, EXTRACT(YEAR FROM i.dateinventaire), 
    EXTRACT(MONTH FROM i.dateinventaire),TO_CHAR(i.dateinventaire, 'Month'),
    tm.val
ORDER BY 
    tm.idtypeMateriel, 
    EXTRACT(YEAR FROM i.dateinventaire), 
    EXTRACT(MONTH FROM i.dateinventaire);


-- Stat commande
CREATE OR REPLACE VIEW total_commande_annee AS
SELECT 
    EXTRACT(YEAR FROM datecommande) AS annee,
    EXTRACT(MONTH FROM datecommande) AS mois,
    TO_CHAR(datecommande, 'Month') AS moisnom,
    COUNT(*) AS totalcommandes,
    AVG(COUNT(*)) OVER (PARTITION BY EXTRACT(MONTH FROM datecommande)) AS moyennecommandes
FROM 
    Commande
GROUP BY 
    EXTRACT(YEAR FROM datecommande),
    EXTRACT(MONTH FROM datecommande),
    TO_CHAR(datecommande, 'Month')
ORDER BY    
    EXTRACT(YEAR FROM datecommande),
    EXTRACT(MONTH FROM datecommande) DESC;


-- Commande totale des articles groupee par mois par annee
CREATE OR REPLACE VIEW total_commande_article AS
SELECT 
    EXTRACT(YEAR FROM c.datecommande) AS annee,
    EXTRACT(MONTH FROM c.datecommande) AS mois,
    TO_CHAR(c.datecommande, 'Month') AS moisnom,
    a.idarticle,
    a.marque,
    a.modele,
    a.typemateriel,
    a.codearticle,
    a.val,
    SUM(dc.quantite) AS quantitetotale
FROM 
    commande c
JOIN 
    detailcommande dc ON c.idcommande = dc.idcommande
 RIGHT JOIN 
    liste_article a ON dc.idarticle = a.idarticle
GROUP BY 
    EXTRACT(YEAR FROM c.datecommande),
    EXTRACT(MONTH FROM c.datecommande),
    TO_CHAR(c.datecommande, 'Month'),
    a.idarticle,
    a.marque,
    a.modele,
    a.typemateriel,
    a.codearticle,
    a.val
ORDER BY
    SUM(dc.quantite),
    EXTRACT(YEAR FROM c.datecommande),
    EXTRACT(MONTH FROM c.datecommande) desc;




-- Emplacement
drop view liste_emplacement;
CREATE or REPLACE VIEW liste_emplacement AS
SELECT 
    t.idemplacement,
    d.depot,
    d.iddepot,
    d.codedep,
    t.codeemp,
    t.capacite,
    t.codebarre
FROM 
    EMPLACEMENT T
JOIN 
    depot d ON T.iddepot = d.iddepot;




-- Total des articles par depot
CREATE OR REPLACE VIEW stock_article_depot as 
select coalesce(sum(quantite),0)as quantite,d.iddepot,d.depot from mouvement_physique mp right join depot d on mp.iddepot=d.iddepot group by d.iddepot,d.depot;


drop view mouvement_stock;
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
        e.idetudiant,
        e.nom,
        e.prenom,
        e.mail,
        e.CONTACT,
        e.ADRESSE,
        N.IDNATUREMOUVEMENT,
        N.NATUREMOUVEMENT,
        MS.STATUT
FROM MOUVEMENTSTOCK MS 
join NATUREMOUVEMENT N on ms.IDNATUREMOUVEMENT=N.IDNATUREMOUVEMENT
join liste_etudiant E on ms.idetudiant=e.idetudiant;

drop view mouvement_physique;

CREATE or replace view mouvement_physique as
select dmp.IDDETAILMOUVEMENTPHYSIQUE,
       dmp.DATEDEPOT,
       case dmp.TYPEMOUVEMENT WHEN 1 THEN
           'ENTREE'
           WHEN -1 THEN
            'SORTIE'
        END as MOUVEMENT,
        nm.idnatureMouvement,
       nm.NATUREMOUVEMENT,
       dmp.TYPEMOUVEMENT,
       a.idarticle,
       a.MARQUE,
       a.MODELE,
       a.codearticle,
       dmp.QUANTITE,
       dmp.PU,
       dmp.total,
       d.iddepot,
       d.DEPOT,
       d.codedep,
       dmp.DESCRIPTION,
       dmp.COMMENTAIRE,
       dmp.STATUT
from  DETAILMOUVEMENTPHYSIQUE dmp
          join ARTICLE A on A.IDARTICLE = dmp.IDARTICLE
          join DEPOT d on dmp.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on dmp.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT ORDER BY dmp.DATEDEPOT desc;


drop view mouvement_fictif;
Create or replace view mouvement_fictif as
select dmf.IDDETAILMOUVEMENTFICTIF,
       ms.IDMOUVEMENTSTOCK,
       ms.DATEDEPOT,
       case ms.TYPEMOUVEMENT WHEN 1 THEN
                                 'ENTREE'
                             WHEN -1 THEN
                                 'SORTIE'
           END as MOUVEMENT,
        ms.TYPEMOUVEMENT,
       nm.NATUREMOUVEMENT,
       m.MARQUE,
       m.MODELE,
       m.NUMSERIE,
       d.DEPOT,
       dmf.DATEDEB,
       dmf.DATEFIN,
       dmf.COMMENTAIRE,
       dmf.DESCRIPTION,
       dmf.STATUT
from  DETAILMOUVEMENTFICTIF dmf
          join MOUVEMENTSTOCK ms on ms.IDMOUVEMENTSTOCK = dmf.IDMOUVEMENT
          join LISTE_MATERIEL m on m.IDMATERIEL = dmf.IDMATERIEL
          join DEPOT d on dmf.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on ms.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT ORDER BY ms.DATEDEPOT desc;


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

-- Cycle des mouvements
CREATE OR REPLACE VIEW cycle_mouvement AS 
WITH DateMinMax AS (
    SELECT 
        TO_CHAR(MIN(DATEDEPOT), 'YYYY') AS min_year,
        TO_CHAR(MAX(DATEDEPOT), 'YYYY') AS max_year
    FROM mouvement_physique
),
AllYears AS (
    SELECT 
        TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || min_year), 12 * (LEVEL - 1)), 'YYYY')) AS annee
    FROM DateMinMax
    CONNECT BY LEVEL <= CEIL(MONTHS_BETWEEN(TO_DATE(max_year, 'YYYY'), TO_DATE(min_year, 'YYYY')) / 12) + 1
),
AllMonths AS (
    SELECT 
        TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || annee), LEVEL - 1), 'MM')) AS mois,
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


-- Rupture des articles
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
    la.codearticle,
    COALESCE(ROUND((r.jours_rupture / t.jours_total) * 100, 2), 0) AS Taux_Rupture_Stock
FROM 
    liste_article la
LEFT JOIN 
    CTE_Duree r ON la.IDARTICLE = r.IDARTICLE AND la.MARQUE = r.MARQUE AND la.MODELE = r.MODELE
LEFT JOIN 
    CTE_Total t ON la.IDARTICLE = t.IDARTICLE AND la.MARQUE = t.MARQUE AND la.MODELE = t.MODELE;


-- Rotation de stock
CREATE OR REPLACE  view rotation_stock as
WITH 
CMV_par_annee AS (
    SELECT 
        EXTRACT(YEAR FROM datedepot) AS annee,
        SUM(quantite * PU) AS CMV
    FROM 
        detailmouvementphysique
    WHERE 
        typeMouvement = -1 /* Mouvement de sortie */
        AND EXTRACT(YEAR FROM datedepot) BETWEEN 2011 AND 2024
    GROUP BY 
        EXTRACT(YEAR FROM datedepot)
),
Stock_Acquis_Annuel AS (
    SELECT 
        EXTRACT(YEAR FROM datedepot) AS annee,
        SUM(CASE WHEN typeMouvement = 1 THEN quantite ELSE -quantite END) AS stock_acquis
    FROM 
        detailmouvementphysique
    WHERE 
        EXTRACT(YEAR FROM datedepot) BETWEEN 2011 AND 2024
    GROUP BY 
        EXTRACT(YEAR FROM datedepot)
),
Stock_Final_Annuel AS (
    SELECT 
        a.annee,
        SUM(NVL(b.stock_acquis, 0)) OVER (ORDER BY a.annee ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS stock_final
    FROM 
        (SELECT DISTINCT EXTRACT(YEAR FROM TO_DATE('2011', 'YYYY') + LEVEL - 1) AS annee FROM dual CONNECT BY LEVEL <= 2024 - 2011 + 1) a
    LEFT JOIN 
        Stock_Acquis_Annuel b ON a.annee = b.annee
),
Stock_Moyen_Annuel AS (
    SELECT 
        annee,
        (NVL(LAG(stock_final, 1, 0) OVER (ORDER BY annee), 0) + stock_final) / 2 AS stock_moyen
    FROM 
        Stock_Final_Annuel
)
SELECT 
    cmv.annee,
    cmv.CMV,
    NVL(stock_moyen.stock_moyen, 0) AS stock_moyen,
    CASE 
        WHEN NVL(stock_moyen.stock_moyen, 0) = 0 THEN 0
        ELSE ROUND(cmv.CMV / stock_moyen.stock_moyen, 2)
    END AS rotation_de_stock
FROM 
    CMV_par_annee cmv
LEFT JOIN 
    Stock_Moyen_Annuel stock_moyen ON cmv.annee = stock_moyen.annee
ORDER BY 
    cmv.annee;



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







