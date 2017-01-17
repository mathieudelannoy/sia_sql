-- rechercher un mobilier depuis son identifiant

SELECT
  projet.intitule, 
  ue.numero AS num_ue, 
  mobilier.id,
  mobilier.numero,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type,
  (SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS matiere_type_precision
FROM 
  app.mobilier
JOIN app.ue ON ue.id = mobilier.id_ue
JOIN app.projet ON projet.id = ue.id_projet
WHERE 
  mobilier.id = 4980;
