with decls; use decls;
package d_stack is
  type stack is limited private;

  procedure empty (st: out stack);
  procedure push (st: in out stack; tr: in trelacio);
  procedure pop (st: in out stack);
  function top (st: in stack) return trelacio;

private
  type stack_range is new integer range -1..50; -- hauria de bastar, no crec que hi hagi mes de 40 op_rel encadenats
  type stack_memory is array (stack_range) of trelacio;

  type stack is
    record
      m: stack_memory;
      i: stack_range:= stack_range'First;
    end record;

end d_stack;
