DELETE FROM app.mobilier WHERE numero = 10000 and id_ue = 8174;

DELETE FROM app.contenant_mobilier AS "a"
WHERE EXISTS
  ( select b.id
    from app.mobilier AS "b"
    where b.id = a.mobilier_id
	and b.numero = 10000
    and b.id_ue = 8174 );
	
DELETE FROM app.mobilier WHERE numero = 10000 and id_ue = 8174;