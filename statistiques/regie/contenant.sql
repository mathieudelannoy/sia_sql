/* CREATE SCHEMA stat
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA stat TO postgres;
GRANT ALL ON SCHEMA stat TO "www-data";
GRANT ALL ON SCHEMA stat TO jrmorreale;
GRANT USAGE ON SCHEMA stat TO admin_sia_minimun;

ALTER DEFAULT PRIVILEGES IN SCHEMA stat
    GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES
    TO admin_sia_minimun;
*/

-- liste des projets n'ayant aucuns contenants liés

CREATE OR REPLACE VIEW stats.projet_sans_contenant AS
WITH source AS (
SELECT DISTINCT
  projet.id
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
WHERE projet.intitule NOT LIKE 'intitu%' AND projet.id != 7)
SELECT
  projet.id,
  projet.intitule
FROM app.projet
LEFT JOIN source ON source.id = projet.id
WHERE
  source.id IS NULL
  AND projet.intitule NOT LIKE 'intitu%'
  AND projet.id != 7
  AND projet.intitule NOT LIKE 'DISPON%'
  AND projet.intitule NOT LIKE 'SRA%'
ORDER BY projet.intitule


