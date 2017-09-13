SELECT
  liste.id AS liste_id,
  liste.valeur,
  code_munsell.interpretation
FROM app.liste
LEFT JOIN app_addons.code_munsell ON liste.id = code_munsell.id
WHERE type_liste = 'ListeMunsell'
