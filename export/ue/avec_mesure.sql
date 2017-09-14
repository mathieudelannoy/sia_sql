-- export inventaire simple des UE d'un projet
SELECT DISTINCT
  ue.id,
  ue.numero,
  ue.ancien_identifiant,
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) AS "Type", 
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature) AS "Nature",
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_interpretation) AS "Interpretation", 
  (SELECT valeur FROM app.liste WHERE liste.id = id_plan) AS "plan",
  (SELECT valeur FROM app.liste WHERE liste.id = id_profil_fond) AS "profil_fond",
  (SELECT valeur FROM app.liste WHERE liste.id = id_profil_paroi) AS "profil_paroi",
  largeur.valeur AS largeur,
  longueur.valeur AS longueur,
  profondeur.valeur As profondeur
FROM app.ue

LEFT JOIN (SELECT id_ue, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 566) AS largeur ON largeur.id_ue = ue.id
LEFT JOIN (SELECT id_ue, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 568) AS longueur ON longueur.id_ue = ue.id
LEFT JOIN (SELECT id_ue, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 3080) AS profondeur ON profondeur.id_ue = ue.id
WHERE 
  ue.id_projet = 839
ORDER BY numero ASC;