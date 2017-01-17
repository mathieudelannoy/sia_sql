-- recherche d'UE non valides

SELECT  
  id,
  numero,
  id_projet,
  ST_AsText(the_geom)
FROM app.ue
WHERE 
  ST_IsValidReason(the_geom) != 'Valid Geometry'