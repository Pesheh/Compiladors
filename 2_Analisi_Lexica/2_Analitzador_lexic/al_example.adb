with pershe_tokens,a_lexic,Ada.Strings.Unbounded,Ada.Text_IO; use pershe_tokens,a_lexic,Ada.Strings.Unbounded,Ada.Text_IO;
procedure al_example is
	tk		: Token;
begin --Example
	open("./al-file");
	Read_Input:
	loop 
		tk:=YYLex;
		New_Line(1);
		--Put_Line("Token: "&YYText);
		exit Read_Input
			when tk= End_of_Input;
	end loop Read_Input;
	close;
end al_example;

