-- export des identifiants de contenants n'étant lié qu'à du mobilier fictif

CREATE VIEW stats.contenant_fumeux AS
WITH
-- liste des contenants ayant du mobilier fictif
avec_fictif AS (
	SELECT DISTINCT
	  contenant_mobilier.contenant_id
	FROM app.mobilier
	LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
	WHERE mobilier.numero >= 10000
	ORDER BY contenant_mobilier.contenant_id),
-- liste des contenants n'ayant pas de mobilier fictif
sans_fictif AS (
	SELECT DISTINCT
	  contenant_mobilier.contenant_id
	FROM app.mobilier
	LEFT JOIN app.contenant_mobilier ON mobilier.id = contenant_mobilier.mobilier_id
	WHERE mobilier.numero < 10000),
-- liste les contenants n'ayant que du fictif
mix_fictif AS (
SELECT
  avec_fictif.contenant_id AS "avec",
  sans_fictif.contenant_id AS "sans"
FROM avec_fictif
LEFT JOIN sans_fictif ON avec_fictif.contenant_id = sans_fictif.contenant_id
ORDER BY sans)

SELECT
 avec
FROM mix_fictif
WHERE sans IS NULL;

COMMENT ON VIEW stats.contenant_fumeux
  IS 'liste des contenants n''étant liés qu''à du mobilier fictif';

-- complète l'export précédent en rajoutant les informations sur les projets et le type de mobliers contenu

SELECT
  c.intitule,
  b.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_matiere_contenant) AS "matiere",
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_type_contenant) AS "type"
FROM stats.contenant_fumeux AS "a"
LEFT JOIN stats.contenant_inv_complet AS "b" ON b.id = a.avec
LEFT JOIN app.projet AS "c" ON b.id_projet = c.id
WHERE 
  b.id_matiere_contenant != 724
  
-- exporte le total par projet des contenants à problèmes

SELECT
  c.intitule,
  COUNT(a.avec) AS nbr
FROM stats.contenant_fumeux AS "a"
LEFT JOIN stats.contenant_inv_complet AS "b" ON b.id = a.avec
LEFT JOIN app.projet AS "c" ON b.id_projet = c.id
WHERE 
  b.id_matiere_contenant != 724
GROUP BY c.intitule
ORDER BY nbr DESC;