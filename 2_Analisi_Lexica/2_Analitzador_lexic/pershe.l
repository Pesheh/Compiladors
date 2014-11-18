CAR [a-zA-Z]
D1[1-9]
D2[0-9]

-- R_KEYWORDS ["procedure"|"is"|"begin"|"end"|"type"|"record"|"new"|"array"|"of"|"while"|"loop"|"if"|"else"|"then"|"not"|"in"|"out"|"in out"|"range"]
-- TERMINALS ["("|")"|":"|";"|":="|"<"|">"|"<="|">="|"="|"+"|"-"|"*"|"/"|"mod"|"**"]
-- NUMBER (({D2}|{D1}{D2}|{D1}{D2}{D2})(_({D2}{D2}{D2}))+)|({D1}({D2}*))
NUMBER ({D2}|{D1}{D2}|{D1}{D2}{D2})(_?({D2}{D2}{D2}))*
CHARACTER \'[\001-\177]\'
STRING \"(([^\"]*)((\"\")*)([^\"]*))*\"
IDENTIFIER {CAR}(_?({CAR}|{D2}))*
COMMENT \-\-([^"\n"])*"\n"
OTHERS [\n\t" "]+

%%

"procedure"															{ECHO; RETURN PC_procedure;}
"is"																{ECHO; RETURN PC_is;}
"begin"																{ECHO; RETURN PC_begin;}
"end"																{ECHO; RETURN PC_end;}
"type"																{ECHO; RETURN PC_end;}
"record"															{ECHO; RETURN PC_record;}
"new"																{ECHO; RETURN PC_new;}
"array"																{ECHO; RETURN PC_array;}
"of"																{ECHO; RETURN PC_of;}
"while"																{ECHO; RETURN PC_while;}
"loop"																{ECHO; RETURN PC_loop;}
"if"																{ECHO; RETURN PC_if;}
"else"																{ECHO; RETURN PC_else;}
"then"																{ECHO; RETURN PC_then;}
"not"																{ECHO; RETURN PC_not;}
"in"																{ECHO; RETURN PC_in;}
"out"																{ECHO; RETURN PC_out;}
"in out"															{ECHO; RETURN PC_in_out;}
"range"																{ECHO; RETURN PC_range;}
-- Id.id:=.. <<< com repr el '.'? o mes ben dit, que acceptam aqui?
"("																	{ECHO; RETURN Bracket_Left;}
")"																	{ECHO; RETURN Bracket_Right;}
":"																	{ECHO; RETURN Colon;}
";"																	{ECHO; RETURN Semicolon;}
":="																{ECHO; RETURN Assignation;}
"<"																	{ECHO; RETURN Less;}
">"																	{ECHO; RETURN More;}
"<="																{ECHO; RETURN Less_or_equal;}
">="																{ECHO; RETURN More_or_equal;}
"="																	{ECHO; RETURN Equal;}
"+"																	{ECHO; RETURN Addition;}
"-"																	{ECHO; RETURN Substraction;}
"*"																	{ECHO; RETURN Multiplication;}
"/"																	{ECHO; RETURN Division;}
"mod"																{ECHO; RETURN Module;}
"**"																{ECHO; RETURN Power;}
{IDENTIFIER}														{ECHO; RETURN Identifier;}
{NUMBER}															{ECHO; RETURN Number;}
{STRING}															{ECHO; RETURN Str;}
{CHARACTER}															{ECHO; RETURN Char;}
{COMMENT}															{ECHO; RETURN Comment;}
{OTHERS}															{null;}
.																	{rec_Err; RETURN Error;}--{ECHO; RETURN Error;}
-- [^({R_KEYWORDS}|{TERMINALS}|{IDENTIFIER}|{NUMBER}|{STRING}|{CHARACTER}|{COMMENT}|{OTHERS})]* {ECHO; RETURN Error;}

%%

	with d_token; use d_token;
	with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;
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
		--procediments locals del reconeixedor;
		procedure rec_Err;
		--variables locals del reconeixedor
		ometre:boolean:=false; pometre:boolean:=false;
		tok_begin_line_prev:integer:=0;
        
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

	--v1.1 -> To do:
	--		  Afegir que assenyali CADA un dels caracters erronis en una sola linea -_...XD
	--		  Gar el func de la part experimental
	--		  Mirar a veure si el contingut de yy_ch_buf es buida i per tant el metode fa aiguesxD 
		procedure rec_Err is 
			j,k:integer;
		begin
			if not ometre then
				ometre:=true; tok_begin_line_prev:=tok_begin_line;
				j:=1; 
				Put("Caracter no reconegut:"); j:=j+22;
				Put(tok_begin_line,width=>1,base=>10);Put(":");Put(tok_begin_col,width=>1,base=>10);Put(":: ");
				j:=j+(Integer'Image(tok_begin_line)'Length)+(Integer'Image(tok_begin_col)'Length)+2;
				Put(">>");
				for i in (yy_ch_buf'first)..(yy_cp-1) loop --no estic segur de que sigui correcte al 100% pero...	
					-- if character != newline, horitzontal tab and space
					if yy_ch_buf(i)/=character'Val(10) and yy_ch_buf(i)/=character'Val(9) and yy_ch_buf(i)/=character'Val(32) then 
						put(yy_ch_buf(i));j:=j+1;
					end if;
				end loop;
				New_Line(2);
				k:=0;
				while k<j loop
					Put(" ");
					k:=k+1;
				end loop;
				Put("^");
			else --Experimental
				if yy_ch_buf(yy_cp)=';' or tok_begin_line_prev<tok_begin_line or yy_ch_buf(yy_cp)=' ' or yy_ch_buf(yy_cp)=character'Val(9) then
					ometre:=false; pometre:=false;
					New_Line(1);
				else
					if not pometre then
						Put_Line("Tots els altres errors que pertanyen a la mateixa paraula omesos"); pometre:=true;
					end if;
				end if;
			end if;
		end rec_Err;

	end a_lexic;

	with Ada.Text_IO,Ada.Integer_Text_IO,Ada.Command_Line; use Ada.Text_IO,Ada.Integer_Text_IO,Ada.Command_Line;
	with d_token,a_lexic; use d_token,a_lexic;
	with d_tnoms, general_defs; use d_tnoms, general_defs;
	procedure C_Tnoms is
		tk		: Token;
		tn		: tnoms;
		i,i2,j		: Integer;
		id		: general_defs.id_nom;
		ids		: array(1..50) of general_defs.id_nom; --50 son prous elements per un joc de proves petit
		id_st 	: general_defs.id_str;
		ids_str	: array(1..50) of general_defs.id_str;
	begin 
		if Argument_Count=1 then
			open(Argument(1)); --per fer proves
			i:=1; i2:=1;
		--	empty(tn);
			Read_Input:
			loop 
				tk:=YYLex;
		
				case tk is
					when Identifier => 	d_tnoms.put(tn,YYText,id); New_Line(1);ids(i):=id; i:=i+1; Put_Line("ID:"&YYText); 
					when Str => d_tnoms.put(tn,YYText,id_st); New_Line(1);ids_str(i2):=id_st; i2:=i2+1; Put_Line("STR:"&YYText);
					when End_Of_Input => Put_Line("EOF");
					when others => New_Line(1);
				end case;

			exit Read_Input
				when tk= End_of_Input;
			end loop Read_Input;

			Put_Line("Tnoms content:");
			j:=1; 
			while j<i loop
				Put_Line("Id("&ids(j)'Img&"):"&get(tn,ids(j)));
				j:=j+1;
			end loop;
			j:=1;
			while j<i2 loop
				Put_Line("Str("&ids_str(j)'Img&"):"&get(tn,ids_str(j)));
				j:=j+1;
			end loop;
			close;
		else
			Put("Usage: ./c_tnoms <file name>.p");
		end if;
	end C_Tnoms;

