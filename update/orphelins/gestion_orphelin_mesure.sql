BEGIN;

DELETE FROM app.mesure WHERE id_mobilier IS NULL AND id_ue IS NULL;

DELETE FROM app.mesureanthropologique WHERE id_mobilier IS NULL;

DELETE FROM app.mesurearcheozoologique WHERE id_mobilier IS NULL;

DELETE FROM app.mesureceramique WHERE id_mobilier IS NULL;

COMMIT;

SELECT *
FROM app.mesure 
WHERE id_mobilier IS NULL AND id_ue IS NULL
ORDER BY id

SELECT *
FROM app.mesure 
WHERE id > 30755 and id < 30765

30758
30759
30787
30809

SELECT *
FROM app.mesure 
WHERE id > 30785 and id < 30790

fait le 04/11

2504 clou
-> 2500