SELECT count(id)
FROM app.mobilier
WHERE determination IS NULL


SELECT DISTINCT determination
FROM app.mobilier
WHERE determination IS NOT NULL
ORDER BY determination

UPDATE app.mobilier SET determination = trim(both ' ' from determination);
UPDATE app.mobilier SET determination = NULL WHERE determination = '';

SELECT count(id)
FROM app.mobilier
WHERE id_matiere_type = 293 AND determination IS NULL

SELECT count(id)
FROM app.mceramique
WHERE  IS NULL

SELECT count(mobilier.id)
FROM app.mobilier
RIGHT JOIN app.mceramique ON mceramique.id = mobilier.id
WHERE id_chrono_1_fin IS NOT NULL

SELECT count(id)
FROM app.mobilier
WHERE 
  type_mobilier IS NULL 
  AND determination IS NULL

SELECT DISTINCT 
  determination
FROM app.mobilier
WHERE 
  id_matiere_type = 293 
  AND determination IS NOT NULL
ORDER BY determination
  
SELECT 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "chrono_debut",
  count(mobilier.id)
FROM app.mobilier
RIGHT JOIN app.mceramique ON mceramique.id = mobilier.id
WHERE id_chrono_1_debut IS NOT NULL
GROUP BY chrono_debut

-- export de la céram pour correction manuelle par les céramo
SELECT
  a.id,
  e.intitule,
  c.intitule,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_debut) AS "chrono_debut",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_debut) AS "chrono_debut2",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_fin) AS "chrono_fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_fin) AS "chrono_fin2",
  a.determination,
  b.categorie,
  b.type,
  b.pate,
  b.cuisson,
  b.decor
FROM app.mobilier AS a
LEFT JOIN app.mceramique AS b ON b.id = a.id
LEFT JOIN app.ue ON a.id_ue = ue.id
LEFT JOIN app.projet AS c ON ue.id_projet = c.id
LEFT JOIN app_addons.projet_operateur AS d ON c.id = d.projet_id
LEFT JOIN app.organisme AS e ON d.organisme_id = e.id
WHERE
  a.id_matiere_type = 296
  AND c.intitule NOT LIKE 'DISPONIBLE%'
  AND c.intitule NOT LIKE 'intitule%'
  AND c.intitule NOT LIKE 'SRA%'
  AND c.intitule != 'Test !'

CREATE INDEX idx_mobilier_matiere_type_idmob
  ON app.mobilier
  USING btree
  (id_matiere_type, id);

-- Monétaire 
SELECT
  a.id,
  e.intitule AS "operateur",
  c.intitule AS "projet",
  a.determination,
  b.representation,
  b.atelier,
  b.exergue,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_debut) AS "chrono_debut",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_debut) AS "chrono_debut2",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_fin) AS "chrono_fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_fin) AS "chrono_fin2"
FROM app.mobilier AS a
LEFT JOIN app.mmonnaie AS b ON b.id = a.id
LEFT JOIN app.ue ON a.id_ue = ue.id
LEFT JOIN app.projet AS c ON ue.id_projet = c.id
LEFT JOIN app_addons.projet_operateur AS d ON c.id = d.projet_id
LEFT JOIN app.organisme AS e ON d.organisme_id = e.id
WHERE
  a.id_matiere_type = 305
  AND c.intitule NOT LIKE 'DISPONIBLE%'
  AND c.intitule NOT LIKE 'intitule%'
  AND c.intitule NOT LIKE 'SRA%'
  AND c.intitule != 'Test !'

-- Lapidaire

SELECT
  a.id,
  e.intitule AS "operateur",
  c.intitule AS "projet",
  a.commentaire,
  a.determination,
  b.revetement,
  b.liant,
  b.marquage,
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_debut) AS "chrono_debut",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_debut) AS "chrono_debut2",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_1_fin) AS "chrono_fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = a.id_chrono_2_fin) AS "chrono_fin2"
FROM app.mobilier AS a
LEFT JOIN app.mlapidaire AS b ON b.id = a.id
LEFT JOIN app.ue ON a.id_ue = ue.id
LEFT JOIN app.projet AS c ON ue.id_projet = c.id
LEFT JOIN app_addons.projet_operateur AS d ON c.id = d.projet_id
LEFT JOIN app.organisme AS e ON d.organisme_id = e.id
WHERE
  a.id_matiere_type = 294
  AND c.intitule NOT LIKE 'DISPONIBLE%'
  AND c.intitule NOT LIKE 'intitule%'
  AND c.intitule NOT LIKE 'SRA%'
  AND c.intitule != 'Test !'
  
-- LITHIQUE

SELECT 'sans détermination' AS quoi, count(id) AS nbr
FROM app.mobilier
WHERE id_matiere_type = 293 AND determination IS NULL
UNION
SELECT 'avec typologie' AS quoi, count(id) AS nbr
FROM app.mlithique
WHERE id_typologie IS NOT NULL
UNION
SELECT 'avec technologie' AS quoi, count(id) AS nbr
FROM app.mlithique
WHERE id_technologie IS NOT NULL

SELECT 
  mobilier.id,
  mlithique.id AS id_lithique,
  regexp_replace(mobilier.commentaire, '\r|\n', ' - ', 'g') AS commentaire,
  mobilier.determination,
  (SELECT valeur FROM app.liste WHERE liste.id =mobilier.id_etat_conservation) AS etat_conservation,
  (SELECT valeur FROM app.liste WHERE liste.id = id_technologie) AS techno,
  (SELECT valeur FROM app.liste WHERE liste.id =id_typologie) AS typo,
  (SELECT valeur FROM app.liste WHERE liste.id =id_fragment) AS fragment
FROM app.mobilier
LEFT JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE 
  id_matiere_type = 293 
  AND determination IS NOT NULL
ORDER BY determination

SELECT DISTINCT
  mobilier.determination,
  (SELECT valeur FROM app.liste WHERE liste.id = id_technologie) AS techno,
  (SELECT valeur FROM app.liste WHERE liste.id =id_typologie) AS typo
FROM app.mobilier
LEFT JOIN app.mlithique ON mobilier.id = mlithique.id
WHERE 
  id_matiere_type = 293 
  AND determination IS NOT NULL
ORDER BY determination;
