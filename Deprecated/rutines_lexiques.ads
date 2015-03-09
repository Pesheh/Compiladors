with d_atribut; use d_atribut;

package rutines_lexiques is
    -- pragma pure;

    procedure rl_atom(a: out atribut);
    procedure rl_identifier(a: out atribut; pos: in posicio; text: in String);
    procedure rl_literal(a: out atribut; pos: in posicio; text: in String);
    procedure rl_op_menor(a: out atribut);
    procedure rl_op_major(a: out atribut);
    procedure rl_op_menorigual(a: out atribut);
    procedure rl_op_majorigual(a: out atribut);
    procedure rl_op_igual(a: out atribut);
    procedure rl_op_diferent(a: out atribut);

end rutines_lexiques;
