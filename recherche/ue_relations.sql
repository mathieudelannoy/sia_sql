-- recherche l'UE de rattachement
-- p. ex. la structure à laquelle appartient le niveau

SELECT
  a.ue1,
  a.ue2,
  c.num
FROM app.relationstratigraphique AS "a"
JOIN app.ue AS b ON a.ue1 = b.id
JOIN app.ue AS "c" ON c.id = a.ue2
WHERE 
 (a.id_relation = 45 OR a.id_relation = 2238)
 AND b.id_projet = 384
 AND b.id_type = 37
 AND c.id_type != 36