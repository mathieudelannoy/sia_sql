SELECT
  regexp_replace(valeur, '\r|\n', '', 'g') 
FROM app.liste
WHERE id = 2775

UPDATE app.liste SET valeur = regexp_replace(valeur, '\r|\n', '', 'g') WHERE type_liste = 'ListeAnthropologiePathologiesObservees';

