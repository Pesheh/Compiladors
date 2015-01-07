with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
with d_atribut; use d_atribut;


package body rutines_lexiques is
    --pragma pure;
    --Definicions
    tn: tnoms; -- Creo que esto deberia ir en un paquete aparte, donde?!
    

    --Procedimientos 
    procedure rl_identifier(a: out atribut; col: in natural; fil: in natural; text: in String) is
        pos: posicio;
        id: id_nom;
    begin
        a:= new node(nd_id);
        
        pos:= (fil,col);
        put(tn,text,id);

        a.id_pos:= pos; a.id_id:= id;
    end rl_identifier;


    procedure rl_literal(a: out atribut; col: in natural; fil: in natural; text: in String) is 
        pos: posicio;
        ids: id_str;
    begin
        a:= new node(nd_lit);

        pos:= (fil,col);
        put(tn,text,ids);

        a.lit_pos:= pos; a.lit_ids:= ids;
    end rl_literal;


    procedure rl_op_rel(a: out atribut; col: in natural; fil: in natural; tr: in trelacio) is
    begin
        a:= new node(nd_op_rel);

        a.orel_tipus:= tr; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_rel;


    procedure rl_in(a: out atribut) is
    begin
        a:= new node(nd_mode);
        a.mode_tipus:= md_in;
    end rl_in;


    procedure rl_in_out(a: out atribut) is
    begin
        a:= new node(nd_mode);
        a.mode_tipus:= md_in_out;
    end rl_in_out;



end rutines_lexiques;
