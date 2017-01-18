-- supprimer de document_ue les relations où les projet du doc et de l'ue ne collent pas
DELETE FROM app.document_ue
WHERE 
document_id IN
(SELECT
  a.document_id
FROM app.document_ue AS "a"
LEFT JOIN app.ue AS "b" ON a.ue_id = b.id
LEFT JOIN app.document AS "c" ON a.document_id = c.id
WHERE b.id_projet != c.id_projet)
AND
ue_id IN
(SELECT
  a.ue_id
FROM app.document_ue AS "a"
LEFT JOIN app.ue AS "b" ON a.ue_id = b.id
LEFT JOIN app.document AS "c" ON a.document_id = c.id
WHERE b.id_projet != c.id_projet)

DELETE FROM app.document WHERE id = 12162;
DELETE FROM app.document_individu WHERE document_id = 12162;


--- supprime les relations entre des docs et des mobiliers

DELETE FROM app.document_mobilier AS a
WHERE EXISTS (
  SELECT 
   b.document_id
  FROM app.document_mobilier AS b
  LEFT JOIN app.document ON b.document_id = document.id
  LEFT JOIN app.mobilier ON mobilier.id = b.mobilier_id
  LEFT JOIN app.ue ON ue.id = mobilier.id_ue
  WHERE 
    ue.id_projet = 155
    AND document.id_sous_typologie = 774
	AND a.document_id = b.document_id);
	
-- supprime
DELETE FROM app.document_individu AS a
--SELECT document_id FROM app.document_individu AS a
WHERE 
  NOT EXISTS (
  SELECT b.document_id
  FROM app.document_mobilier AS b
  WHERE a.document_id = b.document_id
    UNION
  SELECT c.document_id
  FROM app.document_ue AS c
  WHERE a.document_id = c.document_id)
  AND EXISTS (
  SELECT d.id
  FROM app.document AS d
  WHERE a.document_id = d.id AND id_projet IS NULL)
  
-- supprime les cods sans liens avec ue/mobilier
-- SELECT * 

DELETE FROM app.document AS a
WHERE 
  NOT EXISTS (
	SELECT b.document_id
	FROM app.document_mobilier AS b
	WHERE a.id = b.document_id
	  UNION
	SELECT c.document_id
	FROM app.document_ue AS c
	WHERE a.id = c.document_id)
  AND a.id_projet IS NULL