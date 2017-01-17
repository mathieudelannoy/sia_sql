/*
export d'un texte descriptif pour les comblements pouvant être copier sur les planches DAO

Numéro : Nature texture, homogénéité, compacité, code Munsell en toutes lettres (Code Munsell en chiffres) [de la matrice], 
avec concentration taille nature [des inclusions]. 
Mobilier : Type ou Type précision. (+ Matrice secondaire si présente).
*/

WITH

-- récupère les UE du projet
 a AS (SELECT 
	id AS "ue_id", 
	numero 
	FROM app.ue WHERE id_projet = 809),
	
-- récupère toutes les matrices géologiques
 b AS (SELECT 
	a.numero, 
	id AS "mat_id", 
	id_ue, 
	primaire,
	(SELECT valeur FROM app.liste WHERE liste.id = id_texture) || ', ' ||
	  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = id_homogeinite), '') || ', ' ||
	  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = id_compacite), '') 
	  || COALESCE(', ' || (SELECT interpretation FROM app_addons.code_munsell WHERE code_munsell.id = id_munsell) || COALESCE(' (' || (SELECT valeur FROM app.liste WHERE liste.id = id_munsell) || ')', ''), '') AS "matrice"
	FROM app.matrice_geologique 
	INNER JOIN "a" ON a.ue_id = id_ue),

-- récupère les inclusions en les regroupant par matrice et concentrations
c AS (SELECT 
	  id_matrice, 
	  id_concentration,
	  array_to_string(
	    array_agg(
		  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = id_taille), 'éléments') 
		  || ' de ' ||
		  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = id_nature), '?')
		), ', ') AS "taille_nature",
	  COUNT(id_concentration) AS nbr
	FROM app.inclusion_geologique
	INNER JOIN "b" ON id_matrice = b.mat_id
	GROUP BY id_matrice, id_concentration),

-- gère les inclusions sans concentrations
d AS (SELECT
		id_matrice,
		taille_nature AS inclusion
	FROM c
	WHERE id_concentration IS NULL),
-- gère les inclusions seules
e AS (SELECT
		id_matrice,
		(SELECT valeur FROM app.liste WHERE liste.id = id_concentration) || ' ' || taille_nature AS inclusion
	FROM c
	WHERE nbr = 1),
-- gère les inclusions multiples
f AS (SELECT
		id_matrice,
		(SELECT valeur FROM app.liste WHERE liste.id = id_concentration) || ' ' || taille_nature AS inclusion
	FROM c
	WHERE nbr != 1),
-- rassemble les inclusions
g AS (SELECT * FROM d UNION ALL SELECT * FROM e UNION ALL SELECT * FROM f
    ORDER BY id_matrice),
h AS (SELECT
	id_matrice,
	array_to_string(array_agg(inclusion ORDER BY inclusion), ' ; ') AS inclusion
	FROM g 
	GROUP BY id_matrice),
-- filtre les matrices primaires
i AS (SELECT 
		b.numero,
		b.mat_id,
		matrice AS matrice_primaire
		FROM b 
		LEFT JOIN c ON c.id_matrice = b.mat_id
		WHERE b.primaire = TRUE),
-- aggrège les matrices secondaires
j AS (SELECT DISTINCT
		b.numero,
		array_to_string(array_agg(b.matrice), '; ') AS matrice_secondaire
		FROM b 
		LEFT JOIN c ON c.id_matrice = b.mat_id
		WHERE b.primaire = FALSE
		GROUP BY b.numero),
-- FULL REGROUP
k AS (SELECT DISTINCT
  b.numero AS num_ue,
  i.matrice_primaire,
  h.inclusion,
  j.matrice_secondaire
FROM b
LEFT JOIN i ON i.numero = b.numero
LEFT JOIN h ON h.id_matrice = i.mat_id
LEFT JOIN j ON i.numero = j.numero
ORDER BY b.numero),

l AS (
SELECT
  num_ue || ' : ' || 
  upper(substring(matrice_primaire from 1 for 1)) || substring(matrice_primaire from 2 for length(matrice_primaire)) || '. ' || 
  COALESCE(upper(substring(inclusion from 1 for 1)) || substring(inclusion from 2 for length(inclusion)), '*') || 
  COALESCE('. Matrice secondaire : ' || upper(substring(matrice_secondaire from 1 for 1)) || 
  substring(matrice_secondaire from 2 for length(matrice_secondaire)), '*') || '.' AS description
FROM k),

m AS (
SELECT
  replace(replace(replace(replace(replace(replace(
  replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace( replace(replace(replace(replace(replace(replace(replace(
  description,
  -- remplacement typographie
   '. **.', '.'), '*.', '.'), '  ', ' '), ', , ', ', '), ', .', '.'), ', , ', ', '),
  -- remplacement de termes d'inclusion
   'concrétion gros fragments', 'concrétion de gros fragments'),
   'concrétion micro-nodules', 'concrétion de micro-nodules'),
   'concrétion moellons', 'concrétion de moellons'),
   'concrétion nodules', 'concrétion de nodules'),
   'concrétion petits fragments', 'concrétion de petits fragments'),
   'concrétion éclats', 'concrétion d\'éclats'),
   'diffuse éclats', 'éclats diffus'),
   'diffuse gros fragments', 'gros fragments diffus'),
   'diffuse micro-nodules', 'micro-nodules diffus'),
   'diffuse moellons', 'moellons diffus'),
   'diffuse nodules', 'nodules diffus'),
   'percolation moellons', 'percolation de moellons'),
   'percolation nodules', 'percolation de nodules'),
   'percolation petits fragments', 'percolation de petits fragments'),
   'percolation éclats', 'percolation d\'éclats'),
   'percolation micro-nodules', 'percolation de micro-nodules'),
   'percolation gros fragments', 'percolation de gros fragments'),
   'diffuse petits fragments', 'petits fragments diffus'),
   'terre cuite - ', ''),
   'métal - ', 'métal '),
   'oragnique - ', ''),
   'de ardoise', 'd\'ardoise'),
   'de organique', 'd\'organique'),
   'de oxyde', 'd\'oxyde')
	AS description
FROM l)

select * from m;

/*
		-- récupère les mobiliers issus des comblements
  d AS (SELECT DISTINCT
		a.ue_id,
		array_to_string(array_agg(DISTINCT
		(SELECT valeur FROM app.liste WHERE liste.id = d.id_matiere_type) || ' - ' || 
		COALESCE((SELECT valeur FROM app.liste WHERE liste.id = id_matiere_type_precision), '')), ', ') AS mob
		FROM app.mobilier AS "d" 
		LEFT JOIN a ON a.ue_id = d.id_ue
		GROUP BY a.ue_id),
*/