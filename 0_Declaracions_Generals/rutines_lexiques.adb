with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
with d_atribut; use d_atribut;


package body rutines_lexiques is
    pragma pure;
    --Definicions
    tn: tnoms; -- Creo que esto deberia ir en un paquete aparte, donde?!
    

    --Procedimientos 
    procedure rl_identifier(a: out atribut; col: in natural; fil: in natural; text: in String) is
        pos: posicio;
        id: id_nom;
    begin
        a:= new node(nd_id);
        
        pos.all:= (fil,col);
        put(tn,text,id);

        a.pos:= pos; a.id:= id;
    end rl_identifier;


    procedure rl_literal(a: out atribut; col: in natural; fil: in natural; text: in String) is 
        pos: posicio;
        ids: id_str;
    begin
        a:= new node(nd_lit);

        pos.all:= (fil,col);
        put(tn,text,ids);

        a.pos:= pos; a.ids:= ids;
    end rl_literal;


    procedure rl_op_rel(a: out atribut; col: in natural; fil: in natural; text: in String) is
        tr: trelacio;
    begin
        a:= new node(nd_op_rel);
        case text is
                "<"  => tr:= menor;
                ">"  => tr:= major;
                "="  => tr:= igual;
                "<=" => tr:= menorigual;
                ">=" => tr:= majorigual;
        end case;

        a.tipus:= tr; a.ope:= null; a.opd:= null;
    end rl_op_rel;


    procedure rl_PC(a: out atribut; col: in natural; fil: in natural; text: in String) is 
    begin
        null;
    end rl_PC;


end rutines_lexiques;
