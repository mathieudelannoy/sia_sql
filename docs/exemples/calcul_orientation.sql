-- rajoute dans la colonne sous_carre le calcul de l'angle entre le centre du carré et le centre du sous carré

UPDATE ed_operations.beaurainville_undersquare
SET sous_carre = c.azimuth
FROM (
	SELECT
	  a.id,
	  a.num_carre,
	  CAST(degrees(ST_Azimuth(ST_Centroid(a.geom), ST_Centroid(b.geom))) AS NUMERIC(5,2)) AS azimuth
	FROM ed_operations.beaurainville_undersquare AS "a"
	JOIN ed_operations.beaurainville_carroyage AS "b" ON a.num_carre = b.num_carre) AS "c"
WHERE beaurainville_undersquare.id = c.id
  

-- indique quels sont les angles calculés et leur effectif
WITH source AS (
SELECT
   CAST(degrees(ST_Azimuth(ST_Centroid(a.geom), ST_Centroid(b.geom))) AS INTEGER) AS azimuth
FROM ed_operations.beaurainville_undersquare AS "a"
JOIN ed_operations.beaurainville_carroyage AS "b" ON a.num_carre = b.num_carre)

SELECT
  azimuth,
  COUNT(azimuth) AS nbr
FROM source
GROUP BY azimuth