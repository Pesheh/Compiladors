with semantica.missatges;
package body semantica is

  procedure print_arbre is
  begin
    missatges.imprimir_arbre(root);
  end print_arbre;
	
  function nova_var return Num_var is
	begin
		nv:= nv+1;
		return nv;
	end nova_var;
	
  function nou_proc return Num_proc is
	begin
		np:= np+1;
		return np;
	end nou_proc;

end semantica;
