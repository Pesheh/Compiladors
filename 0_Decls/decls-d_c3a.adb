with Ada.Text_IO; use ada.text_io;
with decls.d_tnoms;
with semantica; use semantica;
package body decls.d_c3a is


  function print_tv(tv: in tvariables; nv: in num_var) return string is
  begin
    if tv(nv).tv = esconst then
      return "nv: "&num_Var'image(nv)&"; valor:"&valor'image(tv(nv).all.val)&"; tsb: "&tipus_subjacent'image(tv(nv).all.tsb);
    else
      return "nv: "&num_var'image(nv)&"; num_proc:"&num_proc'image(tv(nv).all.np)&"; ocup: "&despl'image(tv(nv).all.ocup)&"; desp: "&despl'image(tv(nv).all.desp);
    end if;
  end print_tv;

  function print_tp(tp: in tprocediments; np: in num_proc) return String is
  begin
    if tp(np).tp = std then
      return "np: "&num_proc'image(np)&"; id_nom: "&id_nom'image(tp(np).id)&
      "; nparam: "&natural'image(tp(np).nparam);
    else 
      return "np: "&num_proc'image(np)&"; num_etiq: "&num_etiq'image(tp(np).e)&
      "; ocup_vl: "&despl'image(tp(np).ocup_vl)&"; nparam: "&natural'image(tp(np).nparam);
    end if;
  end print_tp;

  procedure nova_var(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; ocup: in despl; t: out num_var) is
    i: despl;
  begin
    nv:= nv+1;
    if tp(np).tp = std then
      -- els procs std tenen 1 o 0 args
      tv(nv):= new e_tvar'(esvar, np, ocup, 0);
    else
      -- si portessim a terme una etapa d'optimitzacio, aixo hauria de calcular-se
      -- un cop hagues acabat l'esmentada etapa (es absurd calcular una ocupacio que canviara).
      -- però com que no es el cas, ho feim aquí
      tv(nv):= new e_tvar'(esvar, np, ocup, -i);
    end if;
    t:= nv;
  end nova_var;


  procedure nova_var_const(nv: in out num_var; tv: in out tvariables; val: in valor; tsb: in tipus_subjacent; t: out num_var) is
  begin
    nv:= nv+1;
    tv(nv):= new e_tvar'(esconst, val, tsb);
    t:= nv;
  end nova_var_const;

  procedure nou_arg(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; offset: in despl; t: out num_var) is
  begin
    nv:= nv+1;
    tv(nv):= new e_tvar'(esvar, np, ocup_ent, offset);
    t:= nv;
  end nou_arg;


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


  function debug_Imatge(i3a: in instr_3a; tv: in tvariables; tp: in tprocediments) return String is
  begin
    if i3a.b = null_nv then
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&" - - {"&print_tv(tv, i3a.nv)&"}";
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&" - - {"&print_tp(tp, i3a.np)&"}";
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&" - -";
      end case;
    elsif i3a.c = null_nv then
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&""&num_var'Image(i3a.b)&" - {"&print_tv(tv, i3a.nv)&"}, {"&print_tv(tv, i3a.b)&"}";
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&""&num_var'Image(i3a.b)&" - {"&print_tp(tp, i3a.np)&"}, {"&print_tv(tv, i3a.b)&"}";
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&""&num_var'Image(i3a.b)&" -";
      end case;
    else
      case i3a.d is
        when comu =>
          return tinstruccio'Image(i3a.t)&""&num_var'Image(i3a.nv)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c)&" {"&print_tv(tv, i3a.nv)&"}, {"&print_tv(tv, i3a.b)&"}, {"&print_tv(tv, i3a.c)&"}";
        when proc =>
          return tinstruccio'Image(i3a.t)&""&num_proc'Image(i3a.np)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c)&" {"&print_tp(tp, i3a.np)&"}, {"&print_tv(tv, i3a.b)&"}, {"&print_tv(tv, i3a.c)&"}";
        when etiq =>
          return tinstruccio'Image(i3a.t)&""&num_etiq'Image(i3a.ne)&""&num_var'Image(i3a.b)&""&num_var'Image(i3a.c);
      end case;
    end if;
  end debug_Imatge;


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


  function consulta_tsb_const(tv: in tvariables; nv: in num_var) return tipus_subjacent is
  begin
    return tv(nv).all.tsb;
  end consulta_tsb_const;


  function consulta_np_var(tv: in tvariables; nv: in num_var) return num_proc is
  begin
    return tv(nv).all.np;
  end consulta_np_var;


  function consulta_desp_var(tv: in tvariables; nv: in num_var) return despl is
  begin
    return tv(nv).all.desp;
  end consulta_desp_var;

  function consulta_ocup_var(tv: in tvariables; nv: in num_var) return despl is
  begin
    return tv(nv).all.ocup;
  end consulta_ocup_var;

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

  procedure actualitza_ocupvl_proc(tp: in out tprocediments; np: in num_proc; ocup: in despl) is
  begin
    tp(np).ocup_vl:=ocup;
  end actualitza_ocupvl_proc;

  procedure actualitza_desp_var(tv: in out tvariables; nv: in num_var; desp: in despl) is
  begin
    tv(nv).all.desp:=desp;
  end actualitza_desp_var;

  procedure print_procs_and_vars(tp: in tprocediments; tv: in tvariables; np: in num_proc; nv: in num_var) is
  begin
    for num_p in null_np+1..np loop
     ada.text_io.put_line(print_tp(tp, num_p));
    end loop;
    for num_v in null_nv+1..nv loop
     ada.text_io.put_line(print_tv(tv, num_v));
    end loop;
  end print_procs_and_vars;

  procedure calcul_desplacaments (tv: in out tvariables; nv: in num_var; tp: in out tprocediments; np: in num_proc) is
    desp: despl;
    var: e_tvar(esvar);
    lvar: array (num_proc range null_np+1..np) of num_var;
    ldesp: array(num_proc range null_np+1..np) of despl;
  begin
    for ip in null_np+1..np loop
      if tp(ip).all.tp = comu then
        tp(ip).all.ocup_vl:= 0;
        ldesp(ip):= ocup_ent;
      end if;
    end loop;

    for iv in null_nv+1..nv loop
      if tv(iv).tv = esvar  and then tv(iv).all.desp <= 0 then
        var:= tv(iv).all;
        if tp(var.np).all.tp = comu then
          desp:= ldesp(var.np);
          tp(var.np).all.ocup_vl:= desp;
          tv(iv).all.desp:= -desp;
          ldesp(var.np):= desp + var.ocup;
          lvar(var.np):= iv;
        end if;
      end if;
    end loop;

    for ip in null_np+1..np loop
      if tp(ip).all.tp = comu and then tp(ip).all.ocup_vl > 0 then
        tp(ip).all.ocup_vl:= tp(ip).all.ocup_vl + tv(lvar(ip)).all.ocup;
      end if;
    end loop;
  end calcul_desplacaments;

end decls.d_c3a;
