-- Sequence
CREATE SEQUENCE SEQTYPEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQCATEGORIEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQARTICLE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDEVIS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQPROFORMA START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILDEVIS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQBONCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQBONLIVRAISON START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDEPOT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQNATUREMOUVEMENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQMOUVEMENTSTOCK START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILMOUVEMENTPHYSIQUE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILMOUVEMENTFICTIF START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQFACTUREMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILSFACTUREMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQPAIEMENT START WITH 1 INCREMENT BY 1;





-- Ordinateur,chargeur,clavier,lampe,...
Create table typeMateriel(
    idtypeMateriel VARCHAR2(100) PRIMARY KEY NOT NULL ,
    typeMateriel VARCHAR2(100) NOT NULL 
);

-- Type materiel bureautique ou materiel informatique ou autre
Create table categorieMateriel(
    idcategorieMateriel VARCHAR2(100) PRIMARY KEY NOT NULL ,
    categorieMateriel VARCHAR2(100) NOT NULL 
);


Create table article(
    idarticle VARCHAR2(50) PRIMARY KEY NOT NULL ,
    marque VARCHAR2(100) NOT NULL ,
    modele CLOB,
    description CLOB,
    codearticle CLOB
);


Create table devis(
    iddevis VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idclient varchar2(100) NOT NULL , 
    datedevis TIMESTAMP DEFAULT current_timestamp,
    statut number DEFAULT  0
);

Alter table devis add foreign key (idclient) references client(idclient);


Create table detaildevis(
    iddetaildevis varchar(50) PRIMARY KEY,
    iddevis  VARCHAR2(100) NOT NULL ,
    idarticle VARCHAR2(100) NOT NULL ,
    description CLOB,
    quantite number(10,2) NOT NULL ,
    PU number(10,2) DEFAULT  0 NOT NULL ,
    total number(10,2) DEFAULT  0 NOT NULL 
);

ALTER TABLE detaildevis ADD foreign key(iddevis) references devis(iddevis);
ALTER TABLE detaildevis ADD foreign key(idarticle) references article(idarticle);

Create table proforma(
    idproforma VARCHAR(50) PRIMARY KEY,
    iddevis VARCHAR2(50) NOT NULL,
    datevalidation TIMESTAMP DEFAULT current_timestamp
);
ALTER TABLE proforma ADD foreign key(iddevis) references devis(iddevis);


Create table boncommande(
    idboncommande varchar2(100) NOT NULL  PRIMARY KEY,
    idproforma VARCHAR2(50) NOT NULL,
    dateboncommande TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

Alter table boncommande add foreign key (idproforma) references proforma(idproforma);


Create table bonlivraison(
    idbonlivraison varchar2(100) NOT NULL  PRIMARY KEY,
    idboncommande varchar2(100) NOT NULL ,
    datebonlivraison TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);
Alter table bonlivraison add foreign key(idboncommande) references boncommande(idboncommande);


Create table materiel(
    idmateriel VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idtypeMateriel VARCHAR2(100) NOT NULL ,
    idcategorieMateriel VARCHAR2(100) NOT NULL ,
    idarticle VARCHAR2(100) NOT NULL ,
    numSerie VARCHAR2(100) NOT NULL ,
    description clob,
    prixVente number(10,2) NOT NULL ,
    caution number(10,2) NOT NULL ,
    couleur VARCHAR2(100) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE materiel ADD foreign key(idtypeMateriel) references typeMateriel(idtypeMateriel);
ALTER TABLE materiel ADD foreign key(idcategorieMateriel) references categorieMateriel(idcategorieMateriel);
ALTER TABLE materiel ADD foreign key(idarticle) references article(idarticle);


Create table depot(
    iddepot VARCHAR2(50) PRIMARY KEY NOT NULL , 
    depot varchar(100) NOT NULL 
);


Create table natureMouvement(
    idnatureMouvement VARCHAR2(50) PRIMARY KEY NOT NULL ,
    natureMouvement varchar2(100) NOT NULL 
);

Create table mouvementStock(
    idmouvementStock VARCHAR2(50) PRIMARY KEY NOT NULL ,
    dateDepot TIMESTAMP DEFAULT  current_timestamp,
    typeMouvement number NOT NULL , /*ENTREE OU SORTIE (1,-1)*/
    idnatureMouvement VARCHAR2(50) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE mouvementStock ADD CONSTRAINT typeMouvementcheck CHECK(typeMouvement IN(1,-1));
ALTER TABLE mouvementStock ADD foreign key(idnatureMouvement) references natureMouvement(idnatureMouvement);


-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   iddetailmouvementphysique VARCHAR2(50) PRIMARY KEY NOT NULL ,
   idmouvement VARCHAR2(50) NOT NULL ,
   idarticle VARCHAR2(50) NOT NULL ,
   quantite NUMBER(10,2) NOT NULL ,
   PU number(10,2) NOT NULL ,
   prixStock NUMBER(10,2) NOT NULL ,
   total NUMBER(10,2) NOT NULL ,
   iddepot VARCHAR2(50) NOT NULL ,
   description CLOB,
   commentaire CLOB,
   statut number DEFAULT  0
);


ALTER TABLE detailmouvementphysique ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementphysique ADD foreign key(idarticle) references article(idarticle);
ALTER TABLE detailmouvementphysique ADD foreign key(iddepot) references depot(iddepot);


-- ENTREE SORTIE FICTIF
Create table detailmouvementfictif(
    iddetailmouvementfictif VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idmouvement varchar(50) NOT NULL ,
    dateDeb TIMESTAMP DEFAULT  current_timestamp,
    dateFin TIMESTAMP DEFAULT  NULL,
    idetudiant varchar(50) NOT NULL ,
    caution NUMBER(10,2),
    idmateriel varchar2(50) NOT NULL ,
    iddepot varchar(50) NOT NULL ,
    description clob,
    commentaire CLOB,
    statut number DEFAULT  0
);
ALTER TABLE detailmouvementfictif ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementfictif ADD foreign key(idetudiant) references etudiant(id);
ALTER TABLE detailmouvementfictif ADD foreign key(idmateriel) references materiel(idmateriel);
ALTER TABLE detailmouvementfictif ADD foreign key(iddepot) references depot(iddepot);


Create table facturemateriel(
    idfacturemateriel VARCHAR2(50) PRIMARY KEY NOT NULL ,
    dateFacture TIMESTAMPDEFAULT  current_timestamp,
    idclient varchar2(100) NOT NULL , 
    idmouvement VARCHAR2(100) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE facturemateriel ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE facturemateriel ADD foreign key(idclient) references client(idclient);



create table paiement(
    id VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idclient varchar2(100) NOT NULL ,
    idfacturemateriel varchar2(100) NOT NULL ,
    idmodepaiement varchar(100) NOT NULL ,
    datepaiement timestamp DEFAULT  current_timestamp
);

ALTER TABLE paiement ADD foreign key(idclient) references client(idclient);
ALTER TABLE paiement ADD foreign key(idfacturemateriel) references facturemateriel(idfacturemateriel);
ALTER TABLE paiement ADD foreign key(idmodepaiement) references modepaiement(id);

ALTER TABLE article
DROP COLUMN description;

ALTER TABLE article
DROP COLUMN modele;

ALTER TABLE article
DROP COLUMN codearticle;

ALTER TABLE article
ADD modele NVARCHAR2(1000);

ALTER TABLE article
MODIFY (modele NOT NULL);

ALTER TABLE article
ADD description NVARCHAR2(1000);

ALTER TABLE article
ADD (codearticle varchar2(70));

ALTER TABLE article
MODIFY (codearticle NOT NULL);


ALTER TABLE materiel
DROP COLUMN description;

ALTER TABLE materiel
ADD description NVARCHAR2(1000);


ALTER TABLE detailsdevis
DROP COLUMN description;

ALTER TABLE detailsdevis
ADD description NVARCHAR2(1000);

ALTER TABLE detailmouvementphysique
DROP COLUMN description;

ALTER TABLE detailmouvementphysique
ADD description NVARCHAR2(1000);


ALTER TABLE detailmouvementphysique
DROP COLUMN commentaire;

ALTER TABLE detailmouvementphysique
ADD commentaire NVARCHAR2(1000);


ALTER TABLE detailmouvementfictif
DROP COLUMN commentaire;

ALTER TABLE detailmouvementfictif
ADD commentaire NVARCHAR2(1000);

ALTER TABLE detaildevis
DROP COLUMN description;

ALTER TABLE detaildevis
ADD description NVARCHAR2(1000);


ALTER TABLE devis 
ADD libelle NVARCHAR2(1000);

ALTER TABLE naturemouvement 
ADD typeMouvement Integer ;


-- Create table commande(
--     idcommande varchar2(50) NOT NULL  PRIMARY KEY,
--     idclient varchar2(100) NOT NULL , 
--     datecommande timestampDEFAULT  current_timestamp,
--     statut number DEFAULT  0
-- );

-- -- Ici idclient= fournisseur
-- Alter table commande add foreign key (idclient) references client(idclient);

-- CREATE TABLE detailscommande(
--    iddetailscommande varchar(50) NOT NULL  PRIMARY KEY,
--    idcommande varchar2(50) NOT NULL ,
--    idarticle varchar2(50) NOT NULL ,
--    description CLOB,
--    quantite number(10,2) NOT NULL ,
--    PU number(10,2)DEFAULT  0 NOT NULL ,
--    total number(12,2),
--    statut number DEFAULT  0
-- );



-- ALTER TABLE detailscommande ADD foreign key(idcommande) references commande(idcommande);
-- ALTER TABLE detailscommande ADD foreign key(idarticle) references article(idarticle);

-- commande,encore modifiable
-- Create table detailboncommande(
--     iddetailboncommande varchar2(100) NOT NULL  PRIMARY KEY,
--     idboncommande varchar2(100) NOT NULL ,
--     idarticle VARCHAR2(100) NOT NULL ,
--     description clob,
--     quantite number(10,2) NOT NULL ,
--     PU number(10,2) NOT NULL  ,
--     total number(10,2) NOT NULL 
-- );

-- ALTER TABLE detailboncommande ADD foreign key(idarticle) references article(idarticle);
-- Alter table detailboncommande add foreign key(idboncommande) references boncommande(idboncommande);

-- Create table detailsfacturemateriel(
--     iddetailsfacturemateriel VARCHAR2(50) PRIMARY KEY NOT NULL ,
--     idfacturemateriel VARCHAR2(100) NOT NULL ,
--     idarticle VARCHAR2(100) NOT NULL ,
--     quantite number(10,2) NOT NULL ,
--     PU number(10,2) NOT NULL ,
--     total number(10,2) NOT NULL 
-- );
-- ALTER TABLE detailsfacturemateriel ADD foreign key(idfacturemateriel) references facturemateriel(idfacturemateriel);
-- ALTER TABLE detailsfacturemateriel ADD foreign key(idarticle) references article(idarticle);



-- ALTER TABLE detailscommande
-- DROP COLUMN description;

-- ALTER TABLE detailscommande
-- ADD description NVARCHAR2(1000);

-- ALTER TABLE detailboncommande
-- DROP COLUMN description;

-- ALTER TABLE detailboncommande
-- ADD description NVARCHAR2(1000);

-- CREATE SEQUENCE SEQCOMMANDE START WITH 1 INCREMENT BY 1;
-- CREATE SEQUENCE SEQDETAILSCOMMANDE START WITH 1 INCREMENT BY 1;
-- CREATE SEQUENCE SEQDETAILBONCOMMANDE START WITH 1 INCREMENT BY 1;
