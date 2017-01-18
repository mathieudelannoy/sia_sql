/* MAJ ANTHROPOLOGIE
*/

CREATE TABLE maj_det_anthropo AS (
SELECT DISTINCT
  manthropologie.id_region_anatomique,
  manthropologie.id_os_principal,
  lower((SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_region_anatomique)
  || ' - ' ||
  (SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_os_principal)) AS new_det
FROM app.mobilier
LEFT JOIN app.manthropologie ON manthropologie.id = mobilier.id
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app_addons.projet_operateur ON ue.id_projet = projet_operateur.projet_id
WHERE 
  id_matiere_type = 1832
  AND determination IS NULL
  AND id_region_anatomique IS NOT NULL
  AND id_os_principal IS NOT NULL
  AND projet_operateur.organisme_id = 1
ORDER BY new_det
);

SELECT count(mobilier.id)
FROM app.mobilier
LEFT JOIN app.manthropologie ON manthropologie.id = mobilier.id
WHERE 
  id_matiere_type = 1832 
  AND determination IS NULL 
  AND manthropologie.id_region_anatomique IS NOT NULL

UPDATE app.mobilier AS a
SET determination = c.new_det
FROM 
  app.manthropologie AS b,
  public.maj_det_anthropo AS c
WHERE 
  a.id_matiere_type = 1832
  AND a.determination IS NULL
  AND b.id = a.id
  AND b.id_region_anatomique = c.id_region_anatomique
  AND b.id_os_principal = c.id_os_principal
  
UPDATE app.mobilier AS a
SET determination = lower(c.valeur)
FROM 
  app.manthropologie AS b,
  app.liste AS c
WHERE 
  a.id_matiere_type = 1832
  AND a.determination IS NULL
  AND b.id = a.id
  AND b.id_region_anatomique = c.id

SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_region_anatomique)