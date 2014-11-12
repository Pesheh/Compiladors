package d_token is 
	type Token is (End_of_Input,Error,PC_procedure,PC_is,PC_begin,PC_end,PC_record,PC_new,PC_array,PC_of,PC_while,PC_loop,PC_if,PC_else,PC_then,PC_not,PC_in,PC_out,PC_in_out,PC_range,Bracket_Left,Bracket_Right,Colon,Semicolon,Assignation,Less,More,Less_or_equal,More_or_equal,Equal,Addition,Substraction,
			Multiplication,Division,Module,Power,Identifier,Str,Char,Number,Comment);
end d_token;
