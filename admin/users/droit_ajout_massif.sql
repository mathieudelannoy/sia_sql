-- pour tous en lecture
INSERT INTO app.projet_individu (id_projet, id_individu, id_fonction, role) 

SELECT id_projet, id_individu, 2830, 'role:mediateur'
FROM (
WITH 
existant AS (
	SELECT 
	  a.id_projet,
	  a.id_individu
	FROM app.projet_individu AS "a"
	JOIN app.individu AS "b" ON a.id_individu = b.id
	WHERE 
		b.active = TRUE 
		AND b.associate = TRUE
		AND b.id_organisme = 1
		AND b.active = TRUE),
	
possible AS (
	SELECT
	  projet.id AS id_projet,
	  b.id AS id_individu
	FROM app.projet
	CROSS JOIN app.individu AS b
	WHERE 
		b.active = TRUE 
		AND b.associate = TRUE
		AND projet.intitule NOT LIKE 'intitule%' 
		AND b.id_organisme = 1
		AND b.active = TRUE)
 
SELECT
  possible.id_projet,
  possible.id_individu
FROM possible
LEFT JOIN existant ON possible.id_projet = existant.id_projet AND possible.id_individu = existant.id_individu
WHERE existant.id_individu IS NULL
ORDER BY possible.id_projet, possible.id_individu
) AS source;

UPDATE app.projet_individu AS a
SET role = b.role::ROLES_ENUM
FROM app.individu AS b
WHERE
  a.id_individu = b.id 
  AND a.id_individu != 23
  AND id_projet >= 571;

UPDATE app.projet_individu AS a
SET role = 'role:specialiste'
WHERE
  a.id_individu = 23 AND id_projet = 526;

SELECT *
FROM app.projet_individu
JOIN app_addons.projet_operateur ON projet_operateur.projet_id = projet_individu.id_projet AND projet_operateur.organisme_id = 2
WHERE projet_individu.id_individu = 29

UPDATE app.projet_individu SET role = 'role:regie' 
FROM (
	SELECT *
	FROM app.projet_individu
	JOIN app_addons.projet_operateur ON projet_operateur.projet_id = projet_individu.id_projet AND projet_operateur.organisme_id = 2
	WHERE projet_individu.id_individu = 29) AS pov
WHERE projet_individu.id_individu =pov.id_individu

UPDATE  t1
SET   email = 
WHERE EXISTS 
        (   SELECT  NULL
            FROM    t2
            WHERE   t1.nom      = t2.nom
                AND t1.prenom   = t2.prenom
                AND t1.email    IS NULL
        )

UPDATE app.projet_individu AS "a"
SET role = 'role:regie' 
WHERE EXISTS (
	SELECT *
	FROM app.projet_individu
	JOIN app_addons.projet_operateur ON projet_operateur.projet_id = projet_individu.id_projet AND projet_operateur.organisme_id = 2
	WHERE 
	  projet_individu.id_individu = 29
	  AND a.id_individu = projet_individu.id_individu
	)

SELECT DISTINCT id_individu
FROM app.projet_individu
JOIN app_addons.projet_operateur ON projet_operateur.projet_id = projet_individu.id_projet AND projet_operateur.organisme_id = 2
WHERE projet_individu.role = 'role:regie'