-- volume par projet
CREATE OR REPLACE VIEW stats.contenant_volume_projet AS
SELECT DISTINCT
  intitule,
  CAST(SUM(volume_m3) AS NUMERIC(4,2)) AS "volume_m3"
FROM stats.contenant_inv_complete
WHERE 
  contenant_inv_complete.volume_m3 IS NOT NULL
GROUP BY intitule
ORDER BY volume_m3 DESC;


-- nombre de caisse sans bâtiment par projet
CREATE OR REPLACE VIEW stats.contenant_sans_batiment AS
SELECT DISTINCT
  intitule,
  COUNT(id) AS total
FROM stats.contenant_inv_complete
WHERE numero <= 2000 AND batiment IS NULL
GROUP BY intitule
ORDER BY total DESC;

-- nombre de caisse sans salle par projet

CREATE OR REPLACE VIEW stats.contenant_sans_salle AS
SELECT DISTINCT
  intitule,
  COUNT(id) AS total
FROM stats.contenant_inv_complete
WHERE numero <= 2000 AND salle IS NULL
GROUP BY intitule
ORDER BY total DESC;

-- nombre de caisse sans etagere par projet

CREATE OR REPLACE VIEW stats.contenant_sans_etagere AS
SELECT DISTINCT
  intitule,
  COUNT(id) AS total
FROM stats.contenant_inv_complete
WHERE numero <= 2000 AND etagere IS NULL
GROUP BY intitule
ORDER BY total DESC;

-- nombre de projet par caisse "annuelle"

CREATE OR REPLACE VIEW stats.contenant_diag AS
WITH source AS (
	SELECT numero
	FROM stats.contenant_inv_complete
	WHERE numero >= 2000 AND numero < 10000)
SELECT
  numero,
  count(numero) as nbr_projets
FROM source
GROUP BY numero
ORDER BY numero;