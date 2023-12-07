-- type materiel
CREATE OR REPLACE FUNCTION getseqtypemateriel
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'TYP: ' || TO_CHAR(SEQTYPEMATERIEL.NEXTVAL) INTO retour FROM dual;
   return retour;
END;

-- Categorie materiel
CREATE OR REPLACE FUNCTION getseqcategoriemateriel
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'CAT: ' || TO_CHAR(SEQCATEGORIEMATERIEL.NEXTVAL) INTO retour FROM dual;
   return retour;
END;

-- Article
CREATE OR REPLACE FUNCTION getseqarticle
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'ART: ' || TO_CHAR(SEQARTICLE.NEXTVAL) INTO retour FROM dual;
   return retour;
END;


-- Materiel
CREATE OR REPLACE FUNCTION getseqmateriel
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'MAT: ' || TO_CHAR(SEQMATERIEL.NEXTVAL) INTO retour FROM dual;
   return retour;
END;


-- Depot
CREATE OR REPLACE FUNCTION getseqdepot
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'DEP: ' || TO_CHAR(SEQDEPOT.NEXTVAL) INTO retour FROM dual;
   return retour;
END;

-- Nature mouvement
CREATE OR REPLACE FUNCTION getseqnaturemouvement
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'NTM: ' || TO_CHAR(SEQNATUREMOUVEMENT.NEXTVAL) INTO retour FROM dual;
   return retour;
END;


--  mouvement
CREATE OR REPLACE FUNCTION getseqmouvement
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'MVT: ' || TO_CHAR(SEQMOUVEMENT.NEXTVAL) INTO retour FROM dual;
   return retour;
END;


--Detail  mouvement
CREATE OR REPLACE FUNCTION getseqdetailmouvementphysique
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'MVP: ' || TO_CHAR(SEQDETAILMOUVEMENTPHYSIQUE.NEXTVAL) INTO retour FROM dual;
   return retour;
END;


CREATE OR REPLACE FUNCTION getseqdetailmouvementfictif
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'MVF: ' || TO_CHAR(SEQDETAILMOUVEMENTFICTIF.NEXTVAL) INTO retour FROM dual;
   return retour;
END;

--  FACTURE
CREATE OR REPLACE FUNCTION getseqfacture
   RETURN VARCHAR2 IS
   retour VARCHAR2(100);
BEGIN
   SELECT 'FAC: ' || TO_CHAR(SEQFACTURE.NEXTVAL) INTO retour FROM dual;
   return retour;
END;
