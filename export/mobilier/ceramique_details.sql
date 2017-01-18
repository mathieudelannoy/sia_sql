-- export des mesures aggrégationnées

SELECT 
  a.id,
  array_to_string(array_agg(c.valeur || ' : ' || b.valeur ORDER BY b.id ASC), '; ') AS mesures
FROM app.mobilier AS "a"
  LEFT OUTER JOIN app.mesure AS "b" ON b.id_mobilier = a.id
  LEFT OUTER JOIN app.liste AS "c" ON b.id_type_mesure = c.id
  RIGHT JOIN app.ue as "d" ON (d.id = a.id_ue AND d.id_projet = 184)
WHERE a.id_matiere_type = 296
GROUP BY a.id
ORDER BY a.id ASC;

-- addition des différents morceaux pour obtenir le total élément par objet

UPDATE
  app.mobilier
  SET nombre_elements = (
	  SELECT COALESCE(mceramique."bord", 0)
		+ COALESCE(mceramique."panse", 0)
		+ COALESCE(mceramique."fond", 0)
		+ COALESCE(mceramique."anse", 0)
		)
FROM 
  app.mceramique, 
  app.ue
WHERE 	
  mobilier.id = mceramique.id AND
  ue.id = mobilier.id_ue AND
  ue.id_projet = 184;
  
-- Export du total des éléments et des NMI par projet
  
SELECT
  COALESCE(mceramique.categorie, 'non renseignée') AS "Catégorie", 
  COALESCE(SUM(mceramique.nmi), 0) AS "Total NMI",
  COALESCE(SUM(mobilier.nombre_elements), 0) AS "Total éléments"
FROM 
  app.mceramique, 
  app.mobilier, 
  app.ue
WHERE 
  mobilier.id = mceramique.id AND
  ue.id = mobilier.id_ue AND
  ue.id_projet = 184
GROUP BY mceramique."categorie";

-- Export du total des éléments et des NMI par projet et par UE
  
SELECT
  ue.numero,
  COALESCE(mceramique.categorie, 'non renseignée') AS "Catégorie", 
  COALESCE(SUM(mceramique.nmi), 0) AS "Total NMI",
  COALESCE(SUM(mobilier.nombre_elements), 0) AS "Total éléments"
FROM 
  app.mceramique, 
  app.mobilier, 
  app.ue
WHERE 
  mobilier.id = mceramique.id AND
  ue.id = mobilier.id_ue AND
  ue.id_projet = 184
GROUP BY ue."numero", mceramique."categorie"
ORDER BY ue."numero", mceramique."categorie" ASC;

----
----
SELECT DISTINCT
  mceramique.categorie
FROM app.mceramique
ORDER BY mceramique.categorie ASC;

SELECT DISTINCT
  mceramique.type
FROM app.mceramique
ORDER BY mceramique.type ASC;

SELECT DISTINCT
  mceramique.pate
FROM app.mceramique
ORDER BY mceramique.pate ASC;