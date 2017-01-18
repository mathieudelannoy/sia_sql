
REVOKE ALL ON DATABASE siacg62 FROM GROUP cda62_topo;

REVOKE ALL ON SCHEMA app FROM GROUP admin_sia_minimun;
REVOKE ALL ON ALL TABLES IN SCHEMA app FROM admin_sia_minimun;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA app FROM admin_sia_minimun;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA app FROM admin_sia_minimun;
REVOKE ALL ON ALL LANGUAGE IN SCHEMA app FROM admin_sia_minimun;

DROP OWNED BY admin_sia_minimun;

DROP ROLE admin_sia_minimun;

REASSIGN OWNED BY admin_sia_minimun TO postgres;

psql.exe --host localhost --port 5433 -U "jrmorreale" --dbname=siacg62


REVOKE ALL ON ALL FUNCTIONS IN SCHEMA fc_contexte FROM cda62_topo;

DROP ROLE cda62_topo;

REASSIGN OWNED BY cda62_topo TO cda62_topographe;

ALTER DEFAULT PRIVILEGES FOR ROLE cda62_topo IN SCHEMA fc_contexte 
	REVOKE ALL ON ALL SEQUENCES;
	
REVOKE ALL ON SCHEMA fc_cadastre FROM GROUP cg62_sig;

-- supprime les droits par défaut sur les tables d'un schéma
ALTER DEFAULT PRIVILEGES IN SCHEMA ed_topo
    REVOKE ALL ON TABLES
    FROM cda62_topo;

-- supprime les droits par défaut sur les tables d'un schéma
ALTER DEFAULT PRIVILEGES IN SCHEMA fc_contexte 
    REVOKE ALL ON SEQUENCES
    FROM cda62_topo;

REVOKE ALL ON SCHEMA fc_cadastre FROM GROUP cg62_sig;
REVOKE ALL ON ALL TABLES IN SCHEMA fc_cadastre FROM cg62_sig;