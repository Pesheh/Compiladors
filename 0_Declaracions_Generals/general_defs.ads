package general_defs is
   max_id: constant integer:=997;
   max_str: constant integer:=499;
   type id is new integer range 0..max_id;
   type id_str is new integer range 0..max_str;
   null_id: constant id:=0;
   null_ids: constant id_str:=0;
   type a_string is access String;
end general_defs;
