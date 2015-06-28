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
  procedure rs_Proc(proc: out atribut; cproc: in atribut; decls: in atribut; sents: in atribut);
  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut; args: in atribut);
  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut);
  procedure rs_Args(args: out atribut; args_seg: in atribut; arg: in atribut);
  procedure rs_Args(args: out atribut; arg: in atribut);
  procedure rs_Arg(arg: out atribut; lid: in atribut; mode: in atribut; tipus: in atribut);
  procedure rs_Mode_in(mode: out atribut);
  procedure rs_Mode_in_out(mode: out atribut);


  -- Declaracio
  procedure rs_Decls(decls: out atribut; decls_seg: in atribut; decl: in atribut);
  procedure rs_Decl(decl: out atribut; decl_real: in atribut);
  procedure rs_Decl_Var(decl: out atribut; lista_id: in atribut; tipus: in atribut);
  procedure rs_Decl_Const(decl: out atribut; lid_const: in atribut; tipus: in atribut; valor: in atribut);
  procedure rs_Idx_neg(idx: out atribut; idx_cont: in atribut);
  procedure rs_Idx_pos(idx: out atribut; idx_cont: in atribut);
  procedure rs_Idx_Cont(idx_cont: out atribut; valor: in atribut);
  procedure rs_Decl_T(decl: out atribut; id_type: in atribut; decl_cont: in atribut);
  procedure rs_Decl_T_Cont(decl: out atribut; info: in atribut);
  procedure rs_Decl_T_Cont(decl: out atribut; rang_array: in atribut; tipus_array: in atribut);
  procedure rs_DCamps(camps: out atribut; camp_seg: in atribut; camp: in atribut);
  procedure rs_DCamps(camps: out atribut; camp: in atribut);
  procedure rs_DCamp(camp: out atribut; var: in atribut);
  procedure rs_Rang(rang: out atribut; id_type: in atribut; linf: in atribut; lsup: in atribut);


  -- Sentencia
  procedure rs_Sents(sents: out atribut; sent: in atribut);
  procedure rs_Sent_Nob(sents: out atribut; sent_cont: in atribut; sent: in atribut);
  procedure rs_Sent_Nob(sents: out atribut; sent: in atribut);
  procedure rs_Sent(sent: out atribut; stipus: in atribut);
  procedure rs_SIter(sent: out atribut; expr: in atribut; sents: in atribut);
  procedure rs_SCond(sent: out atribut; expr: in atribut; sents: in atribut);
  procedure rs_SCond(sent: out atribut; expr: in atribut; sents_if: in atribut; sents_else: in atribut);
  procedure rs_SCrida(sent: out atribut; ref: in atribut);
  procedure rs_SAssign(sent: out atribut; ref: in atribut; expr: in atribut);


  -- Expressio
  procedure rs_LExpr(lexpr: out atribut; cont: in atribut; expr: in atribut);
  procedure rs_LExpr(lexpr: out atribut; expr: in atribut);
  procedure rs_Expr(expr: out atribut; cont: in atribut);
  procedure rs_EAnd(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOr(expr: out atribut; ee: in atribut; ed: in atribut);
  procedure rs_EOpo(expr: out atribut; ee: in atribut; ed: in atribut; op: in atribut);
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


  err,type_error,proc_error,arg_error,record_error,camp_error,array_error,var_error,const_error: exception;

end semantica.c_arbre;
