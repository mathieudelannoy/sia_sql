DELETE FROM app.mobilier AS "a"
WHERE NOT EXISTS
  ( select b.id
    from app.marcheozoologie AS "b"
    where b.id = a.id)
  AND type_mobilier = 'archeozoologie';
  
SELECT count(id)
FROM app.mobilier AS "a"
WHERE NOT EXISTS
  ( select b.id
    from app.marcheozoologie AS "b"
    where b.id = a.id)
  AND type_mobilier = 'archeozoologie';
  
  
UPDATE app.mobilier AS a SET type_mobilier = NULL
WHERE NOT EXISTS
  ( select b.id
    from app.marcheozoologie AS "b"
    where b.id = a.id)
  AND type_mobilier = 'archeozoologie'; 
  
DELETE FROM app.marcheozoologie AS "a"
WHERE NOT EXISTS
  ( SELECT b.id
    FROM app.mobilier AS "b"
    WHERE b.id = a.id AND type_mobilier = 'archeozoologie');

SELECT
  count(id)
FROM app.marcheozoologie AS "a"
WHERE NOT EXISTS
  ( SELECT b.id
    FROM app.mobilier AS "b"
    WHERE b.id = a.id AND type_mobilier = 'archeozoologie');

UPDATE app.mobilier AS a 
SET type_mobilier = NULL 
FROM app.marcheozoologie AS b
WHERE 
  a.id_matiere_type = 1833
  AND a.type_mobilier = 'archeozoologie' 
  AND a.id != b.id