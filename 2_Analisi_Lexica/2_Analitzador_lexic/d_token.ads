package d_token is 
	type Token is (End_of_Input,Error,PC_procedure,PC_is,PC_begin, Colon,Semicolon,Assignation,Less,More,Less_or_equal,More_or_equal,Equal,Addition,Substraction,
			Multiplication,Division,Identifier,Str,Char,Number,Comment);
end d_token;
