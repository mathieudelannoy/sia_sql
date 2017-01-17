-- export d'un inventaire simplifié concaténant les informations

SELECT
  COALESCE(projet.code_oa || '_' ||(SELECT code FROM app.liste WHERE liste.id = mobilier.id_matiere_type), '0') || '_' ||
  ue.numero || '_' || COALESCE(mobilier.numero, 0) AS code_sra,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) || ' / ' ||
  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision), '') || ' / ' ||
  COALESCE(regexp_replace(determination, '\r|\n', '', 'g'), '') AS determination,
  mobilier.nombre_elements,
  poids.valeur || ' gr.' AS poid,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_etat_sanitaire) AS "Etat sanitaire",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "Chronologie"
FROM app.mobilier
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN app.projet ON ue.id_projet = projet.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 569) AS "poids" ON mobilier.id = poids.id_mobilier
WHERE
  ue.id_projet = 155
ORDER BY mobilier.id_matiere_type, mobilier.id_matiere_type_precision, ue.numero
LIMIT 10

