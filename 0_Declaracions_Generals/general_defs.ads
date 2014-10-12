package general_defs is
   max_id: constant Natural:=997;
   max_str: constant Natural:=499;
   type id is new Natural range 0..max_id;
   type id_str is new Natural range 0..max_str;
   null_id: constant id:=0;
   null_ids: constant id_str:=0;
end general_defs;
