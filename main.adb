with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Command_Line; use Ada.Command_Line;
with a_lexic; use a_lexic;
with a_sintactic; use a_sintactic;
with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with semantica; use semantica;
with semantica.c_arbre; use semantica.c_arbre;
with semantica.c_tipus; use semantica.c_tipus;
with semantica.g_codi_int; use semantica.g_codi_int;

procedure main is
  i: natural;
  err: boolean;
begin
  i:= Argument_Count;
  if i = 0 then
    Ada.Text_IO.Put_Line("No s'ha especificat quin fitxer processar");
  elsif i > 1 then
    Ada.Text_IO.Put_Line("Sols es pot processar un fitxer alhora");
  else
    Open(Argument(1));
    semantica.c_tipus.posa_entorn_standard;
    YYParse;
    Close;
    semantica.c_tipus.comprovacio_tipus(err);
    if not err then
      semantica.print_arbre;
      semantica.g_codi_int.gen_codi_int;
    end if;
  end if;
exception
  when Ada.IO_Exceptions.Name_Error =>
    Ada.Text_IO.Put_Line("No s'ha trobat el fitxer especificat '"&Argument(1)&"'");
end main;
