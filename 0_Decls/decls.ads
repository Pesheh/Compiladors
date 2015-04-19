package decls is
  pragma pure;

  --type id_nom is private;
  --type id_str is private;
	
  --type valor is private;
  --type despl is private;
	
  type valor is new integer;
  type despl is new natural;
  
  type tidx is (
    positiu,
    negatiu
  );


--private
  max_id: constant integer:=997;
  max_str: constant integer:=499;

  type id_nom is new integer range 0..max_id;
  type id_str is new integer range 0..max_str;

  null_id: constant id_nom:=0;

  -- El rang de Num_var HA de ser major o igual al de
  -- num_proc, sino tots els castings fets al codi 
  -- poden fallar.
  -- Es llogic pero que hi hagi mes variables que procediments
  -- a un codi minimament normal i, per tant, l'actitut
  -- adoptada no es descabellada.
  type num_var is new natural range 0..max_id;
  type num_proc is new natural range 0..(max_id/2);
  
  null_nv: constant num_var:= num_var'Last;

end decls;
