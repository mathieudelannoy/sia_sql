-- rechercher une UE d'après son identifiant

SELECT
  projet.intitule,
  ue.numero, 
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) AS "Type", 
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature) AS "Nature",
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_interpretation) AS "Interpretation", 
  ue.commentaire
FROM 
  app.ue
LEFT JOIN app.projet ON projet.id = ue.id_projet
WHERE 
  ue.id = 23370;
