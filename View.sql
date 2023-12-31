-- Vue materiel
CREATE VIEW liste_materiel AS
SELECT m.IDMATERIEL,
       tm.TYPEMATERIEL,
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
Create or replace view mouvement_physique as
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


-- Commande
Drop view detail_commande;

Create or replace view detail_commande as
select dc.IDDETAILSCOMMANDE,
       c.DATECOMMANDE,
       a.MARQUE,
       a.MODELE,
       dc.IDCOMMANDE,
       dc.DESCRIPTION,
       dc.QUANTITE,
       dc.PU,
       dc.TOTAL,
       dc.STATUT

from DETAILSCOMMANDE dc
         join ARTICLE a on dc.IDARTICLE = a.IDARTICLE
         join COMMANDE c on dc.IDCOMMANDE = c.IDCOMMANDE;

-- Devis

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

-- Detail bon de commande
drop view v_detail_bon;

CREATE OR REPLACE VIEW v_detail_bon AS
SELECT
    db.IDDETAILBONCOMMANDE,
    db.IDBONCOMMANDE,
    BC.DATEBONCOMMANDE,
    a.MARQUE,
    a.MODELE,
    db.DESCRIPTION,
    db.QUANTITE,
    db.PU,
    db.TOTAL
FROM DETAILBONCOMMANDE db
         JOIN ARTICLE a ON a.IDARTICLE = a.IDARTICLE
         JOIN DETAIL_FACTURE DF ON a.IDARTICLE = DF.IDARTICLE
         JOIN BONCOMMANDE BC ON bc.IDBONCOMMANDE = db.IDBONCOMMANDE;

