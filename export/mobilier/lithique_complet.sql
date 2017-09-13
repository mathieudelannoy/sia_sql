-- export d'un inventaire du mobilier lithique avec les informations sur le contexte de découverte et les contenants de stockage

WITH 
a AS (
SELECT
  mobilier.id,
  projet.code_oa || '_' || 
  COALESCE((SELECT code FROM app.liste WHERE liste.id = mobilier.id_matiere_type), '0') || '_' ||
  ue.numero || '_' || COALESCE(mobilier.numero, 0) AS code_sra,
  ue.numero AS ue_decouverte,
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) || ' - ' || COALESCE((SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature), '') AS ue_decouverte_nature,
  -- (SELECT valeur FROM app.liste WHERE liste.id = ue.id_nature) AS nature_comblement,
  str.numero AS ue_structure_lien,
  (SELECT valeur FROM app.liste WHERE liste.id = str.id_type) || ' - ' || COALESCE((SELECT valeur FROM app.liste WHERE liste.id = str.id_nature), '') AS nature_structure,
  mobilier.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS "matiere_premiere",
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_technologie) AS "technologie",
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_typologie) AS "typologie",
  mobilier.precision,
  regexp_replace(mobilier.commentaire, '\r|\n', ' - ', 'g') AS commentaire,
  mobilier.determination,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_etat_conservation) AS "etat_conservation",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_objet_ou_lot) AS "objet_lot",
  mobilier.nombre_elements,
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_cortex) AS "cortex",
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_talon) AS "talon",
  accident_taille,
  alteration,
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_type_percussion) AS "type_percussion",
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_type_debitage) AS "type_debitage",
  (SELECT valeur FROM app.liste WHERE liste.id = mlithique.id_fragment) AS "fragment",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "chrono_debut", 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "sous_chrono_debut",  
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS "chrono_fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin ) AS "sous_chrono_fin",
  mobilier.tpq,
  mobilier.taq,
  poids.valeur AS poid,
  largeur.valeur AS largeur,
  longueur.valeur AS longueur,
  epaisseur.valeur AS epaisseur
FROM app.mobilier
LEFT JOIN app.mlithique ON mobilier.id = mlithique.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
-- joint la structure à laquelle appartient le comblement
LEFT JOIN app.relationstratigraphique AS "rs" ON ue.id = rs.ue1 AND rs.id_relation = 2238
LEFT JOIN app.ue AS "str" ON rs.ue2 = str.id
-- jointure des mesures
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 569) AS "poids" ON mobilier.id = poids.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 567) AS "epaisseur" ON mobilier.id = epaisseur.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 566) AS "largeur" ON mobilier.id = largeur.id_mobilier
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 568) AS "longueur" ON mobilier.id = longueur.id_mobilier
WHERE 
  ue.id_projet = 839 AND
  mobilier.id_matiere_type = 293),

b AS (
SELECT 
  a.id,
  array_to_string(array_agg(contenant.numero), '; ')  AS contenants
FROM a
LEFT JOIN app.contenant_mobilier ON a.id = contenant_mobilier.mobilier_id
LEFT JOIN app.contenant ON contenant_mobilier.contenant_id = contenant.id
GROUP BY a.id
)

SELECT
 a.id,
 a.ue_decouverte,
 a.ue_decouverte_nature,
 a.ue_structure_lien,
 a.nature_structure,
 a.numero,
 a.matiere_premiere,
 a.technologie,
 a.typologie,
 a.precision,
 a.cortex,
 a.talon,
 a.accident_taille,
 a.alteration,
 a.type_percussion,
 a.type_debitage,
 a.commentaire,
 a.determination,
 a.etat_conservation,
 a.objet_lot,
 a.nombre_elements,
 a.fragment,
 a.chrono_debut,
 a.sous_chrono_debut,
 a.chrono_fin, 
 a.sous_chrono_fin,
 a.poid,
 a.largeur,
 a.longueur,
 a.epaisseur,
 b.contenants
FROM a
LEFT JOIN b ON a.id = b.id
ORDER BY a.ue_decouverte, a.numero;