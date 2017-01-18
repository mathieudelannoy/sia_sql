/*

* buffer_iso permet de sélectionner les points se situant à l'intérieur d'une zone tampon d'une coupe
* project_iso va projeter les points sélectionnés le long de cette coupe et créer une nouvelle géométrie à cet emplacement
* axe_iso va calculer la distance cartésienne entre le début de la coupe et l'iso

* ed_operations.coupes_geol correspond à une couche contenant les lignes, il est important qu'elles soient créées dans le bon sens pour que la reqûete iso parte toujours du point ABS
* ed_operations.coupes_geol_iso correspond à la sélection de points faite par cyril

*/
WITH 
buffer_iso AS (
SELECT 
  coupes.id AS numero_coupe,
  iso.numero_iso,
  iso.type,
  iso.couche,
  iso.nature,
  iso.legende,
  CAST(iso."Z" AS NUMERIC(5,2)) AS axe_z,
  iso.geom
FROM
  ed_operations.coupes_geol_iso AS iso,
  ed_operations.coupes_geol AS coupes
WHERE 
  ST_Within(iso.geom, ST_Buffer(coupes.geom, 1))
),

project_iso AS (
SELECT
  buffer_iso.numero_coupe,
  buffer_iso.numero_iso,
  buffer_iso.type,
  buffer_iso.couche,
  buffer_iso.nature,
  buffer_iso.axe_z,
  buffer_iso.legende,
  ST_Line_Interpolate_Point(
	coupes.geom,
	ST_Line_Locate_Point(
		coupes.geom,
		ST_GeometryN(buffer_iso.geom, 1)
	)
  ) AS geom
FROM buffer_iso
JOIN ed_operations.coupes_geol AS coupes ON coupes.id = buffer_iso.numero_coupe
)

SELECT 
  project_iso.numero_coupe,
  project_iso.numero_iso,
  project_iso.type,
  project_iso.couche,
  project_iso.nature,
  project_iso.legende,
  CAST(ST_Distance(ST_StartPoint(coupes.geom), project_iso.geom) AS NUMERIC(5,2)) AS axe_x,
  project_iso.axe_z
FROM project_iso
JOIN ed_operations.coupes_geol AS coupes ON coupes.id = project_iso.numero_coupe
ORDER BY numero_coupe, axe_x