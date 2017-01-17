SELECT
  projet.id,
  projet.intitule,
  (SELECT liste.valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS type_projet,
  organisme.intitule AS operateur,
  individu.nom,
  individu.prenom,
  projet.date_debut,
  projet.date_fin,
  projet.adresse,  
  projet.raison_urgence,
  projet.problematique_recherche,
  regexp_replace(projet.resume_scientifique, '\r|\n', '', 'g') AS resume_scientifique ,
  regexp_replace(projet.thesaurus_geographique, '\r|\n', '', 'g') AS thesaurus_geographique,
  regexp_replace(projet.thesaurus_thematique, '\r|\n', '', 'g') AS thesaurus_thematique,
  projet.surface_accessible,
  projet.surface_ouverte,
  projet.surface_pourcent,
  projet.codes_ea,
  projet.code_oa,
  projet_nbr_ue.nbr AS total_ue,
  projet_nbr_mobilier.nbr AS total_mobilier
FROM app.projet
LEFT JOIN 
  (SELECT id_projet, id_fonction, id_individu FROM app.projet_individu WHERE id_fonction = 20) 
  AS projet_individu ON projet.id = projet_individu.id_projet
LEFT JOIN app.individu ON projet_individu.id_individu = individu.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN app.organisme ON projet_operateur.organisme_id = organisme.id
-- stats
LEFT JOIN (
	  SELECT 
	    ue.id_projet,
	    count(ue.id) as nbr 
	  FROM app.ue
	  GROUP BY ue.id_projet) 
	AS projet_nbr_ue ON projet_nbr_ue.id_projet = projet.id
LEFT JOIN (
	  SELECT 
	    ue.id_projet,
	    COUNT(mobilier.id) AS nbr
	  FROM app.mobilier
	  JOIN app.ue ON mobilier.id_ue = ue.id
	  GROUP BY ue.id_projet)
	  AS projet_nbr_mobilier ON projet_nbr_mobilier.id_projet = projet.id
-- décompte documents à rajouter
-- décompte contenants à rajouter
WHERE projet_operateur.organisme_id = 1
ORDER BY
  projet.intitule,
  projet.date_debut;