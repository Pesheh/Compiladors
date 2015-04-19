with Ada.Text_IO;
with decls.d_tnoms;
with semantica.missatges; use semantica.missatges; -- <<< TMP per debuguejar 
package body semantica.g_codi_int is

  DEBUG: constant boolean:= true;

  fals: constant num_var:= 0;

  ti: taula_instruccions;
  iti: num_instr:= 0;

  tp: taula_procediments;

  tv: taula_variables;

  ne: etiqueta:= 0;

  procedure gc_proc(nd_proc: in pnode);
  procedure gc_cproc(nd_cproc: in pnode);
  procedure gc_args(nd_args: in pnode; nargs: out natural);
  procedure gc_decls(nd_decls: in pnode);
  procedure gc_sents(nd_sents: in pnode);
  procedure gc_sent(nd_sent: in pnode);
  procedure gc_siter(nd_siter: in pnode);
  procedure gc_scond(nd_scond: in pnode);
  procedure gc_scrida(nd_cproc: in pnode);
  procedure gc_scrida_args(nod_lexpr: in pnode);
  procedure gc_sassign(nd_sassign: in pnode);
  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out despl);
  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; dv: out num_var);
  procedure gc_ref_qs(nd_qs: in pnode; dc: in out despl; dv: in out num_var);
  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out num_var);
  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out despl);
  procedure gc_and(nod_and: in pnode; r: out num_var; d: out despl);
  procedure gc_or(nod_or: in pnode; r: out num_var; d: out despl);
  procedure gc_e2(nd_e2: in pnode; r: out num_var; d: out despl);
  procedure gc_e3(nd_e3: in pnode; r: out num_var; d: out despl);

  function nova_etiq return etiqueta is
  begin
    ne:= ne+1;
    return ne;
  end nova_etiq;

  -- El format es temporal
  procedure genera(t: in tinstruccio; a,b,c: in num_var) is
  begin
    if b = null_nv then
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&" - -");
    elsif c = null_nv then
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&""&num_var'Image(b)&" -");
    else
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&""&num_var'Image(b)&""&num_var'Image(c));
    end if;
  end genera;

  procedure genera(t: in tinstruccio; a: in etiqueta; b,c: in num_var) is
  begin
    if b = null_nv then
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&etiqueta'Image(a)&" - -");
    elsif c = null_nv then
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&etiqueta'Image(a)&""&num_var'Image(b)&" -");
    else
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&etiqueta'Image(a)&""&num_var'Image(b)&""&num_var'Image(c));
    end if;
  end genera;

  procedure genera(t: in tinstruccio; a: in num_var; b: in String; c: in num_var) is
  begin
    if c = null_nv then
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&" "&b&" -");
    else
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&" "&b&""&num_var'Image(c));
    end if;
  end genera;

  procedure genera(t: in tinstruccio; a: in num_var; b: in despl; c: in num_var) is
  begin
    if t = paramc or t = cp_idx then 
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&""&despl'Image(b)&""&num_var'Image(c));
    end if;
  end genera;

  procedure genera(t: in tinstruccio; a,b: in num_var; c: in despl) is
  begin
    if t = cons_idx then 
      missatges_gc_debugging("genera",tinstruccio'Image(t)&""&num_var'Image(a)&""&num_var'Image(b)&""&despl'Image(c));
    end if;
  end genera;

  procedure desref(r: in num_var; d: in despl; t: out num_var) is
  begin
    if d = 0 then
     t:= r;
    else
     t:= nova_var;
     genera(cons_idx, t, r, d);
    end if;
  end desref;

  procedure gen_codi_int is
  begin
    if root.p.tn /= nd_null then
      gc_proc(root.p);
    end if;
  end gen_codi_int;

  procedure gc_proc(nd_proc: in pnode) is
    p: pnode renames nd_proc;
  begin
    if p.proc_cproc.tn /= nd_null then
      gc_cproc(p.proc_cproc);
    end if;
    if p.proc_decls.tn /= nd_null then
      gc_decls(p.proc_decls);
    end if;
    gc_sents(p.proc_sents);
    genera(rtn, num_var(p.proc_cproc.cproc_np), null_nv, null_nv);
  end gc_proc;

  procedure gc_cproc(nd_cproc: in pnode) is
    p: pnode renames nd_cproc;
    nargs: natural;
    e: etiqueta;
  begin
    nargs:= 0; -- usat a la taula de procediments
    if p.cproc_args.tn /= nd_null then
      gc_args(p.cproc_args, nargs);
    end if;
    e:= nova_etiq; genera(etiq, e, null_nv, null_nv); genera(pmb, num_var(p.cproc_np), null_nv, null_nv);
  end gc_cproc;

  procedure gc_args(nd_args: in pnode; nargs: out natural) is
    p: pnode renames nd_args;
  begin
    if p.args_args.tn /= nd_null then
      gc_args(p.args_args, nargs);
    end if;
    nargs:= nargs+1;
  end gc_args;

  procedure gc_decls(nd_decls: in pnode) is
    p: pnode renames nd_decls;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_decls",tnode'Image(p.tn)&"::"&tnode'Image(p.decls_decls.tn)&"::"&tnode'Image(p.decls_decl.tn));
    end if;
    if p.decls_decls.tn /= nd_null then
      gc_decls(p.decls_decls);
    end if;
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
    ei,ef: etiqueta;
    r,t: num_var;
    d: despl;
  begin
    if p.siter_sents.tn /= nd_null then
      ei:= nova_etiq;
      genera(etiq, ei, null_nv, null_nv);
      gc_expressio(p.siter_expr, r, d);
      desref(r, d, t);
      ef:= nova_etiq;
      genera(ieq_goto, ef, t, fals);
      gc_sents(p.siter_sents);
      genera(go_to, ei, null_nv, null_nv);
      genera(etiq, ef, null_nv, null_nv);
    end if;
  end gc_siter;

  procedure gc_scond(nd_scond: in pnode) is
    p: pnode renames nd_scond;
    ef,efi: etiqueta;
    r,t: num_var;
    d: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_scond if ",tnode'Image(p.scond_sents.tn)&"else "&tnode'Image(p.scond_esents.tn));
    end if;
    if p.scond_sents.tn /= nd_null or p.scond_esents.tn /= nd_null then
      gc_expressio(p.scond_expr, r, d);
      desref(r, d, t);
      ef:= nova_etiq;
      genera(ieq_goto, ef, t, fals);
      gc_sents(p.scond_sents);
      if p.scond_esents.tn /= nd_null then
        efi:= nova_etiq;
        genera(go_to, efi, null_nv, null_nv);
        genera(etiq, ef, null_nv, null_nv);
        gc_sents(p.scond_esents);
        -- codi esperat:
        -- if t=fals goto efals
        --  sents_if
        --  goto efi
        -- efals: skip
        --  sents_else
        -- efi: skip
      else 
        efi:= ef; 
        -- codi esperat:
        -- if t=fals goto efi
        --  sents_if
        -- efi: skip
      end if;
      genera(etiq, efi, null_nv, null_nv);
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
      genera(call, num_var(d.np), null_nv, null_nv);
    else
      genera(call, num_var(p.ref_id.iproc_np), null_nv, null_nv);
    end if;
  end gc_scrida;

  procedure gc_scrida_args(nod_lexpr: in pnode) is
    p: pnode renames nod_lexpr;
    r: num_var;
    d: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_scrida_args",tnode'Image(p.tn));
    end if;
    if p.lexpr_cont.tn /= nd_null then
      gc_scrida_args(p.lexpr_cont);
    end if;
    gc_expressio(p.lexpr_expr, r, d);

    if DEBUG then
      missatges_gc_debugging("gc_scrida_args","r="&num_var'Image(r)&"::"&"d="&despl'Image(d));
    end if;

    if d = 0 then
      genera(params, r, null_nv, null_nv);
    else
      genera(paramc, r, d, null_nv);
    end if;

  end gc_scrida_args;


  procedure gc_sassign(nd_sassign: in pnode) is
    p: pnode renames nd_sassign;
    r,r1,t,dv: num_var;
    d,d1,dc: despl;
  begin
    gc_ref(p.sassign_ref, r, d); 
    gc_expressio(p.sassign_expr, r1, d1);
    if d = 0 then
      if d1 = 0 then
        genera(cp, r, r1, null_nv);
        -- r:= r1
      else
        genera(cons_idx, r, r1, d1);
        -- r:= r1[d]
      end if;
    else
      if d1 = 0 then
        genera(cp_idx, r, d, r1);
        -- r[d]:= r1
      else
        desref(r1, d1, t);
        genera(cp_idx, r, d, t);
        -- t:= r1[d1]
        -- r[d]:= t
      end if;
    end if;
  end gc_sassign;

  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_ref;
    dc: despl;
    t,t1,dv: num_var;
  begin
    gc_ref_id(p.ref_id, r, dc, dv);
    if p.ref_qs.tn /= nd_null then
      gc_ref_qs(p.ref_qs, dc, dv);
    end if;
    if dc = 0 and then dv = 0 then
      -- r:= r -- ja li hem posat el valor a gc_ref_id
      d:= 0;
    elsif dc = 0 and then dv /= 0 then
      -- r:= r -- idem cas anterior
      d:= despl(dv);
    elsif dc /= 0 and then dv = 0 then
      t:= nova_var_const(valor(dc), tsb_ent);
      if DEBUG then
        missatges_gc_debugging("gc_ref","invc:"&num_var'Image(t));
      end if;
      -- r:= r -- idem
      d:= despl(t);
    else -- dc /= 0 and dv /= 0
      t:= nova_var_const(valor(dc), tsb_ent);
      if DEBUG then
        missatges_gc_debugging("gc_ref","invc:"&num_var'Image(t));
      end if;
      t1:= nova_var;
      genera(sum, t1, t, dv);
      -- r:= r --idem
      d:= despl(t1);
    end if;
  end gc_ref;

  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; dv: out num_var) is
    p: pnode renames nd_id;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_ref_id",tnode'Image(p.tn));
    end if;
    if p.tn = nd_var then
      r:= p.var_nv;
    else -- p.tn = nd_iproc (otherwise, cataplum)
      r:= num_var(p.iproc_np);
    end if;
    dc:= 0; -- var nul·la
    dv:= 0;
  end gc_ref_id;

  procedure gc_ref_qs(nd_qs: in pnode; dc: in out despl; dv: in out num_var) is
    p: pnode renames nd_qs;
    t,t1,t2: num_var;
    desp: num_var:= 0;
  begin
    if p.qs_qs.tn /= nd_null then
      gc_ref_qs(p.qs_qs, dc, dv);
    end if;
    if p.qs_q.tn = nd_rec then
      -- subst el casting per un acces a TV(p.qs_q.rec_td) quan s'hagi implementat la TV. Aixo es sols per compilar !!!
      dc:= dc + despl(p.qs_q.rec_td);
    else -- p.qs_q.tn = nd_arry
      gc_ref_lexpr(p.qs_q.arry_lexpr, desp);
      t:= nova_var;
      genera(res, t, desp, p.qs_q.arry_tb);
      t1:= nova_var;
      genera(mul, t1, t, p.qs_q.arry_tw);
      if dv = 0 then
        dv:= t1;
      else
        t2:= nova_var;
        genera(sum, t2, t1, dv);
        dv:= t2;
      end if;
    end if;
  end gc_ref_qs;

  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out num_var) is
    p: pnode renames nd_lexpr;
    r,t,t1,te: num_var;
    d: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_expressio",tnode'Image(p.tn));
    end if;
    if p.lexpra_cont.tn /= nd_null then
      gc_ref_lexpr(p.lexpra_cont, desp);
    end if;
    if desp /= 0 then
      t:= nova_var; t1:= nova_var; 
      genera(mul, t, desp, p.lexpra_tu);
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      genera(sum, t1, t, te);
      desp:= t1;
    else
      t:= nova_var;
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      genera(cp, t, te, null_nv);
      desp:= t;
    end if;
    if DEBUG then
      missatges_gc_debugging("gc_ref_lexpr","despl:"&num_var'Image(desp));
    end if;
  end gc_ref_lexpr;

  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_expr;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_expressio",tnode'Image(p.tn)&"::"&tnode'Image(p.expr_e.tn));
    end if;
    case p.expr_e.tn is
      when nd_and => 
        gc_and(p.expr_e, r, d);
      when nd_or =>
        gc_or(p.expr_e, r, d);
      when nd_e2 | nd_op_rel => -- cercar un nom mes cool x)
        gc_e2(p.expr_e, r, d);
      when others =>
        -- Comprovacio de tipus...
        null;
    end case;
  end gc_expressio;

  procedure gc_and(nod_and: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nod_and;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_and",tnode'Image(p.tn));
    end if;
    if p.e_ope.tn = nd_and then
      gc_and(p.e_ope, r1, d1);
    else 
      gc_e2(p.e_ope, r1, d1);
    end if;
    desref(r1, d1, t1);
    gc_e2(p.e_opd, r1, d1);
    desref(r1, d1, t2);
    t:= nova_var;
    genera(op_and, t, t1, t2);
    r:= t;
    d:= 0;
  end gc_and;

  procedure gc_or(nod_or: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nod_or;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_or",tnode'Image(p.tn));
    end if;
    if p.e_ope.tn = nd_or then
      gc_or(p.e_ope, r1, d1);
    else
      gc_e2(p.e_ope, r1, d1);
    end if;
    desref(r1, d1, t1);
    gc_e2(p.e_opd, r1, d1);
    desref(r1, d1, t2);
    t:= nova_var;
    genera(op_or, t, t1, t2);
    r:= t;
    d:= 0;
  end gc_or;

  procedure gc_e2(nd_e2: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_e2;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_e2",tnode'Image(p.tn));
    end if;
    if p.e2_operand = nul then
      gc_e3(p.e2_opd, r, d);
    elsif p.e2_operand = neg_alg or p.e2_operand = neg_log then
      gc_e3(p.e2_opd, r1, d1);
      desref(r1, d1, t); 
      if p.e2_operand = neg_alg then
        genera(neg, t, null_nv, null_nv);
      else
        genera(op_not, t, null_nv, null_nv);
      end if;
      r:= t; 
      d:= 0;
    else
      gc_e2(p.e2_ope, r1, d1);
      desref(r1, d1, t1);
      gc_e2(p.e2_opd, r1, d1);
      desref(r1, d1, t2);
      t:= nova_var;
      case p.e2_operand is
        when major =>
          genera(gt, t, t1, t2);
        when majorigual =>
          genera(ge, t, t1, t2);
        when igual =>
          genera(eq, t, t1, t2);
        when diferent =>
          genera(neq, t, t1, t2);
        when menorigual =>
          genera(le, t, t1,  t2);
        when menor =>
          genera(lt, t, t1, t2);
        when sum =>
          genera(sum, t, t1, t2);
        when res =>
          genera(res, t, t1, t2);
        when prod =>
          genera(mul, t, t1, t2);
        when quoci =>
          genera(div, t, t1, t2);
        when modul =>
          genera(modul, t, t1, t2);
        when others =>
          null;
      end case;
      r:= t;
      d:= 0;
    end if;
  end gc_e2;

  procedure gc_e3(nd_e3: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_e3;
    t: num_var;
  begin
    if DEBUG then
      missatges_gc_debugging("gc_e3",tnode'Image(p.tn)&"=>"&tnode'Image(p.e3_cont.tn));
    end if;
    case p.e3_cont.tn is
      when nd_ref =>
        gc_ref(p.e3_cont, r, d);
      when nd_expr =>
        gc_expressio(p.e3_cont, r, d);
      when nd_lit =>
        if DEBUG then
          missatges_gc_debugging("gc_e3",tipus_subjacent'Image(p.e3_cont.lit_tipus)&"::"&id_str'Image(p.e3_cont.lit_ids));
        end if;
        if p.e3_cont.lit_tipus /= tsb_ent then -- es un string, aixo es temporal, senzillament no se que fer amb ells
          t:= nova_var;
          genera(cp, t, decls.d_tnoms.get(tn, p.e3_cont.lit_ids), null_nv);
        else
          t:= nova_var_const(valor'Value(decls.d_tnoms.get(tn, p.e3_cont.lit_ids)), p.e3_cont.lit_tipus);
          if DEBUG then
            missatges_gc_debugging("gc_e3","invc:"&num_var'Image(t));
          end if;
        end if;
        r:= t;
        d:= 0;
      when others =>
        null;
    end case;
  end gc_e3;

end semantica.g_codi_int;
