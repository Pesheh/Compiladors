package rutines_sintactiques is

	-- Procediment
	procedure rs_Proc(proc: out YYSType; cproc: in YYSType; decls: in YYSType; sents: in YYSType);
    procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType; args: in YYSType);
    procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType);
    procedure rs_Args(args: out YYSType; args_seg: in YYSType; arg: in YYSType);
    procedure rs_Args(args: out YYSType; arg: in YYSType);
    procedure rs_Arg(arg: out YYSType; mode: in YYSType; tipus: in YYSType);
	procedure rs_Mode(mode: out YYStype; tipus: in tmode);


	-- Declaracio
	procedure rs_Decls(decls: out YYSType; decls_seg: in YYSType; decl: YYSType);
    procedure rs_Decl(decl: out YYSType; decl_real: in YYSType); 
    procedure rs_Decl_Var(decl: out YYSType; lista_id: in YYSType; tipus: in YYSType);
    procedure rs_Decl_Const(decl: out YYSType; id_const: in YYSType; tipus: in YYSType; valor: in YYSType);
    procedure rs_Idx(idx: out YYSType; idx_cont: in YYSType; signe: in tidx);
    procedure rs_Idx_Cont(idx_cont: out YYSType; valor: in YYSType);
    procedure rs_Decl_T(decl: out YYSType; id_type: in YYSType; decl_cont: in YYSType);
    procedure rs_Decl_T_Cont(decl: out YYSType; info: in YYSType);
    procedure rs_Decl_T_Cont(decl: out YYSType; rang_array: in YYSType; tipus_array: in YYSType);
	procedure rs_DCamps(camps: out YYSType; camp_seg: in YYStype; camp: in YYStype);
	procedure rs_DCamps(camps: out YYSType; camp: in YYStype);
	procedure rs_DCamp(camp: out YYStype; var: in YYStype);
	
	
	-- Sentencia
	procedure rs_Sents(sents: out YYStype; sent: in YYStype);	
    procedure rs_Sent_Nob(sents: out YYStype; sent_cont: in YYSType; sent: in YYStype);
	procedure rs_Sent_Nob(sents: out YYStype; sent: in YYStype);
	procedure rs_Sent(sent: out YYStype; stipus: in YYStype);
	procedure rs_SIter(sent: out YYStype; expr: in YYStype; sents: in YYStype);
	procedure rs_SCond(sent: out YYStype; expr: in YYStype; sents: in YYStype);
	procedure rs_SCond(sent: out YYStype; expr: in YYStype; sents_if: in YYStype; sents_else: in YYStype);
	procedure rs_SCrida(sent: out YYStype; ref: in YYStype);
	procedure rs_SAssign(sent: out YYStype; ref: in YYStype; expr: in YYStype);
	
	
	-- Expressio
	procedure rs_LExpr(lexpr: out YYStype; cont: in YYStype; expr: in YYStype);
	procedure rs_LExpr(lexpr: out YYStype; expr: in YYStype);
	procedure rs_Expr(expr: out YYStype; cont: in YYStype);
	procedure rs_E0(expr: out YYStype; ee: in YYStype; ed: in YYStype);
	procedure rs_E1(expr: out YYStype; ee: in YYStype; ed: in YYStype);
	procedure rs_E2(expr: out YYStype; ee: in YYStype; op: in operand; ed: in YYStype);
	procedure rs_E2(expr: out YYStype; op:in operand; ed: in YYStype);
	procedure rs_E2(expr: out YYStype; ed: in YYStype);
	procedure rs_E3(expr: out YYStype; e: in YYStype);


	-- Altres
	procedure rs_Lid(lid: out YYStype; id_seg: in YYStype; id: in YYStype);
	procedure rs_Ref(ref: out YYSType; ref_id: in YYSType; qs: in YYSType);
	procedure rs_Qs(qs: out YYSType; qs_in: in YYSType; q: in YYSType);
    procedure rs_Q(q: out YYSType; contingut: in YYSType);


    error,type_error,proc_error,arg_error,record_error,camp_error,array_error,var_error,const_error: exception;
end rutines_sintactiques;
