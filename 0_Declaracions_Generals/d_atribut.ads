with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
package d_atribut is
    --pragma pure; 
    
    --!!!probablemente faltan cosas o hay cosas incorrectas!!!
    type node;
    type atribut is access node;
    type pnode is access node;
    type tnode is (nd_null,nd_id,nd_lit,nd_op_rel,nd_PC);

    type trelacio is (menor,major,menorigual,majorigual,igual,diferent);
    type posicio is
        record
            fila: natural;
            columna: natural;
        end record;
    
    type node(tn: tnode:= nd_null) is
        record
            case tn is
				when nd_null 	=> 
					null;
				when nd_id 		=> 
					id: id_nom; 
					id_pos: posicio;
				when nd_lit		=>
					ids: id_str; 
					lit_pos: posicio;
				when nd_op_rel 	=>     
					tipus: trelacio;
					ope,opd: pnode; -- operador esquerra/dreta
				when nd_PC 		=> 
					null; 
            end case;
        end record;

end d_atribut;
