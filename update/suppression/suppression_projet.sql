BEGIN;

DELETE FROM app.contenant_mobilier AS "a"
WHERE EXISTS (
SELECT DISTINCT
  b.id
FROM app.mobilier AS "b"
JOIN app.ue AS "c" ON b.id_ue = c.id
WHERE 
  c.id_projet = 632
  AND a.mobilier_id = b.id);

DELETE FROM app.mobilier AS "a"
WHERE EXISTS (
SELECT b.id
FROM app.mobilier AS "b"
JOIN app.ue ON b.id_ue = ue.id
WHERE 
  ue.id_projet = 632
  AND a.id = b.id);

DELETE FROM app.ue WHERE id_projet = 632;

DELETE FROM app_addons.projet_operateur WHERE projet_id = 632;

DELETE FROM app.projet_individu WHERE id_projet = 632;

DELETE FROM app.projet WHERE id = 632;

COMMIT;
