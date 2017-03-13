-- requête pour obtenir une liste des projets avec un centroide géoréférencé
CREATE OR REPLACE VIEW stats.projet_cda62_centroide AS 

WITH source AS (
	 SELECT
	  projet.id,
	  projet.intitule,
	  ST_Transform(ST_Multi(projet.the_geom), 2154) AS geom
	FROM app.projet
	LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
	WHERE 
	  projet_operateur.organisme_id = 1
	  AND the_geom IS NOT NULL
	  AND ST_geometrytype(the_geom) != 'ST_Point'
UNION ALL
	 SELECT
	  projet.id,
	  projet.intitule,
	  ST_Transform(ST_Multi(ST_Buffer((projet.the_geom), 5)), 2154) AS geom
	FROM app.projet
	LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
	WHERE 
	  projet_operateur.organisme_id = 1
	  AND the_geom IS NOT NULL
	  AND ST_geometrytype(the_geom) = 'ST_Point'
	)
SELECT
  source.id,
  projet.intitule,
  date_part('isoyear'::text, projet.date_debut) AS date_debut,
  date_part('isoyear'::text, projet.date_fin) AS date_fin,
  projet.adresse, 
  (SELECT liste.valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS type_projet,
  projet.code_oa,
  ST_AsText(ST_Centroid(source.geom)) AS wkt_geom
FROM source
LEFT JOIN app.projet ON source.id = projet.id
ORDER by date_debut, projet.intitule;