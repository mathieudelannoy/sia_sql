SELECT
  str.numero AS ue_structure,
  (SELECT valeur FROM app.liste WHERE liste.id = str.id_type) || ' - ' || COALESCE((SELECT valeur FROM app.liste WHERE liste.id = str.id_nature), '') AS ue_structure_nature,
  ue.numero AS ue_comblement,
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) || ' - ' || COALESCE((SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature), '') AS ue_comblement_nature,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS matiere_type_precision,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "Chrono début", 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "Sous-Chrono début",  
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS "Chrono fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin ) AS "Sous-chrono fin"
FROM 
  app.mobilier
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
-- joint la structure à laquelle appartient le comblement
LEFT JOIN app.relationstratigraphique AS "rs" ON ue.id = rs.ue1 AND (rs.id_relation = 2238 OR rs.id_relation = 45)
LEFT JOIN app.ue AS "str" ON rs.ue2 = str.id
WHERE ue.id_projet = 560
ORDER BY ue_structure, ue_comblement

UPDATE app.mobilier
SET
  id_chrono_1_debut = 24,
  id_chrono_2_debut = 27,
  id_chrono_1_fin = 24,
  id_chrono_2_fin = 27,
  tpq = 1200,
  taq = 1300
FROM app.ue
WHERE
  ue.id = mobilier.id_ue
  AND ue.id = 30509
  AND mobilier.id_matiere_type = 296