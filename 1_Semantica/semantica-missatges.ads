with decls; use decls;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tsimbols; use decls.d_tsimbols;

package semantica.missatges is

  procedure missatges_desc_no_es_tipus(pos: in posicio; id: in id_nom);
  procedure missatges_conflictes_declaracio(pos: in posicio; id: in id_nom);
  procedure missatges_operacio_amb_escalar(pos: in posicio);
  procedure missatges_tipus_incosistent_lit(pos: in posicio; id_tipus: in id_nom;tsb_found: in tipus_subjacent);
  procedure missatges_tipus_incosistent_id(pos: in posicio; id_expected, id_found: in id_nom);
  procedure missatges_valor_fora_rang(pos: in posicio; id_tipus: in id_nom);
  procedure missatges_rang_incorrecte(pos: in posicio);
  procedure missatges_assignacio_incorrecta(pos: in posicio);
  procedure missatges_operador_tipus(pos: in posicio; tsb_tipus: in tipus_subjacent; op: in operand);
  procedure missatges_log_operador(pos: in posicio; tsb: in tipus_subjacent);
  procedure missatges_sent_buida;
  procedure missatges_expressions_incompatibles(pos: in posicio; id_tipus1, id_tipus2: in id_nom; tsb1, tsb2: in tipus_subjacent);
  procedure missatges_no_record(pos: in posicio; id: in id_nom);
  procedure missatges_camp_no_record(pos: in posicio; id_rec, id_camp: in id_nom);
  procedure missatges_no_array(pos: in posicio; id: in id_nom);
  procedure missatges_menys_indexos_array(pos: in posicio; id_array: in id_nom);
  procedure missatges_massa_indexos_array(pos: in posicio; id_array: in id_nom);
  procedure missatges_menys_arguments_proc(pos: in posicio; id_proc: in id_nom);
  procedure missatges_massa_arguments_proc(pos: in posicio; id_proc: in id_nom);
  procedure missatges_arg_mode(pos: in posicio; id: in id_nom);
  procedure missatges_proc_mult_parentesis(pos: in posicio);
  procedure missatges_cond_bool(pos: in posicio; tsb: in tipus_subjacent);
  procedure missatges_no_definida(pos: in posicio; id: in id_nom);
  procedure missatges_no_proc(pos: in posicio);






  --Missatges de debugging
  procedure missatges_ct_error_intern(pos: in posicio; proc: in String);
  procedure missatges_ct_debugging(proc,msg: in String);
  procedure missatges_gc_debugging(proc,msg: in String);
  procedure missatges_imprimir_desc(proc: in String; d: in descripcio; id: in id_nom; p: in String);
  procedure missatges_imprimir_id(proc: in String; id: in id_nom; nom: in String );


  procedure imprimir_arbre(root: in pnode);
end semantica.missatges;
