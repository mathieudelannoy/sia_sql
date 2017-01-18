CREATE SCHEMA maintenance
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA maintenance TO postgres;
GRANT ALL ON SCHEMA maintenance TO "www-data";
GRANT ALL ON SCHEMA maintenance TO jrmorreale;
GRANT USAGE ON SCHEMA maintenance TO admin_sia_minimun;

ALTER DEFAULT PRIVILEGES IN SCHEMA maintenance
    GRANT INSERT, SELECT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES
    TO admin_sia_minimun;


-- pg_relation_size(name::regclass)

-- calcule le taux d'utilisation des index
CREATE VIEW maintenance.index_taux_usage AS 
SELECT 
  relname, 
  100 * idx_scan / (seq_scan + idx_scan) AS "pourcentage_utilisation_index", 
  n_live_tup AS lignes_vivantes
FROM 
  pg_stat_user_tables
WHERE
    seq_scan + idx_scan > 0 
ORDER BY pourcentage_utilisation_index DESC;

-- stat des index des clés primaires ou secondaires
CREATE VIEW maintenance.index_utilisation_pkey_fkey AS
SELECT 
  schemaname AS "schema",
  relname AS "table",
  indexrelname AS "index_nom",
  idx_scan AS "nbr_scan",
  idx_tup_read AS "nbr_lecture",
  idx_tup_fetch AS "nbr_recup"
FROM pg_stat_user_indexes
WHERE pg_stat_user_indexes.indexrelname LIKE '%key'
ORDER BY idx_scan DESC;
COMMENT ON VIEW maintenance.index_utilisation_pkey_fkey
  IS 'stat des index des clés primaires ou secondaires';

-- stat des index des clés créées manuellement
CREATE VIEW maintenance.index_utilisation_key_custom AS
SELECT 
  schemaname AS "schema",
  relname AS "table",
  indexrelname AS "index_nom",
  idx_scan AS "nbr_scan",
  idx_tup_read AS "nbr_lecture",
  idx_tup_fetch AS "nbr_recup"
FROM pg_stat_user_indexes
WHERE pg_stat_user_indexes.indexrelname NOT LIKE '%key'
ORDER BY idx_scan DESC;
COMMENT ON VIEW maintenance.index_utilisation_key_custom
  IS 'stat des index des clés créées manuellement';
  
-- indique les index qui font doublon
CREATE VIEW maintenance.index_doublons AS
SELECT pg_size_pretty(sum(pg_relation_size(idx))::bigint) AS size,
       (array_agg(idx))[1] AS idx1, (array_agg(idx))[2] AS idx2,
       (array_agg(idx))[3] AS idx3, (array_agg(idx))[4] AS idx4
FROM (
    SELECT indexrelid::regclass AS idx,
	(indrelid::text ||E'\n'|| indclass::text ||E'\n'|| indkey::text ||E'\n'||
     coalesce(indexprs::text,'')||E'\n' || coalesce(indpred::text,'')) AS KEY
    FROM pg_index) AS sub
GROUP BY KEY HAVING count(*)>1
ORDER BY sum(pg_relation_size(idx)) DESC;

-- poid total des tables (index et toast compris), les 20 plus grosses
CREATE VIEW maintenance.table_usage_disk AS
SELECT
  nspname || '.' || relname AS "relation",
  pg_size_pretty(pg_total_relation_size(a.oid)) AS "taille_totale"
FROM pg_class AS "a"
LEFT JOIN pg_namespace AS "b" ON (a.relnamespace = b.oid)
WHERE 
  nspname NOT IN ('pg_catalog', 'information_schema')
  AND a.relkind <> 'i'
  AND nspname !~ '^pg_toast'
ORDER BY pg_total_relation_size(a.oid) DESC
LIMIT 20;

COMMENT ON VIEW maintenance.table_usage_disk
  IS 'taille totale des vingts plus grosses tables (index et TOAST inclus)';

-- nombre de lignes vivantes par table
CREATE OR REPLACE VIEW maintenance.table_nbr_lignes_vivantes AS 
SELECT 
  relname AS "table", 
  n_live_tup AS "nbr_lignes"
FROM 
  pg_stat_user_tables
WHERE schemaname = 'app'
ORDER BY n_live_tup DESC; 

-- nombre d'enregistrements du SIA
CREATE OR REPLACE VIEW maintenance.table_nbr_lignes_total AS 
SELECT 
 SUM(nbr_lignes)
FROM maintenance.table_nbr_lignes_vivantes;