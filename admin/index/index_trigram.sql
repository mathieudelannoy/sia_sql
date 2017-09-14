/*

en se basant sur la vue matérialisée des intitulés de projet :
- utilisation de FTS pour isoler les lexemes et écarter le bruit inutile (accent, liason, etc.)
- utilisation de unaccent pour élargir la recherche
- utilsation de pg_trm pour créer un index de trigram sur les lexemes fts
- chaque espace dans la chaîne tapée par l'utilisateur est remplacée par un %

*/

CREATE EXTENSION unaccent;
CREATE EXTENSION pg_trgm;

CREATE MATERIALIZED VIEW app_addons.projet_intitule_tsvector AS
SELECT 
  id, 
  intitule, 
  to_tsvector('french', unaccent(intitule)) AS intitule_tsv,
  strip(to_tsvector('french', unaccent(intitule)))::text AS intitule_trigram
FROM app_addons.projet_intitule;

CREATE INDEX idx_projet_intitule_tsvector
  ON app_addons.projet_intitule_tsvector USING gin(intitule_tsv);

CREATE INDEX idx_projet_intitule_tsvector_trigram 
  ON app_addons.projet_intitule_tsvector
  USING gin (intitule_trigram gin_trgm_ops);

-- requête par fts/trigram
-- les résultats trigram sont affichés uniquement 
-- s'ils ne figurent pas dans les résulats fts
-- normalisation du terme recherché avec_to_tsquery
WITH
source_ts AS (
SELECT id, intitule
FROM app_addons.projet_intitule_tsvector 
WHERE intitule_tsv @@ to_tsquery(unaccent('VALEUR:*'))
)

SELECT id, intitule
FROM source_ts
UNION
SELECT id, intitule
FROM app_addons.projet_intitule_tsvector
WHERE 
  intitule_trigram ILIKE unaccent('%VALEUR%')
  AND NOT EXISTS (SELECT * FROM source_ts) ;