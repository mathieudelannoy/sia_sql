-- export d'un inventaire des localisations 

SELECT DISTINCT
 localisation.id,
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM app.localisation