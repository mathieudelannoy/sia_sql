UPDATE  t1
  SET   email = 
        (   SELECT  email
            FROM    t2
            WHERE   t1.nom      = t2.nom
                AND t1.prenom   = t2.prenom
                AND t1.email    IS NULL
        )
WHERE   EXISTS 
        (   SELECT  NULL
            FROM    t2
            WHERE   t1.nom      = t2.nom
                AND t1.prenom   = t2.prenom
                AND t1.email    IS NULL
        )
;