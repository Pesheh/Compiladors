with d_token,a_lexic,Ada.Integer_Text_IO,Ada.Strings.Unbounded,Ada.Text_IO, Ada.Command_Line; use d_token,a_lexic,Ada.Strings.Unbounded,Ada.Text_IO, Ada.Command_Line,Ada.Integer_Text_IO;
with d_tnoms, general_defs; use d_tnoms, general_defs;
procedure C_Tnoms is
	tk		: Token;
	s		: Unbounded_String;
	tn		: tnoms;
	i,i2,j		: Integer;
	id		: general_defs.id_nom;
	ids		: array(1..50) of general_defs.id_nom; --50 son prous elements per un joc de proves petit
	id_st 	: general_defs.id_str;
	ids_str	: array(1..50) of general_defs.id_str;
begin 
	if Argument_Count=1 then
		open(Argument(1)); --per fer proves
	else
		open("./al-file");
	end if;
	i:=1; i2:=1;
	empty(tn);
	Read_Input:
	loop 
		tk:=YYLex;
		s:=To_Unbounded_String(YYText);
		
		case tk is
			when Error => Put_Line("Error: "&To_String(s));
			when Identifier => 	d_tnoms.put(tn,To_String(s),id);ids(i):=id; i:=i+1; Put_Line("ID:"&To_String(s)); 
			when Str => d_tnoms.put(tn,To_String(s),id_st); ids_str(i2):=id_st; i2:=i2+1; Put_Line("STR:"&To_String(s));
			when End_Of_Input => Put_Line("EOF");
			when others => Put_Line(To_String(s));
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
end C_Tnoms;

