-- Sequence
CREATE SEQUENCE SEQTYPEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQCATEGORIEMATERIEL START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQARTICLE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILSCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDEVIS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILDEVIS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQBONCOMMANDE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQDETAILBONCOMMANDE START WITH 1 INCREMENT BY 1;
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




-- Stock
-- Il y a 19 tables

-- Ordinateur,chargeur,clavier,lampe,...
Create table typeMateriel(
    idtypeMateriel VARCHAR2(100) primary key not null,
    typeMateriel VARCHAR2(100) not null
);

-- Type materiel bureautique ou materiel informatique ou autre
Create table categorieMateriel(
    idcategorieMateriel VARCHAR2(100) primary key not null,
    categorieMateriel VARCHAR2(100) not null
);


Create table article(
    idarticle VARCHAR2(50) primary key not null,
    marque VARCHAR2(100) not null,
    modele CLOB,
    description CLOB,
    codearticle CLOB
);

Create table commande(
    idcommande varchar2(50) not null primary key,
    idclient varchar2(100) not null, 
    datecommande timestamp default current_timestamp,
    statut number default 0
);

-- Ici idclient= fournisseur
Alter table commande add foreign key (idclient) references client(idclient);

Create table detailscommande(
    iddetailscommande varchar(50) not null primary key,
    idcommande varchar2(50) not null,
    idarticle  varchar2(50) not null,
    description clob,
    quantite number(10,2) not null,
    PU number(10,2) not null default 0,
    total number(10,2) not null,
    statut number default 0
);

ALTER TABLE detailscommande ADD foreign key(idcommande) references commande(idcommande);
ALTER TABLE detailscommande ADD foreign key(idarticle) references article(idarticle);

-- commande,encore modifiable


Create table devis(
    iddevis VARCHAR2(50) primary key not null,
    idcommande VARCHAR2(50) not null,
    idclient varchar2(100) not null, 
    datedevis TIMESTAMP default current_timestamp,
    statut number default 0
);

-- Ici idclient= fournisseur
Alter table devis add foreign key (idclient) references client(idclient);


-- 1-Devis,encore modifiable 
-- 2- Le proforma doit etre valider par l'utilisateur pour etre transformer en facture definitive


Create table detaildevis(
    iddetaildevis varchar(50) primary key not null,
    iddevis  VARCHAR2(100) not null,
    idarticle VARCHAR2(100) not null,
    description clob,
    quantite number(10,2) not null,
    PU number(10,2) not null default 0,
    total number(10,2) not null
);

ALTER TABLE detaildevis ADD foreign key(iddevis) references devis(iddevis);
ALTER TABLE detaildevis ADD foreign key(idarticle) references article(idarticle);


Create table boncommande(
    idboncommande varchar2(100) not null primary key,
    idclient varchar2(100) not null, 
    dateboncommande TIMESTAMP default current_timestamp,
    statut number default 0
);

Alter table boncommande add foreign key (idclient) references client(idclient);


Create table detailboncommande(
    iddetailboncommande varchar2(100) not null primary key,
    idboncommande varchar2(100) not null,
    idarticle VARCHAR2(100) not null,
    description clob,
    quantite number(10,2) not null,
    PU number(10,2) not null default 0,
    total number(10,2) not null
);

ALTER TABLE detailboncommande ADD foreign key(idarticle) references article(idarticle);
Alter table detailboncommande add foreign key(idboncommande) references boncommande(idboncommande);


Create table bonlivraison(
    id varchar2(100) not null primary key,
    idclient varchar2(100) not null, 
    idboncommande varchar2(100) not null,
    datebonlivraison TIMESTAMP default current_timestamp,
    statut number default 0
);
Alter table bonlivraison add foreign key (idclient) references client(idclient);
Alter table bonlivraison add foreign key(idboncommande) references boncommande(idboncommande);


Create table materiel(
    idmateriel VARCHAR2(50) primary key not null,
    idtypeMateriel VARCHAR2(100) not null,
    idcategorieMateriel VARCHAR2(100) not null,
    idarticle VARCHAR2(100) not null,
    numSerie VARCHAR2(100) not null,
    description clob,
    prixVente number(10,2) not null,
    caution number(10,2) not null,
    couleur VARCHAR2(100) not null,
    statut number default 0
);

ALTER TABLE materiel ADD foreign key(idtypeMateriel) references typeMateriel(idtypeMateriel);
ALTER TABLE materiel ADD foreign key(idcategorieMateriel) references categorieMateriel(idcategorieMateriel);
ALTER TABLE materiel ADD foreign key(idarticle) references article(idarticle);


Create table depot(
    iddepot VARCHAR2(50) primary key not null, 
    depot varchar(100) not null
);


Create table natureMouvement(
    idnatureMouvement VARCHAR2(50) primary key not null,
    natureMouvement varchar2(100) not null
);

Create table mouvementStock(
    idmouvementStock VARCHAR2(50) primary key not null,
    dateDepot TIMESTAMP  default current_timestamp,
    typeMouvement number not null, /*ENTREE OU SORTIE (1,-1)*/
    idnatureMouvement VARCHAR2(50) NOT NULL,
    statut number default 0
);

ALTER TABLE mouvementStock ADD CONSTRAINT typeMouvementcheck CHECK(typeMouvement IN(1,-1));
ALTER TABLE mouvementStock ADD foreign key(idnatureMouvement) references natureMouvement(idnatureMouvement);


-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   iddetailmouvementphysique VARCHAR2(50) PRIMARY KEY NOT NULL,
   idmouvement VARCHAR2(50) NOT NULL,
   idarticle VARCHAR2(50) NOT NULL,
   quantite NUMBER(10,2) NOT NULL,
   PU number(10,2) not null default 0,
   prixStock NUMBER(10,2) NOT NULL,
   total NUMBER(10,2) NOT NULL,
   iddepot VARCHAR2(50) NOT NULL,
   description clob,
   commentaire CLOB,
   statut number default 0
);


ALTER TABLE detailmouvementphysique ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementphysique ADD foreign key(idarticle) references article(idarticle);
ALTER TABLE detailmouvementphysique ADD foreign key(iddepot) references depot(iddepot);


-- ENTREE SORTIE FICTIF
Create table detailmouvementfictif(
    iddetailmouvementfictif VARCHAR2(50) primary key not null,
    idmouvement varchar(50) not null,
    dateDeb TIMESTAMP  default current_timestamp,
    dateFin TIMESTAMP  default null,
    idetudiant varchar(50) not null,
    caution NUMBER(10,2) DEFAULT 0,
    idmateriel varchar2(50) not null,
    iddepot varchar(50) not null,
    description clob,
    commentaire CLOB,
    statut number default 0
);
ALTER TABLE detailmouvementfictif ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE detailmouvementfictif ADD foreign key(idetudiant) references etudiant(id);
ALTER TABLE detailmouvementfictif ADD foreign key(idmateriel) references materiel(idmateriel);
ALTER TABLE detailmouvementfictif ADD foreign key(iddepot) references depot(iddepot);


Create table facturemateriel(
    idfacturemateriel VARCHAR2(50) primary key not null,
    dateFacture TIMESTAMP default current_timestamp,
    idclient varchar2(100) not null, 
    idmouvement VARCHAR2(100) not null,
    statut number default 0
);

ALTER TABLE facturemateriel ADD foreign key(idmouvement) references mouvementStock(idmouvementStock);
ALTER TABLE facturemateriel ADD foreign key(idclient) references client(idclient);



Create table detailsfacturemateriel(
    iddetailsfacturemateriel VARCHAR2(50) primary key not null,
    idfacturemateriel VARCHAR2(100) not null,
    idarticle VARCHAR2(100) not null,
    quantite number(10,2) not null,
    PU number(10,2) not null default 0,
    total number(10,2) not null
);
ALTER TABLE detailsfacturemateriel ADD foreign key(idfacturemateriel) references facturemateriel(idfacturemateriel);
ALTER TABLE detailsfacturemateriel ADD foreign key(idarticle) references article(idarticle);


create table paiement(
    id VARCHAR2(50) primary key not null,
    idclient varchar2(100) not null,
    idfacturemateriel varchar2(100) not null,
);

ALTER TABLE paiement ADD foreign key(idclient) references client(idclient);
ALTER TABLE paiement ADD foreign key(idfacturemateriel) references facturemateriel(idfacturemateriel);


-- Tables

-- Historique
-- Import csv
-- Export csv
-- Statistiques

