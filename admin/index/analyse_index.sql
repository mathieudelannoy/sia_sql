--- SCHEMA CREATION

CREATE SCHEMA stats
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA stats TO postgres;
GRANT ALL ON SCHEMA stats TO jrmorreale;
GRANT USAGE ON SCHEMA stats TO admin_sia_minimun;

----------
-- PROJET
CREATE INDEX CONCURRENTLY idx_projet_intitule_and_id ON app.projet USING btree (intitule, id);
CREATE INDEX CONCURRENTLY idx_projet_id_and_intitule ON app.projet USING btree (id, intitule);
CREATE INDEX CONCURRENTLY idx_projet_intitule ON app.projet USING btree (intitule);
CREATE INDEX CONCURRENTLY idx_ue_id_projet_id_ue ON app.ue USING btree (id_projet, id);

----------
-- PROJET_INDIVIDU
CREATE INDEX CONCURRENTLY idx_projet_individu_id_individu_and_id_projet ON app.projet_individu USING btree (id_individu, id_projet);
CREATE INDEX CONCURRENTLY idx_projet_individu_id_projet_individu_role ON app.projet_individu USING btree (id_projet, id_individu, role);
CREATE INDEX CONCURRENTLY idx_projet_individu_id_fonction ON app.projet_individu USING btree (id_fonction);
CREATE INDEX CONCURRENTLY idx_projet_individu_role ON app.projet_individu USING btree (role);
----------
-- UE
CREATE INDEX CONCURRENTLY idx_ue_numero ON app.ue USING btree (numero);
-- CREATE INDEX CONCURRENTLY idx_ue_id_projet ON app.ue USING btree (id_projet);
CREATE INDEX CONCURRENTLY idx_ue_id_projet_num_ue ON app.ue USING btree (id_projet, numero);
CREATE INDEX CONCURRENTLY idx_ue_centroide ON app.ue USING gist (ST_PointOnSurface(ue.the_geom));
CREATE INDEX CONCURRENTLY idx_ue_id_id_projet ON app.ue USING btree (id, id_projet);
CREATE INDEX CONCURRENTLY idx_ue_id_num_ue ON app.ue USING btree (id, numero);

----------
-- MATRICE_GEOLOGIQUE
CREATE INDEX CONCURRENTLY idx_matrice_geologique_id_ue ON app.matrice_geologique USING btree (id_ue);
CREATE INDEX CONCURRENTLY idx_matrice_geologique_id_munsell ON app.matrice_geologique USING btree (id_munsell);
CREATE INDEX CONCURRENTLY idx_matrice_geologique_id_compacite ON app.matrice_geologique USING btree (id_compacite);
CREATE INDEX CONCURRENTLY idx_matrice_geologique_id_homogeinite ON app.matrice_geologique USING btree (id_homogeinite);
CREATE INDEX CONCURRENTLY idx_matrice_geologique_id_texture ON app.matrice_geologique USING btree (id_texture);
----------
-- INCLUSION_GEOLOGIQUE
CREATE INDEX CONCURRENTLY idx_inclusion_geologique_id_matrice ON app.inclusion_geologique USING btree (id_matrice);
CREATE INDEX CONCURRENTLY idx_inclusion_geologique_id_taille ON app.inclusion_geologique USING btree (id_taille);
CREATE INDEX CONCURRENTLY idx_inclusion_geologique_id_nature ON app.inclusion_geologique USING btree (id_nature);
CREATE INDEX CONCURRENTLY idx_inclusion_geologique_id_concentration ON app.inclusion_geologique USING btree (id_concentration);
-------
-- MOBILIER
CREATE INDEX CONCURRENTLY idx_mobilier_numero ON app.mobilier USING btree (numero);
CREATE INDEX CONCURRENTLY idx_mobilier_id_numero ON app.mobilier USING btree (id,numero);
CREATE INDEX CONCURRENTLY idx_mobilier_id_mob_and_id_ue ON app.mobilier USING btree (id, id_ue);
CREATE INDEX CONCURRENTLY idx_mobilier_id_ue_and_id_mob ON app.mobilier USING btree (id_ue, id);
CREATE INDEX CONCURRENTLY idx_mobilier_matiere ON app.mobilier USING btree (id_matiere);
CREATE INDEX CONCURRENTLY idx_mobilier_matiere_type ON app.mobilier USING btree (id_matiere_type);
CREATE INDEX CONCURRENTLY idx_mobilier_type_mobilier ON app.mobilier USING btree (type_mobilier);
CREATE INDEX CONCURRENTLY idx_mobilier_nombre_elements ON app.mobilier USING btree (nombre_elements);
-- relation intermobilier
CREATE INDEX idx_relationintermobilier_mobilier_2_1 ON app.relationintermobilier USING btree (mobilier2 ,mobilier1);

-------
-- MCERAMIQUE
CREATE INDEX CONCURRENTLY idx_mceramique_categorie ON app.mceramique USING btree (categorie);
CREATE INDEX CONCURRENTLY idx_mceramique_type ON app.mceramique USING btree (type);
CREATE INDEX CONCURRENTLY idx_mceramique_pate ON app.mceramique USING btree (pate);
CREATE INDEX CONCURRENTLY idx_mceramique_bord ON app.mceramique USING btree (bord);
CREATE INDEX CONCURRENTLY idx_mceramique_panse ON app.mceramique USING btree (panse);
CREATE INDEX CONCURRENTLY idx_mceramique_fond ON app.mceramique USING btree (fond);
CREATE INDEX CONCURRENTLY idx_mceramique_anse ON app.mceramique USING btree (anse);
CREATE INDEX CONCURRENTLY idx_mceramique_nmi ON app.mceramique USING btree (nmi);
CREATE INDEX CONCURRENTLY idx_mceramique_cuisson ON app.mceramique USING btree (cuisson);
CREATE INDEX CONCURRENTLY idx_mceramique_decor ON app.mceramique USING btree (decor);
CREATE INDEX CONCURRENTLY idx_mceramique_traitement_surface ON app.mceramique USING btree (traitement_surface);
CREATE INDEX CONCURRENTLY idx_mceramique_faconnage ON app.mceramique USING btree (faconnage);

-------
-- MLITHIQUE

CREATE INDEX CONCURRENTLY idx_mlithique_id_typo ON app.mlithique USING btree (id, id_typologie);
CREATE INDEX CONCURRENTLY idx_mlithique_typo ON app.mlithique USING btree (id_typologie);
CREATE INDEX CONCURRENTLY idx_mlithique_id_techno ON app.mlithique USING btree (id, id_technologie);
CREATE INDEX CONCURRENTLY idx_mlithique_techno ON app.mlithique USING btree (id_technologie);
CREATE INDEX CONCURRENTLY idx_mlithique_fragment ON app.mlithique USING btree (id_fragment);

CREATE INDEX CONCURRENTLY idx_mlithique_ ON app.mlithique USING btree ();

-------
-- ANTHROPO
-- pathologie
CREATE INDEX CONCURRENTLY idx_pathologie_id_mobilier ON app.pathologie USING btree (id_mobilier);
CREATE INDEX CONCURRENTLY idx_pathologie_id_codification ON app.pathologie USING btree (id_codification);
CREATE INDEX CONCURRENTLY idx_pathologie_id_type_pathologie ON app.pathologie USING btree (id_type_pathologie);
CREATE INDEX CONCURRENTLY idx_pathologie_id_type_pathologie_observe ON app.pathologie USING btree (id_type_pathologie_observe);
--connexions
CREATE INDEX CONCURRENTLY idx_connexionanthropologique_id_mobilier ON app.connexionanthropologique USING btree (id_mobilier);
CREATE INDEX CONCURRENTLY idx_connexionanthropologique_id_etat ON app.connexionanthropologique USING btree (id_etat);
CREATE INDEX CONCURRENTLY idx_connexionanthropologique_id_type_connexion ON app.connexionanthropologique USING btree (id_type_connexion);

-------
-- ARCHEOZOOLOGIE

CREATE INDEX CONCURRENTLY idx_marcheozoologie_os_region_to_partie ON app.marcheozoologie USING btree (id_region_anatomique, id_os_principal, id_os_partie_concernee);
		

CREATE INDEX CONCURRENTLY idx_marcheozoologie_os_principal ON app.marcheozoologie USING btree (id_os_principal);
CREATE INDEX CONCURRENTLY idx_marcheozoologie_os_partie ON app.marcheozoologie USING btree (id_os_partie_concernee);
CREATE INDEX CONCURRENTLY idx_marcheozoologie_espece ON app.marcheozoologie USING btree (id_espece);
CREATE INDEX CONCURRENTLY idx_marcheozoologie_trace ON app.marcheozoologie USING btree (id_trace);
CREATE INDEX CONCURRENTLY idx_marcheozoologie_sexe ON app.marcheozoologie USING btree (id_sexe);
CREATE INDEX CONCURRENTLY idx_marcheozoologie_epiphysation ON app.marcheozoologie USING btree (id_epiphysation);

CREATE INDEX CONCURRENTLY idx_marcheozoologie_ ON app.marcheozoologie USING btree ();
------------
-- CONTENANT
CREATE INDEX CONCURRENTLY idx_contenant_numero ON app.contenant USING btree (numero);
CREATE INDEX CONCURRENTLY idx_contenant_matiere ON app.contenant USING btree (id_matiere_contenant);
CREATE INDEX CONCURRENTLY idx_contenant_id_type_contenant ON app.contenant USING btree (id_type_contenant);
CREATE INDEX CONCURRENTLY idx_contenant_id_longueur_predefinie ON app.contenant USING btree (id_longueur_predefinie);
CREATE INDEX CONCURRENTLY idx_contenant_id_largeur_predefinie ON app.contenant USING btree (id_largeur_predefinie);
CREATE INDEX CONCURRENTLY idx_contenant_id_hauteur_predefinie ON app.contenant USING btree (id_hauteur_predefinie);
CREATE INDEX CONCURRENTLY idx_contenant_id_localisation ON app.contenant USING btree (id_localisation);
------------
-- CONTENANT_MOBILIER
CREATE INDEX idx_contenant_mobilier_id_contenant_and_id_mob ON app.contenant_mobilier USING btree (contenant_id , mobilier_id );
------------
-- CONTENANT_DOCUMENT
CREATE INDEX idx_contenant_document_id_contenant_and_id_doc ON app.contenant_document USING btree (contenant_id ,document_id );
------------
-- LOCALISATION
CREATE INDEX CONCURRENTLY idx_localisation_id_batiment ON app.localisation USING btree (id_batiment);
CREATE INDEX CONCURRENTLY idx_localisation_id_salle ON app.localisation USING btree (id_salle);
CREATE INDEX CONCURRENTLY idx_localisation_id_etagere ON app.localisation USING btree (id_etagere);
CREATE INDEX CONCURRENTLY idx_localisation_id_tablette ON app.localisation USING btree (id_tablette);			

------------
-- DOCUMENT
CREATE INDEX CONCURRENTLY idx_document_id_typologie ON app.document USING btree (id_typologie);
CREATE INDEX CONCURRENTLY idx_document_id_sous_typologie ON app.document USING btree (id_sous_typologie);
CREATE INDEX CONCURRENTLY idx_document_id_determination ON app.document USING btree (id_determination);
CREATE INDEX CONCURRENTLY idx_document_id_categorie ON app.document USING btree (id_categorie);
CREATE INDEX CONCURRENTLY idx_document_id_nature_support ON app.document USING btree (id_nature_support);
CREATE INDEX CONCURRENTLY idx_document_id_format ON app.document USING btree (id_format);
CREATE INDEX CONCURRENTLY idx_document_id_objet_lot ON app.document USING btree (id_objet_lot);
CREATE INDEX CONCURRENTLY idx_document_id_projet ON app.document USING btree (id_projet);
------------
-- DOCUMENT_INDIVIDU
CREATE INDEX idx_document_individu_id_individu_and_id_doc ON app.document_individu USING btree (individu_id ,document_id );
------------
-- DOCUMENT_MOBILIER
CREATE INDEX idx_document_individu_id_mobilier_and_id_doc ON app.document_mobilier USING btree (mobilier_id ,document_id );
------------
-- DOCUMENT_UE
CREATE INDEX idx_document_individu_id_ue_and_id_doc ON app.document_ue USING btree (ue_id ,document_id );

----------
-- MESURE
CREATE INDEX CONCURRENTLY idx_mesure_valeur ON app.mesure USING btree (valeur);
CREATE INDEX CONCURRENTLY idx_mesure_id_type_mesure_and_valeur ON app.mesure USING btree (id_type_mesure, valeur);
CREATE INDEX CONCURRENTLY idx_mesure_id_mobilier_and_valeur ON app.mesure USING btree (id_mobilier, valeur);
CREATE INDEX CONCURRENTLY idx_mesure_id_mobilier_and_id_type_mesure_and_valeur ON app.mesure USING btree (id_mobilier, id_type_mesure, valeur);
CREATE INDEX CONCURRENTLY idx_mesure_id_type_mesure_id_mobilier_and_valeur ON app.mesure USING btree (id_type_mesure, id_mobilier, valeur);
----------
-- MESURE ANTHROPOLOGIQUE
CREATE INDEX CONCURRENTLY idx_mesureanthropologique_id_type_mesure_id_mobilier_and_valeur ON app.mesureanthropologique USING btree (id_type_mesure, id_mobilier, valeur);
CREATE INDEX CONCURRENTLY idx_mesureanthropologique_id_mobilier_and_valeur ON app.mesureanthropologique USING btree (id_mobilier, valeur);
----------
-- MESURE ARCHEOZOOLOGIQUE
CREATE INDEX CONCURRENTLY idx_mesurearcheozoologique_id_type_mesure_id_mobilier_and_valeur ON app.mesurearcheozoologique USING btree (id_type_mesure, id_mobilier, valeur);
CREATE INDEX CONCURRENTLY idx_mesurearcheozoologique_id_mobilier_and_valeur ON app.mesurearcheozoologique USING btree (id_mobilier, valeur);

----------
-- COMMUNE
CREATE INDEX CONCURRENTLY idx_commune_nom ON app.commune USING btree (nom);
CREATE INDEX CONCURRENTLY idx_commune_id_nom ON app.commune USING btree (id, nom);
----------
-- PARCELLE
CREATE INDEX CONCURRENTLY idx_parcelle_num ON app.parcelle USING btree (numero);
CREATE INDEX CONCURRENTLY idx_parcelle_id_num ON app.parcelle USING btree (id, numero);
CREATE INDEX CONCURRENTLY idx_parcelle_id_parcelle_and_id_section ON app.parcelle USING btree (id, id_section);
----------
-- SECTION
CREATE INDEX CONCURRENTLY idx_section_nom ON app.section USING btree (nom);
CREATE INDEX CONCURRENTLY idx_section_id_and_nom ON app.section USING btree (id, nom);
CREATE INDEX CONCURRENTLY idx_section_id_section_and_id_commune ON app.section USING btree (id, id_commune);

---------
-- TRAITEMENTS
-- individu
CREATE INDEX idx_traitement_individu_id_individu_and_id_traitement ON app.traitement_individu USING btree (individu_id, traitement_id);
-- mobilier
CREATE INDEX idx_traitement_mobilier_id_mobilier_and_id_traitement ON app.traitement_mobilier USING btree (mobilier_id, traitement_id);

---------
-- REGIE
CREATE INDEX idx_regie_individu_id_mindividu_and_id_regie ON app.regie_individu USING btree (individu_id, regie_id);

---------
-- LISTE

CREATE INDEX CONCURRENTLY idx_liste_id_valeur ON app.liste USING btree (id, valeur);
CREATE INDEX CONCURRENTLY idx_liste_valeur ON app.liste USING btree (valeur);
CREATE INDEX CONCURRENTLY idx_liste_id_type ON app.liste USING btree (id, type_liste);

CREATE INDEX idx_liste_type_valeur ON app.liste USING btree (type_liste, valeur);


CREATE INDEX CONCURRENTLY idx_ ON app. USING btree ();
CREATE INDEX CONCURRENTLY idx_ ON app. USING btree ();
CREATE INDEX CONCURRENTLY idx_ ON app. USING btree ();