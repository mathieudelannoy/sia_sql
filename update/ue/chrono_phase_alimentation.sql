-- assigne des phases aux UE niveaux à partir de leur mobilier

BEGIN;

CREATE VIEW magic_phase AS
WITH "source_mob_chrono" AS (
SELECT DISTINCT
  mobilier.id_ue,
  mobilier.tpq,
  mobilier.taq,
  mobilier.id_chrono_1_debut,
  mobilier.id_chrono_2_debut,  
  mobilier.id_chrono_1_fin,
  mobilier.id_chrono_2_fin
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
WHERE 
  ue.id_projet =276
  AND mobilier.tpq IS NOT NULL),
"source_ue_conflit" AS (
SELECT
  id_ue,
  count(id_ue) AS nbr
FROM source_mob_chrono
GROUP BY id_ue),
"source_ue_phase" AS (
SELECT DISTINCT
  b.id AS id_phase,
  a.id_ue
FROM source_mob_chrono AS "a"
JOIN app.phase AS "b" ON 
	a.id_chrono_1_debut = b.id_chrono_1_debut 
	AND a.id_chrono_2_debut = b.id_chrono_2_debut 
	AND a.id_chrono_1_fin = b.id_chrono_1_fin 
	AND a.id_chrono_2_fin = b.id_chrono_2_fin
JOIN source_ue_conflit AS "c" ON a.id_ue = c.id_ue
WHERE 
  b.id_projet = 276
  AND c.nbr = 1
ORDER BY b.id)
SELECT * FROM source_ue_phase;

INSERT INTO app.phase_ue (id_phase, id_ue) 
SELECT id_phase, id_ue FROM public.magic_phase;

DROP VIEW public.magic_phase;

COMMIT;

-- assigne les phases aux structures à partir des niveaux
INSERT INTO app.phase_ue
SELECT DISTINCT
  phase_ue.id_phase,
  rs.ue2 AS id_ue
FROM app.ue
JOIN app.phase_ue ON ue.id = phase_ue.id_ue
JOIN app.relationstratigraphique AS "rs" ON ue.id = rs.ue1 AND rs.id_relation = 2238
WHERE ue.id_projet = 276;


-- repérage conflit
WITH
source AS (
SELECT DISTINCT
  phase_ue.id_phase,
  rs.ue2 AS id_ue
FROM app.ue
JOIN app.phase_ue ON ue.id = phase_ue.id_ue
JOIN app.relationstratigraphique AS "rs" ON ue.id = rs.ue1 AND rs.id_relation = 2238
WHERE 
  ue.id_projet = 276),
source_conflit AS (
SELECT
  id_ue,
  count(id_phase) AS nbr,
  array_to_string(array_agg(id_phase), ',')
FROM source
GROUP BY id_ue)

SELECT * 
FROM source_conflit
ORDER BY nbr DESC 
