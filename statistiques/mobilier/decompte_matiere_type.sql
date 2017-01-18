-- par matière
CREATE OR REPLACE VIEW stats.mobilier_par_matiere AS
SELECT DISTINCT
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "matiere",
  COUNT(mobilier.id_matiere) AS "decompte",
  (SELECT DISTINCT COUNT(mobilier.id_matiere) GROUP BY mobilier.id_matiere) * 100 / (SELECT DISTINCT COUNT(mobilier.id_matiere) FROM app.mobilier)  AS "%",
  SUM(mobilier.nombre_elements) AS "Nbr_elements"
FROM app.mobilier
GROUP BY mobilier.id_matiere
ORDER BY "decompte" DESC;

-- par matière type
CREATE OR REPLACE VIEW stats.mobilier_par_matiere_type AS
SELECT DISTINCT
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS "matiere_type",
  COUNT(mobilier.id_matiere) AS "decompte",
  SUM(mobilier.nombre_elements) AS "Nbr_elements"
FROM app.mobilier
GROUP BY mobilier.id_matiere_type
ORDER BY "decompte" DESC;