-- décompte des projets par type

CREATE VIEW stats.projet_par_type AS
SELECT
  (SELECT valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS "type_projet",
  COUNT(id_type_projet) AS nbr 
FROM app.projet
WHERE
  projet.intitule NOT LIKE 'DISPONIBLE%'
  AND projet.intitule NOT LIKE 'intitule%'
  AND projet.intitule NOT LIKE 'SRA%'
  AND projet.intitule != 'Test !'
GROUP BY id_type_projet
ORDER BY type_projet ASC