
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

function YYLex return Token is
subtype short is integer range -32768..32767;
    yy_act : integer;
    yy_c : short;

-- returned upon end-of-file
YY_END_TOK : constant integer := 0;
YY_END_OF_BUFFER : constant := 50;
subtype yy_state_type is integer;
yy_current_state : yy_state_type;
INITIAL : constant := 0;
yy_accept : constant array(0..130) of short :=
    (   0,
        0,    0,   50,   48,   47,   47,   48,   48,   24,   25,
       39,   37,   27,   38,   26,   40,   43,   43,   28,   29,
       31,   35,   32,   42,   42,   42,   42,   42,   42,   42,
       42,   42,   42,   42,   42,   42,   42,   47,    0,   44,
        0,    0,   36,   43,    0,   30,   33,   34,   42,    0,
       42,   42,   42,   42,   42,   42,   14,   18,    2,   42,
       42,   42,   42,   42,   11,   23,   42,   42,   42,   42,
       42,   42,    0,   45,   46,    0,   43,    0,   22,   42,
       42,   42,   42,    4,    0,   42,   41,    7,   17,   42,
       42,   42,   42,   42,   42,   42,   43,    0,   42,   42,

       42,   15,    0,   13,   20,    1,   42,   42,   16,    8,
       42,   43,   10,    3,    6,    0,   42,   21,   42,   12,
       42,   19,   42,    9,   42,   42,    5,   42,    1,    0
    ) ;

yy_ec : constant array(ASCII.NUL..ASCII.DEL) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    2,    3,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    4,    5,    6,    5,    5,    5,    5,    7,    8,
        9,   10,   11,   12,   13,   14,   15,   16,   17,   17,
       17,   17,   17,   17,   17,   17,   17,   18,   19,   20,
       21,   22,    5,    5,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
       23,   23,   23,   23,   23,   23,   23,   23,   23,   23,
        5,    5,    5,    5,   24,    5,   25,   26,   27,   28,

       29,   30,   31,   32,   33,   23,   23,   34,   35,   36,
       37,   38,   23,   39,   40,   41,   42,   23,   43,   23,
       44,   23,    5,    5,    5,    5,    1
    ) ;

yy_meta : constant array(0..44) of short :=
    (   0,
        1,    1,    2,    3,    3,    3,    3,    3,    3,    3,
        3,    3,    3,    3,    3,    4,    4,    3,    3,    3,
        3,    3,    4,    4,    4,    4,    4,    4,    4,    4,
        4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
        4,    4,    4,    4
    ) ;

yy_base : constant array(0..134) of short :=
    (   0,
        0,    0,  244,  245,   43,   46,  237,    0,  245,  245,
      245,  245,  245,  229,  245,  220,  245,   35,  219,  245,
      218,  245,  217,  213,   29,   31,   30,   37,   34,   32,
       38,   48,   52,   39,   55,   57,   62,   93,  230,  229,
      227,  230,  245,   76,   71,  245,  245,  245,  208,  207,
       74,   75,   79,   80,   81,   83,  206,  102,  205,   85,
       84,   89,   42,   91,  204,  203,   93,   95,   96,  100,
      103,  104,  220,  245,  245,  222,  118,  122,  200,  119,
      112,  109,  122,  199,  185,  116,  197,  196,  195,  123,
      126,  124,  128,  132,  134,  135,  144,  150,  138,  140,

      146,  194,  175,  192,  191,  148,  149,  147,  181,  180,
      150,  179,  178,  177,  156,  159,  160,  175,  161,  174,
      159,  245,  151,  172,  166,  167,  170,  168,   94,  245,
      205,  207,   53,  210
    ) ;

yy_def : constant array(0..134) of short :=
    (   0,
      130,    1,  130,  130,  130,  130,  131,  132,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  133,  133,  133,  133,  133,  133,  133,
      133,  133,  133,  133,  133,  133,  133,  130,  131,  130,
      130,  134,  130,  130,  130,  130,  130,  130,  133,  133,
      133,  133,  133,  133,  133,  133,  133,  133,  133,  133,
      133,  133,  133,  133,  133,  133,  133,  133,  133,  133,
      133,  133,  131,  130,  130,  134,  130,  130,  133,  133,
      133,  133,  133,  133,  130,  133,  133,  133,  133,  133,
      133,  133,  133,  133,  133,  133,  130,  130,  133,  133,

      133,  133,  130,  133,  133,  133,  133,  133,  133,  133,
      133,  130,  133,  133,  133,  130,  133,  133,  133,  133,
      133,  130,  133,  133,  133,  133,  133,  133,  133,    0,
      130,  130,  130,  130
    ) ;

yy_nxt : constant array(0..289) of short :=
    (   0,
        4,    5,    6,    5,    4,    7,    8,    9,   10,   11,
       12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
       22,   23,   24,    4,   25,   26,   27,   24,   28,   24,
       24,   24,   29,   30,   31,   32,   33,   34,   35,   24,
       36,   24,   37,   24,   38,   38,   38,   38,   38,   38,
       44,   44,   50,   50,   50,   50,   49,   50,   45,   53,
       50,   50,   50,   57,   51,   50,   54,   52,   60,   58,
       55,   50,   56,   59,   61,   50,   62,   67,   50,   68,
       50,   65,   89,   69,   63,   50,   78,   78,   70,   64,
       66,   77,   77,   72,   38,   38,   38,   50,   50,   45,

       71,   79,   50,   50,   50,   85,   50,   50,   50,   81,
       84,   87,   50,   80,   50,   82,   50,   50,   50,   50,
       83,   86,   93,   50,   90,   50,   50,   50,   94,   91,
       92,   88,   50,   97,   97,   50,   96,   98,   98,   50,
       95,   45,   50,   99,  100,   50,   50,   50,  101,   50,
      102,   50,  106,  104,  107,   50,  105,   50,   50,   97,
       97,   50,  110,   50,  108,  112,  112,  109,  111,   50,
       50,   50,   50,   50,   50,  114,  117,  118,  120,   50,
      121,  113,   50,   50,   50,  119,  115,  123,  124,   50,
       50,   50,  126,   50,  125,   50,  129,   50,   50,  122,

       50,   50,   45,   50,   50,  128,  127,   39,   39,   41,
       41,   76,   76,   76,   50,   50,  116,   50,   50,   50,
       50,  103,   50,   50,   75,   40,   50,   50,   50,   50,
      130,   50,   75,   74,   73,   40,   50,   48,   47,   46,
       43,   42,   40,  130,    3,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130
    ) ;

yy_chk : constant array(0..289) of short :=
    (   0,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
        1,    1,    1,    1,    5,    5,    5,    6,    6,    6,
       18,   18,   25,   27,   26,   30,  133,   29,   18,   26,
       28,   31,   34,   29,   25,   63,   27,   25,   30,   29,
       28,   32,   28,   29,   31,   33,   32,   34,   35,   35,
       36,   33,   63,   35,   32,   37,   45,   45,   36,   32,
       33,   44,   44,   37,   38,   38,   38,   51,   52,   44,

       36,   51,   53,   54,   55,   58,   56,   61,   60,   53,
       56,   61,   62,   52,   64,   54,   67,  129,   68,   69,
       55,   60,   69,   70,   64,   58,   71,   72,   70,   67,
       68,   62,   82,   77,   77,   81,   72,   78,   78,   86,
       71,   77,   80,   80,   81,   83,   90,   92,   82,   91,
       83,   93,   91,   86,   92,   94,   90,   95,   96,   97,
       97,   99,   95,  100,   93,   98,   98,   94,   96,  101,
      108,  106,  107,  111,  123,  100,  106,  107,  111,  115,
      115,   99,  121,  117,  119,  108,  101,  117,  119,  125,
      126,  128,  123,  127,  121,  124,  128,  120,  118,  116,

      114,  113,  112,  110,  109,  126,  125,  131,  131,  132,
      132,  134,  134,  134,  105,  104,  103,  102,   89,   88,
       87,   85,   84,   79,   76,   73,   66,   65,   59,   57,
       50,   49,   42,   41,   40,   39,   24,   23,   21,   19,
       16,   14,    7,    3,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130,  130,
      130,  130,  130,  130,  130,  130,  130,  130,  130
    ) ;


-- copy whatever the last rule matched to the standard output

procedure ECHO is
begin
   if (text_io.is_open(user_output_file)) then
     text_io.put( user_output_file, yytext );
   else
     text_io.put( yytext );
   end if;
end ECHO;

-- enter a start condition.
-- Using procedure requires a () after the ENTER, but makes everything
-- much neater.

procedure ENTER( state : integer ) is
begin
     yy_start := 1 + 2 * state;
end ENTER;

-- action number for EOF rule of a given start state
function YY_STATE_EOF(state : integer) return integer is
begin
     return YY_END_OF_BUFFER + state + 1;
end YY_STATE_EOF;

-- return all but the first 'n' matched characters back to the input stream
procedure yyless(n : integer) is
begin
        yy_ch_buf(yy_cp) := yy_hold_char; -- undo effects of setting up yytext
        yy_cp := yy_bp + n;
        yy_c_buf_p := yy_cp;
        YY_DO_BEFORE_ACTION; -- set up yytext again
end yyless;

-- redefine this if you have something you want each time.
procedure YY_USER_ACTION is
begin
        null;
end;

-- yy_get_previous_state - get the state just before the EOB char was reached

function yy_get_previous_state return yy_state_type is
    yy_current_state : yy_state_type;
    yy_c : short;
begin
    yy_current_state := yy_start;

    for yy_cp in yytext_ptr..yy_c_buf_p - 1 loop
	yy_c := yy_ec(yy_ch_buf(yy_cp));
	if ( yy_accept(yy_current_state) /= 0 ) then
	    yy_last_accepting_state := yy_current_state;
	    yy_last_accepting_cpos := yy_cp;
	end if;
	while ( yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state ) loop
	    yy_current_state := yy_def(yy_current_state);
	    if ( yy_current_state >= 131 ) then
		yy_c := yy_meta(yy_c);
	    end if;
	end loop;
	yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
    end loop;

    return yy_current_state;
end yy_get_previous_state;

procedure yyrestart( input_file : file_type ) is
begin
   open_input(text_io.name(input_file));
end yyrestart;

begin -- of YYLex
<<new_file>>
        -- this is where we enter upon encountering an end-of-file and
        -- yywrap() indicating that we should continue processing

    if ( yy_init ) then
        if ( yy_start = 0 ) then
            yy_start := 1;      -- first start state
        end if;

        -- we put in the '\n' and start reading from [1] so that an
        -- initial match-at-newline will be true.

        yy_ch_buf(0) := ASCII.LF;
        yy_n_chars := 1;

        -- we always need two end-of-buffer characters. The first causes
        -- a transition to the end-of-buffer state. The second causes
        -- a jam in that state.

        yy_ch_buf(yy_n_chars) := YY_END_OF_BUFFER_CHAR;
        yy_ch_buf(yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;

        yy_eof_has_been_seen := false;

        yytext_ptr := 1;
        yy_c_buf_p := yytext_ptr;
        yy_hold_char := yy_ch_buf(yy_c_buf_p);
        yy_init := false;
-- UMASS CODES :
--   Initialization
        tok_begin_line := 1;
        tok_end_line := 1;
        tok_begin_col := 0;
        tok_end_col := 0;
        token_at_end_of_line := false;
        line_number_of_saved_tok_line1 := 0;
        line_number_of_saved_tok_line2 := 0;
-- END OF UMASS CODES.
    end if; -- yy_init

    loop                -- loops until end-of-file is reached

-- UMASS CODES :
--    if last matched token is end_of_line, we must
--    update the token_end_line and reset tok_end_col.
    if Token_At_End_Of_Line then
      Tok_End_Line := Tok_End_Line + 1;
      Tok_End_Col := 0;
      Token_At_End_Of_Line := False;
    end if;
-- END OF UMASS CODES.

        yy_cp := yy_c_buf_p;

        -- support of yytext
        yy_ch_buf(yy_cp) := yy_hold_char;

        -- yy_bp points to the position in yy_ch_buf of the start of the
        -- current run.
	yy_bp := yy_cp;
	yy_current_state := yy_start;
	loop
		yy_c := yy_ec(yy_ch_buf(yy_cp));
		if ( yy_accept(yy_current_state) /= 0 ) then
		    yy_last_accepting_state := yy_current_state;
		    yy_last_accepting_cpos := yy_cp;
		end if;
		while ( yy_chk(yy_base(yy_current_state) + yy_c) /= yy_current_state ) loop
		    yy_current_state := yy_def(yy_current_state);
		    if ( yy_current_state >= 131 ) then
			yy_c := yy_meta(yy_c);
		    end if;
		end loop;
		yy_current_state := yy_nxt(yy_base(yy_current_state) + yy_c);
	    yy_cp := yy_cp + 1;
if ( yy_current_state = 130 ) then
    exit;
end if;
	end loop;
	yy_cp := yy_last_accepting_cpos;
	yy_current_state := yy_last_accepting_state;

<<next_action>>
	    yy_act := yy_accept(yy_current_state);
            YY_DO_BEFORE_ACTION;
            YY_USER_ACTION;

        if aflex_debug then  -- output acceptance info. for (-d) debug mode
            text_io.put( Standard_Error, "--accepting rule #" );
            text_io.put( Standard_Error, INTEGER'IMAGE(yy_act) );
            text_io.put_line( Standard_Error, "(""" & yytext & """)");
        end if;

-- UMASS CODES :
--   Update tok_begin_line, tok_end_line, tok_begin_col and tok_end_col
--   after matching the token.
        if yy_act /= YY_END_OF_BUFFER and then yy_act /= 0 then
-- Token are matched only when yy_act is not yy_end_of_buffer or 0.
          Tok_Begin_Line := Tok_End_Line;
          Tok_Begin_Col := Tok_End_Col + 1;
          Tok_End_Col := Tok_Begin_Col + yy_cp - yy_bp - 1;
          if yy_ch_buf ( yy_bp ) = ASCII.LF then
            Token_At_End_Of_Line := True;
          end if;
        end if;
-- END OF UMASS CODES.

<<do_action>>   -- this label is used only to access EOF actions
            case yy_act is
		when 0 => -- must backtrack
		-- undo the effects of YY_DO_BEFORE_ACTION
		yy_ch_buf(yy_cp) := yy_hold_char;
		yy_cp := yy_last_accepting_cpos;
		yy_current_state := yy_last_accepting_state;
		goto next_action;



when 1 => 
--# line 39 "kobal.l"
rl_atom(YYLVal); RETURN Pc_procedure;

when 2 => 
--# line 40 "kobal.l"
rl_atom(YYLVal); RETURN Pc_is;

when 3 => 
--# line 41 "kobal.l"
rl_atom(YYLVal); RETURN Pc_begin;

when 4 => 
--# line 42 "kobal.l"
rl_atom(YYLVal); RETURN Pc_end;

when 5 => 
--# line 43 "kobal.l"
rl_atom(YYLVal); RETURN Pc_const;

when 6 => 
--# line 44 "kobal.l"
rl_atom(YYLVal); RETURN Pc_const;

when 7 => 
--# line 45 "kobal.l"
rl_atom(YYLVal); RETURN Pc_new;

when 8 => 
--# line 46 "kobal.l"
rl_atom(YYLVal); RETURN Pc_type;

when 9 => 
--# line 47 "kobal.l"
rl_atom(YYLVal); RETURN Pc_record;

when 10 => 
--# line 48 "kobal.l"
rl_atom(YYLVal); RETURN Pc_array;

when 11 => 
--# line 49 "kobal.l"
rl_atom(YYLVal); RETURN Pc_of;

when 12 => 
--# line 50 "kobal.l"
rl_atom(YYLVal); RETURN Pc_while;

when 13 => 
--# line 51 "kobal.l"
rl_atom(YYLVal); RETURN Pc_loop;

when 14 => 
--# line 52 "kobal.l"
rl_atom(YYLVal); RETURN Pc_if;

when 15 => 
--# line 53 "kobal.l"
rl_atom(YYLVal); RETURN Pc_else;

when 16 => 
--# line 54 "kobal.l"
rl_atom(YYLVal); RETURN Pc_then;

when 17 => 
--# line 55 "kobal.l"
rl_atom(YYLVal); RETURN Pc_not;

when 18 => 
--# line 56 "kobal.l"
rl_atom(YYLVal); RETURN Pc_in;

when 19 => 
--# line 57 "kobal.l"
rl_atom(YYLVal); RETURN Pc_in_out;

when 20 => 
--# line 58 "kobal.l"
rl_atom(YYLVal); RETURN Pc_null;

when 21 => 
--# line 59 "kobal.l"
rl_atom(YYLVal); RETURN Pc_range;

when 22 => 
--# line 60 "kobal.l"
rl_atom(YYLVal); RETURN Pc_and;

when 23 => 
--# line 61 "kobal.l"
rl_atom(YYLVal); RETURN Pc_or;

when 24 => 
--# line 62 "kobal.l"
rl_atom(YYLVal); RETURN Parentesi_o;

when 25 => 
--# line 63 "kobal.l"
rl_atom(YYLVal); RETURN Parentesi_t;

when 26 => 
--# line 64 "kobal.l"
rl_atom(YYLVal); RETURN Punt;

when 27 => 
--# line 65 "kobal.l"
rl_atom(YYLVal); RETURN Coma;

when 28 => 
--# line 66 "kobal.l"
rl_atom(YYLVal); RETURN Dospunts;

when 29 => 
--# line 67 "kobal.l"
rl_atom(YYLVal); RETURN Punticoma;

when 30 => 
--# line 68 "kobal.l"
rl_atom(YYLVal); RETURN Dospuntsigual;

when 31 => 
--# line 69 "kobal.l"
rl_op_menor(YYLVal); RETURN Op_rel;

when 32 => 
--# line 70 "kobal.l"
rl_op_major(YYLVal); RETURN Op_rel;

when 33 => 
--# line 71 "kobal.l"
rl_op_menorigual(YYLVal); RETURN Op_rel;

when 34 => 
--# line 72 "kobal.l"
rl_op_majorigual(YYLVal); RETURN Op_rel;

when 35 => 
--# line 73 "kobal.l"
rl_op_igual(YYLVal); RETURN Op_rel;

when 36 => 
--# line 74 "kobal.l"
rl_op_diferent(YYLVal); RETURN Op_rel;

when 37 => 
--# line 75 "kobal.l"
rl_atom(YYLVal); RETURN S_mes;

when 38 => 
--# line 76 "kobal.l"
rl_atom(YYLVal); RETURN S_menys;

when 39 => 
--# line 77 "kobal.l"
rl_atom(YYLVal); RETURN S_prod;

when 40 => 
--# line 78 "kobal.l"
rl_atom(YYLVal); RETURN S_quoci;

when 41 => 
--# line 79 "kobal.l"
rl_atom(YYLVal); RETURN Pc_mod;

when 42 => 
--# line 80 "kobal.l"
rl_identifier(YYLVal, YYPos, yytext);  RETURN Identif;

when 43 => 
--# line 81 "kobal.l"
rl_literal_ent(YYLVal, YYPos, yytext); RETURN Lit;

when 44 => 
--# line 82 "kobal.l"
rl_literal_str(YYLVal, YYPos, yytext); RETURN Lit;

when 45 => 
--# line 83 "kobal.l"
rl_literal_car(YYLVal, YYPos, yytext); RETURN Lit;

when 46 => 
--# line 84 "kobal.l"
null;

when 47 => 
--# line 85 "kobal.l"
null;

when 48 => 
--# line 86 "kobal.l"
RETURN Error;

when 49 => 
--# line 88 "kobal.l"
ECHO;
when YY_END_OF_BUFFER + INITIAL + 1 => 
    return End_Of_Input;
                when YY_END_OF_BUFFER =>
                    -- undo the effects of YY_DO_BEFORE_ACTION
                    yy_ch_buf(yy_cp) := yy_hold_char;

                    yytext_ptr := yy_bp;

                    case yy_get_next_buffer is
                        when EOB_ACT_END_OF_FILE =>
                            begin
                            if ( yywrap ) then
                                -- note: because we've taken care in
                                -- yy_get_next_buffer() to have set up yytext,
                                -- we can now set up yy_c_buf_p so that if some
                                -- total hoser (like aflex itself) wants
                                -- to call the scanner after we return the
                                -- End_Of_Input, it'll still work - another
                                -- End_Of_Input will get returned.

                                yy_c_buf_p := yytext_ptr;

                                yy_act := YY_STATE_EOF((yy_start - 1) / 2);

                                goto do_action;
                            else
                                --  start processing a new file
                                yy_init := true;
                                goto new_file;
                            end if;
                            end;
                        when EOB_ACT_RESTART_SCAN =>
                            yy_c_buf_p := yytext_ptr;
                            yy_hold_char := yy_ch_buf(yy_c_buf_p);
                        when EOB_ACT_LAST_MATCH =>
                            yy_c_buf_p := yy_n_chars;
                            yy_current_state := yy_get_previous_state;

                            yy_cp := yy_c_buf_p;
                            yy_bp := yytext_ptr;
                            goto next_action;
                        when others => null;
                        end case; -- case yy_get_next_buffer()
                when others =>
                    text_io.put( "action # " );
                    text_io.put( INTEGER'IMAGE(yy_act) );
                    text_io.new_line;
                    raise AFLEX_INTERNAL_ERROR;
            end case; -- case (yy_act)
        end loop; -- end of loop waiting for end of file
end YYLex;
--# line 88 "kobal.l"

    function YYText return String is
    begin
      return kobal_dfa.YYText;
    end YYText;

    function YYLength return Integer is
    begin
      return kobal_dfa.YYLength;
    end YYLength;

  end a_lexic;

