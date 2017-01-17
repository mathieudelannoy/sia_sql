-- export des codes SRA pour le mobilier d'après les champs saisis

SELECT
  mobilier.id,
  COALESCE(projet.code_oa || '_' ||(SELECT code FROM app.liste WHERE liste.id = mobilier.id_matiere_type), '0') || '_' ||
  ue.numero || '_' || COALESCE(mobilier.numero, 0) AS code_sra
FROM app.mobilier
JOIN app.ue ON ue.id = mobilier.id_ue
JOIN app.projet ON ue.id_projet = projet.id
WHERE mobilier.numero IS NOT NULL
ORDER BY ue.id_projet