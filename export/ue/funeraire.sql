/*
sélection des structures fosses = creusement
*/

CREATE VIEW sp_creusement AS
SELECT
  ens.num_ensemble,
  a.numero,
  femp.emplacement,
  'plan ' || (SELECT valeur FROM app.liste WHERE liste.id = a.id_plan) || 
  ', fond ' || (SELECT valeur FROM app.liste WHERE liste.id = a.id_profil_fond) ||
  ', paroi ' || (SELECT valeur FROM app.liste WHERE liste.id = a.id_profil_paroi) AS "forme_fosse",
  flg3.dimensions
FROM app.ue AS "a"
-- jointure du numéro d'ensemble
LEFT JOIN (SELECT rs.ue1, ue.numero AS "num_ensemble"
FROM app.relationstratigraphique AS rs
JOIN app.ue ON rs.ue2 = ue.id
WHERE rs.id_relation = 45 AND ue.id_type = 40 AND ue.id_nature = 210 AND ue.id_projet = 155) AS ens ON ens.ue1 = a.id
-- jointure du niveau de cimetière correspondant
LEFT JOIN (SELECT
  a.id,
  replace(replace(
  array_to_string(array_agg('UE ' || nvc.numero || ', ' || nvc.commentaire), '; ')
  , ' ; scories', ''), ', scories', '') as "emplacement"
FROM app.ue AS "a"
LEFT JOIN (SELECT rs.ue1, rs.ue2, ue.numero, ue.commentaire
FROM app.relationstratigraphique AS rs
JOIN app.ue ON rs.ue2 = ue.id
WHERE 
  rs.id_relation = 47 
  AND ue.id_type = 37 
  AND ue.id_projet = 155
  AND ue.commentaire LIKE '%cimetière%') 
  AS "nvc" ON nvc.ue1 = a.id
WHERE a.id_interpretation = 252
GROUP BY a.id) AS femp ON femp.id = a.id
-- jointure des dimensions de la fosse
LEFT JOIN (SELECT a.id, a.numero, flg.valeur::text || 'cm x ' ||  flg2.valeur::text || 'cm' AS "dimensions" FROM app.ue AS "a"
LEFT JOIN  (SELECT MAX(valeur) AS valeur, id_ue FROM app.mesure WHERE id_type_mesure = 568 GROUP BY id_ue) AS flg ON flg.id_ue = a.id
LEFT JOIN  (SELECT MAX(valeur) AS valeur, id_ue FROM app.mesure WHERE id_type_mesure = 566 GROUP BY id_ue) AS flg2 ON flg2.id_ue = a.id
WHERE a.id_interpretation = 252 and a.id_projet = 155 ) AS flg3 ON flg3.id = a.id
WHERE a.id_interpretation = 252 and a.id_projet = 155
ORDER BY ens.num_ensemble, a.numero;

/*
sélection des contenants funéraires
*/

CREATE VIEW sp_contenant_funeraire AS
SELECT
  ens.num_ensemble,
  a.numero AS "numero_contenant",
  COALESCE((SELECT valeur FROM app.liste WHERE liste.id = a.id_interpretation), 'indéterminé') AS "type_contenant",
  clou_contenant.nombre_elements AS clous_contenant,
  COALESCE(epingle_contenant.nbr, 0) || ' en ' || epingle_contenant.epingle_contenant_alliage AS epingles_contenant,
  COALESCE(tissus_contenant.tissu::text, 'pas d''indice') AS tissu_contenant,
  COALESCE(bois_contenant.determination, 'pas d''indice') AS bois_contenant
FROM app.ue AS "a"
-- jointure du numéro d'ensemble
LEFT JOIN (SELECT rs.ue1, ue.numero AS "num_ensemble"
FROM app.relationstratigraphique AS rs
JOIN app.ue ON rs.ue2 = ue.id
WHERE rs.id_relation = 45 AND ue.id_type = 40 AND ue.id_nature = 210 AND ue.id_projet = 155) AS ens ON ens.ue1 = a.id
-- jointure des clous avec total du nombre d'éléments
LEFT JOIN (SELECT id_ue, nombre_elements FROM app.mobilier 
WHERE mobilier.determination = 'clou' AND nombre_elements IS NOT NULL) as "clou_contenant" ON a.id = clou_contenant.id_ue
-- jointure des épingles
LEFT JOIN (SELECT id_ue, SUM(nombre_elements) AS nbr, 
(SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type_precision) AS epingle_contenant_alliage FROM app.mobilier WHERE mobilier.determination = 'épingle' AND nombre_elements IS NOT NULL GROUP BY id_ue, epingle_contenant_alliage) as "epingle_contenant" ON a.id = epingle_contenant.id_ue
-- jointures des tissus (linceuls)
LEFT JOIN (SELECT id_ue, 'fragment de linceul' AS tissu,
 mobilier.determination FROM app.mobilier WHERE mobilier.determination LIKE '%linceul%') AS tissus_contenant ON tissus_contenant.id_ue = a.id
-- jointure des bois
LEFT JOIN (SELECT id_ue, mobilier.determination 
FROM app.mobilier WHERE mobilier.determination LIKE '%bois%') AS bois_contenant ON bois_contenant.id_ue = a.id 
WHERE 
  a.id_nature = 1838 
  AND a.id_projet = 155
  AND num_ensemble IS NOT NULL
ORDER BY ens.num_ensemble, numero_contenant;

-- ne récupère que les cercueils (90)
CREATE VIEW sp_contenant_cercueil AS
SELECT *
FROM sp_contenant_funeraire
WHERE type_contenant LIKE 'cercueil';
-- ne récupère que les linceuls (61)
CREATE VIEW sp_contenant_linceul AS
SELECT *
FROM sp_contenant_funeraire
WHERE type_contenant LIKE 'linceul';

-- compte le nombre de contenants par ensemble (939 214)
SELECT
  ue.numero AS "num_ensemble",
  count(sp_contenant_funeraire.num_ensemble) as nbr
FROM app.ue
LEFT JOIN sp_contenant_funeraire ON ue.numero = sp_contenant_funeraire.num_ensemble
WHERE 
  ue.id_type = 40 
  AND ue.id_nature = 210 
  AND ue.id_projet = 155 
GROUP BY ue.numero
ORDER BY nbr DESC
  
  
/*
sélection des comblements (111)
*/

CREATE VIEW sp_comblement AS
SELECT
  ens.num_ensemble,
  a.numero AS "numero_comblement",
  matgeol.matrice_comblement,
  lower(array_to_string(array_agg(mob_comblement.matiere_type || ' (' || mob_comblement.nbr || ')'), ', ')) AS mobilier_comblement
FROM app.ue AS "a"
-- jointure du numéro d'ensemble
LEFT JOIN (SELECT rs.ue1, ue.numero AS "num_ensemble"
FROM app.relationstratigraphique AS rs
JOIN app.ue ON rs.ue2 = ue.id
WHERE rs.id_relation = 45 AND ue.id_type = 40 AND ue.id_nature = 210 AND ue.id_projet = 155) AS ens ON ens.ue1 = a.id
-- join les matrices géologiques
LEFT JOIN (SELECT id_ue,
array_to_string(array_agg(
(SELECT valeur FROM app.liste WHERE liste.id = id_texture) || ' (' ||
(SELECT valeur FROM app.liste WHERE liste.id = id_munsell) || '), ' ||
(SELECT valeur FROM app.liste WHERE liste.id = id_homogeinite) || ',' ||
(SELECT valeur FROM app.liste WHERE liste.id = id_compacite)), '; ') AS matrice_comblement
FROM app.matrice_geologique 
GROUP BY id_ue) AS matgeol ON matgeol.id_ue = a.id
-- synthèse des mobiliers du comblement
LEFT JOIN (SELECT id_ue, 
(SELECT valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) AS matiere_type, COUNT(nombre_elements) AS nbr FROM app.mobilier GROUP BY id_ue, id_matiere_type) AS mob_comblement ON mob_comblement.id_ue = a.numero
WHERE 
  a.id_nature = 192 
  and a.id_interpretation = 1841 
  and a.id_projet = 155
GROUP BY ens.num_ensemble, a.numero, matgeol.matrice_comblement


-- vue rassemblant les positions du crâne, des mains et des pieds
CREATE VIEW position_membres AS
WITH ps2 AS (WITH position_squelette AS (
SELECT
  mobilier.id_ue,
  mobilier.id,
  crane.position_crane,
  main.position_main,
  pied.position_pied
FROM app.mobilier
-- join la position du crane
LEFT JOIN (
  SELECT DISTINCT id, 'crâne ' || (SELECT valeur FROM app.liste WHERE liste.id = id_position_in_situ_os) AS position_crane
  FROM app.manthropologie WHERE id_region_anatomique = 1136 AND id_os_principal IS NULL AND id_position_in_situ_os IS NOT NULL) AS crane ON crane.id = mobilier.id
-- join la position des mains
LEFT JOIN (
  SELECT DISTINCT id, 
  'main ' || (SELECT valeur FROM app.liste WHERE liste.id = id_lateralisation) || ' ' || (SELECT valeur FROM app.liste WHERE liste.id = id_position_in_situ_os) AS position_main
  FROM app.manthropologie
  WHERE id_region_anatomique = 1137 AND id_os_principal = 1207 AND id_position_in_situ_os IS NOT NULL
) AS main ON main.id = mobilier.id
-- join la position des pieds
LEFT JOIN (
  SELECT DISTINCT id, 
   'pied ' || (SELECT valeur FROM app.liste WHERE liste.id = id_lateralisation) || ' (effet de paroi : ' || ' ' || 
   (SELECT valeur FROM app.liste WHERE liste.id = id_effet_paroi_pied) || ')' AS position_pied
  FROM app.manthropologie
  WHERE id_region_anatomique = 1135 AND id_os_principal = 1213) AS pied ON pied.id = mobilier.id
WHERE 
  id_matiere = 292
  AND id_matiere_type = 1832
)
SELECT 
  rlmob.mobilier1,
  ps.position_crane AS position_membres
FROM position_squelette AS ps
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON ps.id = rlmob.mobilier2
WHERE position_crane IS NOT NULL 
UNION
SELECT 
  rlmob.mobilier1,
  ps.position_main AS position_membres
FROM position_squelette AS ps
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON ps.id = rlmob.mobilier2
WHERE position_main IS NOT NULL 
UNION
SELECT 
  rlmob.mobilier1,
  ps.position_pied AS position_membres
FROM position_squelette AS ps
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON ps.id = rlmob.mobilier2
WHERE position_pied IS NOT NULL)
SELECT 
  ps2.mobilier1,
  array_to_string(array_agg(ps2.position_membres ORDER BY ps2.position_membres), ', ') AS position_membres
FROM ps2
GROUP BY ps2.mobilier1;

-- vue rassemblant les pathologies
CREATE VIEW sq_pathologie AS
WITH source3 AS (
WITH source2 AS (
WITH source AS (
SELECT DISTINCT
  rlmob.mobilier1 AS squelette,
  (SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_os_principal) AS os_principal,
  id_type_pathologie,
  (SELECT valeur FROM app.liste WHERE liste.id = pathologie.id_type_pathologie_observe) || ' (' ||
  (SELECT valeur FROM app.liste WHERE liste.id = pathologie.id_codification) || ')' AS patho
FROM app.pathologie
LEFT JOIN app.manthropologie ON pathologie.id_mobilier = manthropologie.id
LEFT JOIN app.mobilier ON mobilier.id = pathologie.id_mobilier
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON id_mobilier = rlmob.mobilier2
WHERE ue.id_projet = 155 AND rlmob.mobilier1 IS NOT NULL
ORDER BY squelette, id_type_pathologie)
SELECT 
  squelette,
  os_principal,
  --id_type_pathologie,
  array_to_string(array_agg(patho), ', ') as patho2
FROM source
GROUP BY  squelette, os_principal
ORDER BY squelette, os_principal)
SELECT
  squelette,
  array_to_string(array_agg(patho2), ', ') as patho3
FROM source2
WHERE os_principal IS NULL
GROUP BY squelette
UNION
SELECT
  squelette,
  array_to_string(array_agg(os_principal || ' - ' || patho2), ', ') as patho3
FROM source2
WHERE os_principal IS NOT NULL
GROUP BY squelette)
SELECT DISTINCT
  squelette,
  array_to_string(array_agg(patho3), ', ') AS pathologie
FROM source3
GROUP BY squelette
ORDER BY squelette;

-- vue rasseùblant les caractères discrets
CREATE VIEW sq_caracteres AS
WITH source2 AS (
WITH source AS (
SELECT DISTINCT
  rlmob.mobilier1 AS squelette,
  (SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_region_anatomique) AS region_anatomique,
  (SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_os_principal) AS os_principal,
  (SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_caracteres_discrets) AS caracteres_discrets
FROM app.manthropologie
LEFT JOIN app.mobilier ON mobilier.id = manthropologie.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON manthropologie.id = rlmob.mobilier2
WHERE 
  ue.id_projet = 155 
  AND rlmob.mobilier1 IS NOT NULL
  AND id_caracteres_discrets IS NOT NULL
ORDER BY squelette, os_principal)
SELECT
  squelette,
  lower(region_anatomique) || ' - ' || caracteres_discrets AS caracteres_discrets
FROM source
WHERE os_principal IS NULL
UNION
SELECT
  squelette,
  os_principal || ' - ' || caracteres_discrets AS caracteres_discrets
FROM source
WHERE os_principal IS NOT NULL)
SELECT
  squelette,
  array_to_string(array_agg(caracteres_discrets), ', ') AS caracteres_discrets
FROM source2
GROUP BY squelette
ORDER BY squelette;

-- vue rassemblant les infos de symétrie
DROP VIEW sq_symetrie;
CREATE VIEW sq_symetrie AS
WITH source AS (SELECT DISTINCT
   rlmob.mobilier1 AS squelette,
   lower((SELECT valeur FROM app.liste WHERE liste.id = manthropologie.id_region_anatomique)) || ' ' ||
   (SELECT valeur FROM app.liste WHERE liste.id = id_symetrie) AS symetrie
FROM app.manthropologie
-- indique le squelette de rattachement
LEFT JOIN (SELECT * FROM app.relationintermobilier WHERE id_relation = 51) AS rlmob ON manthropologie.id = rlmob.mobilier2
WHERE rlmob.mobilier1 IS NOT NULL AND id_symetrie IS NOT NULL
ORDER BY squelette)
SELECT
  squelette,
  array_to_string(array_agg(symetrie), ', ') AS symetrie
from source
GROUP BY squelette;

CREATE VIEW sp_squelette AS
SELECT DISTINCT
  ens.ue2 AS "id_ensemble",
  ue.numero AS "num_individu",
  mobilier.commentaire,
  (SELECT valeur FROM app.liste WHERE liste.id = id_orientation_squelette) AS orientation,
  (SELECT valeur FROM app.liste WHERE liste.id = id_espace_inhumation) AS espace_decomposition,
  (SELECT valeur FROM app.liste WHERE liste.id = id_etat_conservation) AS etat_conservation,
  'coupé par ' || rl.perturbation AS perturbation,
  (SELECT valeur FROM app.liste WHERE liste.id = id_position_generale_corps) AS position_generale_corps,
  (SELECT valeur FROM app.liste WHERE liste.id = id_face_apparition) AS face_apparition,
  'sexe' ||' - ' || (SELECT valeur FROM app.liste WHERE liste.id = id_sexe) AS sexe,
  (SELECT valeur FROM app.liste WHERE liste.id = id_codification)  AS codification,
  'âge' ||' - ' || (SELECT valeur FROM app.liste WHERE liste.id = id_age) AS age,
  COALESCE(msa.stature, 'indéterminée') AS stature,
  sq_pathologie.pathologie,
  sq_caracteres.caracteres_discrets,
  sq_symetrie.symetrie,
  ps.position_membres,
  (SELECT valeur FROM app.liste WHERE liste.id = id_type_inhumation) AS type_inhumation,
  (SELECT valeur FROM app.liste WHERE liste.id = id_etat_sepulture) AS etat_sepulture
FROM app.mobilier
-- joint les champs spécialistes
LEFT JOIN app.manthropologie ON mobilier.id = manthropologie.id
-- joint les ues coupés par le sque
LEFT JOIN (SELECT ue1, array_to_string(array_agg(ue2 ORDER BY ue2), '; ') AS perturbation 
FROM app.relationstratigraphique WHERE id_relation = 44 GROUP BY ue1) AS rl ON rl.ue1 = mobilier.id_ue
-- joint l'ue de l'individu
LEFT JOIN app.ue ON ue.id = mobilier.id_ue
-- joint les informations sur la position des membres
LEFT JOIN position_membres AS ps ON ps.mobilier1 = mobilier.id
-- indique la stature
LEFT JOIN (
  SELECT id_mobilier, CAST(MAX(valeur::int) AS TEXT) AS stature FROM app.mesureanthropologique
  WHERE id_type_mesure = 581 GROUP BY id_mobilier) AS msa ON msa.id_mobilier = mobilier.id
-- joit les pathologies
LEFT JOIN sq_pathologie ON sq_pathologie.squelette = mobilier.id
-- joint les caractères discrets
LEFT JOIN sq_caracteres ON sq_caracteres.squelette = mobilier.id
-- joint les symétries
LEFT JOIN sq_symetrie ON sq_symetrie.squelette = mobilier.id
-- jointure du numéro de contenant
LEFT JOIN (
  SELECT rs.ue1, rs.ue2 
  FROM app.relationstratigraphique AS rs
  JOIN app.ue ON rs.ue2 = ue.id
  WHERE rs.id_relation = 45 AND ue.id_type = 40 AND ue.id_nature = 210 AND ue.id_projet = 155) AS ens ON ens.ue1 = ue.id
WHERE 
  id_matiere = 292
  AND id_matiere_type = 1832
  AND id_objet_ou_lot = 1122
  AND ue.id_projet = 155
  AND id_type_inhumation IS NOT NULL
ORDER BY id_ensemble ASC;

/*
REVOIR mobilier du comblement (autre qu'anthropo)
rajouter TISSUS dans la liste des termes mobilier précision
  (SELECT valeur FROM app.liste WHERE liste.id = ) || ', ' ||
*/

/*
Sélection des ensembles sépultures
*/

CREATE VIEW sp_ue AS
SELECT DISTINCT
  ue.id AS "id_ensemble",
  ue.numero AS "num_ensemble",
  sp_creusement.numero AS "num_creusement",
  sp_creusement.emplacement AS "emplacement_creusement",
  sp_creusement.forme_fosse AS "forme_creusement",
  sp_creusement.dimensions AS "dimensions_creusement",
  sp_contenant_cercueil.numero_contenant AS "num_cercueil",
  sp_contenant_cercueil.type_contenant AS "type_cercueil",
  sp_contenant_cercueil.clous_contenant AS "clous_cercueil",
  sp_contenant_cercueil.bois_contenant AS "bois_cercueil",
  sp_contenant_linceul.numero_contenant AS "num_linceul",
  sp_contenant_linceul.type_contenant AS "type_linceul",
  sp_contenant_linceul.epingles_contenant AS "epingles_linceul",
  sp_contenant_linceul.tissu_contenant AS "tissu_linceul",
  sp_comblement.numero_comblement,
  sp_comblement.matrice_comblement,
  sp_comblement.mobilier_comblement
FROM app.ue
LEFT JOIN sp_creusement ON ue.numero = sp_creusement.num_ensemble
LEFT JOIN sp_contenant_cercueil ON ue.numero = sp_contenant_cercueil.num_ensemble
LEFT JOIN sp_contenant_linceul ON ue.numero = sp_contenant_linceul.num_ensemble
LEFT JOIN sp_comblement ON ue.numero = sp_comblement.num_ensemble
WHERE 
  ue.id_type = 40 
  AND ue.id_nature = 210 
  AND ue.id_projet = 155
ORDER BY ue.numero ASC;
  
CREATE VIEW sp_sepultures AS
SELECT DISTINCT
  sp_ue.num_ensemble,
  sp_ue.num_creusement,
  sp_ue.forme_creusement,
  sp_ue.emplacement_creusement,
  sp_ue.dimensions_creusement,
  sp_ue.num_cercueil,
  sp_ue.type_cercueil,
  sp_ue.clous_cercueil,
  sp_ue.bois_cercueil,
  sp_ue.num_linceul,
  sp_ue.type_linceul,
  sp_ue.epingles_linceul,
  sp_ue.tissu_linceul,
  sp_ue.numero_comblement,
  sp_ue.matrice_comblement,
  sp_ue.mobilier_comblement,
  sp_squelette.num_individu,
  sp_squelette.type_inhumation,
  sp_squelette.etat_sepulture,
  sp_squelette.orientation,
  sp_squelette.espace_decomposition,
  sp_squelette.etat_conservation,
  sp_squelette.perturbation,
  sp_squelette.position_generale_corps,
  sp_squelette.face_apparition,
  sp_squelette.sexe,
  sp_squelette.codification,
  sp_squelette.age,
  sp_squelette.stature,
  sp_squelette.pathologie,
  sp_squelette.caracteres_discrets,
  sp_squelette.symetrie,
  sp_squelette.position_membres,
  sp_squelette.commentaire
FROM sp_ue
LEFT JOIN sp_squelette ON sp_ue.id_ensemble = sp_squelette.id_ensemble
WHERE sp_ue.num_ensemble != 214 AND sp_ue.num_ensemble !=  939
ORDER BY sp_ue.num_ensemble, sp_squelette.num_individu;