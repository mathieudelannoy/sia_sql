-- export du mobilier lithique d'un projet avec le poids associé

SELECT 
  mobilier.id,
  ue.numero AS "ue",
  mobilier.numero,
  mobilier.precision,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "matiere",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS "type",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS "type_precision",
  mobilier.precision,
  mobilier.determination,
  mobilier.commentaire,
  mobilier.nombre_elements AS "nbr_elements",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_etat_conservation) AS "etat_conservation",
  poids.valeur AS poid
FROM
  app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 569) AS "poids" ON mobilier.id = poids.id_mobilier
WHERE
  ue.id_projet = 517 AND
  mobilier.id_matiere_type = 295;