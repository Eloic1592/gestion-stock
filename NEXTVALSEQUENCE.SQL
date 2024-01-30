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


CREATE OR REPLACE FUNCTION getseqdevis
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDEVIS.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqdetaildevis
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQDETAILDEVIS.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqboncommande
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQBONCOMMANDE.nextval INTO retour FROM dual;
 return retour;
END;


CREATE OR REPLACE FUNCTION getseqbonlivraison
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQBONLIVRAISON.nextval INTO retour FROM dual;
 return retour;
END;

CREATE OR REPLACE FUNCTION getseqmateriel
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQMATERIEL.nextval INTO retour FROM dual;
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

CREATE OR REPLACE FUNCTION getseqfacturemateriel
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQFACTUREMATERIEL.nextval INTO retour FROM dual;
 return retour;
END;

-- 
CREATE OR REPLACE FUNCTION getseqpaiement
 RETURN NUMBER IS
 retour NUMBER;
BEGIN
 SELECT SEQPAIEMENT.nextval INTO retour FROM dual;
 return retour;
END;


-- CREATE OR REPLACE FUNCTION getseqcommande
--  RETURN NUMBER IS
--  retour NUMBER;
-- BEGIN
--  SELECT SEQCOMMANDE.nextval INTO retour FROM dual;
--  return retour;
-- END;

-- CREATE OR REPLACE FUNCTION getseqdetailscommande
--  RETURN NUMBER IS
--  retour NUMBER;
-- BEGIN
--  SELECT SEQDETAILSCOMMANDE.nextval INTO retour FROM dual;
--  return retour;
-- END;

-- CREATE OR REPLACE FUNCTION getseqdetailboncommande
--  RETURN NUMBER IS
--  retour NUMBER;
-- BEGIN
--  SELECT SEQDETAILBONCOMMANDE.nextval INTO retour FROM dual;
--  return retour;
-- END;

-- CREATE OR REPLACE FUNCTION getseqdetailsfacturemateriel
--  RETURN NUMBER IS
--  retour NUMBER;
-- BEGIN
--  SELECT SEQDETAILSFACTUREMATERIEL.nextval INTO retour FROM dual;
--  return retour;
-- END;
