DROP TABLE  app_addons.mobilier CASCADE;
DROP TABLE  app_addons.mesure;

CREATE TABLE app_addons.mobilier (
  id SERIAL NOT NULL,
  CONSTRAINT fake_one_pkey PRIMARY KEY (id)
);

CREATE VIEW app_addons.mobilier_poids AS
SELECT
  id,
  NULL::int AS valeur
FROM app_addons.mobilier;

CREATE TABLE app_addons.mesure (
  id SERIAL NOT NULL,
  id_mobilier INTEGER,
  id_type_mesure INTEGER,
  valeur INTEGER,
  CONSTRAINT good_one_pkey PRIMARY KEY (id)
);

CREATE OR REPLACE RULE rule_fake_to_good_insert AS
  ON INSERT TO app_addons.mobilier_poids
  DO INSTEAD (
    INSERT INTO app_addons.mobilier (id)
     VALUES (nextval('app_addons.mobilier_id_seq'));
    INSERT INTO app_addons.mesure (id_mobilier, id_type_mesure, valeur)
      VALUES (currval('app_addons.mobilier_id_seq'), 569, NEW.valeur);
  );

INSERT INTO app_addons.mobilier_poids (valeur) VALUES (10);

SELECT * FROM app_addons.mesure;

SELECT * FROM app_addons.mobilier;

--Insert Rule
CREATE OR REPLACE RULE insert_new_fangled_table AS
  ON INSERT TO new_fangled
  DO INSTEAD
     INSERT INTO legacy_login (legacy_login_id, email, password, created)
     VALUES (nextval('legacy_login_id_seq'),
             NEW.username,
             NEW.password,
             TIMESTAMP WITH TIME ZONE 'epoch' + NEW.created_time * INTERVAL '1 second');

--Update Rule
CREATE OR REPLACE RULE update_new_fangled_table AS
  ON UPDATE TO new_fangled
  DO INSTEAD
     UPDATE legacy_login
        SET email = NEW.username,
            password = NEW.password,
            created = TIMESTAMP WITH TIME ZONE 'epoch' + NEW.created_time * INTERVAL '1 second'
      WHERE legacy_login_id = OLD.id;

--Delete Rule
CREATE OR REPLACE RULE delete_new_fangled_table AS
  ON DELETE TO new_fangled
  DO INSTEAD
     DELETE FROM legacy_login
      WHERE legacy_login_id = OLD.id;

