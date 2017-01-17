-- export pour la génération des bordereaux de remise au SRA
WITH contenant_inv_total AS (
	SELECT DISTINCT
	 b.contenant_id,
	 d.id_projet
	FROM app.contenant_mobilier AS "b"
	LEFT JOIN app.mobilier AS "c" ON b.mobilier_id = c.id
	LEFT JOIN app.ue AS "d" ON c.id_ue = d.id
	  UNION
	SELECT DISTINCT
	 b.contenant_id,
	 c.id_projet
	FROM app.contenant_document AS "b"
	LEFT JOIN app.document AS "c" ON b.document_id = c.id)

SELECT
  x.code_oa,
  date_part('isoyear'::text, x.date_debut) AS "année",
  x.intitule,
  b.matiere_type AS "Matière - Type",
  b.type_contenant || ' ' || COALESCE(b.dimensions, 'dimensions indéterminées') AS "type de contenants et dimensions",
  COUNT(b.matiere_type) AS "Nombre",
  array_to_string(array_agg(DISTINCT b.numero ORDER BY b.numero ASC), ', ') AS "numeros"
FROM contenant_inv_total AS "a"
LEFT JOIN (
SELECT
  contenant.id,
  contenant.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_type_contenant) AS type_contenant,
  contenant.longueur*10 || '*' || contenant.largeur*10 || '*' || contenant.hauteur::int*10 AS dimensions
FROM app.contenant) AS "b" ON a.contenant_id = b.id
LEFT JOIN app.projet AS "x" ON x.id = a.id_projet
LEFT JOIN app_addons.projet_operateur AS "z" ON z.projet_id = x.id
WHERE
   z.organisme_id = 1 
  AND date_part('isoyear'::text, x.date_debut) >= 2015
  AND date_part('isoyear'::text, x.date_fin) <= 2016
  AND en_cours = FALSE
GROUP BY x.code_oa, x.intitule, b.matiere_type, b.type_contenant, b.dimensions, x.date_debut
ORDER BY x.code_oa;