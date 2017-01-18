-- extrait les différentes chronologies de mobilier

SELECT DISTINCT
  mobilier.tpq,
  mobilier.taq,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "Chrono début", 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "Sous-Chrono début",  
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS "Chrono fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin ) AS "Sous-chrono fin"
FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id
WHERE ue.id_projet =276
ORDER BY mobilier.tpq, mobilier.taq

-- indique les UE disposant de plusieurs chrono mobilier

WITH "source_mob_chrono" AS (
SELECT DISTINCT
  ue.numero,
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
  numero,
  count(numero) AS nbr
FROM source_mob_chrono
GROUP BY numero)

SELECT *
FROM source_ue_conflit
WHERE nbr > 1

-- sélectionne les mobiliers d'une UE avec datation en conflit
SELECT 
  ue.numero,
  mobilier.id,
    mobilier.numero,
(SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS "type",
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
  AND mobilier.tpq IS NOT NULL
  AND ue.numero = 267


