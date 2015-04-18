with decls.d_descripcio;
package decls.d_atribut is
  --pragma pure;

--private
  type node;
  type pnode is access node;
	subtype atribut is pnode;
	type tnode is (
    nd_null,
    nd_root,
		nd_proc,
	  nd_decls,
		nd_decl,
		nd_decl_var,
		nd_decl_const,
		nd_decl_t,
		nd_decl_t_cont_type,
		nd_decl_t_cont_record,
		nd_decl_t_cont_arry,
    nd_dcamps,
    nd_dcamp,
    nd_rang,
    nd_c_proc,
    nd_args,
    nd_arg,
    nd_mode,
    nd_lid,
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
    nd_and,
    nd_or,
    nd_e2,
    nd_e3,
    nd_lexpr,
    nd_id,
    nd_lit,
    nd_op_rel
  );


  type tmode is (
    md_in,
    md_in_out
  );
  

  type posicio is
    record
      fila: natural;
      columna: natural;
    end record;


	type operand is (
    nul,
    menor,
    major,
    menorigual,
    majorigual,
    igual,
    diferent,
    sum,
    res,
    prod,
    quoci,
    pot,
    modul,
    neg_log,
    neg_alg
  );

  type node(tn: tnode:= nd_null) is
    record
      case tn is
        when nd_null => 
          null;

        when nd_root =>
          p: pnode;

        when nd_id => 
          id_id: id_nom; 
          id_pos: posicio;    

        when nd_lit =>
          lit_ids: id_str; 
          lit_pos: posicio;
          lit_tipus: decls.d_descripcio.tipus_subjacent;

        when nd_op_rel =>     
          orel_tipus: operand;

        when nd_lid =>
          lid_seg: pnode;
          lid_id: pnode;
          
        when nd_mode =>
          mode_tipus: tmode;
          
        when nd_c_proc =>
          cproc_id: pnode;
          cproc_args: pnode;
          
        when nd_proc =>
          proc_cproc: pnode;
          proc_decls: pnode;
          proc_sents: pnode;

        when nd_args =>
          args_args: pnode;
          args_arg: pnode;
        
        when nd_arg =>
          arg_tipus: pnode;
          arg_lid: pnode;
          arg_mode: tmode;

        when nd_decls =>
          decls_decls: pnode;
          decls_decl: pnode;

        when nd_decl =>
          decl_real: pnode;

        when nd_dcamps =>
          dcamps_dcamps: pnode;
          dcamps_dcamp: pnode;

        when nd_dcamp =>
          dcamp_decl: pnode;	

        when nd_decl_var =>
          dvar_lid: pnode;
          dvar_tipus: pnode;

        when nd_decl_const =>
          dconst_lid: pnode;
          dconst_tipus: pnode;
          dconst_valor: pnode;

        when nd_decl_t =>
          dt_id: pnode;
          dt_cont: pnode;

        when nd_decl_t_cont_type =>
          dtcont_rang: pnode;

        when nd_decl_t_cont_record =>
          dtcont_camps: pnode;

        when nd_decl_t_cont_arry =>
          dtcont_idx: pnode;
          dtcont_tipus: pnode;
        
        when nd_rang =>
	        rang_id: id_nom;
			    rang_linf: pnode;
			    rang_lsup: pnode;

        when nd_idx =>
          idx_tipus: tidx;
          idx_cont: pnode;

        when nd_idx_cont =>
          idxc_valor: pnode;

        when nd_sents	=>
          sents_cont: pnode;

        when nd_sents_nob	=>
          snb_snb: pnode;
          snb_sent: pnode;

        when nd_sent =>	
          sent_sent: pnode;

        when nd_siter =>
          siter_expr: pnode;
          siter_sents: pnode;

        when nd_scond =>
          scond_expr: pnode;
          scond_sents: pnode;
          scond_esents: pnode;

        when nd_scrida =>
          scrida_ref: pnode;

        when nd_sassign =>
          sassign_ref: pnode;
          sassign_expr: pnode;

        when nd_ref =>
          ref_id: pnode;
          ref_qs: pnode;

        when nd_qs =>
          qs_qs: pnode;
          qs_q: pnode;

        when nd_q =>
          q_contingut: pnode;

        when nd_expr =>
          expr_e: pnode;

        when nd_and | nd_or =>
          e_ope: pnode;
          e_opd: pnode;
    
        when nd_e2 =>
          e2_ope: pnode;
          e2_opd: pnode;
          e2_operand: operand;

        when nd_e3 =>
          e3_cont: pnode;

        when nd_lexpr =>
          lexpr_cont: pnode;
          lexpr_expr: pnode;

      end case;
    end record;

end decls.d_atribut;
