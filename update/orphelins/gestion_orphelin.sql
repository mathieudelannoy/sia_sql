-- mise à mort des orphelins

DELETE FROM app. WHERE ;
DELETE FROM app.matrice_geologique WHERE id_ue is null;
DELETE FROM app.inclusion_geologique WHERE id_matrice is null;

DELETE FROM app.mobilier WHERE id_ue IS NULL;

-- suppression des éventuelles dépendances d'un mobilier 

DELETE FROM app.contenant_mobilier AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.mobilier_id
    and b.id_ue IS NULL );

DELETE FROM app.document_mobilier AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.mobilier_id
    and b.id_ue IS NULL );




-- suppression geologie

DELETE FROM app.inclusion
	
-- suppression document orphelin

SELECT * FROM app.document
WHERE 
  NOT EXISTS 
  (SELECT document_id AS id FROM app.document_mobilier 
    WHERE document_mobilier.document_id = document.id) 
  AND NOT EXISTS 
  (SELECT document_id AS id FROM app.document_ue 
    WHERE document_ue.document_id = document.id) 
  AND document.id_projet IS NULL

-- schéma pour voir ce qui va être effacé
SELECT count(*) FROM app.mobilier WHERE id_ue IS NULL;

SELECT count(*) FROM app.mlithique AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.id
    and b.id_ue IS NULL );
	
DELETE FROM app.ue WHERE id_projet IS NULL;
