UPDATE app.mobilier AS "a" SET id_matiere_type = 298 
WHERE EXISTS (
SELECT b.id
FROM app.mobilier AS "b"
LEFT JOIN app.ue ON b.id_ue = ue.id
WHERE 
  b.id_matiere_type = 296
  AND ue.id_projet = 155
  AND b.type_mobilier IS NOT NULL
  AND b.determination = 'bille'
  AND a.id = b.id);
  

  
  
SELECT mobilier.id
FROM app.mobilier
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
WHERE 
  mobilier.id_matiere_type = 296
  AND ue.id_projet = 155
  AND mobilier.type_mobilier IS NOT NULL
  AND mobilier.determination = 'palet'