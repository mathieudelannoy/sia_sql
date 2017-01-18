/*
Exporter un tableau contenant pour chaque opération :
-	Code oa
-	Intitulé opération
-	Total UE
-	Total contenants
-	Total mobilier présent
-	Total mobilier non localisé
*/

WITH 
source_projet AS (
SELECT
  projet.id,
  projet.code_oa,
  projet.intitule,
  (SELECT valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS "type_projet", 
  organisme.intitule AS organisme
FROM  app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN app.organisme ON projet_operateur.organisme_id = organisme.id AND organisme_role_id = 32
WHERE creation > '2014-03-01'),

total_ue AS (
SELECT
  ue.id_projet,
  COUNT(ue.id) AS nbr_ue
FROM app.ue
RIGHT JOIN source_projet ON source_projet.id = ue.id_projet
GROUP BY ue.id_projet
),

total_contenant AS (
SELECT
  a.id_projet,
  COUNT(a.id) AS nbr_contenant
FROM stats.contenant_inv_complete AS "a"
RIGHT JOIN source_projet AS "b" ON a.id_projet = b.id
GROUP BY a.id_projet
),

total_mobilier AS (
SELECT
  ue.id_projet,
  COUNT(mobilier.id) AS nbr_mobilier
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
GROUP BY ue.id_projet
),

total_mobilier_nonloc AS (
SELECT
  ue.id_projet,
  COUNT(mobilier.id) AS nbr_mobilier_nonloc
FROM app.mobilier
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
JOIN app.ue ON mobilier.id_ue = ue.id
WHERE contenant_mobilier.mobilier_id IS NULL
GROUP BY ue.id_projet
)

SELECT
  a.code_oa,
  a.intitule,
  a.type_projet,
  a.organisme,
  total_ue.nbr_ue,
  total_contenant.nbr_contenant,
  total_mobilier.nbr_mobilier,
  total_mobilier_nonloc.nbr_mobilier_nonloc
FROM source_projet AS "a"
LEFT JOIN total_ue ON total_ue.id_projet = a.id
LEFT JOIN total_contenant ON total_contenant.id_projet = a.id
LEFT JOIN total_mobilier ON total_mobilier.id_projet = a.id
LEFT JOIN total_mobilier_nonloc ON total_mobilier_nonloc.id_projet = a.id


