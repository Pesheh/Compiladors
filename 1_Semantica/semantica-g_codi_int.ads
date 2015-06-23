with Ada.Text_IO;
with Ada.Sequential_IO;

package semantica.g_codi_int is

  procedure prepara_g_codi_int(nomf: in String);
  procedure gen_codi_int;

private

  package Instruccio_IO is new Ada.Sequential_IO(instr_3a);

  f3a:  Instruccio_IO.File_Type;
  f3as: Ada.Text_IO.File_Type;

end semantica.g_codi_int;
