-- liste des opérations par responsable
CREATE VIEW stats.projet_responsables_liste
SELECT
  a.intitule,
  c.nom || ' ' || c.prenom AS RO
FROM app.projet AS a
LEFT JOIN app.projet_individu AS b ON a.id = b.id_projet
LEFT JOIN app.individu AS c ON b.id_individu = c.id
WHERE b.id_fonction = 20
ORDER BY RO;

-- décompte des projets par responsable
CREATE VIEW stats.projet_responsables_total AS
SELECT
  c.nom || ' ' || c.prenom AS RO,
  COUNT(a.id) AS nbr
FROM app.projet AS a
LEFT JOIN app.projet_individu AS b ON a.id = b.id_projet
LEFT JOIN app.individu AS c ON b.id_individu = c.id
WHERE b.id_fonction = 20
GROUP BY RO
ORDER BY nbr DESC;