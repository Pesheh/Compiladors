with decls; use decls;
with decls.d_arbre; use decls.d_arbre;

package d_queue is
  type queue is private;
  procedure empty(q: out queue);
  procedure put(q: in out queue; p: in pnode; i: in Integer);
  procedure pop(q: in out queue; p: out pnode; i: out Integer);
  function is_empty(q: in queue) return boolean;

private
  type item;
  type pitem is access item;

  type item is
    record
      p: pnode;
      i: Integer;
      next: pitem;
    end record;

  type queue is
    record
      b: pitem; -- beginning
      e: pitem; -- end
      els: Integer; --num elements
    end record;
end d_queue;
