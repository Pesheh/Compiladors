with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
with d_atribut; use d_atribut;


package body rutines_lexiques is
    --pragma pure;
    --Definicions
    tn: tnoms; -- Creo que esto deberia ir en un paquete aparte, donde?!
    

    --Procedimientos 
    procedure rl_atom(a: out atribut) is
    begin
     a:= new node(nd_null); 
    end rl_atom;
    
    procedure rl_identifier(a: out atribut; pos: in posicio; text: in String) is
      id: id_nom;
    begin
      a:= new node(nd_id);
        
      put(tn,text,id);

      a.id_pos:= pos; a.id_id:= id;
    end rl_identifier;


    procedure rl_literal(a: out atribut; pos: in posicio; text: in String) is 
      ids: id_str;
    begin
      a:= new node(nd_lit);

      put(tn,text,ids);

      a.lit_pos:= pos; a.lit_ids:= ids;
    end rl_literal;

    procedure rl_op_menor(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= menor; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_menor;
    
    procedure rl_op_major(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= major; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_major;
    
    procedure rl_op_menorigual(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= menorigual; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_menorigual;
    
    procedure rl_op_majorigual(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= majorigual; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_majorigual;
    
    procedure rl_op_igual(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= igual; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_igual;
    
    procedure rl_op_diferent(a: out atribut) is
    begin
      a:= new node(nd_op_rel);

      a.orel_tipus:= diferent; a.orel_ope:= null; a.orel_opd:= null;
    end rl_op_diferent;

end rutines_lexiques;
