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
