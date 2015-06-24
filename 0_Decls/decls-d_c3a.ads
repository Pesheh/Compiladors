with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tsimbols; use decls.d_tsimbols;

package decls.d_c3a is

  type discr_instruccio is (comu, proc, etiq);
  type instr_3a(d: discr_instruccio) is private;
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
  type tvariables is limited private;
  type tprocediments is limited private;

  procedure nova_var(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; ocup: in despl; t: out num_var);
  procedure nova_var_const(nv: in out num_var; tv: in out tvariables; val: in valor; tsb: in tipus_subjacent; t: out num_var);
  procedure nou_proc(np: in out num_proc; tp: in out tprocediments; e: in num_etiq; prof: in profunditat; nparam: in natural; p: out num_proc);
  procedure nova_etiq (ne: in out num_etiq; e: out num_etiq);

  procedure act_proc_args(tp: in out tprocediments; np: in num_proc; nargs: in natural);

  -- Si posam Valor, entra en conflicte amb el tipus valor
  function Value(t: in tinstruccio; a: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a,b: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a,b,c: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a: in num_etiq) return instr_3a;
  function Value(t: in tinstruccio; a: in num_etiq; b,c: in num_var) return instr_3a;
  function Value(t: in tinstruccio; a: in num_proc) return instr_3a;

  function Imatge(i3a: in instr_3a) return String;

  -- Es l'unica manera de mantenir la privacitat del tipus variable. Si escau
  -- aplicar aquest esquema als camps necessaris a posteriori d'aquest tipus
  function consulta_val_const(tv: in tvariables; nv: in num_var) return valor;
  function consulta_np_var(tv: in tvariables; nv: in num_var) return num_proc;
  function consulta_desp_var(tv: in tvariables; nv: in num_var) return despl;
  function es_var(tv: in tvariables; nv: in num_var) return boolean;

  function consulta_prof_proc(tp: in tprocediments; np: in num_proc) return profunditat;
  pragma Inline(nou_proc, nova_etiq, Value, consulta_val_const);

private

  type instr_3a (d: discr_instruccio) is
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

  esvar: constant boolean:= true;
  esconst: constant boolean:= false;
  type e_tvar (e: boolean) is
    record
      case e is
        when esvar =>
          np: num_proc;
          ocup: despl;
          desp: despl;
        when esconst =>
          val: valor;
          tsb: tipus_subjacent;
      end case;
    end record;

  -- Es l'unica manera de poder tenir un array d'elements de tamany "variable"
  type pe_tvar is access e_tvar;

  type e_tproc is
    record
      e: num_etiq;
      prof: profunditat;
      ocup_vl: despl;
      nparam: natural;
    end record;

  type tvariables is array (num_var) of pe_tvar;
  type tprocediments is array (num_proc) of e_tproc;

end decls.d_c3a;
