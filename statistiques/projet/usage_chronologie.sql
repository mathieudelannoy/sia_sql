-- observation de toutes les références chronologiques des projets de la dir.

CREATE VIEW stats.projet_cda62_chrono AS

SELECT 
  projet.id,
  projet.intitule,
  source.type_datation,
  source.debut_nv1,
  source.debut_nv2,
  source.fin_nv1,
  source.fin_nv2,
  source.tpq,
  source.taq
FROM (
-- périodes chronologiques des phases par projet
SELECT
  projet.id,
  'phase' AS "type_datation",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_1_debut) AS debut_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_2_debut) AS debut_nv2,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_1_fin) AS fin_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = phase.id_chrono_2_fin) AS fin_nv2,
  phase.tpq,
  phase.taq
FROM app.phase
JOIN app.projet ON phase.id_projet = projet.id
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND (phase.id_chrono_1_debut IS NOT NULL 
       OR phase.id_chrono_1_fin IS NOT NULL
	   OR phase.tpq IS NOT NULL 
	   OR phase.taq IS NOT NULL)
  
UNION ALL

-- périodes chronologiques des UE par projet
SELECT DISTINCT
  projet.id,
  'ue' AS "type_datation",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = ue.id_chrono_1_debut) AS debut_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = ue.id_chrono_2_debut) AS debut_nv2,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = ue.id_chrono_1_fin) AS fin_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = ue.id_chrono_2_fin) AS fin_nv2,
  ue.tpq,
  ue.taq
FROM app.ue
JOIN app.projet ON ue.id_projet = projet.id
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND (ue.id_chrono_1_debut IS NOT NULL 
       OR ue.id_chrono_1_fin IS NOT NULL
	   OR ue.tpq IS NOT NULL 
	   OR ue.taq IS NOT NULL)
  
UNION ALL

-- périodes chronologiques des mobiliers par projet
SELECT DISTINCT
  projet.id,
  'mobilier' AS "type_datation",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS debut_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS debut_nv2,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS fin_nv1,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin) AS fin_nv2,
  mobilier.tpq,
  mobilier.taq
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
  AND (mobilier.id_chrono_1_debut IS NOT NULL 
       OR mobilier.id_chrono_1_fin IS NOT NULL
	   OR mobilier.tpq IS NOT NULL 
	   OR mobilier.taq IS NOT NULL)
	   
ORDER BY id, tpq, taq
) AS source
JOIN app.projet ON source.id = projet.id;

COMMENT ON VIEW stats.projet_cda62_chrono
  IS 'liste les informations chrono des projets du cda62 (phase, ue, mobilier)';

-- sélection des projets n'ayant aucune indication chronologique
CREATE VIEW stats.projet_cda62_chrono_absente AS
WITH source AS (
SELECT DISTINCT id
FROM stats.projet_cda62_chrono
)

SELECT
  projet.id,
  projet.intitule
FROM app.projet 
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
JOIN source ON projet.id = source.id
WHERE 
  organisme_id = 1
  AND source.id IS NULL;
  
COMMENT ON VIEW stats.projet_cda62_chrono_absente
  IS 'liste les projets du cda62 n''ayant aucune information chrono)';