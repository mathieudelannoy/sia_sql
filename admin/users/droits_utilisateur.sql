-- Ajout de relation entre individus et projet
INSERT INTO app.projet_individu (id_projet, id_individu, id_fonction, role) VALUES
  (525, 22, 25, 'role:secretaire'),
  (525, 28, 2816, 'role:ro_adjoint')

-- voir tous les utilisateurs d'un projet
SELECT
  projet.id,
  projet.intitule,
  c.id,
  c.nom || ' ' || c.prenom AS "individu"
FROM app.projet 
LEFT JOIN app.projet_individu AS b ON projet.id = b.id_projet
RIGHT JOIN app.individu AS c ON b.id_individu = c.id
WHERE projet.id = 163;

-- voir tous les projets d'un utilisateur
SELECT
  projet.id,
  projet.intitule,
  c.id,
  c.nom || ' ' || c.prenom AS "individu"
FROM app.projet 
LEFT JOIN app.projet_individu AS b ON projet.id = b.id_projet
RIGHT JOIN app.individu AS c ON b.id_individu = c.id
WHERE c.id = 94;

DELETE FROM app.projet_individu WHERE id_projet = 250 AND id_individu = 43;

UPDATE app.individu SET mot_de_passe = '' WHERE app.individu.nom LIKE '';

-- suppression d'un individu
DELETE FROM app.regie_individu WHERE individu_id = 49;
DELETE FROM app.traitement_individu WHERE individu_id = 49;
DELETE FROM app.projet_individu WHERE id_individu =49;
DELETE FROM app.individu WHERE id = 49;


DELETE FROM app.projet_individu WHERE id_individu = 48;
UPDATE app.individu SET mot_de_passe = 'rien' WHERE id = 48;

UPDATE app.projet_individu SET role = 'role:mediateur' WHERE id_individu = 153 AND role = 'role:null';

UPDATE app.projet_individu SET role = 'role:referent_sig', id_fonction = 27 WHERE id_individu = 48 AND role = 'role:mediateur' AND id_projet = 448;

UPDATE app.projet_individu 
SET id_fonction = 2815, role = 'role:regie' 
WHERE id_individu = 153 AND role = 'role:mediateur';

UPDATE app.projet_individu 
SET id_fonction = 2816, role = 'role:administrateur' 
WHERE id_individu = 28 AND role = 'role:mediateur';

UPDATE app.projet_individu 
SET role = 'role:specialiste', id_fonction = 11
FROM app_addons.projet_operateur AS "b"
WHERE 
  id_individu = 41 
  AND role != 'role:specialiste' 
  AND id_projet = b.projet_id
  AND b.organisme_id = 1
  AND organisme_role_id = 32;
