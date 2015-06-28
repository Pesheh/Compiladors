with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed; use Ada.Strings.Fixed; --El trim

with semantica; use semantica;
with decls.d_c3a; use decls.d_c3a;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tnoms;

package body semantica.g_codi_ass is
  use Instruccio_IO;
  use Pila_Procediments;
  pproc: Pila_Procediments.pila;

  Output: Ada.Text_IO.File_Type;
  Input: Instruccio_IO.File_Type;
  newline: String(1..1):=(1=>ASCII.LF); --new line

  nf: Unbounded_String;


  --Definicions
  function ga_llegir return instr_3a;
  procedure ga_escriure(text: in String);

  procedure generacio_assemblador;
  procedure init_memoria;


  function ga_load(nv: in num_var; r: in registre) return String;
  function ga_load_constant(nv: in num_var; r: in registre) return String;
  function ga_load_var_local(nv: in num_var; r: in registre) return String;
  function ga_load_param_local(nv: in num_var; r: in registre) return String;
  function ga_load_var_global(nv: in num_var; r: in registre) return String;
  function ga_load_param_global(nv: in num_var; r: in registre) return String;


  function ga_store(nv: in num_var; r: in registre) return String;
  function ga_store_var_local(nv: in num_var; r: in registre) return String;
  function ga_store_param_local(nv: in num_var; r: in registre) return String;
  function ga_store_var_global(nv: in num_var; r: in registre) return String;
  function ga_store_param_global(nv: in num_var; r: in registre) return String;


  function ga_load_address(nv: in num_var; r: in registre) return String;
  function ga_load_address_constant(nv: in num_var; r: in registre) return String;
  function ga_load_address_var_local(nv: in num_var; r: in registre) return String;
  function ga_load_address_param_local(nv: in num_var; r: in registre) return String;
  function ga_load_address_var_global(nv: in num_var; r: in registre) return String;
  function ga_load_address_param_global(nv: in num_var; r: in registre) return String;


  procedure ga_cp(i3a: in instr_3a);
  procedure ga_cons_idx(i3a: in instr_3a);
  procedure ga_cp_idx(i3a: in instr_3a);


  procedure ga_sum(i3a: in instr_3a);
  procedure ga_res(i3a: in instr_3a);
  procedure ga_mul(i3a: in instr_3a);
  procedure ga_div(i3a: in instr_3a);
  procedure ga_modul(i3a: in instr_3a);
  procedure ga_neg(i3a: in instr_3a);
  procedure ga_op_not(i3a: in instr_3a);
  procedure ga_op_and(i3a: in instr_3a);
  procedure ga_op_or(i3a: in instr_3a);


  function ga_etiq(e: in num_etiq) return String;
  function ga_goto(e: in num_etiq) return String;
  procedure ga_goto(i3a: in instr_3a);
  procedure ga_etiq(i3a: in instr_3a);
  procedure ga_ieq_goto(i3a: in instr_3a);

  procedure ga_gt(i3a: in instr_3a);
  procedure ga_ge(i3a: in instr_3a);
  procedure ga_eq(i3a: in instr_3a);
  procedure ga_neq(i3a: in instr_3a);
  procedure ga_le(i3a: in instr_3a);
  procedure ga_lt(i3a: in instr_3a);


  procedure ga_pmb(i3a: in instr_3a);
  procedure ga_rtn(i3a: in instr_3a);
  procedure ga_call(i3a: in instr_3a);
  procedure ga_paramc(i3a: in instr_3a);
  procedure ga_params(i3a: in instr_3a);


  function Value(e: in num_etiq) return String is
  begin 
    return Trim(num_etiq'Image(e), Ada.Strings.Left);
  end Value;

  function Value(d: in despl) return String is
  begin
    return Trim(despl'Image(d), Ada.Strings.Left);
  end Value;
  
  function Value(i: in Integer) return String is
  begin
    return Trim(Integer'Image(i), Ada.Strings.Left);
  end Value;

  function Value(v: in valor) return String is
  begin
    return Trim(valor'Image(v), Ada.Strings.Left);
  end Value;


  procedure gen_codi_ass is
  begin
    Open(File=>Input, Mode=>In_File, Name=> To_String(nf) & ".c3a");
    Create(File=>Output, Mode=>Out_File, Name=> To_String(nf) & ".s");
    buida(pproc);
    calcul_desplacaments(tv, nv, tp, np);
    generacio_assemblador;
    Close(Input);
    Close(Output);
  end gen_codi_ass;


  procedure prepara_g_codi_ass(nomf: in String) is
  begin
    nf:= To_Unbounded_String(nomf);
  end prepara_g_codi_ass;


  function ga_llegir return instr_3a is
    inst: instr_3a_bin;
  begin
    Instruccio_IO.Read(Input, Item=> inst);
    return To_i3a(inst);
  end ga_llegir;

  procedure ga_escriure(text: in String) is
  begin
    Put(File=> Output, Item=> text);
  end ga_escriure;


  procedure generacio_assemblador is
    inst: instr_3a;
  begin
    init_memoria;
    while not End_Of_File(Input) loop
      inst:=ga_llegir;
      case consulta_tipus(inst) is
        when cp       =>
          ga_cp(inst);
          ga_escriure(newline);
        when cp_idx   =>
          ga_cp_idx(inst);
          ga_escriure(newline);
        when cons_idx =>
          ga_cons_idx(inst);
          ga_escriure(newline);
        when sum      =>
          ga_sum(inst);
          ga_escriure(newline);
        when res      =>
          ga_res(inst);
          ga_escriure(newline);
        when mul      =>
          ga_mul(inst);
          ga_escriure(newline);
        when div      =>
          ga_div(inst);
          ga_escriure(newline);
        when modul    =>
          ga_modul(inst);
          ga_escriure(newline);
        when neg      =>
          ga_neg(inst);
          ga_escriure(newline);
        when op_not   =>
          ga_op_not(inst);
          ga_escriure(newline);
        when op_and   =>
          ga_op_and(inst);
          ga_escriure(newline);
        when op_or    =>
          ga_op_or(inst);
          ga_escriure(newline);
        when etiq     =>
          ga_etiq(inst);
          ga_escriure(newline);
        when go_to    =>
          ga_goto(inst);
          ga_escriure(newline);
        when ieq_goto =>
          ga_ieq_goto(inst);
          ga_escriure(newline);
        when gt       =>
          ga_gt(inst);
          ga_escriure(newline);
        when ge       =>
          ga_ge(inst);
          ga_escriure(newline);
        when eq       =>
          ga_eq(inst);
          ga_escriure(newline);
        when neq      =>
          ga_neq(inst);
          ga_escriure(newline);
        when le       =>
          ga_le(inst);
          ga_escriure(newline);
        when lt       =>
          ga_lt(inst);
          ga_escriure(newline);
        when pmb      =>
          ga_pmb(inst);
          ga_escriure(newline);
        when rtn      =>
          ga_rtn(inst);
          ga_escriure(newline);
        when call     =>
          ga_call(inst);
          ga_escriure(newline);
        when params   =>
          ga_params(inst);
          ga_escriure(newline);
        when paramc   =>
          ga_paramc(inst);
          ga_escriure(newline);
      end case;
    end loop;
  end generacio_assemblador;


  --Inicializar memoria
  procedure init_memoria is
  begin
    ga_escriure(".section  .bss" & newline);
    ga_escriure("  .comm DISP, 100" & newline);
    ga_escriure(".section .text" & newline);
    ga_escriure("  .global main" & newline);
  end init_memoria;

  --LOAD
  function ga_load(nv: in num_var; r: in registre) return String is
  begin
    if not es_var(tv, nv) then
      return ga_load_constant(nv, r);

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, cim(pproc))  then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_var_local(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, cim(pproc)) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_load;


  function ga_load_constant(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    valor_const: constant String:= Value(consulta_val_const(tv, nv));
  begin
    return "  movl  $" & valor_const &", %" & reg & newline;
  end ga_load_constant;

  function ga_load_var_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_var_local;

  function ga_load_param_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl " & desplacament & "(%ebp), %esi" & newline
          & "  movl (%esi), %" & reg & newline;
  end ga_load_param_local;

  function ga_load_var_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %" & reg & newline;
  end ga_load_var_global;

  function ga_load_param_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %esi" & newline
          & "  movl (%esi), %" & reg & newline;
  end ga_load_param_global;


  --STORE
  function ga_store(nv: in num_var; r: in registre) return String is
  begin
    if consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, cim(pproc)) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_store_var_local(nv, r );

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_store_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, cim(pproc)) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_store_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_store_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_store;


  function ga_store_var_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return "  movl %" & reg & ", " & desplacament & "(%ebp)" & newline;
  end ga_store_var_local;


  function ga_store_param_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %edi" & newline
         & "  movl %" & reg & ", (%edi)" & newline;
  end ga_store_param_local;


  function ga_store_var_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %edi" & newline
          & "  movl %" & reg & " ," & desplacament & "(%edi)" & newline;
  end ga_store_var_global;


  function ga_store_param_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:= Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %edi" & newline
          & "  movl %" & reg & ", (%edi)" & newline;
  end ga_store_param_global;


  --LOAD ADDRESS
  function ga_load_address(nv: in num_var; r: in registre) return String is
  begin
    if not es_var(tv, nv) then
      return ga_load_address_constant(nv, r);

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, cim(pproc))  then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_address_var_local(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_address_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, cim(pproc)) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_address_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_address_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_load_address;

  function ga_load_address_constant(nv: in num_var; r: in registre) return String is
    ecx: num_etiq;
  begin
    nova_etiq(ne, ecx);
    case consulta_tsb_const(tv, nv) is
      when tsb_ent | tsb_bool=>
        return    ".section .data" & newline
               &  "  ec"   & Value(ecx) & ": .long   "& Value(consulta_val_const(tv, nv)) & newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" & registre'Image(r) & newline;

      when tsb_car =>
        return    ".section .data" & newline
               &  "  ec" & Value(ecx) & ": .ascii  """
               &  Character'Val(Integer(consulta_val_const(tv, nv))) & """" & newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" & registre'Image(r) & newline;

      when tsb_nul=>
        return    ".section .data" & newline
               &  "  ec" & Value(ecx) & ": .asciz  "
               &  decls.d_tnoms.get(tn, id_str(consulta_val_const(tv, nv)))  &  newline
               &  ".section .text" & newline
               &  "  movl  $ec" & Value(ecx) & ", %" & registre'Image(r) & newline;

      when others  => null;
    end case;
    return "";
  end ga_load_address_constant;


  function ga_load_address_var_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return "  leal " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_address_var_local;


  function ga_load_address_param_local(nv: in num_var; r: in registre) return String is
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return "  movl " & desplacament & "(%ebp), %" & reg & newline;
  end ga_load_address_param_local;


  function ga_load_address_var_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:=Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  leal " & desplacament & "(%esi), %" & reg &  newline;
  end ga_load_address_var_global;

  function ga_load_address_param_global(nv: in num_var; r: in registre) return String is
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, consulta_np_var(tv, nv)));
    desp_display: constant String:= Value(desp_disp);
    reg: constant String:= registre'Image(r);
    desplacament: constant String:= Value(consulta_desp_var(tv, nv));
  begin
    return  "  movl $DISP, %esi" & newline
          & "  movl " & desp_display & "(%esi), %esi" & newline
          & "  movl " & desplacament & "(%esi), %" & reg &  newline;
  end ga_load_address_param_global;



  --Instruccions de copia
  procedure ga_cp(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
  begin
    ga_escriure(ga_load(b, eax)
    & ga_store(a, eax));
  end ga_cp;

  procedure ga_cons_idx(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(c, eax)
              & ga_load_address(b, esi)
              & "  subl %eax, %esi" & newline
              & "  movl (%esi), %eax" & newline
              & ga_store(a, eax));
  end ga_cons_idx;

  procedure ga_cp_idx(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & ga_load_address(a, edi)
              & "  subl %eax, %edi" & newline
              & "  movl %ebx, (%edi)" & newline);
  end ga_cp_idx;

  --Instruccions artimetic-logiques
  procedure ga_sum(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
               & ga_load(c, ebx)
               & "  addl %ebx, %eax" & newline
               & ga_store(a, eax));
  end ga_sum;

  procedure ga_res(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  subl %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_res;

  procedure ga_mul(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  imull %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_mul;

  procedure ga_div(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  movl %eax, %edx" & newline
              & "  sarl $31, %edx" & newline
              & ga_load(c, ebx)
              & "  idivl  %ebx" & newline
              & ga_store(a, eax));
  end ga_div;

  procedure ga_modul(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  movl %eax, %edx" & newline
              & "  sarl $31, %edx" & newline
              & ga_load(c, ebx)
              & "  idivl  %ebx" & newline
              & ga_store(a, edx));
  end ga_modul;

  procedure ga_neg(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  negl %eax" & newline
              & ga_store(a, eax));
  end ga_neg;

  procedure ga_op_not(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & "  notl %eax" & newline
              & ga_store(a, eax));
  end ga_op_not;

  procedure ga_op_and(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  andl %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_op_and;

  procedure ga_op_or(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
  begin
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  orl  %ebx, %eax" & newline
              & ga_store(a, eax));
  end ga_op_or;

  --Instruccions de Brancament
  function ga_etiq(e: in num_etiq) return String is
    etiqueta: constant String:= Value(e);
  begin
    if e=null_ne+1 then
      return "main: NOP" & newline;
    else
      return "E" & etiqueta  & ": NOP" & newline;
    end if;
  end ga_etiq;

  function ga_goto(e: in num_etiq) return String is
    etiqueta: constant String:=Value(e);
  begin
    return "  jmp  E" & etiqueta & newline;
  end ga_goto;


  procedure ga_etiq(i3a: in instr_3a) is
    e: constant num_etiq:= consulta_arg_ne(i3a);
  begin
    ga_escriure(ga_etiq(e));
  end ga_etiq;


  procedure ga_goto(i3a: in instr_3a) is
    e: constant num_etiq:= consulta_arg_ne(i3a);
  begin
    ga_escriure(ga_goto(e));
  end ga_goto;


  procedure ga_ieq_goto(i3a: in instr_3a) is
    e: constant num_etiq:= consulta_arg_ne(i3a);
    a: constant num_var:= consulta_arg2(i3a);
    b: constant num_var:= consulta_arg3(i3a);
    e1: num_etiq;
  begin
    nova_etiq(ne, e1);
    ga_escriure(ga_load(a, eax)
              & ga_load(b, ebx)
              & "  cmpl %ebx, %eax" & newline
              & "  jne  E" & Value(e1) & newline
              & ga_goto(e)
              & ga_etiq(e1));
  end ga_ieq_goto;


  procedure ga_gt(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jge  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_gt;


  procedure ga_ge(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jg  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_ge;


  procedure ga_eq(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jne  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_eq;


  procedure ga_neq(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  je  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_neq;


  procedure ga_lt(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jle  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_lt;


  procedure ga_le(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
    b: constant num_var:= consulta_arg2(i3a);
    c: constant num_var:= consulta_arg3(i3a);
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    ga_escriure(ga_load(b, eax)
              & ga_load(c, ebx)
              & "  cmpl %eax, %ebx" & newline
              & "  jl  E" & Value(e) & newline
              & "  movl $-1, %ecx" & newline
              & ga_goto(e1)
              & ga_etiq(e)
              & "  movl $0, %ecx" & newline
              & ga_etiq(e1)
              & ga_store(a, ecx));
  end ga_le;

  --Crida a procediments
  procedure ga_pmb(i3a: in instr_3a) is
    np: constant num_proc:= consulta_arg_np(i3a);
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, np));
    desp_display: constant String:= Value(desp_disp);
    ocupacio_proc: constant String:= Value(consulta_ocup_proc(tp, np));
  begin
    empila(pproc, np);
    ga_escriure("  movl $DISP, %esi" & newline
              & "  movl " & desp_display & "(%esi), %eax" & newline
              & "  pushl %eax" & newline
              & "  pushl %ebp" & newline
              & "  movl %esp, %ebp" & newline
              & "  movl %ebp, " & desp_display & "(%esi)" & newline
              & "  subl  $" & ocupacio_proc & ", %esp" & newline);
  end ga_pmb;

  procedure ga_rtn(i3a: in instr_3a) is
    np: constant num_proc:= consulta_arg_np(i3a);
    desp_disp: constant Integer:= 4*Value(consulta_prof_proc(tp, np));
    desp_display: constant String:= Value(desp_disp);
  begin
    ga_escriure("  movl %ebp, %esp" & newline
              & "  popl %ebp" & newline
              & "  movl $DISP, %edi" & newline
              & "  popl %eax" & newline
              & "  movl %eax, " & desp_display & "(%edi)" & newline
              & "  ret" & newline);
    desempila(pproc);
  end ga_rtn;

  procedure ga_params(i3a: in instr_3a) is
    a: constant num_var:= consulta_arg_nv(i3a);
  begin
    ga_escriure(ga_load_address(a, eax)
              & "  pushl %eax" & newline);
  end ga_params;

  procedure ga_paramc(i3a: in instr_3a) is
    a: constant num_var:=consulta_arg_nv(i3a);
    b: constant num_var:=consulta_arg2(i3a);
  begin
    ga_escriure(ga_load_address(a, eax)
              & ga_load(b, ebx)
              & "  subl %ebx, %eax" & newline
              & "  pushl %eax" & newline);
  end ga_paramc;

  procedure ga_call(i3a: in instr_3a) is
    np: constant num_proc:= consulta_arg_np(i3a);
    nparam: constant Integer:= 4*consulta_nparam_proc(tp, np);
    tamany_nparam: constant String:= Value(nparam);
  begin
    if consulta_tproc(tp, np)=comu then
      ga_escriure("  call E" & Value(consulta_etiq_proc(tp, np)) & newline
                & "  addl $" & tamany_nparam & ", %esp" & newline);
    else
      ga_escriure("  call _" & consulta_nom_proc(tp, np, tn) & newline
                & "  addl $" & tamany_nparam & ", %esp" & newline);
    end if;
  end ga_call;
  

end semantica.g_codi_ass;
