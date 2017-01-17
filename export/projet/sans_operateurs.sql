-- projets sans opérateurs associés
SELECT projet.id, projet.intitule, projet.code_oa
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  projet_operateur.organisme_id IS NULL 
  AND projet.intitule NOT LIKE '%coll%'
  AND projet.intitule NOT LIKE 'DISPONIBLE%'
  AND projet.intitule NOT LIKE 'intitule%'
  AND projet.intitule NOT LIKE 'SRA%'
  AND projet.intitule != 'Test !'
ORDER BY projet.intitule;
