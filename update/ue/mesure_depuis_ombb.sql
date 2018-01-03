/*
Création d'un vue joignant les géométries des UE présentes dans le SIApour les joindres spatialement avec la table résultant de l'algo OMBB de QGIS :
Le but est d'avoir des longeurs/largeurs estimées sans intervention manuelle, une version de PostGIS avec SFCGAL faciliterait les choses avec des fonctions telles que ST_ApproximateMedialAxis

La vue résultante permet de rajouter directement les mesures aux UE en insérant les valeurs dans la table app.mesure
*/

CREATE VIEW public."temp_jointure_ombb" AS

WITH

-- filtre les UE appartenant au projet ciblé et en écartant les types d'UE indésirables
source_ue AS (
SELECT 
  id, numero,
  --(SELECT valeur FROM app.liste WHERE liste.id = id_type) AS type_ue,
  CAST(St_Area(ST_Transform(the_geom, 2154)) AS NUMERIC(7,2)) AS surface,
  ST_Transform(the_geom, 2154) AS geom
FROM app.ue
WHERE
  ue.the_geom IS NOT NULL
  AND id_projet = 848
  AND (
    commentaire != 'obus' 
	OR commentaire = 'VRD' 
	OR commentaire IS NULL)
  AND (id_type = 38 OR id_type = 41 OR id_type = 40)
),

-- joint les données OMBBen utilisant son centroide et celui de la box OMBB le plus proche
-- la distinction permet de réduire le risque d'établir des relations erronées

join_ombb_small AS (
SELECT 
  a.id,
  a.numero,
  a.surface,
  ST_Area(b.geom) AS surface_ombb,
  CAST(b.width AS NUMERIC(7,2)) AS largeur,
  CAST(b.height AS NUMERIC(7,2)) AS longueur
FROM 
  source_ue AS "a",
  public.ombb AS "b"
WHERE 
  a.surface < 5
  AND St_Area(b.geom) < 10
  AND ST_Within(
    ST_Centroid(a.geom),
    ST_Buffer(ST_Centroid(b.geom), 0.4)
    )
ORDER BY a.numero
),

join_ombb_big AS (
SELECT 
  a.id,
  a.numero,
  a.surface,
  ST_Area(b.geom) AS surface_ombb,
  CAST(b.width AS NUMERIC(7,2)) AS largeur,
  CAST(b.height AS NUMERIC(7,2)) AS longueur
FROM 
  source_ue AS "a",
  public.ombb AS "b"
WHERE 
  a.surface > 5
  AND St_Area(b.geom) > 5
  AND ST_Within(
    ST_Centroid(a.geom),
    ST_Buffer(ST_Centroid(b.geom), 2)
    )
ORDER BY a.numero
)

SELECT *
FROM join_ombb_small
UNION
SELECT *
FROM join_ombb_big
ORDER BY numero