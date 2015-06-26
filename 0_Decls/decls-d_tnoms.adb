with Ada.Strings.Hash; use ada.Strings;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with semantica.missatges; use semantica.missatges;
package body decls.d_tnoms is

  --Auxiliar operations:
  procedure save_name(tc: in out char_table; nom: in string; nc: in out integer) is
  begin
    for i in nom'Range loop
      nc:= nc+1; tc(nc):= nom(i);
    end loop;
  end save_name;


  procedure save_string(tc: in out char_table; text: in string; ncs: in out integer) is
  begin
    for i in reverse text'Range loop
      ncs:= ncs-1; tc(ncs):= text(i);
    end loop;
  end save_string;


  function equal(nom: in string; tn: in tnoms; p: in id_nom) return boolean is
    tid: id_table renames tn.tid;
    tc: char_table renames tn.tc;
    nid: id_nom renames tn.nid;
    pi,pf: natural;
    i,j:natural;
  begin
    pi:= tid(p-1).ptc+1; pf:= tid(p).ptc;
    i:= nom'first;j:= pi;
    while nom(i)=tc(j) and i<nom'Last and j<pf loop
      i:= i+1; j:= j+1;
    end loop;
    return nom(i)=tc(j) and i=nom'Last and j=pf;
  end equal;

  -- *******************************************************************


  procedure empty(tn: out tnoms)is
    td: disp_table renames tn.td;
    tid: id_table renames tn.tid;
    ts: str_table renames tn.ts;
    nid: id_nom renames tn.nid;
    ns: id_str renames tn.ns;
    nc: integer renames tn.nc;
    ncs: integer renames tn.ncs;
  begin
    for i in hash_index loop td(i):=null_id; end loop;
    nid:= null_id; ns:= 0; nc:=0; ncs:= max_ch;
    tid(null_id):= (null_id, nc); ts(0):= max_ch;
  end empty;


  procedure put(tn: in out tnoms; nom: in string; ident: out id_nom)is
    td: disp_table renames tn.td;
    tid: id_table renames tn.tid;
    tc: char_table renames tn.tc;
    nid: id_nom renames tn.nid;
    nc: integer renames tn.nc;
    ncs: integer renames tn.ncs;
    i: hash_type;
    p: id_nom;
    nm: String:= To_Lower(nom);
  begin
    i:= hash(nm) mod b; p:= td(i);
    while p/=null_id and then not equal(nm,tn,p) loop
      p:= tid(p).psh;
    end loop;
    if p=null_id then
      if nid=maxid then raise space_overflow; end if;
      if nc+nom'Length>ncs then raise space_overflow; end if;
      save_name(tc, nm, nc);
      nid:= nid+1; tid(nid):= (td(i),nc);
      td(i):=nid; p:=nid;
    end if;
    missatges_imprimir_id("put",p, nm);
    ident:= p;
  end put;


  function get(tn: in tnoms; ident: in id_nom) return string is
    tid: id_table renames tn.tid;
    tc: char_table renames tn.tc;
    nid: id_nom renames tn.nid;
    i,j: integer;
  begin

    missatges_imprimir_id("get",ident,"");
    if ident=null_id or ident>nid then raise bad_use; end if;
    i:= tid(ident-1).ptc+1; j:= tid(ident).ptc;
    return tc(i..j);
  end get;


  procedure put(tn: in out tnoms; text: in string;ids: out id_str)is
    tc: char_table renames tn.tc;
    ts: str_table renames tn.ts;
    ns: id_str renames tn.ns;
    ncs: integer renames tn.ncs;
    nc: integer renames tn.nc;
  begin
    if ns=maxstr then raise space_overflow; end if;
    if ncs-text'Length<nc then raise space_overflow; end if;
    save_string(tc, text, ncs);
    ns:= ns+1; ts(ns):= ncs;
    ids:=ns;
  end put;


  function get(tn: in tnoms; ids: in id_str) return string is
    tc: char_table renames tn.tc;
    ts: str_table renames tn.ts;
    ns: id_str renames tn.ns;
    i,j: integer;
  begin
    if ids=0 or ids>ns then raise bad_use; end if;
    j:= ts(ids-1)-1; i:= ts(ids);
    return tc(i..j);
  end get;

end decls.d_tnoms;
