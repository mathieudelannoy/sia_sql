-- identifie les doublons
CREATE OR REPLACE VIEW correction AS
WITH su AS (
SELECT 
  MIN(a.id) AS id,
  a.id_traitement_niveau_1 AS tn1,
  a.id_traitement_niveau_2 AS tn2,
  a.date_validite AS date_validite
FROM app.traitement AS "a"
LEFT JOIN app.traitement_mobilier AS "b" ON a.id = b.traitement_id
LEFT JOIN app.mobilier AS "c" ON b.mobilier_id = c.id
LEFT JOIN app.ue AS "d" ON c.id_ue = d.id
WHERE d.id_projet = 380
GROUP BY a.id_traitement_niveau_1, a.id_traitement_niveau_2, a.date_validite)
SELECT
  sd.id,
  su.id AS id_ok
FROM
 (SELECT
    a.id,
    a.id_traitement_niveau_1 AS tn1,
    a.id_traitement_niveau_2 AS tn2,
    a.date_validite
  FROM app.traitement AS "a"
  LEFT JOIN app.traitement_mobilier AS "b" ON a.id = b.traitement_id
  LEFT JOIN app.mobilier AS "c" ON b.mobilier_id = c.id
  LEFT JOIN app.ue AS "d" ON c.id_ue = d.id
  WHERE d.id_projet = 380) AS sd
LEFT JOIN su ON su.tn1 = sd.tn1 AND su.tn2 = sd.tn2 AND su.date_validite = sd.date_validite
WHERE su.id != sd.id
ORDER BY id_ok, sd.id

-- supprime le lien entre un individu et un traitement
DELETE FROM app.traitement_individu AS "a"
WHERE EXISTS (
  SELECT b.id
  FROM public.correction AS "b"
  WHERE a.traitement_id = b.id
);

-- remplace la référence aux mauvais traitement par le traitement correct
UPDATE app.traitement_mobilier SET traitement_id = correction.id_ok FROM public.correction WHERE traitement_id = correction.id;

-- supprime les traitements orphelins
DELETE FROM app.traitement AS "a"
WHERE NOT EXISTS (
  SELECT b.traitement_id
  FROM app.traitement_individu AS "b"
  WHERE b.traitement_id = a.id)
AND NOT EXISTS (
  SELECT c.traitement_id
  FROM app.traitement_mobilier as "c"
  WHERE c.traitement_id = a.id)
AND a.id_regie IS NULL; -- à enlever si on veut supprimer celles avec une régie orpheline

-- supprime les régies orphelines
DELETE FROM app.regie AS "a"
WHERE NOT EXISTS (
  SELECT b.id_regie
  FROM app.traitement AS "b"
  WHERE a.id = b.id_regie);