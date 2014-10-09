with Ada;with general_defs; with d_tnoms; with Ada.Text_IO; with Ada.Integer_Text_IO; with ada.Strings;
with Ada.Strings.Unbounded;
use general_defs;use d_tnoms; use Ada.Text_IO;use Ada.strings; use ada.Strings.Unbounded;
use Ada;
procedure Main is
   tn:tnoms;
   ident:id;
   --     ids:id_str;
   ret: Ada.Strings.Unbounded.Unbounded_String;
begin

   empty(tn);
   put(tn,"Hello",ident); --
   get(tn,ident,ret);
   put(Ada.Strings.Unbounded.To_String(ret));
   new_line;
   --     put(tn,"Hi",ident);
   --     put("Hi: " & ident'img);
end Main;
