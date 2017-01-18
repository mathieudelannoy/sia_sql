-- tous les projets où le CDA62 est opérateur principal
CREATE VIEW stats.projet_cda62_total AS
SELECT 
  projet.id, 
  projet.intitule, 
  EXTRACT(ISOYEAR FROM projet.date_debut) AS date_debut, 
  EXTRACT(ISOYEAR FROM projet.date_fin) AS date_fin, 
  projet.adresse, 
  (SELECT valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS "type_projet", 
  projet.surface_accessible, 
  projet.surface_ouverte, 
  projet.surface_pourcent, 
  projet.codes_ea, 
  projet.code_oa, 
  c.nom || ' ' || c.prenom AS RO,
  AsText(projet.the_geom) AS geom_wkt
FROM 
  app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN app.projet_individu AS b ON projet.id = b.id_projet AND b.id_fonction = 20
LEFT JOIN app.individu AS c ON b.id_individu = c.id
WHERE 
  organisme_id = 1 
  AND organisme_role_id = 32
ORDER BY projet.date_debut, projet.intitule ASC;
COMMENT ON VIEW stats.projet_cda62_total IS 'tous les projets où le CDA62 est opérateur principal';