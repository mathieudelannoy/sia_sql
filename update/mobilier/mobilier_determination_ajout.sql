



-- MAJ LITHIQUE

SELECT count(mobilier.id)
FROM app.mobilier
JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE
  mobilier.id_matiere_type = 293
  AND mobilier.determination IS NOT NULL
  
SELECT count(mobilier.id)
FROM app.mobilier
JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE mobilier.id_matiere_type = 293 AND mlithique.id_typologie IS NOT NULL;
-- 1061

SELECT count(mobilier.id)
FROM app.mobilier
JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE mobilier.id_matiere_type = 293 AND mlithique.id_technologie IS NOT NULL;
-- 3409

BEGIN;

UPDATE app.mobilier 
SET determination = (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_typologie)
FROM app.mlithique
WHERE 
  mobilier.id = mlithique.id
  AND mobilier.id_matiere_type = 293 
  AND mobilier.determination IS NULL
  AND mlithique.id_typologie IS NOT NULL;
  
UPDATE app.mobilier 
SET determination = (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_technologie)
FROM app.mlithique
WHERE 
  mobilier.id = mlithique.id
  AND mobilier.id_matiere_type = 293 
  AND mobilier.determination IS NULL
  AND mlithique.id_technologie IS NOT NULL;
  
COMMIT;