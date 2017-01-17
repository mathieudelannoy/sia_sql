-- liste des projets avec les informations de surface
SELECT
  projet.id,
  projet.intitule,
  EXTRACT(YEAR FROM projet.date_debut) as date_debut,
  projet.surface_accessible,
  projet.surface_ouverte,
  projet.surface_pourcent,
  ST_Area(ST_Transform(ST_Multi(projet.the_geom), 2154))::int AS surface_geom,
  projet.code_oa
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet_operateur.organisme_id = 1
  --AND the_geom IS NOT NULL
  AND ST_geometrytype(the_geom) != 'ST_Point'
  AND EXTRACT(YEAR FROM projet.date_debut) >= 2012
ORDER BY date_debut

