CREATE OR REPLACE VIEW stats.projet_cda62_chrono_phase_absente AS

WITH source AS (

SELECT DISTINCT
  projet.id
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
)
  
SELECT
  projet.id,
  projet.intitule
FROM app.projet 
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN source ON projet.id = source.id
WHERE 
  organisme_id = 1 
  AND source.id IS NULL
ORDER BY projet.intitule;

COMMENT ON VIEW stats.projet_cda62_chrono_phase_absente
  IS 'projets du cda62 n''ayant aucune phase renseignée';