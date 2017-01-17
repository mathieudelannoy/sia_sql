-- décompte des documents par projet
CREATE VIEW stats.projet_nbr_document AS
WITH source AS (
	SELECT
	  id_projet,
	  COUNT(id) AS nbr
	FROM app.document
	GROUP BY id_projet
	UNION ALL
	SELECT
	  ue.id_projet,
	  COUNT(document.id) AS nbr
	FROM app.document
	LEFT JOIN app.document_mobilier ON document.id = document_mobilier.document_id
	LEFT JOIN app.mobilier ON mobilier.id = document_mobilier.mobilier_id
	LEFT JOIN app.ue ON ue.id = mobilier.id_ue
	WHERE document.id_projet IS NULL
	GROUP BY ue.id_projet
	UNION ALL
	SELECT
	  ue.id_projet,
	  COUNT(document.id) AS nbr
	FROM app.document
	LEFT JOIN app.document_ue ON document.id = document_ue.document_id
	LEFT JOIN app.ue ON ue.id = document_ue.ue_id
	GROUP BY ue.id_projet)
SELECT
  id_projet,
  SUM(nbr) AS total
FROM source
WHERE id_projet IS NOT NULL
GROUP BY id_projet
ORDER BY id_projet;