-- indique les valeurs en double dans les listes
WITH source AS (
	SELECT
	  type_liste,
	  valeur,
	  count(valeur) AS nbr,
	  array_to_string(array_agg(id ORDER BY id), ', ') AS "ids"
	FROM app.liste
	GROUP BY type_liste, valeur)
SELECT 
  type_liste,
  valeur,
  nbr,
  ids
FROM source
WHERE nbr > 1
ORDER BY type_liste, valeur;

-- remplacement d'une des valeurs en double et suppression

UPDATE app.contenant SET id_longueur_predefinie = 734 WHERE id_longueur_predefinie = 2845;
UPDATE app.liste_liste SET id_liste_parent = 734 WHERE id_liste_parent = 2845 AND id_liste_child > 2800;
UPDATE app.liste_liste SET id_liste_child = 734 WHERE id_liste_child = 2845;
DELETE FROM app.liste_liste WHERE id_liste_parent = 2845;
DELETE FROM app.liste WHERE id = 2845;

type_liste	valeur	nbr	ids
ListeArcheozoologieOsPartieConcerne	épiphyse distale	2	1581, 2957
ListeArcheozoologieOsPartieConcerne	épiphyse proximale	2	1624, 2958
ListeMatiereTypePrecision	phtanite	2	2849, 2945
ListeEspece	équidé	2	562, 3013

id_matiere_type_precision
id_os_partie_concernee
id_espece

-- remplacement d'une des valeurs en double
UPDATE app.marcheozoologie 
SET id_os_partie_concernee = 1624
WHERE id_os_partie_concernee = 2958;

-- suppression des relations entre valeurs de liste
SELECT
 *
FROM app.liste_liste 
WHERE 
  id_liste_parent = 2958 
  OR id_liste_child = 2958
  OR id_liste_child = 1624

UPDATE app.liste_liste 
SET id_liste_parent = 2849 
WHERE 
  id_liste_parent = 2945 
  AND id_liste_child > 2800;

UPDATE app.liste_liste 
SET id_liste_child = 734 
WHERE id_liste_child = 2845;

BEGIN;

DELETE FROM app.liste_liste 
WHERE id_liste_child = 2958;
DELETE FROM app.liste WHERE id = 2958;

COMMIT;