WITH 

-- récupère tous les contenants mobilier et doucmentation par projet
source1 AS (
SELECT DISTINCT
  contenant_mobilier.contenant_id,
  ue.id_projet
FROM app.contenant_mobilier
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
UNION ALL
SELECT DISTINCT
  contenant_id,
  id_projet
FROM app.contenant_document
LEFT JOIN app.document ON contenant_document.document_id = document.id
WHERE id_projet IS NOT NULL
),



-- récupère les informations des contenants
source2 AS (
SELECT
  projet.id AS id_projet,
  source1.contenant_id,
  contenant.numero,
  projet.intitule AS "intitule",
  contenant.id_localisation,
  contenant.id_matiere_contenant,
  contenant.id_type_contenant
FROM source1
LEFT JOIN app.contenant ON contenant.id = source1.contenant_id
LEFT JOIN app.projet ON source1.id_projet = projet.id
WHERE projet.intitule NOT LIKE 'intitu%' AND projet.id != 7
),

-- récupère les valeurs des libellés
source3 AS (
SELECT
  id_projet,
  source2.contenant_id,
  source2.numero,
  source2.intitule,
  (SELECT valeur FROM app.liste WHERE liste.id = source2.id_matiere_contenant) AS matiere,
  (SELECT valeur FROM app.liste WHERE liste.id = source2.id_type_contenant) AS "type",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  (SELECT string_to_array(valeur,'-') FROM app.liste WHERE liste.id = localisation.id_etagere) AS "travee",
  (SELECT string_to_array(valeur, '-') FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM source2
LEFT JOIN app.localisation ON localisation.id = source2.id_localisation
)


SELECT
  id_projet,
  contenant_id AS id,
  intitule,
  matiere,
  numero,
  "type",
  batiment,
  salle,
  travee[1],
  etagere[2],
  tablette,
  'à faire' AS statut
FROM source3