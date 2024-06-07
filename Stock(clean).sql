-- Sequence
CREATE SEQUENCE SEQTYPEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQCATEGORIEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQARTICLE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILBONCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQRECEPTION START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQSTOCKAGE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDISTRIBUTION START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQINVENTAIRE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDEPOT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQNATUREMOUVEMENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQMOUVEMENTSTOCK START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILMOUVEMENTPHYSIQUE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILMOUVEMENTFICTIF START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQFACTUREMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILSFACTUREMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQPAIEMENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQEMPLACEMENT START WITH 1 INCREMENT BY 1;

-- Type materiel bureautique ou materiel informatique ou autre
CREATE TABLE categorieMateriel(
    idcategorieMateriel VARCHAR2(100) PRIMARY KEY NOT NULL,
    categorieMateriel VARCHAR2(100),
    val VARCHAR2(50)
);

-- Ordinateur,chargeur,clavier,lampe,...
CREATE TABLE typeMateriel(
    idtypeMateriel VARCHAR2(100) PRIMARY KEY NOT NULL ,
    typeMateriel VARCHAR2(100),
    val VARCHAR2(50),
    idcategorieMateriel VARCHAR2(100) NOT NULL
);

ALTER TABLE typeMateriel ADD FOREIGN KEY (idcategorieMateriel) REFERENCES categorieMateriel(idcategorieMateriel);


CREATE TABLE article(
    idarticle VARCHAR2(50) PRIMARY KEY NOT NULL ,
    marque NVARCHAR2(100),
    modele VARCHAR2(1000),
    description VARCHAR2(1000),
    idtypeMateriel VARCHAR2(100) NOT NULL,
    prix NUMBER(15,2) DEFAULT 0,
    quantitestock NUMBER(15,2) DEFAULT 0
);

ALTER TABLE article ADD codearticle varchar2(255);
ALTER TABLE article MODIFY modele NVARCHAR2(1000) DEFAULT 'Modele non precise';
ALTER TABLE article MODIFY description NVARCHAR2(1000) DEFAULT 'Aucune description';
ALTER TABLE article ADD FOREIGN KEY (idtypeMateriel) REFERENCES typeMateriel(idtypeMateriel);

CREATE TABLE materiel(
    idmateriel VARCHAR2(50) PRIMARY KEY NOT NULL,
    marque NVARCHAR2(100),
    modele NVARCHAR2(1000),
    numSerie VARCHAR2(100),
    description VARCHAR2(1000),
    prixvente NUMBER(15,2) DEFAULT 0,
    caution NUMBER(15,2) DEFAULT 0,
    idtypeMateriel VARCHAR2(100) NOT NULL,
    statut NUMBER DEFAULT 0,
    signature NVARCHAR2(500) DEFAULT 'ITU'
);

ALTER TABLE materiel MODIFY modele NVARCHAR2(1000) DEFAULT 'Modele non precise';
ALTER TABLE materiel MODIFY description NVARCHAR2(1000) DEFAULT 'Aucune description';
ALTER TABLE materiel ADD FOREIGN KEY (idtypeMateriel) REFERENCES typeMateriel(idtypeMateriel);


CREATE TABLE depot(
    iddepot VARCHAR2(50) PRIMARY KEY NOT NULL , 
    depot varchar(100) NOT NULL,
    codedep VARCHAR2(50),
    capacite NUMBER(15,2) DEFAULT 0
);
ALTER TABLE depot ADD codebarre VARCHAR2(255);


-- Emplacement dans un depot
CREATE TABLE emplacement(
    idemplacement varchar(50) PRIMARY KEY NOT NULL,
    iddepot VARCHAR2(100) NOT NULL,
    codeemp VARCHAR2(100),
    capacite NUMBER(15,2) DEFAULT 0
);
ALTER TABLE emplacement ADD codebarre VARCHAR2(255);
ALTER TABLE emplacement ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);

-- Commande
CREATE TABLE Commande(
    idcommande VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idclient varchar2(100) NOT NULL , 
    libelle NVARCHAR2(1000),
    datecommande TIMESTAMP DEFAULT current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE Commande ADD FOREIGN KEY (idclient) REFERENCES client(idclient);


CREATE TABLE detailcommande(
    iddetailcommande VARCHAR(50) PRIMARY KEY,
    idcommande VARCHAR2(100) NOT NULL,
    idarticle VARCHAR2(100) NOT NULL ,
    description NVARCHAR2(1000),
    quantite NUMBER(15,2) DEFAULT  0,
    PU NUMBER(15,2) DEFAULT  0,
    total NUMBER(15,2) DEFAULT 0
);

ALTER TABLE detailcommande MODIFY description NVARCHAR2(1000) DEFAULT 'Aucune description';
ALTER TABLE detailcommande ADD FOREIGN KEY(idcommande) REFERENCES Commande(idcommande);
ALTER TABLE detailcommande ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);


-- Reception
CREATE TABLE reception(
    idreception VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idcommande VARCHAR2(100) NOT NULL ,
    datereception TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE reception ADD FOREIGN KEY(idcommande) REFERENCES Commande(idcommande);


-- Stockage
CREATE TABLE stockage(
    idstockage VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idarticle VARCHAR2(100),
    quantite NUMBER(15,2) default 0,
    datestockage TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE stockage ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE stockage ADD etatstocke va DEFAULT 0;
ALTER TABLE stockage ADD idmateriel VARCHAR2(100);
ALTER TABLE stockage ADD FOREIGN KEY(IDMATERIEL) REFERENCES materiel(IDMATERIEL);


-- Repartition des articles 
CREATE TABLE distribution(
    iddistribution VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idarticle VARCHAR2(100),
    quantite NUMBER(15,2) default 0,
    datedistribution TIMESTAMP DEFAULT  current_timestamp,
    iddepot VARCHAR2(100),
    statut number DEFAULT  0
);

ALTER TABLE distribution ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);
ALTER TABLE distribution ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE distribution ADD idemplacement VARCHAR2(100);
ALTER TABLE distribution ADD FOREIGN KEY(idemplacement) REFERENCES emplacement(idemplacement);
ALTER TABLE distribution ADD etatdistribue number DEFAULT 0;
ALTER TABLE distribution ADD idmateriel VARCHAR2(100);
ALTER TABLE distribution ADD FOREIGN KEY(idmateriel) REFERENCES materiel(idmateriel);


-- Inventaire
CREATE TABLE inventaire(
    idinventaire VARCHAR2(100) NOT NULL  PRIMARY KEY,
    idarticle VARCHAR2(100),
    idmateriel varchar2(100),
    quantitereel NUMBER(15,2) default 0,
    quantitetheorique NUMBER(15,2) default 0,
    dateinventaire TIMESTAMP DEFAULT  current_timestamp,
    statut number DEFAULT  0
);

ALTER TABLE inventaire ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE inventaire ADD etatinventaire number DEFAULT 0;
ALTER TABLE inventaire ADD idmateriel VARCHAR2(100);
ALTER TABLE inventaire ADD FOREIGN KEY(idmateriel) REFERENCES materiel(idmateriel);
ALTER TABLE inventaire ADD description NVARCHAR2(1000);


CREATE TABLE natureMouvement(
    idnatureMouvement VARCHAR2(50) PRIMARY KEY NOT NULL ,
    natureMouvement varchar2(100) NOT NULL,
    typeMouvement NUMBER DEFAULT 0
);

-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   iddetailmouvementphysique VARCHAR2(50) PRIMARY KEY NOT NULL,
   typeMouvement NUMBER NOT NULL CHECK (typeMouvement in(1,-1)), /*ENTREE OU SORTIE (1,-1)*/
   idnatureMouvement VARCHAR2(50) NOT NULL ,
   datedepot TIMESTAMP DEFAULT current_timestamp,
   idarticle VARCHAR2(50) NOT NULL,
   quantite NUMBER(15,2)  DEFAULT 0,
   PU NUMBER(15,2)  DEFAULT 0,
   total NUMBER(15,2)  DEFAULT 0,
   iddepot VARCHAR2(50) NOT NULL,
   description NVARCHAR2(1000),
   commentaire NVARCHAR2(1000), 
   statut NUMBER DEFAULT 0
);

ALTER TABLE detailmouvementphysique MODIFY commentaire NVARCHAR2(1000) DEFAULT 'Aucun commentaire';
ALTER TABLE detailmouvementphysique MODIFY description NVARCHAR2(1000) DEFAULT 'Aucune description';
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idnatureMouvement) REFERENCES natureMouvement(idnatureMouvement);


CREATE TABLE mouvementStock(
    idmouvementStock VARCHAR2(50) PRIMARY KEY NOT NULL,
    dateDepot TIMESTAMP DEFAULT  current_timestamp,
    typeMouvement number NOT NULL CHECK (typeMouvement in(1,-1)), 
    idetudiant VARCHAR2(50) NOT NULL ,
    idnatureMouvement VARCHAR2(50) NOT NULL ,
    statut number DEFAULT  0
);

ALTER TABLE mouvementStock ADD CONSTRAINT typeMouvementcheck CHECK(typeMouvement IN(1,-1));
ALTER TABLE mouvementStock ADD FOREIGN KEY(idnatureMouvement) REFERENCES natureMouvement(idnatureMouvement);
ALTER TABLE mouvementStock ADD FOREIGN KEY(idetudiant) REFERENCES etudiant(id);


-- ENTREE SORTIE FICTIF
CREATE TABLE detailmouvementfictif(
    iddetailmouvementfictif VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idmouvement varchar(50) NOT NULL ,
    dateDeb TIMESTAMP DEFAULT  current_timestamp,
    dateFin TIMESTAMP DEFAULT  current_timestamp,
    caution NUMBER(15,2) DEFAULT  0,
    idmateriel varchar2(50) NOT NULL,
    iddepot varchar(50) NOT NULL,
    description NVARCHAR2(1000),
    commentaire NVARCHAR2(1000),
    statut number DEFAULT  0
);

ALTER TABLE detailmouvementfictif MODIFY commentaire NVARCHAR2(1000) DEFAULT 'Aucun commentaire';
ALTER TABLE detailmouvementfictif MODIFY description NVARCHAR2(1000) DEFAULT 'Aucune description';
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(idmouvement) REFERENCES mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(idmateriel) REFERENCES materiel(idmateriel);
ALTER TABLE detailmouvementfictif ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);




CREATE TABLE paiement(
    id VARCHAR2(50) PRIMARY KEY NOT NULL ,
    idfacturemateriel varchar2(100) NOT NULL ,
    idmodepaiement varchar(100) NOT NULL ,
    datepaiement timestamp DEFAULT  current_timestamp
);

ALTER TABLE paiement ADD FOREIGN KEY(idfacturemateriel) REFERENCES facturemateriel(idfacturemateriel);
ALTER TABLE paiement ADD FOREIGN KEY(idmodepaiement) REFERENCES modepaiement(id);


-- Supprimer les tables avec les contraintes les plus profondes en premier
DROP TABLE paiement CASCADE CONSTRAINTS;
DROP TABLE detailmouvementfictif CASCADE CONSTRAINTS;
DROP TABLE mouvementStock CASCADE CONSTRAINTS;
DROP TABLE detailmouvementphysique CASCADE CONSTRAINTS;
DROP TABLE inventaire CASCADE CONSTRAINTS;
DROP TABLE distribution CASCADE CONSTRAINTS;
DROP TABLE stockage CASCADE CONSTRAINTS;
DROP TABLE reception CASCADE CONSTRAINTS;
DROP TABLE detailcommande CASCADE CONSTRAINTS;
DROP TABLE Commande CASCADE CONSTRAINTS;
DROP TABLE emplacement CASCADE CONSTRAINTS;
DROP TABLE depot CASCADE CONSTRAINTS;
DROP TABLE materiel CASCADE CONSTRAINTS;
DROP TABLE article CASCADE CONSTRAINTS;
DROP TABLE typeMateriel CASCADE CONSTRAINTS;
DROP TABLE categorieMateriel CASCADE CONSTRAINTS;
DROP TABLE natureMouvement CASCADE CONSTRAINTS;


-- Alter
ALTER TABLE naturemouvement 
ADD typeMouvement Integer ;


-- Delete
DELETE FROM paiement;

DELETE FROM facturemateriel;

DELETE FROM detailmouvementfictif;

DELETE FROM detailmouvementphysique;

DELETE FROM mouvementStock;

DELETE FROM natureMouvement;

DELETE FROM depot;

DELETE FROM bonlivraison;

DELETE FROM boncommande;

DELETE FROM proforma;

DELETE FROM detaildevis;

DELETE FROM devis;

DELETE FROM materiel;

DELETE FROM article;

DELETE FROM typeMateriel;

DELETE FROM categorieMateriel;


