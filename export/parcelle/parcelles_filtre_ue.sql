-- export de parcelles liées aux opérations en ne retenant que celles contenant au moins une UE

WITH source AS (
SELECT
  projet.id,
  projet.intitule,
  projet.date_debut,
  projet.date_fin,
  ST_Centroid(ue.the_geom) AS the_geom
FROM app.ue
LEFT JOIN app.projet ON ue.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet_operateur.organisme_id = 1
  AND ue.the_geom IS NOT NULL
)

SELECT DISTINCT
  source.id,
  source.intitule,
  source.date_debut,
  source.date_fin,
  commune.nom,
  commune.code_insee,
  section.nom,
  parcelle.numero
FROM source
LEFT JOIN app.parcelle ON ST_Contains(parcelle.the_geom, source.the_geom)
LEFT JOIN app."section" On parcelle.id_section = "section".id
LEFT JOIN app.commune ON commune.id = "section".id_commune
WHERE parcelle.numero IS NOT NULL
ORDER BY  source.date_debut, source.intitule