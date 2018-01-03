SELECT a.id, b.id_ref
FROM app.projet_intitule AS "a"
LEFT JOIN 
	(SELECT DISTINCT id_ref FROM app.localisation_adresse) AS "b"
	ON a.id = b.id_ref

app.projet_organisme
app.localisation_adresse
app.projet_intitule

-- projets sans intitulé généré
SELECT a.id
FROM app.projet AS "a"
LEFT JOIN app.projet_intitule AS "b" ON a.id = b.id
WHERE b.id IS NULL

-- ancien intitulé du projet
SELECT intitule
FROM app.projet
WHERE id = 13;

-- localisation sans contenu
SELECT 
  id_ref, a.id, 
  b.intitule, b.nom,
  c.intitule AS intitule_auto
FROM app.localisation_adresse AS "a"
LEFT JOIN app.projet AS "b" ON b.id = id_ref
LEFT JOIN app.projet_intitule AS "c" ON a.id_ref = c.id
WHERE
  lieu_dit IS NULL AND
  num_voirie IS NULL AND
  id_type_voirie IS NULL AND
  nom_voirie IS NULL AND
  complement IS NULL AND
  id_commune IS NULL
ORDER BY id_ref;

--- projets sans aucune information de localisation
SELECT
  a.id, a.intitule,
  b.intitule AS old_one, b.nom
FROM app.projet_intitule AS "a"
WHERE a.intitule = 'SansLocalisation, SansDate (''SansNom'', collection'')'
LEFT JOIN app.projet AS "b" ON b.id = a.idold_one


Sains-en-Amienois