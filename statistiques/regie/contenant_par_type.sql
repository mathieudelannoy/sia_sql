-- répartition par matière
DROP VIEW stats.contenant_par_matiere;
CREATE VIEW stats.contenant_par_matiere AS
SELECT
  (SELECT valeur FROM app.liste WHERE liste.id = id_matiere_contenant) AS "matiere",
  count(numero) AS "nbr_contenant",
  CAST(SUM(volume)/1000000  AS NUMERIC(5,2)) AS "volume_m3"
FROM stats.contenant_inv_complet
WHERE numero <= 2000
GROUP BY id_matiere_contenant
ORDER BY volume_m3 DESC;

-- répartition par type de contenant
DROP VIEW stats.contenant_par_type;
CREATE VIEW stats.contenant_par_type AS
SELECT 
  "type", 
  count(numero) AS "nbr", 
  CAST(SUM(volume_m3) AS NUMERIC(5,2)) AS "volume_m3"
FROM stats.contenant_inv_complete
WHERE numero <= 2000
GROUP BY "type"
ORDER BY "type";



