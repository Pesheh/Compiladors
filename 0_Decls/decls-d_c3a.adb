with Ada.Text_IO;
with decls.d_tnoms;
with semantica; use semantica;
package body decls.d_c3a is

  procedure nova_var(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; ocup: in despl; t: out num_var) is
  begin
    nv:= nv+1;
    if tp(np).tp = std then
      -- els procs std tenen 1 o 0 args
      tv(nv):= new e_tvar'(esvar, np, ocup, 0);
    else
      tv(nv):= new e_tvar'(esvar, np, ocup, tp(np).ocup_vl);
      tp(np).ocup_vl:= tp(np).ocup_vl + ocup;
    end if;
    -- si portessim a terme una etapa d'optimitzacio, aixo hauria de calcular-se
    -- un cop hagues acabat l'esmentada etapa (es absurd calcular una ocupacio que canviara).

    if DEBUG then
      Ada.Text_IO.Put_Line("nova_var:nv::"&num_var'Image(nv));
    end if;

    t:= nv;
  end nova_var;


  procedure nova_var_const(nv: in out num_var; tv: in out tvariables; val: in valor; tsb: in tipus_subjacent; t: out num_var) is
  begin
    nv:= nv+1;
    tv(nv):= new e_tvar'(esconst, val, tsb);

    --if DEBUG then
      Ada.Text_IO.Put_Line("nova_var_const:nvc::"
      &num_var'Image(nv)&"::"
      &valor'Image(val)&"::"
      &tipus_subjacent'Image(tsb));
    --end if;

    t:= nv;
  end nova_var_const;


  procedure nou_proc(np: in out num_proc; tp: in out tprocediments; e: in num_etiq; prof: in profunditat; nparam: in natural; p: out num_proc) is
  begin
    np:= np+1;
    tp(np):= new e_tproc'(comu, e=> e, prof=> prof, ocup_vl=> 0, nparam=> nparam);

    p:= np;
  end nou_proc;


  procedure nou_proc_std(np: in out num_proc; tp: in out tprocediments; id: in id_nom; prof: in profunditat; nparam: in natural; p: out num_proc) is
  begin
    np:= np+1;
    tp(np):= new e_tproc'(std, id=> id, prof=> prof, nparam=> nparam);

    p:= np;
  end nou_proc_std;

  procedure nova_etiq (ne: in out num_etiq; e: out num_etiq) is
  begin
    ne:= ne+1;

    e:= ne;
  end nova_etiq;


  procedure act_proc_args(tp: in out tprocediments; np: in num_proc; nargs: in natural) is
  begin
    tp(np).nparam:= nargs;
  end act_proc_args;


  function Value(t: in tinstruccio; a: in num_var) return instr_3a is
  begin
    return (comu, t, nv=> a, b=> null_nv, c=> null_nv);
  end Value;


  function Value(t: in tinstruccio; a,b: in num_var) return instr_3a is
  begin
    return (comu, t, nv=> a, b=> b, c=> null_nv);
  end Value;


  function Value(t: in tinstruccio; a,b,c: in num_var) return instr_3a is
  begin
    return (comu, t, nv=> a, b=> b, c=> c);
  end Value;


  function Value(t: in tinstruccio; a: in num_etiq) return instr_3a is
  begin
    return (etiq, t, ne=> a, b=> null_nv, c=> null_nv);
  end Value;


  function Value(t: in tinstruccio; a: in num_etiq; b,c: in num_var) return instr_3a is
  begin
    return (etiq, t, ne=> a, b=> b, c=> c);
  end Value;


  function Value(t: in tinstruccio; a: in num_proc) return instr_3a is
  begin
    return (proc, t, np=> a, b=> null_nv, c=> null_nv);
  end Value;


  function Imatge(i3a: in instr_3a) return String is
  begin
    if i3a.b = null_nv then
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&" - -";
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&" - -";
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&" - -";
      end case;
    elsif i3a.c = null_nv then
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&""&num_var'Image(i3a.b)&" -";
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&""&num_var'Image(i3a.b)&" -";
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&""&num_var'Image(i3a.b)&" -";
      end case;
    else
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c);
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c);
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c);
      end case;
    end if;
  end Imatge;


  function To_i3a_bin(i3a: in instr_3a) return instr_3a_bin is
  begin
    case i3a.d is
      when comu =>
        return (i3a.t, integer(i3a.nv), integer(i3a.b), integer(i3a.c));
      when proc =>
        return (i3a.t, integer(i3a.np), integer(i3a.b), integer(i3a.c));
      when etiq =>
        return (i3a.t, integer(i3a.ne), integer(i3a.b), integer(i3a.c));
      end case;
  end To_i3a_bin;


  function To_i3a(i3a_b: in instr_3a_bin) return instr_3a is
  begin
    case i3a_b.t is
      when pmb | call | rtn =>
        return (proc, i3a_b.t, np=> num_proc(i3a_b.a), b=> num_var(i3a_b.b), c=> num_var(i3a_b.c));
      when etiq | go_to | ieq_goto =>
        return (etiq, i3a_b.t, ne=> num_etiq(i3a_b.a), b=> num_var(i3a_b.b), c=> num_var(i3a_b.c));
      when others =>
         return (comu, i3a_b.t, nv=> num_var(i3a_b.a), b=> num_var(i3a_b.b), c=> num_var(i3a_b.c));
    end case;
  end To_i3a;


  function consulta_tipus(i3a: in instr_3a) return tinstruccio is
  begin
    return i3a.t;
  end consulta_tipus;


  function consulta_arg_nv(i3a: in instr_3a) return num_var is
  begin
    return i3a.nv;
  end consulta_arg_nv;


  function consulta_arg_np(i3a: in instr_3a) return num_proc is
  begin
    return i3a.np;
  end consulta_arg_np;


  function consulta_arg_ne(i3a: in instr_3a) return num_etiq is
  begin
    return i3a.ne;
  end consulta_arg_ne;

  function consulta_arg2(i3a: in instr_3a) return num_var is
  begin
    return i3a.b;
  end consulta_arg2;

  function consulta_arg3(i3a: in instr_3a) return num_var is
  begin
    return i3a.c;
  end consulta_arg3;


  -- Es l'unica manera de mantenir la privacitat del tipus variable. Si escau
  -- aplicar aquest esquema als camps necessaris a posteriori d'aquest tipus
  function consulta_val_const(tv: in tvariables; nv: in num_var) return valor is
  begin
    return tv(nv).all.val;
  end consulta_val_const;


  function consulta_np_var(tv: in tvariables; nv: in num_var) return num_proc is
  begin
    return tv(nv).all.np;
  end consulta_np_var;


  function consulta_desp_var(tv: in tvariables; nv: in num_var) return despl is
  begin
    return tv(nv).all.desp;
  end consulta_desp_var;


  function es_var(tv: in tvariables; nv: in num_var) return boolean is
  begin
    return tv(nv).all.tv = esvar;
  end es_var;


  function consulta_tproc(tp: in tprocediments; np: in num_proc) return tproc is
  begin
    return tp(np).tp;
  end consulta_tproc;


  function consulta_prof_proc(tp: in tprocediments; np: in num_proc) return profunditat is
  begin
    return tp(np).prof;
  end consulta_prof_proc;


  function consulta_ocup_proc(tp: in tprocediments; np: in num_proc) return despl is
  begin
    if tp(np).tp = std then
      return 0;
    else
      return tp(np).ocup_vl;
    end if;
  end consulta_ocup_proc;


  function consulta_etiq_proc(tp: in tprocediments; np: in num_proc) return num_etiq is
  begin
    if tp(np).tp = std then
      return null_ne;
    else
      return tp(np).e;
    end if;
  end consulta_etiq_proc;


  function consulta_nom_proc(tp: in tprocediments; np: in num_proc; tn: in tnoms) return String is
  begin
    if tp(np).tp = std then
      return d_tnoms.get(tn, tp(np).id);
    else
      return "";
    end if;
  end consulta_nom_proc;


  function consulta_nparam_proc(tp: in tprocediments; np: in num_proc) return natural is
  begin
    return tp(np).nparam;
  end consulta_nparam_proc;

end decls.d_c3a;
