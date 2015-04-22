with Ada.Text_IO; --TMP
with semantica.missatges;
package body semantica is

  DEBUG: constant boolean:= true;

  procedure print_arbre is
  begin
    missatges.imprimir_arbre(root);
  end print_arbre;
	
  function nova_var return Num_var is
	begin
    nv:= nv+1;
		if DEBUG then
      Ada.Text_IO.Put_Line("nova_var:nv::"&num_var'Image(nv));
    end if;
		return nv;
	end nova_var;
	
  function nou_proc return Num_proc is
	begin
		np:= np+1;
		return np;
	end nou_proc;
  
  function nova_var(np: num_proc; ocup: ocupacio; desp: despl) return num_var is
  begin
		-- pendent d'ampliar
    nv:= nv+1;
		if DEBUG then
      Ada.Text_IO.Put_Line("nova_var:nv::"&num_var'Image(nv));
    end if;
		return nv;
  end nova_var;

  function nova_var_const(val: valor; tsb: tipus_subjacent) return num_var is
  begin
		-- pendent d'ampliar
    nv:= nv+1;
		if DEBUG then
      Ada.Text_IO.Put_Line("nova_var_const:nvc::"
      &num_var'Image(nv)&"::"
      &valor'Image(val)&"::"
      &tipus_subjacent'Image(tsb));
    end if;
		return nv;
  end nova_var_const;

end semantica;
