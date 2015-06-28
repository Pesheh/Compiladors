with decls.d_descripcio;
package decls.d_arbre is

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
    nd_iproc,
    nd_var,
    nd_qs,
    nd_q,
    nd_arry,
    nd_rec,
    nd_lexpr_arry,
    nd_expr,
    nd_and,
    nd_or,
    nd_eop,
    nd_et,
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
          lit_val: valor;
          lit_pos: posicio;
          lit_tipus: decls.d_descripcio.tipus_subjacent;

        when nd_op_rel =>
          orel_tipus: operand;

        when nd_var =>
          var_nv: num_var;
          var_ocup: despl;

        when nd_lid =>
          lid_seg: pnode;
          lid_id: pnode;

        when nd_mode =>
          mode_tipus: tmode;

        when nd_c_proc =>
          cproc_id: pnode;
          cproc_np: num_proc;
          cproc_args: pnode;

        when nd_proc =>
          proc_cproc: pnode;
          proc_decls: pnode;
          proc_sents: pnode;

        when nd_iproc =>
          iproc_np: num_proc;

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
          rang_pos: posicio;
          rang_linf: pnode;
          rang_lsup: pnode;

        when nd_idx =>
          idx_tipus: tidx;
          idx_cont: pnode;

        when nd_idx_cont =>
          idxc_valor: pnode;

        when nd_sents  =>
          sents_cont: pnode;

        when nd_sents_nob  =>
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

        when nd_arry =>
          arry_lexpr: pnode;
          -- constants de despl calc per el compilador
          arry_tb: num_var;
          arry_tw: num_var;

        when nd_lexpr_arry =>
          lexpra_cont: pnode;
          lexpra_expr: pnode;
          -- constant del compilador (lsup-linf+1)
          lexpra_tu: num_var;

        when nd_rec =>
          -- despl constant del camp.
          rec_td: num_var;

        when nd_expr =>
          expr_e: pnode;

        when nd_and | nd_or =>
          e_ope: pnode;
          e_opd: pnode;

        when nd_eop =>
          eop_ope: pnode;
          eop_opd: pnode;
          eop_operand: operand;

        when nd_et =>
          et_cont: pnode;

        when nd_lexpr =>
          lexpr_cont: pnode;
          lexpr_expr: pnode;

      end case;
    end record;

end decls.d_arbre;
