-- total des projets du CDA62 par années

CREATE VIEW stats.projet_cda62_par_an AS
WITH source AS (
SELECT 
  EXTRACT(ISOYEAR FROM projet.date_debut) AS annee, 
  COUNT(id) AS nbr,
  SUM(surface_ouverte)::int AS surface_ouverte
FROM 
  app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE organisme_id = 1
GROUP BY EXTRACT(ISOYEAR FROM projet.date_debut)
)
SELECT *
FROM source
ORDER BY annee ASC;
COMMENT ON VIEW stats.projet_cda62_par_an IS 'total des projets du CDA62 par années (opérateur et prestataire)';