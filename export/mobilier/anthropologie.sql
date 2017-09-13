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
  contenant.numero AS contenant
FROM app.mobilier

--LEFT JOIN app.mceramique ON mobilier.id = mceramique.id

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

WHERE
  ue.id_projet = 748
  AND mobilier.id_matiere_type = 1832;