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

  -- Els rangs estan per permetre indexat la TV i TP amb els respectius indexos. Si per el contrari emprassim naturals
  -- el compilador de x86_64 fa un pataplaf ben gros ja que el tamany maxim d'arrays estatics permes es 2GB i be...
  -- http://stackoverflow.com/questions/10486116/what-does-this-gcc-error-relocation-truncated-to-fit-mean
  type num_var is new natural range 0..501;
  type num_proc is new natural range 0..250;
  nil_nv: constant num_var:= 501;

--private
  max_id: constant integer:=997;
  max_str: constant integer:=499;

  type id_nom is new integer range 0..max_id;
  type id_str is new integer range 0..max_str;

  null_id: constant id_nom:=0;

end decls;
