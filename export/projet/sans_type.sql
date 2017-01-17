-- projets dont le type est indéterminé

SELECT 
  projet.id, 
  projet.intitule, 
  projet.code_oa
FROM app.projet
WHERE 
  projet.id_type_projet IS NULL
  AND projet.intitule NOT LIKE 'DISPONIBLE%'
  AND projet.intitule NOT LIKE 'intitule%'
  AND projet.intitule NOT LIKE 'SRA%'