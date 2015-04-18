with decls.d_descripcio; use decls.d_descripcio; 

package semantica.c_tipus is
  procedure posa_entorn_standard;
  --Declaracions
  procedure ct_decls(nd_decls: in pnode);
  procedure ct_decl_tipus(decl_tipus: in pnode);

  procedure ct_decl_var(decl_var: in pnode);
  procedure ct_lid_var(lid_var: in pnode; idt: in id_nom);
  
  procedure ct_decl_const(decl_const: in pnode);
  procedure ct_lid_const(lid_const: in pnode; desc: in decls.d_descripcio.descripcio);
  procedure ct_valor(nd_idx: in pnode; id_tipus: out id_nom; tsb: out decls.d_descripcio.tipus_subjacent; v: out valor);
  
  procedure ct_rang(decl_rang: in pnode);
  
  procedure ct_record(nd_record: in pnode);
  procedure ct_dcamps(nd_dcamps: in pnode;idr: in id_nom;desp: in out despl);
  procedure ct_dcamp(nd_dcamp: in pnode;idr: in id_nom;desp: in out despl);
  procedure ct_dcamp_lid(nd_lid: in pnode; idt,idr: in id_nom; desp: in out despl;ocup: in despl);
  
  procedure ct_array(nd_array: in pnode);
  procedure ct_array_idx(nd_lidx: in pnode;id_array: in id_nom; num_comp: in out valor);

  procedure ct_decl_proc(nd_procediment: in pnode);
  procedure ct_decl_args(nd_args: in pnode;id_proc: in id_nom);
  procedure ct_decl_arg(nd_lid_arg: in pnode;id_proc,id_tipus: in id_nom;mode: in tmode);

  --Sentencias
  procedure ct_sents(nd_sents: in pnode);
  procedure ct_sents_nob(nd_sents_nob: in pnode);
  procedure ct_sent_iter(nd_sent: in pnode);
  procedure ct_sent_cond(nd_sent: in pnode);
  procedure ct_sent_crida(nd_sent: in pnode);
  procedure ct_sent_assign(nd_sent: in pnode);
  
  --Referencias
  procedure ct_ref(nd_ref: in pnode; id_base: out id_nom; id_tipus: out id_nom);
  procedure ct_qs(nd_qs: in pnode; id_base: in id_nom; id_tipus: in out id_nom);
  procedure ct_q(nd_q: in pnode; id_base: in id_nom; id_tipus: in out id_nom);
  procedure ct_qs_proc(nd_qs: in pnode; id_base: in id_nom);

  procedure ct_lexpr_proc(nd_lexpr: in pnode; id_base: in id_nom;it: in out iterador_arg);
  procedure ct_lexpr_array(nd_lexpr: in pnode; id_base: in id_nom; id_tipus: in out id_nom; it: in out iterador_index);
  procedure ct_expr(nd_expr: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);

  --Expressions
  procedure ct_e(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  
  procedure ct_e2(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e2_op_rel(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e2_arit(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e2_neg_log(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e2_neg_arit(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);

  procedure ct_e3(nd_e: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e3_lit(nd_lit: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  procedure ct_e3_ref(nd_ref: in pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean);
  
  --Auxiliar 
  function tipus_compatible(id_tipus1, id_tipus2: in id_nom; tsb1, tsb2: in tipus_subjacent; id_texp: out id_nom; tsb_exp: out tipus_subjacent) return boolean;

end semantica.c_tipus;
