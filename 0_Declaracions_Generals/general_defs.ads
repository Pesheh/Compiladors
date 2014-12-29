package general_defs is
    pragma pure;

    max_id: constant integer:=997;
    max_str: constant integer:=499;

    type id_nom is new integer range 0..max_id;
    type id_str is new integer range 0..max_str;
   
    null_id: constant id_nom:=0;

end general_defs;
