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


-- Type materiel bureautique ou materiel informatique ou autre
CREATE TABLE categorieMateriel(
    idcategorieMateriel VARCHAR2(100) PRIMARY KEY NOT NULL ,
    categorieMateriel VARCHAR2(100) NOT NULL 
);

-- Ordinateur,chargeur,clavier,lampe,...
CREATE TABLE typeMateriel(
    idtypeMateriel VARCHAR2(100) PRIMARY KEY NOT NULL ,
    typeMateriel VARCHAR2(100) NOT NULL,
    idcategorieMateriel VARCHAR2(100) NOT NULL
);

ALTER TABLE typeMateriel ADD FOREIGN KEY (idcategorieMateriel) REFERENCES categorieMateriel(idcategorieMateriel);


CREATE TABLE article(
    idarticle VARCHAR2(50) PRIMARY KEY NOT NULL ,
    marque NVARCHAR2(100),
    modele NVARCHAR2(1000),
    description NVARCHAR2(1000),
    idtypeMateriel VARCHAR2(100) NOT NULL
);

ALTER TABLE article ADD FOREIGN KEY (idtypeMateriel) REFERENCES typeMateriel(idtypeMateriel);

CREATE TABLE materiel(
    idmateriel VARCHAR2(50) PRIMARY KEY NOT NULL ,
    marque NVARCHAR2(100),
    modele NVARCHAR2(1000),
    numSerie VARCHAR2(100) NOT NULL ,
    description NVARCHAR2(1000),
    prixVente number(10,2) NOT NULL ,
    caution number(10,2) NOT NULL ,
    couleur VARCHAR2(100) NOT NULL ,
    statut number DEFAULT 0
);


CREATE TABLE devis(
    iddevis VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idclient varchar2(100) NOT NULL , 
    datedevis TIMESTAMP DEFAULT current_timestamp,
    statut number DEFAULT  0,
    libelle NVARCHAR2(1000)
);

ALTER TABLE devis ADD FOREIGN KEY (idclient) REFERENCES client(idclient);


CREATE TABLE detaildevis(
    iddetaildevis VARCHAR(50) PRIMARY KEY,
    iddevis VARCHAR2(100) NOT NULL ,
    idarticle VARCHAR2(100) NOT NULL ,
    description NVARCHAR2(1000),
    quantite NUMBER(10,2) NOT NULL ,
    PU NUMBER(10,2) DEFAULT  0 NOT NULL ,
    total NUMBER(10,2) DEFAULT  0 NOT NULL 
);

ALTER TABLE detaildevis ADD FOREIGN KEY(iddevis) REFERENCES devis(iddevis);
ALTER TABLE detaildevis ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);

CREATE TABLE proforma(
    idproforma VARCHAR(50) PRIMARY KEY,
    iddevis VARCHAR2(50) NOT NULL,
    datevalidation TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY(iddevis) REFERENCES devis(iddevis)
);


CREATE TABLE boncommande(
    idboncommande VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idproforma VARCHAR2(50) NOT NULL,
    dateboncommande TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE boncommande ADD FOREIGN KEY (idproforma) REFERENCES proforma(idproforma);


CREATE TABLE bonlivraison(
    idbonlivraison VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idboncommande VARCHAR2(100) NOT NULL ,
    datebonlivraison TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE bonlivraison ADD FOREIGN KEY(idboncommande) REFERENCES boncommande(idboncommande);

CREATE TABLE depot(
    iddepot VARCHAR2(50) PRIMARY KEY NOT NULL , 
    depot varchar(100) NOT NULL 
);


CREATE TABLE natureMouvement(
    idnatureMouvement VARCHAR2(50) PRIMARY KEY NOT NULL ,
    natureMouvement varchar2(100) NOT NULL 
);

CREATE TABLE mouvementStock(
    idmouvementStock VARCHAR2(50) PRIMARY KEY NOT NULL ,
    dateDepot TIMESTAMP DEFAULT  current_timestamp,
    typeMouvement number NOT NULL , /*ENTREE OU SORTIE (1,-1)*/
    idnatureMouvement VARCHAR2(50) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE mouvementStock ADD CONSTRAINT typeMouvementcheck CHECK(typeMouvement IN(1,-1));
ALTER TABLE mouvementStock ADD FOREIGN KEY(idnatureMouvement) REFERENCES natureMouvement(idnatureMouvement);


-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   iddetailmouvementphysique VARCHAR2(50) PRIMARY KEY NOT NULL,
   idmouvement VARCHAR2(50) NOT NULL,
   idarticle VARCHAR2(50) NOT NULL,
   quantite NUMBER(10,2)  DEFAULT 0,
   PU NUMBER(10,2)  DEFAULT 0,
   prixStock NUMBER(10,2) DEFAULT 0,
   total NUMBER(10,2)  DEFAULT 0,
   restestock NUMBER(10,2) DEFAULT 0,
   iddepot VARCHAR2(50) NOT NULL,
   description NVARCHAR2(1000),
   commentaire NVARCHAR2(1000),
   statut NUMBER DEFAULT 0
);



ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idmouvement) REFERENCES mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);


-- ENTREE SORTIE FICTIF
CREATE TABLE detailmouvementfictif(
    iddetailmouvementfictif VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idmouvement varchar(50) NOT NULL ,
    dateDeb TIMESTAMP DEFAULT  current_timestamp,
    dateFin TIMESTAMP DEFAULT  NULL,
    idetudiant varchar(50) NOT NULL ,
    caution NUMBER(10,2) ,
    idmateriel varchar2(50) NOT NULL ,
    iddepot varchar(50) NOT NULL,
    description NVARCHAR2(1000),
    commentaire NVARCHAR2(1000),
    statut number DEFAULT  0
);

ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(idmouvement) REFERENCES mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(idetudiant) REFERENCES etudiant(id);
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(idmateriel) REFERENCES materiel(idmateriel);
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);


CREATE TABLE facturemateriel(
    idfacturemateriel VARCHAR2(50) PRIMARY KEY NOT NULL ,
    dateFacture TIMESTAMP DEFAULT  current_timestamp,
    idclient varchar2(100) NOT NULL , 
    idmouvement VARCHAR2(100) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE facturemateriel ADD FOREIGN KEY(idmouvement) REFERENCES mouvementStock(idmouvementStock);
ALTER TABLE facturemateriel ADD FOREIGN KEY(idclient) REFERENCES client(idclient);


CREATE TABLE paiement(
    id VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idclient varchar2(100) NOT NULL ,
    idfacturemateriel varchar2(100) NOT NULL ,
    idmodepaiement varchar(100) NOT NULL ,
    datepaiement timestamp DEFAULT  current_timestamp
);

ALTER TABLE paiement ADD FOREIGN KEY(idclient) REFERENCES client(idclient);
ALTER TABLE paiement ADD FOREIGN KEY(idfacturemateriel) REFERENCES facturemateriel(idfacturemateriel);
ALTER TABLE paiement ADD FOREIGN KEY(idmodepaiement) REFERENCES modepaiement(id);


-- Drop table
DROP TABLE paiement;
DROP TABLE facturemateriel;
DROP TABLE detailmouvementfictif;
DROP TABLE detailmouvementphysique;
DROP TABLE mouvementStock;
DROP TABLE natureMouvement;
DROP TABLE depot;
DROP TABLE materiel;
DROP TABLE bonlivraison;
DROP TABLE boncommande;
DROP TABLE proforma;
DROP TABLE detaildevis;
DROP TABLE devis;
DROP TABLE article;
DROP TABLE typeMateriel;
DROP TABLE categorieMateriel;
