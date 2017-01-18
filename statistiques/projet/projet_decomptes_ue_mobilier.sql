-- totaux des UE et mobiliers par projet
CREATE VIEW stats.projet_total_ue_mobilier AS
SELECT
  projet.intitule,
  ue.ue_total,
  mobilier.mobilier_total
FROM (SELECT id, intitule FROM app.projet WHERE projet.intitule NOT LIKE 'DISPONIBLE%' OR projet.intitule NOT LIKE 'intitu%' OR id != 7) AS "projet"
LEFT JOIN (SELECT count(id) AS ue_total, id_projet FROM app.ue GROUP BY id_projet) AS "ue" ON projet.id = ue.id_projet
LEFT JOIN (SELECT count(mobilier.id) AS mobilier_total, ue.id_projet FROM app.mobilier
JOIN app.ue ON mobilier.id_ue = ue.id GROUP BY ue.id_projet) AS "mobilier" ON projet.id = mobilier.id_projet
ORDER BY ue_total DESC;
