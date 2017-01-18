TL;DR : clés primaires manquantes et index nécessaires

En décembre, une courte [analyse](https://gist.github.com/Jean-Roc/bc241c29dbceb0d29039) de la fréquence d'utilisation des index lors de la récupération de lignes montre un manque d'index dans le schéma, plusieurs tables sont en-dessous de 90% d'utilisation et certaines carrément en-dessous de 10% (app.mesure était à 4% avec 9628 enregistrements). Si pour certaines un seq scan sera souvent plus rapide qu'un parcours d'index (p. ex. app.chronologie), d'autres en pâtissent (app.mesure, app.section)

Il manque les index de type btree :
* sur les clés étrangères (fkey), la contrainte de référence ne crée pas automatiquement d'index. Ainsi si la fkey n'est pas également la pkey de sa table, aucun index ne sera utilisé pour les jointures (ex. contenant_mobilier).
* sur des colonnes multiples
* sur les colonnes affichées suite à une opération spatiale

Ce qu'il faudrait faire :
* créer un index sur les colonnes fkey (sauf celles référant app.liste vu que c'est l'appli cliente qui bosse) ([SQL](https://gist.github.com/Jean-Roc/4e48affa94716443a260))
* créer une contrainte pkey sur les colonnes des tables pivots des relations N-N (ce qui avait été fait pour app.projet_individu) 
([SQL](https://gist.github.com/Jean-Roc/a8e8a92dcbc9675b103e))

J'ai fait le choix d'opérer l'essai sur le serveur de production car il s'agit d'ajouts sans impact sur l'appli, c'est le seul moyen de vérifier dans les faits quels index sont utilisés.

Le schéma *maintenance* contient une série de vue permettant de juger du taux d'utilisation des index. L'impact observable reflète nos opérations en cours, des indexs sont pour l'instant peu utilisés car leurs tables n'ont pas encore été utilisées depuis leur déployement.

On pourrait pousser plus loin en logguant les requêtes générées par l'application pour retenir les plus lentes et voir où d'autres index seraient les plus pertinents. En tout cas, le bénéfice est palpable sur des tables comme *contenant_mobilier*.

Ce ticket ne propose pas d'intégration, j'attend que nos opérations couvrent tout le spectre d'utilisation du sia pour en faire le bilan.
