-- Vue materiel

DROP VIEW liste_materiel;
CREATE VIEW liste_materiel AS
SELECT m.IDMATERIEL,
        tm.IDTYPEMATERIEL,
       tm.TYPEMATERIEL,
       cm.IDCATEGORIEMATERIEL,
       cm.CATEGORIEMATERIEL,
       a.MARQUE,
       a.modele,
       m.numserie,
       m.COULEUR,
       m.DESCRIPTION,
       m.PRIXVENTE,
       m.CAUTION,
       m.STATUT
FROM materiel m
         JOIN TYPEMATERIEL tm ON m.IDTYPEMATERIEL = tm.IDTYPEMATERIEL
         JOIN CATEGORIEMATERIEL cm ON m.IDCATEGORIEMATERIEL = cm.IDCATEGORIEMATERIEL
         JOIN ARTICLE a ON m.IDARTICLE = a.IDARTICLE;

-- Vue mouvement de stock[physique-fictif]

drop view mouvement_physique;
CREATE or replace view mouvement_physique as
select dmp.IDDETAILMOUVEMENTPHYSIQUE,
       ms.IDMOUVEMENTSTOCK,
       ms.DATEDEPOT,
       case ms.TYPEMOUVEMENT WHEN 1 THEN
           'ENTREE'
           WHEN -1 THEN
            'SORTIE'
        END as MOUVEMENT,
       nm.NATUREMOUVEMENT,
       a.MARQUE,
       a.MODELE,
       dmp.QUANTITE,
       dmp.PU,
       dmp.PRIXSTOCK,
       dmp.total,
       d.DEPOT,
       dmp.DESCRIPTION,
       dmp.COMMENTAIRE,
       dmp.STATUT
from  DETAILMOUVEMENTPHYSIQUE dmp
          join MOUVEMENTSTOCK ms on ms.IDMOUVEMENTSTOCK = dmp.IDMOUVEMENT
          join ARTICLE A on A.IDARTICLE = dmp.IDARTICLE
          join DEPOT d on dmp.IDDEPOT = d.IDDEPOT
          join NATUREMOUVEMENT nm on ms.IDNATUREMOUVEMENT = nm.IDNATUREMOUVEMENT;

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
       dmf.DATEDEB,
       dmf.DATEFIN,
       e.ID as IDETUDIANT,
       e.NOM,
       e.PRENOM,
       dmf.COMMENTAIRE,
       dmf.DESCRIPTION,
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


DROP VIEW mouvement_stock;
CREATE OR REPLACE VIEW mouvement_stock AS
SELECT
    ms.IDMOUVEMENTSTOCK,
    ms.DATEDEPOT,
    ms.TYPEMOUVEMENT,
    n.IDNATUREMOUVEMENT,
    n.NATUREMOUVEMENT
FROM MOUVEMENTSTOCK ms
         JOIN NATUREMOUVEMENT n on N.IDNATUREMOUVEMENT = ms.IDNATUREMOUVEMENT;


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
     FROM  DEVIS D  join CLIENT c  on c.IDCLIENT=d.IDCLIENT;    

Drop view detail_devis;
Create or replace view detail_devis as
select dv.IDDETAILDEVIS,
       c.IDDEVIS,
       a.MARQUE,
       a.MODELE,
       dv.DESCRIPTION,
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
        d.*,
        p.datevalidation
     FROM PROFORMA P join client_devis D on p.IDDEVIS=d.IDDEVIS;


drop view detail_proforma;
CREATE OR REPLACE view detail_proforma as
SELECT
    p.IDPROFORMA,
    d.*
FROM PROFORMA P join DETAIL_DEVIS D on p.IDDEVIS=d.IDDEVIS;

drop view client_commande;
CREATE OR REPLACE view client_commande as
SELECT
        c.IDBONCOMMANDE,
        c.DATEBONCOMMANDE,
        CP.IDPROFORMA,
        CP.NOM,
        CP.NIF,
        CP.NUMSTAT,
        CP.ADRESSE,
        CP.TELEPHONE,
        CP.DATEVALIDATION
FROM BONCOMMANDE C join client_proforma CP on c.IDPROFORMA=CP.IDPROFORMA;


drop view client_livraison;
CREATE OR REPLACE view client_livraison as
SELECT
        c.IDBONLIVRAISON,
        c.DATEBONLIVRAISON,
        CP.*
FROM BONLIVRAISON C join client_commande CP on c.IDBONCOMMANDE=CP.IDBONCOMMANDE;

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
        N.IDNATUREMOUVEMENT,
        N.NATUREMOUVEMENT,
        N.TYPEMOUVEMENT,
        MS.STATUT
FROM MOUVEMENTSTOCK MS join NATUREMOUVEMENT N on ms.IDNATUREMOUVEMENT=N.IDNATUREMOUVEMENT;


DROP VIEW liste_materiel;
DROP VIEW mouvement_physique;
DROP VIEW mouvement_fictif;
DROP VIEW client_facture;
DROP VIEW detail_facture;
DROP VIEW paiement_facture;
DROP VIEW v_detail_bon;
DROP VIEW mouvement_stock;
DROP VIEW liste_etudiant;
drop view client_devis;
DROP VIEW detail_devis;
drop view client_proforma;
drop view detail_proforma;
drop view client_commande;












-- Commande
-- DROP VIEW detail_commande;
-- Drop view detail_commande;

-- Create or replace view detail_commande as
-- select dc.IDDETAILSCOMMANDE,
--        c.DATECOMMANDE,
--        a.MARQUE,
--        a.MODELE,
--        dc.IDCOMMANDE,
--        dc.DESCRIPTION,
--        dc.QUANTITE,
--        dc.PU,
--        dc.TOTAL,
--        dc.STATUT
-- from DETAILSCOMMANDE dc
--          join ARTICLE a on dc.IDARTICLE = a.IDARTICLE
--          join COMMANDE c on dc.IDCOMMANDE = c.IDCOMMANDE;


-- Detail bon de commande
-- drop view v_detail_bon;

-- CREATE OR REPLACE VIEW v_detail_bon AS
-- SELECT
--     db.IDDETAILBONCOMMANDE,
--     db.IDBONCOMMANDE,
--     BC.DATEBONCOMMANDE,
--     a.MARQUE,
--     a.MODELE,
--     db.DESCRIPTION,
--     db.QUANTITE,
--     db.PU,
--     db.TOTAL
-- FROM DETAILBONCOMMANDE db
--          JOIN ARTICLE a ON a.IDARTICLE = a.IDARTICLE
--          JOIN DETAIL_FACTURE DF ON a.IDARTICLE = DF.IDARTICLE
--          JOIN BONCOMMANDE BC ON bc.IDBONCOMMANDE = db.IDBONCOMMANDE;
