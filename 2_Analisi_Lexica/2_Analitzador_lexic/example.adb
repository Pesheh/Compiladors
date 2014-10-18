with d_token,a_lexic;use d_token,a_lexic;
procedure Example is
	tk		: Token;
begin --Example
	open("file");
	Read_Input:
	loop 
		tk:=YYLex;
		exit Read_Input
			when tk= End_of_Input;
	end loop Read_Input;
	close;
end Example;

