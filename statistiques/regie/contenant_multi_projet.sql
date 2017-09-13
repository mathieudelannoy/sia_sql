-- repère les contenants multi-projets
WITH

source AS (
SELECT DISTINCT
  contenant_mobilier.contenant_id,
  ue.id_projet,
  mobilier.id AS id_mobilier
FROM app.contenant_mobilier
JOIN app.mobilier ON mobilier.id = contenant_mobilier.mobilier_id 
JOIN app.ue ON ue.id = mobilier.id_ue
ORDER BY contenant_id, ue.id_projet
),

source_agg_mob AS (
SELECT
  contenant_id,
  id_projet,
  id_projet || ' (' || array_to_string(array_agg(id_mobilier ORDER BY id_mobilier), ', ') || ')' AS id_projet_mob
FROM source
GROUP BY contenant_id, id_projet
)

SELECT
  contenant_id,
  array_to_string(array_agg(id_projet_mob), ', ') AS id_projets
FROM source_agg_mob
GROUP BY contenant_id
HAVING COUNT(contenant_id) > 1
ORDER BY contenant_id;

---

WITH

source AS (
SELECT DISTINCT
  contenant_mobilier.contenant_id,
  ue.id_projet,
  mobilier.id AS id_mobilier
FROM app.contenant_mobilier
JOIN app.mobilier ON mobilier.id = contenant_mobilier.mobilier_id 
JOIN app.ue ON ue.id = mobilier.id_ue
ORDER BY contenant_id, ue.id_projet
),

source_doublon AS (
SELECT DISTINCT
  contenant_id,
  id_projet
FROM source
),

--source intitule
source_doublon2 AS (
SELECT 
  contenant_id,
  array_to_string(array_agg((SELECT intitule FROM app.projet WHERE projet.id = id_projet) || ' (' || id_projet ||')'), ', ') As projets
FROM source_doublon
GROUP BY contenant_id
HAVING COUNT(id_projet) > 1
ORDER BY contenant_id)

SELECT 
  contenant.numero,
  contenant_id,
  projets
FROM source_doublon2
JOIN app.contenant ON contenant.id = contenant_id
