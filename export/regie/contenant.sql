-- export des contenants d'un projet avec sa matière et les matières des mobliers contenus

SELECT 
  a.id,
  a.numero,
  (SELECT liste.valeur FROM app.liste WHERE liste.id = a.id_matiere_contenant) AS matiere,
  array_to_string(array_agg(DISTINCT (SELECT liste.valeur FROM app.liste WHERE liste.id = c.id_matiere_type)), ', ') AS mobiliers
FROM app.contenant AS "a"
LEFT JOIN app.contenant_mobilier AS "b" 
  ON b.contenant_id = a.id
LEFT JOIN app.mobilier AS "c" 
  ON c.id = b.mobilier_id
LEFT JOIN app.ue AS "d" 
  ON d.id = c.id_ue
WHERE d.id_projet = 206
GROUP BY 
  a.id, 
  a.numero, 
  matiere
ORDER BY 
  matiere, 
  mobiliers, 
  numero;

-- export d'une liste des contenants de documentation par projet

WITH source AS (
  SELECT DISTINCT
   b.contenant_id,
   c.id_projet
  FROM app.contenant_document AS "b"
  LEFT JOIN app.document AS "c" ON b.document_id = c.id
)

SELECT
  a.id,
  a.numero,
  projet.intitule
FROM app.contenant AS "a"
LEFT JOIN source ON a.id = source.contenant_id
LEFT JOIN app.projet ON source.id_projet = projet.id
WHERE a.id_type_contenant = 714
ORDER BY intitule;