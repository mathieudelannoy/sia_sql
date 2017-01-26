-- ajout de champs pour la spécialité lithique
-- table app.mlithique

ALTER TABLE app.mlithique
  ADD COLUMN id_cortex integer, -- ListeLithiqueCortex
  ADD COLUMN id_talon integer, -- ListeLithiqueTalon
  ADD COLUMN accident_taille character varying(256),
  ADD COLUMN alteration character varying(256),
  ADD COLUMN id_type_percussion integer, -- ListeLithiqueTypePercussion
  ADD COLUMN id_type_debitage integer -- ListeLithiqueTypeDebitage
  ;

-- création des nouvelles listes de termes lithiques

INSERT INTO app.liste (type_liste, valeur)
  ('ListeLithiqueCortex', 'Valeur temporaire'),
  ('ListeLithiqueTalon', 'Valeur temporaire'),
  ('ListeLithiqueTypePercussion', 'Valeur temporaire'),
  ('ListeLithiqueTypeDebitage', 'Valeur temporaire');
  
-- création d'une spécialité pour la TCA
-- utilisé pour les mobiliers où la matière type est égale à 'terre cuite architecturale' (id 297, ListeMatiereType)

CREATE TABLE app.mtca (
  id integer NOT NULL,
  nmi integer,
  type character varying(256),  catégorie character varying(256),  pate character varying(256),  cuisson character varying(256),  faconnage character varying(256),  traitement_surface character varying(256),  decor character varying(256),  description_bord character varying(256),  inscription character varying(256),
  ref_biblio character varying(256),
  CONSTRAINT mtca_pkey PRIMARY KEY (id),
  CONSTRAINT mtca_fkey FOREIGN KEY (id)
    REFERENCES app.mobilier (id) MATCH FULL
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- ajout de champs pour la spécialité lapidaire
-- table app.mlapidaire

ALTER TABLE app.mlapidaire
  ADD COLUMN traitement_surface character varying(256),
  ADD COLUMN decor character varying(256),
  ADD COLUMN trace_outil character varying(256);
  
-- ajout de champs pour la spécialité anthropologie
-- table app.manthropologie

ALTER TABLE app.manthropologie
  ADD COLUMN age_precision character varying(256),
  ADD COLUMN emplacement_ossement character varying(256),
  ADD COLUMN couleurs_ossements character varying(256),
  ADD COLUMN type_cremation character varying(256),
  ADD COLUMN degre_cremation character varying(256),
  ADD COLUMN id_type_brulure integer, -- ListeAnthropologieTyperBrulure
  ADD COLUMN presence_restes_bucher boolean,
  ADD COLUMN effet_paroi boolean,
  ADD COLUMN nmi integer,
  ADD COLUMN fragmentation character varying(256),
  ADD COLUMN effet character varying(256),
  ADD COLUMN type_depot integer, -- ListeAnthropologieDepot
  ADD COLUMN coussin_funeraire
  ;

modification	compression	texte	non normalisé

-- création des nouvelles listes de termes anthropologie

INSERT INTO app.liste (type_liste, valeur)
  ('ListeAnthropologieDepot', 'primaire'),
  ('ListeAnthropologieDepot', 'secondaire'),
  ('ListeAnthropologieDepot', 'réduction'),
  ('ListeAnthropologieTyperBrulure', 'frais'),
  ('ListeAnthropologieTyperBrulure', 'sec'),

-- modification de la colonne "age" d'entier vers texte

BEGIN;

CREATE TEMPORARY TABLE conversion_anthropo_compression (
  id_mobilier INTEGER NOT NULL,
  compression INTEGER
);

INSERT INTO conversion_anthropo_compression (id_mobilier, compression)
SELECT id, compression
FROM app.manthropologie;

ALTER TABLE app.manthropologie
  DROP COLUMN compression;

ALTER TABLE app.manthropologie
  ADD COLUMN compression character varying(256);

UPDATE app.manthropologie 
SET compression = (SELECT valeur FROM app.liste WHERE liste.id = conversion_anthropo_compression.compression),
FROM conversion_anthropo_compression
WHERE manthropologie.id = conversion_anthropo_compression.id_mobilier
  
COMMIT;
  
-- ajout de champs pour la spécialité archeozoologie
-- table app.marcheozoologie

ALTER TABLE app.marcheozoologie
  ADD COLUMN id_intemperisation INTEGER, -- ListeArcheozoologieIntemperisation
  ADD COLUMN id_trace_vegetale INTEGER,  -- ListeArcheozoologieTraceVegetal
  ADD COLUMN id_trace_animale INTEGER,  -- ListeArcheozoologieTraceAnimal
  ADD COLUMN id_fracturation INTEGER,  -- ListeArcheozoologieFracturation
  ADD COLUMN type_fracturation character varying(256),
  ADD COLUMN dent_precision character varying(256);

-- création des nouvelles listes de termes archeozoologie

INSERT INTO app.liste (type_liste, valeur) VALUES
  ('ListeArcheozoologieIntemperisation', '0'),
  ('ListeArcheozoologieIntemperisation', '1'),
  ('ListeArcheozoologieIntemperisation', '2'),
  ('ListeArcheozoologieIntemperisation', '3'),
  ('ListeArcheozoologieIntemperisation', '4'),
  ('ListeArcheozoologieIntemperisation', '5'),
  ('ListeArcheozoologieTraceVegetal', '0'),
  ('ListeArcheozoologieTraceVegetal', '1'),
  ('ListeArcheozoologieTraceVegetal', '2'),
  ('ListeArcheozoologieTraceVegetal', '3'),
  ('ListeArcheozoologieTraceAnimal', '0'),
  ('ListeArcheozoologieTraceAnimal', '1'),
  ('ListeArcheozoologieTraceAnimal', '2'),
  ('ListeArcheozoologieTraceAnimal', '3'),
  ('ListeArcheozoologieFracturation', 'frais'),
  ('ListeArcheozoologieFracturation', 'sec'),
  ('ListeArcheozoologieFracturation', 'récente'),
  ('ListeArcheozoologieFracturation', 'non');
  
-- modification de la colonne "age" d'entier vers texte

BEGIN;

CREATE TEMPORARY TABLE conversion_archeozoo_age (
  id INTEGER NOT NULL,
  age INTEGER
);

INSERT INTO conversion_archeozoo_age (id, age)
SELECT id, age
FROM app.marcheozoologie;

ALTER TABLE app.marcheozoologie
  DROP COLUMN age;

ALTER TABLE app.marcheozoologie
  ADD COLUMN age character varying(256);

UPDATE app.marcheozoologie 
SET age = conversion_archeozoo_age.age
FROM conversion_archeozoo_age
WHERE marcheozoologie.id = conversion_archeozoo_age.id;
  
COMMIT;

-- ajout de champs pour la table app.pathologie

ALTER TABLE app.pathologie
  ADD COLUMN localisation character varying(256);