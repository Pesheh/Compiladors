%token pc_procedure pc_is pc_begin pc_end pc_const pc_new pc_type pc_record pc_array pc_of pc_in pc_out pc_in_out pc_null pc_range pc_while pc_loop pc_if pc_then pc_else
%right dospuntsigual 
%right dospunts
%right coma
%left punt punticoma
%right pc_and pc_or
%left s_mes s_menys
%left s_prod s_quoci
%right pc_not
%right lit id
%token parentesi_t
%right parentesi_o
%left dummy
%right dummy_r

%%
PROC:
	 pc_procedure C_PROC pc_is
	 	DECLS
	 pc_begin
	 	SENTS
	 pc_end pc_procedure punticoma
  ;

DECLS:
	 DECLS DECL
  |	 
  ;

DECL:
	 PROC
  |  DECL_VAR
  |  DECL_CONST
  |  DECL_T
  ;

DECL_VAR:
	 LID dospunts id punticoma
  ;

DECL_CONST:
	 LID dospunts pc_const id dospunts IDX punticoma
  ;

DECL_T:
	 pc_type id pc_is DECL_T_CONT
  ;

DECL_T_CONT:
	 pc_new RANG punticoma
  |	 pc_type id pc_is pc_record
  	 	DCAMPS
	 pc_end pc_record punticoma
  |  pc_type id pc_is pc_array parentesi_o LID parentesi_t pc_of id punticoma
  ;
 
DCAMPS:
	 DCAMPS DCAMP
  |  DCAMP
  ;

DCAMP:
	 DECL_VAR
  ;

C_PROC:
	 id parentesi_o ARGS parentesi_t
  |  id
  ;

ARGS:
	 ARGS punticoma ARG
  |  ARG
  ;

ARG:
	 LID dospunts MODE id
  ;

MODE:
	 pc_in
  |	 pc_out
  |  pc_in_out
  ;

LID:
	 LID coma id
  |  id
  ;

RANG:
	 id pc_range IDX punt punt IDX
  ;
  
IDX:
	 OP_U IDX_CONT
  ;

IDX_CONT:
	 lit
  |  id
  ;

SENTS:
	 SENTS_NOB
  |  pc_null punticoma
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
	 pc_while EXPR pc_loop
	 	SENTS
	 pc_end pc_loop punticoma
  ;

S_COND:
	 pc_if EXPR pc_then
	 	SENTS
	 pc_end pc_if punticoma
  |	 pc_if EXPR pc_then
  		SENTS
	 pc_else
	 	SENTS
	 pc_end pc_if punticoma
  ;

S_CRIDA:
	 id parentesi_o PARAMS parentesi_t punticoma
  |  id punticoma
  ;

S_ASSIGN:
	 REF dospuntsigual EXPR punticoma
  ;

REF:
	 id QS
  ;

QS:
	 QS Q
  |  
  ;

Q:
	 punt id
  |	 parentesi_o LEXPR parentesi_t
  ;

PARAMS:
	 LEXPR
  ;

EXPR:
	 E0
  |  E1
  |  E2
  ;

E0:
	 E0 pc_and E2
  |  E2 pc_and E2
  ;

E1:
	 E1 pc_or E2
  |  E2 pc_or E2
  ;

E2:
	 E2 OP_REL E3
  |  E2 s_mes E3
  |  E2 s_menys E3
  |  E2 s_prod E3
  |  E2 s_quoci E3
  |  E3 OP_E E3
  |  pc_not E3
  |	 s_menys E3 %prec dummy
  |  E3
  ;

E3:
	 REF
  |  parentesi_o EXPR parentesi_t
  |  lit
  ;

OP_E:
	s_prod s_prod
  ;

OP_REL:
	 
  ;

OP_U:
	 s_menys %prec dummy
  |  
  ;

LEXPR:
	 LEXPR coma EXPR
  |  EXPR
  ;
%%

##
