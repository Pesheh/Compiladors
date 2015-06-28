with Ada.Sequential_IO;
with d_pila;
with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with decls.d_arbre; use decls.d_arbre;
with decls.d_c3a; use decls.d_c3a;
package semantica is

  procedure prepara_analisi(nomf: in String);

private

  tn: tnoms;
  ts: tsimbols;

  root: pnode;

  nv: num_var;
  np: num_proc;
  ne: num_etiq;

  tv: tvariables;
  tp: tprocediments;

  ERROR: boolean;

  package Instruccio_IO is new Ada.Sequential_IO(instr_3a_bin);
  package Pila_Procediments is new D_Pila(max_proc, elem => num_proc);

  pproc: Pila_Procediments.pila;
  
end semantica;



with semantica.missatges;
with semantica.c_tipus;
with semantica.g_codi_int;
with semantica.g_codi_ass;
package body semantica is

  procedure prepara_analisi(nomf: in String) is
    cert, fals: num_var;
  begin

    empty(tn);
    empty(ts);

    nv:= null_nv;
    np:= null_np;
    ne:= null_ne;

    ERROR:= false;

    semantica.c_tipus.posa_entorn_standard(cert, fals);
    semantica.g_codi_int.prepara_g_codi_int(nomf, cert, fals);
    semantica.g_codi_ass.prepara_g_codi_ass(nomf);
  end prepara_analisi;

end semantica;


with decls.d_descripcio;
package semantica.c_arbre is

  -- Rutines de control
  procedure rl_atom(a: out atribut);
  procedure rs_atom(a: out atribut);


  -- Rutines Fonamentals
  procedure rl_identifier(a: out atribut; pos: in posicio; text: in String);
  procedure rl_literal_ent(a: out atribut; pos: in posicio; text: in String);
  procedure rl_literal_car(a: out atribut; pos: in posicio; text: in String);
  procedure rl_literal_str(a: out atribut; pos: in posicio; text: in String);


  -- Operadors relacionals
  procedure rl_op_menor(a: out atribut);
  procedure rl_op_major(a: out atribut);
  procedure rl_op_menorigual(a: out atribut);
  procedure rl_op_majorigual(a: out atribut);
  procedure rl_op_igual(a: out atribut);
  procedure rl_op_diferent(a: out atribut);


  -- Procediment
  procedure rs_Root(proc: in atribut);
  procedure rs_Proc(proc: out atribut; cproc: in atribut; decls: in atribut; 
                    sents: in atribut);
  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut; 
                      args: in atribut);
  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut);
  procedure rs_Args(args: out atribut; args_seg: in atribut; arg: in atribut);
  procedure rs_Args(args: out atribut; arg: in atribut);
  procedure rs_Arg(arg: out atribut; lid: in atribut; mode: in atribut; 
                   tipus: in atribut);
  procedure rs_Mode_in(mode: out atribut);
  procedure rs_Mode_in_out(mode: out atribut);


  -- Declaracio
  procedure rs_Decls(decls: out atribut; decls_seg: in atribut; 
                     decl: in atribut);
  procedure rs_Decl(decl: out atribut; decl_real: in atribut);
  procedure rs_Decl_Var(decl: out atribut; lista_id: in atribut; 
                        tipus: in atribut);
  procedure rs_Decl_Const(decl: out atribut; lid_const: in atribut; 
                          tipus: in atribut; valor: in atribut);
  procedure rs_Idx_neg(idx: out atribut; idx_cont: in atribut);
  procedure rs_Idx_pos(idx: out atribut; idx_cont: in atribut);
  procedure rs_Idx_Cont(idx_cont: out atribut; valor: in atribut);
  procedure rs_Decl_T(decl: out atribut; id_type: in atribut; 
                      decl_cont: in atribut);
  procedure rs_Decl_T_Cont(decl: out atribut; info: in atribut);
  procedure rs_Decl_T_Cont(decl: out atribut; rang_array: in atribut; 
                           tipus_array: in atribut);
  procedure rs_DCamps(camps: out atribut; camp_seg: in atribut; 
                      camp: in atribut);
  procedure rs_DCamps(camps: out atribut; camp: in atribut);
  procedure rs_DCamp(camp: out atribut; var: in atribut);
  procedure rs_Rang(rang: out atribut; id_type: in atribut; linf: in atribut; 
                    lsup: in atribut);


  -- Sentencia
  procedure rs_Sents(sents: out atribut; sent: in atribut);
  procedure rs_Sent_Nob(sents: out atribut; sent_cont: in atribut;
                        sent: in atribut);
  procedure rs_Sent_Nob(sents: out atribut; sent: in atribut);
  procedure rs_Sent(sent: out atribut; stipus: in atribut);
  procedure rs_SIter(sent: out atribut; expr: in atribut; sents: in atribut);
  procedure rs_SCond(sent: out atribut; expr: in atribut; sents: in atribut);
  procedure rs_SCond(sent: out atribut; expr: in atribut; 
                     sents_if: in atribut; sents_else: in atribut);
  procedure rs_SCrida(sent: out atribut; ref: in atribut);
  procedure rs_SAssign(sent: out atribut; ref: in atribut; expr: in atribut);


  -- Expressio
  procedure rs_LExpr(lexpr: out atribut; cont: in atribut; expr: in atribut);
  procedure rs_LExpr(lexpr: out atribut; expr: in atribut);
  procedure rs_Expr(expr: out atribut; cont: in atribut);
  procedure rs_EAnd(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOr(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpo(expr: out atribut; ee: in atribut; ed: in atribut; 
                    op: in atribut);
  procedure rs_EOps(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpr(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpp(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpq(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpm(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpnl(expr: out atribut; ed: in atribut);
  procedure rs_EOpna(expr: out atribut; ed: in atribut);
  procedure rs_EOp(expr: out atribut; ed: in atribut);
  procedure rs_ET(expr: out atribut; e: in atribut);


  -- Referència
  procedure rs_Ref(ref: out atribut; ref_id: in atribut; qs: in atribut);
  procedure rs_Qs(qs: out atribut; qs_in: in atribut; q: in atribut);
  procedure rs_Q(q: out atribut; contingut: in atribut);


  -- Llistes
  procedure rs_Lid(lid: out atribut; id_seg: in atribut; id: in atribut);
  procedure rs_Lid(lid: out atribut; id: in atribut);


  err,type_error,proc_error,arg_error,record_error,camp_error,array_error,
  var_error,const_error: exception;

end semantica.c_arbre;


with decls.d_descripcio;
with decls.d_arbre;
package body semantica.c_arbre is

  -- Rutines de control

  procedure rl_atom(a: out atribut) is
  begin
    a:= new node(nd_null);
  end rl_atom;


  procedure rs_atom(a: out atribut) is
  begin
    a:= new node(nd_null);
  end rs_atom;

  -- Rutines lèxiques

  procedure rl_identifier(a: out atribut; pos: in posicio; text: in String) 
  is
    id: id_nom;
  begin
    put(tn,text,id);
    a:= new node(nd_id);
    a.id_pos:= pos; a.id_id:= id;
  end rl_identifier;


  procedure rl_literal_ent(a: out atribut; pos: in posicio; text: in String) 
  is
  begin
    a:= new node(nd_lit);
    a.lit_pos:= pos;
    a.lit_val:= valor'Value(text);
    a.lit_tipus:= decls.d_descripcio.tsb_ent;
  end rl_literal_ent;


  procedure rl_literal_car(a: out atribut; pos: in posicio; text: in String) 
  is
  begin
    a:= new node(nd_lit);
    a.lit_pos:= pos;
    a.lit_val:= valor(Character'Pos(text(text'First+1)));
    a.lit_tipus:= decls.d_descripcio.tsb_car;
  end rl_literal_car;


  procedure rl_literal_str(a: out atribut; pos: in posicio; text: in String) 
  is
    ids: id_str;
  begin
    put(tn,text,ids);
    a:= new node(nd_lit);
    a.lit_pos:= pos;
    a.lit_val:= valor(ids);
    a.lit_tipus:= decls.d_descripcio.tsb_nul;
  end rl_literal_str;


  procedure rl_op_menor(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= menor;
  end rl_op_menor;


  procedure rl_op_major(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= major;
  end rl_op_major;


  procedure rl_op_menorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= menorigual;
  end rl_op_menorigual;


  procedure rl_op_majorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= majorigual;
  end rl_op_majorigual;


  procedure rl_op_igual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= igual;
  end rl_op_igual;


  procedure rl_op_diferent(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
    a.orel_tipus:= diferent;
  end rl_op_diferent;


  -- Rutines sintàctiques

  procedure rs_Root(proc: in atribut) is
  begin
    root:= new node(nd_root);
    root.p:=proc;
  end rs_Root;


  procedure rs_Proc(proc: out atribut; cproc: in atribut; decls: in atribut;
                    sents: in atribut) is
  begin
    proc:= new node(nd_proc);
    proc.proc_cproc:= cproc;
    proc.proc_decls:= decls;
    proc.proc_sents:= sents;
  end rs_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut; args: in atribut)
  is
  begin
    cproc:= new node(nd_c_proc);
    cproc.cproc_id:= proc_id;
    cproc.cproc_args:= args;
    cproc.cproc_np:= null_np;
  end rs_C_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut) is
  begin
    cproc:= new node(nd_c_proc);
    cproc.cproc_id:= proc_id;
    cproc.cproc_args:= new node(nd_null);
    cproc.cproc_np:= null_np;
  end rs_C_Proc;


  procedure rs_Args(args: out atribut; args_seg: in atribut; arg: in atribut) 
  is
  begin
    args:= new node(nd_args);
    args.args_args:= args_seg;
    args.args_arg:= arg;
  end rs_Args;


  procedure rs_Args(args: out atribut; arg: in atribut) is
  begin
    args:= new node(nd_args);
    args.args_args:= new node(nd_null);
    args.args_arg:= arg;
  end rs_Args;


  procedure rs_Arg(arg: out atribut; lid: in atribut; mode: in atribut; 
                   tipus: in atribut) is
  begin
    arg:= new node(nd_arg);
    arg.arg_lid:= lid;
    arg.arg_mode:= mode.mode_tipus;
    arg.arg_tipus:= tipus;
  end rs_Arg;


  procedure rs_Mode_in(mode: out atribut) is
  begin
    mode:= new node(nd_mode);
    mode.mode_tipus:= md_in;
  end rs_Mode_in;


  procedure rs_Mode_in_out(mode: out atribut) is
  begin
    mode:= new node(nd_mode);
    mode.mode_tipus:= md_in_out;
  end rs_Mode_in_out;


  -- Declaracions

  procedure rs_Decls(decls: out atribut; decls_seg: in atribut; 
                     decl: in atribut) is
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


  procedure rs_Decl_Var(decl: out atribut; lista_id: in atribut; 
                        tipus: in atribut) is
  begin
    decl:= new node(nd_decl_var);
    decl.dvar_lid:= lista_id;
    decl.dvar_tipus:= tipus;
  end rs_Decl_Var;


  procedure rs_Decl_Const(decl: out atribut; lid_const: in atribut; 
                          tipus: in atribut; valor: in atribut) is
  begin
    decl:= new node(nd_decl_const);
    decl.dconst_lid:= lid_const;
    decl.dconst_tipus:= tipus;
    decl.dconst_valor:= valor;
  end rs_Decl_Const;


  procedure rs_Idx_neg(idx: out atribut; idx_cont: in atribut) is
  begin
    idx:= new node(nd_idx);
    idx.idx_cont:= idx_cont;
    idx.idx_tipus:= negatiu;
  end rs_Idx_neg;


  procedure rs_Idx_pos(idx: out atribut; idx_cont: in atribut) is
  begin
    idx:= new node(nd_idx);
    idx.idx_cont:= idx_cont;
    idx.idx_tipus:= positiu;
  end rs_Idx_pos;


  procedure rs_Idx_Cont(idx_cont: out atribut; valor: in atribut) is
  begin
    idx_cont:= new node(nd_idx_cont);
    idx_cont.idxc_valor:= valor;
  end rs_Idx_Cont;


  procedure rs_Decl_T(decl: out atribut; id_type: in atribut; 
                      decl_cont: in atribut) is
  begin
    decl:= new node(nd_decl_t);
    decl.dt_id:= id_type;
    decl.dt_cont:= decl_cont;
  end rs_Decl_T;


  procedure rs_Decl_T_Cont(decl: out atribut; info: in atribut) is
  begin
    case info.tn is
      when nd_rang =>
        decl:= new node(nd_decl_t_cont_type);
        decl.dtcont_rang:= info;

      when nd_dcamps   =>
        decl:= new node(nd_decl_t_cont_record);
        decl.dtcont_camps:= info;
      
      when others =>
        null; -- ERROR

    end case;
  end rs_Decl_T_Cont;


  procedure rs_Decl_T_Cont(decl: out atribut; rang_array: in atribut; 
                           tipus_array: in atribut) is
  begin
    decl:= new node(nd_decl_t_cont_arry);
    decl.dtcont_idx:= rang_array;
    decl.dtcont_tipus:= tipus_array;
  end rs_Decl_T_Cont;


  procedure rs_DCamps(camps: out atribut; camp_seg: in atribut; 
                      camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);
    camps.dcamps_dcamps:= camp_seg;
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;


  procedure rs_DCamps(camps: out atribut; camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);
    camps.dcamps_dcamps:= new node(nd_null);
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;


  procedure rs_DCamp(camp: out atribut; var: in atribut) is
  begin
    camp:= new node(nd_dcamp);
    camp.dcamp_decl:= var;
  end rs_DCamp;


  procedure rs_Rang(rang: out atribut; id_type: in atribut; 
                    linf: in atribut; lsup: in atribut) is
  begin
    rang:=new node(nd_rang);
    rang.rang_id:=id_type.id_id;
    rang.rang_linf:=linf;
    rang.rang_lsup:=lsup;
  end rs_Rang;


  -- Sentencies

  procedure rs_Sents(sents: out atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents);
    sents.sents_cont:= sent;
  end rs_Sents;


  procedure rs_Sent_Nob(sents: out atribut; sent_cont: in atribut; 
                        sent: in atribut) is
  begin
    sents:= new node(nd_sents_nob);
    sents.snb_snb:= sent_cont;
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent_Nob(sents: out atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents_nob);
    sents.snb_snb:= new node(nd_null);
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent(sent: out atribut; stipus: in atribut) is
  begin
    sent:= new node(nd_sent);
    sent.sent_sent:= stipus;
  end rs_Sent;


  procedure rs_SIter(sent: out atribut; expr: in atribut; 
                     sents: in atribut) is
  begin
    sent:= new node(nd_siter);
    sent.siter_expr:= expr;
    sent.siter_sents:= sents;
  end rs_SIter;


  procedure rs_SCond(sent: out atribut; expr: in atribut; sents: in atribut) 
  is
  begin
    sent:= new node(nd_scond);
    sent.scond_expr:= expr;
    sent.scond_sents:= sents;
    sent.scond_esents:= new node(nd_null);
  end rs_SCond;


  procedure rs_SCond(sent: out atribut; expr: in atribut; sents_if: in atribut; 
                     sents_else: in atribut) is
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


  procedure rs_SAssign(sent: out atribut; ref: in atribut; expr: in atribut)
  is
  begin
    sent:= new node(nd_sassign);
    sent.sassign_ref:= ref;
    sent.sassign_expr:= expr;
  end rs_SAssign;


  -- Expressio

  procedure rs_LExpr(lexpr: out atribut; cont: in atribut; expr: in atribut)
  is
  begin
    lexpr:= new node(nd_lexpr);
    lexpr.lexpr_cont:= cont;
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_LExpr(lexpr: out atribut; expr: in atribut) is
  begin
    lexpr:= new node(nd_lexpr);
    lexpr.lexpr_cont:= new node(nd_null);
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_Expr(expr: out atribut; cont: in atribut) is
  begin
    expr:= new node(nd_expr);
    expr.expr_e:= cont;
  end rs_Expr;


  procedure rs_EAnd(expr: out atribut; ee: in atribut; ed: in atribut) 
  is
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


  procedure rs_EOpo(expr: out atribut; ee: in atribut; ed: in atribut; 
                    op: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= op.orel_tipus;
  end rs_EOpo;


  procedure rs_EOps(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.sum;
  end rs_EOps;


  procedure rs_EOpr(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.res;
  end rs_EOpr;


  procedure rs_EOpp(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.prod;
  end rs_EOpp;


  procedure rs_EOpq(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.quoci;
  end rs_EOpq;


  procedure rs_EOpm(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= ee;
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.modul;
  end rs_EOpm;


  procedure rs_EOpnl(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= new node(nd_null);
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.neg_log;
  end rs_EOpnl;


  procedure rs_EOpna(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= new node(nd_null);
    expr.eop_opd:= ed;
    expr.eop_operand:= decls.d_arbre.neg_alg;
  end rs_EOpna;


  procedure rs_EOp(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_eop);
    expr.eop_ope:= new node(nd_null);
    expr.eop_opd:= ed;
    expr.eop_operand:= nul;
  end rs_EOp;


  procedure rs_ET(expr: out atribut; e: in atribut) is
  begin
    expr:= new node(nd_et);
    expr.et_cont:= e;
  end rs_ET;


  -- Referències

  procedure rs_Ref(ref: out atribut; ref_id: in atribut; qs: in atribut) 
  is
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


  -- Llistes

  procedure rs_Lid(lid: out atribut; id_seg: in atribut; id: in atribut)
  is
  begin
    lid:= new node(nd_lid);
    lid.lid_seg:= id_seg;
    lid.lid_id:= id;
  end rs_Lid;


  procedure rs_Lid(lid: out atribut; id: in atribut) is
  begin
    lid:= new node(nd_lid);
    lid.lid_seg:= new node(nd_null);
    lid.lid_id:= id;
  end rs_Lid;
end semantica.c_arbre;



package semantica.g_codi_int is

  procedure prepara_g_codi_int(nomf: in String; c,f: in num_var);
  procedure gen_codi_int;

end semantica.g_codi_int;


with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with decls.d_tnoms;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_c3a; use decls.d_c3a;
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
  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; 
                      dv: out num_var);
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
     -- no tinc del tot clar aquest ocup_ent, simplifica les coses pero 
     -- es una tudada de memoria
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
    genera(Value(etiq, c_etiq_proc(tp, cim(pproc))));
    genera(Value(pmb, cim(pproc)));
  end gc_cproc;


  procedure gc_decls(nd_decls: in pnode) is
    p: pnode renames nd_decls;
  begin
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
    if p.ref_qs.tn /= nd_null then
      gc_scrida_args(p.ref_qs.qs_q.q_contingut);
    end if;
    
    if p.ref_id.tn = nd_id then -- stdio call
      d:= get(ts, p.ref_id.id_id);
      genera(Value(call, d.np));
    else
      genera(Value(call, p.ref_id.iproc_np));
    end if;
  end gc_scrida;


  procedure gc_scrida_args(nod_lexpr: in pnode) is
    p: pnode renames nod_lexpr;
    r,d: num_var;
  begin
    if p.lexpr_cont.tn /= nd_null then
      gc_scrida_args(p.lexpr_cont);
    end if;
    
    gc_expressio(p.lexpr_expr, r, d);

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
      -- r = r
      d:= null_nv;
    elsif dc = 0 and then dv /= 0 then
      -- r = r(dv)
      d:= dv;
    elsif dc /= 0 and then dv = 0 then
      nova_var_const(nv, tv, valor(dc), tsb_ent, t);
      -- r:= r.dc
      d:= t;
    else -- dc /= 0 and dv /= 0
      nova_var_const(nv, tv, valor(dc), tsb_ent, t);
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t1);
      genera(Value(sum, t1, t, dv));
      -- r:= r.dc(dv)
      d:= t1;
    end if;
  end gc_ref;


  procedure gc_ref_id(nd_id: in pnode; r: out num_var; dc: out despl; 
                      dv: out num_var) is
    p: pnode renames nd_id;
  begin
    r:= p.var_nv;
    dc:= 0;
    dv:= null_nv;
  end gc_ref_id;


  procedure gc_ref_qs(nd_qs: in pnode; dc: in out despl; dv: in out num_var) 
  is
    p: pnode renames nd_qs;
    t,t1,t2: num_var;
    desp: num_var:= null_nv;
  begin
    if p.qs_qs.tn /= nd_null then
      gc_ref_qs(p.qs_qs, dc, dv);
    end if;
    
    if p.qs_q.tn = nd_rec then
      dc:= dc + despl(c_val_const(tv, p.qs_q.rec_td));
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
    if p.lexpra_cont.tn /= nd_null then
      gc_ref_lexpr(p.lexpra_cont, desp);
    end if;
    
    if desp /= 0 then
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      genera(Value(mul, t, desp, p.lexpra_tu));
      
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t1);
      genera(Value(sum, t1, t, te));
      desp:= t1;
    else
      nova_var(nv, tv, tp, cim(pproc), ocup_ent, t);
      
      gc_expressio(p.lexpra_expr, r, d);
      desref(r, d, te);
      
      genera(Value(cp, t, te, null_nv));
      desp:= t;
    end if;
  end gc_ref_lexpr;


  procedure gc_expressio(nd_expr: in pnode; r: out num_var; d: out num_var) 
  is
    p: pnode renames nd_expr;
  begin
    case p.expr_e.tn is
      when nd_and =>
        gc_and(p.expr_e, r, d);
        --ocup:= ocup_bool;
        
      when nd_or =>
        gc_or(p.expr_e, r, d);
        --ocup:= ocup_bool;
        
      when nd_eop | nd_op_rel =>
        gc_eop(p.expr_e, r, d);
        --ocup:= max(ocup_[terme1..termeN])
        
      when others =>
        null;
        -- Comprovació de tipus

    end case;
  end gc_expressio;


  procedure gc_and(nod_and: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nod_and;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
    if p.e_ope.tn = nd_and then
      gc_and(p.e_ope, r1, d1);
    else
      gc_eop(p.e_ope, r1, d1);
    end if;
    -- bastaria amb un char/bit -1..0 per guardar el resultat
    desref(r1, d1, t1); 
    
    gc_eop(p.e_opd, r1, d1);
    -- bastaria amb un char/bit -1..0 per guardar el resultat
    desref(r1, d1, t2); 
    
    -- bastaria amb un char/bit -1..0 per guardar el resultat
    nova_var(nv, tv, tp, cim(pproc), ocup_ent, t); 
    genera(Value(op_and, t, t1, t2));
    r:= t;
    d:= null_nv;
  end gc_and;


  procedure gc_or(nod_or: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nod_or;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
    if p.e_ope.tn = nd_or then
      gc_or(p.e_ope, r1, d1);
    else
      gc_eop(p.e_ope, r1, d1);
    end if;
    desref(r1, d1, t1);
    
    gc_eop(p.e_opd, r1, d1);
    desref(r1, d1, t2);
    
    nova_var(nv, tv, tp, cim(pproc), ocup_ent, t); 
    genera(Value(op_or, t, t1, t2));
    r:= t;
    d:= null_nv;
  end gc_or;


  procedure gc_eop(nd_eop: in pnode; r: out num_var; d: out num_var) is
    p: pnode renames nd_eop;
    t,t1,t2: num_var;
    r1,d1: num_var;
  begin
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
      desref(r1, d1, t1);
      
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
    case p.et_cont.tn is
      when nd_ref =>
        gc_ref(p.et_cont, r, d);
        
      when nd_expr =>
        gc_expressio(p.et_cont, r, d);
        
      when nd_lit =>
        case p.et_cont.lit_tipus is
          when tsb_ent | tsb_car | tsb_bool | tsb_nul =>
            nova_var_const(nv, tv, p.et_cont.lit_val,
                           p.et_cont.lit_tipus, t);
                           
          when others =>
            null;
            
        end case;
        r:= t;
        d:= null_nv;
      when others =>
        null;
        
    end case;
  end gc_et;
end semantica.g_codi_int;



package semantica.g_codi_ass is

  procedure gen_codi_ass;
  procedure prepara_g_codi_ass(nomf: in String);

end semantica.g_codi_ass;


with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed; --El trim
with decls.d_tnoms;
with decls.d_c3a; use decls.d_c3a;
with decls.d_descripcio; use decls.d_descripcio;
with semantica; use semantica;
package body semantica.g_codi_ass is
  use Instruccio_IO;
  use Pila_Procediments;

  Output: Ada.Text_IO.File_Type;
  Input: Instruccio_IO.File_Type;
  newline: String(1..1):=(1=>ASCII.LF); --new line

  nf: Unbounded_String;

  type registre is (
    eax,
    ebx,
    ecx,
    edx,
    esi,
    edi,
    ebp,
    esp
  );
    
  --Definicions
  function ga_llegir return instr_3a;
  procedure ga_escriure(text: in String);

  procedure generacio_assemblador;
  procedure init_memoria;


  function ga_load(nv: in num_var; r: in registre) return String;
  function ga_load_constant(nv: in num_var; r: in registre) return String;
  function ga_load_var_local(nv: in num_var; r: in registre) return String;
  function ga_load_param_local(nv: in num_var; r: in registre) return String;
  function ga_load_var_global(nv: in num_var; r: in registre) return String;
  function ga_load_param_global(nv: in num_var; r: in registre) 
  return String;


  function ga_store(nv: in num_var; r: in registre) return String;
  function ga_store_var_local(nv: in num_var; r: in registre) return String;
  function ga_store_param_local(nv: in num_var; r: in registre) 
  return String;
  function ga_store_var_global(nv: in num_var; r: in registre) return String;
  function ga_store_param_global(nv: in num_var; r: in registre) 
  return String;


  function ga_load_address(nv: in num_var; r: in registre) return String;
  function ga_load_address_constant(nv: in num_var; r: in registre) 
  return String;
  function ga_load_address_var_local(nv: in num_var; r: in registre) 
  return String;
  function ga_load_address_param_local(nv: in num_var; r: in registre) 
  return String;
  function ga_load_address_var_global(nv: in num_var; r: in registre) 
  return String;
  function ga_load_address_param_global(nv: in num_var; r: in registre) 
  return String;


  procedure ga_cp(i3a: in instr_3a);
  procedure ga_cons_idx(i3a: in instr_3a);
  procedure ga_cp_idx(i3a: in instr_3a);


  procedure ga_sum(i3a: in instr_3a);
  procedure ga_res(i3a: in instr_3a);
  procedure ga_mul(i3a: in instr_3a);
  procedure ga_div(i3a: in instr_3a);
  procedure ga_modul(i3a: in instr_3a);
  procedure ga_neg(i3a: in instr_3a);
  procedure ga_op_not(i3a: in instr_3a);
  procedure ga_op_and(i3a: in instr_3a);
  procedure ga_op_or(i3a: in instr_3a);


  function ga_etiq(e: in num_etiq) return String;
  function ga_goto(e: in num_etiq) return String;
  procedure ga_goto(i3a: in instr_3a);
  procedure ga_etiq(i3a: in instr_3a);
  procedure ga_ieq_goto(i3a: in instr_3a);

  procedure ga_gt(i3a: in instr_3a);
  procedure ga_ge(i3a: in instr_3a);
  procedure ga_eq(i3a: in instr_3a);
  procedure ga_neq(i3a: in instr_3a);
  procedure ga_le(i3a: in instr_3a);
  procedure ga_lt(i3a: in instr_3a);


  procedure ga_pmb(i3a: in instr_3a);
  procedure ga_rtn(i3a: in instr_3a);
  procedure ga_call(i3a: in instr_3a);
  procedure ga_paramc(i3a: in instr_3a);
  procedure ga_params(i3a: in instr_3a);


  function Value(*) return String is
  begin 
    -- omesa per conveniència
  end Value;


  procedure gen_codi_ass is
  begin
    Open(File=>Input, Mode=>In_File, Name=> To_String(nf) & ".c3a");
    Create(File=>Output, Mode=>Out_File, Name=> To_String(nf) & ".s");
    
    buida(pproc);
    calcul_desplacaments(tv, nv, tp, np);
    generacio_assemblador;
    
    Close(Input);
    Close(Output);
  end gen_codi_ass;


  procedure prepara_g_codi_ass(nomf: in String) is
  begin
    nf:= To_Unbounded_String(nomf);
  end prepara_g_codi_ass;


  function ga_llegir return instr_3a is
    inst: instr_3a_bin;
  begin
    Instruccio_IO.Read(Input, Item=> inst);
    return To_i3a(inst);
  end ga_llegir;

  procedure ga_escriure(text: in String) is
  begin
    Put(File=> Output, Item=> text);
  end ga_escriure;


  procedure generacio_assemblador is
    inst: instr_3a;
  begin
    init_memoria;
    while not End_Of_File(Input) loop
      inst:=ga_llegir;
      case c_tipus(inst) is
        -- per cada tipus d'instrucció, crida al pertinent procediment
        -- i afegeix un newline a continuació. S'ha omés per conveniència
      end case;
    end loop;
  end generacio_assemblador;


  --Inicialitzar memoria
  procedure init_memoria is
  begin
    ga_escriure(".section  .bss" & newline);
    ga_escriure("  .comm DISP, 100" & newline);
    
    ga_escriure(".section .text" & newline);
    ga_escriure("  .global main" & newline);
  end init_memoria;


  --LOAD
  function ga_load(nv: in num_var; r: in registre) return String is
  begin
    if not es_var(tv, nv) then
      return ga_load_constant(nv, r);

    elsif c_prof_proc(tp, c_np_var(tv, nv)) = c_prof_proc(tp, cim(pproc)) 
    then
      if c_desp_var(tv, nv)<0 then
        return ga_load_var_local(nv, r);

      elsif c_desp_var(tv, nv)>0 then
        return ga_load_param_local(nv, r);
      end if;

    elsif c_prof_proc(tp, c_np_var(tv, nv)) < c_prof_proc(tp, cim(pproc)) 
    then
      if c_desp_var(tv, nv)<0 then
        return ga_load_var_global(nv, r);

      elsif c_desp_var(tv, nv)>0 then
        return ga_load_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_load;


  function ga_load_constant(nv: in num_var; r: in registre) return String 
  is
    reg: constant String:= registre'Image(r);
    valor_const: constant String:= Value(c_val_const(tv, nv));
  begin
    return "  movl  $" & valor_const &", %" & reg & newline;
  end ga_load_constant;


  function ga_load_var_local(nv: in num_var; r: in registre) return String 
  is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_var_local;


  function ga_load_param_local(nv: in num_var; r: in registre) return String 
  is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl " & desplacament & "(%ebp), %esi" & newline
          & "  movl (%esi), %" & reg & newline;
  end ga_load_param_local;


  function ga_load_var_global(nv: in num_var; r: in registre) return String 
  is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp, c_np_var(tv, nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %" & reg & newline;
  end ga_load_var_global;


  function ga_load_param_global(nv: in num_var; r: in registre) return String
  is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp,c_np_var(tv,nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %esi" & newline
          & "  movl (%esi), %" & reg & newline;
  end ga_load_param_global;


  --STORE
  function ga_store(nv: in num_var; r: in registre) return String is
  begin
    if c_prof_proc(tp, c_np_var(tv, nv)) = c_prof_proc(tp, cim(pproc)) 
    then
      if c_desp_var(tv, nv)<0 then
        return ga_store_var_local(nv, r );

      elsif c_desp_var(tv, nv)>0 then
        return ga_store_param_local(nv, r);
      end if;

    elsif c_prof_proc(tp, c_np_var(tv, nv)) < c_prof_proc(tp, cim(pproc)) 
    then
      if c_desp_var(tv, nv)<0 then
        return ga_store_var_global(nv, r);

      elsif c_desp_var(tv, nv)>0 then
        return ga_store_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_store;


  function ga_store_var_local(nv: in num_var; r: in registre) return String
  is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return "  movl %" & reg & ", " & desplacament & "(%ebp)" & newline;
  end ga_store_var_local;


  function ga_store_param_local(nv: in num_var; r: in registre) 
  return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %edi" & newline
         & "  movl %" & reg & ", (%edi)" & newline;
  end ga_store_param_local;


  function ga_store_var_global(nv: in num_var; r: in registre) return String
  is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp,c_np_var(tv,nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %edi" & newline
          & "  movl %" & reg & " ," & desplacament & "(%edi)" & newline;
  end ga_store_var_global;


  function ga_store_param_global(nv: in num_var; r: in registre) 
  return String is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp, c_np_var(tv,nv)));
    desp_display: constant String:= Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %edi" & newline
          & "  movl %" & reg & ", (%edi)" & newline;
  end ga_store_param_global;


  --LOAD ADDRESS
  function ga_load_address(nv: in num_var; r: in registre) return String 
  is
  begin
    if not es_var(tv, nv) then
      return ga_load_address_constant(nv, r);

    elsif c_prof_proc(tp, c_np_var(tv, nv)) = c_prof_proc(tp, cim(pproc)) 
    then
      if c_desp_var(tv, nv)<0 then
        return ga_load_address_var_local(nv, r);

      elsif c_desp_var(tv, nv)>0 then
        return ga_load_address_param_local(nv, r);
      end if;

    elsif c_prof_proc(tp, c_np_var(tv, nv)) < c_prof_proc(tp, cim(pproc))
    then
      if c_desp_var(tv, nv)<0 then
        return ga_load_address_var_global(nv, r);

      elsif c_desp_var(tv, nv)>0 then
        return ga_load_address_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_load_address;


  function ga_load_address_constant(nv: in num_var; r: in registre)
  return String is
    ecx: num_etiq;
  begin
    nova_etiq(ne, ecx);
    case c_tsb_const(tv, nv) is
      when tsb_ent | tsb_bool=>
        return    ".section .data" & newline
               &  "  ec"   & Value(ecx) & ": .long   "
               & Value(c_val_const(tv, nv)) & newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" 
               & registre'Image(r) & newline;

      when tsb_car =>
        return    ".section .data" & newline
               &  "  ec" & Value(ecx) & ": .ascii  """
               &  Character'Val(Integer(c_val_const(tv, nv))) & """" 
               & newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" & registre'Image(r) 
               & newline;

      when tsb_nul=>
        return    ".section .data" & newline
               &  "  ec" & Value(ecx) & ": .asciz  "
               &  decls.d_tnoms.get(tn, id_str(c_val_const(tv, nv)))  
               &  newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" & registre'Image(r) 
               & newline;

      when others  => null;
    end case;
    return "";
  end ga_load_address_constant;


  function ga_load_address_var_local(nv: in num_var; r: in registre) 
  return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return "  leal " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_address_var_local;


  function ga_load_address_param_local(nv: in num_var; r: in registre) 
  return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_address_param_local;


  function ga_load_address_var_global(nv: in num_var; r: in registre) 
  return String is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp,c_np_var(tv,nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  leal " & desplacament & "(%esi), %" & reg &  newline;
  end ga_load_address_var_global;


  function ga_load_address_param_global(nv: in num_var; r: in registre) 
  return String is
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp,c_np_var(tv,nv)));
    desp_display: constant String:= Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(c_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %" & reg &  newline;
  end ga_load_address_param_global;


  --Instruccions de còpia
  procedure ga_cp(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
  begin
    ga_escriure(ga_load(b, eax)
    & ga_store(a, eax));
  end ga_cp;


  -- Empram un subl a l'hora de calcular el desplaçament de l'addr
  -- enlloc de l'esperat addl perque ens permet generar un codi intermitj 
  -- molt més elegant i B+A (A < 0 i B > 0) es equivalent a B-A (A,B >0)
  procedure ga_cons_idx(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(c, eax)
              & ga_load_address(b, esi)
              & "  subl %eax, %esi" & newline
              & "  movl (%esi), %eax" & newline
              & ga_store(a, eax));
  end ga_cons_idx;


  -- Ídem que al cas de cons_idx
  procedure ga_cp_idx(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & ga_load_address(a, edi)
              & "  subl %eax, %edi" & newline
              & "  movl %ebx, (%edi)" & newline);
  end ga_cp_idx;


  --Instruccions artimetic-logiques
  procedure ga_sum(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
               & ga_load(c, ebx)
               & "  addl %ebx, %eax" & newline
               & ga_store(a, eax));
  end ga_sum;


  procedure ga_res(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  subl %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_res;


  procedure ga_mul(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  imul %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_mul;


  procedure ga_div(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  movl %eax, %edx" & newline
              & "  sarl $31, %edx" & newline
              & ga_load(c, ebx)
              & "  idivl  %ebx" & newline
              & ga_store(a, eax));
  end ga_div;


  procedure ga_modul(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  movl %eax, %edx" & newline
              & "  sarl $31, %edx" & newline
              & ga_load(c, ebx)
              & "  idivl  %ebx" & newline
              & ga_store(a, edx));
  end ga_modul;


  procedure ga_neg(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  negl %eax" & newline
              & ga_store(a, eax));
  end ga_neg;


  procedure ga_op_not(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  notl %eax" & newline
              & ga_store(a, eax));
  end ga_op_not;


  procedure ga_op_and(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  andl %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_op_and;


  procedure ga_op_or(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  orl  %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_op_or;


  --Instruccions de Brancament
  function ga_etiq(e: in num_etiq) return String is
    etiqueta: constant String:= Value(e);
  begin
    -- Petit artifici per generar l'etiqueta main i que el gcc no es queixi
    -- L'alternativa era cercar una comanda per especificar una altra etiqueta
    -- inicial però optàrem per no fer-ho.
    -- Tot i que no ho sembli, degut al disseny del llenguatge i a com 
    -- assignam les etiquetes als procediments, el primer procediment reconegut
    -- sempre serà el 'main' i tendrà etiqueta E(null_nv+1)
    -- EX:
    -- proc A is
    --   proc B is
    --     ...
    --   end proc;
    --   ...
    -- begin
    --    main bloc
    -- end proc;
    if e=null_ne+1 then
      return "main: NOP" & newline;
    else
      return "E" & etiqueta  & ": NOP" & newline;
    end if;
  end ga_etiq;


  function ga_goto(e: in num_etiq) return String is
    etiqueta: constant String:=Value(e);
  begin
    return "  jmp  E" & etiqueta & newline;
  end ga_goto;


  procedure ga_etiq(i3a: in instr_3a) is
    e: constant num_etiq:= c_arg_ne(i3a);
  begin
    ga_escriure(ga_etiq(e));
  end ga_etiq;


  procedure ga_goto(i3a: in instr_3a) is
    e: constant num_etiq:= c_arg_ne(i3a);
  begin
    ga_escriure(ga_goto(e));
  end ga_goto;


  procedure ga_ieq_goto(i3a: in instr_3a) is
    e: constant num_etiq:= c_arg_ne(i3a);
    a: constant num_var:= c_arg2(i3a);
    b: constant num_var:= c_arg3(i3a);
    e1: num_etiq;
  begin
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(a, eax)
              & ga_load(b, ebx)
              & "  cmpl %ebx, %eax" & newline
              & "  jne  E" & Value(e1) & newline
              & ga_goto(e)
              & ga_etiq(e1));
  end ga_ieq_goto;


  procedure ga_gt(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jge  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_gt;


  procedure ga_ge(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jg  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_ge;


  procedure ga_eq(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jne  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_eq;


  procedure ga_neq(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  je  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_neq;


  procedure ga_lt(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jle  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_lt;


  procedure ga_le(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
    b: constant num_var:= c_arg2(i3a);
    c: constant num_var:= c_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jl  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_le;


  --Crida a procediments
  procedure ga_pmb(i3a: in instr_3a) is
    np: constant num_proc:= c_arg_np(i3a);
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp, np));
    desp_display: constant String:= Value(desp_disp);
    ocupacio_proc: constant String:= Value(c_ocup_proc(tp, np));
  begin
    empila(pproc, np);
    
    ga_escriure("  movl $DISP, %esi" & newline
              & "  movl " & desp_display & "(%esi), %eax" & newline
              & "  pushl %eax" & newline
              & "  pushl %ebp" & newline
              & "  movl %esp, %ebp" & newline
              & "  movl %ebp, " & desp_display & "(%esi)" & newline
              & "  subl  $" & ocupacio_proc & ", %esp" & newline);
  end ga_pmb;


  procedure ga_rtn(i3a: in instr_3a) is
    np: constant num_proc:= c_arg_np(i3a);
    desp_disp: constant Integer:= 4*Value(c_prof_proc(tp, np));
    desp_display: constant String:= Value(desp_disp);
  begin
    ga_escriure("  movl %ebp, %esp" & newline
              & "  popl %ebp" & newline
              & "  movl $DISP, %edi" & newline
              & "  popl %eax" & newline
              & "  movl %eax, " & desp_display & "(%edi)" & newline
              & "  ret" & newline);
              
    desempila(pproc);
  end ga_rtn;


  procedure ga_params(i3a: in instr_3a) is
    a: constant num_var:= c_arg_nv(i3a);
  begin
    ga_escriure(ga_load_address(a, eax)
              & "  pushl %eax" & newline);
  end ga_params;


  -- Empram un subl a l'hora de calcular el desplaçament de l'addr
  -- enlloc de l'esperat addl perque ens permet generar un codi intermitj 
  -- molt més elegant i B+A (A < 0 i B > 0) es equivalent a B-A (A,B >0)
  procedure ga_paramc(i3a: in instr_3a) is
    a: constant num_var:=c_arg_nv(i3a);
    b: constant num_var:=c_arg2(i3a);
  begin
    ga_escriure(ga_load_address(a, eax)
              & ga_load(b, ebx)
              & "  subl %ebx, %eax" & newline
              & "  pushl %eax" & newline);
  end ga_paramc;


  procedure ga_call(i3a: in instr_3a) is
    np: constant num_proc:= c_arg_np(i3a);
    nparam: constant Integer:= 4*c_nparam_proc(tp, np);
    tamany_nparam: constant String:= Value(nparam);
  begin
    if c_tproc(tp, np)=comu then
      ga_escriure("  call E" & Value(c_etiq_proc(tp, np)) & newline
                & "  addl $" & tamany_nparam & ", %esp" & newline);
    else
      ga_escriure("  call _" & c_nom_proc(tp, np, tn) & newline
                & "  addl $" & tamany_nparam & ", %esp" & newline);
    end if;
  end ga_call;
end semantica.g_codi_ass;
