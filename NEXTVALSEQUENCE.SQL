CREATE OR REPLACE FUNCTION getseqtypemateriel
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQTYPEMATERIEL.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqcategorieMateriel
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQCATEGORIEMATERIEL.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqarticle
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQARTICLE.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqmateriel
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQMATERIEL.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqcommande
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQCOMMANDE.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqdetailcommande
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDETAILBONCOMMANDE.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqreception
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQRECEPTION.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqstockage
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQSTOCKAGE.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqdistribution
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDISTRIBUTION.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqinventaire
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQINVENTAIRE.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqdepot
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDEPOT.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqnatureMouvement
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQNATUREMOUVEMENT.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqemplacement
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQEMPLACEMENT.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqmouvementStock
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQMOUVEMENTSTOCK.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqdetailmouvementphysique
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDETAILMOUVEMENTPHYSIQUE.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqdetailmouvementfictif
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDETAILMOUVEMENTFICTIF.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqpaiement
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQPAIEMENT.nextval INTO retour FROM dual;
 return retour;
END;

