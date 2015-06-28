with Ada.Sequential_IO;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tsimbols; use decls.d_tsimbols;
with decls.d_tnoms; use decls.d_tnoms;

package decls.d_c3a is

  type discr_instruccio is (comu, proc, etiq);
  type instr_3a(d: discr_instruccio:= comu) is private;
  type instr_3a_bin is private;

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
    ieq_goto,
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
  type tproc is (std, comu);

  type tvariables is limited private;
  type tprocediments is limited private;


  procedure nova_var(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; ocup: in despl; t: out num_var);
  procedure nova_var_const(nv: in out num_var; tv: in out tvariables; val: in valor; tsb: in tipus_subjacent; t: out num_var);
  procedure nou_arg(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; offset: in despl; t: out num_var);
  procedure nou_proc(np: in out num_proc; tp: in out tprocediments; e: in num_etiq; prof: in profunditat; nparam: in natural; p: out num_proc);
  procedure nou_proc_std(np: in out num_proc; tp: in out tprocediments; id: in id_nom; prof: in profunditat; nparam: in natural; p: out num_proc);
  procedure nova_etiq (ne: in out num_etiq; e: out num_etiq);

  procedure act_proc_args(tp: in out tprocediments; np: in num_proc; nargs: in natural);


  -- Funcions de consulta i conversió

  function Value(t: in tinstruccio; a: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a,b: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a,b,c: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a: in num_etiq) return instr_3a;
  function Value(t: in tinstruccio; a: in num_etiq; b,c: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a: in num_proc) return instr_3a;

  function Imatge(i3a: in instr_3a; tv: in tvariables; tp: in tprocediments) return String;

  -- Conversió d'instrucció normal a instrucció binària (per guardar al fitxer)
  function To_i3a_bin(i3a: in instr_3a) return instr_3a_bin;
  function To_i3a(i3a_b: in instr_3a_bin) return instr_3a;

  -- Funcions per consultar els camps de les instruccions
  function consulta_tipus(i3a: in instr_3a) return tinstruccio;
  function consulta_arg_nv(i3a: in instr_3a) return num_var;
  function consulta_arg_np(i3a: in instr_3a) return num_proc;
  function consulta_arg_ne(i3a: in instr_3a) return num_etiq;
  function consulta_arg2(i3a: in instr_3a) return num_var;
  function consulta_arg3(i3a: in instr_3a) return num_var;

  -- Funcions per consultar els camps de les variables
  function consulta_val_const(tv: in tvariables; nv: in num_var) return valor;
  function consulta_tsb_const(tv: in tvariables; nv: in num_var) return tipus_subjacent;
  function consulta_np_var(tv: in tvariables; nv: in num_var) return num_proc;
  function consulta_desp_var(tv: in tvariables; nv: in num_var) return despl;
  function consulta_ocup_var(tv: in tvariables; nv: in num_var) return despl;
  function es_var(tv: in tvariables; nv: in num_var) return boolean;

  -- Funcions per consultar els camps dels procediements
  function consulta_tproc(tp: in tprocediments; np: in num_proc) return tproc;
  function consulta_prof_proc(tp: in tprocediments; np: in num_proc) return profunditat;
  function consulta_ocup_proc(tp: in tprocediments; np: in num_proc) return despl;
  function consulta_etiq_proc(tp: in tprocediments; np: in num_proc) return num_etiq;
  function consulta_nom_proc(tp: in tprocediments; np: in num_proc; tn: in tnoms) return String;
  function consulta_nparam_proc(tp: in tprocediments; np: in num_proc) return natural;

  --Procediment per actualitzar els campsde les variables/procs
  procedure calcul_desplacaments (tv: in out tvariables; nv: in num_var; tp: in out tprocediments; np: in num_proc);
private

  type instr_3a (d: discr_instruccio:= comu) is
    record
      t: tinstruccio;
      b: num_var;
      c: num_var;
      case d is
        when comu =>
          nv: num_var;
        when proc =>
          np: num_proc;
        when etiq =>
          ne: num_etiq;
      end case;
    end record;

  -- Aquest es el tipus d'instruccions escrites al fitxer binári ja que simplifiquen
  -- molt la seua gestió
  type instr_3a_bin is
    record
      t: tinstruccio;
      a: integer;
      b: integer;
      c: integer;
    end record;

  type tvar is (esvar, esconst);
  type e_tvar (tv: tvar) is
    record
      case tv is
        when esvar =>
          np: num_proc;
          ocup: despl;
          desp: despl;
        when esconst =>
          val: valor;
          tsb: tipus_subjacent;
      end case;
    end record;

  type pe_tvar is access e_tvar;


  type e_tproc (tp: tproc)is
    record
      prof: profunditat;
      nparam: natural;
      case tp is
        when comu =>
          e: num_etiq;
          ocup_vl: despl;
        when std =>
          id: id_nom;
      end case;
    end record;

  type pe_tproc is access e_tproc;

  type tvariables is array (num_var) of pe_tvar;
  type tprocediments is array (num_proc) of pe_tproc;

end decls.d_c3a;
