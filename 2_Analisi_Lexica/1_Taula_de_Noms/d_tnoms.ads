with Ada.Containers; use Ada.Containers;
with general_defs; use general_defs;
with Ada.Text_IO; with Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
 use Ada.Text_IO;
package d_tnoms is
   type tnoms is limited private;

   max_ch: constant Natural := (max_id+max_str)*64;
   space_overflow,bad_use: exception;

   procedure empty(tn: out tnoms);
   procedure put(tn: in out tnoms; nom: in string; ident: out id_nom);
   function get(tn: in tnoms; ident: in id_nom)return string;

   procedure put(tn: in out tnoms; text: in string; ids: out id_str);
   function get(tn: in tnoms; ids: in id_str) return string;

private
   b: constant Hash_Type:=Hash_Type(max_id); --In the Ada.Containers package;
   subtype hash_index is Hash_Type range 0..b-1;
   type list_item is
      record
         psh:id_nom;
         ptc:natural;
      end record;
   type id_table is array (id_nom) of list_item;
   type str_table is array (id_str) of Natural;
   type disp_table is array (hash_index) of id_nom;
   subtype char_table is String(1..max_ch);

   type tnoms is
      record
         td: disp_table:=(others=>null_id);
         tid: id_table:=(others=>(null_id,0));
         ts: str_table:=(others=>max_ch);
         tc: char_table;
         nid: id_nom:=null_id;--number of assigned identifiers;
         ns: id_str:=null_ids;--number of stored strings;
         nc: Natural:=0;--number of stored characters as identifiers;
         ncs: Natural:=max_ch;--number of stored characters as strings;
      end record;

end d_tnoms;
