-- décompte des UEs par projet
CREATE VIEW stats.projet_nbr_ue AS
SELECT 
  projet.intitule,
  count(ue.id) as nbr 
FROM app.ue
JOIN app.projet ON ue.id_projet = projet.id
GROUP BY projet.intitule, id_projet
ORDER BY nbr DESC;