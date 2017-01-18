-- total des projets avec/sans géométrie
CREATE VIEW stats.projet_geom AS
SELECT a.total_null, b.total_notnull
FROM 
 (SELECT count(id) as total_null FROM app.projet WHERE the_geom IS NULL) AS "a",
 (SELECT count(id) as total_notnull FROM app.projet WHERE the_geom IS NOT NULL) AS "b";

-- extraction des projets sans géométrie
SELECT id, intitule, code_oa
FROM (
  SELECT id, intitule, code_oa, the_geom 
  FROM app.projet 
  WHERE projet.intitule NOT LIKE 'DISPONIBLE%' AND 
  projet.intitule NOT LIKE 'Indé%' AND
  projet.intitule NOT LIKE 'intitu%' AND
  id != 7) AS "projet"
WHERE the_geom IS NULL
ORDER BY intitule ASC;

UPDATE app.projet SET the_geom = ST_MakeValid(the_geom);