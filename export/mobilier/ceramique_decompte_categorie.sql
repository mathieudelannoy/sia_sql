-- export des catégories céramiques d'un projet avec somme du nombre d'éléments
SELECT
  c.numero,
  b.categorie,
  SUM(a.nombre_elements)
FROM app.mobilier AS "a"
LEFT JOIN app.mceramique AS "b" ON a.id = b.id
LEFT JOIN app.ue AS "c" ON a.id_ue = c.id
WHERE 
  c.id_projet = 391
  AND a.id_matiere_type = 296
  AND b.categorie IS NOT NULL
GROUP BY c.numero, b.categorie
