SELECT
  ue.numero AS num_ue,
  COALESCE(ue_rl1.numero, ue.numero) AS num_str,
  (SELECT numero FROM app.ue WHERE mobilier.id_ue_localisation = ue.id) AS ue_localisation,
  mobilier.id,
  mobilier.numero,
  mobydick.mob_contenus,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS matiere,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS matiere_type_precision,
  regexp_replace(mobilier.commentaire, '\r|\n', '', 'g') AS commentaire,
  mobilier.precision,
  mobilier.determination,
 (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_objet_ou_lot) AS objet_lot,
  mobilier.nombre_elements AS nbr,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_etat_sanitaire) AS "Etat sanitaire", 
  mobilier.etat_representativite AS "Représentativité", 
  contenant.numero AS contenant,
  
  -- champs spécialistes cérmiques
  mceramique.categorie, 
  mceramique."type", 
  mceramique.pate,
  COALESCE(mceramique."bord", 0) AS "bord",
  COALESCE(mceramique."panse", 0) AS "panse",
  COALESCE(mceramique."fond", 0) AS "fond",
  COALESCE(mceramique."anse", 0) AS "anse",
  mceramique.nmi,
  mceramique.cuisson,
  mceramique.decor,
  mceramique.description_bord,
  mceramique.description_col,
  mceramique.description_epaulement,
  mceramique.description_fond,
  mceramique.description_levre,
  mceramique.description_panse,
  mceramique.faconnage,
  mceramique.traitement_surface,
  mceramique.ref_biblio,
  
  -- chronologie
  mobilier.taq,
  mobilier.tpq,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "Chrono début", 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "Sous-Chrono début",  
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS "Chrono fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin ) AS "Sous-chrono fin",  
  -- liste des mesures
  diametre_ext.valeur AS diametre_ext,
  diametre_int.valeur AS diametre_int,
  hauteur.valeur AS hauteur,
  largeur.valeur AS largeur,
  longueur.valeur AS longueur,
  poids.valeur AS poids,
  section_max.valeur AS section_max,
  section_min.valeur AS section_min,
  volume.valeur AS volume,
  epaisseur.valeur AS epaisseur,
  diametre_bord.valeur AS "diamètre bord",
  diametre_col.valeur AS "diamètre col",
  diametre_fond.valeur AS "diamètre fond",
  diametre_panse.valeur AS "diamètre panse",
  hauteur_col.valeur AS "hauteur col",
  hauteur_vase.valeur AS "hauteur vase",
  epaisseur_col.valeur AS "épaisseur col",
  epaisseur_fond.valeur AS "épaisseur fond",
  epaisseur_levre.valeur AS "épaisseur lèvre",
  epaisseur_panse.valeur AS "épaisseur panse",
  (SELECT valeur FROM app.liste WHERE liste.id = traitement.id_traitement_niveau_1)
    || ' - ' ||
	(SELECT valeur FROM app.liste WHERE liste.id = traitement.id_traitement_niveau_2) AS traitement,
  (SELECT valeur FROM app.liste WHERE liste.id = regie.id_mouvement_niveau_1)
    || ' - ' ||
	(SELECT valeur FROM app.liste WHERE liste.id = regie.id_mouvement_niveau_2) AS regie

FROM app.mobilier

LEFT JOIN app.mceramique ON mobilier.id = mceramique.id

-- jointure des différentes UEs liées
JOIN app.ue ON ue.id = mobilier.id_ue
LEFT JOIN app.relationstratigraphique AS rl1 ON ue.id = rl1.ue1 AND rl1.id_relation = 2238
LEFT JOIN app.ue AS ue_rl1 ON ue_rl1.id = rl1.ue2

-- jointure mobilier appartenance
LEFT JOIN 
(SELECT 
  relationintermobilier.mobilier1,
  array_to_string(array_agg(lot.numero ORDER BY numero), ', ') AS mob_contenus
FROM app.relationintermobilier 
JOIN app.mobilier AS lot ON relationintermobilier.mobilier2 = lot.id
WHERE relationintermobilier.id_relation = 51
GROUP BY relationintermobilier.mobilier1
) as mobydick ON mobydick.mobilier1 = mobilier.id

-- jointure des contenants
LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
LEFT JOIN app.contenant ON contenant_mobilier.contenant_id = contenant.id

-- jointure des traitement et régie
LEFT JOIN app.traitement_mobilier ON traitement_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.traitement ON traitement.id = traitement_mobilier.traitement_id
LEFT JOIN app.regie ON traitement.id_regie = regie.id

-- jointure des mesures
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 570) AS diametre_ext ON diametre_ext.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 572) AS diametre_int ON diametre_int.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 571) AS hauteur ON hauteur.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 566) AS largeur ON largeur.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 568) AS longueur ON longueur.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 569) AS poids ON poids.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 565) AS section_max ON section_max.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 564) AS section_min ON section_min.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 563) AS volume ON volume.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesure WHERE id_type_mesure = 567) AS epaisseur ON epaisseur.id_mobilier = mobilier.id
-- jointure des mesures céramiques spécialistes
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2245) AS diametre_bord ON diametre_bord.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2248) AS diametre_col ON diametre_col.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2240) AS diametre_fond ON diametre_fond.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2243) AS diametre_panse ON diametre_panse.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2247) AS hauteur_col ON hauteur_col.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2242) AS hauteur_vase ON hauteur_vase.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2246) AS epaisseur_col ON epaisseur_col.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2241) AS epaisseur_fond ON epaisseur_fond.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2239) AS epaisseur_levre ON epaisseur_levre.id_mobilier = mobilier.id
LEFT JOIN (SELECT id_mobilier, id_type_mesure, valeur FROM app.mesureceramique WHERE id_type_mesure = 2244) AS epaisseur_panse ON epaisseur_panse.id_mobilier = mobilier.id

WHERE 
  ue.id_projet = 839
  AND mobilier.id_matiere_type = 296;
