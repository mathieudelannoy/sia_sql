BEGIN;

-- ajout d'une période de validité de la commune
ALTER TABLE app.commune
  ADD COLUMN date_debut timestamp without time zone;
ALTER TABLE app.commune
  ADD COLUMN date_fin timestamp without time zone;

-- ajout d'une période de validité de la section
ALTER TABLE app.section
  ADD COLUMN date_debut timestamp without time zone;
ALTER TABLE app.section
  ADD COLUMN date_fin timestamp without time zone;

-- valeur par défaut pour toutes les communes
UPDATE app.commune
SET date_debut = '1968-01-01'
WHERE date_debut IS NULL;

UPDATE app.commune
SET date_fin = '2099-12-31'
WHERE date_fin IS NULL;

-- valeur par défaut pour toutes les sections
UPDATE app.section
SET date_debut = '1968-01-01'
WHERE date_debut IS NULL;

UPDATE app.section
SET date_fin = '2099-12-31'
WHERE date_fin IS NULL;

UPDATE app.parcelle
SET fin_validite = '2099-12-31'
WHERE fin_validite IS NULL;

COMMIT;

CREATE INDEX dx_projet_tsrange on app.projet USING GiST (tsrange(date_debut, date_fin));
CREATE INDEX dx_commune_tsrange on app.commune USING GiST (tsrange(date_debut, date_fin));
CREATE INDEX dx_section_tsrange on app.section USING GiST (tsrange(date_debut, date_fin));
CREATE INDEX dx_parcelle_tsrange on app.parcelle USING GiST (tsrange(debut_validite, fin_validite));