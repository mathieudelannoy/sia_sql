-----------
-- M-A-J --
-----------

-- reporte les mesures prédéfinies dans les mesures saisies
UPDATE app.contenant SET longueur = (SELECT valeur::numeric FROM app.liste WHERE liste.id = id_longueur_predefinie) WHERE contenant.longueur IS NULL;
UPDATE app.contenant SET largeur = (SELECT valeur::numeric FROM app.liste WHERE liste.id = id_largeur_predefinie) WHERE contenant.largeur IS NULL;
UPDATE app.contenant SET hauteur = (SELECT valeur::numeric FROM app.liste WHERE liste.id = id_hauteur_predefinie) WHERE contenant.hauteur IS NULL;

-- calcule le volume
UPDATE app.contenant 
SET volume = contenant.longueur * contenant.largeur * contenant.hauteur 
WHERE contenant.volume IS NULL;

UPDATE app.contenant SET volume = contenant.longueur * contenant.largeur * contenant.hauteur WHERE contenant.id = 2437;

-- remplit le volume pour les seaux
UPDATE app.contenant SET volume = 11000 WHERE contenant.id_type_contenant = 711 AND contenant.volume IS NULL;

SELECT count(id) FROM app.contenant WHERE volume IS NULL;

SELECT * FROM stats.contenant_mobilier WHERE volume_m3 IS NULL;