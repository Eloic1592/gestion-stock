-- Categorie de materiel
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Materiel bureautique');
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Materiel Informatique');
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Materiel Sonore');
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Alimentation');
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Luminaires');
INSERT INTO categorieMateriel(idcategorieMateriel,categorieMateriel) values(getseqcategoriemateriel,'Aeration');



-- Type de materiel
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'Ordinateur');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'Imprimante');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'chargeur');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'clavier');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'Ventilateur');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'Baffle');
INSERT INTO typeMateriel(idtypeMateriel,typeMateriel) values(getseqtypemateriel,'Prise');


-- Nature mouvement
INSERT INTO natureMouvement(idnatureMouvement,natureMouvement) values(getseqnatureMouvement,'Don');
INSERT INTO natureMouvement(idnatureMouvement,natureMouvement) values(getseqnatureMouvement,'Transfert');
INSERT INTO natureMouvement(idnatureMouvement,natureMouvement) values(getseqnatureMouvement,'Perte');


-- Depot
INSERT INTO Depot(iddepot,depot) values(getseqdepot,'Bibliotheque');
INSERT INTO Depot(iddepot,depot) values(getseqdepot,'Salle 6');



-- Article
-- Insert test data into the 'article' table
INSERT INTO article (idarticle, marque, modele, description, codearticle)
VALUES (getseqarticle, 'BrandA', 'ModelA', 'DescriptionA', 'CodeA');

INSERT INTO article (idarticle, marque, modele, description, codearticle)
VALUES (getseqarticle, 'BrandB', 'ModelB', 'DescriptionB', 'CodeB');