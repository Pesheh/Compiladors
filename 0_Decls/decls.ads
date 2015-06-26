package decls is
  pragma pure;

  DEBUG: constant boolean:= false;

  type valor is new integer;
  type despl is new integer;

  ocup_ent: constant despl:= 4; -- 4Bytes x enter
  ocup_char: constant despl:= ocup_ent; -- 4Bytes x char (simplificacio)
  ocup_bool: constant despl:= ocup_char; -- 4Bytes x bool (simplificacio).
  -- Aquests 2 serien els que teoricament hauriem d'emprar però per simplicitat no ho feim
  ocup_char_compressed: constant despl:= 1; -- 1Byte x char
  ocup_bool_compressed: constant despl:= ocup_char_compressed; -- 1Byte x boolean

  type tidx is (
    positiu,
    negatiu
  );


  max_id: constant integer:=997;
  max_str: constant integer:=499;

  type id_nom is new natural range 0..max_id;
  type id_str is new natural range 0..max_str;

  null_id: constant id_nom:= id_nom'First;


  max_var: constant integer:= 1023;
  max_proc: constant integer:= 511;
  max_etiq: constant integer:= 1023;

  type num_var is new natural range 0..max_var;
  type num_proc is new natural range 0..max_proc;
  type num_etiq is new natural range 0..max_etiq;

  null_nv: constant num_var:= num_var'First;
  null_np: constant num_proc:= num_proc'First;
  null_ne: constant num_etiq:= num_etiq'First;

end decls;
