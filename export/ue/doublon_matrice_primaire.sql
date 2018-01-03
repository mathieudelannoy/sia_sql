-- liste les UE ayant plusieurs matrices primaires

WITH

-- récupère les UE du projet
 a AS (SELECT 
	id AS "ue_id", 
	numero 
	FROM app.ue WHERE id_projet = 813),
	
-- récupère toutes les matrices géologiques
 b AS (SELECT 
	a.numero, 
	id AS "mat_id", 
	id_ue,
	primaire
	FROM app.matrice_geologique 
	INNER JOIN "a" ON a.ue_id = id_ue),

-- groupe par primaire is true
c AS (
SELECT
  numero
FROM b
WHERE primaire IS TRUE
GROUP BY numero, primaire
HAVING count(numero) > 1
ORDER BY numero)

SELECT *
FROM c;


-- liste les UE n'ayant aucune matrice primaire
WITH
-- récupère les UE du projet
 a AS (
	SELECT 
	id AS "ue_id", 
	numero 
	FROM app.ue 
	WHERE id_projet = 846),
	
-- récupère toutes les matrices géologiques primaires
 b AS (
	SELECT 
	a.numero, 
	id AS "mat_id", 
	id_ue,
	primaire
	FROM app.matrice_geologique 
	JOIN "a" ON a.ue_id = id_ue
	),
	
c AS (
	SELECT b.numero
	FROM b
	WHERE NOT EXISTS
	(SELECT d.id_ue, d.primaire FROM b AS d WHERE b.id_ue = d.id_ue AND d.primaire IS TRUE)
	GROUP BY b.numero
	ORDER BY b.numero
	)

SELECT *
FROM c