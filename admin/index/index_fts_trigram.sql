
-- installation de l'extension \contrib unaccent
CREATE EXTENSION unaccent;
-- installation de l'extension \contrib trigram
CREATE EXTENSION pg_trgm;

-- remplacement de la vue matérialisé projet_intitule
DROP VIEW app_addons.projet_intitule;

-- création d'une fonction immutable pour la fonction unaccent
CREATE OR REPLACE FUNCTION app_addons.cd62_UnaccentImmutable(text)
  RETURNS text AS
$func$
SELECT public.unaccent('public.unaccent', $1)
$func$  LANGUAGE sql IMMUTABLE;

-- création d'un index GIN des trigrams sur les lexemes des intitulés
CREATE INDEX idx_projet_intitule_trigram 
  ON app_addons.projet_intitule
  USING gin (lexeme gin_trgm_ops);

-- exemple de requête
SELECT id, intitule
FROM app_addons.projet_intitule
WHERE intitule ~* unaccent(trim('the '))
ORDER BY intitule

CREATE INDEX idx_projet_intitule_trigram 
  ON app_addons.projet_intitule
  USING gin (
    replace(
    strip(
    to_tsvector('simple',
    app_addons.cd62_UnaccentImmutable(intitule)
    ))::text,'''', '') gin_trgm_ops);

SELECT id,
replace(strip(to_tsvector('simple', unaccent(intitule)))::text,'''', '') AS int2
FROM app_addons.projet_intitule

DROP INDEX app_addons.idx_projet_intitule_trigram;
DROP FUNCTION app_addons.cd62_UnaccentImmutable(text);


UPDATE app_addons.projet_intitule
SET trigram = replace(strip(to_tsvector('simple', app_addons.cd62_UnaccentImmutable(intitule)))::text,'''', '')