with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with decls.d_atribut; use decls.d_atribut;

package semantica is

  procedure print_arbre;

private
  tn: tnoms;
  ts: tsimbols;
  root: pnode;
end semantica;
