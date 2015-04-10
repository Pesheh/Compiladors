with ada.text_io; use ada.text_io;
with decls.d_descripcio;
with decls.d_atribut;
with d_stack; use d_stack;
package body semantica.c_arbre is

  st: stack;

  -- Rutina de control
 
  procedure r_atom(a: out atribut) is
  begin
   a:= new node(nd_null); 
  end r_atom;

  -- Rutines lèxiques 
  
  procedure rl_identifier(a: out atribut; pos: in posicio; text: in String) is
    id: id_nom;
  begin
    put(tn,text,id);
    a:= new node(nd_id);
    a.id_pos:= pos; a.id_id:= id;
  end rl_identifier;


  procedure rl_literal(a: out atribut; pos: in posicio; text: in String; tipus: in decls.d_descripcio.tipus_subjacent) is 
    ids: id_str;
  begin
    put(tn,text,ids);
    a:= new node(nd_lit);
    a.lit_pos:= pos; a.lit_ids:= ids;
    a.lit_tipus:=tipus;
  end rl_literal;


  procedure rl_op_menor(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= menor; a.orel_ope:= null; a.orel_opd:= null;
    push(st,menor);
  end rl_op_menor;
  

  procedure rl_op_major(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= major; a.orel_ope:= null; a.orel_opd:= null;
    push(st,major);
 end rl_op_major;
  

  procedure rl_op_menorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= menorigual; a.orel_ope:= null; a.orel_opd:= null;
    push(st,menorigual); 
  end rl_op_menorigual;
  

  procedure rl_op_majorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= majorigual; a.orel_ope:= null; a.orel_opd:= null;
    push(st,majorigual);
  end rl_op_majorigual;
  

  procedure rl_op_igual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= igual; a.orel_ope:= null; a.orel_opd:= null;
    push(st,igual);
  end rl_op_igual;
  

  procedure rl_op_diferent(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= diferent; a.orel_ope:= null; a.orel_opd:= null;
    push(st,diferent);
  end rl_op_diferent;


  -- Rutines sintàctiques
  
  procedure rs_Root(proc: in atribut) is
  begin
      empty(tn);
      empty(ts);
      root:= new node(nd_root);
      root.p:=proc;
  end rs_Root;
  
  procedure rs_Proc(proc: out atribut; cproc: in atribut; decls: in atribut; sents: in atribut) is
  begin
      proc:= new node(nd_proc);
      proc.proc_cproc:= cproc;
      proc.proc_decls:= decls;
      proc.proc_sents:= sents;
  end rs_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut; args: in atribut) is
  begin
      cproc:= new node(nd_c_proc);
      cproc.cproc_id:= proc_id;
      cproc.cproc_args:= args;
  end rs_C_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut) is
  begin
      cproc:= new node(nd_c_proc);
      cproc.cproc_id:= proc_id;
      cproc.cproc_args:= null;
  end rs_C_Proc;


  procedure rs_Args(args: out atribut; args_seg: in atribut; arg: in atribut) is
  begin
      args:= new node(nd_args);
      args.args_args:= args_seg;
      args.args_arg:= arg;
  end rs_Args;


  procedure rs_Args(args: out atribut; arg: in atribut) is
  begin
      args:= new node(nd_args);
      args.args_args:= null;
      args.args_arg:= arg;
  end rs_Args;


  procedure rs_Arg(arg: out atribut;lid: in atribut; mode: in atribut; tipus: in atribut) is
  begin 
      arg:= new node(nd_arg);
      arg.arg_lid:= lid;
      arg.arg_mode:= mode.mode_tipus;
      arg.arg_tipus:= tipus;
  end rs_Arg;


  procedure rs_Mode(mode: out atribut; tipus: in tmode) is
  begin
    mode:= new node(nd_mode);
    mode.mode_tipus:= tipus;
  end rs_Mode;


  -- Declaracions

  procedure rs_Decls(decls: out atribut; decls_seg: in atribut; decl: atribut) is
  begin
      decls:= new node(nd_decls);
      decls.decls_decls:= decls_seg;
      decls.decls_decl:= decl;
  end rs_Decls;
 
  
  procedure rs_Decl(decl: out atribut; decl_real: in atribut) is
  begin
      decl:=new node(nd_decl);
      decl.decl_real:= decl_real;
  end rs_Decl;


  procedure rs_Decl_Var(decl: out atribut; lista_id: in atribut; tipus: in atribut) is
  begin
      decl:= new node(nd_decl_var);
      decl.dvar_lid:= lista_id;
      decl.dvar_tipus:= tipus;
  end rs_Decl_Var;
  
 
  procedure rs_Decl_Const(decl: out atribut; lid_const: in atribut; tipus: in atribut; valor: in atribut) is
  begin
      decl:= new node(nd_decl_const);
      decl.dconst_lid:= lid_const;
      decl.dconst_tipus:= tipus;
      decl.dconst_valor:= valor;
  end rs_Decl_Const;
  
  
  procedure rs_Idx(idx: out atribut; idx_cont: in atribut; signe: in tidx) is
  begin
      idx:= new node(nd_idx);
      idx.idx_cont:= idx_cont;
      idx.idx_tipus:= signe; -- << comentat a d_atribut
  end rs_Idx;


  procedure rs_Idx_Cont(idx_cont: out atribut; valor: in atribut) is
  begin
      idx_cont:= new node(nd_idx_cont);
      idx_cont.idxc_valor:= valor;
  end rs_Idx_Cont;


  procedure rs_Decl_T(decl: out atribut; id_type: in atribut; decl_cont: in atribut) is
  begin
      decl:= new node(nd_decl_t);
      decl.dt_id:= id_type;
      decl.dt_cont:= decl_cont;
  end rs_Decl_T;


  procedure rs_Decl_T_Cont(decl: out atribut; info: in atribut) is
  begin
      case info.tn is
          when nd_rang  =>
              decl:= new node(nd_decl_t_cont_type);
              decl.dtcont_rang:= info;

          when nd_dcamps    =>
              decl:= new node(nd_decl_t_cont_record);
              decl.dtcont_camps:= info;
        when others =>
          null; -- ERROR

      end case;
  end rs_Decl_T_Cont;

  
  procedure rs_Decl_T_Cont(decl: out atribut; rang_array: in atribut; tipus_array: in atribut) is
  begin
      decl:= new node(nd_decl_t_cont_arry);
      decl.dtcont_idx:= rang_array;
      decl.dtcont_tipus:= tipus_array;
  end rs_Decl_T_Cont;


  procedure rs_DCamps(camps: out atribut; camp_seg: in atribut; camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);
    camps.dcamps_dcamps:= camp_seg;
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;


  procedure rs_DCamps(camps: out atribut; camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);
    camps.dcamps_dcamps:= null;
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;



  procedure rs_DCamp(camp: out atribut; var: in atribut) is
  begin
    camp:= new node(nd_dcamp);
    camp.dcamp_decl:= var;
  end rs_DCamp;


  -- Sentencia

  procedure rs_Sents(sents: out atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents);
    sents.sents_cont:= sent;
  end rs_Sents;


  procedure rs_Sent_Nob(sents: out atribut; sent_cont: in atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents_nob);
    sents.snb_snb:= sent_cont;
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent_Nob(sents: out atribut; sent: in atribut) is 
  begin
    sents:= new node(nd_sents_nob);
    sents.snb_snb:= null;
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent(sent: out atribut; stipus: in atribut) is
  begin
    sent:= new node(nd_sent);
    sent.sent_sent:= stipus;
  end rs_Sent;

  
  procedure rs_SIter(sent: out atribut; expr: in atribut; sents: in atribut) is
    begin
        sent:= new node(nd_siter);
        sent.siter_expr:= expr;
        sent.siter_sents:= sents;
    end rs_SIter;


  procedure rs_SCond(sent: out atribut; expr: in atribut; sents: in atribut) is
  begin
    sent:= new node(nd_scond);
    sent.scond_expr:= expr;
    sent.scond_sents:= sents;
    sent.scond_esents:= null;
  end rs_SCond;
  

  procedure rs_SCond(sent: out atribut; expr: in atribut; sents_if: in atribut; sents_else: in atribut) is
  begin
    sent:= new node(nd_scond);
    sent.scond_expr:= expr;
    sent.scond_sents:= sents_if;
    sent.scond_esents:= sents_else;
  end rs_SCond;
  
  
    procedure rs_SCrida(sent: out atribut; ref: in atribut) is
  begin
    sent:= new node(nd_scrida);
    sent.scrida_ref:= ref;
  end rs_SCrida;
  

  procedure rs_SAssign(sent: out atribut; ref: in atribut; expr: in atribut) is 
  begin
    sent:= new node(nd_sassign);
    sent.sassign_ref:= ref;
    sent.sassign_expr:= expr;
  end rs_SAssign;


  -- Expressio

  procedure rs_LExpr(lexpr: out atribut; cont: in atribut; expr: in atribut) is
  begin
    lexpr:= new node(nd_lexpr);
    lexpr.lexpr_cont:= cont;
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_LExpr(lexpr: out atribut; expr: in atribut) is
  begin
    lexpr:= new node(nd_lexpr);
    lexpr.lexpr_cont:= null;
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_Expr(expr: out atribut; cont: in atribut) is
  begin
    expr:= new node(nd_expr);
    expr.expr_e:= cont;
  end rs_Expr;


  procedure rs_EAnd(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_and);
    expr.e_ope:= ee;
    expr.e_opd:= ed;
  end rs_EAnd;


  procedure rs_EOr(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_or);
    expr.e_ope:= ee;
    expr.e_opd:= ed;
  end rs_EOr;


	--Rutines semàntiques auxiliars 

  procedure rs_E2o(expr: out atribut; ee: in atribut; ed:in atribut) is
  begin
   expr:= new node(nd_op_rel);
   expr.orel_tipus:= top(st); pop(st);
   expr.orel_ope:= ee;
   expr.orel_opd:= ed;
  end rs_E2o;


  procedure rs_E2s(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.sum;
  end rs_E2s;


  procedure rs_E2r(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.res;
  end rs_E2r;
  

  procedure rs_E2p(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.prod;
  end rs_E2p;


  procedure rs_E2q(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.quoci;
  end rs_E2q;


  procedure rs_E2m(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.modul;
  end rs_E2m;

  
  procedure rs_E2nl(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= null;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.neg_log;
  end rs_E2nl;
  
  
  procedure rs_E2na(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= null;
    expr.e2_opd:= ed;
    expr.e2_operand:= decls.d_atribut.neg_alg;
  end rs_E2na;

  
  procedure rs_E2(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);
    expr.e2_ope:= null;
    expr.e2_opd:= ed;
    expr.e2_operand:= nul;
  end rs_E2;


  procedure rs_E3(expr: out atribut; e: in atribut) is
  begin
    expr:= new node(nd_e3);
    expr.e3_cont:= e;
  end rs_E3;


  -- Altres

  procedure rs_Lid(lid: out atribut; id_seg: in atribut; id: in atribut) is
  begin
    lid:= new node(nd_lid);
    lid.lid_seg:= id_seg;
    lid.lid_id:= id;
  end rs_Lid;
  
  procedure rs_Lid(lid: out atribut;  id: in atribut) is
  begin
    lid:= new node(nd_lid);
    lid.lid_seg:= null;
    lid.lid_id:= id;
  end rs_Lid;


  procedure rs_Ref(ref: out atribut; ref_id: in atribut; qs: in atribut) is
  begin
      ref:= new node(nd_ref);
      ref.ref_id:= ref_id;
      ref.ref_qs:= qs;
  end rs_Ref;

procedure rs_Qs(qs: out atribut; qs_in: in atribut; q: in atribut) is
  begin
      qs:= new node(nd_qs);
      qs.qs_qs:= qs_in;
      qs.qs_q:= q;
  end rs_Qs;


  procedure rs_Q(q: out atribut; contingut: in atribut) is
  begin
      q:= new node(nd_q);
      q.q_contingut:= contingut;
  end rs_Q;
  
  procedure rs_Rang(rang: out atribut;id_type: in atribut; linf: in atribut; lsup: in atribut) is
  begin
    rang:=new node(nd_rang);
    rang.rang_id:=id_type.id_id;
    rang.rang_linf:=linf;
    rang.rang_lsup:=lsup;
  end rs_Rang;

end semantica.c_arbre;
