package general_defs is
<<<<<<< HEAD
   max_id: constant integer:=997;
   max_str: constant integer:=499;
   type id is new integer range 0..max_id;
   type id_str is new integer range 0..max_str;
   null_id: constant id:=0;
   null_ids: constant id_str:=0;
   type a_string is access String;
=======
   max_id: constant Natural:=997;
   max_str: constant Natural:=499;
   type id is new Natural range 0..max_id;
   type id_str is new Natural range 0..max_str;
   null_id: constant id:=0;
   null_ids: constant id_str:=0;
>>>>>>> 08839528ab462bda7fa44b6f1dd97748b7d3ea72
end general_defs;
