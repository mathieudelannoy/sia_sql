/*
REGIE
*/

-- sélectionne les relations d'individus pour les régies orphelins
SELECT * FROM app.regie_individu AS "c"
WHERE EXISTS (
  SELECT *
  FROM 
  (SELECT a.id
  FROM app.regie AS "a"
  WHERE NOT EXISTS (
    SELECT NULL
    FROM app.traitement AS "b"
    WHERE a.id = b.id_regie) 
    ) AS "d"
  WHERE d.id = c.regie_id);
 
-- supprime les relations d'individus pour les régies orphelins
DELETE FROM app.regie_individu AS "c"
WHERE EXISTS (
  SELECT *
  FROM (
  SELECT a.id
  FROM app.regie AS "a"
  WHERE NOT EXISTS (
    SELECT NULL
    FROM app.traitement AS "b"
    WHERE a.id = b.id_regie) 
    ) AS "d"
  WHERE d.id = c.regie_id);

-- montre les régies orphelines 
SELECT a.id
FROM app.regie AS "a"
WHERE NOT EXISTS (
  SELECT NULL
  FROM app.traitement AS "b"
  WHERE a.id = b.id_regie
  );
  
-- supprime les régies orphelines 

DELETE FROM app.regie AS "a"
WHERE NOT EXISTS (
  SELECT NULL
  FROM app.traitement AS "b"
  WHERE a.id = b.id_regie
  );
  

 /*
TRAITEMENT
*/

-- supprime les relations d'individus pour les traitements orphelins
DELETE FROM app.traitement_individu AS "c"
WHERE EXISTS (
  SELECT *
  FROM (
  SELECT a.id FROM app.traitement AS "a"
  WHERE NOT EXISTS (
    SELECT NULL
    FROM app.traitement_mobilier AS "b"
    WHERE a.id = b.traitement_id)) AS "d"
  WHERE d.id = c.traitement_id);

-- supprimer les traitements orphelins
DELETE FROM app.traitement AS "a"
WHERE NOT EXISTS (
  SELECT NULL
  FROM app.traitement_mobilier AS "b"
  WHERE a.id = b.traitement_id
  );

BEGIN;
DELETE FROM app.traitement_individu WHERE traitement_id = 643;
DELETE FROM app.traitement_mobilier WHERE traitement_id = 643;
DELETE FROM app.traitement WHERE id = 643;
COMMIT;
