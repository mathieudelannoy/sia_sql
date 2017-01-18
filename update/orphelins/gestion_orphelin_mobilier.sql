DELETE FROM app.mobilier WHERE id_ue IS NULL;

SELECT id, id_ue FROM app.mobilier WHERE id_ue IS NULL;
SELECT id, id_ue FROM app.mobilier WHERE id >= 57330 AND id <= 57340 ORDER BY id;

-- suppression des éventuelles dépendances d'un mobilier spécialisé
DELETE FROM app.mlithique AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

DELETE FROM app.mlapidaire AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

DELETE FROM app.mceramique AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

DELETE FROM app.marcheozoologie AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

DELETE FROM app.manthropologie AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

DELETE FROM app.mmonnaie AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );

-- ANTHROPO

DELETE FROM app.connexionanthropologique WHERE id_mobilier is null;
DELETE FROM app.pathologie WHERE id_mobilier is null;