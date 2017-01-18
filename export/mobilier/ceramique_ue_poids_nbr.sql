-- export de l'UE avec le nombre d'éléments céramique et leur poids total
WITH
source_ceram AS (
SELECT
  COALESCE(ue_rl1.numero, ue.numero) AS num_str,
 ue.numero AS num_nv,
 mobilier.id,
 mobilier.numero AS num_mob,
 mobilier.commentaire,
 mobilier.nombre_elements AS nbr,
 mesure.valeur AS poids
FROM app.mobilier
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.mesure ON mobilier.id = mesure.id_mobilier AND mesure.id_type_mesure = 569
LEFT JOIN app.relationstratigraphique AS rl1 ON ue.id = rl1.ue1 AND rl1.id_relation = 2238
LEFT JOIN app.ue AS ue_rl1 ON ue_rl1.id = rl1.ue2
WHERE 
  ue.id_projet = 276 
  AND mobilier.id_matiere_type = 296),
source_lot AS (
SELECT DISTINCT
  id,
  COALESCE(rmob.id_relation, 0) AS lot
FROM source_ceram
LEFT JOIN app.relationintermobilier AS rmob ON source_ceram.id = rmob.mobilier1),
source_ceram_lot AS (
SELECT
  source_ceram.num_str,
  source_ceram.num_nv,
  source_ceram.id,
  source_ceram.num_mob,
  source_ceram.commentaire,
  source_ceram.nbr,
  source_ceram.poids,
  source_lot.lot
FROM source_ceram
LEFT JOIN source_lot On source_ceram.id = source_lot.id
WHERE source_ceram.nbr IS NOT NULL),
source_tri AS (
SELECT
  regexp_replace(commentaire, 'sd ', '') AS ue,
  nbr,
  poids
FROM source_ceram_lot
WHERE 
  commentaire LIKE 'sd%' 
  AND (lot = 51 OR lot = 0)
UNION
SELECT
  num_str::text AS ue,
  nbr,
  poids
FROM source_ceram_lot
WHERE 
  (commentaire NOT LIKE 'sd%' OR commentaire IS NULL)
  AND (lot = 51 OR lot = 0))
  
SELECT
  ue,
  SUM(nbr) AS nbr,
  SUM(poids) AS poids
FROM source_tri
GROUP BY ue
ORDER BY ue
