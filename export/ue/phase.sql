-- export les UE avec informations sur la phase associée

SELECT DISTINCT
  ue.numero AS "UE", 
  (SELECT valeur FROM app.liste WHERE liste.id = ue.id_type) AS "Type", 
  ue.tpq AS "TPQ", 
  ue.taq AS "TAQ",
  COALESCE(phase.nom, NULL) AS "Phase", 
  COALESCE(phase.tpq, NULL) AS "Phase TPQ", 
  COALESCE(phase.taq, NULL) AS "Phase TAQ"
FROM 
  app.ue
LEFT JOIN app.phase_ue on ue.id = phase_ue.id_ue
LEFT JOIN app.phase on phase.id = phase_ue.id_phase
WHERE
  ue.id_projet = 155
ORDER BY ue.numero ASC;

SELECT DISTINCT
  phase.nom, 
  phase.tpq, 
  phase.taq
FROM 
  app.ue, 
  app.phase, 
  app.phase_ue
WHERE 
  ue.id = phase_ue.id_ue AND
  phase.id = phase_ue.id_phase AND
  ue.id_projet = 187;