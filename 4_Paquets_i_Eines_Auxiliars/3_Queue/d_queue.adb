package body d_queue is
  procedure empty(q: out queue) is
  begin
    q.els:=0;
  end empty;


  function is_empty(q: in queue) return boolean is
  begin
    return q.els=0;
  end is_empty;


  procedure put(q: in out queue; p: in pnode; i: in Integer) is
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
  end put;


  procedure pop(q: in out queue; p: out pnode; i: out Integer) is
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
  end pop;


end d_queue;
