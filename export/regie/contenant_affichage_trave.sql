-- export pour l'affichage en bout de travée
-- à refaire

CREATE VIEW stockage_affichage_travee AS
WITH source AS (
SELECT DISTINCT
  contenant.id,
  projet.intitule AS "projet",
  projet.code_oa,
  contenant.id_localisation
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
WHERE projet.intitule NOT LIKE 'intitu%' AND projet.id != 7)
SELECT
  source.projet,
  source.code_oa,
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_salle) AS "salle",
  c.travee,
  c.etagere
FROM source
LEFT JOIN app.localisation AS "b" ON b.id = source.id_localisation
LEFT JOIN app_addons.localisation_sane AS "c" ON c.id_localisation = source.id_localisation
WHERE b.id_salle IS NOT NULL
GROUP BY source.projet, source.code_oa, b.id_salle, c.travee, c.etagere
ORDER BY b.id_salle, c.travee, c.etagere, source.projet;

