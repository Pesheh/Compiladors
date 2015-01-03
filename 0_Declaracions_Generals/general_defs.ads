package general_defs is
    pragma pure;

    max_id: constant integer:=997;
    max_str: constant integer:=499;

    type id_nom is new integer range 0..max_id;
    type id_str is new integer range 0..max_str;
   
    null_id: constant id_nom:=0;

    type despl is natural;

    type tipus_desc is (dnula,dvar,dconst,dindx,dtipus,dcamp,dproc,dargc);
    type tipus_subj is (tsb_nul, tsb_bool, tsb_car, tsb_ent, tsb_arr, tsb_rec);
    type desc_tipus(tsb: tipus_subj:= tsb_nul) is
        record
            ocup: despl;
            case tsb is
                when tsb_bool, tsb_car, tsb_ent => null;
                when tsb_arr => null;
                when tsb_rec => null;
                when tsb_nul => null;
            end case;
        end record
    type descripcio(td: tipus_desc:= dnula) is
        record
            case td is
                when dnula  => null;
                when dvar   => null;
                when dconst => null;
                when dindx  => null;
                when dtipus => dt: desc_tipus;
                when dcamp  => null;
                when dproc  => null;
                when dargc  => null;
            end case;
        end record;
end general_defs;
