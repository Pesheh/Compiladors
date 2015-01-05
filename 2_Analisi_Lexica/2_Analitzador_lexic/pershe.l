--alphabetical character
ALPH_C [a-zA-Z]

--graphic char including " and Space
GC [\040-\176] 

--idem as before excluding " 
GC_NON_Q [\040-\041]|[\043-\176] 

--non graphic char and Space
NON_GC [\001-\040]

--digit
D [0-9]

--non zero digit
NZD [1-9]

--numbers like x_yyy, xy_y, xyy_yyy, xyy(_yyy)+ where x != 0
NUM_WITH_LOWERBAR (({D}|{NZD}{D}|{NZD}{D}{D})(_({D}{D}{D}))+)

--numbers not starting with 0
NUM_WITHOUT_LOWERBAR ({NZD}{D}*)

--inner element of a string, it may be a graphic character (without the double quote) or a double double quote.
STRING_BODY (\"\"|{GC_NON_Q}+)*

NUMBER {NUM_WITH_LOWERBAR}|{NUM_WITHOUT_LOWERBAR}

STRING \"{STRING_BODY}\"

IDENTIFIER {ALPH_C}(_?({ALPH_C}|{D}))*

CHARACTER \'{GC}\'

COMMENT \-\-{GC}*\n

OTHERS {NON_GC}+

%%

"procedure"															{ECHO; RETURN Pc_procedure;}
"is"																{ECHO; RETURN Pc_is;}
"begin"																{ECHO; RETURN Pc_begin;}
"end"																{ECHO; RETURN Pc_end;}
"const"																{ECHO; RETURN Pc_const;}
"new"																{ECHO; RETURN Pc_new;}
"type"																{ECHO; RETURN Pc_type;}
"record"															{ECHO; RETURN Pc_record;}
"array"																{ECHO; RETURN Pc_array;}
"of"																{ECHO; RETURN Pc_of;}
"while"																{ECHO; RETURN Pc_while;}
"loop"																{ECHO; RETURN Pc_loop;}
"if"																{ECHO; RETURN Pc_if;}
"else"																{ECHO; RETURN Pc_else;}
"then"																{ECHO; RETURN Pc_then;}
"not"																{ECHO; RETURN Pc_not;}
"in"																{ECHO; RETURN Pc_in;}
"in out"															{ECHO; RETURN Pc_in_out;}
"null"																{ECHO; RETURN Pc_null;}
"range"																{ECHO; RETURN Pc_range;}
"and"																{ECHO; RETURN Pc_and;}
"or"																{ECHO; RETURN Pc_or;}
"("																	{ECHO; RETURN Parentesi_o;}
")"																	{ECHO; RETURN Parentesi_t;}
"."																	{ECHO; RETURN Punt;}
","																	{ECHO; RETURN Coma;}
":"																	{ECHO; RETURN Dospunts;}
";"																	{ECHO; RETURN Punticoma;}
":="																{ECHO; RETURN Dospuntsigual;}
"<"																	{ECHO; RETURN Op_rel;}
">"																	{ECHO; RETURN Op_rel;}
"<="																{ECHO; RETURN Op_rel;}
">="																{ECHO; RETURN Op_rel;}
"="																	{ECHO; RETURN Op_rel;}
"/="																{ECHO; RETURN Op_rel;}
"+"																	{ECHO; RETURN S_mes;}
"-"																	{ECHO; RETURN S_menys;}
"*"																	{ECHO; RETURN S_prod;}
"/"																	{ECHO; RETURN S_quoci;}
"mod"																{ECHO; RETURN Pc_mod;}
{IDENTIFIER}														{ECHO; put(" Id"); RETURN Identif;}
{NUMBER}															{ECHO; put(" Num"); RETURN Lit;}
{STRING}															{ECHO; put(" Str"); RETURN Lit;}
{CHARACTER}															{ECHO; RETURN Lit;}

-- els comentaris no ens importen per re?
{COMMENT}															{ECHO; put(" Comm");}
{OTHERS}															{null;}
.																	{put("ERR: "); ECHO; RETURN Error;}

%%

	with pershe_tokens; use pershe_tokens;
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
				Put(yytext);
				--for i in (yy_ch_buf'first)..(yy_cp-1) loop --no estic segur de que sigui correcte al 100% pero...	
					-- if character != newline, horitzontal tab and space
				--	if yy_ch_buf(i)/=character'Val(10) and yy_ch_buf(i)/=character'Val(9) and yy_ch_buf(i)/=character'Val(32) then 
				--		put(yy_ch_buf(i));j:=j+1;
				--	end if;
				--end loop;
				--New_Line(2);
				--k:=0;
				--while k<j loop
				--	Put(" ");
				--	k:=k+1;
				--end loop;
				--Put("^");
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
	with pershe_tokens,a_lexic; use pershe_tokens,a_lexic;
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
					when Identif => 	d_tnoms.put(tn,YYText,id); New_Line(1);ids(i):=id; i:=i+1; Put_Line("ID:"&YYText); 
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

