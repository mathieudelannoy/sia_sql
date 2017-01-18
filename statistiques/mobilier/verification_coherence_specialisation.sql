-- decompte des enregistrements mobilier présents dans les tables specialistes
EXPLAIN ANALYZE
CREATE VIEW stats.mobilier_specialiste_par_type_mobilier AS
SELECT 
  type_mobilier::text,
  decompte AS decompte_specialiste  
FROM (
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.manthropologie AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'anthropologie') AS a ON a.id = b.id
    GROUP BY a.type_mobilier
  UNION
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.marcheozoologie AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'archeozoologie') AS a ON a.id = b.id
    GROUP BY a.type_mobilier
  UNION
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.mceramique AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'ceramique') AS a ON a.id = b.id
    GROUP BY a.type_mobilier
  UNION
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.mlithique AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'lithique') AS a ON a.id = b.id
    GROUP BY a.type_mobilier
  UNION
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.mlapidaire AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'lapidaire') AS a ON a.id = b.id
    GROUP BY a.type_mobilier
  UNION
    SELECT
     a.type_mobilier,
     count(b.id) as decompte
    FROM app.mmonnaie AS b
    LEFT JOIN (SELECT id, type_mobilier FROM app.mobilier WHERE mobilier.type_mobilier::text = 'monnaie')  AS a ON a.id = b.id
    GROUP BY a.type_mobilier
	) 
	AS tables_spe
ORDER BY type_mobilier ASC;

-- decompte les mobiliers marqués comme specialisés dans app.mobilier
CREATE VIEW stats.mobilier_par_type_mobilier AS
SELECT
 a.type_mobilier,
 count(a.type_mobilier) AS decompte_table_generale
FROM app.mobilier AS a
WHERE a.type_mobilier IS NOT NULL
GROUP BY a.type_mobilier
ORDER BY a.type_mobilier ASC;

-- affiche les totaux par type de la table mobilier et des tables spécialisées
CREATE VIEW stats.mobilier_comparaison_total_mobiliers_specialistes AS
SELECT
  a.type_mobilier,
  a.decompte_table_generale,
  b.decompte AS decompte_tables_specialistes
FROM stats.mobilier_par_type_mobilier AS a
LEFT JOIN stats.mobilier_specialiste_par_type_mobilier AS b ON a.type_mobilier::text = b.type_mobilier::text
ORDER BY a.type_mobilier ASC;
COMMENT ON VIEW stats.mobilier_comparaison_total_mobiliers_specialistes
  IS 'compare les totaux de la table mobilier par type_mobilier et les totaux des différentes tables spécialisées';
  
-- mob > spe
SELECT
  a.id AS id_mobilier,
  a.type_mobilier,
  b.id AS id_ceramique
FROM app.mobilier AS a
LEFT JOIN app.mceramique AS b ON b.id = a.id
WHERE b.id IS NOT NULL AND a.type_mobilier::text LIKE 'ceramique'
ORDER BY a.type_mobilier DESC

-- mob < spe
SELECT
  a.id AS id_mobilier,
  a.type_mobilier,
  b.id AS id_ceramique
FROM app.mobilier AS a
LEFT JOIN app.mceramique AS b ON b.id = a.id
WHERE b.id IS NULL AND a.type_mobilier::text LIKE 'ceramique'
ORDER BY a.id ASC;

--- affiche les enregistrement ayant une erreur de cohérence entre "type_mobilier" / "id_matiere_type"
CREATE VIEW stats.mobilier_incoherence_type AS
SELECT *
FROM (
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'archeozoologie' AND
  a.id_matiere = 292 AND
  a.id_matiere_type != 1833
UNION
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'anthropologie' AND
  a.id_matiere = 292 AND
  a.id_matiere_type != 1832
UNION
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'lithique' AND
  a.id_matiere = 286 AND
  a.id_matiere_type != 293
UNION
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'lapidaire' AND
  a.id_matiere = 286 AND
  a.id_matiere_type != 294
UNION
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'ceramique' AND
  a.id_matiere = 285 AND
  a.id_matiere_type != 296
UNION
SELECT
  a.type_mobilier::text,
  a.id,
  a.id_matiere,
  a.id_matiere_type
FROM app.mobilier AS a
WHERE 
  a.type_mobilier::text = 'monnaie' AND
  a.id_matiere = 290 AND
  a.id_matiere_type != 305)
  AS foo
ORDER BY type_mobilier, id ASC;