SELECT * FROM app.ue
WHERE id_projet is null;

BEGIN;

DELETE FROM app.inclusion_geologique
WHERE id_matrice is null;

DELETE FROM app.matrice_geologique
WHERE id_ue is null;

DELETE FROM app.ue
WHERE id_projet is null;

COMMIT;