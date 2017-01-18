-- pour tous en lecture
INSERT INTO app.projet_individu (id_projet, id_individu, id_fonction, role) 
SELECT source.id_projet, source.id_individu, 13, 'role:mediateur'
FROM (
WITH 
existant AS (
	SELECT 
	  a.id_projet,
	  a.id_individu 
	FROM app.projet_individu AS "a"
	JOIN app.individu AS "b" ON a.id_individu = b.id
	WHERE b.id_organisme = 1),
possible AS (
	SELECT
	  projet.id AS id_projet,
	  individu.id AS id_individu
	FROM app.projet
	CROSS JOIN app.individu
	WHERE 
	  individu.id_organisme = 6
	  AND mot_de_passe != 'rien'
	  AND projet.intitule NOT LIKE 'intitule%'),
total AS (
	SELECT
	  possible.id_projet,
	  possible.id_individu
	FROM possible
	LEFT JOIN existant ON possible.id_projet = existant.id_projet AND possible.id_individu = existant.id_individu
	WHERE existant.id_individu IS NULL
	ORDER BY possible.id_projet, possible.id_individu)
SELECT
 total.id_projet,
 total.id_individu,
 projet_individu.id_projet AS doublon
FROM total
LEFT JOIN app.projet_individu ON projet_individu.id_projet = total.id_projet AND projet_individu.id_individu = total.id_individu
WHERE projet_individu.id_projet IS NULL
) AS source;

INSERT INTO app.projet_individu (id_projet, id_individu, id_fonction, role) 
SELECT source.id, 197, 13, 'role:mediateur'
FROM (
SELECT
  projet.id
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id 
WHERE projet_operateur.organisme_id = 1
ORDER BY projet.id) AS source;

DELETE FROM app.projet_individu WHERE individu_id = 193;


