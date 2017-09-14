## export du schema "app_addons"
pg_dump.exe --host localhost --port 5433 --username "jrmorreale" --schema "app_addons" -Fc --file="D:/SIA/fichiers/dump/2017_06_02_siacg62_app_addons.backup" "siacg62"

## export du schema "maintenance"
pg_dump.exe --host localhost --port 5433 --username "jrmorreale" --schema "maintenance" -Fc --file="D:/SIA/fichiers/dump/2017_06_02_siacg62_maintenance.backup" "siacg62"

## export du schema "stats"
pg_dump.exe --host localhost --port 5433 --username "jrmorreale" --schema "stats" -Fc --file="D:/SIA/fichiers/dump/2017_06_02_siacg62_stats.backup" "siacg62"

#######################
## création des schémas

psql.exe --host localhost --port 5433 --username "jrmorreale" --dbname=siacg62 -c "CREATE SCHEMA app_addons AUTHORIZATION postgres; GRANT ALL ON SCHEMA app_addons TO postgres; GRANT ALL ON SCHEMA app_addons TO jrmorreale; COMMENT ON SCHEMA app_addons IS 'tables liées au schéma app';"

psql.exe --host localhost --port 5433 --username "jrmorreale" --dbname=siacg62 -c "CREATE SCHEMA maintenance AUTHORIZATION postgres;GRANT ALL ON SCHEMA maintenance TO postgres;GRANT ALL ON SCHEMA maintenance TO jrmorreale;"

psql.exe --host localhost --port 5433 --username "jrmorreale" --dbname=siacg62 -c "CREATE SCHEMA stats AUTHORIZATION postgres;GRANT ALL ON SCHEMA stats TO postgres;GRANT ALL ON SCHEMA stats TO jrmorreale;"

###########################
## restauration des schémas

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --schema-only --schema "app_addons" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_app_addons.backup"

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --schema-only --schema "maintenance" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_maintenance.backup"

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --schema-only --schema "stats" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_stats.backup"

###########################
## restauration des données

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --data-only --schema "app_addons" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_app_addons.backup"

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --data-only --schema "maintenance" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_maintenance.backup"

pg_restore.exe --host localhost --port 5433 -U "jrmorreale" --dbname="siacg62" --format custom --data-only --schema "stats" --single-transaction "D:/SIA/fichiers/dump/2017_06_02_siacg62_stats.backup"