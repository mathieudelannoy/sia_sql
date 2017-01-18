CREATE VIEW stats.contenant_volume_global AS
SELECT 
  CAST(SUM(volume_m3) AS NUMERIC(5,2)) AS "volume_m3"
FROM stats.contenant_inv_complete
WHERE numero <= 2000
