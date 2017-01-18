CREATE TABLE public.nid (
  id integer,
  prout text);
  
INSERT INTO public.nid VALUES (1, 'a, b , c');

SELECT id, UNNEST(string_to_array(prout, ', '))
FROM public.nid

SELECT 
  id, 
  (k).key as year, 
  (k).value as value 
FROM
  (SELECT j->> 'id' as id, json_each_text(j) as k
    FROM 
	(SELECT row_to_json(tbl) as j FROM tbl)as q)
    as r
WHERE 
  (k).key <> 'id';