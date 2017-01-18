SELECT
  projet.intitule,
  ue.numero AS num_ue,
  mobilier.id,
  mobilier.numero,
  mobilier.determination,
  mceramique.type,
  mceramique.categorie
FROM app.mobilier
JOIN app.ue ON ue.id = mobilier.id_ue
JOIN app.projet ON ue.id_projet = projet.id
LEFT JOIN app.mceramique ON mobilier.id = mceramique.id
WHERE 
  mobilier.id_matiere_type = 296
  AND mobilier.id_chrono_1_debut = 19
  AND (ue.id_projet = 283
  OR ue.id_projet = 276
  OR ue.id_projet = 444)  
ORDER BY mceramique.type
