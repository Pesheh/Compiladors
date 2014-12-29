with d_atribut; use d_atribut;

package rutines_lexiques is
    pragma pure;

    --probablemente faltan cosas!!!
    procedure rl_identifier(a: out atribut; col: in natural; fil: in natural; text: in String );
    procedure rl_literal(a: out atribut; col: in natural; fil: in natural; text: in String);
    procedure rl_op_rel(a: out atribut; col: in natural; fil: in natural; text: in String);
    procedure rl_PC(a: out atribut; col: in natural; fil: in natural; text: in String);

end rutines_lexiques;
