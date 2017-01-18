-- individu par projet
WITH source AS (
SELECT
  id_projet,
  COUNT(id_individu) AS nbr
FROM app.projet_individu
GROUP BY id_projet)
SELECT 
  'médianne' AS type_info,
  median(nbr)::int AS valeur
FROM source
UNION
SELECT 
  'moyenne' AS type_info,
  avg(nbr)::int AS valeur
FROM source
UNION
SELECT 
  'min' AS type_info,
  min(nbr) AS valeur
FROM source
UNION
SELECT 
  'max' AS type_info,
  max(nbr) AS valeur
FROM source

-- projet par individu
WITH source AS (
SELECT
  id_individu,
  COUNT(id_projet) AS nbr
FROM app.projet_individu
GROUP BY id_individu)
SELECT 
  'médianne' AS type_info,
  median(nbr)::int AS valeur
FROM source
UNION
SELECT 
  'moyenne' AS type_info,
  avg(nbr)::int AS valeur
FROM source
UNION
SELECT 
  'min' AS type_info,
  min(nbr) AS valeur
FROM source
UNION
SELECT 
  'max' AS type_info,
  max(nbr) AS valeur
FROM source


