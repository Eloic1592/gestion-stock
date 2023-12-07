-- Sequence

Create sequence SEQTYPEMATERIEL start with 1 increment by 1;

Create sequence SEQCATEGORIEMATERIEL start with 1 increment by 1;

Create sequence SEQARTICLE Start with 1 increment by 1;

Create sequence SEQMATERIEL start with 1 increment by 1;

Create sequence SEQDEPOT start with 1 increment by 1;

Create sequence SEQETUDIANT start with 1 increment by 1;

Create sequence SEQNATUREMOUVEMENT start with 1 increment by 1;

Create sequence SEQMOUVEMENT start with 1 increment by 1;

Create sequence SEQDETAILMOUVEMENTPHYSIQUE start with 1 increment by 1;

Create sequence SEQDETAILMOUVEMENTFICTIF start with 1 increment by 1;

Create sequence SEQFACTURE start with 1 increment by 1;

Create sequence SEQDETAILSFACTURE start with 1 increment by 1;

-- Ordinateur,chargeur,clavier,lampe,...
Create table typeMateriel(
    id VARCHAR2(100) primary key not null,
    typeMateriel VARCHAR2(100) not null
);

-- Type materiel bureautique ou materiel informatique ou autre
Create table categorieMateriel(
    id VARCHAR2(100) primary key not null,
    categorieMateriel VARCHAR2(100) not null
);


Create table article(
    id VARCHAR2(50) primary key not null,
    marque VARCHAR2(100) not null,
    modele CLOB,
    description CLOB,
    code CLOB,
    PU number(10,2) not null,
    marque varchar2(100) not null
);


Create table materiel(
    id VARCHAR2(50) primary key not null,
    idtypeMateriel VARCHAR2(100) not null,
    idcategorieMateriel VARCHAR2(100) not null,
    idarticle VARCHAR2(100) not null,
    numSerie VARCHAR2(100) not null,
    prixVente number(10,2) not null,
    caution number(10,2) not null,
    statut VARCHAR2(100) not null,
    couleur VARCHAR2(100) not null
);

ALTER TABLE materiel ADD foreign key(idtypeMateriel) references typeMateriel(id);
ALTER TABLE materiel ADD foreign key(idcategorieMateriel) references categorieMateriel(id);
ALTER TABLE materiel ADD foreign key(idarticle) references article(id);

Create table depot(
    id VARCHAR2(50) primary key not null, 
    depot varchar(100) not null
);


Create table etudiant(
    id VARCHAR2(50) primary key not null,
    nom VARCHAR2(100) not null,
    prenom VARCHAR2(100) not null,
    datenaissance date not null,
    pere varchar(100) not null,
    professionpere varchar(100),
    mere varchar(100) not null,
    professionmere varchar(100),
    adresse varchar(100) not null,
    contact varchar(100),
    email varchar(100),
    chemin varchar(100) not null,
    pays varchar(100) not null,
    niveau integer default 0,
    Numformulaire integer default 0,
    Ecolenianarana varchar(100)
);
-- Table etudiant deja dans la base scol stock

Create table natureMouvement(
    id VARCHAR2(50) primary key not null,
    natureMouvement varchar2(100) not null
);

Create table mouvementStock(
    id VARCHAR2(50) primary key not null,
    dateDepot TIMESTAMP  default current_timestamp,
    typeMouvement INTEGER not null,
    statut VARCHAR2(100) not null
);

ALTER TABLE mouvementStock ADD CONSTRAINT typeMouvementcheck CHECK(typeMouvement IN(1,-1));

-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   id VARCHAR2(50) PRIMARY KEY NOT NULL,
   idmouvement VARCHAR2(50) NOT NULL,
   idnatureMouvement VARCHAR2(50) NOT NULL,
   idarticle VARCHAR2(50) NOT NULL,
   quantite NUMBER(10,2) NOT NULL,
   PU NUMBER(10,2) NOT NULL,
   prixStock NUMBER(10,2) NOT NULL,
   total NUMBER(10,2) NOT NULL,
   iddepot VARCHAR2(50) NOT NULL,
   commentaire CLOB,
   statut VARCHAR2(50) NOT NULL
);


ALTER TABLE detailmouvementphysique ADD foreign key(idmouvement) references mouvementStock(id);
ALTER TABLE detailmouvementphysique ADD foreign key(idnatureMouvement) references natureMouvement(id);
ALTER TABLE detailmouvementphysique ADD foreign key(idarticle) references article(id);
ALTER TABLE detailmouvementphysique ADD foreign key(iddepot) references depot(id);


-- ENTREE SORTIE FICTIF
Create table detailmouvementfictif(
    id VARCHAR2(50) primary key not null,
    idmouvement varchar(50) not null,
    dateDeb TIMESTAMP  default current_timestamp,
    dateFin TIMESTAMP  default null,
    idetudiant varchar(50) not null,
    idnatureMouvement varchar(50) not null,
    caution NUMBER(10,2) DEFAULT 0,
    idmateriel varchar2(50) not null,
    iddepot varchar(50) not null,
    commentaire CLOB,
    statut varchar(50) not null
);
ALTER TABLE detailmouvementfictif ADD foreign key(idmouvement) references mouvementStock(id);
ALTER TABLE detailmouvementfictif ADD foreign key(idetudiant) references etudiant(id);
ALTER TABLE detailmouvementfictif ADD foreign key(idnatureMouvement) references natureMouvement(id);
ALTER TABLE detailmouvementfictif ADD foreign key(idmateriel) references materiel(id);
ALTER TABLE detailmouvementfictif ADD foreign key(iddepot) references depot(id);


Create table facture(
    id VARCHAR2(50) primary key not null,
    dateFacture TIMESTAMP default current_timestamp,
    nomFournisseur VARCHAR2(100) not null,
    idmouvement VARCHAR2(100) not null,
    statut VARCHAR2(50) not null
);

ALTER TABLE facture ADD foreign key(idmouvement) references mouvementStock(id);


Create table detailsfacture(
    id VARCHAR2(50) primary key not null,
    idfacture VARCHAR2(100) not null,
    idarticle VARCHAR2(100) not null,
    quantite number(10,2) not null,
    PU number(10,2) not null,
    total number(10,2) not null
);

ALTER TABLE detailsfacture ADD foreign key(idfacture) references facture(id);
ALTER TABLE detailsfacture ADD foreign key(idarticle) references article(id);

-- Tables

-- Historique
-- Import csv
-- Export csv
-- Statistiques

