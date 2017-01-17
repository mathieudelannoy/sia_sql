WITH 

source1 AS (
SELECT DISTINCT
  contenant_mobilier.contenant_id,
  ue.id_projet
FROM app.contenant_mobilier
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id),

source2 AS (
SELECT
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

source3 AS (
SELECT
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
),

source_recol AS (
SELECT id, date_recol, regexp_replace(statut, 'nouvelle localisation', 'vu', 'g') statut
FROM maintenance.contenant_recolement
WHERE date_recol = '2016-04-27' AND statut != 'à faire'
)

SELECT
  contenant_id AS id,
  numero,
  intitule,
  matiere,
  "type",
  batiment,
  salle,
  travee[1],
  etagere[2],
  tablette,
  COALESCE(source_recol.statut, 'à faire') AS statut,
  source_recol.date_recol AS date  
FROM source3
LEFT JOIN source_recol ON source_recol.id = source3.contenant_id