-- export d'un inventaire pour le mobilier lapidaire

SELECT DISTINCT
  ue.numero,
  mobilier.numero, 
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere) AS "matiere",
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS "type", 
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS "precision",
  mlapidaire.revetement, 
  mlapidaire.liant, 
  mlapidaire.marquage, 
  mobilier.determination,
  regexp_replace(mobilier.commentaire, '\r|\n', ' - ', 'g') AS commentaire,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_objet_ou_lot) AS "objet_lot",
  mobilier.nombre_elements, 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_debut) AS "Chrono début", 
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_debut) AS "Sous-Chrono début",  
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_1_fin) AS "Chrono fin",
  (SELECT intitule FROM app.chronologie WHERE chronologie.id = mobilier.id_chrono_2_fin ) AS "Sous-chrono fin",
  mobilier.tpq,
  mobilier.taq
FROM 
  app.ue,
  app.mobilier
LEFT JOIN app.mlapidaire ON mobilier.id = mlapidaire.id
WHERE 
  ue.id_projet = 155 AND
  mobilier.id_matiere_type = 294 AND
  mobilier.id_ue = ue.id
ORDER BY   ue.numero, mobilier.numero;