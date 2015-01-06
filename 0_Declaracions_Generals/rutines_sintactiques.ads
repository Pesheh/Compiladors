package rutines_sintactiques is
	-- aquestes son totes les rutines, pero n'hi pot haver
	-- mes d'una amb el mateix nom (args diferents o de tipus
	-- diferent).
	-- Tambe es possible que alguna rutina NO sigui necessaria
	-- pero ho he inclos tot per si de cas.

	procedure rs_Proc(proc: out YYSType; cproc: in YYSType; decls: in YYSType; sents: in YYSType);
	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType; args: in YYSType);
	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType);
	procedure rs_Args(args: out YYSType; args_seg: in YYSType; arg: in YYSType);
	procedure rs_Args(args: out YYSType; arg: in YYSType);
	procedure rs_Arg(arg: out YYSType; mode: in YYSType; tipus: in YYSType);

	procedure rs_Decls(decls: out YYSType; decls_seg: in YYSType; decl: YYSType);
    --No estoy del todo seguro de esta manera de estructurar las declaraciones.
	procedure rs_Decl(decl: out YYSType; decl_real: in YYSType); 
	procedure rs_Decl_Var(decl: out YYSType; lista_id: in YYSType; tipus: in YYSType);
	rs_Decl_Const;
	rs_Decl_T;
	rs_Decl_T_Cont;
	rs_DCamps;
	rs_DCampr;
	rs_Mode;
	rs_Lid;
	rs_Rang;
	rs_Idx;
	rs_Idx_Cont;
	rs_Sents;
	rs_Sents_Nob;
	rs_Sent;
	rs_SIter;
	rs_SCond;
	rs_SCrida;
	rs_SAssign;
	rs_Ref;
	rs_Qs;
	rs_Q;
	rs_Expr;
	rs_E0;
	rs_E1;
	rs_E2;
	rs_E3;
	rs_LExpr;


    proc_error,arg_error: exception;
end rutines_sintactiques;
