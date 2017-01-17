-- Export de la strati extistante d'un projet

SELECT 
  "b".ue1 AS ue1_id, 
  (SELECT a.numero WHERE b.ue1 = "a".id) AS "UE1", 
  "c".valeur, 
  "b".ue2,
  
FROM 
  app.ue AS "a", 
  app.relationstratigraphique as "b", 
  app.liste AS "c" 
WHERE 
  "b".id_relation = c.id 
  AND "b".ue1 = a.id 
  AND "a".id_projet = 155 
ORDER BY "c".valeur, "b".ue1 ASC




