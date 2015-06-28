generic
  max_elem: natural;
  type elem is private;
package d_pila is                                                       

  type pila is limited private;

  procedure buida(p: in out pila);
  procedure empila(p: in out pila; e: in elem);
  procedure desempila(p: in out pila);
  function  cim(p: in pila) return elem;
  function  es_buida(p: in pila) return boolean;

  limit_de_capacitat, mal_us: exception;

private

  min_elem: constant natural:= 0;

  subtype rang_pila is Natural range min_elem..max_elem;
  type memoria is array (rang_pila) of elem;

  type pila is
    record
      idx: rang_pila;
      mem: memoria;
    end record;

end d_pila;


package body d_pila is

  procedure buida(p: in out pila) is
  begin
    p.idx:= min_elem;
  end buida;


  procedure empila(p: in out pila; e: in elem) is
  begin
    if p.idx = max_elem then raise limit_de_capacitat; end if;
    p.idx:= p.idx + 1;
    p.mem(p.idx):= e;
  end empila;


  procedure desempila(p: in out pila) is
  begin
    if p.idx = min_elem then raise mal_us; end if;
    p.idx:= p.idx - 1;
  end desempila;


  function cim(p: in pila) return elem is
  begin
    if p.idx = min_elem then raise mal_us; end if;
    return p.mem(p.idx);
  end cim;


  function es_buida(p: in pila) return boolean is
  begin
    return p.idx = min_elem;
  end es_buida;

end d_pila;



with decls; use decls;
with decls.d_arbre; use decls.d_arbre;
package d_cua is

  type cua is private;
  
  procedure buida(q: out cua);
  procedure posa(q: in out cua; p: in pnode; i: in Integer);
  procedure elimina(q: in out cua; p: out pnode; i: out Integer);
  function es_buida(q: in cua) return boolean;

private

  type item;
  type pitem is access item;

  type item is
    record
      p: pnode;
      i: Integer;
      next: pitem;
    end record;

  type cua is
    record
      b: pitem; -- beginning
      e: pitem; -- end
      els: Integer; --num elements
    end record;
    
end d_cua;


package body d_cua is

  procedure buida(q: out cua) is
  begin
    q.els:=0;
  end buida;


  procedure posa(q: in out cua; p: in pnode; i: in Integer) is
    b: pitem renames q.b;
    e: pitem renames q.e;
    els: Integer renames q.els;
    nou: pitem;
  begin
    nou:= new item;
    nou.p:=p;
    nou.i:=i;
    nou.next:=null;
    if els=0 then
      b:=nou;
      e:=b;
    else
      e.next:=nou;
      e:=nou;
    end if;
    els:=els+1;
  end posa;


  procedure elimina(q: in out cua; p: out pnode; i: out Integer) is
    b: pitem renames q.b;
    e: pitem renames q.e;
    els: Integer renames q.els;
  begin
    if els=0 then
      p:= null; i:= -1; --error
    else
      p:=b.p; i:=b.i;
      els:= els-1;
      if els=0 then
        b:=null; e:=null;
      else
        b:=b.next;
      end if;
    end if;
  end elimina;
  
  function es_buida(q: in cua) return boolean is
  begin
    return q.els=0;
  end es_buida;

end d_cua;
