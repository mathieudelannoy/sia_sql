-- export inventaire simple des UE d'un projet
SELECT DISTINCT
  ue.id,
  ue.numero,
  ue.ancien_identifiant,
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) AS "Type", 
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature) AS "Nature",
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_interpretation) AS "Interpretation", 
  ue.commentaire
FROM 
  app.ue
WHERE 
  ue.id_projet = 206
ORDER BY numero ASC;

-- export de l'identifiant et du numéro des UE d'un projet

SELECT
  ue.id AS id_ue,
  ue.numero
FROM 
  app.ue
WHERE 
  ue.id_projet = 69
ORDER BY numero ASC;