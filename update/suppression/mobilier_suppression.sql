
-- supprime par matière type et projet
DELETE FROM app.mobilier AS a
WHERE EXISTS ( 
SELECT 
  b.id
FROM app.mobilier AS b
LEFT JOIN app.ue ON ue.id = b.id_ue
WHERE 
  b.id_matiere_type = 296
  AND ue.id_projet = 596
  AND a.id = b.id);
