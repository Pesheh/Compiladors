with  Decls;
with  Decls.d_Arbre;
package Kobal_Tokens is


subtype YYSType is decls.d_arbre.atribut;

    YYLVal, YYVal : YYSType; 
    type Token is
        (End_Of_Input, Error, Pc_Procedure, Pc_Is,
         Pc_Begin, Pc_End, Pc_Const,
         Pc_New, Pc_Type, Pc_Record,
         Pc_Array, Pc_Of, Pc_In,
         Pc_In_Out, Pc_Null, Pc_Range,
         Pc_While, Pc_Loop, Pc_If,
         Pc_Then, Pc_Else, Dospuntsigual,
         Dospunts, Coma, Punt,
         Punticoma, Pc_And, Pc_Or,
         Op_Rel, S_Mes, S_Menys,
         S_Prod, S_Quoci, Pc_Mod,
         Pc_Not, Identif, Lit,
         Parentesi_T, Parentesi_O );

    Syntax_Error : exception;

end Kobal_Tokens;
