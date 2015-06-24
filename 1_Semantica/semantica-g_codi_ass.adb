with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


with semantica; use semantica;
with decls.d_c3a; use decls.d_c3a;

package body semantica.g_codi_ass is 
  Output: File_Type; 
  Input: File_Type;
  newline: String(1..1):=(1=>ASCII.LF); --new line

  np_encurs: num_proc:=0;
  nf: Unbounded_String;


  --Definicions
  function ga_llegir return instr_3a;
  procedure ga_escribir(text: in String);
  procedure generacio_assemblador;
  procedure init_memoria;
  function init_constants return String;
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
  function ga_cp(a, b: in num_var) return String;
  function ga_cons_idx(a, b, c: in num_var) return String;
  function ga_cp_idx(a, b, c: in num_var) return String;
  function ga_sum(a, b, c: in num_var) return String;
  function ga_res(a, b, c: in num_var) return String;
  function ga_mul(a, b, c: in num_var) return String;
  function ga_div(a, b, c: in num_var) return String;
  function ga_modul(a, b, c: in num_var) return String;
  function ga_neg(a, b: in num_var) return String; 
  function ga_op_not(a, b: in num_var) return String; 
  function ga_op_and(a, b, c: in num_var) return String;
  function ga_op_or(a, b, c: in num_var) return String;
  function ga_etiq(e: in num_etiq) return String;
  function ga_goto(e: in num_etiq) return String;
  function ga_ieq_goto(a, b: in num_var; e: in num_etiq) return String;
  function ga_gt(a, b, c: in num_var) return String;
  function ga_ge(a, b, c: in num_var) return String;
  function ga_eq(a, b, c: in num_var) return String;
  function ga_neq(a, b, c: in num_var) return String;
  function ga_le(a, b, c: in num_var) return String;
  function ga_lt(a, b, c: in num_var) return String;







  procedure gen_codi_ass is
  begin
    Open(File=>Input, Mode=>In_File, Name=> To_String(nf) & ".c3as");
    Create(File=>Output, Mode=>Out_File, Name=> To_String(nf) & ".s");
    generacio_assemblador;
    Close(Input);
    Close(Output);
  end gen_codi_ass;
  
  procedure prepara_g_codi_ass(nomf: in String) is
  begin
    nf:= To_Unbounded_String(nomf);
  end prepara_g_codi_ass;


  
  function ga_llegir return instr_3a is
  begin
    return instr_3a'Input(Stream(Input));
  end ga_llegir;


  procedure ga_escribir(text: in String) is
  begin
    Put(File=> Output, Item=> text);
  end ga_escribir;


  procedure generacio_assemblador is
    inst: instr_3a;
  begin
    while not End_Of_File(Input) loop
      inst:=ga_llegir;
      case inst.t is
        when cp       =>
          ga_escribir(ga_cp(inst.a, inst.b));
        when cp_idx   =>
          ga_escribir(ga_cp_idx(inst.a, inst.b, inst.c));
        when cons_idx =>
          ga_escribir(ga_cons_idx(inst.a, inst.b, inst.c));
        when sum      =>
          ga_escribir(ga_sum(inst.a, inst.b, inst.c));
        when res      =>
          ga_escribir(ga_res(inst.a, inst.b, inst.c));
        when mul      =>
          ga_escribir(ga_mul(inst.a, inst.b, inst.c));
        when div      =>
          ga_escribir(ga_div(inst.a, inst.b, inst.c));
        when modul    =>
          ga_escribir(ga_modul(inst.a, inst.b, inst.c));
        when neg      =>
          ga_escribir(ga_neg(inst.a, inst.b));
        when op_not   =>
          ga_escribir(ga_not(inst.a, inst.b));
        when op_and   =>
          ga_escribir(ga_op_and(inst.a, inst.b, inst.c));
        when op_or    =>
          ga_escribir(ga_op_or(inst.a, inst.b, inst.c));
        when num_etiq     =>
          ga_escribir(ga_op_or(inst.a));
        when go_to    =>
          ga_escribir(ga_goto(inst.a));
        when ieq_goto =>
          ga_escribir(ga_ieq_goto(inst.a, inst.b, inst.c));
        when gt       =>
          ga_escribir(ga_gt(inst.a, inst.b, inst.c));
        when ge       =>
          ga_escribir(ga_ge(inst.a, inst.b, inst.c));
        when eq       =>
          ga_escribir(ga_eq(inst.a, inst.b, inst.c));
        when neq      =>
          ga_escribir(ga_neq(inst.a, inst.b, inst.c));
        when le       =>
          ga_escribir(ga_le(inst.a, inst.b, inst.c));
        when lt       =>
          ga_escribir(ga_lt(inst.a, inst.b, inst.c));
        when pmb      =>
          null;
        when rtn      =>
          null;
        when call     =>
          null;
        when params   =>
          null;
        when paramc   =>
          null;
      end case;
    end loop;
  end generacio_assemblador;


  --Inicializar memoria
  procedure init_memoria is
  begin
    ga_escribir(".section .data" & newline);
    ga_escribir(init_constants);
    ga_escribir(".secion  .bss" & newline);
    ga_escribir(" .comm DISP, 1000" & newline);
    --...
  end init_memoria;

  function init_constants return String is
  begin
    return "";
  end init_constants;

  --LOAD
  function ga_load(nv: in num_var; r: in registre) return String is
  begin
    if not es_var(tv, nv) then
      return ga_load_constant(nv, r);  

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, np_encurs)  then
      if consulta_desp_var(tv, nv)<0 then
       return ga_load_var_local(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, np_encurs) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_param_global(nv, r);
      end if;
    end if;
    return "";
  end ga_load;


  function ga_load_constant(nv: in num_var; r: in registre) return String is
  begin
    return "movl  $" & valor'Image(consulta_val_const(tv, nv)) &", %" & registre'Image(r) & newline; 
  end ga_load_constant;

  function ga_load_var_local(nv: in num_var; r: in registre) return String is
  begin
    return "movl " & despl'Image(consulta_desp_var(tv, nv)) & "(%ebp), %" & registre'Image(r) & newline;
  end ga_load_var_local;
  
  function ga_load_param_local(nv: in num_var; r: in registre) return String is
  begin
    return  "movl " & despl'Image(consulta_desp_var(tv, nv)) & "(%ebp), %esi" & newline
           & "movl (%esi), %" & registre'Image(r) & newline;
  end ga_load_param_local;

  --
  function ga_load_var_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_load_var_global;

  function ga_load_param_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_load_param_global;


  --STORE
  function ga_store(nv: in num_var; r: in registre) return String is
  begin
    if consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, np_encurs) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_store_var_local(nv, r );

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_store_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, np_encurs) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_store_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_store_param_global(nv, r);
      end if;
    end if;  
    return "";
  end ga_store;

  
  function ga_store_var_local(nv: in num_var; r: in registre) return String is
  begin
    return "movl %" & registre'Image(r) & ", " & despl'Image(consulta_desp_var(tv, nv))
              & "(%ebp)" & newline;
  end ga_store_var_local;


  function ga_store_param_local(nv: in num_var; r: in registre) return String is
  begin
    return "movl " & despl'Image(consulta_desp_var(tv, nv)) & "(%ebp), %edi" & newline
           & "movl %" & registre'Image(r) & ", (%edi)" & newline;
  end ga_store_param_local;


  function ga_store_var_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_store_var_global;


  function ga_store_param_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_store_param_global;


  --LOAD ADDRESS 
  function ga_load_address(nv: in num_var; r: in registre) return String is
  begin
    if not es_var(tv, nv) then
      return ga_load_address_constant(nv, r);  

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) = consulta_prof_proc(tp, np_encurs)  then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_address_var_local(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_address_param_local(nv, r);
      end if;

    elsif consulta_prof_proc(tp, consulta_np_var(tv, nv)) < consulta_prof_proc(tp, np_encurs) then
      if consulta_desp_var(tv, nv)<0 then
        return ga_load_address_var_global(nv, r);

      elsif consulta_desp_var(tv, nv)>0 then
        return ga_load_address_param_global(nv, r);
      end if;
    end if;  
  return "";
  end ga_load_address;


  function ga_load_address_constant(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_load_address_constant;


  function ga_load_address_var_local(nv: in num_var; r: in registre) return String is
  begin
    return "leal " & despl'Image(consulta_desp_var(tv, nv)) & ", %" & registre'Image(r) & newline;
  end ga_load_address_var_local;
  

  function ga_load_address_param_local(nv: in num_var; r: in registre) return String is
  begin
    return "movl " & despl'Image(consulta_desp_var(tv, nv)) & ", %" & registre'Image(r) & newline;
  end ga_load_address_param_local;

  
  function ga_load_address_var_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_load_address_var_global;
  
  function ga_load_address_param_global(nv: in num_var; r: in registre) return String is
  begin
    return "";
  end ga_load_address_param_global;



  --Instruccions de copia
  function ga_cp(a, b: in num_var) return String is
  begin
    return ga_load(b, eax) 
         & ga_store(a, eax);
  end ga_cp;

  function ga_cons_idx(a, b, c: in num_var) return String is
  begin
    return  ga_load(c, eax) 
          & ga_load_address(b, esi)
          & "addl %eax, %esi" & newline
          & "movl (%esi), %eax" & newline
          & ga_store(a, eax);
  end ga_cons_idx;

  function ga_cp_idx(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax) 
          & ga_load(c, ebx)
          & ga_load_address(a, edi)
          & "addb %eax, %edi" & newline
          & "movl %ebx, (%edi)" & newline;
  end ga_cp_idx;

  --Instruccions artimetic-logiques
  function ga_sum(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "addl %ebx, %eax" & newline
          & ga_store(a, eax);
  end ga_sum;

  function ga_res(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "subl %ebx, %eax" & newline
          & ga_store(a, eax);
  end ga_res;

  function ga_mul(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax) 
          & ga_load(c, ebx)
          & "imul $ebx, %eax" & newline
          & ga_store(a, eax);
  end ga_mul;

  function ga_div(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & "movl %eax, %edx"
          & "asrl $31, %edx" & newline --Creo que no es asrl->sarl
          & "idivl  %ebx" & newline
          & ga_store(a, eax);
  end ga_div;

  function ga_modul(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & "movl %eax, %edx"
          & "asrl $31, %edx" & newline --Creo que no es asrl->sarl
          & "idivl  %ebx" & newline
          & ga_store(a, edx);
  end ga_modul;

  function ga_neg(a, b: in num_var) return String is 
  begin
    return  ga_load(b, eax)
          & "negl %eax" & newline
          & ga_store(a, eax);
  end ga_neg;

  function ga_op_not(a, b: in num_var) return String is 
  begin
    return  ga_load(b, eax)
          & "notl %eax" & newline
          & ga_store(a, eax);
  end ga_op_not;

  function ga_op_and(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "andl %ebx, %eax" & newline
          & ga_store(a, eax);
  end ga_op_and;

  function ga_op_or(a, b, c: in num_var) return String is
  begin
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "orl  %ebx, %eax" & newline
          & ga_store(a, eax);
  end ga_op_or;

  --Instruccions de Brancament

  function ga_etiq(e: in num_etiq) return String is
  begin
    return  "E" & num_etiq'Image(e)&": NOP" & newline;
  end ga_etiq;

  function ga_goto(e: in num_etiq) return String is
  begin
    return  "jmp  E" & num_etiq'Image(e) & newline;
  end ga_goto;
  
  function ga_ieq_goto(a, b: in num_var; e: in num_etiq) return String is
    e1: num_etiq;
  begin
    nova_etiq(ne, e1);
    return  ga_load(a, eax)
          & ga_load(b, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jme  E" & num_etiq'Image(e1) & newline
          & ga_goto(e)
          & ga_etiq(e1);
  end ga_ieq_goto;

  
  function ga_gt(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jg  E" & num_etiq'Image(e) & newline
          & "movl $-1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_gt;
  
  
  function ga_ge(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jge  E" & num_etiq'Image(e) & newline
          & "movl $-1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_ge;
  
  
  function ga_eq(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jme  E" & num_etiq'Image(e) & newline
          & "movl $-1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_eq;
 

  function ga_neq(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jme  E" & num_etiq'Image(e) & newline
          & "movl $1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $-1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_neq;
  
  
  function ga_le(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jle  E" & num_etiq'Image(e) & newline
          & "movl $-1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_le;
  
  
  function ga_lt(a, b, c: in num_var) return String is
    e, e1: num_etiq;
  begin
    nova_etiq(ne, e);
    nova_etiq(ne, e1);
    return  ga_load(b, eax)
          & ga_load(c, ebx)
          & "cmpl %ebx, %eax" & newline
          & "jl  E" & num_etiq'Image(e) & newline
          & "movl $-1, %ecx" & newline
          & ga_goto(e1)
          & ga_etiq(e)
          & "movl $1, %ecx" & newline
          & ga_etiq(e1)
          & ga_store(a, ecx);
  end ga_lt;

end semantica.g_codi_ass;
