/*
-- nombre d orphelin
UNION
SELECT 
  '' AS "table", 
  count(id) AS "nbr"
FROM app.
WHERE  is null
WHERE NOT EXISTS (SELECT  AS id FROM app. WHERE =)
*/

CREATE OR REPLACE VIEW maintenance.orphelins AS
-- nombre d'ue orphelines
SELECT 
  'ue' AS "table", 
  count(id) AS "nbr"
FROM app.ue
WHERE id_projet IS NULL
-- nombre d'inclusions orphelines
UNION
SELECT 
  'ue_inclusion' AS "table", 
  count(id) AS "nbr"
FROM app.inclusion_geologique
WHERE id_matrice is null
-- nombre d orphelin
UNION
SELECT 
  'ue_matrice' AS "table", 
  count(id) AS "nbr"
FROM app.matrice_geologique
WHERE id_ue is null
-- nombre de mobiliers orphelins
UNION 
SELECT 
  'mobilier' AS "table", 
  count(id) AS "nbr"
FROM app.mobilier
WHERE id_ue is null
-- nombre de traitements orphelins
UNION
SELECT 
  'traitement' AS "table", 
  count(id) AS "nbr"
FROM app.traitement
WHERE NOT EXISTS (SELECT traitement_id AS id FROM app.traitement_mobilier WHERE traitement.id = traitement_mobilier.traitement_id)
UNION
-- nombre de régies orphelines
SELECT 
  'regie' AS "table", 
  count(id) AS "nbr"
FROM app.regie
WHERE NOT EXISTS (SELECT id_regie AS id FROM app.traitement WHERE traitement.id_regie = regie.id)
-- nombre de contenants orphelins
UNION
SELECT 
  'contenants' AS "table", 
  count(id) AS "nbr"
FROM app.contenant
WHERE 
  NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_mobilier 
    WHERE contenant_mobilier.contenant_id = contenant.id) 
  AND NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_document 
    WHERE contenant_document.contenant_id = contenant.id)
AND contenant.id_projet IS NULL
-- nombre de documents orphelins
UNION
SELECT 
  'documents' AS "table", 
  count(id) AS "nbr"
FROM app.document
WHERE 
  NOT EXISTS 
  (SELECT document_id AS id FROM app.document_mobilier 
    WHERE document_mobilier.document_id = document.id) 
  AND NOT EXISTS 
  (SELECT document_id AS id FROM app.document_ue 
    WHERE document_ue.document_id = document.id)
  AND id_projet IS NULL
-- nombre de connexions anthropologiques orphelines
UNION
SELECT 
  'mobilier_anthropo_cnx' AS "table", 
  count(id) AS "nbr"
FROM app.connexionanthropologique
WHERE id_mobilier is null
-- nombre de connexions anthropologiques orphelines
UNION
SELECT 
  'mobilier_anthropo_patho' AS "table", 
  count(id) AS "nbr"
FROM app.pathologie
WHERE id_mobilier is null
-- nombre de mesures générales orphelines
UNION
SELECT 
  'mesures' AS "table", 
  count(id) AS "nbr"
FROM app.mesure
WHERE id_mobilier IS NULL AND id_ue IS NULL
-- nombre de mesures spécialistes orphelines
UNION
SELECT 
  'mesures_anthropo' AS "table", 
  count(id) AS "nbr"
FROM app.mesureanthropologique
WHERE id_mobilier IS NULL
UNION
SELECT 
  'mesures_archeozoo' AS "table", 
  count(id) AS "nbr"
FROM app.mesurearcheozoologique
WHERE id_mobilier IS NULL
UNION
SELECT 
  'mesures_ceram' AS "table", 
  count(id) AS "nbr"
FROM app.mesureceramique
WHERE id_mobilier IS NULL
ORDER BY "table" ASC;