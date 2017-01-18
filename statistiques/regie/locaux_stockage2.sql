SELECT
  id,
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM app.localisation

SELECT
  id,
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM app.localisation
ORDER BY batiment, salle , etagere

SELECT DISTINCT
  id_batiment,
  id_salle,
  id_etagere
FROM app.localisation
ORDER BY id_batiment, id_salle , id_etagere


WITH source AS (
SELECT
  id,
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere"
FROM app.localisation
WHERE id_tablette IS NULL
ORDER BY batiment, salle , etagere
)
SELECT
 source.id
FROM public.loc
LEFT JOIN source ON source.salle::int = loc.salle AND source.etagere = loc.etagere

SELECT 
  id,
  volume
from app.contenant
WHERE volume = 12500000

