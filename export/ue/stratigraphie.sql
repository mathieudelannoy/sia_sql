-- Export de la strati extistante d'un projet

SELECT 
  "b".ue1 AS ue1_id, 
  --(SELECT a.numero WHERE b.ue1 = "a".id) AS "UE1", 
  "c".valeur, 
  "b".ue2
  
FROM app.ue AS "a"
JOIN app.relationstratigraphique as "b" ON "b".ue1 = a.id
JOIN app.liste AS "c" ON "b".id_relation = c.id
WHERE 
  "a".id_projet = 820 
ORDER BY "c".valeur, "b".ue1 ASC



-- export avec aggrégations des relations par type

WITH

source_strati AS (
SELECT 
  b.ue1 AS ue1_id, 
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_relation) AS relation,
  array_to_string(array_agg(c.numero ORDER BY c.numero), ', ') AS ue2_agg
FROM app.ue AS "a"
JOIN app.relationstratigraphique as "b" ON "b".ue1 = a.id
JOIN app.ue AS "c" ON b.ue2 = c.id
WHERE
  "a".id_projet = 820
GROUP BY "b".id_relation, "b".ue1
ORDER BY "b".id_relation, "b".ue1
)

SELECT
  ue1_id,
  array_to_string(array_agg(relation || ' ' || ue2_agg ORDER BY relation), '; ') AS relations
FROM source_strati
GROUP BY ue1_id