package body d_stack is

  procedure empty (st: out stack) is
  begin
    st.i:= stack_range'First;
  end empty;

  procedure push (st: in out stack; tr: in trelacio) is
  begin
    if st.i = stack_range'Last then null; end if; -- overflow
    st.i:= st.i+1;
    st.m(st.i):= tr;
  end push;

  procedure pop (st: in out stack) is
  begin
    if st.i = stack_range'First then null; end if; -- underflow
    st.i:= st.i-1;
  end pop;

  function top (st: in stack) return trelacio is
  begin
    if st.i = stack_range'First then null; end if; -- underflow
    return st.m(st.i);
  end top;

end d_stack;
