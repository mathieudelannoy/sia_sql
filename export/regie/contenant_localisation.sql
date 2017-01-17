-- export d'un inventaire des contenants avec la localisation associée

SELECT DISTINCT
 contenant.id,
 contenant.numero,
 (SELECT liste.valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS matiere,
 localisation.id,
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_batiment) AS "batiment",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_salle) AS "salle",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_etagere) AS "etagere",
 (SELECT valeur FROM app.liste WHERE liste.id = localisation.id_tablette) AS "tablette"
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app.projet ON ue.id_projet = projet.id
LEFT JOIN app.localisation ON localisation.id = contenant.id_localisation
WHERE projet.id = 394
ORDER BY localisation.id;