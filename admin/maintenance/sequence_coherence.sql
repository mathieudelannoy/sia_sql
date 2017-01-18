-- test cohérence incrémentation

--SELECT MAX(id) FROM app.;
--SELECT nextval('app._id_seq');
--SELECT setval('app._id_seq', (SELECT MAX(id) FROM app.));

SELECT MAX(id) FROM app.projet;
SELECT nextval('app.projet_id_seq');
--SELECT setval('app.projet_id_seq', (SELECT MAX(id) FROM app.projet)+1);
SELECT setval('app.projet_id_seq', (SELECT MAX(id) FROM app.projet));

SELECT MAX(id) FROM app.ue;
SELECT nextval('app.ue_id_seq');
SELECT setval('app.ue_id_seq', (SELECT MAX(id) FROM app.ue));

SELECT setval('app.ue_id_seq', (SELECT MAX(id) FROM app.ue)+171);

SELECT MAX(id) FROM app.contenant;
SELECT nextval('app.contenant_id_seq');
SELECT setval('app.contenant_id_seq', (SELECT MAX(id) FROM app.contenant)+69);
SELECT setval('app.contenant_id_seq', 7155);

SELECT MAX(id) FROM app.inclusion_geologique;
SELECT nextval('app.inclusion_geologique_id_seq');
SELECT setval('app.inclusion_geologique_id_seq', (SELECT MAX(id) FROM app.inclusion_geologique));

SELECT MAX(id) FROM app.matrice_geologique;
SELECT nextval('app.matrice_geologique_id_seq');
SELECT setval('app.matrice_geologique_id_seq', (SELECT MAX(id) FROM app.matrice_geologique));
SELECT setval('app.matrice_geologique_id_seq', (SELECT MAX(id) FROM app.matrice_geologique)+129);

SELECT MAX(id) FROM app.document;
SELECT nextval('app.document_id_seq');
SELECT setval('app.document_id_seq', (SELECT MAX(id) FROM app.document));

SELECT setval('app.document_id_seq', (SELECT MAX(id) FROM app.document)+14);

SELECT MAX(id) FROM app.individu;
SELECT nextval('app.individu_id_seq');
SELECT setval('app.individu_id_seq', (SELECT MAX(id) FROM app.individu));

SELECT MAX(id) FROM app.liste;
SELECT nextval('app.liste_id_seq');
SELECT setval('app.liste_id_seq', (SELECT MAX(id) FROM app.liste));

----
--  MOBILIER
----
SELECT MAX(id) FROM app.mobilier;
SELECT nextval('app.mobilier_id_seq');
SELECT setval('app.mobilier_id_seq', (SELECT MAX(id) FROM app.mobilier));
SELECT setval('app.mobilier_id_seq', (SELECT MAX(id) FROM app.mobilier)+393);
SELECT setval('app.mobilier_id_seq', 43435);

SELECT MAX(id) FROM app.pathologie;
SELECT nextval('app.pathologie_id_seq');
SELECT setval('app.pathologie_id_seq', (SELECT MAX(id) FROM app.pathologie));

SELECT MAX(id) FROM app.localisation;
SELECT nextval('app.localisation_id_seq');
SELECT setval('app.localisation_id_seq', (SELECT MAX(id) FROM app.localisation));


----
--  MESURES
----
SELECT MAX(id) FROM app.mesure;
SELECT nextval('app.mesure_id_seq');
SELECT setval('app.mesure_id_seq', (SELECT MAX(id) FROM app.mesure));
SELECT setval('app.mesure_id_seq', (SELECT MAX(id) FROM app.mesure)+324);

SELECT MAX(id) FROM app.mesureanthropologique;
SELECT nextval('app.mesureanthropologique_id_seq');
SELECT setval('app.mesureanthropologique_id_seq', (SELECT MAX(id) FROM app.mesureanthropologique));

SELECT MAX(id) FROM app.mesurearcheozoologique;
SELECT nextval('app.mesurearcheozoologique_id_seq');
SELECT setval('app.mesurearcheozoologique_id_seq', (SELECT MAX(id) FROM app.mesurearcheozoologique));

SELECT MAX(id) FROM app.mesureceramique;
SELECT nextval('app.mesureceramique_id_seq');
SELECT setval('app.mesureceramique_id_seq', (SELECT MAX(id) FROM app.mesureceramique));

SELECT MAX(id) FROM app.phase;
SELECT nextval('app.phase_id_seq');
SELECT setval('app.phase_id_seq', (SELECT MAX(id) FROM app.phase));

----
--  GEOMETRIES
----

SELECT MAX(id) FROM app.commune;
SELECT nextval('app.commune_id_seq');
SELECT setval('app.commune_id_seq', (SELECT MAX(id) FROM app.commune));

SELECT MAX(id) FROM app.section;
SELECT nextval('app.section_id_seq');
SELECT setval('app.section_id_seq', (SELECT MAX(id) FROM app.section));

SELECT MAX(id) FROM app.parcelle;
SELECT nextval('app.parcelle_id_seq');
SELECT setval('app.parcelle_id_seq', (SELECT MAX(id) FROM app.parcelle));

SELECT MAX(id) FROM app.statutjuridique;
SELECT nextval('app.statutjuridique_id_seq');
SELECT setval('app.statutjuridique_id_seq', (SELECT MAX(id) FROM app.statutjuridique));

SELECT MAX(id) FROM app.traitement;
SELECT nextval('app.traitement_id_seq');
SELECT setval('app.traitement_id_seq', (SELECT MAX(id) FROM app.traitement));

SELECT MAX(id) FROM app.regie;
SELECT nextval('app.regie_id_seq');
SELECT setval('app.regie_id_seq', (SELECT MAX(id) FROM app.regie));