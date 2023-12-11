-- type materiel
CREATE OR REPLACE FUNCTION getseqtypemateriel
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQTYPEMATERIEL.nextval INTO retour FROM dual;
  return retour;
END;

-- Categorie materiel
CREATE OR REPLACE FUNCTION getseqcategoriemateriel
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQCATEGORIEMATERIEL.nextval INTO retour FROM dual;
  return retour;
END;

-- Article
CREATE OR REPLACE FUNCTION getseqarticle
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQARTICLE.nextval INTO retour FROM dual;
  return retour;
END;

-- Materiel
CREATE OR REPLACE FUNCTION getseqmateriel
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQMATERIEL.nextval INTO retour FROM dual;
  return retour;
END;


-- Depot
CREATE OR REPLACE FUNCTION getseqdepot
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQDEPOT.nextval INTO retour FROM dual;
  return retour;
END;

-- Nature mouvement
CREATE OR REPLACE FUNCTION getseqnaturemouvement
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQNATUREMOUVEMENT.nextval INTO retour FROM dual;
  return retour;
END;

--  mouvement
CREATE OR REPLACE FUNCTION getseqmouvement
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQMOUVEMENT.nextval INTO retour FROM dual;
  return retour;
END;


--Detail  mouvement
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


--  FACTURE
CREATE OR REPLACE FUNCTION getseqfacturemateriel
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQFACTURE.nextval INTO retour FROM dual;
  return retour;
END;

-- DETAILSFACTURE
CREATE OR REPLACE FUNCTION getseqdetailfacturemateriel
  RETURN NUMBER IS
  retour NUMBER;
BEGIN
  SELECT SEQDETAILSFACTURE.nextval INTO retour FROM dual;
  return retour;
END;