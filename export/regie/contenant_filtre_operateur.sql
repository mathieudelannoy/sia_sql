-- export des contenants liés aux projets d'un opérateur

SELECT
  contenant.id,
  contenant.numero,
  (SELECT liste.valeur FROM app.liste WHERE liste.id = contenant.id_matiere_contenant) AS contenant_matiere,
  projet.intitule,
  array_to_string(array_agg(DISTINCT (SELECT liste.valeur FROM app.liste WHERE liste.id = mobilier.id_matiere_type) 
    || ' : ' || regexp_replace(mobilier.commentaire, '\r|\n', ' - ', 'g')), ', ') AS mobiliers
FROM app.contenant
LEFT JOIN app.contenant_mobilier ON contenant.id = contenant_mobilier.contenant_id
LEFT JOIN app.mobilier ON contenant_mobilier.mobilier_id = mobilier.id
LEFT JOIN app.ue ON mobilier.id_ue = ue.id
LEFT JOIN app_addons.projet_operateur ON ue.id_projet = projet_operateur.projet_id
LEFT JOIN app.projet ON ue.id_projet = projet.id
WHERE projet_operateur.organisme_id = 2
GROUP BY contenant.id, contenant.numero, projet.intitule, contenant_matiere
ORDER BY projet.intitule, contenant.numero;