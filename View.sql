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
    s.VAL as SEXE
FROM ETUDIANT e join SEXE s on e.SEXE=S.ID;


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

-- Stock via a l'inventaire des produits
CREATE OR REPLACE VIEW stock_article_inventaire as 
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
    EXTRACT(YEAR FROM c.datecommande),
    EXTRACT(MONTH FROM c.datecommande) DESC,
    a.idarticle;





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



-- Stock par materiel
CREATE OR REPLACE VIEW stock_materiel as 
select (select count(idtypemateriel) from materiel where statut=0 AND idtypemateriel=t.idtypemateriel) as libre,(select count(idtypemateriel) from materiel where statut=1 AND idtypemateriel=t.idtypemateriel) as occupe,(select count(idtypemateriel) from materiel  WHERE idtypemateriel=t.idtypemateriel) as total,t.idtypemateriel,t.typemateriel from liste_materiel lm right join typemateriel t on lm.idtypemateriel=t.idtypemateriel group by t.idtypemateriel,t.typemateriel;



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




