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


  -- Temporal, a la generacio de codi canvien.
	nv: num_var:= 0;
	np: num_proc:= 0;

  function nova_var return Num_var;
  function nou_proc return Num_proc;
end semantica;
