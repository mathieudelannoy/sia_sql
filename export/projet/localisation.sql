/*
Saisie des informations de localisation #115
https://github.com/camptocamp/SiaCG62/issues/115
*/

-- localisation à l'adresse

-- n lieu-dit

CREATE TABLE app_addons.localisation_adresse (
  id_ref INTEGER,
  id SERIAL NOT NULL,
  lieu_dit character varying(256),
  num_voirie INTEGER,
  type_voirie INTEGER,
  nom_voirie character varying(256),
  complement character varying(256),
  id_commune INTEGER,
  CONSTRAINT localisation_adresse_pkey PRIMARY KEY (id),
  CONSTRAINT localisation_adresse_fkey FOREIGN KEY (id_ref)
    REFERENCES app.projet (id) MATCH SIMPLE
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT localisation_adresse_type_voirie_fkey FOREIGN KEY (type_voirie)
    REFERENCES app.liste (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT localisation_commune_fkey FOREIGN KEY (id_ref)
    REFERENCES app.projet (id) MATCH SIMPLE
    ON UPDATE RESTRICT ON DELETE RESTRICT
);

COMMENT ON TABLE app.localisation_adresse
  IS 'localisation manuelle à l''adresse';

CREATE INDEX CONCURRENTLY idx_localisation_adresse_id_projet ON app_addons.localisation_adresse USING btree (id_ref);

INSERT INTO pg_enum (enumtypid, enumlabel)
SELECT e.enumtypid, 'type_voirie' AS enumlabel
FROM pg_enum as "e" WHERE e.enumlabel = 'ListeMatiere';

  
-- liste de termes pour la voirie
INSERT INTO app.liste (type_liste, valeur)  VALUES
  ('type_voirie', 'artère'),
  ('type_voirie', 'autoberge'),
  ('type_voirie', 'autoroute'),
  ('type_voirie', 'avenue'),
  ('type_voirie', 'boulevard'),
  ('type_voirie', 'chaussée'),
  ('type_voirie', 'chemin'),
  ('type_voirie', 'départementale'),
  ('type_voirie', 'échangeur'),
  ('type_voirie', 'impasse'),
  ('type_voirie', 'nationale'),
  ('type_voirie', 'place'),
  ('type_voirie', 'pont'),
  ('type_voirie', 'rocade'),
  ('type_voirie', 'ruelle'),
  ('type_voirie', 'rue'); 

-- jeu de données

INSERT INTO app_addons.localisation_adresse (id_ref, id, lieu_dit, num_voirie, type_voirie, nom_voirie, complement, id_commune)
  (),
  ();
  
-- requête pour former l'intitulé si une seule localisation est renseigné pour un projet ou aucune

-- inclure la date de fin avec dédoublement ?

CREATE MATERIALZED VIEW app_addons.projet_intitule AS

WITH 

simple AS (

WITH
localisation_simple AS (
SELECT id_ref
FROM app_addons.localisation_adresse
GROUP BY id_ref
HAVING COUNT(id_ref) <= 1)

SELECT
  a.id,
  COALESCE(c.nom, 'SansLocalisation')
  || ', '
  || COALESCE(CAST(EXTRACT(ISOYEAR FROM a.date_debut) AS TEXT), 'SansDate')
  || ' ('''
  || COALESCE(COALESCE(COALESCE(a.adresse, d.lieu_dit), (SELECT liste.valeur FROM app.liste WHERE liste.id = d.type_voirie) || ' ' || d.nom_voirie), 'SansNom')
  || ''', '
  || COALESCE((SELECT liste.valeur FROM app.liste WHERE liste.id = a.id_type_projet), 'SansType')
  || ''')' AS intitule
FROM app.projet AS "a"
JOIN localisation_simple AS "b" ON a.id = b.id_ref
JOIN app_addons.localisation_adresse AS "d" ON b.id_ref = d.id_ref
LEFT JOIN app.commune AS "c" ON d.id_commune = c.id
ORDER BY a.id),

multi AS (
WITH
localisation_multi AS (
SELECT id_ref
FROM app_addons.localisation_adresse
GROUP BY id_ref
HAVING COUNT(id_ref) > 1),

localisation_com AS (
SELECT DISTINCT
  a.id_ref,
  array_to_string(array_agg(DISTINCT c.nom ORDER BY c.nom), ', ') AS nom_communes
FROM localisation_multi AS "a"
LEFT JOIN app_addons.localisation_adresse AS "b" ON a.id_ref = b.id_ref
LEFT JOIN app.commune AS "c" ON b.id_commune = c.id
GROUP BY a.id_ref),

localisation_voirie AS (
SELECT
  a.id_ref,
  array_to_string(array_agg(DISTINCT(SELECT liste.valeur FROM app.liste WHERE liste.id = type_voirie)
  || ' ' || nom_voirie), ', ') AS voirie
FROM localisation_multi AS "b"
JOIN app_addons.localisation_adresse AS "a" ON a.id_ref = b.id_ref
GROUP BY a.id_ref),

localisation_lieu_dit AS (
SELECT
  a.id_ref,
  array_to_string(array_agg(DISTINCT a.lieu_dit ORDER BY a.lieu_dit), ', ') AS lieu_dit
FROM localisation_multi AS "b"
JOIN app_addons.localisation_adresse AS "a" ON a.id_ref = b.id_ref
WHERE a.lieu_dit IS NOT NULL
GROUP BY a.id_ref
)

SELECT
  projet.id,
  COALESCE(localisation_com.nom_communes, 'SansLocalisation')
  || ', '
  || COALESCE(CAST(EXTRACT(ISOYEAR FROM projet.date_debut) AS TEXT), 'SansDate')
  || ' ('''
  || COALESCE(COALESCE(projet.adresse, localisation_lieu_dit.lieu_dit), localisation_voirie.voirie, 'SansNom')
  || ''', '
  || COALESCE((SELECT liste.valeur FROM app.liste WHERE liste.id = projet.id_type_projet), 'SansType')
  || ''')'
  AS intitule
FROM app.projet
JOIN localisation_multi ON projet.id = localisation_multi.id_ref
JOIN localisation_voirie ON projet.id = localisation_voirie.id_ref
LEFT JOIN localisation_com ON projet.id = localisation_com.id_ref
LEFT JOIN localisation_lieu_dit ON projet.id = localisation_lieu_dit.id_ref
)

SELECT *
FROM simple
UNION
SELECT *
FROM multi
ORDER BY id