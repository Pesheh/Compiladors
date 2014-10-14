package  is


type key_type is (cval, ival, noval); 

type yystype is record
  register : character;
  value    : integer; 
end record;
        

    YYLVal, YYVal : YYSType; 
    type Token is
        (End_Of_Input, Error, '(', ')',
         Number, Identifier, New_Line,
         '=', '+', '-',
         '*', '/', Dummy,
         Exp );

    Syntax_Error : exception;

end ;
