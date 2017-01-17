-- liste les projets avec l'organisme et le RO associés
SELECT 
  projet.id, 
  projet.intitule,
  d.intitule AS operateur,  
  projet.code_oa,
  c.nom,
  c.prenom
FROM app.projet
LEFT JOIN app_addons.projet_operateur AS "a" ON projet.id = a.projet_id
LEFT JOIN app.projet_individu AS "b" ON projet.id = b.id_projet
LEFT JOIN app.individu AS "c" ON b.id_individu = c.id
LEFT JOIN app.organisme AS "d" ON a.organisme_id = d.id
WHERE 
  projet.intitule NOT LIKE '%coll%'
  AND projet.intitule NOT LIKE 'DISPONIBLE%'
  AND projet.intitule NOT LIKE 'intitule%'
  AND projet.intitule NOT LIKE 'SRA%'
  AND projet.intitule != 'Test !'
  AND b.id_fonction = 20
  AND a.organisme_role_id = 32
ORDER BY projet.intitule;