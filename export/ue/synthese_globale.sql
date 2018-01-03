/*
export construit pour le rapport de diag de la BA103
*/

WITH

-- récupération des UE concernés
source_ue AS (
SELECT 
  a.id,
  CASE WHEN a.numero > 100 THEN LEFT(a.numero::text, 1)::int ELSE 0 END AS secteur,
  CASE 
    WHEN a.numero < 100000 AND a.numero > 100  THEN RIGHT(LEFT(a.numero::text, 2), 1)::int
    WHEN a.numero >= 100000 THEN RIGHT(LEFT(a.numero::text, 3), 2)::int
  ELSE 0 END AS tranchée,
  LPAD(
    RIGHT(a.numero::text, 3)
    , 3, '0') AS num_ue,
  a.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = a.id_type) AS ue_type,
  (SELECT valeur FROM app.liste WHERE liste.id = a.id_nature) AS ue_nature,
  (SELECT valeur FROM app.liste WHERE liste.id = a.id_interpretation) AS ue_interpretation,
  regexp_replace(a.commentaire, '\r|\n', '', 'g') AS commentaire
FROM app.ue AS "a"
WHERE 
  "a".id_projet = 848
),

-- récupère l'UE d'appartenance via les relations strati
source_ue_app AS (
SELECT
  a.id,
  c.numero AS ue_appartenance,
  (SELECT valeur FROM app.liste WHERE liste.id = c.id_nature) AS ue_app_nature,
  (SELECT valeur FROM app.liste WHERE liste.id = c.id_interpretation) AS ue_app_interpretation,
  regexp_replace(c.commentaire, '\r|\n', '', 'g') AS commentaire_ue_app
FROM source_ue AS "a"
JOIN app.relationstratigraphique as "b" ON "b".ue1 = a.id AND "b".id_relation = 2238
JOIN app.ue AS "c" ON b.ue2 = c.id
),

-- récupération et aggrégation des différents types de mobilier présents dans chaque UE
source_mob AS (
SELECT DISTINCT
  mobilier.id_ue,
  array_to_string(array_agg(DISTINCT(SELECT DISTINCT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type)), ', ') AS matiere_type
  -- ajouter récupération chrono datation
FROM app.mobilier
JOIN source_ue ON source_ue.id = mobilier.id_ue
GROUP BY mobilier.id_ue
),

-- récupération des différents phases associés à une UE
source_phase AS (
SELECT
  source_ue.id,
  phase_ue.id_phase,
  COALESCE(phase.nom, '?')
    || ' (' ||
	COALESCE(phase.tpq, 0)
	|| '/' ||
	COALESCE(phase.taq, 0)
	|| ')' AS intitule_phase
FROM source_ue
JOIN app.phase_ue ON source_ue.id = phase_ue.id_ue
JOIN app.phase ON phase_ue.id_phase = phase.id
ORDER BY source_ue.id),

-- aggrégation des différents phases par UE
source_phase_agg AS (
SELECT
  id,
  array_to_string(array_agg(intitule_phase ORDER BY intitule_phase), ', ') AS phases
FROM source_phase
GROUP BY id
),

-- récupération des bornes chronologiques via les valeurs renseignées pour les mobiliers d'une UE
source_chrono_debut AS (
SELECT DISTINCT ON (id_ue)
  id_ue,
  chronologie.intitule
FROM app.mobilier
JOIN source_ue ON source_ue.id = mobilier.id_ue
JOIN app.chronologie ON chronologie.id = mobilier.id_chrono_2_debut
WHERE id_chrono_2_debut IS NOT NULL
ORDER BY id_ue, chronologie.tpq ASC
),

source_chrono_fin AS (
SELECT DISTINCT ON (id_ue)
  id_ue,
  chronologie.intitule
FROM app.mobilier
JOIN source_ue ON source_ue.id = mobilier.id_ue
JOIN app.chronologie ON chronologie.id = mobilier.id_chrono_2_fin
WHERE id_chrono_2_fin IS NOT NULL
ORDER BY id_ue, chronologie.tpq ASC
),

-- récupération des mesures des UE
source_mesure AS (
SELECT
  id_ue,
  id_type_mesure,
  CAST(valeur/100 AS NUMERIC(6,2)) AS valeur
FROM app.mesure AS "a"
JOIN source_ue AS "b" ON b.id = a.id_ue
WHERE 
  id_type_mesure = 566 -- largeur
  OR id_type_mesure = 568 -- longueur
  OR id_type_mesure = 3080 -- profondeur
  OR id_type_mesure = 570 -- diametre
),

-- récupération et aggrégation de la totalité des informations stratigraphiques
source_strati AS (
SELECT 
  b.ue1 AS ue1_id, 
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_relation) AS relation,
  array_to_string(array_agg(c.numero ORDER BY c.numero), ', ') AS ue2_agg
FROM source_ue AS "a"
JOIN app.relationstratigraphique as "b" ON "b".ue1 = a.id
JOIN app.ue AS "c" ON b.ue2 = c.id
GROUP BY "b".id_relation, "b".ue1
ORDER BY "b".id_relation, "b".ue1
),

source_strati_agg AS (
SELECT
  ue1_id,
  array_to_string(array_agg(relation || ' ' || ue2_agg ORDER BY relation), '; ') AS relations
FROM source_strati
GROUP BY ue1_id
),

-- centralisation des CTE avec mise en forme
final AS (
SELECT
  numero,
  secteur,
  tranchée,
  COALESCE(LPAD(RIGHT(source_ue_app.ue_appartenance::text, 3), 3, '0'), LPAD(RIGHT(numero::text, 3), 3, '0')) AS "UE Creusement",
  replace(
  replace(
    COALESCE(source_ue_app.ue_app_nature, '')
    || ' - ' ||
	COALESCE(source_ue_app.ue_app_interpretation, '') 
	, ' -  - ', '') 
	, ' - ', '') AS description_creusement,
  num_ue,
  replace(ue_type
    || ' - ' ||
    COALESCE(ue_nature, '') 
    || ' - ' || 
	COALESCE(ue_interpretation, '')
    , ' -  - ', '') AS description,
  commentaire,
  source_ue_app.commentaire_ue_app,
  source_mob.matiere_type,
  source_chrono_debut.intitule AS chrono_debut,
  source_chrono_fin.intitule AS chrono_fin,
  c.valeur AS largeur,
  d.valeur AS longueur,
  e.valeur AS profondeur,
  f.valeur AS diametre,
  ba103_geol.description AS description_matrice,
  source_strati_agg.relations,
  phases
FROM source_ue
LEFT JOIN source_ue_app ON source_ue_app.id = source_ue.id
LEFT JOIN source_mob ON source_mob.id_ue = source_ue.id
LEFT JOIN source_mesure AS "c" ON c.id_ue = source_ue.id AND c.id_type_mesure = 566
LEFT JOIN source_mesure AS "d" ON d.id_ue = source_ue.id AND d.id_type_mesure = 568
LEFT JOIN source_mesure AS "e" ON e.id_ue = source_ue.id AND e.id_type_mesure = 3080
LEFT JOIN source_mesure AS "f" ON f.id_ue = source_ue.id AND f.id_type_mesure = 570
LEFT JOIN source_chrono_debut ON source_chrono_debut.id_ue = source_ue.id
LEFT JOIN source_chrono_fin ON source_chrono_fin.id_ue = source_ue.id
LEFT JOIN public.ba103_geol ON ue_niveau = source_ue.numero
LEFT JOIN source_strati_agg ON source_strati_agg.ue1_id = source_ue.id
LEFT JOIN source_phase_agg ON source_phase_agg.id = source_ue.id
)

SELECT 
  numero,
  secteur,
  tranchée,
  "UE Creusement",
  CASE 
    WHEN "UE Creusement" = num_ue
	  THEN NULL
	ELSE
	  num_ue
	END AS "UE Comblement",
  description,
  commentaire,
  commentaire_ue_app,
  matiere_type,
  chrono_debut,
  chrono_fin,
  largeur,
  longueur,
  profondeur,
  diametre,
  description_matrice,
  relations,
  phases
FROM final
ORDER BY secteur, tranchée, "UE Creusement", num_ue;