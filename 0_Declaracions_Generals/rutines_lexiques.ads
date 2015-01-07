with d_atribut; use d_atribut;

package rutines_lexiques is
    -- pragma pure;

    --probablemente faltan cosas!!!
    procedure rl_identifier(a: out atribut; col: in natural; fil: in natural; text: in String );
    procedure rl_literal(a: out atribut; col: in natural; fil: in natural; text: in String);
    procedure rl_op_rel(a: out atribut; col: in natural; fil: in natural; tr: in trelacio);
    procedure rl_in(a: out atribut);
    procedure rl_in_out(a: out atribut);

end rutines_lexiques;
