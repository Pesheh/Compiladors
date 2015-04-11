with Ada.Text_IO;
with decls.d_tnoms;
package body semantica.g_codi_int is
 
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
  procedure gc_scrida_args(nd_qs: in pnode);
  procedure gc_sassign(nd_sassign: in pnode);
  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out despl);
  procedure gc_ref_id(nd_id: in pnode; r: out num_var; idt: out id_nom; dc: out despl; dv: out num_var);
  procedure gc_ref_qs(nd_qs: in pnode; idt: in out id_nom; dc: in out despl; dv: in out num_var);
  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out despl; it: in out iterador_index);
  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out despl);
  procedure gc_and(n_and: in pnode; r: out num_var; d: out despl);
  procedure gc_or(n_or: in pnode; r: out num_var; d: out despl);
  procedure gc_e2(nd_e2: in pnode; r: out num_var; d: out despl);
  procedure gc_e3(nd_e3: in pnode; r: out num_var; d: out despl);


  function nova_var(np: num_proc; ocup: ocupacio; desp: despl) return num_var is
  begin
		-- pendent d'ampliar
    nv:= nv+1;
		return nv;
  end nova_var;

  function nova_var_const(val: valor; tsb: tipus_subjacent) return num_var is
  begin
		-- pendent d'ampliar
    nv:= nv+1;
		return nv;
  end nova_var_const;


  function nova_etiq return etiqueta is
  begin
    ne:= ne+1;
    return ne;
  end nova_etiq;

  -- El format es temporal
  procedure genera(t: in tinstruccio; a,b,c: in num_var) is
  begin
    Ada.Text_IO.Put_Line(tinstruccio'Image(t)&""&num_var'Image(a)&""&num_var'Image(b)&""&num_var'Image(c));
  end genera;

  procedure genera(t: in tinstruccio; a: in etiqueta; b,c: in num_var) is
  begin
    Ada.Text_IO.Put_Line(tinstruccio'Image(t)&""&etiqueta'Image(a)&""&num_var'Image(b)&""&num_var'Image(c));
  end genera;

  procedure genera(t: in tinstruccio; a: in num_var; b: in String; c: in num_var) is
  begin
    Ada.Text_IO.Put_Line(tinstruccio'Image(t)&""&num_var'Image(a)&""&b&""&num_var'Image(c));
  end genera;

  procedure desref(r: in num_var; d: in despl; t: out num_var) is
  begin
    if d=0 then
     t:= r;
    else
     t:= nova_var;
     genera(cons_idx,t,r,num_var(d));
    end if;
  end desref;

  procedure g_codi_int is
  begin
    if root.p /= null then
      gc_proc(root.p);
    end if;
  end g_codi_int;

  procedure gc_proc(nd_proc: in pnode) is
    p: pnode renames nd_proc;
  begin
    if p.proc_cproc /= null then
      gc_cproc(p.proc_cproc); -- realment no es gaire necessari aixo, de moment
    else
      null;
      -- error molt gros
    end if;
    if p.proc_decls /= null then
      gc_decls(p.proc_decls);
    end if;
    if p.proc_sents /= null then
      gc_sents(p.proc_sents);
    end if;
    genera(rtn,num_var(p.proc_cproc.cproc_id.id_id),0,0);
  end gc_proc;

  procedure gc_cproc(nd_cproc: in pnode) is
    p: pnode renames nd_cproc;
    nargs: natural;
    e: etiqueta;
  begin
    nargs:= 0; -- usat a la taula de procediments
    if p.cproc_args /= null then
      gc_args(p.cproc_args, nargs);
    end if;
    e:= nova_etiq; genera(etiq,e,0,0); genera(pmb,num_var(np),0,0);
  end gc_cproc;

  procedure gc_args(nd_args: in pnode; nargs: out natural) is
    p: pnode renames nd_args;
  begin
    if p.args_args /= null then
      gc_args(p.args_args, nargs);
    end if;
    nargs:= nargs+1;
  end gc_args;

  procedure gc_decls(nd_decls: in pnode) is
    p: pnode renames nd_decls;
  begin
    null; -- cal generar codi intermitg per a les declaracions?
  end gc_decls;

  procedure gc_sents(nd_sents: in pnode) is
  begin
    gc_sent(nd_sents.sents_cont);
  end gc_sents;

  procedure gc_sent(nd_sent: in pnode) is
    p: pnode;
  begin
    p:= nd_sent;
    if p.snb_snb /= null then
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
        -- hello, comprovacio de tipus!?! -_-
        null;
    end case;
  end gc_sent;

  procedure gc_siter(nd_siter: in pnode) is
    p: pnode renames nd_siter;
    ei,ef: etiqueta;
    r,t: num_var;
    d: despl;
  begin
    ei:= nova_etiq;
    genera(etiq,ei,0,0);
    gc_expressio(p.siter_expr,r,d);
    desref(r,d,t);
    ef:= nova_etiq;
    genera(eq,ef,t,fals);
    gc_sents(p.siter_sents);
    genera(go_to,ei,0,0);
    genera(etiq,ef,0,0);
  end gc_siter;

  procedure gc_scond(nd_scond: in pnode) is
    p: pnode renames nd_scond;
    ef,efi: etiqueta;
    r,t: num_var;
    d: despl;
  begin
    gc_expressio(p.scond_expr,r,d);
    desref(r,d,t);
    ef:= nova_etiq;
    genera(eq,ef,t,fals);
    gc_sents(p.scond_sents);
    if p.scond_esents /= null then
      efi:= nova_etiq;
      genera(go_to,efi,0,0);
      genera(etiq,ef,0,0);
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
    genera(etiq,efi,0,0);
  end gc_scond;

  procedure gc_scrida(nd_cproc: in pnode) is
    p: pnode renames nd_cproc;
    d: descripcio;
  begin
    d:= get(ts,p.ref_id.id_id);
    if p.ref_qs /= null then
      gc_scrida_args(p.ref_qs);
    end if;
    genera(call,num_var(d.np),0,0);
  end gc_scrida;

  procedure gc_scrida_args(nd_qs: in pnode) is
    p: pnode renames nd_qs;
    r: num_var;
    d: despl;
  begin
    if p.qs_qs /= null then
      gc_scrida_args(p.ref_qs);
    end if;
    gc_expressio(p.qs_q.q_contingut,r,d);
    if d = 0 then
      genera(params,r,0,0);
    else
      genera(paramc,r,num_var(d),0);
    end if;
  end gc_scrida_args;

  procedure gc_sassign(nd_sassign: in pnode) is
    p: pnode renames nd_sassign;
    r,r1,t,dv: num_var;
    d,d1,dc: despl;
  begin
    gc_ref(p.sassign_ref,r,d); 
    gc_expressio(p.sassign_expr,r1,d1);
    if d = 0 then
      if d1 = 0 then
        genera(cp,r,r1,0);
        -- r:= r1
      else
        genera(cons_idx,r,r1,num_var(d1));
        -- r:= r1[d]
      end if;
    else
      if d1 = 0 then
        genera(cp_idx,r,num_var(d),r1);
        -- r[d]:= r1
      else
        desref(r1,d1,t);
        genera(cp_idx,r,num_var(d),t);
        -- t:= r1[d1]
        -- r[d]:= t
      end if;
    end if;
  end gc_sassign;

  procedure gc_ref(nd_ref: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_ref;
    dc: despl;
    t,t1,dv: num_var;
    idt: id_nom;
  begin
    gc_ref_id(p.ref_id,r,idt,dc,dv);
    if p.ref_qs /= null then
      gc_ref_qs(p.ref_qs,idt,dc,dv);
    end if;
    if dc = 0 and then dv = 0 then
      -- r:= r -- ja li hem posat el valor a gc_ref_id
      d:= 0;
    elsif dc = 0 and then dv /= 0 then
      -- r:= r -- idem cas anterior
      d:= despl(dv);
    elsif dc /= 0 and then dv = 0 then
      t:= nova_var_const(valor(dc),tsb_ent);
      -- r:= r -- idem
      d:= despl(t);
    else -- dc /= 0 and dv /= 0
      t:= nova_var_const(valor(dc),tsb_ent);
      t1:= nova_var;
      genera(sum,t1,t,dv);
      -- r:= r --idem
      d:= despl(t1);
    end if;
  end gc_ref;

  procedure gc_ref_id(nd_id: in pnode; r: out num_var; idt: out id_nom; dc: out despl; dv: out num_var) is
    p: pnode renames nd_id;
    d: descripcio;
  begin
    d:= get(ts,p.id_id);
    r:= d.nv;
    idt:= d.tv;
    dc:= 0; -- var nul·la
    dv:= 0;
  end gc_ref_id;

  procedure gc_ref_qs(nd_qs: in pnode; idt: in out id_nom; dc: in out despl; dv: in out num_var) is
    p: pnode renames nd_qs;
    it: iterador_index;
    b: natural;
    t,t1,t2,tw,tb: num_var;
    w: despl;
    desp: despl:= 0;
    dt,dtc,dca: descripcio;
  begin
    if p.qs_qs /= null then
      gc_ref_qs(p.qs_qs,idt,dc,dv);
    end if;
    if p.qs_q.tn = nd_id then
      dca:= get_camp(ts,idt,p.qs_q.q_contingut.id_id);
      idt:= dca.tcmp;
      dc:= dc + dca.dcmp;
    else -- p.qs_q.tn = nd_lexpr
      first(ts,idt,it);
      gc_ref_lexpr(p.qs_q,desp,it);
      dt:= get(ts,idt);
      b:= dt.dt.b; 
      idt:= dt.dt.tcomp;
      dtc:= get(ts,idt);
      w:= dtc.dt.ocup;
      tw:= nova_var_const(valor(w),tsb_ent); tb:= nova_var_const(valor(b),tsb_ent);
      t:= nova_var;
      genera(res,t,num_var(desp),tb);
      t1:= nova_var;
      genera(mul,t1,t,tw);
      if dv = 0 then
        dv:= t1;
      else
        t2:= nova_var;
        genera(sum,t2,t1,dv);
        dv:= t2;
      end if;
    end if;
  end gc_ref_qs;

  procedure gc_ref_lexpr(nd_lexpr: in pnode; desp: in out despl; it: in out iterador_index) is
    p: pnode renames nd_lexpr;
    dindx,dtindx: descripcio;
    u: valor;
    r,t,t1,te,tu: num_var;
    d: despl;
  begin
    if p.lexpr_cont /= null then
      gc_ref_lexpr(p.lexpr_cont,desp,it);
    end if;
    dindx:= get(ts,it); next(ts,it);
    dtindx:= get(ts,dindx.tind);
    u:= dtindx.dt.lsup - dtindx.dt.linf + 1;
    tu:= nova_var_const(u,tsb_ent);
    t:= nova_var; t1:= nova_var;
    genera(mul,t,num_var(desp),tu);
    gc_expressio(p.lexpr_expr,r,d);
    desref(r,d,te);
    genera(sum,t1,t,te);
    desp:= despl(t1);
  end gc_ref_lexpr;

  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_expr;
  begin
    case p.expr_e.tn is
      when nd_and => 
        gc_and(p.expr_e,r,d);
      when nd_or =>
        gc_or(p.expr_e,r,d);
      when nd_e2 => -- cercar un nom mes cool x)
        gc_e2(p.expr_e,r,d);
      when others =>
        -- Comprovacio de tipus...
        null;
    end case;
  end gc_expressio;

  procedure gc_and(n_and: in pnode; r: out num_var; d: out despl) is
    p: pnode renames n_and;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if p.e_ope.tn = nd_and then
      gc_and(p.e_ope,r1,d1);
    else 
      gc_e2(p.e_ope,r1,d1);
    end if;
    desref(r1,d1,t1);
    gc_e2(p.e_opd,r1,d1);
    desref(r1,d1,t2);
    t:= nova_var;
    genera(op_and,t,t1,t2);
    r:= t;
    d:= 0;
  end gc_and;

  procedure gc_or(n_or: in pnode; r: out num_var; d: out despl) is
    p: pnode renames n_or;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if p.e_ope.tn = nd_or then
      gc_and(p.e_ope,r1,d1);
    else
      gc_e2(p.e_ope,r1,d1);
    end if;
    desref(r1,d1,t1);
    gc_e2(p.e_opd,r1,d1);
    desref(r1,d1,t2);
    t:= nova_var;
    genera(op_or,t,t1,t2);
    r:= t;
    d:= 0;
  end gc_or;

  procedure gc_e2(nd_e2: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_e2;
    t,t1,t2: num_var;
    r1: num_var;
    d1: despl;
  begin
    if p.tn = nd_op_rel then
      gc_e2(p.orel_ope,r1,d1);
      desref(r1,d1,t1);
      gc_e3(p.orel_opd,r1,d1);
      desref(r1,d1,t2);
      t:= nova_var;
      case p.orel_tipus is
        when major =>
          genera(gt,t,t1,t2);
        when majorigual =>
          genera(ge,t,t1,t2);
        when igual =>
          genera(eq,t,t1,t2);
        when diferent =>
          genera(neq,t,t1,t2);
        when menorigual =>
          genera(le,t,t1,t2);
        when menor =>
          genera(lt,t,t1,t2);
      end case;
      r:= t;
      d:= 0;
    else
      if p.e2_operand = nul then
          gc_e3(p.e2_opd,r1,d1);
      elsif p.e2_operand = neg_alg or p.e2_operand = neg_log then
          gc_e3(p.e2_opd,r1,d1);
          desref(r1,d1,t); -- es necessari?
          if p.e2_operand = neg_alg then
            genera(neg,t,0,0);
          else
            genera(op_not,t,0,0);
          end if;
          r:= t; -- si el desref es necessari, aixo tmb ho es
          d:= 0;
      else
          gc_e2(p.e2_ope,r1,d1);
          desref(r1,d1,t1);
          gc_e3(p.e2_opd,r1,d1);
          desref(r1,d1,t2);
          t:= nova_var;
          case p.e2_operand is
            when sum =>
              genera(sum,t,t1,t2);
            when res =>
              genera(res,t,t1,t2);
            when prod =>
              genera(mul,t,t1,t2);
            when quoci =>
              genera(div,t,t1,t2);
            when modul =>
              genera(modul,t,t1,t2);
            when others =>
              null;
          end case;
          r:= t;
          d:= 0;
      end if;
    end if;
  end gc_e2;

  procedure gc_e3(nd_e3: in pnode; r: out num_var; d: out despl) is
    p: pnode renames nd_e3;
    t: num_var;
  begin
    case p.e3_cont.tn is
      when nd_ref =>
        gc_ref(p.e3_cont,r,d);
      when nd_expr =>
        gc_expressio(p.e3_cont,r,d);
      when nd_lit =>
        t:= nova_var;
        genera(cp,t,decls.d_tnoms.get(tn,p.e3_cont.lit_ids),0);
        r:= t;
        d:= 0;
      when others =>
        null;
    end case;
  end gc_e3;

end semantica.g_codi_int;
