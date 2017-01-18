-- tous les projets du CDA62 par type et par années

CREATE VIEW stats.projet_cda62_type_ans AS
WITH source AS (
SELECT 
  EXTRACT(ISOYEAR FROM projet.date_debut) AS date_debut, 
  EXTRACT(ISOYEAR FROM projet.date_fin) AS date_fin, 
  (SELECT valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS "type_projet" 
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE organisme_id = 1)
SELECT
  date_debut,
  type_projet,
  COUNT(type_projet) as nbr
FROM source
GROUP BY type_projet, date_debut
ORDER BY type_projet, date_debut;
COMMENT ON VIEW stats.projet_cda62_type_ans IS 'tous les projets du CDA62 par type et par années';