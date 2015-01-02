with Ada;with general_defs; with d_tnoms; with Ada.Text_IO; with Ada.Integer_Text_IO; with ada.Strings;
use general_defs;use d_tnoms; use Ada.Text_IO;use Ada.strings;
procedure Main is
   tn:tnoms;
   ident:id_nom;
   ids:id_str;
begin
   empty(tn);
   put(tn,"Hello",ids);
   put(ids'Img); put("   ");
   put(get(tn,ids));
   new_line;
   put(tn,"HelloHelloHelloHelloHello",ids);
   put(ids'Img); put("   ");
   put(tn,"HelloHelloHelloHelloHello",ids);
   put(ids'Img); put("   ");
   put(get(tn,ids));
end Main;
