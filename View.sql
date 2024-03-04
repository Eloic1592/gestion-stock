-- Vue materiel

drop view liste_article;
CREATE or REPLACE VIEW liste_article AS
SELECT 
    m.IDARTICLE,
    tm.IDTYPEMATERIEL,
    tm.TYPEMATERIEL,
    m.MARQUE,
        CASE 
        WHEN m.MODELE IS NULL OR m.MODELE = '' THEN N'Aucune description'
        ELSE m.MODELE
    END AS MODELE,
    CASE 
        WHEN m.DESCRIPTION IS NULL OR m.DESCRIPTION = '' THEN N'Aucune description'
        ELSE m.DESCRIPTION
    END AS DESCRIPTION
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
        CASE 
        WHEN m.MODELE IS NULL OR m.MODELE = '' THEN N'Aucune description'
        ELSE m.MODELE
    END AS MODELE,
    m.NUMSERIE,
    m.COULEUR,
    CASE 
        WHEN m.DESCRIPTION IS NULL OR m.DESCRIPTION = '' THEN N'Aucune description'
        ELSE m.DESCRIPTION
    END AS DESCRIPTION,
    m.PRIXVENTE,
    m.CAUTION,
    m.SIGNATURE,
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
       dmp.RESTESTOCK,
       d.IDDEPOT,
       d.DEPOT,
        CASE 
        WHEN dmp.DESCRIPTION IS NULL OR dmp.DESCRIPTION = '' THEN N'Aucune description'
        ELSE dmp.DESCRIPTION
        END AS DESCRIPTION,
       dmp.COMMENTAIRE,
       dmp.STATUT
from  DETAILMOUVEMENTPHYSIQUE dmp
          join liste_article A on A.IDARTICLE = dmp.IDARTICLE
          join DEPOT d on dmp.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on dmp.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT;




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
        N.NATUREMOUVEMENT,
        N.TYPEMOUVEMENT,
        E.ID as IDETUDIANT,
        E.NOM,
        E.PRENOM,
        MS.STATUT
FROM MOUVEMENTSTOCK MS join NATUREMOUVEMENT N on ms.IDNATUREMOUVEMENT=N.IDNATUREMOUVEMENT join ETUDIANT E on E.ID=MS.IDETUDIANT;


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
       case ms.TYPEMOUVEMENT WHEN 1 THEN
                                 'ENTREE'
                             WHEN -1 THEN
                                 'SORTIE'
           END as MOUVEMENT,
       nm.NATUREMOUVEMENT,
       m.MARQUE,
       m.MODELE,
       m.NUMSERIE,
       m.COULEUR,
       d.DEPOT,
       m.CAUTION,
       dmf.DATEDEB,
       dmf.DATEFIN,
       dmf.COMMENTAIRE,
        CASE 
        WHEN dmf.DESCRIPTION IS NULL OR dmf.DESCRIPTION = '' THEN N'Aucune description'
        ELSE dmf.DESCRIPTION
        END AS DESCRIPTION,
       dmf.STATUT
from  DETAILMOUVEMENTFICTIF dmf
          join MOUVEMENTSTOCK ms on ms.IDMOUVEMENTSTOCK = dmf.IDMOUVEMENT
          join LISTE_MATERIEL m on m.IDMATERIEL = dmf.IDMATERIEL
          join DEPOT d on dmf.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on ms.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT;


-- Facture
drop view client_facture;
Create or replace view client_facture as
select fm.IDFACTUREMATERIEL,
       fm.IDMOUVEMENT,
       fm.DATEFACTURE,
       c.NOM,
       c.TELEPHONE,
       c.NIF,
       c.NUMSTAT,
       c.ADRESSE,
       c.QUITTANCE,
       fm.STATUT
from FACTUREMATERIEL fm
         join client c on fm.IDCLIENT = c.IDCLIENT;


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
select coalesce(sum(quantite),0) as quantite,la.idarticle,la.marque,la.modele,la.description,la.IDTYPEMATERIEL,la.TYPEMATERIEL
from detailmouvementphysique dm  right join liste_article la on la.idarticle=dm.idarticle  group by la.idarticle,la.marque,la.modele,la.description,la.IDTYPEMATERIEL,la.TYPEMATERIEL;



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



-- Benefice groupee par type de mouvement
CREATE OR REPLACE view stat_naturemouvement as 
WITH TousLesMois AS (
    SELECT 
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || TO_CHAR(SYSDATE, 'YYYY')), LEVEL - 1), 'MM') AS mois,
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || TO_CHAR(SYSDATE, 'YYYY')), LEVEL - 1), 'YYYY') AS annee,
        TO_CHAR(ADD_MONTHS(TO_DATE('01-01-' || TO_CHAR(SYSDATE, 'YYYY')), LEVEL - 1), 'MONTH') AS mois_nom
    FROM DUAL
    CONNECT BY LEVEL <= 12
)
SELECT 
    TousLesMois.annee,
    TousLesMois.mois,
    TousLesMois.mois_nom,
    NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.total ELSE 0 END), 0) AS gain,
    NVL(SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.total ELSE 0 END), 0) AS depense,
    NVL(SUM(mp.total), 0) AS benefice,
    nm.IDNATUREMOUVEMENT,
    nm.NATUREMOUVEMENT
FROM 
    TousLesMois
CROSS JOIN 
    NATUREMOUVEMENT nm
LEFT JOIN 
    mouvement_physique mp ON EXTRACT(MONTH FROM mp.DATEDEPOT) = TousLesMois.mois 
                            AND EXTRACT(YEAR FROM mp.DATEDEPOT) = TousLesMois.annee 
                            AND nm.IDNATUREMOUVEMENT = mp.IDNATUREMOUVEMENT
GROUP BY 
    TousLesMois.annee, TousLesMois.mois, TousLesMois.mois_nom, nm.IDNATUREMOUVEMENT, nm.NATUREMOUVEMENT
ORDER BY 
    TousLesMois.annee, TousLesMois.mois, nm.IDNATUREMOUVEMENT;


WITH DatesMinMax AS (
    SELECT 
        TO_CHAR(MIN(mp.DATEDEPOT), 'YYYY-MM') AS min_date,
        TO_CHAR(MAX(mp.DATEDEPOT), 'YYYY-MM') AS max_date
    FROM 
        mouvement_physique mp
),
ToutesLesDates AS (
    SELECT DISTINCT
        TO_CHAR(mp.DATEDEPOT, 'YYYY-MM') AS mois_annee
    FROM 
        mouvement_physique mp
    CROSS JOIN 
        DatesMinMax
    WHERE 
        TO_CHAR(mp.DATEDEPOT, 'YYYY-MM') BETWEEN DatesMinMax.min_date AND DatesMinMax.max_date
),
GainDepenseBenefice AS (
    SELECT 
        TO_CHAR(mp.DATEDEPOT, 'YYYY-MM') AS mois_annee,
        nm.IDNATUREMOUVEMENT,
        SUM(CASE WHEN mp.TYPEMOUVEMENT = -1 THEN mp.total ELSE 0 END) AS gain,
        SUM(CASE WHEN mp.TYPEMOUVEMENT = 1 THEN mp.total ELSE 0 END) AS depense,
        SUM(mp.total) AS benefice
    FROM 
        mouvement_physique mp
    CROSS JOIN 
        DatesMinMax
    LEFT JOIN 
        NATUREMOUVEMENT nm ON mp.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT
    WHERE 
        TO_CHAR(mp.DATEDEPOT, 'YYYY-MM') BETWEEN DatesMinMax.min_date AND DatesMinMax.max_date
    GROUP BY 
        TO_CHAR(mp.DATEDEPOT, 'YYYY-MM'), nm.IDNATUREMOUVEMENT
)
SELECT 
    ToutesLesDates.mois_annee,
    gdb.IDNATUREMOUVEMENT,
    nm.NATUREMOUVEMENT,
    NVL(SUM(gdb.gain), 0) AS total_gain,
    NVL(SUM(gdb.depense), 0) AS total_depense,
    NVL(SUM(gdb.benefice), 0) AS total_benefice
FROM 
    ToutesLesDates
LEFT JOIN 
    GainDepenseBenefice gdb ON ToutesLesDates.mois_annee = gdb.mois_annee
LEFT JOIN 
    NATUREMOUVEMENT nm ON gdb.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT
GROUP BY 
    ToutesLesDates.mois_annee, gdb.IDNATUREMOUVEMENT, nm.NATUREMOUVEMENT
ORDER BY 
    ToutesLesDates.mois_annee, gdb.IDNATUREMOUVEMENT;




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
    NATUREMOUVEMENT 
    from NATUREMOUVEMENT;


-- Stock par materiel
CREATE OR REPLACE VIEW stock_materiel as 
select (select count(idtypemateriel) from materiel where statut=0 AND idtypemateriel=t.idtypemateriel) as libre,(select count(idtypemateriel) from materiel where statut=1 AND idtypemateriel=t.idtypemateriel) as occupe,(select count(idtypemateriel) from materiel  WHERE idtypemateriel=t.idtypemateriel) as total,t.idtypemateriel,t.typemateriel from liste_materiel lm right join typemateriel t on lm.idtypemateriel=t.idtypemateriel group by t.idtypemateriel,t.typemateriel;


-- Stock materiel par depot
Create OR REPLACEC VIEW pourcentage_utilisation as 


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




