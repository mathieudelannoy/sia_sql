-- création de la base
psql.exe --host ADRESSE_IP --port PORTNUM -U "ROLENAME" --dbname=postgres -c "CREATE DATABASE DBNAME WITH TEMPLATE=template_postgis OWNER = postgres TABLESPACE = pg_default CONNECTION LIMIT = -1;"
psql.exe --host ADRESSE_IP --port PORTNUM -U "ROLENAME" --dbname=DBNAME -1 -f "D:\SIA\fichiers\dump\2016_08_12_DBNAME_noowner_schema_public_enum.sql"
psql.exe --host ADRESSE_IP --port PORTNUM -U "ROLENAME" --dbname=DBNAME -1 -f "D:\SIA\fichiers\dump\2016_08_12_DBNAME_noowner_schemaonly_app.sql"

-- importation du schéma
pg_restore.exe --host ADRESSE_IP --port PORTNUM --username "ROLENAME" --create --dbname "DBNAME" --format custom --schema-only --schema=app --no-owner "D:/SIA/fichiers/dump/2016_08_12_DBNAME_noowner_schemaonly.backup" > D:\ERROR.TXT

pg_restore.exe --host ADRESSE_IP --port PORTNUM --username "ROLENAME" -O --create --format custom --schema-only --schema=app --file="D:/SCRIPT.SQL" "D:/SIA/fichiers/dump/2016_08_12_DBNAME_noowner_schemaonly.backup"

-- importation data app

pg_restore.exe --host ADRESSE_IP --port PORTNUM --dbname "DBNAME" --username "ROLENAME" --no-owner --no-security-labels --format custom --data-only --schema=app --jobs=4 "D:\SIA\fichiers\dump\2016_08_17_DBNAME_noowner_app.backup"

pg_restore.exe --host ADRESSE_IP --port PORTNUM --dbname "DBNAME" --username "ROLENAME" --format custom --data-only --schema=app --jobs=4 "D:\SIA\fichiers\dump\2016_08_17_DBNAME_noowner_app.backup"

pg_restore.exe --host ADRESSE_IP --port PORTNUM --dbname "DBNAME" --username "ROLENAME" --format custom --data-only --schema=app --single-transaction --disable-triggers "D:\SIA\fichiers\dump\2016_08_17_DBNAME_app.backup"