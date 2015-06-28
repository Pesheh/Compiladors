with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with decls.d_tnoms;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_c3a; use decls.d_c3a;
with semantica.missatges; use semantica.missatges; -- <<< TMP per debuguejar

package body semantica.g_codi_int is

  use Instruccio_IO;
  use Pila_Procediments;

  f3a:  Instruccio_IO.File_Type;
  f3as: Ada.Text_IO.File_Type;
  nf: Unbounded_String;

  fals: num_var;
  cert: num_var;

  procedure gc_proc(nd_proc: in pnode);
  procedure gc_cproc(nd_cproc: in pnode);


  procedure gc_decls(nd_decls: in pnode);


  procedure gc_sents(nd_sents: in pnode);
  procedure gc_sent(nd_sent: in pnode);
  procedure gc_siter(nd_siter: in pnode);
  procedure gc_scond(nd_scond: in pnode);
  procedure gc_scrida(nd_cproc: in pnode);
  procedure gc_scrida_args(nod_lexpr: in pnode);
  procedure gc_sassign(nd_sassign: in pnode);


  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out num_var);
  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; dv: out num_var);
  procedure gc_ref_qs(nd_qs: in pnode; dc: in out despl; dv: in out num_var);
  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out num_var);


  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out num_var);
  procedure gc_and(nod_and: in pnode; r: out num_var; d: out num_var);
  procedure gc_or(nod_or: in pnode; r: out num_var; d: out num_var);
  procedure gc_eop(nd_eop: in pnode; r: out num_var; d: out num_var);
  procedure gc_et(nd_et: in pnode; r: out num_var; d: out num_var);



  procedure prepara_g_codi_int(nomf: in String; c,f: in num_var) is
  begin
    cert:= c;
    fals:= f;
    nf:= To_Unbounded_String(nomf);
  end prepara_g_codi_int;


  procedure gen_codi_int is
  begin
    Create(f3a, Out_File, To_String(nf)&".c3a");
    Create(f3as, Out_File, To_String(nf)&".c3as");

    if root.p.tn /= nd_null then
      buida(pproc);
      gc_proc(root.p);
    end if;

    Close(f3as);
    Close(f3a);
  end gen_codi_int;


  procedure genera(i3a: in instr_3a) is
  begin
    Instruccio_IO.Write(f3a, To_i3a_bin(i3a));
    Ada.Text_IO.Put_Line(f3as, Imatge(i3a, tv, tp));
  end genera;


  procedure desref(r: in num_var; d: in num_var; t: out num_var) is
  begin
    if d = null_nv then
     t:= r;
    else
     -- no tinc del tot clar aquest ocup_ent, simplifica les coses pero es una
     -- tudada de memoria
     nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
     genera(Value(cons_idx, t, r, d));
    end if;
  end desref;


  procedure gc_proc(nd_proc: in pnode) is
    p: pnode renames nd_proc;
  begin
    empila(pproc, p.proc_cproc.cproc_np);
    if p.proc_decls.tn /= nd_null then
      gc_decls(p.proc_decls);
    end if;
    gc_cproc(p.proc_cproc);
    gc_sents(p.proc_sents);
    genera(Value(rtn, cim(pproc)));
    desempila(pproc);
  end gc_proc;


  procedure gc_cproc(nd_cproc: in pnode) is
    p: pnode renames nd_cproc;
  begin
    genera(Value(etiq, consulta_etiq_proc(tp, cim(pproc))));
    genera(Value(pmb, cim(pproc)));
  end gc_cproc;


--procedure gc_args(nd_args: in pnode; nargs: out natural) is
--  p: pnode renames nd_args;
--begin
--  if p.args_args.tn /= nd_null then
--    gc_args(p.args_args, nargs);
--  end if;
--  nargs:= nargs+1;
--end gc_args;


  procedure gc_decls(nd_decls: in pnode) is
    p: pnode renames nd_decls;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_decls",tnode'Image(p.tn)&"::"&tnode'Image(p.decls_decls.tn)&"::"&tnode'Image(p.decls_decl.tn));
    end if;
    if p.decls_decls.tn /= nd_null then
      gc_decls(p.decls_decls);
    end if;
    -- nomes cal generar codi per als procediments
    if p.decls_decl.decl_real.tn = nd_proc then
      gc_proc(p.decls_decl.decl_real);
    end if;
  end gc_decls;


  procedure gc_sents(nd_sents: in pnode) is
  begin
    if DEBUG then
      missatges_gc_debugging("gc_sents",tnode'Image(nd_sents.tn));
    end if;
    if nd_sents.tn /= nd_null then
      gc_sent(nd_sents.sents_cont);
    end if;
  end gc_sents;


  procedure gc_sent(nd_sent: in pnode) is
    p: pnode;
  begin
    p:= nd_sent;
    if p.snb_snb.tn /= nd_null then
      gc_sent(p.snb_snb);
    end if;
    p:= p.snb_sent.sent_sent;
    case p.tn is
      when nd_siter =>
        gc_siter(p);
      when nd_scond =>
        gc_scond(p);
      when nd_scrida =>
        gc_scrida(p);
      when nd_sassign =>
        gc_sassign(p);
      when others =>
        null;
    end case;
  end gc_sent;


  procedure gc_siter(nd_siter: in pnode) is
    p: pnode renames nd_siter;
    ei,ef: num_etiq;
    r,t,d: num_var;
  begin
    if p.siter_sents.tn /= nd_null then
      nova_etiq(ne, ei);
      genera(Value(etiq, ei));
      gc_expressio(p.siter_expr, r, d);
      desref(r, d, t); -- Bastaria amb un byte per codificar -1..0
      nova_etiq(ne, ef);
      genera(Value(ieq_goto, ef, t, fals));
      gc_sents(p.siter_sents);
      genera(Value(go_to, ei));
      genera(Value(etiq, ef));
    end if;
  end gc_siter;


  procedure gc_scond(nd_scond: in pnode) is
    p: pnode renames nd_scond;
    ef,efi: num_etiq;
    r,t,d: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_scond if ",tnode'Image(p.scond_sents.tn)&"else "&tnode'Image(p.scond_esents.tn));
    end if;
    if p.scond_sents.tn /= nd_null or p.scond_esents.tn /= nd_null then
      gc_expressio(p.scond_expr, r, d);
      desref(r, d, t);
      nova_etiq(ne, ef);
      genera(Value(ieq_goto, ef, t, fals));
      gc_sents(p.scond_sents);
      if p.scond_esents.tn /= nd_null then
        nova_etiq(ne, efi);
        genera(Value(go_to, efi));
        genera(Value(etiq, ef));
        gc_sents(p.scond_esents);
        -- codi esperat:
        -- if t=fals goto efals
        --  sents_if
        --  goto efi
        -- efals: skip
        --  sents_else
        -- efi: skip
      else
        efi:= ef; --tefi:= tef;
        -- codi esperat:
        -- if t=fals goto efi
        --  sents_if
        -- efi: skip
      end if;
      genera(Value(etiq, efi));
    end if;
  end gc_scond;


  procedure gc_scrida(nd_cproc: in pnode) is
    p: pnode;
    d: descripcio;
  begin
    p:= nd_cproc.scrida_ref;
    if DEBUG then
      missatges_gc_debugging("gc_scrida",tnode'Image(p.tn)&"::"&tnode'Image(p.ref_id.tn));
    end if;
    if p.ref_qs.tn /= nd_null then
      gc_scrida_args(p.ref_qs.qs_q.q_contingut);
    end if;
    if p.ref_id.tn = nd_id then -- stdio call
      d:= get(ts, p.ref_id.id_id);
      if DEBUG then
        missatges_gc_debugging("gc_scrida",tipus_descr'Image(d.td));
      end if;
      genera(Value(call, d.np));
    else
      genera(Value(call, p.ref_id.iproc_np));
    end if;

  end gc_scrida;


  procedure gc_scrida_args(nod_lexpr: in pnode) is
    p: pnode renames nod_lexpr;
    r,d: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_scrida_args",tnode'Image(p.tn));
    end if;
    if p.lexpr_cont.tn /= nd_null then
      gc_scrida_args(p.lexpr_cont);
    end if;
    gc_expressio(p.lexpr_expr, r, d);

    if DEBUG then
      missatges_gc_debugging("gc_scrida_args","r="&num_var'Image(r)&"::"&"d="&num_var'Image(d));
    end if;

    if d = null_nv then
      genera(Value(params, r));
    else
      genera(Value(paramc, r, d));
    end if;

  end gc_scrida_args;


  procedure gc_sassign(nd_sassign: in pnode) is
    p: pnode renames nd_sassign;
    r,r1,t,d,d1: num_var;
  begin
    gc_ref(p.sassign_ref, r, d);
    gc_expressio(p.sassign_expr, r1, d1);
    if d = null_nv then
      if d1 = null_nv then
        genera(Value(cp, r, r1));
        -- r:= r1
      else
        genera(Value(cons_idx, r, r1, d1));
        -- r:= r1[d1]
      end if;
    else
      if d1 = null_nv then
        genera(Value(cp_idx, r, d, r1));
        -- r[d]:= r1
      else
        desref(r1, d1, t);
        genera(Value(cp_idx, r,  d, t));
        -- t:= r1[d1]
        -- r[d]:= t
      end if;
    end if;
  end gc_sassign;


  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nd_ref;
    dc: despl;
    t,t1,dv: num_var;
  begin
    gc_ref_id(p.ref_id, r, dc, dv);
    if p.ref_qs.tn /= nd_null then
      gc_ref_qs(p.ref_qs, dc, dv);
    end if;
    if dc = 0 and then dv = 0 then
      -- r = r -- ja li hem posat el valor a gc_ref_id
      d:= null_nv;
    elsif dc = 0 and then dv /= 0 then
      -- r = r(dv)
      d:= dv;
    elsif dc /= 0 and then dv = 0 then
      nova_var_const(nv, tv, valor(dc), tsb_ent, t);
      if DEBUG then
        missatges_gc_debugging("gc_ref","dc /= 0 & dv = 0:"&num_var'Image(t));
      end if;
      -- r:= r.dc
      d:= t;
    else -- dc /= 0 and dv /= 0
      nova_var_const(nv, tv, valor(dc), tsb_ent, t);
      if DEBUG then
        missatges_gc_debugging("gc_ref","dc /= 0 & dv /= 0:"&num_var'Image(t));
      end if;
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t1);
      genera(Value(sum, t1, t, dv));
      -- r:= r.dc(dv)
      d:= t1;
    end if;
  end gc_ref;


  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; dv: out num_var) is
    p: pnode renames nd_id;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_ref_id",tnode'Image(p.tn));
    end if;
    r:= p.var_nv;
    dc:= 0;
    dv:= null_nv;
  end gc_ref_id;


  procedure gc_ref_qs(nd_qs: in pnode; dc: in out despl; dv: in out num_var) is
    p: pnode renames nd_qs;
    t,t1,t2: num_var;
    desp: num_var:= null_nv;
  begin
    if p.qs_qs.tn /= nd_null then
      gc_ref_qs(p.qs_qs, dc, dv);
    end if;
    if p.qs_q.tn = nd_rec then
      dc:= dc + despl(consulta_val_const(tv, p.qs_q.rec_td));
    else -- p.qs_q.tn = nd_arry
      gc_ref_lexpr(p.qs_q.arry_lexpr, desp);
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      genera(Value(res, t, desp, p.qs_q.arry_tb));
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t1);
      genera(Value(mul, t1, t, p.qs_q.arry_tw));
      if dv = null_nv then
        dv:= t1;
      else
        nova_var(nv, tv, tp, cim(pproc), ocup_ent, t2);
        genera(Value(sum, t2, t1, dv));
        dv:= t2;
      end if;
    end if;
  end gc_ref_qs;


  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out num_var) is
    p: pnode renames nd_lexpr;
    r,d,t,t1,te: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_expressio",tnode'Image(p.tn));
    end if;
    if p.lexpra_cont.tn /= nd_null then
      gc_ref_lexpr(p.lexpra_cont, desp);
    end if;
    if desp /= 0 then
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t); nova_var(nv, tv, tp, cim(pproc), ocup_ent, t1);
      genera(Value(mul, t, desp, p.lexpra_tu));
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      genera(Value(sum, t1, t, te));
      desp:= t1;
    else
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      genera(Value(cp, t, te, null_nv));
      desp:= t;
    end if;
    if DEBUG then
      missatges_gc_debugging("gc_ref_lexpr","despl:"&num_var'Image(desp));
    end if;
  end gc_ref_lexpr;


  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nd_expr;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_expressio",tnode'Image(p.tn)&"::"&tnode'Image(p.expr_e.tn));
    end if;
    case p.expr_e.tn is
      when nd_and =>
        gc_and(p.expr_e, r, d);
        --ocup:= ocup_bool;
      when nd_or =>
        gc_or(p.expr_e, r, d);
        --ocup:= ocup_bool;
      when nd_eop | nd_op_rel =>
        gc_eop(p.expr_e, r, d);
      when others =>
        -- Comprovacio de tipus...
        null;
    end case;
  end gc_expressio;


  procedure gc_and(nod_and: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nod_and;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_and",tnode'Image(p.tn));
    end if;
    if p.e_ope.tn = nd_and then
      gc_and(p.e_ope, r1, d1);
    else
      gc_eop(p.e_ope, r1, d1);
    end if;
    desref(r1, d1, t1); -- bastaria amb un char -1..0 per guardar el resultat
    gc_eop(p.e_opd, r1, d1);
    desref(r1, d1, t2); -- bastaria amb un char -1..0 per guardar el resultat
    nova_var(nv, tv, tp, cim(pproc), ocup_ent, t); -- bastaria amb un char -1..0 per guardar el resultat
    genera(Value(op_and, t, t1, t2));
    r:= t;
    d:= null_nv;
  end gc_and;


  procedure gc_or(nod_or: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nod_or;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_or",tnode'Image(p.tn));
    end if;
    if p.e_ope.tn = nd_or then
      gc_or(p.e_ope, r1, d1);
    else
      gc_eop(p.e_ope, r1, d1);
    end if;
    -- El tema d'ocupi es una mica redundant
    -- 'a' < 'c' and 'd' > 'k' ==
    -- tc1:= 'a'; tc2:= 'c';
    -- t1:= tc1 < tc2;
    -- tc3:= 'd'; tc4:= 'k';
    -- t2:= tc3 > tc4;
    -- t:= t1 and t2
    desref(r1, d1, t1);
    gc_eop(p.e_opd, r1, d1);
    desref(r1, d1, t2);
    nova_var(nv, tv, tp, cim(pproc), ocup_ent, t); -- bastaria amb un char -1..0 per guardar el resultat
    genera(Value(op_or, t, t1, t2));
    r:= t;
    -- Ocup_bool ?
    --ocup:= ocup_ent;
    d:= null_nv;
  end gc_or;


  procedure gc_eop(nd_eop: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nd_eop;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_eop",tnode'Image(p.tn));
    end if;
    if p.eop_operand = nul then
      gc_et(p.eop_opd, r, d);
    elsif p.eop_operand = neg_alg or p.eop_operand = neg_log then
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      gc_et(p.eop_opd, r1, d1);
      desref(r1, d1, t1);
      if p.eop_operand = neg_alg then
        genera(Value(neg, t, t1, null_nv));
      else
        genera(Value(op_not, t, t1, null_nv));
      end if;
      r:= t;
      d:= null_nv;
    else
      gc_eop(p.eop_ope, r1, d1);
      desref(r1, d1, t1); -- Si no vaig malament 'A' + 'b' no esta permes al nostre llenguatge xD
      gc_eop(p.eop_opd, r1, d1);
      desref(r1, d1, t2);
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      case p.eop_operand is
        when major =>
          genera(Value(gt, t, t1, t2));
        when majorigual =>
          genera(Value(ge, t, t1, t2));
        when igual =>
          genera(Value(eq, t, t1, t2));
        when diferent =>
          genera(Value(neq, t, t1, t2));
        when menorigual =>
          genera(Value(le, t, t1,  t2));
        when menor =>
          genera(Value(lt, t, t1, t2));
        when sum =>
          genera(Value(sum, t, t1, t2));
        when res =>
          genera(Value(res, t, t1, t2));
        when prod =>
          genera(Value(mul, t, t1, t2));
        when quoci =>
          genera(Value(div, t, t1, t2));
        when modul =>
          genera(Value(modul, t, t1, t2));
        when others =>
          null;
      end case;
      r:= t;
      d:= null_nv;
    end if;
  end gc_eop;


  procedure gc_et(nd_et: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nd_et;
    t: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_et",tnode'Image(p.tn)&"=>"&tnode'Image(p.et_cont.tn));
    end if;
    case p.et_cont.tn is
      when nd_ref =>
        gc_ref(p.et_cont, r, d);
      when nd_expr =>
        gc_expressio(p.et_cont, r, d);
      when nd_lit =>
        if DEBUG then
          missatges_gc_debugging("gc_et",tipus_subjacent'Image(p.et_cont.lit_tipus)&"::"&valor'Image(p.et_cont.lit_val));
        end if;
        case p.et_cont.lit_tipus is
          when tsb_ent | tsb_car | tsb_bool | tsb_nul =>
            nova_var_const(nv, tv, p.et_cont.lit_val, p.et_cont.lit_tipus, t);
          when others =>
            null;
        end case;
        if DEBUG then
          missatges_gc_debugging("gc_et","invc:"&num_var'Image(t));
        end if;
        r:= t;
        d:= null_nv;
      when others =>
        null;
    end case;
  end gc_et;


end semantica.g_codi_int;
