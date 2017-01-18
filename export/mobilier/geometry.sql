-- EXPORT PAR TYPE
-- additionne les éléments par UE, matière, type et précision
-- regroupe les déterminations de mobilier par structure
-- TODO enlever les annulées, récup les geom de l'ue d'appartenance

SELECT 
  ue.numero AS "UE",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "Matiere", 
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS "Matiere_type",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS "Matiere_type_precision", 
  array_to_string(array_agg(DISTINCT mobilier.determination ORDER BY mobilier.determination ASC), '; ') AS "Mobiliers_determines",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin) AS "Periode", 
  COALESCE(SUM(mobilier.nombre_elements), 0) AS "Total_elements",
  ST_AsEWKT(ue.the_geom) AS "geom"  
FROM 
  app.ue, 
  app.projet, 
  app.mobilier
WHERE 
  ue.id = mobilier.id_ue AND
  projet.id = ue.id_projet AND
  projet.id = 21
GROUP BY 
  ue.numero,
  mobilier.id_matiere, 
  mobilier.id_matiere_type, 
  mobilier.id_matiere_type_precision,
  mobilier.id_chrono_2_fin,
  ue.the_geom
 ORDER BY 
  mobilier.id_matiere ASC, 
  mobilier.id_matiere_type ASC;
  
-- EXPORT PAR DETERMINATION
-- additionne les éléments par UE, matière, type
-- TODO enlever les annulées, récup les geom de l'ue d'appartenance

SELECT 
  ue.numero AS "UE",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "Matiere", 
  mobilier.determination AS "Determination",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin) AS "Periode", 
  COALESCE(SUM(mobilier.nombre_elements), 0) AS "Total_elements",
  ST_AsEWKT(ue.the_geom) AS "geom"  
FROM 
  app.ue, 
  app.projet, 
  app.mobilier
WHERE 
  ue.id = mobilier.id_ue AND
  projet.id = ue.id_projet AND
  projet.id = 21
GROUP BY 
  ue.numero,
  mobilier.id_matiere, 
  mobilier.determination,
  mobilier.id_chrono_2_fin,
  ue.the_geom
ORDER BY 
  mobilier.determination ASC;

-- EXPORT PAR COMMENTAIRE

SELECT 
  ue.numero AS "UE",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "Matiere", 
  mobilier.determination AS "Determination",
  mobilier.commentaire AS "commentaire",
  COALESCE(SUM(mobilier.nombre_elements), 0) AS "Total_elements",
  ST_AsEWKT(ue.the_geom) AS "geom"  
FROM 
  app.ue, 
  app.projet, 
  app.mobilier
WHERE 
  ue.id = mobilier.id_ue AND
  projet.id = ue.id_projet AND
  projet.id = 21 AND
  mobilier.commentaire LIKE '' -- meule molette marcassite palisson
GROUP BY 
  ue.numero,
  mobilier.id_matiere, 
  mobilier.determination,
  mobilier.commentaire,
  ue.the_geom
ORDER BY 
  mobilier.determination ASC
  mobilier.commentaire ASC;  
  
-- EXPORT DES GEOM DES STRUCTURES D'APPARTENANCE

SELECT 
  ue.numero as "UE_appartenance",
  (SELECT numero FROM app.ue WHERE ue.id = relationstratigraphique.ue1) AS UE_contenu,
  ST_AsEWKT(ue.the_geom) AS "geom_appartenance"
FROM 
  app.ue, 
  app.projet, 
  app.relationstratigraphique
WHERE 
  ue.id = relationstratigraphique.ue2 AND
  projet.id = ue.id_projet AND
  projet.id = 21 AND 
  relationstratigraphique.id_relation = 45
ORDER BY ue.numero ASC;

-- EXPORT AVEC SOMME DES POIDS

SELECT 
  ue.numero,
  mobilier.determination,
  array_to_string(array_agg(DISTINCT (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin)), '; ') AS "Periode",
  SUM(mesure.valeur)
FROM 
  app.projet, 
  app.mobilier, 
  app.mesure, 
  app.ue
WHERE 
  mobilier.determination LIKE 'terre %' AND
  projet.id = ue.id_projet AND
  mobilier.id = mesure.id_mobilier AND
  ue.id = mobilier.id_ue AND
  mesure.id_type_mesure = 569 AND
  projet.id = 21
GROUP BY 
  ue.numero, 
  mobilier.determination
ORDER BY
  mobilier.determination ASC,
  ue.numero ASC;

  array_to_string(, '; ')
  array_to_string(array_agg(), '; ')
  array_to_string(SUM(), '; ')