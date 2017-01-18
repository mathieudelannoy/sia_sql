-- statistiques sur l'emploi du champ "détermination" pour la spécialité archéozoologique

SELECT 
  'total' AS "quoi",
  count(id) as total
FROM app.mobilier
WHERE 
  id_matiere_type = 1833

UNION
  
SELECT 
  'avec spécialisation' AS "quoi", 
  count(mobilier.id) AS nbr
FROM app.mobilier
WHERE 
  id_matiere_type = 1833 
  AND type_mobilier IS NOT NULL 

UNION

SELECT
  'sans détermination' AS "quoi",
  count(mobilier.id) AS nbr
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  id_matiere_type = 1833 
  AND determination IS NULL

UNION

SELECT 
  'sans espèce' AS "quoi",
  count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  id_matiere_type = 1833 AND
  marcheozoologie.id_espece IS NULL

UNION

SELECT 
  'sans région' AS "quoi",
  count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  id_matiere_type = 1833 AND
  marcheozoologie.id_region_anatomique IS NULL

UNION

SELECT 
  'sans os principal' AS "quoi",
  count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  id_matiere_type = 1833 AND
  marcheozoologie.id_os_principal IS NULL
  
UNION

SELECT 
  'sans os partie' AS "quoi",
  count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  id_matiere_type = 1833 AND
  marcheozoologie.id_os_partie_concernee IS NULL

ORDER BY total DESC