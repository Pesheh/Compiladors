package decls.d_descripcio is
  type tipus_subjacent is (
    tsb_bool,
    tsb_car,
    tsb_ent,
    tsb_arr,
    tsb_rec,
    tsb_nul
  );

  type descr_tipus(tsb: tipus_subjacent:= tsb_nul) is
    record
      ocup: despl;
      case tsb is
        when tsb_bool | tsb_car | tsb_ent  =>
          linf,lsup: valor;
        when tsb_arr             =>
          tcomp: id_nom; -- tipus dels components de l'arry
          b: valor; -- constant del compilador
        when tsb_rec | tsb_nul         =>
          null;
        end case;
      end record;

    type tipus_descr is (
      dnula,
      dvar,
      dconst,
      dindx,
      dtipus,
      dcamp,
      dproc,
      dargc
    );

    type descripcio(td: tipus_descr:= dnula) is
      record
        case td is
          when dnula  =>
            null;
          when dvar   =>
            tv: id_nom; -- tipus de la variable
            nv: num_var; -- gc
          when dconst =>
            tc: id_nom; -- tipus de la constant
            vc: valor; -- valor de la constant
          when dindx  =>
            tind: id_nom;
          when dtipus =>
            dt: descr_tipus;
          when dcamp  =>
            tcmp: id_nom; -- tipus del camp
            dcmp: despl; -- gc
          when dproc  =>
            np: num_proc; -- gc
          when dargc  =>
            ta: id_nom; -- tipus de l'argument
            na: num_var; -- gc
        end case;
      end record;
end decls.d_descripcio;
