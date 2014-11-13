CAR [a-zA-Z]
D1[1-9]
D2[0-9]


R_KEYWORDS ["procedure"|"is"|"begin"|"end"|"type"|"record"|"new"|"array"|"of"|"while"|"loop"|"if"|"else"|"then"|"not"|"in"|"out"|"in out"|"range"]
TERMINALS ["("|")"|":"|";"|":="|"<"|">"|"<="|">="|"="|"+"|"-"|"*"|"/"|"mod"|"**"]
--NUMBER (({D2}|{D1}{D2}|{D1}{D2}{D2})(_({D2}{D2}{D2}))+)|({D1}({D2}*))
NUMBER ({D2}|{D1}{D2}|{D1}{D2}{D2})(_?({D2}{D2}{D2}))*
CHARACTER \'\001-\177]\'
STRING \"(([^\"]*)((\"\")*)([^\"]*))*\"
IDENTIFIER {CAR}({CAR}|{D2})*
COMMENT \-\-([^"\n"])*"\n"
OTHERS [\n\t" "]+

%%

"procedure"															{TEXT_IO.PUT_LINE("PROCEDURE"); RETURN PC_procedure;}
"is"																{TEXT_IO.PUT_LINE("IS"); RETURN PC_is;}
"begin"																{TEXT_IO.PUT_LINE("BEGIN"); RETURN PC_begin;}
"end"																{TEXT_IO.PUT_LINE("END"); RETURN PC_end;}
"type"																{TEXT_IO.PUT_LINE("END"); RETURN PC_end;}
"record"															{TEXT_IO.PUT_LINE("RECORD"); RETURN PC_record;}
"new"																{TEXT_IO.PUT_LINE("NEW"); RETURN PC_new;}
"array"																{TEXT_IO.PUT_LINE("ARRAY"); RETURN PC_array;}
"of"																{TEXT_IO.PUT_LINE("OF"); RETURN PC_of;}
"while"																{TEXT_IO.PUT_LINE("WHILE"); RETURN PC_while;}
"loop"																{TEXT_IO.PUT_LINE("LOOP"); RETURN PC_loop;}
"if"																{TEXT_IO.PUT_LINE("IF"); RETURN PC_if;}
"else"																{TEXT_IO.PUT_LINE("ELSE"); RETURN PC_else;}
"then"																{TEXT_IO.PUT_LINE("THEN"); RETURN PC_then;}
"not"																{TEXT_IO.PUT_LINE("NOT"); RETURN PC_not;}
"in"																{TEXT_IO.PUT_LINE("IN"); RETURN PC_in;}
"out"																{TEXT_IO.PUT_LINE("OUT"); RETURN PC_out;}
"in out"															{TEXT_IO.PUT_LINE("IN_OUT"); RETURN PC_in_out;}
"range"																{TEXT_IO.PUT_LINE("RANGE"); RETURN PC_range;}
-- Id.id:=.. <<< com repr el '.'? o mes ben dit, que acceptam aqui?
"("																	{TEXT_IO.PUT_LINE("BRACKET_L"); RETURN Bracket_Left;}
")"																	{TEXT_IO.PUT_LINE("BRACKET_R"); RETURN Bracket_Right;}
":"																	{TEXT_IO.PUT_LINE("COLON"); RETURN Colon;}
";"																	{TEXT_IO.PUT_LINE("SEMICOLON"); RETURN Semicolon;}
":="																{TEXT_IO.PUT_LINE("ASSIGNATION"); RETURN Assignation;}
"<"																	{TEXT_IO.PUT_LINE("LESS"); RETURN Less;}
">"																	{TEXT_IO.PUT_LINE("MORE"); RETURN More;}
"<="																{TEXT_IO.PUT_LINE("LESS OR EQUAL"); RETURN Less_or_equal;}
">="																{TEXT_IO.PUT_LINE("MORE OR EQUAL"); RETURN More_or_equal;}
"="																	{TEXT_IO.PUT_LINE("EQUAL"); RETURN Equal;}
"+"																	{TEXT_IO.PUT_LINE("ADDITION"); RETURN Addition;}
"-"																	{TEXT_IO.PUT_LINE("SUBSTRACTION"); RETURN Substraction;}
"*"																	{TEXT_IO.PUT_LINE("MULTIPLICATION"); RETURN Multiplication;}
"/"																	{TEXT_IO.PUT_LINE("DIVISION"); RETURN Division;}
"mod"																{TEXT_IO.PUT_LINE("MODULUS"); RETURN Module;}
"**"																{TEXT_IO.PUT_LINE("POW"); RETURN Power;}
{IDENTIFIER}														{TEXT_IO.PUT_LINE("IDENTIFIER"); RETURN Identifier;}
{NUMBER}															{TEXT_IO.PUT_LINE("INTEGER"); RETURN Number;}
{STRING}															{TEXT_IO.PUT_LINE("STRING"); RETURN Str;}
{CHARACTER}															{TEXT_IO.PUT_LINE("CHARACTER"); RETURN Char;}
{COMMENT}															{TEXT_IO.PUT_LINE("COMMENT"); RETURN Comment;}
{OTHERS}															{null;}
<*>																	{TEXT_IO.PUT_LINE("ERROR"); RETURN Error;}
-- [^({R_KEYWORDS}|{TERMINALS}|{IDENTIFIER}|{NUMBER}|{STRING}|{CHARACTER}|{COMMENT}|{OTHERS})]* {TEXT_IO.PUT_LINE("ERROR"); RETURN Error;}

%%

	with d_token; use d_token;
	with pershe_io,pershe_dfa;use pershe_io,pershe_dfa;
	package a_lexic is
        procedure open(name: in String);
        procedure close;
        function YYLex return Token;    -- YYText?

		--Auxiliar functions to allow external packages use these *_dfa functions
		function YYText return String;
		function YYLength return Integer;
	end a_lexic;

	package body a_lexic is
        procedure open(name: in String) is
        begin
                Open_Input(name);
        end open;

        procedure close is
        begin
                Close_Input;
        end close;
##
		--Auxiliar functions to allow external packages use these *_dfa functions
		function YYText return String is
		begin
			return pershe_dfa.YYText;
		end YYText;

		function YYLength return Integer is
		begin
			return pershe_dfa.YYLength;
		end YYLength;
	end a_lexic;

