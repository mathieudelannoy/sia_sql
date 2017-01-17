-- export des différentes valeurs distinctes de détermination
SELECT DISTINCT
  determination
FROM app.mobilier
WHERE determination IS NOT NULL
ORDER BY determination

-- export de toutes les déterminations saisies avec le mobilier associé

SELECT
  id, 
  regexp_replace(determination, '\r|\n', '', 'g') AS determination,
  regexp_replace(commentaire, '\r|\n', '', 'g') AS commentaires
FROM app.mobilier
WHERE determination IS NOT NULL AND determination != commentaire