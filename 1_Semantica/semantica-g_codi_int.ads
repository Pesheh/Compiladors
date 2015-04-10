with decls; use decls;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tsimbols; use decls.d_tsimbols;

package semantica.g_codi_int is
  
  type etiqueta is private;
  type ocupacio is private;

  procedure g_codi_int;

  -- ha de formar part de l'especificacio?
  function nova_var return num_var;
  function nova_var(np: num_proc; ocup: ocupacio; desp: despl) return num_var;
  -- variables constants
  function nova_var_const(val: valor; tsb: tipus_subjacent) return num_var;
  function nou_proc return num_proc;
  function nova_etiq return etiqueta;

private
  

  type etiqueta is new num_var;
  type ocupacio is new natural;

  esvar: constant boolean:=true;
  type e_tvar (e: boolean) is 
    record
      case e is
        when esvar=>
          np: num_proc;
          ocup: ocupacio;
          desp: despl;
        when not esvar=>
          val: valor;
          tsb: tipus_subjacent;
      end case;
    end record;

  -- Es l'unica manera de poder tenir un array d'elements de tamany "variable"
  type pe_tvar is access e_tvar;

  type e_tproc is
    record
      e: etiqueta;
      prof: profunditat;
      ocup_vl: ocupacio;
      nparam: natural;
    end record;

  type taula_variables is array (num_var) of pe_tvar;
  type taula_procediments is array (num_proc) of e_tproc;

  -- Rang temporal 0..200
  type num_instr is new natural range 0..200;

  type tinstruccio is (
    cp,
    cp_idx,
    cons_idx,
    sum,
    res,
    mul,
    div,
    modul,
    neg,
    op_not,
    op_and,
    op_or,
    etiq,
    go_to,
    gt,
    ge,
    eq,
    neq,
    le,
    lt,
    pmb,
    rtn,
    call,
    params,
    paramc
  );

  -- Els num_var...
  type instruccio is
    record
      t: tinstruccio;
      a: num_var;
      b: num_var;
      c: num_var;
    end record;

  type taula_instruccions is array (num_instr) of instruccio;

end semantica.g_codi_int;
