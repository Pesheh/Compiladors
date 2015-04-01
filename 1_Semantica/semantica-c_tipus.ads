with decls.d_descripcio; 
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

end semantica.c_tipus;
