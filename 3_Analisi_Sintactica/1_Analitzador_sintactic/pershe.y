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
%right Parentesi_o
%right right

%%
PROC:
	 Pc_procedure C_PROC Pc_is
	 	DECLS
	 Pc_begin
	 	SENTS
	 Pc_end Pc_procedure Punticoma
  ;

DECLS:
	 DECLS DECL
  |--lambda	 
  ;

DECL:
	 PROC
  |  DECL_VAR
  |  DECL_CONST
  |  DECL_T
  ;

DECL_VAR:
	 LID Dospunts Identif Punticoma
  ;

DECL_CONST:
	 Identif Dospunts Pc_const Identif Dospunts IDX Punticoma
  ;

DECL_T:
	 Pc_type Identif Pc_is DECL_T_CONT
  ;

DECL_T_CONT:
	 Pc_new RANG Punticoma
  |	 Pc_type Identif Pc_is Pc_record
  	 	DCAMPS
	 Pc_end Pc_record Punticoma
  |  Pc_type Identif Pc_is Pc_array Parentesi_o LID Parentesi_t Pc_of Identif Punticoma
  ;
 
DCAMPS:
	 DCAMPS DCAMP
  |  DCAMP
  ;

DCAMP:
	 DECL_VAR
  ;

C_PROC:
	 Identif Parentesi_o ARGS Parentesi_t
  |  Identif
  ;

ARGS:
	 ARGS Punticoma ARG
  |  ARG
  ;

ARG:
	 LID Dospunts MODE Identif
  ;

MODE:
	 Pc_in
  |  Pc_in_out
  ;

LID:
	 LID Coma Identif
  |  Identif
  ;

RANG:
	 Identif Pc_range IDX Punt Punt IDX
  ;
  
IDX:
	 S_menys IDX_CONT
  |  IDX_CONT
  ;

IDX_CONT:
	 Lit
  |  Identif
  ;

SENTS:
	 SENTS_NOB
  |  Pc_null Punticoma
  ;

SENTS_NOB:
	 SENTS_NOB SENT
  |  SENT
  ;

SENT:
	 S_ITER
  |  S_COND
  |  S_CRIDA
  |  S_ASSIGN
  ;

S_ITER:
	 Pc_while EXPR Pc_loop
	 	SENTS
	 Pc_end Pc_loop Punticoma
  ;

S_COND:
	 Pc_if EXPR Pc_then
	 	SENTS
	 Pc_end Pc_if Punticoma
  |	 Pc_if EXPR Pc_then
  		SENTS
	 Pc_else
	 	SENTS
	 Pc_end Pc_if Punticoma
  ;

S_CRIDA:
  	 REF Punticoma -- Que passara amb les crides on el valor dels parametres no es pugui calcular en temps de compilacio?
  ;

S_ASSIGN:
	 REF Dospuntsigual EXPR Punticoma
  ;

REF:
	 Identif QS
  ;

QS:
	 QS Q
  |--lambda  
  ;

Q:
	 Punt Identif
  |	 Parentesi_o LEXPR Parentesi_t
  ;

EXPR:
	 E0
  |  E1
  |  E2
  ;

E0:
	 E0 Pc_and E2
  |  E2 Pc_and E2
  ;

E1:
	 E1 Pc_or E2
  |  E2 Pc_or E2
  ;

E2:
	 E2 Op_rel E3
  |  E2 S_mes E3
  |  E2 S_menys E3
  |  E2 S_prod E3
  |  E2 S_quoci E3
  |  E2 Pc_mod E3
  |	 M1 E3 S_prod S_prod E3 
  |  Pc_not E3
  |	 S_menys E3
  |  E3
  ;

E3:
	 REF
  |  Parentesi_o EXPR Parentesi_t
  |  Lit
  ;

M1:
     %prec right
  ;

LEXPR:
	 LEXPR Coma EXPR
  |  EXPR
  ;
%%

	package a_sintactic is
		procedure YYParse;
	end a_sintactic;

	package body a_sintactic is
##
	end a_sintactic;
