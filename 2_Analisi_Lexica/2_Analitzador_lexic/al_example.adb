with d_token,a_lexic,Ada.Strings.Unbounded,Ada.Text_IO; use d_token,a_lexic,Ada.Strings.Unbounded,Ada.Text_IO;
procedure al_example is
	tk		: Token;
begin --Example
	open("./al-file");
	Read_Input:
	loop 
		tk:=YYLex;
		Put_Line("L"&YYText);
		exit Read_Input
			when tk= End_of_Input;
	end loop Read_Input;
	close;
end al_example;

