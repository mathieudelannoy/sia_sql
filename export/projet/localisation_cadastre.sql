CREATE MATERIALIZED VIEW app.projet_localisation_cadastre AS

WITH
-- sélection des projets de la direction
selection_projet AS (
SELECT
  projet.id AS id_projet,
  date_debut,
  date_fin,
  projet.the_geom
FROM app.projet
JOIN app_addons.projet_operateur ON projet.id = projet_operateur.projet_id
WHERE 
  organisme_id = 1
),
-- sélections ayant une date de validité compatible avec les date de début et fin des projets
selection_parcelle AS (
SELECT DISTINCT
  b.id_projet,
  a.numero AS nom_parcelle,
  a.the_geom
FROM 
  app.parcelle AS a, 
  selection_projet AS b
WHERE
  tsrange(a.debut_validite, a.fin_validite) && tsrange(b.date_debut, COALESCE(b.date_fin, CURRENT_DATE))
  AND (
  ST_Intersects(b.the_geom, a.the_geom)
  OR ST_Contains(a.the_geom, b.the_geom))
ORDER BY id_projet
),

selection_section AS (
SELECT DISTINCT
  b.id_projet,
  a.id AS id_section,
  a.nom AS nom_section,
  a.the_geom
FROM 
  app.section AS a, 
  selection_projet AS b
WHERE
  tsrange(a.date_debut, a.date_fin) && tsrange(b.date_debut, COALESCE(b.date_fin, CURRENT_DATE))
  AND (
  ST_Intersects(b.the_geom, a.the_geom)
  OR ST_Contains(a.the_geom, b.the_geom))
ORDER BY id_projet, nom_section
),

selection_commune AS (
SELECT
  b.id_projet,
  a.nom AS nom_commune,
  a.the_geom
FROM 
  app.commune AS a,
  selection_projet AS b
WHERE
  tsrange(a.date_debut, a.date_fin) && tsrange(b.date_debut, COALESCE(b.date_fin, CURRENT_DATE))
  AND (
  ST_Intersects(b.the_geom, a.the_geom)
  OR ST_Contains(a.the_geom, b.the_geom))
ORDER BY id_projet, nom_commune
),
-- regouprements et concaténations
join_section_commune AS (
SELECT
  a.id_projet,
  b.nom_commune,
  a.id_section,
  a.nom_section
FROM
  selection_section AS a
JOIN selection_commune AS b ON 
  a.id_projet = b.id_projet
  AND ST_Contains(b.the_geom, ST_PointOnSurface(a.the_geom))
GROUP BY a.id_projet, nom_commune, id_section, nom_section
ORDER BY a.id_projet, nom_commune, nom_section
),

join_section_parcelle AS (
SELECT 
  b.id_projet,
  b.id_section,
  b.nom_section || ' ' ||
  array_to_string(array_agg(a.nom_parcelle ORDER BY a.nom_parcelle::int ASC), ', ') AS parcelles
FROM selection_parcelle AS a
JOIN selection_section AS b ON
  a.id_projet = b.id_projet
  AND ST_Contains(b.the_geom, ST_PointOnSurface(a.the_geom))
GROUP BY b.id_projet, b.id_section, nom_section
),

resultat_par_commune  AS (
SELECT
  a.id_projet,
  a.nom_commune || ' '||
   array_to_string(
   array_agg(
   COALESCE(b.parcelles, a.nom_section)
   ), ', ') AS loc
FROM join_section_commune AS "a"
LEFT JOIN join_section_parcelle AS "b" ON
  a.id_projet = b.id_projet
  AND a.id_section = b.id_section
GROUP BY a.id_projet, nom_commune
ORDER BY loc)

SELECT
  id_projet,
  array_to_string(array_agg(loc ORDER BY loc), ' / ') As localisation_cadastre
FROM resultat_par_commune
GROUP BY id_projet
ORDER BY id_projet;

COMMENT ON MATERIALIZED VIEW app.projet_localisation_cadastre
  IS 'localisation à la commune, section et parcelle de l''emprise des projets en tenant compte des dates de validité de chaque éléments';

CREATE UNIQUE INDEX constraint_idx_projet_localisation_cadastre_id_projet ON app.projet_localisation_cadastre (id_projet);

CREATE INDEX idx_projet_localisation_cadastre_id_projet on app.projet_localisation_cadastre USING btree (id_projet, localisation_cadastre);