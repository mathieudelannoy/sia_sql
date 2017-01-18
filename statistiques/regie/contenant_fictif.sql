SELECT
  contenant.id
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id AND mobilier.numero = 10000

-- mobiliers fictifs en 10000 = 272
SELECT 
  mobilier.id
FROM app.mobilier
WHERE mobilier.numero = 10000

-- contenants liés au mobilier fictif
SELECT 
  mobilier.id,
  contenant_mobilier.contenant_id
FROM app.mobilier
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
WHERE mobilier.numero = 10000 AND contenant_mobilier.contenant_id IS NOT NULL

SELECT DISTINCT
  contenant_mobilier.contenant_id
FROM app.mobilier
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
WHERE mobilier.numero = 10000 AND contenant_mobilier.contenant_id IS NOT NULL


WITH 
-- tout les contenants liés à mobilier fictif
source AS (
SELECT DISTINCT
  contenant_mobilier.contenant_id
FROM app.mobilier
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
WHERE mobilier.numero = 10000 AND contenant_mobilier.contenant_id IS NOT NULL),
-- lie pour ces contenants le mobilier non-fictif
source2 AS (
SELECT
  source.contenant_id,
  mobilier.id AS mobid
FROM source
LEFT JOIN app.contenant_mobilier ON source.contenant_id = contenant_mobilier.mobilier_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id AND mobilier.numero != 10000),
source3 AS (
-- ne conserve que les contenants uniquement liés à du fictif
SELECT DISTINCT
  contenant_id,
FROM source2
WHERE mobid IS NOT NULL
ORDER BY contenant_id)

WITH source AS (
SELECT
  contenant.id,
  contenant.numero,
  mobilier.id AS mobid,
  mobilier.numero AS mobnum,
  ue.id_projet
FROM app.contenant
JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
JOIN app.mobilier ON mobilier.id = contenant_mobilier.mobilier_id
JOIN app.ue ON mobilier.id_ue = ue.id),

source_10k AS (
SELECT DISTINCT id
FROM source
WHERE mobnum = 10000),

source_p10k AS (
SELECT DISTINCT id
FROM source
WHERE mobnum != 10000 OR mobnum IS NULL),

source_fictif_only AS (
SELECT DISTINCT
  source_10k.id
FROM source_10k
LEFT JOIN source_p10k ON source_10k.id = source_p10k.id
WHERE source_p10k.id IS NULL)

SELECT
  source.id_projet,
  projet.intitule,
  source_fictif_only.id,
  source.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS "matiere"
FROM source_fictif_only
JOIN source ON source_fictif_only.id = source.id
JOIN app.projet ON source.id_projet = projet.id
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
JOIN app.contenant ON source_fictif_only.id = contenant.id 
WHERE 
  organisme_id = 1 
ORDER BY source.id_projet, matiere, numero
