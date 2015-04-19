with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with decls.d_atribut; use decls.d_atribut;
with decls.d_descripcio; use decls.d_descripcio;

package semantica is

  type ocupacio is private;

  procedure print_arbre;
	function nova_var return Num_var;
  function nou_proc return Num_proc;
  function nova_var(np: num_proc; ocup: ocupacio; desp: despl) return num_var;
  -- variables constants
  function nova_var_const(val: valor; tsb: tipus_subjacent) return num_var;

private
  type ocupacio is new natural;
  
  tn: tnoms;
  ts: tsimbols;
  root: pnode;

  nv: num_var:= 0;
  np: num_proc:= 0;

end semantica;
