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

/*
export des communes chevauchant ou contenant des emprises de projet
avec décompte (une opération peut être comptée plusieurs fois si elle
est présente dans plusieurs communes)
*/
WITH 
source_emprise AS (
	SELECT
	  projet.id,
	  projet.the_geom
	FROM app.projet
	LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
	WHERE 
	  projet_operateur.organisme_id = 1
	  AND projet.the_geom IS NOT NULL
	),

source_commune AS (
	SELECT
	  commune.id,
	  COUNT(commune.id) AS nbr
	FROM 
	  source_emprise,
	  app.commune
	WHERE
	  ST_Overlaps(source_emprise.the_geom, commune.the_geom)
	  OR ST_Contains(commune.the_geom, source_emprise.the_geom)
	GROUP BY commune.id
	ORDER BY commune.id
)	

SELECT 
  commune.nom,
  source_commune.nbr,
  ST_AsText(ST_Transform(commune.the_geom, 2154)) AS wkt_geom
FROM source_commune
JOIN app.commune ON source_commune.id = commune.id