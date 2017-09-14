-- indique les projets de la Dir sans emprise
SELECT
  projet.id,
  projet.intitule
FROM app.projet
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet_operateur.organisme_id = 1
  AND the_geom IS NULL;