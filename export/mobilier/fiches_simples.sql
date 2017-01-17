SELECT
  mobilier.id,
  ue.numero AS UE,
  mobilier.numero AS num_mob,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS matiere_type_precision,
  mobilier.commentaire,
  mceramique.categorie, 
  mceramique."type", 
  mceramique.pate,
  mceramique.decor,
  poids.valeur AS poid,
  largeur.valeur AS largeur,
  longueur.valeur AS longueur,
  hauteur.valeur AS hauteur
FROM app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN app.mceramique ON mobilier.id = mceramique.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 569) AS "poids" ON mobilier.id = poids.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 567) AS "epaisseur" ON mobilier.id = epaisseur.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 566) AS "largeur" ON mobilier.id = largeur.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 568) AS "longueur" ON mobilier.id = longueur.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 571) AS "hauteur" ON mobilier.id = hauteur.id_mobilier
WHERE
  ue.id_projet = 155
  AND id_matiere_type != 1833
  AND id_matiere_type != 1832
  AND id_matiere_type != 305
  AND id_matiere_type != 294
ORDER BY matiere_type, matiere_type_precision
