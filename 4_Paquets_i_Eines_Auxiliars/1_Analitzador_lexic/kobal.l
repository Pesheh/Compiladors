-- alphabetical character
ALPH_C [a-zA-Z]

-- graphic char including " and Space
GC [\040-\176]

-- idem as before excluding "
GC_NON_Q [\040-\041\043-\176]

-- digit
D [0-9]

-- non zero digit
NZD [1-9]

-- numbers like x_yyy, xy_yyy, xyy_yyy, xyy(_yyy)+ where x != 0
NUM_WITH_LOWERBAR ({NZD}|{NZD}{D}|{NZD}{D}{D})(_{D}{D}{D})+

-- numbers. Zero included
NUM_WITHOUT_LOWERBAR {D}|({NZD}{D}*)

-- inner element of a string, it may be a graphic character (without the double quote) or a double double quote.
STRING_BODY (\"\"|{GC_NON_Q}+)*

NUMBER {NUM_WITH_LOWERBAR}|{NUM_WITHOUT_LOWERBAR}

STRING \"{STRING_BODY}\"

IDENTIFIER {ALPH_C}(_?({ALPH_C}|{D}))*

CHARACTER \'{GC}\'

COMMENT "--"{GC}*\n

SEPARATOR [ \t\n]+

%%

"procedure"|"proc"                  {rl_atom(YYLVal); RETURN Pc_procedure;}
"is"                                {rl_atom(YYLVal); RETURN Pc_is;}
"begin"                             {rl_atom(YYLVal); RETURN Pc_begin;}
"end"                               {rl_atom(YYLVal); RETURN Pc_end;}
"constant"                          {rl_atom(YYLVal); RETURN Pc_const;}
"const"                             {rl_atom(YYLVal); RETURN Pc_const;}
"new"                               {rl_atom(YYLVal); RETURN Pc_new;}
"type"                              {rl_atom(YYLVal); RETURN Pc_type;}
"record"                            {rl_atom(YYLVal); RETURN Pc_record;}
"array"                             {rl_atom(YYLVal); RETURN Pc_array;}
"of"                                {rl_atom(YYLVal); RETURN Pc_of;}
"while"                             {rl_atom(YYLVal); RETURN Pc_while;}
"loop"                              {rl_atom(YYLVal); RETURN Pc_loop;}
"if"                                {rl_atom(YYLVal); RETURN Pc_if;}
"else"                              {rl_atom(YYLVal); RETURN Pc_else;}
"then"                              {rl_atom(YYLVal); RETURN Pc_then;}
"not"                               {rl_atom(YYLVal); RETURN Pc_not;}
"in"                                {rl_atom(YYLVal); RETURN Pc_in;}
"in out"                            {rl_atom(YYLVal); RETURN Pc_in_out;}
"null"                              {rl_atom(YYLVal); RETURN Pc_null;}
"range"                             {rl_atom(YYLVal); RETURN Pc_range;}
"and"                               {rl_atom(YYLVal); RETURN Pc_and;}
"or"                                {rl_atom(YYLVal); RETURN Pc_or;}
"("                                 {rl_atom(YYLVal); RETURN Parentesi_o;}
")"                                 {rl_atom(YYLVal); RETURN Parentesi_t;}
"."                                 {rl_atom(YYLVal); RETURN Punt;}
","                                 {rl_atom(YYLVal); RETURN Coma;}
":"                                 {rl_atom(YYLVal); RETURN Dospunts;}
";"                                 {rl_atom(YYLVal); RETURN Punticoma;}
":="                                {rl_atom(YYLVal); RETURN Dospuntsigual;}
"<"                                 {rl_op_menor(YYLVal); RETURN Op_rel;}
">"                                 {rl_op_major(YYLVal); RETURN Op_rel;}
"<="                                {rl_op_menorigual(YYLVal); RETURN Op_rel;}
">="                                {rl_op_majorigual(YYLVal); RETURN Op_rel;}
"="                                 {rl_op_igual(YYLVal); RETURN Op_rel;}
"/="                                {rl_op_diferent(YYLVal); RETURN Op_rel;}
"+"                                 {rl_atom(YYLVal); RETURN S_mes;}
"-"                                 {rl_atom(YYLVal); RETURN S_menys;}
"*"                                 {rl_atom(YYLVal); RETURN S_prod;}
"/"                                 {rl_atom(YYLVal); RETURN S_quoci;}
"mod"                               {rl_atom(YYLVal); RETURN Pc_mod;}
{IDENTIFIER}                        {rl_identifier(YYLVal, YYPos, yytext);  RETURN Identif;}
{NUMBER}                            {rl_literal_ent(YYLVal, YYPos, yytext); RETURN Lit;}
{STRING}                            {rl_literal_str(YYLVal, YYPos, yytext); RETURN Lit;}
{CHARACTER}                         {rl_literal_car(YYLVal, YYPos, yytext); RETURN Lit;}
{COMMENT}                           {null;}
{SEPARATOR}                         {null;}
.                                   {RETURN Error;}

%%

  with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;
  with kobal_io,kobal_dfa;use kobal_io,kobal_dfa;
  with decls; use decls;
  with decls.d_arbre;
  with kobal_tokens;
  package a_lexic is
    procedure open(name: in String);
    procedure close;
    procedure YYError(s: in String);
    function YYPos return decls.d_arbre.posicio;
    function YYLex return kobal_tokens.Token;

    --Auxiliar functions to allow external packages use these *_dfa functions
    function YYText return String;
    function YYLength return Integer;
  end a_lexic;

  with decls; use decls;
  with decls.d_arbre; use decls.d_arbre;
  with decls.d_descripcio; use decls.d_descripcio;
  with semantica; use semantica;
  with semantica.c_arbre; use semantica.c_arbre;
  with kobal_tokens; use kobal_tokens;
  package body a_lexic is

    procedure open(name: in String) is
    begin
      Open_Input(name);
    end open;

    procedure close is
    begin
      Close_Input;
    end close;

    procedure YYError(s: in String) is
    begin
      put(s);
    end YYError;

    function YYPos return decls.d_arbre.posicio is
    begin
      return (tok_begin_line, tok_begin_col);
    end YYPos;

##

    function YYText return String is
    begin
      return kobal_dfa.YYText;
    end YYText;

    function YYLength return Integer is
    begin
      return kobal_dfa.YYLength;
    end YYLength;

  end a_lexic;
