WITH
source_lithique AS (
SELECT
  COALESCE(ue_rl1.numero, ue.numero) AS num_str,
 ue.numero AS num_nv,
 mobilier.id,
 mobilier.numero AS num_mob,
 mobilier.commentaire,
 id_technologie,
 id_typologie,
 mobilier.nombre_elements AS nbr
FROM app.mobilier
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.relationstratigraphique AS rl1 ON ue.id = rl1.ue1 AND rl1.id_relation = 2238
LEFT JOIN app.ue AS ue_rl1 ON ue_rl1.id = rl1.ue2
LEFT JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE 
  ue.id_projet = 283 
  AND mobilier.id_matiere_type = 293),
source_ue_simple AS (
  SELECT
  SUBSTRING(commentaire FROM '.{3}$') AS ue,
  id_technologie,
  id_typologie,
  nbr
FROM source_lithique
WHERE 
  commentaire LIKE '%sd%'
UNION ALL
SELECT
  num_str::text AS ue,
   id_technologie,
 id_typologie,
  nbr
FROM source_lithique
WHERE 
  (commentaire NOT LIKE '%sd%' OR commentaire IS NULL)),
source_regroup AS (
SELECT
  ue::int,
  SUM(nbr) AS nbr
FROM source_ue_simple
GROUP BY ue::int
)

SELECT 
  source_regroup.ue,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = ue.id_chrono_1_debut) AS "Chrono",
  source_regroup.nbr,
  ST_AsText(ST_Transform(ue.the_geom, 2154)) AS the_geom
FROM source_regroup
LEFT JOIN app.ue ON ue.numero = source_regroup.ue AND ue.id_projet = 283
WHERE the_geom IS NOT NULL
ORDER BY ST_GeometryType(ue.the_geom), ue
