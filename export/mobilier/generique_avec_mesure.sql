WITH source AS (
SELECT
  mobilier.id,
  ue.numero AS "ue",
  mobilier.numero,
  mobilier.determination,
  mceramique.categorie, 
  mceramique."type", 
  mesure.id AS "id_mesure",
  (SELECT valeur FROM app.liste WHERE liste.id = mesure.id_type_mesure) AS "type_mesure",
  mesure.valeur
FROM
  app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN app.mceramique ON mobilier.id = mceramique.id
JOIN app.mesure ON mobilier.id = mesure.id_mobilier
WHERE 
  ue.id_projet = 276 AND
  mobilier.id_matiere_type = 296
UNION ALL
SELECT
  mobilier.id,
  ue.numero AS "ue",
  mobilier.numero,
  mobilier.determination,
  mceramique.categorie, 
  mceramique."type", 
  mesureceramique.id AS "id_mesure",
  (SELECT valeur FROM app.liste WHERE liste.id = mesureceramique.id_type_mesure) AS "type_mesure",
  mesureceramique.valeur
FROM
  app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN app.mceramique ON mobilier.id = mceramique.id
JOIN app.mesureceramique ON mobilier.id = mesureceramique.id_mobilier
WHERE 
  ue.id_projet = 276 AND
  mobilier.id_matiere_type = 296)

SELECT
  id,
  type_mesure,
  COUNT(id) AS nbr
FROM source  
GROUP BY id, type_mesure
