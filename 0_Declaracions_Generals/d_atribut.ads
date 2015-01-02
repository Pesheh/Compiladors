with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
package d_atribut is
    pragma pure; 
    
    --!!!probablemente faltan cosas o hay cosas incorrectas!!!
    type node;
    type atribut is access node;
    type pnode is access node;
    type tnode(nd_nul,nd_id,nd_lit,nd_op_rel,nd_PC);

    type trelacio(menor,major,menorigual,majorigual,igual);
    type posicio is
        record
            fila: natural;
            columna: natural;
        end record;
    
    type node(tn: tnode:= nd_nul) is
        record
            case tn is
                    nd_null=> null;

                    nd_id=> id: id_nom; 
                            pos: posicio;

                    nd_lit=> ids: id_str; 
                             pos: posicio;
            
                    nd_op_rel=>     tipus: trelacio;
                                    ope,opd: pnode; -- operador esquerra/dreta
                    
                    nd_PC=> null; 

            end case;
        end record;

end d_atribut;
