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
%right Identif Lit
%token Parentesi_t
%right Parentesi_o 

%with decls; 
%with decls.d_atribut;
{ 
subtype YYSType is decls.d_atribut.atribut;
}

%%
PROC_PRIMA:
  	 PROC									{rs_Root($1);} -- Proc principal
    ;
PROC:
	 Pc_procedure C_PROC Pc_is
	 	DECLS
	 Pc_begin
	 	SENTS
	 Pc_end Pc_procedure Punticoma									{rs_Proc($$,$2,$4,$6);}
  ;

DECLS:
	 DECLS DECL														{rs_Decls($$,$1,$2);}
  |       															{r_atom($$);}
  ;

DECL:
	 PROC															{rs_Decl($$,$1);}
  |  DECL_CONST													{rs_Decl($$,$1);}
  |  DECL_VAR														{rs_Decl($$,$1);}
  |  DECL_T															{rs_Decl($$,$1);}
  ;

DECL_CONST:
	 LID Dospunts Pc_const Identif Dospuntsigual IDX Punticoma		{rs_Decl_Const($$,$1,$4,$6);}
  ;


DECL_VAR:
	 LID Dospunts Identif Punticoma									{rs_Decl_Var($$,$1,$3);}
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
	 Pc_in															{rs_Mode($$,decls.d_atribut.md_in);}
  |  Pc_in_out														{rs_Mode($$,decls.d_atribut.md_in_out);}
  ;

LID:
	 LID Coma Identif												{rs_Lid($$,$1,$3);}
  |  Identif														{rs_Lid($$,$1);}
  ;

RANG:
	 Identif Pc_range IDX Punt Punt IDX								{rs_Rang($$,$1,$3,$6);}
  ;
  
IDX:
	 S_menys IDX_CONT												{rs_Idx($$,$2,decls.negatiu);}
  |  IDX_CONT														{rs_Idx($$,$1,decls.positiu);}
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
	 SENTS_NOB SENT													{rs_Sent_Nob($$,$1,$2);}
  |  SENT															{rs_Sent_Nob($$,$1);}
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
	   E_AND																{rs_Expr($$,$1);}
  |  E_OR																{rs_Expr($$,$1);}
  |  E2																{rs_Expr($$,$1);}
  ;

E_AND:
	   E_AND Pc_and E2													{rs_EAnd($$,$1,$3);}
  |  E2 Pc_and E2													{rs_EAnd($$,$1,$3);}
  ;

E_OR:
	   E_OR Pc_or E2													{rs_EOr($$,$1,$3);}
  |  E2 Pc_or E2													{rs_EOr($$,$1,$3);}
  ;

E2:
	   E2 Op_rel E2													{rs_E2o($$,$1,$3,$2);}
  |  E2 S_mes E2													{rs_E2s($$,$1,$3);}
  |  E2 S_menys E2													{rs_E2r($$,$1,$3);}
  |  E2 S_prod E2													{rs_E2p($$,$1,$3);}
  |  E2 S_quoci E2													{rs_E2q($$,$1,$3);}
  |  E2 Pc_mod E2													{rs_E2m($$,$1,$3);}
  |  Pc_not E3														{rs_E2nl($$,$2);}
  |	 S_menys E3														{rs_E2na($$,$2);}
  |  E3																{rs_E2($$,$1);}
  ;

E3:
	 REF															{rs_E3($$,$1);}
  |  Parentesi_o EXPR Parentesi_t									{rs_E3($$,$2);}
  |  Lit															{rs_E3($$,$1);}
  ;


LEXPR:
	 LEXPR Coma EXPR												{rs_LExpr($$,$1,$3);}
  |  EXPR															{rs_LExpr($$,$1);}
  ;
%%

	package a_sintactic is
		procedure YYParse;
	end a_sintactic;

  with a_lexic, kobal_dfa, kobal_io, text_io, kobal_tokens, kobal_goto, kobal_shift_reduce; 
  use  a_lexic, text_io, kobal_tokens, kobal_goto, kobal_io, kobal_shift_reduce; 
  
	with decls;
  with decls.d_atribut;
  with semantica; use semantica;
	with semantica.c_arbre; use semantica.c_arbre;
	package body a_sintactic is
##
	end a_sintactic;
