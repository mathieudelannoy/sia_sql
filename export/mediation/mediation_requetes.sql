-- total des interventions toutes années confondues
CREATE VIEW fc_cd62.mediation_total_intervention AS
WITH source AS (
SELECT
  id_etab,
  COUNT(id_etab) AS nbr
FROM fc_cd62.mediation_compta
GROUP BY id_etab)

SELECT
 "type",
 nom_commune,
 nom,
 nbr,
 communes_point.geom
FROM source AS a
JOIN fc_cd62.mediation_etablissement AS b ON a.id_etab = b.id
JOIN fc_admin.communes_point ON insee_com = b.code_insee
ORDER BY nbr DESC;


-- total des interventions toutes années confondues par commune
CREATE VIEW fc_cd62.mediation_total_intervention_commune AS

WITH 
source AS (
SELECT
  id_etab,
  COUNT(id_etab) AS nbr
FROM fc_cd62.mediation_compta
GROUP BY id_etab),

source2 AS (
SELECT
 code_insee,
 SUM(nbr) AS nbr
FROM source AS a
JOIN fc_cd62.mediation_etablissement AS b ON a.id_etab = b.id
GROUP BY code_insee
ORDER BY code_insee DESC)

SELECT
  communes_point.nom_com,
  source2.nbr,
  communes_point.geom
FROM source2
JOIN fc_admin.communes_point ON insee_com = source2.code_insee;

-- total par type d'établissements
CREATE VIEW fc_cd62.mediation_total_par_type_etablissement AS
WITH source AS (
SELECT
  id_etab,
  COUNT(id_etab) AS nbr
FROM fc_cd62.mediation_compta
GROUP BY id_etab)

SELECT
 "type",
 SUM(nbr) AS nbr
FROM source AS a
JOIN fc_cd62.mediation_etablissement AS b ON a.id_etab = b.id
GROUP BY "type"
ORDER BY nbr DESC;

-- total par type d'établissements par an
CREATE VIEW fc_cd62.mediation_total_par_type_etablissement_annee AS
WITH source AS (
SELECT
  id_etab,
  COUNT(id_etab) AS nbr
FROM fc_cd62.mediation_compta
GROUP BY id_etab)

SELECT
  b."type",
  a.annee_debut,
  COUNT(a.id_etab) AS nbr
FROM fc_cd62.mediation_compta AS "a"
JOIN fc_cd62.mediation_etablissement AS "b" ON a.id_etab = b.id
GROUP BY b."type", annee_debut
ORDER BY annee_debut, "type";

-- total par type d'animations
CREATE VIEW fc_cd62.mediation_total_par_module AS
SELECT
  a.module,
  COUNT(a.id_etab) AS nbr
FROM fc_cd62.mediation_compta AS "a"
GROUP BY a.module
ORDER BY a.module;

-- total par type d'animations par an
CREATE VIEW fc_cd62.mediation_total_par_module_annee AS
SELECT
  a.module,
  a.annee_debut,
  COUNT(a.id_etab) AS nbr
FROM fc_cd62.mediation_compta AS "a"
GROUP BY a.module, a.annee_debut
ORDER BY a.module, a.annee_debut;

-- totalité des interventions
CREATE VIEW fc_cd62.mediation_intervention AS
SELECT
 a.id,
 b."type" AS type_etablissement,
 b.nom_commune,
 b.nom,
 a.module,
 a.annee_debut,
 c.geom
FROM fc_cd62.mediation_compta AS a
JOIN fc_cd62.mediation_etablissement AS b ON a.id_etab = b.id
JOIN fc_admin.communes_point AS c ON c.insee_com = b.code_insee
ORDER BY a.annee_debut, a.module;