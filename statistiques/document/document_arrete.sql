--numéros d'arrêté enregistrés et projets correspondants

SELECT DISTINCT
  document.id_projet,
  arrete.numero_arrete  
FROM app.arrete
JOIN app.document ON document.id = arrete.id
WHERE arrete.numero_arrete IS NOT NULL
ORDER BY document.id_projet


UPDATE app.arrete
SET arrete.numero_arrete = regexp_replace( regexp_replace( regexp_replace( regexp_replace( regexp_replace( regexp_replace( regexp_replace( regexp_replace( trim(lower(arrete.numero_arrete)), '/diag', '', 'g') , '-', '/', 'g') , '/designation', '', 'g') , '/fouille', '', 'g') , '/bis', '', 'g') , 'bis', '', 'g') , 'ter', '', 'g') , ' diag', '', 'g')

SELECT DISTINCT
  document.id_projet,
  projet.intitule,
  arrete.numero_arrete,
  ST_AsText(ST_Centroid(projet.the_geom)) AS geom
FROM app.arrete
JOIN app.document ON document.id = arrete.id
JOIN app_addons.projet_operateur ON document.id_projet = projet_operateur.projet_id
JOIN app.projet ON projet.id = document.id_projet
WHERE 
  arrete.numero_arrete IS NOT NULL
  AND projet_operateur.organisme_id = 1
  AND projet.the_geom IS NOT NULL
ORDER BY document.id_projet;
