WITH

--  sélectionne les projets de la DA62
source_projet AS (
SELECT
  projet.id,
  (SELECT liste.valeur FROM app.liste WHERE liste.id = projet.id_type_projet) AS type_operation,
  projet.intitule,
  projet.date_debut,
  projet.date_fin,
  projet.surface_accessible,
  regexp_replace(projet.thesaurus_thematique, '\r|\n', '', 'g') AS thesaurus_thematique
FROM app.projet
LEFT JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
LEFT JOIN app.organisme ON projet_operateur.organisme_id = organisme.id
WHERE projet_operateur.organisme_id = 1),

-- sélectionne les personnes liées à ces projets
source_individu AS (
SELECT
  projet_individu.id_projet, 
  projet_individu.id_fonction, 
  projet_individu.role,
  individu.nom || ' ' || individu.prenom AS personne
FROM app.projet_individu
JOIN source_projet ON source_projet.id = projet_individu.id_projet
JOIN app.individu ON individu.id = projet_individu.id_individu AND (individu.id_organisme != 4 OR individu.id_organisme IS NULL)
WHERE
  projet_individu.role != 'role:mediateur'
  AND projet_individu.role != 'role:secretaire'
  AND projet_individu.role != 'role:administrateur'
  AND projet_individu.role != 'role:regie'
  AND projet_individu.role != 'role:null'
  AND id_fonction != 21
  AND id_fonction != 1821
  AND id_fonction != 2816
  AND id_fonction != 2830
ORDER BY
  projet_individu.id_projet, 
  projet_individu.id_fonction, 
  projet_individu.role),
  
-- regroupement par projet et fonctions
-- FILTER serait si cool à partir de là...
source_agg_individu AS (
SELECT
  id_projet, 
  id_fonction, 
  role,
  array_to_string(array_agg(personne ORDER BY personne), ', ') AS agg_personnes
FROM source_individu
GROUP BY 
  id_projet, 
  id_fonction,
  role
ORDER BY
  id_projet, 
  id_fonction,
  role
),

-- regroupement par projet et spécialités
source_agg_specialistes AS (
SELECT
  id_projet,
  array_to_string(array_agg(agg_personnes 
    || ' (' ||
    (SELECT liste.valeur FROM app.liste WHERE liste.id = source_agg_individu.id_fonction)
	|| ')' ORDER BY agg_personnes), ', ') AS agg_personnes
FROM source_agg_individu
WHERE role = 'role:specialiste'
GROUP BY id_projet)

SELECT 
  id,
  type_operation,
  intitule,
  date_debut,
  date_fin,
  surface_accessible,
  thesaurus_thematique,
  a.agg_personnes AS "RO",
  a2.agg_personnes AS "Adjoints",
  b.agg_personnes AS "Specialistes",
  c.agg_personnes AS "techniciens",
  d.agg_personnes AS "topographes"
FROM source_projet
LEFT JOIN source_agg_individu AS "a" ON source_projet.id = a.id_projet AND a.role = 'role:ro_adjoint' AND a.id_fonction = 20
LEFT JOIN source_agg_individu AS "a2" ON source_projet.id = a2.id_projet AND a2.role = 'role:ro_adjoint' AND a2.id_fonction = 22
LEFT JOIN source_agg_specialistes AS "b" ON source_projet.id = b.id_projet
LEFT JOIN source_agg_individu AS "c" ON source_projet.id = c.id_projet AND c.role = 'role:technicien' AND c.id_fonction = 15
LEFT JOIN source_agg_individu AS "d" ON source_projet.id = d.id_projet AND d.role = 'role:referent_sig' AND d.id_fonction = 27
ORDER BY date_debut, date_fin, id