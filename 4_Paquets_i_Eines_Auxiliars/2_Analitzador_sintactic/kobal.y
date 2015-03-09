%token Pc_procedure Pc_is Pc_begin Pc_end Pc_const Pc_new Pc_type Pc_record Pc_array Pc_of Pc_in Pc_in_out Pc_null Pc_range Pc_while Pc_loop Pc_if Pc_then Pc_else
%right Dospuntsigual 
%right Dospunts
%right Coma
%left Punt Punticoma
%right Pc_and Pc_or
%nonassoc Op_rel
%left S_mes S_menys
%left S_prod S_quoci
%left Pc_mod
%right Pc_not
%right Lit Identif
%token Parentesi_t
%right Parentesi_o -- aquest token tambe s'empra com a dummy per otorgar precedencia i associativitat a M1

%with d_atribut;
{ 
subtype YYSType is d_atribut.atribut;
}

%%
PROC:
	 Pc_procedure C_PROC Pc_is
	 	DECLS
	 Pc_begin
	 	SENTS
	 Pc_end Pc_procedure Punticoma									{rs_Proc($$,$2,$4,$6);} -- Aquí podem afegir un surt_block
  ;

DECLS:
	 DECLS DECL														{rs_Decls($$,$1,$2);}
  |       															{r_atom($$);}
  ;

DECL:
	 PROC															{rs_Decl($$,$1);}
  |  DECL_VAR														{rs_Decl($$,$1);}
  |  DECL_CONST														{rs_Decl($$,$1);}
  |  DECL_T															{rs_Decl($$,$1);}
  ;

DECL_VAR:
	 LID Dospunts Identif Punticoma									{rs_Decl_Var($$,$1,$3);}
  ;

DECL_CONST:
	 Identif Dospunts Pc_const Identif Dospunts IDX Punticoma		{rs_Decl_Const($$,$1,$4,$6);}
  ;

DECL_T:
	 Pc_type Identif Pc_is DECL_T_CONT								{rs_Decl_T($$,$2,$4);}
  ;

DECL_T_CONT:
	 Pc_new RANG Punticoma											{rs_Decl_T_Cont($$,$2);}
  |	 Pc_record
  	 	DCAMPS
	 Pc_end Pc_record Punticoma										{rs_Decl_T_Cont($$,$2);}
  |  Pc_array Parentesi_o LID Parentesi_t Pc_of Identif Punticoma	{rs_Decl_T_Cont($$,$3,$6);}
  ;
 
DCAMPS:
	 DCAMPS DCAMP													{rs_DCamps($$,$1,$2);}
  |  DCAMP															{rs_DCamps($$,$1);}
  ;

DCAMP:
	 DECL_VAR														{rs_DCamp($$,$1);}
  ;

C_PROC:
	 Identif Parentesi_o ARGS Parentesi_t							{rs_C_Proc($$,$1,$3);}
  |  Identif														{rs_C_Proc($$,$1);}
  ;

ARGS:
	 ARGS Punticoma ARG												{rs_Args($$,$1,$3);}
  |  ARG															{rs_Args($$,$1);}
  ;

ARG:
	 LID Dospunts MODE Identif										{rs_Arg($$,$1,$3,$4);}
  ;

MODE:
	 Pc_in															{rs_Mode($$,d_atribut.md_in);}
  |  Pc_in_out														{rs_Mode($$,d_atribut.md_in_out);}
  ;

LID:
	 LID Coma Identif												{rs_Lid($$,$1,$3);}
  |  Identif														{rs_Lid($$,$1);}
  ;

RANG:
	 Identif Pc_range IDX Punt Punt IDX								{rs_Rang($$,$1,$3,$6);}
  ;
  
IDX:
	 S_menys IDX_CONT												{rs_Idx($$,$2,decls_generals.negatiu);}
  |  IDX_CONT														{rs_Idx($$,$1,decls_generals.positiu);}
  ;

IDX_CONT:
	 Lit															{rs_Idx_Cont($$,$1);}
  |  Identif														{rs_Idx_Cont($$,$1);}
  ;

SENTS:
	 SENTS_NOB														{rs_Sents($$,$1);}
  |  Pc_null Punticoma												{r_atom($$);}
  ;

SENTS_NOB:
	 SENTS_NOB SENT													{rs_Sents_Nob($$,$1,$2);}
  |  SENT															{rs_Sents_Nob($$,$1);}
  ;

SENT:
	 S_ITER															{rs_Sent($$,$1);}
  |  S_COND															{rs_Sent($$,$1);}
  |  S_CRIDA														{rs_Sent($$,$1);}
  |  S_ASSIGN														{rs_Sent($$,$1);}
  ;

S_ITER:
	 Pc_while EXPR Pc_loop
	 	SENTS
	 Pc_end Pc_loop Punticoma										{rs_SIter($$,$2,$4);}
  ;

S_COND:
	 Pc_if EXPR Pc_then
	 	SENTS
	 Pc_end Pc_if Punticoma											{rs_SCond($$,$2,$4);}
  |	 Pc_if EXPR Pc_then
  		SENTS
	 Pc_else
	 	SENTS
	 Pc_end Pc_if Punticoma											{rs_SCond($$,$2,$4,$6);}
  ;

S_CRIDA:
  	 REF Punticoma													{rs_SCrida($$,$1);}
  ;

S_ASSIGN:
	 REF Dospuntsigual EXPR Punticoma								{rs_SAssign($$,$1,$3);}
  ;

REF:
	 Identif QS														{rs_Ref($$,$1,$2);}
  ;

QS:
	 QS Q															{rs_Qs($$,$1,$2);}
  |     														{r_atom($$);}
  ;

Q:
	 Punt Identif													{rs_Q($$,$2);}
  |	 Parentesi_o LEXPR Parentesi_t									{rs_Q($$,$2);}
  ;

EXPR:
	 E0																{rs_Expr($$,$1);}
  |  E1																{rs_Expr($$,$1);}
  |  E2																{rs_Expr($$,$1);}
  ;

E0:
	 E0 Pc_and E2													{rs_E0($$,$1,$3);}
  |  E2 Pc_and E2													{rs_E0($$,$1,$3);}
  ;

E1:
	 E1 Pc_or E2													{rs_E1($$,$1,$3);}
  |  E2 Pc_or E2													{rs_E1($$,$1,$3);}
  ;

-- Substituir per les corresponents subrutines, una per tipus d'operand
E2:
	 E2 Op_rel E3													{rs_E2($$,$1,d_atribut.o_rel,$3);}
  |  E2 S_mes E3													{rs_E2($$,$1,d_atribut.sum,$3);}
  |  E2 S_menys E3													{rs_E2($$,$1,d_atribut.res,$3);}
  |  E2 S_prod E3													{rs_E2($$,$1,d_atribut.prod,$3);}
  |  E2 S_quoci E3													{rs_E2($$,$1,d_atribut.quoci,$3);}
  |  E2 Pc_mod E3													{rs_E2($$,$1,d_atribut.modul,$3);}
  |	 M1 E3 S_prod S_prod E3											{rs_E2($$,$2,d_atribut.pot,$5);} 
  |  Pc_not E3														{rs_E2($$,d_atribut.neg_log,$1);}
  |	 S_menys E3														{rs_E2($$,d_atribut.neg_alg,$1);}
  |  E3																{rs_E2($$,$1);}
  ;

E3:
	 REF															{rs_E3($$,$1);}
  |  Parentesi_o EXPR Parentesi_t									{rs_E3($$,$2);}
  |  Lit															{rs_E3($$,$1);}
  ;

M1:
     %prec Parentesi_o												{r_atom($$);}
  ;

LEXPR:
	 LEXPR Coma EXPR												{rs_LExpr($$,$1,$3);}
  |  EXPR															{rs_LExpr($$,$1);}
  ;
%%

	package a_sintactic is
		procedure YYParse;
	end a_sintactic;

	with d_atribut;
	with c_arbre; use c_arbre;
	package body a_sintactic is
##
	end a_sintactic;
