-- retire à un utilisateur tout les droits pour les opérations hors-cg62
SELECT * FROM app.projet_individu 
WHERE 
  id_projet !=7 AND
  id_individu = 23 AND 
  NOT EXISTS (SELECT projet_id FROM app_addons.projet_operateur WHERE projet_operateur.projet_id = projet_individu.id_projet)

DELETE FROM app.projet_individu 
WHERE 
  id_projet !=7 AND
  id_individu = 23 AND 
  NOT EXISTS (SELECT projet_id FROM app_addons.projet_operateur WHERE projet_operateur.projet_id = projet_individu.id_projet)