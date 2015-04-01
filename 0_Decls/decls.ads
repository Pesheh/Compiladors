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
  type num_var is new natural; -- sols per compilar
  type num_proc is new natural; -- sols per compilar

--private
  max_id: constant integer:=997;
  max_str: constant integer:=499;

  type id_nom is new integer range 0..max_id;
  type id_str is new integer range 0..max_str;

  null_id: constant id_nom:=0;


--type tidx is (
--  positiu,
--  negatiu
--);

end decls;
