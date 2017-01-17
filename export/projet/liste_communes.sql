-- export des communes chevauchant des emprises de projet

WITH source AS (
SELECT
  projet.id,
  projet.the_geom
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet_operateur.organisme_id = 1
  AND projet.the_geom IS NOT NULL
)

SELECT DISTINCT
  commune.nom
FROM source
LEFT JOIN app.commune ON ST_Overlaps(source.the_geom, commune.the_geom)
ORDER BY commune.nom