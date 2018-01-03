-- export d'un inventaire simplifié concaténant les informations

-- geometrie
WITH
-- récupère tous les mobiliers
source AS (
SELECT 
  a.id, 
  a.id_ue,
  b.the_geom
FROM app.mobilier AS "a"
JOIN app.ue AS "b" ON b.id = a.id_ue
WHERE
  b.id_projet = 845),

-- mobilier récupérant la géométrie depuis l'ue liée
mob_geom_nv1 AS (
SELECT
  id, id_ue, the_geom
FROM source
WHERE the_geom IS NOT NULL),
-- mobilier récupérant la géométrie depuis les relations strati
mob_geom_nv2 AS (
SELECT
  source.id, source.id_ue,
  ue.the_geom
FROM source
JOIN app.relationstratigraphique ON source.id_ue = relationstratigraphique.ue1
JOIN app.ue ON relationstratigraphique.ue2 = ue.id
WHERE
  source.the_geom IS NULL
  AND (relationstratigraphique.id_relation = 2238 OR relationstratigraphique.id_relation = 45)
  AND ue.the_geom IS NOT NULL),

mob_geom_union AS (
SELECT id, id_ue, the_geom
FROM mob_geom_nv1
UNION
SELECT id, id_ue, the_geom
FROM mob_geom_nv2),

mob_parcelles AS (
SELECT a.id. b.numero
FROM mob_geom_union AS "a", app.parcelle AS "b"
WHERE ST_Within(ST_Centroid(a.the_geom), b.the_geom)
)


SELECT
  c.code_region::text || c.code::text || '_' ||
    (SELECT code FROM app.liste WHERE liste.id = a.id_matiere_type) || '_' ||
    b.numero  || '_' || COALESCE(a.numero::text, 'NaN') AS "Identifiant",
  regexp_replace(
    (SELECT valeur FROM app.liste WHERE liste.id = a.id_matiere_type) || ' / ' ||
    COALESCE(
    (SELECT valeur FROM app.liste WHERE liste.id = a.id_matiere_type_precision), '')
    || ' / ' ||
    COALESCE(regexp_replace(determination, '\r|\n', '', 'g'), ''), '/  /', '/' ) AS "Détermination",
  a.nombre_elements AS "Nombre d’éléments",
  a.poids AS "Poids (g)",
  (SELECT valeur FROM app.liste WHERE liste.id = a.id_etat_sanitaire) AS "État sanitaire",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_debut) ||'/'|| (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_fin) AS "Chronologie",
  mob_parcelles.numero AS "Parcelle"
FROM app.mobilier AS "a"
JOIN app.ue AS "b" ON b.id = a.id_ue
JOIN app.projet_codes AS "c" ON 
  b.id_projet = c.id_projet
  AND c.code_principal IS TRUE
  AND id_code_type = 3174
LEFT JOIN mob_parcelles ON mob_parcelles.id = a.id
WHERE
  b.id_projet = 845
ORDER BY "Identifiant"

/*
Rajouter le support historique avec les timerange !
Rajouter section !
*/
