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




