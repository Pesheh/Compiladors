with Ada.Containers; use Ada.Containers;

package decls.d_tnoms is

    type tnoms is limited private;

   --Noms
    procedure empty(tn: out tnoms);
    procedure put(tn: in out tnoms; nom: in String; ident: out id_nom);
    function get(tn: in tnoms; ident: in id_nom)return string;

   --Strings/Literals
    procedure put(tn: in out tnoms; text: in string; ids: out id_str);
    function get(tn: in tnoms; ids: in id_str) return string;

   --Excepcions
    space_overflow,bad_use: exception;

private
    max_ch: constant Natural:= (max_id+max_str)*64;
    maxid: constant id_nom:= id_nom(max_id);
    maxstr: constant id_str:= id_str(max_str);
    b: constant Ada.Containers.Hash_Type:= Ada.Containers.Hash_Type(max_id);

    subtype hash_index is Ada.Containers.Hash_Type range 0..b-1;
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
            td: disp_table:= (others=> null_id);
            tid: id_table;
            ts: str_table;
            tc: char_table;
            nid: id_nom:= null_id;--num idents
            ns: id_str:= 0;--num strings
            nc: Natural:= 0;--num chars idents
            ncs: Natural:= max_ch;--num chars strings
        end record;
end decls.d_tnoms;
