-- nombre de tablette
SELECT
  COUNT(id)
FROM app.localisation
WHERE id_tablette IS NOT NULL

-- nombre de tablette par salle
CREATE VIEW stockage_affichage_travee AS
SELECT
  (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
  COUNT(id) AS nbr_tablette
FROM app.localisation
WHERE id_tablette IS NOT NULL
GROUP BY id_batiment, id_salle
ORDER BY id_salle


-- création d'une table avec les mesures de chacune des tablettes
CREATE TABLE app_addons.stockage_mesure_tablette (
  id INTEGER NOT NULL,
  longueur NUMERIC(5,2),
  largeur NUMERIC(5,2),
  hauteur NUMERIC(5,2),
  volume NUMERIC(3,2),
  CONSTRAINT stockage_mesure_tablette_pkey PRIMARY KEY (id),
   CONSTRAINT stockage_mesure_tablette_id_fkey FOREIGN KEY (id) 
     REFERENCES app.localisation (id) MATCH FULL
	 ON UPDATE CASCADE ON DELETE RESTRICT
);

\COPY app_addons.stockage_mesure_tablette (id , longueur, largeur, hauteur, volume) FROM '/home/cg62/restore/mesure.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

-- nombre de contenants par localisation
WITH source AS (
SELECT
  b.id,
  COUNT(a.id_localisation) as nbr
FROM app.contenant AS "a"
LEFT JOIN app.localisation AS "b" On a.id_localisation = b.id
GROUP BY b.id)
SELECT
  source.id,
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_batiment) AS "batiment",
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_salle) AS "salle",
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_etagere) AS "etagere",
  (SELECT valeur FROM app.liste WHERE liste.id = b.id_tablette) AS "tablette",
  source.nbr
FROM source
LEFT JOIN app.localisation AS "b" On source.id = b.id

-- volume total des tablettes utilisés
WITH source AS (
SELECT 
  contenant.id_localisation
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
WHERE 
  intitule NOT LIKE 'intitu%'
  AND contenant.id != 7
  AND intitule NOT LIKE 'DISPON%'
  AND intitule NOT LIKE 'SRA%'
UNION
SELECT
  contenant.id_localisation
FROM app.contenant
LEFT JOIN app.contenant_document ON contenant.id = contenant_document.contenant_id
LEFT JOIN app.document ON contenant_document.document_id = document.id
LEFT JOIN app.projet ON document.id_projet = projet.id
WHERE
  intitule NOT LIKE 'intitu%'
  AND contenant.id != 7
  AND intitule NOT LIKE 'DISPON%'
  AND intitule NOT LIKE 'SRA%')
SELECT 
  SUM(stockage_mesure_tablette.volume) AS volume_tablette
FROM source
LEFT JOIN app.localisation On source.id_localisation = localisation.id
LEFT JOIN app_addons.stockage_mesure_tablette ON stockage_mesure_tablette.id = localisation.id
WHERE localisation.id_tablette IS NOT NULL

-- nombre de contenants sur une tablette