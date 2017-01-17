-- décompte des mobiliers par matière/type pour chaque projet
CREATE VIEW stats.projet_nbr_mobilier AS
SELECT 
  projet.intitule,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS matiere,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  COUNT(mobilier.id) AS nbr
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
GROUP BY projet.intitule, ue.id_projet, matiere, matiere_type
ORDER BY nbr DESC;

SELECT 
  ue.id_projet,
  COUNT(mobilier.id) AS nbr
FROM app.mobilier
GROUP BY ue.id_projet, matiere, matiere_type
