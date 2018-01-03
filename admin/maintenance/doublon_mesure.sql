/*
- plusieurs épaisseurs sur un même bloc lapidaire
- plusieurs poids pour une fiche mobilier car flemme de faire plusieurs fiches (et pas de total bien sûr car la même personne considère qu'en même que les mobiliers doivent être différenciés)
*/

SELECT 
  count(id_mobilier)
FROM app.mesure 
WHERE app.mesure.id_type_mesure = 569;

SELECT DISTINCT 
  count(id_mobilier)
FROM app.mesure 
WHERE app.mesure.id_type_mesure = 569


--save all mesure
SELECT * FROM app.mesure;

-- type de mesure en double pour un mobilier
SELECT 
  (SELECT valeur FROM app.liste WHERE liste.id = id_type_mesure) AS type_mesure,
  id_mobilier,
  COUNT(id_type_mesure)
FROM app.mesure
WHERE id_mobilier IS NOT NULL
GROUP BY id_type_mesure, id_mobilier
HAVING COUNT(id_type_mesure) > 1
ORDER BY id_type_mesure;

-- type de mesure en double pour une UE
SELECT 
  (SELECT valeur FROM app.liste WHERE liste.id = id_type_mesure) AS type_mesure,
  id_ue,
  COUNT(id_type_mesure)
FROM app.mesure
WHERE id_ue IS NOT NULL
GROUP BY id_type_mesure, id_ue
HAVING COUNT(id_type_mesure) > 1
ORDER BY id_type_mesure


/*
Suppression des doublons de mesures/valeurs pour un mobilier
si le type de mesure et la valeur sont strictement identiques
changer id_monilier par id_ue pour opérer sur les UE
*/

WITH 

source_doublon_strict as (
SELECT 
  id_type_mesure,
  id_mobilier,
  valeur,
  COUNT(id_type_mesure)
FROM app.mesure
WHERE id_mobilier IS NOT NULL
GROUP BY id_type_mesure, id_mobilier, valeur
HAVING COUNT(id_type_mesure) > 1
ORDER BY id_type_mesure),

choix_doublon AS (
SELECT
 id,
 mesure.id_mobilier,
 mesure.id_type_mesure,
 mesure.valeur
FROM app.mesure
JOIN source_doublon_strict ON
   source_doublon_strict.id_type_mesure = mesure.id_type_mesure 
   AND source_doublon_strict.id_mobilier = mesure.id_mobilier
ORDER BY mesure.id_mobilier, mesure.id_type_mesure, valeur),

choix_doublon_suppr AS (
SELECT 
  MAX(id) AS id,
  id_mobilier,
  id_type_mesure,
  valeur
FROM choix_doublon
GROUP BY id_type_mesure, id_mobilier, valeur
ORDER BY MAX(id)
)

/*
DELETE FROM app.mesure
USING choix_doublon_suppr WHERE mesure.id = choix_doublon_suppr.id;
*/

SELECT *
FROM app.mesure
JOIN choix_doublon_suppr ON mesure.id = choix_doublon_suppr.id;

