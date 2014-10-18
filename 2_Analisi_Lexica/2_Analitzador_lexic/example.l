LOWER [a-z]
UPPER [A-Z]
DIGIT[0-9]

%%

\n						{null;}
"Procedure"					{TEXT_IO.PUT_LINE("PROCEDURE"); RETURN PC_procedure;}
"is"						{TEXT_IO.PUT_LINE("IS"); RETURN PC_is;}
"begin"						{TEXT_IO.PUT_LINE("BEGIN"); RETURN PC_begin;}
":"						{TEXT_IO.PUT_LINE("COLON"); RETURN Colon;}
";"						{TEXT_IO.PUT_LINE("SEMICOLON"); RETURN Semicolon;}
":="						{TEXT_IO.PUT_LINE("ASSIGNATION"); RETURN Assignation;}
"<"						{TEXT_IO.PUT_LINE("LESS"); RETURN Less;}
">"						{TEXT_IO.PUT_LINE("MORE"); RETURN More;}
"<="						{TEXT_IO.PUT_LINE("LESS OR EQUAL"); RETURN Less_or_equal;}
">="						{TEXT_IO.PUT_LINE("MORE OR EQUAL"); RETURN More_or_equal;}
"="						{TEXT_IO.PUT_LINE("EQUAL"); RETURN Equal;}
"+"						{TEXT_IO.PUT_LINE("ADDITION"); RETURN Addition;}
"-"						{TEXT_IO.PUT_LINE("SUBSTRACTION"); RETURN Substraction;}
"*"						{TEXT_IO.PUT_LINE("MULTIPLICATION"); RETURN Multiplication;}
"/"						{TEXT_IO.PUT_LINE("DIVISION"); RETURN Division;}
({LOWER}|{UPPER})({LOWER}|{UPPER}|{DIGIT})+	{TEXT_IO.PUT_LINE("IDENTIFIER"); RETURN Identifier;}

\"(([^\"]*)((\"\")*)([^\"]*))*\"		{PUT("STRING   ");PUT_LINE(Example_DFA.YYText);return Str;}
.						{PUT("NOT  ");PUT(Example_DFA.YYText);new_line;return Error;}						

%%

	with d_token,a_lexic; use d_token,a_lexic;
	WITH Example_io,Example_dfa;Use Example_io,Example_dfa;
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
end a_lexic;
