/* MAJ ARCHEOZOO
détermination = espèce + os
2 updates distinctes pour gérer les absences
*/

SELECT DISTINCT
  (SELECT valeur FROM app.liste WHERE liste.id = id_espece) || ' - ' ||
  (SELECT valeur FROM app.liste WHERE liste.id = id_os_principal) AS new_det,
  mobilier.determination
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON marcheozoologie.id = mobilier.id
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app_addons.projet_operateur ON ue.id_projet = projet_operateur.projet_id
WHERE 
  id_matiere_type = 1833
  AND determination IS NULL
  AND id_region_anatomique IS NOT NULL
  AND id_os_principal IS NOT NULL
  AND projet_operateur.organisme_id = 1;

  
  
-- espèce et os principal
UPDATE app.mobilier 
SET determination = 
  (SELECT valeur FROM app.liste WHERE liste.id = id_espece) || ' - ' ||
  (SELECT valeur FROM app.liste WHERE liste.id = id_os_principal)
FROM app.marcheozoologie
WHERE 
  mobilier.id = marcheozoologie.id
  AND mobilier.id_matiere_type = 1833
  AND mobilier.determination IS NULL
  AND mobilier.type_mobilier IS NOT NULL
  AND id_espece IS NOT NULL
  AND id_os_principal IS NOT NULL;
 
-- juste l'espèce
UPDATE app.mobilier 
SET determination = 
  (SELECT valeur FROM app.liste WHERE liste.id = id_espece)
FROM app.marcheozoologie
WHERE 
  mobilier.id = marcheozoologie.id
  AND mobilier.id_matiere_type = 1833
  AND mobilier.determination IS NULL
  AND mobilier.type_mobilier IS NOT NULL
  AND id_espece IS NOT NULL
  AND id_os_principal IS NULL;

-- juste l'os principal
UPDATE app.mobilier 
SET determination = 
  'espèce indéterminée - ' || (SELECT valeur FROM app.liste WHERE liste.id = id_os_principal)
FROM app.marcheozoologie
WHERE 
  mobilier.id = marcheozoologie.id
  AND mobilier.id_matiere_type = 1833  AND mobilier.determination IS NULL
  AND mobilier.type_mobilier IS NOT NULL
  AND id_espece IS NULL
  AND id_os_principal IS NOT NULL;


  
SELECT count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.marcheozoologie ON mobilier.id = marcheozoologie.id
WHERE 
  mobilier.id_matiere_type = 1833
  AND mobilier.determination IS NULL
  AND mobilier.type_mobilier = 'archeozoologie'
  AND id_espece IS NOT NULL
  AND id_os_principal IS NOT NULL;