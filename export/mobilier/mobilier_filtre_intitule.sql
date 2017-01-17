-- exporte les enregistrements mobiliers de tous les projets dont l'intitulé contient le terme recherché

WITH source_projet AS (
SELECT
  projet.id, 
  projet.intitule,
  projet.code_oa,
  projet_operateur.organisme_id
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet.intitule ILIKE 'Thérouanne%'
  AND (projet_operateur.organisme_id != 1 OR projet_operateur.organisme_id IS NULL)
)

SELECT
  source_projet.code_oa,
  source_projet.intitule,
  ue.numero AS UE,
  mobilier.numero AS num_mob,
  mobilier.precision,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS matiere,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS matiere_type_precision,
  mobilier.determination,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_etat_sanitaire) AS "Etat sanitaire", 
  contenant.numero AS contenant
FROM app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
JOIN source_projet ON ue.id_projet = source_projet.id
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
LEFT JOIN app.contenant ON contenant_mobilier.contenant_id = contenant.id
ORDER BY code_oa