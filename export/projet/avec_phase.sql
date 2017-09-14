-- une ligne par projet/phase

WITH source AS (

SELECT
  projet.id,
  phase.nom,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_1_debut) AS debut_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_2_debut) AS debut_nv2,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_1_fin) AS fin_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_2_fin) AS fin_nv2,
  phase.tpq,
  phase.taq
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
)
  
SELECT
  projet.id,
  projet.intitule,
  source.nom,
  source.debut_nv1,
  source.debut_nv2,
  source.fin_nv1,
  source.fin_nv2,
  source.tpq,
  source.taq
FROM app.projet 
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN source ON projet.id = source.id
WHERE 
  organisme_id = 1 
  AND projet.thesaurus_thematique NOT ILIKE '%négatif%'
  AND source.id IS NOT NULL
  AND debut_nv1 IS NOT NULL
ORDER BY projet.intitule, source.tpq;


-- une ligne par projet
-- les phases sont triées par TPQ et regroupées

WITH 

source AS (
SELECT DISTINCT
  projet.id,
  phase.id_chrono_1_debut AS id_periode
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND phase.id_chrono_1_debut IS NOT NULL
  
UNION

SELECT DISTINCT
  projet.id,
  phase.id_chrono_1_fin AS id_periode
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND phase.id_chrono_1_fin IS NOT NULL
  
UNION

SELECT
  projet.id,
  NULL AS id_periode
FROM app.projet 
LEFT JOIN app.phase ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND phase.id IS NULL
ORDER BY id, id_periode
),

source_tri AS (
SELECT
  source.id,
  array_to_string(array_agg(chronologie.intitule ORDER BY chronologie.tpq), ', ') AS phases
FROM source
LEFT JOIN app.chronologie ON chronologie.id = source.id_periode
GROUP BY source.id
)

SELECT
  projet.intitule,
  thesaurus_thematique,
  source_tri.phases
FROM source_tri
JOIN app.projet ON projet.id = source_tri.id
ORDER BY projet.intitule
