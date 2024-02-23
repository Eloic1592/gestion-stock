-- ENTREE SORTIE PHYSIQUE
CREATE TABLE detailmouvementphysique(
   iddetailmouvementphysique VARCHAR2(50) PRIMARY KEY NOT NULL,
    typeMouvement number NOT NULL , /*ENTREE OU SORTIE (1,-1)*/
    idnatureMouvement VARCHAR2(50) NOT NULL ,
   datedepot TIMESTAMP DEFAULT current_timestamp,
   idarticle VARCHAR2(50) NOT NULL,
   quantite NUMBER(10,2)  DEFAULT 0,
   PU NUMBER(10,2)  DEFAULT 0,
   total NUMBER(10,2)  DEFAULT 0,
   restestock NUMBER(10,2) DEFAULT 0,
   iddepot VARCHAR2(50) NOT NULL,
   description NVARCHAR2(1000),
   commentaire NVARCHAR2(1000),
   statut NUMBER DEFAULT 0
);


ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idarticle) REFERENCES article(idarticle);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(iddepot) REFERENCES depot(iddepot);
ALTER TABLE detailmouvementphysique ADD FOREIGN KEY(idnatureMouvement) REFERENCES natureMouvement(idnatureMouvement);

