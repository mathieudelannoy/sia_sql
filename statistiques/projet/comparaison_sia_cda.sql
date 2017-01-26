-- comparaison des opérations présentes dans le SIA et dans la base contexte

CREATE VIEW fc_contexte.comparaison_sia_cda AS 
SELECT
  a.intitule,
  a.code_oa,
  b.id AS code_cda
FROM fc_contexte.emprise_cd62 AS a
LEFT JOIN fc_contexte.contexte_attributs AS b ON a.code_oa -150000 = b.code_patriarche