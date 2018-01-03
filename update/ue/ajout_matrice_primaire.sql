/*
Le script d'export des mattrices nécessite que chaque UE n'ayant qu'une matrice ai une matrice primaire indiquée. Vu que ce n'est pas fait lors de la saisie utilisateur, cette màj le fait.
*/

UPDATE app.matrice_geologique 
SET primaire = TRUE
FROM (

WITH
-- récupère les UE du projet
a AS (
  SELECT 
	  id AS "ue_id", 
	  numero 
	FROM app.ue WHERE id_projet = 821),

-- récupère toutes les UE ayant une matrice primaire
b AS (
	SELECT a.ue_id
	FROM a
	JOIN app.matrice_geologique ON a.ue_id = id_ue
	WHERE primaire = TRUE),

-- récupère toutes les matrices géologiques non-primaires 
-- dont l'UE n'a aucune primaire et qu'une matrice
c AS (
	SELECT 
	  a.ue_id
	FROM app.matrice_geologique 
	INNER JOIN "a" ON a.ue_id = id_ue
	WHERE primaire = FALSE
	GROUP BY a.ue_id
	HAVING COUNT(a.ue_id) = 1)

SELECT * FROM c

) AS update_matrice

WHERE 
  matrice_geologique.id_ue = update_matrice.ue_id;