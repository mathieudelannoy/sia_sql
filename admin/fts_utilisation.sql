/*
Full Text Search
Efficace mais limité pour la recherc
ts_headline ?
*/

-- affiche les éléments isolés de chaque chaîne
SELECT ts_parse('default', intitule)  
FROM app_addons.projet_intitule

-- affiche le mangage du catalogue utilisé
SHOW default_text_search_config;

-- exemple de rercherche d'un lexeme complet
SELECT id, intitule
FROM app_addons.projet_intitule
WHERE to_tsvector(intitule) @@  to_tsquery('Thérouanne')

-- exemple de rercherche d'un lexeme incomplet
SELECT id, intitule
FROM app_addons.projet_intitule
WHERE to_tsvector(intitule) @@  to_tsquery('Théro:*')

-- création d'un index GIN
CREATE INDEX projet_intitule_tsvector_intitule ON app_addons.projet_intitule USING gin(to_tsvector(intitule));

/*
Trigam pg_trm présent contrib

https://www.odoo.com/apps/modules/8.0/base_search_fuzzy/
*/

fc_cadastre.communes_2014
nom_commune

CREATE EXTENSION pg_trgm;

CREATE INDEX idx_admin_communes_trigram_nom ON fc_admin.communes_point
  USING gin (nom_com gin_trgm_ops);
  
SELECT 
  nom_com, 
  nom_com <-> '%arra%' AS "distance",
  similarity(nom_com, '%arra%') AS "similaire"
FROM fc_admin.communes_point
WHERE nom_com % '%arra%'
ORDER BY similaire DESC

-- la distance entre la valeur cherchée et celle présenté
-- la valeur est égal à 1 - la similarité 

-- création d'une table listant les lexemes uniques
CREATE MATERIALIZED VIEW app_addons.projet_intitule_wordlist AS
SELECT row_number() over (order by word) as id, word, ndoc , nentry 
FROM ts_stat(
  'SELECT intitule_tsv
   FROM app_addons.projet_intitule_tsvector')
ORDER BY word ASC;

CREATE INDEX idx_projet_intitule_wordlist_trigram_id ON app_addons.projet_intitule_wordlist
  USING btree (id, word);
CREATE INDEX idx_projet_intitule_wordlist_trigram ON app_addons.projet_intitule_wordlist
  USING gin (word gin_trgm_ops);
  
CREATE TABLE app_addons.projet_intitule_wordlist_occurence (
  id_word INTEGER NOT NULL,
  id_projet INTEGER NOT NULL,
  CONSTRAINT projet_intitule_wordlist_occurence_pkey PRIMARY KEY (id_word, id_projet)
-- ajout fkey à faire
  );