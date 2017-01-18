/*
La remarque porte essentiellement pour la série terrain et post-fouille :
-  Relevé de terrain :
  - saisir l’ensemble : la liste est la suivante : coupe, coupe et plan, log, plan, schéma, schéma stratigraphique
  - la légende est remplie automatiquement en récupérant les UE liés (Jean-Roc)
-  Dessin de mobilier :
  - la légende est remplie automatiquement en récupérant les mobiliers liés ex. céramique 3 (UE5) (Jean-Roc)
-  Photographie 
  - récupération automatique lors de l’import des photos des informations saisies en IPTC : Champs / orientation / sujets / mots clés (UE)

*/
BEGIN;
CREATE VIEW app.photographie_maj AS
SELECT 
  a.id,
  b.infos_photo,
  c.concat_ue,
  d.concat_mob
FROM app.document AS "a"
-- concaténation des champs photographies
LEFT JOIN (SELECT
  id As id_document,
  (SELECT valeur FROM app.liste WHERE liste.id = id_champs) || '; orientation ' || (SELECT valeur FROM app.liste WHERE liste.id = id_orientation) || '; sujet ' || (SELECT valeur FROM app.liste WHERE liste.id = id_sujet) AS infos_photo
FROM app.photographie) AS "b" ON a.id = b.id_document
-- concaténations des UE liées
LEFT JOIN (SELECT 
  document_id AS id_document,
  'UE : ' || array_to_string(array_agg(DISTINCT ue.numero ORDER BY ue.numero ASC), ', ') AS concat_ue
FROM app.document_ue
LEFT JOIN app.ue ON ue.id = document_ue.ue_id
GROUP BY id_document) AS "c" ON a.id = c.id_document
-- concaténation des mobiliers liés
LEFT JOIN (SELECT 
  document_id AS id_document,
  'Mobiliers : ' || array_to_string(array_agg(DISTINCT mobilier.numero ORDER BY mobilier.numero ASC), ', ') AS concat_mob
FROM app.document_mobilier
JOIN (SELECT id, numero FROM app.mobilier WHERE numero IS NOT NULL) AS "mobilier" ON mobilier.id = document_mobilier.mobilier_id
GROUP BY document_id) AS "d" ON a.id = d.id_document
WHERE id_projet = 814 AND type_document::text = 'photographie';

UPDATE app.document AS "a" 
SET description = b.infos_photo || ' - ' || b.concat_ue || ' - ' || b.concat_mob 
FROM app.photographie_maj AS "b" 
WHERE a.id = b.id AND description IS NULL AND b.concat_mob IS NOT NULL;

UPDATE app.document AS "a" 
SET description = b.infos_photo || ' - ' || b.concat_ue
FROM app.photographie_maj AS "b" 
WHERE a.id = b.id AND description IS NULL;

UPDATE app.document AS "a" 
SET description = b.infos_photo
FROM app.photographie_maj AS "b" 
WHERE a.id = b.id AND description IS NULL;

DROP VIEW app.photographie_maj;

/*
MAJ DES RELEVES TERRAIN
*/

CREATE VIEW app.releve_maj AS
SELECT 
  document_id AS id,
  'UE : ' || array_to_string(array_agg(DISTINCT ue.numero ORDER BY ue.numero ASC), ', ') AS concat_ue
FROM app.document_ue
JOIN app.document ON document_ue.document_id = document.id
LEFT JOIN app.ue ON ue.id = document_ue.ue_id
WHERE 
  ue.id_projet = 814
  AND id_sous_typologie = 773
GROUP BY document_id;

UPDATE app.document AS "a" 
SET description = b.concat_ue
FROM app.releve_maj AS "b" 
WHERE a.id = b.id AND description IS NULL;

DROP VIEW app.releve_maj;
COMMIT;