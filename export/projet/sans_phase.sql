WITH source AS (

SELECT DISTINCT
  projet.id
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
)
  
SELECT
  projet.id,
  projet.intitule,
  c.nom || ' ' || c.prenom AS RO
FROM app.projet 
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN source ON projet.id = source.id
LEFT JOIN app.projet_individu AS b ON projet.id = b.id_projet
LEFT JOIN app.individu AS c ON b.id_individu = c.id
WHERE 
  organisme_id = 1 
  AND source.id IS NULL
  AND b.id_fonction = 20
  AND projet.thesaurus_thematique NOT ILIKE '%négatif%'
ORDER BY RO, projet.intitule;
