package d_token is 
	type Token is (End_of_Input, Error, Pc_procedure, Pc_is, Pc_begin, Pc_end, Pc_const, Pc_new, Pc_type, Pc_record, Pc_array, Pc_of, Pc_in, Pc_in_out, Pc_null, Pc_range, Pc_while, Pc_loop, Pc_if, Pc_then, Pc_else, Pc_and, Pc_or, Pc_not, Pc_mod, Coma, Punt, Dospunts, Dospuntsigual, Punticoma, Parentesi_o, Parentesi_t, Op_rel, S_mes, S_menys, S_prod, S_quoci, Lit, Identif);
end d_token;
