WITH
ue_app AS (
SELECT 
  b.ue1 AS "ue1_id",
  a.numero,
  c.valeur, 
  b.ue2 AS "ue2_id"
FROM 
  app.ue AS "a",
  app.relationstratigraphique as "b", 
  app.liste AS "c"
WHERE 
  "b".id_relation = 2238
  AND "b".id_relation = c.id
  AND "b".ue1 = a.id
  AND "a".id_projet = 748
ORDER BY "c".valeur, "b".ue1 ASC),

ue_app_geom AS (
SELECT
  ue_app.numero,
  ue.the_geom
FROM ue_app
LEFT JOIN app.ue ON ue2_id = ue.id),

ue_all_geom AS (
SELECT 
 ue.numero,
 ue.the_geom
FROM app.ue
WHERE 
  ue.id_projet = 748
  AND ue.the_geom IS NOT NULL
UNION
SELECT
  numero,
  the_geom
FROM ue_app_geom)

SELECT DISTINCT
  numero,
  ST_AsText(the_geom)
FROM ue_all_geom
WHERE GeometryType(the_geom) = 'MULTIPOLYGON'