-- indique que l'état sanitaire est stable pour les cailloux
UPDATE app.mobilier AS "a"
SET id_etat_sanitaire = 1120
WHERE EXISTS(
	SELECT b.id
	FROM app.mobilier AS "b"
	LEFT JOIN app.ue ON b.id_ue = ue.id
	WHERE 
	  ue.id_projet = 276
	  AND id_matiere_type = 293
	  AND b.id = a.id );

-- Datation néolithique final sauf pour les UE suivantes
-- Et les lithiques dont la technologie est « débris »

UPDATE app.mobilier AS "a"
SET 
  id_chrono_1_debut = 8,
  id_chrono_2_debut = 11,
  id_chrono_1_fin = 8,
  id_chrono_2_fin = 11,
  tpq = -3000,
  taq = -2500
WHERE EXISTS(  
	SELECT b.id
	FROM app.mobilier AS "b"
	LEFT JOIN app.ue ON b.id_ue = ue.id
	LEFT JOIN app.mlithique AS "c" ON b.id = c.id
	WHERE 
	  ue.id_projet = 276
	  AND id_matiere_type = 293
	  AND c.id_technologie = 2891
	  AND b.id = a.id 
	  AND (ue.numero !=572
	  OR ue.numero !=579
	  OR ue.numero !=612
	  OR ue.numero !=627
	  OR ue.numero !=614
	  OR ue.numero !=629
	  OR ue.numero !=604
	  OR ue.numero !=616)
	  );