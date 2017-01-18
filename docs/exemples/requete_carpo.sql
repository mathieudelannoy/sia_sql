-- requêtes utilisés sur une base sqlite avec des données importées d'un tableur excel pour des études de densité

SELECT ROWID, "PK_UID", "id_type", "nbr", "ue"
FROM "taxons"
ORDER BY ROWID

CREATE VIEW total_taxons_par_ue AS
SELECT "ue", SUM(nbr) AS total
FROM "taxons"
GROUP BY "ue"
ORDER BY total DESC;

CREATE VIEW total_taxons_par_categorie AS
SELECT
  typo.categorie,
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type
GROUP BY typo.categorie
ORDER BY categorie ASC;

CREATE VIEW total_taxons_par_categorie_noshit AS
SELECT
  typo.categorie,
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type
WHERE taxons.id_type != 73 AND taxons.id_type != 34
GROUP BY typo.categorie
ORDER BY categorie ASC;

CREATE VIEW total_taxons_par_type AS
SELECT
  typo.categorie,
  typo.nom_scientifique,
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type
GROUP BY typo.categorie, typo.nom_scientifique
ORDER BY typo.categorie, typo.nom_scientifique ASC;

CREATE VIEW total_taxons_par_type_noshit AS
SELECT
  typo.categorie,
  typo.nom_scientifique,
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type
WHERE taxons.id_type != 73 AND taxons.id_type != 34
GROUP BY typo.categorie, typo.nom_scientifique
ORDER BY typo.categorie, typo.nom_scientifique ASC;

CREATE VIEW total_taxons_total_noshit AS
SELECT
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type
WHERE taxons.id_type != 73 AND taxons.id_type != 34;

CREATE VIEW total_taxons_total AS
SELECT
  SUM(nbr) AS total
FROM "taxons"
JOIN typo ON typo.id_type = taxons.id_type;

---

SELECT
FROM "taxons"
LEFT JOIN formes 

SELECT DISTINCT * FROM "taxons_geoloc"
WHERE Geometry IS NULL;

CREATE VIEW "taxons_geoloc" AS
SELECT "a"."id_type" AS "id_type", "a"."nbr" AS "nbr",
    "a"."ue" AS "ue", "b"."ROWID" AS "ROWID"
FROM "taxons" AS "a"
LEFT JOIN "formes" AS "b" ON ("a"."ue" = "b"."numero")
ORDER BY "a"."ue", "a"."id_type";

CREATE VIEW "taxons_geoloc_point" AS
SELECT
  id_type,
  nbr,
  ue,
  ST_PointOnSurface(Geometry) AS Geometry
FROM 'taxons_geoloc';

CREATE TABLE "formes_point" AS
SELECT
  numero,
  ST_PointOnSurface(Geometry) AS Geometry
FROM 'formes';

-- Question 1 : 

-- Question 2 : distribution desnité moyenne par litre de sédiment sans MOA

CREATE VIEW densite_par_litre_geoloc_pt AS
SELECT
  a.rowid, a.ue, a.densite_litre, b.Geometry
FROM densite_par_litre AS "a"
JOIN formes_point AS "b" ON a.ue = b.numero;

CREATE VIEW densite_par_litre_geoloc_pt AS
SELECT 
  a.ue, 
  a.densite_litre,
  b.ROWID AS ROWID,
  b.Geometry AS Geometry
FROM densite_par_litre AS a
JOIN formes_point AS b ON (a.ue = b.numero)

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column)
  VALUES ('densite_par_litre_geoloc_pt', 'geometry', 'rowid', 'formes_point', 'geometry');

-- Question 3 : Distribution de la MOAC

SELECT * FROM taxons WHERE id_type = 34;

CREATE VIEW "distribution_moac" AS
SELECT 
  a.ue, a.nbr, b.ROWID, b.Geometry
FROM "taxons" AS "a"
JOIN "formes_point" AS "b" ON ("a"."ue" = "b"."numero")
WHERE a.id_type = 34;

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_moac', 'geometry', 'rowid', 'formes_point', 'geometry', 1);
  
-- Question 4 : distribution des ceralia indterminata 33 32

CREATE VIEW "distribution_cerealia_ind" AS
SELECT 
  a.ue, a.nbr, b.ROWID, b.Geometry
FROM "taxons" AS "a"
JOIN "formes_point" AS "b" ON ("a"."ue" = "b"."numero")
WHERE a.id_type = 32;

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_cerealia_ind', 'geometry', 'rowid', 'formes_point', 'geometry', 1);

-- Question 5 : distribution des blés vêtus 6 et 12

CREATE VIEW "distribution_bles_vetu" AS
SELECT 
  a.ue, SUM(a.nbr) AS nbr, b.ROWID, b.Geometry
FROM "taxons" AS "a"
JOIN "formes_point" AS "b" ON ("a"."ue" = "b"."numero")
WHERE a.id_type = 6 OR a.id_type = 12
GROUP BY a.ue;

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_bles_vetu', 'geometry', 'rowid', 'formes_point', 'geometry', 1);
  
-- Question 6 :distribution des orges

CREATE VIEW "distribution_orges" AS
SELECT 
  a.ue, SUM(a.nbr) AS nbr, b.ROWID, b.Geometry
FROM "taxons" AS "a"
JOIN "formes_point" AS "b" ON ("a"."ue" = "b"."numero")
WHERE a.id_type = 19 OR a.id_type = 24 OR a.id_type = 22
GROUP BY a.ue;

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_orges', 'geometry', 'rowid', 'formes_point', 'geometry', 1);
  
-- distribution des fruits

CREATE VIEW "distribution_fruit" AS
SELECT 
  a.ue, SUM(a.nbr) AS nbr, b.ROWID, b.Geometry
FROM "taxons" AS "a"
JOIN "formes_point" AS "b" ON ("a"."ue" = "b"."numero")
WHERE a.id_type = 36 OR a.id_type = 38 OR a.id_type = 40
GROUP BY a.ue;

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_fruit', 'geometry', 'rowid', 'formes_point', 'geometry', 1);
  
-- CAMEMBERT

CREATE VIEW "distribution_par_camembert" AS
SELECT
 a.num,
 b.nbr AS cerealia_ind,
 c.nbr AS hordeum_vulgare_var_nudum,
 d.nbr AS hordeum_vulgare,
 e.nbr AS triticum_monococcum,
 f.nbr AS triticum_dicoccon,
 g.nbr AS triticum_sp,
 h.ROWID, h.Geometry
FROM liste_ue AS a
LEFT JOIN taxons AS b ON b.ue = a.num AND b.id_type = 32
LEFT JOIN taxons AS c ON c.ue = a.num AND c.id_type = 22
LEFT JOIN taxons AS d ON d.ue = a.num AND d.id_type = 19
LEFT JOIN taxons AS e ON e.ue = a.num AND e.id_type = 12
LEFT JOIN taxons AS f ON f.ue = a.num AND f.id_type = 6
LEFT JOIN taxons AS g ON g.ue = a.num AND g.id_type = 1
JOIN formes_point AS "h" ON a.num = h.numero
WHERE stats = 'camembert';

INSERT INTO views_geometry_columns (view_name, view_geometry, view_rowid, f_table_name, f_geometry_column, read_only)
  VALUES ('distribution_par_camembert', 'geometry', 'rowid', 'formes_point', 'geometry', 1);

6	Céréales	Triticum dicoccon
12	Céréales	Triticum monococcum
22	Céréales	Hordeum vulgare var. nudum
19	Céréales	Hordeum vulgare
1	Céréales	Triticum sp.
32	Céréales	Cerealia indeterminata

-- balle = Triticum monococcum bases de glumes + Triticum monococcum bases d'épillets +Triticum dicoccon bases de glumes + Triticum dicoccon bases d'épillets
-- 10 + 11 + 3 + 4
-- VS grains de blés = Triticum dicoccon + Triticum monococcum
--
SELECT
 a.num,
 (b.nbr + c.nbr + d.nbr + e.nbr) AS balle,
 (f.nbr + g.nbr) AS grains,
  h.ROWID, 
  St_AsText(h.Geometry) AS WKT_geom
FROM liste_ue AS a
-- balle
LEFT JOIN taxons AS b ON b.ue = a.num AND b.id_type = 3
LEFT JOIN taxons AS c ON c.ue = a.num AND c.id_type = 4
LEFT JOIN taxons AS d ON d.ue = a.num AND d.id_type = 10
LEFT JOIN taxons AS e ON e.ue = a.num AND e.id_type = 11
-- grain
LEFT JOIN taxons AS f ON f.ue = a.num AND f.id_type = 6
LEFT JOIN taxons AS g ON g.ue = a.num AND g.id_type = 12
LEFT JOIN formes_point AS h ON a.num = h.numero
WHERE 
  stats = 'camembert'
  AND (balle > 0 OR grains > 0);
  

SELECT
  a.numero,
  total_balle,
  total_grain,
  St_AsText(a.Geometry) AS WKT_geom
FROM formes_point AS a
LEFT JOIN (  
SELECT 
  ue,
  SUM(nbr) AS total_balle
FROM taxons
WHERE 
  id_type = 3
  OR id_type = 4
  OR id_type = 10
  OR id_type = 11
GROUP BY ue) AS b ON a.numero = b.ue
 LEFT JOIN (
SELECT 
  ue,
  SUM(nbr) AS total_grain
FROM taxons
WHERE 
  id_type = 6
  OR id_type = 12
GROUP BY ue) AS c ON a.numero = c.ue
WHERE total_balle > 0 OR total_grain > 0;
