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
    m.STATUT
FROM 
    materiel m
JOIN 
    TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL;




-- Vue mouvement de stock[physique-fictif]

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
       nm.NATUREMOUVEMENT,
       a.IDARTICLE,
       a.MARQUE,
       a.MODELE,
        case dmp.TYPEMOUVEMENT WHEN 1 THEN
            dmp.QUANTITE*1
           WHEN -1 THEN
            dmp.QUANTITE*-1
        END as QUANTITE,
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
       e.ID as IDETUDIANT,
       e.NOM,
       e.PRENOM,
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
          join NATUREMOUVEMENT nm on ms.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT
          join ETUDIANT E ON E.ID=dmf.IDETUDIANT;

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
        MS.STATUT
FROM MOUVEMENTSTOCK MS join NATUREMOUVEMENT N on ms.IDNATUREMOUVEMENT=N.IDNATUREMOUVEMENT;


DROP VIEW liste_etudiant;
CREATE OR REPLACE VIEW liste_etudiant AS
SELECT
    e.ID as IDETUDIANT,
    e.NOM,
    e.PRENOM,
    e.MAIL,
    s.VAL as SEXE
FROM ETUDIANT e join SEXE s on e.SEXE=S.ID;


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


