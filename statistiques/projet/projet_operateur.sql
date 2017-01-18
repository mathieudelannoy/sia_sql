-- décompte des projets par opérateur
SELECT
  organisme.intitule AS organisme,
  COUNT(projet.id) as nbr
FROM  app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id AND projet_operateur.organisme_role_id = 32
LEFT JOIN app.organisme ON projet_operateur.organisme_id = organisme.id
GROUP BY organisme
ORDER BY nbr DESC;