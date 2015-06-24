
  with a_lexic, kobal_dfa, kobal_io, text_io, kobal_tokens, kobal_goto, kobal_shift_reduce;
  use  a_lexic, text_io, kobal_tokens, kobal_goto, kobal_io, kobal_shift_reduce;

  with decls;
  with decls.d_arbre;
  with semantica; use semantica;
  with semantica.c_arbre; use semantica.c_arbre;
  package body a_sintactic is
procedure YYParse is

   -- Rename User Defined Packages to Internal Names.
    package yy_goto_tables         renames
      Kobal_Goto;
    package yy_shift_reduce_tables renames
      Kobal_Shift_Reduce;
    package yy_tokens              renames
      Kobal_Tokens;

   use yy_tokens, yy_goto_tables, yy_shift_reduce_tables;

   procedure yyerrok;
   procedure yyclearin;


   package yy is

       -- the size of the value and state stacks
       stack_size : constant Natural := 300;

       -- subtype rule         is natural;
       subtype parse_state  is natural;
       -- subtype nonterminal  is integer;

       -- encryption constants
       default           : constant := -1;
       first_shift_entry : constant :=  0;
       accept_code       : constant := -3001;
       error_code        : constant := -3000;

       -- stack data used by the parser
       tos                : natural := 0;
       value_stack        : array(0..stack_size) of yy_tokens.yystype;
       state_stack        : array(0..stack_size) of parse_state;

       -- current input symbol and action the parser is on
       action             : integer;
       rule_id            : rule;
       input_symbol       : yy_tokens.token;


       -- error recovery flag
       error_flag : natural := 0;
          -- indicates  3 - (number of valid shifts after an error occurs)

       look_ahead : boolean := true;
       index      : integer;

       -- Is Debugging option on or off
        DEBUG : constant boolean := TRUE;

    end yy;


    function goto_state
      (state : yy.parse_state;
       sym   : nonterminal) return yy.parse_state;

    function parse_action
      (state : yy.parse_state;
       t     : yy_tokens.token) return integer;

    pragma inline(goto_state, parse_action);


    function goto_state(state : yy.parse_state;
                        sym   : nonterminal) return yy.parse_state is
        index : integer;
    begin
        index := goto_offset(state);
        while  integer(goto_matrix(index).nonterm) /= sym loop
            index := index + 1;
        end loop;
        return integer(goto_matrix(index).newstate);
    end goto_state;


    function parse_action(state : yy.parse_state;
                          t     : yy_tokens.token) return integer is
        index      : integer;
        tok_pos    : integer;
        default    : constant integer := -1;
    begin
        tok_pos := yy_tokens.token'pos(t);
        index   := shift_reduce_offset(state);
        while integer(shift_reduce_matrix(index).t) /= tok_pos and then
              integer(shift_reduce_matrix(index).t) /= default
        loop
            index := index + 1;
        end loop;
        return integer(shift_reduce_matrix(index).act);
    end parse_action;

-- error recovery stuff

    procedure handle_error is
      temp_action : integer;
    begin

      if yy.error_flag = 3 then -- no shift yet, clobber input.
      if yy.debug then
          text_io.put_line("Ayacc.YYParse: Error Recovery Clobbers " &
                   yy_tokens.token'image(yy.input_symbol));
      end if;
        if yy.input_symbol = yy_tokens.end_of_input then  -- don't discard,
        if yy.debug then
            text_io.put_line("Ayacc.YYParse: Can't discard END_OF_INPUT, quiting...");
        end if;
        raise yy_tokens.syntax_error;
        end if;

            yy.look_ahead := true;   -- get next token
        return;                  -- and try again...
    end if;

    if yy.error_flag = 0 then -- brand new error
        yyerror("Syntax Error");
    end if;

    yy.error_flag := 3;

    -- find state on stack where error is a valid shift --

    if yy.debug then
        text_io.put_line("Ayacc.YYParse: Looking for state with error as valid shift");
    end if;

    loop
        if yy.debug then
          text_io.put_line("Ayacc.YYParse: Examining State " &
               yy.parse_state'image(yy.state_stack(yy.tos)));
        end if;
        temp_action := parse_action(yy.state_stack(yy.tos), error);

            if temp_action >= yy.first_shift_entry then
                if yy.tos = yy.stack_size then
                    text_io.put_line(" Stack size exceeded on state_stack");
                    raise yy_Tokens.syntax_error;
                end if;
                yy.tos := yy.tos + 1;
                yy.state_stack(yy.tos) := temp_action;
                exit;
            end if;

        Decrement_Stack_Pointer :
        begin
          yy.tos := yy.tos - 1;
        exception
          when Constraint_Error =>
            yy.tos := 0;
        end Decrement_Stack_Pointer;

        if yy.tos = 0 then
          if yy.debug then
            text_io.put_line("Ayacc.YYParse: Error recovery popped entire stack, aborting...");
          end if;
          raise yy_tokens.syntax_error;
        end if;
    end loop;

    if yy.debug then
        text_io.put_line("Ayacc.YYParse: Shifted error token in state " &
              yy.parse_state'image(yy.state_stack(yy.tos)));
    end if;

    end handle_error;

   -- print debugging information for a shift operation
   procedure shift_debug(state_id: yy.parse_state; lexeme: yy_tokens.token) is
   begin
       text_io.put_line("Ayacc.YYParse: Shift "& yy.parse_state'image(state_id)&" on input symbol "&
               yy_tokens.token'image(lexeme) );
   end;

   -- print debugging information for a reduce operation
   procedure reduce_debug(rule_id: rule; state_id: yy.parse_state) is
   begin
       text_io.put_line("Ayacc.YYParse: Reduce by rule "&rule'image(rule_id)&" goto state "&
               yy.parse_state'image(state_id));
   end;

   -- make the parser believe that 3 valid shifts have occured.
   -- used for error recovery.
   procedure yyerrok is
   begin
       yy.error_flag := 0;
   end yyerrok;

   -- called to clear input symbol that caused an error.
   procedure yyclearin is
   begin
       -- yy.input_symbol := yylex;
       yy.look_ahead := true;
   end yyclearin;


begin
    -- initialize by pushing state 0 and getting the first input symbol
    yy.state_stack(yy.tos) := 0;


    loop

        yy.index := shift_reduce_offset(yy.state_stack(yy.tos));
        if integer(shift_reduce_matrix(yy.index).t) = yy.default then
            yy.action := integer(shift_reduce_matrix(yy.index).act);
        else
            if yy.look_ahead then
                yy.look_ahead   := false;

                yy.input_symbol := yylex;
            end if;
            yy.action :=
             parse_action(yy.state_stack(yy.tos), yy.input_symbol);
        end if;


        if yy.action >= yy.first_shift_entry then  -- SHIFT

            if yy.debug then
                shift_debug(yy.action, yy.input_symbol);
            end if;

            -- Enter new state
            if yy.tos = yy.stack_size then
                text_io.put_line(" Stack size exceeded on state_stack");
                raise yy_Tokens.syntax_error;
            end if;
            yy.tos := yy.tos + 1;
            yy.state_stack(yy.tos) := yy.action;
              yy.value_stack(yy.tos) := yylval;

        if yy.error_flag > 0 then  -- indicate a valid shift
            yy.error_flag := yy.error_flag - 1;
        end if;

            -- Advance lookahead
            yy.look_ahead := true;

        elsif yy.action = yy.error_code then       -- ERROR

            handle_error;

        elsif yy.action = yy.accept_code then
            if yy.debug then
                text_io.put_line("Ayacc.YYParse: Accepting Grammar...");
            end if;
            exit;

        else -- Reduce Action

            -- Convert action into a rule
            yy.rule_id  := -1 * yy.action;

            -- Execute User Action
            -- user_action(yy.rule_id);


                case yy.rule_id is

when  1 =>
--#line  50
rs_Root(
yy.value_stack(yy.tos));

when  2 =>
--#line  58
rs_Proc(
yyval,
yy.value_stack(yy.tos-7),
yy.value_stack(yy.tos-5),
yy.value_stack(yy.tos-3));

when  3 =>
--#line  62
rs_Decls(
yyval,
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  4 =>
--#line  63
rl_atom(
yyval);

when  5 =>
--#line  67
rs_Decl(
yyval,
yy.value_stack(yy.tos));

when  6 =>
--#line  68
rs_Decl(
yyval,
yy.value_stack(yy.tos));

when  7 =>
--#line  69
rs_Decl(
yyval,
yy.value_stack(yy.tos));

when  8 =>
--#line  70
rs_Decl(
yyval,
yy.value_stack(yy.tos));

when  9 =>
--#line  74
rs_Decl_Const(
yyval,
yy.value_stack(yy.tos-6),
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos-1));

when  10 =>
--#line  79
rs_Decl_Var(
yyval,
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos-1));

when  11 =>
--#line  83
rs_Decl_T(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  12 =>
--#line  87
rs_Decl_T_Cont(
yyval,
yy.value_stack(yy.tos-1));

when  13 =>
--#line  90
rs_Decl_T_Cont(
yyval,
yy.value_stack(yy.tos-3));

when  14 =>
--#line  91
rs_Decl_T_Cont(
yyval,
yy.value_stack(yy.tos-4),
yy.value_stack(yy.tos-1));

when  15 =>
--#line  95
rs_DCamps(
yyval,
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  16 =>
--#line  96
rs_DCamps(
yyval,
yy.value_stack(yy.tos));

when  17 =>
--#line  100
rs_DCamp(
yyval,
yy.value_stack(yy.tos));

when  18 =>
--#line  104
rs_C_Proc(
yyval,
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos-1));

when  19 =>
--#line  105
rs_C_Proc(
yyval,
yy.value_stack(yy.tos));

when  20 =>
--#line  109
rs_Args(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  21 =>
--#line  110
rs_Args(
yyval,
yy.value_stack(yy.tos));

when  22 =>
--#line  114
rs_Arg(
yyval,
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  23 =>
--#line  118
rs_Mode_in(
yyval);

when  24 =>
--#line  119
rs_Mode_in_out(
yyval);

when  25 =>
--#line  123
rs_Lid(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  26 =>
--#line  124
rs_Lid(
yyval,
yy.value_stack(yy.tos));

when  27 =>
--#line  128
rs_Rang(
yyval,
yy.value_stack(yy.tos-5),
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos));

when  28 =>
--#line  132
rs_Idx_neg(
yyval,
yy.value_stack(yy.tos));

when  29 =>
--#line  133
rs_Idx_pos(
yyval,
yy.value_stack(yy.tos));

when  30 =>
--#line  137
rs_Idx_Cont(
yyval,
yy.value_stack(yy.tos));

when  31 =>
--#line  138
rs_Idx_Cont(
yyval,
yy.value_stack(yy.tos));

when  32 =>
--#line  142
rs_Sents(
yyval,
yy.value_stack(yy.tos));

when  33 =>
--#line  143
rl_atom(
yyval);

when  34 =>
--#line  147
rs_Sent_Nob(
yyval,
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  35 =>
--#line  148
rs_Sent_Nob(
yyval,
yy.value_stack(yy.tos));

when  36 =>
--#line  152
rs_Sent(
yyval,
yy.value_stack(yy.tos));

when  37 =>
--#line  153
rs_Sent(
yyval,
yy.value_stack(yy.tos));

when  38 =>
--#line  154
rs_Sent(
yyval,
yy.value_stack(yy.tos));

when  39 =>
--#line  155
rs_Sent(
yyval,
yy.value_stack(yy.tos));

when  40 =>
--#line  161
rs_SIter(
yyval,
yy.value_stack(yy.tos-5),
yy.value_stack(yy.tos-3));

when  41 =>
--#line  167
rs_SCond(
yyval,
yy.value_stack(yy.tos-5),
yy.value_stack(yy.tos-3));

when  42 =>
--#line  172
rs_SCond(
yyval,
yy.value_stack(yy.tos-7),
yy.value_stack(yy.tos-5),
yy.value_stack(yy.tos-3));

when  43 =>
--#line  176
rs_SCrida(
yyval,
yy.value_stack(yy.tos-1));

when  44 =>
--#line  180
rs_SAssign(
yyval,
yy.value_stack(yy.tos-3),
yy.value_stack(yy.tos-1));

when  45 =>
--#line  184
rs_Ref(
yyval,
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  46 =>
--#line  188
rs_Qs(
yyval,
yy.value_stack(yy.tos-1),
yy.value_stack(yy.tos));

when  47 =>
--#line  189
rl_atom(
yyval);

when  48 =>
--#line  193
rs_Q(
yyval,
yy.value_stack(yy.tos));

when  49 =>
--#line  194
rs_Q(
yyval,
yy.value_stack(yy.tos-1));

when  50 =>
--#line  198
rs_Expr(
yyval,
yy.value_stack(yy.tos));

when  51 =>
--#line  199
rs_Expr(
yyval,
yy.value_stack(yy.tos));

when  52 =>
--#line  200
rs_Expr(
yyval,
yy.value_stack(yy.tos));

when  53 =>
--#line  204
rs_EAnd(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  54 =>
--#line  205
rs_EAnd(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  55 =>
--#line  209
rs_EOr(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  56 =>
--#line  210
rs_EOr(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  57 =>
--#line  214
rs_EOpo(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos),
yy.value_stack(yy.tos-1));

when  58 =>
--#line  215
rs_EOps(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  59 =>
--#line  216
rs_EOpr(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  60 =>
--#line  217
rs_EOpp(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  61 =>
--#line  218
rs_EOpq(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  62 =>
--#line  219
rs_EOpm(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  63 =>
--#line  220
rs_EOpnl(
yyval,
yy.value_stack(yy.tos));

when  64 =>
--#line  221
rs_EOpna(
yyval,
yy.value_stack(yy.tos));

when  65 =>
--#line  222
rs_EOp(
yyval,
yy.value_stack(yy.tos));

when  66 =>
--#line  226
rs_ET(
yyval,
yy.value_stack(yy.tos));

when  67 =>
--#line  227
rs_ET(
yyval,
yy.value_stack(yy.tos-1));

when  68 =>
--#line  228
rs_ET(
yyval,
yy.value_stack(yy.tos));

when  69 =>
--#line  233
rs_LExpr(
yyval,
yy.value_stack(yy.tos-2),
yy.value_stack(yy.tos));

when  70 =>
--#line  234
rs_LExpr(
yyval,
yy.value_stack(yy.tos));

                    when others => null;
                end case;


            -- Pop RHS states and goto next state
            yy.tos      := yy.tos - rule_length(yy.rule_id) + 1;
            if yy.tos > yy.stack_size then
                text_io.put_line(" Stack size exceeded on state_stack");
                raise yy_Tokens.syntax_error;
            end if;
            yy.state_stack(yy.tos) := goto_state(yy.state_stack(yy.tos-1) ,
                                 get_lhs_rule(yy.rule_id));

              yy.value_stack(yy.tos) := yyval;

            if yy.debug then
                reduce_debug(yy.rule_id,
                    goto_state(yy.state_stack(yy.tos - 1),
                               get_lhs_rule(yy.rule_id)));
            end if;

        end if;


    end loop;


end yyparse;
  end a_sintactic;
