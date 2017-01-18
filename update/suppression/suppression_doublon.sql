-- cti est une valeur unique pour chaque enregistrement, non-affiché dans la table

-- affichage des doublons avec une colonne indiquant le nombre de doublons par rows
WITH cte AS 
 (SELECT 
    contenant_id,
    mobilier_id,
	row_number() over(PARTITION BY contenant_id, mobilier_id ORDER BY contenant_id, mobilier_id DESC) AS rn 
  FROM app.contenant_mobilier ORDER BY rn)
SELECT *
FROM cte
WHERE rn > 1
ORDER BY contenant_id, mobilier_id  ASC;

------------------------------------------------
-- affichage des doublons qui seront à supprimer

SELECT * FROM app.contenant_mobilier
WHERE ctid IN
  (SELECT ctid
	FROM
       (SELECT 
	     ctid,
         row_number() over (partition BY contenant_id, mobilier_id ORDER BY ctid) AS rnum
        FROM app.contenant_mobilier
		) as t
    WHERE t.rnum > 1);

-- suppression des doublons

DELETE FROM app.contenant_mobilier
WHERE ctid IN
  (SELECT ctid
	FROM
       (SELECT 
	     ctid,
         row_number() over (partition BY contenant_id, mobilier_id ORDER BY ctid) AS rnum
        FROM app.contenant_mobilier) as t
    WHERE t.rnum > 1);