CREATE VIEW update_matrice AS
WITH
-- récupère les UE du projet
  a AS (
  SELECT 
		id AS "ue_id", 
		numero 
		FROM app.ue WHERE id_projet = 809),
-- récupère toutes les matrices géologiques
  b AS (
  SELECT 
		a.ue_id,
		COUNT(a.ue_id) AS nbr
 		FROM app.matrice_geologique 
		INNER JOIN "a" ON a.ue_id = id_ue
		WHERE primaire = FALSE
		GROUP BY a.ue_id),
c AS (
	SELECT
	 ue_id
	FROM b
	WHERE nbr = 1)

SELECT * FROM c;

UPDATE app.matrice_geologique 
SET primaire = TRUE
FROM public.update_matrice
WHERE 
  matrice_geologique.id_ue = update_matrice.ue_id
  AND update_matrice.nbr = 1;
  
DROP VIEW update_matrice;