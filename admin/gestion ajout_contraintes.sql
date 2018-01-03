/* contrainte de saisie d'un numéro de parcelle
son absence bloque la requête spatiale de la page projet et provoque
une erreur 505
*/

ALTER TABLE app.parcelle
   ALTER COLUMN numero SET NOT NULL;

-- ajout d'une obligation de saisie pour les dates de modifications et de création d'un projet
-- sinon erreur 505 de l'app cliente lorsqu'elle tente de trier par date de modification

ALTER TABLE app.projet
   ALTER COLUMN creation SET NOT NULL;
   
ALTER TABLE app.projet
   ALTER COLUMN modification SET NOT NULL;
   
-- ajout d'une contrainte de non-nullité pour l'id du projet dans un row ue
-- provoque une erreur 500 pour l'utilisateur mais évite les orphelins

ALTER TABLE app.ue
  ALTER COLUMN id_projet SET NOT NULL;
  
-- ajout d'une contrainte d'unicité pour les mesures de mobilier
-- évite d'avoir deux fois la même mesure pour le même mobilier

-- ajout d'une contrainte d'unicité pour les mesures d'UE
-- évite d'avoir deux fois la même mesure pour la même UE