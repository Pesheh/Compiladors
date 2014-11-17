
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
			empty(tn);
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


