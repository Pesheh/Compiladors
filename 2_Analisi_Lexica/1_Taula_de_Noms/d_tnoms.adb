
with Ada.Strings.Hash; use ada.Strings;
package body d_tnoms is
   --Auxiliar operations:
   procedure save_name(tc: in out char_table;nom:in string;nc: in out integer) is
   begin
      for i in nom'Range loop
         nc:=nc+1; tc(nc):=nom(i);
      end loop;
   end save_name;

   procedure save_string(tc: in out char_table;text:in string;ncs: in out integer) is
   begin
      for i in text'Range loop
         ncs:=ncs-1;tc(ncs):=text(i);
      end loop;
   end save_string;

   function equal(nom: in string;tn: in tnoms;p:in id) return boolean is
      tid: id_table renames tn.tid;
      tc: char_table renames tn.tc;
      nid: id renames tn.nid;
      pi,pf: natural;
      i,j:natural;
   begin
      pi:=tid(p-1).ptc+1;pf:=tid(p).ptc;
      i:=nom'first;j:=pi;
      while nom(i)=tc(j) and i<nom'Last and j<pf loop i:=i+1; j:=j+1; end loop;
      return nom(i)=tc(j) and i=nom'Last and j=pf;
   end equal;

   function equal(text: in string; tn: in tnoms;p:in id_str) return boolean is
      ts: str_table renames tn.ts;
      tc: char_table renames tn.tc;
      pi,pf: integer;
      i,j:integer;
   begin
      pi:=ts(p-1)-1; pf:=ts(p);
      i:=text'last; j:=pi;
      while text(i)=tc(j) and i>text'first and j>pf loop i:=i-1;j:=j-1; end loop;
      return text(i)=tc(j) and i=text'first and j=pf;

   end equal;

   -- *******************************************************************
   procedure empty(tn: out tnoms)is
      td:disp_table renames tn.td;
      tid:id_table renames tn.tid;
      ts: str_table renames tn.ts;
      nid:id renames tn.nid;
      ns: id_str renames tn.ns;
      nc: integer renames tn.nc;
      ncs:integer renames tn.ncs;
   begin
      for i in hash_index loop td(i):=null_id; end loop;
      nid:=0;ns:=0;nc:=0;ncs:=max_ch;
      tid(null_id):=(null_id,nc);ts(null_ids):=max_ch;
   end empty;


   procedure put(tn: in out tnoms; nom: in string; ident: out id)is
      td: disp_table renames tn.td;
      tid: id_table renames tn.tid;
      tc: char_table renames tn.tc;
      nid: id renames tn.nid;
      nc: integer renames tn.nc;
      ncs: integer renames tn.ncs;
      i:hash_type;
      p:id;
   begin
      i:=hash(nom) mod b;p:=td(i);
      while p/=null_id and then not equal(nom,tn,p) loop p:=tid(p).psh; end loop;
      if p=null_id then
         if nid=id(max_id) then raise space_overflow; end if;
         if nc+nom'Length>ncs then raise space_overflow; end if;
         save_name(tc,nom,nc);
         nid:=nid+1;tid(nid):=(td(i),nc);
         td(i):=nid;p:=nid;
      end if;
      ident:=p;
   end put;

   function get(tn: in tnoms; ident: in id) return a_string is
      tid: id_table renames tn.tid;
      tc: char_table renames tn.tc;
      nid: id renames tn.nid;
      i,j: integer;
   begin
      if ident=null_id or ident>nid then raise bad_use;end if;
      i:=tid(ident-1).ptc+1; j:=tid(ident).ptc;
      return new String'(tc(i..j));
   end get;

   procedure put(tn: in out tnoms; text: in string;ids: out id_str)is
      tc: char_table renames tn.tc;
      ts: str_table renames tn.ts;
      ns: id_str renames tn.ns;
      ncs: integer renames tn.ncs;
      nc:integer renames tn.nc;
      p: id_str;
   begin
      p:=null_ids+1;
      if ns=id_str(max_str) then raise space_overflow; end if;
      while ts(p)/=0 and then not equal(text,tn,p) loop p:=p+1; end loop;
      if ts(p)=0 then
<<<<<<< HEAD
         if ncs -text'Length<nc then raise space_overflow; end if;
         save_string(text,tc,ncs);
=======
         if ns=id_str(max_str) then raise space_overflow; end if;
         if ncs-text'Length<nc then raise space_overflow; end if;
         save_string(tc,text,ncs);
>>>>>>> 08839528ab462bda7fa44b6f1dd97748b7d3ea72
         ns:=ns+1;ts(ns):=ncs; p:=ns;
      end if;
      ids:=p;
   exception
      when space_overflow=> put("Space overflow");
   end put;

   function get(tn: in tnoms; ids: in id_str) return a_string is
      tc:char_table renames tn.tc;
      ts: str_table renames tn.ts;
      ns: id_str renames tn.ns;--number of stored strings
      i,j: integer;
   begin
      if ids=null_ids or ids>ns then raise bad_use; end if;
      j:=ts(ids-1)-1;i:=ts(ids);
      return new String'(tc(i..j));
   end get;



end d_tnoms;