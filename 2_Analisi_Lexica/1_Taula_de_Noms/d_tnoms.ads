with Ada.Containers; use Ada.Containers; with Ada.Strings.Unbounded;
with general_defs; use general_defs;
package d_tnoms is
   type tnoms is limited private;

   max_ch: constant integer := (max_id+max_str)*64;
   space_overflow,bad_use: exception;

   procedure empty(tn: out tnoms);
   procedure put(tn: in out tnoms; nom: in string; ident: out id);
   procedure get(tn: in tnoms; ident: in id;str:out Ada.Strings.Unbounded.Unbounded_String);

   procedure put(tn: in out tnoms; text: in string;ids: out id_str);
   function get(tn: in tnoms; ids: in id_str) return string;

private
   b: constant Hash_Type:=Hash_Type(max_id); --In the Ada.Containers package;
   subtype hash_index is Hash_Type range 0..b-1;
   type list_item is
      record
         psh:id;
         ptc:natural;
      end record;
   type id_table is array (id) of list_item;
   type str_table is array (id_str) of integer;
   type disp_table is array (hash_index) of id;
   subtype char_table is string(1..max_ch);

   type tnoms is
      record
         td: disp_table;
         tid: id_table;
         ts: str_table;
         tc: char_table;
         nid: id;--number of assigned identifiers;
         ns: id_str;--number of stored strings;
         nc: integer;--number of stored characters as identifiers;
         ncs: integer;--number of stored characters as strings;
      end record;

end d_tnoms;
