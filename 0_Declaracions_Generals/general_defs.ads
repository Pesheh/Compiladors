package general_defs is
    pragma pure;

    max_id: constant integer:=997;
    max_str: constant integer:=499;

    type id_nom is new integer range 0..max_id;
    type id_str is new integer range 0..max_str;
   
    null_id: constant id_nom:=0;


-- T_Simbols stuff
	type tidx is (positiu, negatiu);
	type valor is
		record
			signe: tidx;
			v: natural; --temp
		end record; 
	type num_var is new natural; -- sols per compilar
	type num_proc is new natural; -- sols per compilar


    type despl is new natural;

    type tipus_subjacent is (tsb_bool, tsb_car, tsb_ent, tsb_arr, tsb_rec, tsb_nul); -- El orden es relevante petar
    type descr_tipus(tsb: tipus_subjacent:= tsb_nul) is
        record
            ocup: despl;
            case tsb is
                when tsb_bool | tsb_car | tsb_ent	=> 
					linf,lsup: valor;
                when tsb_arr 						=>
					tcomp: id_nom; -- tipus dels components de l'arry
					-- other gc stuff
                when tsb_rec | tsb_nul 				=> 
					null;
            end case;
        end record;

    type tipus_descr is (dnula,dvar,dconst,dindx,dtipus,dcamp,dproc,dargc);
    type descripcio(td: tipus_descr:= dnula) is
        record
            case td is
                when dnula  => 
					null;
                when dvar   => 
					tv: id_nom; -- tipus de la variable
					nv: num_var; -- gc
                when dconst => 
					tc: id_nom; -- tipus de la constant
					vc: valor; -- valor de la constant 
                when dindx  => 
					tind: id_nom;
                when dtipus => 
					dt: descr_tipus;
                when dcamp  => 
					tcmp: id_nom; -- tipus del camp
					dcmp: despl; -- gc
                when dproc  => 
					np: num_proc; -- gc
                when dargc  => 
					ta: id_nom; -- tipus de l'argument
					na: num_var; -- gc
            end case;
        end record;

end general_defs;
