-- décompte par projet
-- monnaie
SELECT
  projet.intitule,
  'monnaie' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 305
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
UNION ALL
-- lapidaire
SELECT
  projet.intitule,
  'lapidaire' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 394
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
UNION ALL
-- anthropologie
SELECT
  projet.intitule,
  'anthropologie' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 1832
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
UNION ALL
-- archéozoologie
SELECT
  projet.intitule,
  'archéozoologie' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 1833
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
UNION ALL
-- lithique
SELECT
  projet.intitule,
  'lithique' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 293
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
UNION ALL
-- céramique
SELECT
  projet.intitule,
  'céramique' AS matiere_type,
  count(mobilier.id) AS nbr_total
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE
  mobilier.id_matiere_type = 296
  AND mobilier.determination IS NULL
GROUP BY projet.intitule
