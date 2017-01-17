-- la commande \COPY permet d'importer un fichier tabulé dans la base en une seule transaction
-- c-à-d que si une ligne contient une erreur, le restant ne sera pas intégré

------------------
-- Projet
------------------

COPY app.projet (id, intitule, date_debut, date_fin, adresse, id_type_projet, raison_urgence, problematique_recherche, resume_scientifique, thesaurus_geographique, thesaurus_thematique, code_oa, en_cours, creation, modification)
FROM '/home/cg62/restore/projet.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app_addons.projet_operateur (projet_id, organisme_id, organisme_role_id)
FROM '/home/cg62/restore/projet_operateur.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.organisme (id, intitule, description, id_type_organisme) FROM '/home/cg62/restore/export_organisme.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER, QUOTE '*');

\COPY app.individu (id, nom, prenom, sexe, id_organisme, nom_utilisateur, role, creation, modification, mot_de_passe) FROM '/home/cg62/restore/export_individu.csv' WITH (DELIMITER E'\t', FORMAT csv);

COPY app.projet_individu (id_projet, id_individu, id_fonction, role) FROM '/home/cg62/restore/projet_individu.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app_addons.projet_operateur (projet_id, organisme_id, organisme_role_id) FROM '/home/cg62/restore/projet_operateur.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

------------------
-- UE
------------------

COPY app.ue (id,  numero,  ancien_identifiant,  id_projet,  id_type,  id_nature,  id_interpretation,  commentaire,  id_plan,  id_profil_fond,  id_profil_paroi,  id_chrono_1_debut,  id_chrono_2_debut,  tpq,  id_chrono_1_fin,  id_chrono_2_fin,  taq,  the_geom) 
FROM '/home/cg62/restore/ue.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.matrice_geologique (id, id_ue, primaire, id_texture, id_munsell, id_compacite, id_homogeinite) 
FROM '/home/cg62/restore/ue_matrice.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.inclusion_geologique (id, id_matrice, id_taille, id_concentration, id_nature) 
FROM '/home/cg62/restore/ue_inclusion.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.relationstratigraphique (ue1, id_relation, ue2) 
FROM '/home/cg62/restore/ue_strati.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

\COPY app.phase_ue (id_phase, id_ue) FROM '/home/cg62/restore/phase_ue.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

------------------
-- Mobilier
------------------

COPY app.mobilier (id, numero, precision, commentaire, id_matiere, id_matiere_type, id_matiere_type_precision, determination, id_etat_sanitaire, etat_representativite, id_etat_conservation, nombre_elements, id_objet_ou_lot, composite, id_ue, type_mobilier, id_chrono_1_debut, id_chrono_2_debut, tpq, id_chrono_1_fin, id_chrono_2_fin, taq, date_decouverte) 
FROM '/home/cg62/restore/mobilier.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

SELECT setval('app.mobilier_id_seq', (SELECT MAX(id) FROM app.mobilier)+1);

---- id_etat_representativite OUT

COPY app.mceramique (id, categorie, type, pate, bord, panse, fond, anse, nmi, cuisson, decor, description_bord, description_col, description_epaulement, description_fond, description_levre, description_panse, faconnage, ref_biblio, traitement_surface) 
FROM '/home/cg62/restore/mobilier_ceramique.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.mlithique (id, id_technologie, id_typologie, id_fragment) 
FROM '/home/cg62/restore/mobilier_lithique.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.mlapidaire (id, revetement, liant, marquage) FROM '/home/cg62/restore/mobilier_lapidaire.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.mmonnaie (id, representation, inscription_avers, description_avers, inscription_revers, description_revers, exergue, atelier) FROM '/home/cg62/restore/monnaie.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.marcheozoologie (id, age, id_espece, id_lateralisation, id_sexe, id_trace, id_region_anatomique , id_os_principal, id_os_partie_concernee, id_epiphysation) 
FROM '/home/cg62/restore/mobilier_archeozoologie.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

\COPY app.manthropologie (id, id_region_anatomique, id_os_principal, id_os_partie_concernee, id_lateralisation) FROM '/home/cg62/restore/anthropologie.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.mesure (id, id_type_mesure, id_mobilier, valeur) 
FROM '/home/cg62/restore/mesure.csv' 
WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.mesureceramique (id, id_type_mesure, id_mobilier, valeur) 
FROM '/home/cg62/restore/mesure_ceramique.csv' 
WITH (DELIMITER E'\t', FORMAT csv, HEADER);


SELECT setval('app.mesure_id_seq', (SELECT MAX(id) FROM app.mesure)+1);

------------------
-- Traitements et régie
------------------

COPY app.regie (id, id_mouvement_niveau_1, id_mouvement_niveau_2, date_sortie, date_retour_previsionnel, date_retour_effectif, commentaire) 
FROM '/home/cg62/restore/regie.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.traitement (id, id_regie, id_traitement_niveau_1, id_traitement_niveau_2, date_validite, objectif, resultat) 
FROM '/home/cg62/restore/traitement.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.traitement_mobilier (traitement_id, mobilier_id) 
FROM '/home/cg62/restore/traitement_mobilier.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

------------------
-- Liste
------------------

\COPY app.liste (id, type_liste, valeur) FROM '/home/cg62/restore/liste.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);
SELECT setval('app.liste_id_seq', (SELECT MAX(id) FROM app.liste)+1);

\COPY app.liste_liste (id_liste_parent, id_liste_child) FROM '/home/cg62/restore/liste_liste.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

------------------
-- Contenant
------------------

COPY app.contenant (id, numero, id_matiere_contenant, id_type_contenant, id_longueur_predefinie, id_largeur_predefinie, id_hauteur_predefinie, id_localisation, longueur, largeur, hauteur, volume) 
FROM '/home/cg62/restore/contenant.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

SELECT setval('app.contenant_id_seq', (SELECT MAX(id) FROM app.contenant)+1);

COPY app.contenant_mobilier (contenant_id, mobilier_id)
FROM '/home/cg62/restore/contenant_mobilier.csv'
WITH (DELIMITER E'\t', FORMAT csv, HEADER);

\COPY app.contenant_document (document_id, contenant_id) FROM '/home/cg62/restore/doc_contenant.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

\COPY app.localisation (id_batiment, id_salle, id_etagere, id_tablette) FROM '/home/cg62/restore/localisation.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

------------------
-- Document
------------------
BEGIN;
-- sans echelle
COPY app.document (id, numero, description, nombre_elements, url, date, id_typologie, id_sous_typologie, id_determination, id_categorie, id_nature_support, id_format, id_objet_lot, id_projet, type_document) 
FROM '/home/cg62/restore/document.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.photographie (id, id_champs, id_orientation, id_sujet) 
FROM '/home/cg62/restore/document_photographie.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.document_ue (document_id, ue_id)
FROM '/home/cg62/restore/document_ue.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COPY app.document_individu (document_id, individu_id)
FROM '/home/cg62/restore/document_individu.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);

COMMIT;

COPY app.document_mobilier (document_id, mobilier_id) 
FROM '/home/cg62/restore/document_mobilier.csv' WITH (DELIMITER E'\t', FORMAT csv, HEADER);