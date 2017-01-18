-- volume par salle
CREATE OR REPLACE VIEW stats.contenant_volume_salle AS
SELECT DISTINCT
  COALESCE("batiment", 'indéterminé') AS batiment,
  COALESCE("salle",'indéterminé') AS salle,
  CAST(SUM(volume_m3) AS NUMERIC(4,2)) AS "volume_m3"
FROM stats.contenant_inv_complete
WHERE numero <= 2000
GROUP BY "batiment", "salle"
ORDER BY "batiment", "salle";