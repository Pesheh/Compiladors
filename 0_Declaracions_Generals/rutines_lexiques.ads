with d_atribut; use d_atribut;

package rutines_lexiques is
    -- pragma pure;

    procedure rl_identifier(a: out atribut; col: in natural; fil: in natural; text: in String );
    procedure rl_literal(a: out atribut; col: in natural; fil: in natural; text: in String);
    procedure rl_op_rel(a: out atribut; col: in natural; fil: in natural; tr: in trelacio);

end rutines_lexiques;
