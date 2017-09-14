-- export avec la géométrie d'origine au format WKT
SELECT
  projet.id,
  projet.intitule,
  date_part('isoyear'::text, projet.date_debut) AS date_debut,
  date_part('isoyear'::text, projet.date_fin) AS date_fin,
  projet.adresse, 
  (SELECT liste.valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS type_projet,
  projet.raison_urgence,
  -- projet.problematique_recherche,
  -- projet.resume_scientifique,
  -- projet.thesaurus_geographique,
  -- projet.thesaurus_thematique,
  -- projet.surface_accessible,
  -- projet.surface_ouverte,
  -- projet.surface_pourcent,
  -- projet.codes_ea,
  projet.code_oa,
  date_part('isoyear'::text, projet.creation) AS creation_sia,
  ST_AsText(ST_Transform(projet.the_geom, 2154)) AS wtk_geom
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE projet_operateur.organisme_id = 1
ORDER BY projet.intitule, projet.date_debut;
