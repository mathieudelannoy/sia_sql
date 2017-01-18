CREATE VIEW stats.document_format AS
SELECT 
   count(id) AS nbr,
  (SELECT valeur FROM app.liste WHERE liste.id = document.id_format) AS "formats"
FROM app.document
GROUP BY id_format
ORDER BY nbr DESC;