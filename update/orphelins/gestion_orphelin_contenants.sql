-- suppression des contenants orphelins
DELETE FROM app.contenant
WHERE 
  NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_mobilier 
    WHERE contenant_mobilier.contenant_id = contenant.id) 
  AND NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_document 
    WHERE contenant_document.contenant_id = contenant.id)
  AND contenant.id_projet IS NULL

-- suppression contenant mobilier orphelin
DELETE FROM app.contenant AS "a"
WHERE NOT EXISTS
(
select b.contenant_id
from app.contenant_mobilier AS "b"
where b.contenant_id = a.id
) AND a.id_matiere_contenant != 724;

-- nombre de contenants orphelins
SELECT 
  contenant.id,
  contenant.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS "matiere"
FROM app.contenant
WHERE 
  NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_mobilier 
    WHERE contenant_mobilier.contenant_id = contenant.id) 
  AND NOT EXISTS 
  (SELECT contenant_id AS id FROM app.contenant_document 
    WHERE contenant_document.contenant_id = contenant.id)
  AND contenant.id_projet IS NULL
ORDER BY contenant.id;

SELECT DISTINCT
  contenant_mobilier.contenant_id,
  projet.intitule
FROM app.contenant_mobilier
JOIN app.contenant ON contenant_mobilier.contenant_id = contenant.id
JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
JOIN app.ue ON mobilier.id_ue = ue.id
JOIN app.projet ON ue.id_projet = projet.id
WHERE 
  contenant_mobilier.contenant_id >= 9770
  AND contenant_mobilier.contenant_id <= 9617

SELECT 
  *
FROM app.contenant
LEFT JOIN (SELE
WHERE 