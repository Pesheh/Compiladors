with d_tnoms; use d_tnoms;
with general_defs; use general_defs;
package d_atribut is
    --pragma pure; 
    
    --!!!probablemente faltan cosas o hay cosas incorrectas!!!
	type node;
	type atribut is access node;
    type pnode is access node;
    -- nd arg inclou el mode. Estan todos los tipos, pero tal vez faltan mas o sobran algunos.
	type tnode is (nd_null,
				   nd_proc,
				   nd_decls,
				   nd_decl,
				   nd_decl_var,
				   nd_decl_const,
				   nd_decl_t,
				   nd_decl_t_cont,
				   nd_dcamps,
				   nd_dcamp,
				   nd_c_proc,
				   nd_args,
				   nd_arg,
                   nd_mode,
				   nd_lid,
				   nd_rang,
				   nd_idx,
				   nd_idx_cont,
				   nd_sents,
				   nd_sents_nob,
				   nd_sent,
				   nd_siter,
				   nd_scond,
				   nd_scrida,
				   nd_sassign,
				   nd_ref,
				   nd_qs,
				   nd_q,
				   nd_expr,
				   nd_e0,
				   nd_e1,
				   nd_e2,
				   nd_e3,
				   nd_lexpr,
				   nd_id,
				   nd_lit,
				   nd_op_rel);

    type trelacio is (menor,major,menorigual,majorigual,igual,diferent);
    type tmode is (md_in,md_in_out);
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
				
                when nd_lid | nd_decl_var	=>
					fe,fd: pnode;
                
                when nd_mode    =>
                    tmd: tmode;
                
                when nd_c_proc  =>
                    proc_id: pnode;
                    args: pnode;
                
                when nd_proc    =>
                    cproc: pnode;
                    decls: pnode;
                    sents: pnode;
			
                when nd_args    =>
                    args: pnode;
                    arg: pnode;
                
                when nd_arg =>
                    idarg: id_nom;
                    darg: descripcio;
                    mode: pnode;

                when nd_decls   =>
                    decls: pnode;
                    decl: pnode;

                when nd_decl    =>
                    decl_real: pnode;

                when nd_decl_var    =>
                   null; 

                when others => -- Anar substituint aquests 'others' amb els corresponents tipusXD
					null;
            end case;
        end record;

end d_atribut;
