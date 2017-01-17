---- EXPORT LISTE COMPLETE

SELECT 
  liste.id,
  liste.type_liste, 
  liste.valeur
FROM 
  app.liste
ORDER BY
  liste.type_liste ASC, 
  liste.valeur ASC;

---- EXPORT LISTE UE
SELECT
  e.id AS id_type,
  c.id AS id_nature,
  a.id AS id_interpretation,
  e.valeur AS type,
  c.valeur AS nature,
  a.valeur AS interpretation
FROM app.liste AS "a"
JOIN app.liste_liste AS "b" ON b.id_liste_child = a.id
JOIN app.liste AS "c" ON c.id = b.id_liste_parent AND c.type_liste = 'ListeNatureUE'
JOIN app.liste_liste AS "d" ON d.id_liste_child = c.id
JOIN app.liste AS "e" ON e.id = d.id_liste_parent AND e.type_liste = 'ListeTypeUE'
WHERE a.type_liste = 'ListeInterpretationUE'
ORDER BY type, nature, interpretation


---- EXPORT LISTE MOBILIER GENERAL

CREATE VIEW valeurs_mobilier AS
SELECT
  matiere,
  matiere_type,
  (SELECT liste.valeur FROM app.liste WHERE liste_precision.id_liste_child = liste.id AND
  liste.type_liste = 'ListeMatiereTypePrecision') AS "type_precision"
FROM 
	(SELECT DISTINCT 
		liste.valeur AS "matiere",
		(SELECT liste.id FROM app.liste WHERE matiere_type_list.id_liste_child = liste.id) AS "id_matiere_type",
		(SELECT liste.valeur FROM app.liste WHERE matiere_type_list.id_liste_child = liste.id) AS "matiere_type"
	FROM app.liste
	LEFT JOIN app.liste_liste AS matiere_type_list ON matiere_type_list.id_liste_parent = liste.id
	WHERE liste.type_liste = 'ListeMatiere'	) AS "liste_matiere_et_type"
LEFT JOIN app.liste_liste AS liste_precision ON liste_precision.id_liste_parent = id_matiere_type
ORDER BY matiere, matiere_type, type_precision ASC;

-- EXPORT OS ARCHEOZOO
 
CREATE VIEW "valeurs_os_archeoozoo" AS
WITH source AS (
SELECT
  liste.id AS id_region,
  liste.valeur AS "region",
  (SELECT liste.id FROM app.liste WHERE region.id_liste_child = liste.id) AS "id_os_principal",
  (SELECT liste.valeur FROM app.liste WHERE region.id_liste_child = liste.id) AS "os_principal"  
FROM  app.liste
LEFT JOIN app.liste_liste AS "region" ON region.id_liste_parent = liste.id
WHERE   type_liste = 'ListeArcheozoologieRegionAnatomique'
)
SELECT
  id_region,
  id_os_principal,
  c.id_liste_child AS "id_os_partie",
  region,
  os_principal,
  (SELECT liste.valeur FROM app.liste WHERE c.id_liste_child = liste.id) AS "os_partie"
FROM source
LEFT JOIN app.liste_liste AS c ON c.id_liste_parent = source.id_os_principal
ORDER BY region, os_principal, os_partie ASC;

-- EXPORT OS ANTHROPO
 
CREATE VIEW "valeurs_os_anthropo" AS
SELECT
  region,
  os_principal,
  (SELECT liste.valeur FROM app.liste WHERE liste_partie.id_liste_child = liste.id) AS "os_partie"  
FROM (
	SELECT
	  liste.valeur AS "region",
	  (SELECT liste.id FROM app.liste WHERE region.id_liste_child = liste.id) AS "id_os_principal",
	  (SELECT liste.valeur FROM app.liste WHERE region.id_liste_child = liste.id) AS "os_principal"  
	FROM  app.liste
	LEFT JOIN app.liste_liste AS "region" ON region.id_liste_parent = liste.id
	WHERE   type_liste = 'ListeAnthropologieRegionAnatomique') AS "liste_region_et_principal"
LEFT JOIN app.liste_liste AS liste_partie ON liste_partie.id_liste_parent = liste_region_et_principal.id_os_principal
ORDER BY region, os_principal, os_partie ASC;

-- export lithique

SELECT 
  id,
  type_liste::text,
  valeur
FROM app.liste
WHERE type_liste::text = 'ListeTypologie' OR type_liste::text = 'ListeTechnologie'

--- STAT LISTES

CREATE VIEW "valeurs_par_type_liste" AS
SELECT
  type_liste::text,
  COUNT(type_liste::text) AS "nbr_valeurs"
FROM app.liste
GROUP BY type_liste::text
ORDER BY nbr_valeurs DESC;

--- EXPORT TRAITEMENTS

CREATE VIEW "valeurs_traitement" AS
SELECT
  a.valeur AS "traitement_nv1",
  (SELECT liste.valeur FROM app.liste WHERE b.id_liste_child = liste.id) AS "traitement_nv2"
FROM app.liste AS "a"
LEFT JOIN app.liste_liste AS "b" ON b.id_liste_parent = a.id
WHERE a.type_liste = 'ListeTraitementNiveau1'
ORDER BY traitement_nv1, traitement_nv2;

-- EXPORTS REGIE

CREATE VIEW "valeurs_regie" AS
SELECT
  a.valeur AS "regie_nv1",
  (SELECT liste.valeur FROM app.liste WHERE b.id_liste_child = liste.id) AS "regie_nv2"
FROM app.liste AS "a"
LEFT JOIN app.liste_liste AS "b" ON b.id_liste_parent = a.id
WHERE a.type_liste = 'ListeRegieNiveau1'
ORDER BY regie_nv1, regie_nv2;

-- EXPORT MUNSELL
SELECT
  a.valeur,
  b.interpretation
FROM app.liste AS "a"
LEFT JOIN app_addons.code_munsell AS b On a.id = b.id
WHERE a.type_liste = 'ListeMunsell' AND b.interpretation IS NOT NULL
ORDER BY a.valeur