WITH source AS (
SELECT
  id,
  intitule, 
  debut_nv1,
  debut_nv2,
  fin_nv1,
  fin_nv2,
  MIN(tpq) AS tpq,
  MAX(taq) AS taq
FROM stats.projet_cda62_chrono
GROUP BY id, intitule, debut_nv1, debut_nv2, fin_nv1, fin_nv2)

SELECT
  nom || ' - ' || prenom AS "RO",
  source.id,
  source.intitule, 
  source.debut_nv1,
  source.debut_nv2,
  source.fin_nv1,
  source.fin_nv2,
  source.tpq,
  source.taq
FROM source
JOIN app.projet_individu ON source.id = projet_individu.id_projet AND id_fonction = 20
JOIN app.individu ON individu.id = projet_individu.id_individu AND (individu.id_organisme = 1 OR individu.id_organisme IS NULL)
WHERE source.debut_nv1 IS NOT NULL