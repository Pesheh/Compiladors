with Ada.Text_IO;
with semantica; use semantica;
package body decls.d_c3a is

  procedure nova_var(nv: in out num_var; tv: in out tvariables; tp: in out tprocediments; np: in num_proc; ocup: in despl; t: out num_var) is
  begin
    nv:= nv+1;
    tv(nv):= new e_tvar'(esvar, np, ocup, tp(np).ocup_vl);
    -- si portessim a terme una etapa d'optimitzacio, aixo hauria de calcular-se
    -- un cop hagues acabat l'esmentada etapa (es absurd calcular una ocupacio que canviara).
    tp(np).ocup_vl:= tp(np).ocup_vl + ocup;

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
    tp(np):= (e, prof, 0, nparam);

    p:= np;
  end nou_proc;


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

  -- Es l'unica manera de mantenir la privacitat del tipus variable. Si escau
  -- aplicar aquest esquema als camps necessaris a posteriori d'aquest tipus
  function consulta_val_const(tv: in tvariables; nv: in num_var) return valor is
  begin
    return tv(nv).all.val;
  end consulta_val_const;

end decls.d_c3a;
