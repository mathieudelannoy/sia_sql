/* 
création d'une vue avec tous les contenants de document
la récupération du projet se fait via le document ou sa relation avec le mobilier
*/

CREATE VIEW stats.contenant_inv_document AS
WITH source AS (
-- joindre le projet en utilisant l'id_projet du document
(SELECT DISTINCT contenant_document.contenant_id, document.id_projet
FROM app.contenant_document
JOIN (SELECT id, id_projet FROM app.document WHERE id_projet IS NOT NULL) 
  AS document ON contenant_document.document_id = document.id)
UNION
-- joindre le projet en utilisant une relation ue
(SELECT DISTINCT contenant_document.contenant_id, ue.id_projet
FROM app.contenant_document
LEFT JOIN app.document ON contenant_document.document_id = document.id
LEFT JOIN app.document_ue ON document_ue.document_id = document.id
LEFT JOIN app.ue ON document_ue.ue_id = ue.id
WHERE ue.id_projet IS NOT NULL)
UNION
-- joindre le projet en utilisant une relation mobilier
(SELECT DISTINCT contenant_document.contenant_id, ue.id_projet
FROM app.contenant_document
LEFT JOIN app.document ON contenant_document.document_id = document.id
LEFT JOIN app.document_mobilier ON document_mobilier.document_id = document.id
LEFT JOIN app.mobilier ON document_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
WHERE ue.id_projet IS NOT NULL)
ORDER BY contenant_id)
SELECT
  source.id_projet,
  contenant.id
FROM app.contenant
LEFT JOIN source ON source.contenant_id = contenant.id
LEFT JOIN app.projet ON source.id_projet = projet.id
WHERE
  contenant.id_matiere_contenant = 724
  AND projet.intitule NOT LIKE 'intitu%'
  AND projet.intitule NOT LIKE 'DISPON%'
  AND projet.intitule NOT LIKE 'SRA%'  
  AND projet.id != 7;

/*
export d'une liste de tous les contenants mobiliers
*/

CREATE OR REPLACE VIEW stats.contenant_inv_mobilier AS
SELECT DISTINCT
  ue.id_projet AS id_projet,
  contenant.id
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
WHERE
  contenant.id_matiere_contenant != 724
  AND projet.intitule NOT LIKE 'intitu%'
  AND projet.intitule NOT LIKE 'DISPON%'
  AND projet.intitule NOT LIKE 'SRA%'  
  AND projet.id != 7;  
  
  
  
-- export d'une liste avec tous les contenants

CREATE VIEW stats.contenant_inv_complet AS

WITH source AS (
	SELECT *
	FROM stats.contenant_inv_document
	UNION
	SELECT *
	FROM stats.contenant_inv_mobilier
	ORDER BY id_projet, id
	)

SELECT
  source.id,
  contenant.numero,
  source.id_projet,
  contenant.volume,
  contenant.id_matiere_contenant,
  contenant.id_type_contenant,
  localisation.id_batiment,
  localisation.id_salle,
  localisation.id_etagere,
  localisation.id_tablette
FROM source
LEFT JOIN app.contenant ON source.id = contenant.id
LEFT JOIN app.localisation ON localisation.id = contenant.id_localisation
  

-- export d'une liste avec tous les contenants

CREATE VIEW stats.contenant_inv_complet_lisible AS
WITH source AS (
SELECT *
FROM stats.contenant_inv_document
UNION
SELECT *
FROM stats.contenant_inv_mobilier
ORDER BY id_projet, id)
SELECT
  source.id,
  contenant.numero,
  source.id_projet,
  projet.intitule,
  contenant.volume/1000000 AS "volume_m3",
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS "matiere",
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_type_contenant) AS "type",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM source
LEFT JOIN app.contenant ON source.id = contenant.id
LEFT JOIN app.localisation ON localisation.id = contenant.id_localisation
LEFT JOIN app.projet ON source.id_projet = projet.id
