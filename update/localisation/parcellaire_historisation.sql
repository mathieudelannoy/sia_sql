-- jeu de test
CREATE TABLE app_addons.commune AS
SELECT * 
FROM app.commune
WHERE nom = 'Mont-Saint-Éloi';

CREATE TABLE app_addons.section AS
SELECT section.id, section.nom, section.the_geom
FROM app.section, app_addons.commune
WHERE ST_WITHIN(section.the_geom, commune.the_geom);

CREATE TABLE app_addons.parcelle AS
SELECT  parcelle.id, parcelle.numero, parcelle.the_geom
FROM app_addons.section, app.parcelle
WHERE ST_Overlaps(parcelle.the_geom, section.the_geom);


-- ajout d'une période de validité de la commune
ALTER TABLE app_addons.commune
  ADD COLUMN date_debut timestamp without time zone;
ALTER TABLE app_addons.commune
  ADD COLUMN date_fin timestamp without time zone;

-- ajout d'une période de validité de la section
ALTER TABLE app_addons.section
  ADD COLUMN date_debut timestamp without time zone;
ALTER TABLE app_addons.section
  ADD COLUMN date_fin timestamp without time zone;

-- valeur par défaut pour toutes les communes
UPDATE app_addons.commune
SET date_debut = '1968-01-01'
WHERE date_debut IS NULL;
UPDATE app_addons.commune
date_fin = '2099-12-31';
WHERE date_fin IS NULL;

-- valeur par défaut pour toutes les sections
UPDATE app_addons.section
SET date_debut = '1968-01-01'
WHERE date_debut IS NULL;
UPDATE app_addons.section
date_fin = '2099-12-31';
WHERE date_fin IS NULL;

-- valeurs par défaut pour les parcelles_mse
UPDATE app.parcelle
SET debut_validite = projet.date_debut, fin_validite = projet.date_fin
FROM app.projet
WHERE 
  the_geom is not null 
  AND ST_ISEmpty(ST_CollectionExtract(projet.the_geom, 3)) IS FALSE
  AND (ST_Intersects(the_geom_projet, section.the_geom)
  OR ST_Contains(section.the_geom, the_geom_projet));
  
SELECT
  parcelle.debut_validite,
  parcelle.fin_validite,
  projet.date_debut,
  projet.date_fin
FROM app.projet, app.parcelle
WHERE 
  the_geom is not null 
  AND ST_ISEmpty(ST_CollectionExtract(projet.the_geom, 3)) IS FALSE
  AND (ST_Intersects(the_geom_projet, section.the_geom)
  OR ST_Contains(section.the_geom, the_geom_projet));

-- jeu de données mont saint-éloi
INSERT INTO app.parcelle (numero, id_section, debut_validite, fin_validite, the_geom) 
SELECT numero, id_section, debut_validite, fin_validite, the_geom 
FROM app_addons.parcelle;


  id serial NOT NULL,
  geom geometry(MultiPolygon,3857),
  numero integer,
  date_debut date,
  date_fin date,
  CONSTRAINT parcelles_mse_pkey PRIMARY K
  
CREATE TABLE app_addons.parcelle
(
  id serial NOT NULL,
  numero character varying(32) NOT NULL,
  debut_validite date,
  fin_validite date,
  proprietaire character varying(256),
  id_section integer,
  the_geom geometry,
  CONSTRAINT parcellebis_pkey PRIMARY KEY (id),
  CONSTRAINT parcellebis_id_section_fkey FOREIGN KEY (id_section)
      REFERENCES app.section (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);