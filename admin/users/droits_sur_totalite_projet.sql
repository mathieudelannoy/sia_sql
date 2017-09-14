-- permet de créer une relation entre un utilisateur et l'ensemble des projets
-- la sous-requête est là pour déclencher l'usage de l'index

INSERT INTO app.projet_individu (id_projet, id_individu, id_fonction, role)
SELECT
  source.id_projet,
  '239' AS id_individu,
  '2795' AS id_fonction,
  'role:regie' AS role
FROM (
	SELECT
	  projet.id AS id_projet
	FROM app.projet
	WHERE projet.intitule NOT LIKE 'intitule%'
	ORDER BY id_projet
	) AS source

-- la requête est à modifier pour tenir compte des relations existantes
-- UPSERT serait simple ici...