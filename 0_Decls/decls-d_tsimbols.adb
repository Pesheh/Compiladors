with semantica; use semantica;
with semantica.missatges; use semantica.missatges;
package body decls.d_tsimbols is

  procedure empty(ts: out tsimbols) is
    td: tdescripcio renames ts.td;
    tb: tblocks renames ts.tb;
    prof: profunditat renames ts.prof;
  begin
    for id in id_nom loop
      td(id):= (0,(td => dnula),0);
    end loop;
    prof:= 0; tb(prof):= 0;
    prof:= 1; tb(prof):= tb(prof-1);
  end empty;


  procedure put(ts: in out tsimbols; id: in id_nom; d: in descripcio; error: out boolean) is
    td: tdescripcio renames ts.td;
    te: texpansio renames ts.te;
    tb: tblocks renames ts.tb;
    prof: profunditat renames ts.prof;
    ie: index_expansio;
  begin
    missatges_imprimir_desc("put",d, id, prof'img);

    error:= false;
    if td(id).prof=prof then
      error:= true;
    end if;
    if not error then
      ie:= tb(prof); ie:= ie+1; tb(prof):= ie;
      te(ie).prof:= td(id).prof; te(ie).d:= td(id).d;
      td(id).prof:= prof;
      td(id).d:= d;
      te(ie).id:= id; te(ie).next:= 0;
    end if;
  end put;


  function get(ts: in tsimbols; id: in id_nom) return descripcio is
    td: tdescripcio renames ts.td;
  begin
    return td(id).d;
  end get;




  procedure put_camp(ts: in out tsimbols; idr,idc: in id_nom; dc: in descripcio; error: out boolean) is
    td: tdescripcio renames ts.td;
    te: texpansio renames ts.te;
    tb: tblocks renames ts.tb;
    prof: profunditat renames ts.prof;
    ie: index_expansio;
  begin
    if td(idr).d.td /= dtipus then raise no_es_tipus; end if;
    if td(idr).d.dt.tsb /= tsb_rec then
      raise no_es_record;
    end if;
    error:=false;
    ie:= td(idr).next;
    while ie /= 0 and then te(ie).id /= idc loop
      ie:= te(ie).next;
    end loop;
    if ie /= 0 then error:= true; end if;
    if not error then
      ie:= tb(prof); ie:= ie+1; tb(prof):= ie;
      te(ie).id:= idc; te(ie).prof:= -1; te(ie).d:= dc;
      te(ie).next:= td(idr).next; td(idr).next:= ie;
    end if;
  end put_camp;


  function get_camp(ts: in tsimbols; idr,idc: in id_nom) return descripcio is
    td: tdescripcio renames ts.td;
    te: texpansio renames ts.te;
    ie: index_expansio;
    d: descripcio;
  begin
    if td(idr).d.td /= dtipus then raise no_es_tipus; end if;
    if td(idr).d.dt.tsb /= tsb_rec then raise no_es_record; end if;
    ie:= td(idr).next;
    while ie /= 0 and then te(ie).id /= idc loop
      ie:= te(ie).next;
    end loop;
    if ie=0 then d:= (td => dnula);
    else d:= te(ie).d;
    end if;
    return d;
  end get_camp;

  procedure update(ts: in out tsimbols; id: in id_nom; d: in descripcio) is
    td: tdescripcio renames ts.td;
  begin
    td(id).d:=d;
  end update;


  procedure put_index(ts: in out tsimbols; ida: in id_nom; di: in descripcio) is
    td: tdescripcio renames ts.td;
    tb: tblocks renames ts.tb;
    te: texpansio renames ts.te;
    prof: profunditat renames ts.prof;
    ie, iep: index_expansio;
  begin
    if td(ida).d.td /= dtipus then raise no_es_tipus; end if;
    if td(ida).d.dt.tsb /= tsb_arr then raise no_es_array; end if;
    iep:=0; ie:= td(ida).next;
    while ie /= 0 loop
      iep:= ie; ie:= te(ie).next;
    end loop;
    ie:= tb(prof); ie:= ie+1; tb(prof):= ie;
    te(ie).id:= null_id; te(ie).d:= di; te(ie).prof:= -1;
    if iep = 0 then td(ida).next:= ie;
    else te(iep).next:= ie;
    end if;
      te(ie).next:= 0;
  end put_index;


  procedure first(ts: in tsimbols; ida: in id_nom; it: out iterador_index) is
    td: tdescripcio renames ts.td;
  begin
    if td(ida).d.td /= dtipus then raise no_es_tipus; end if;
    if td(ida).d.dt.tsb /= tsb_arr then raise no_es_array; end if;
    it.ie:= td(ida).next;
  end first;


  procedure next(ts: in tsimbols; it: in out iterador_index) is
    te: texpansio renames ts.te;
  begin
    if it.ie=0 then raise mal_us; end if;
    it.ie:= te(it.ie).next;
  end next;


  function get(ts: in tsimbols; it: in iterador_index) return descripcio is
    te: texpansio renames ts.te;
  begin
    if it.ie=0 then raise mal_us; end if;
    return te(it.ie).d;
  end get;


  function is_valid(it: in iterador_index) return boolean is
  begin
    return it.ie /= 0;
  end is_valid;




  procedure put_arg(ts: in out tsimbols; idp,ida: in id_nom; da: in descripcio;error: out boolean) is
    td: tdescripcio renames ts.td;
    te: texpansio renames ts.te;
    tb: tblocks renames ts.tb;
    prof: profunditat renames ts.prof;
    ie, iep: index_expansio;
  begin
    if td(idp).d.td /= dproc then raise no_es_proc; end if;
    iep:= 0; ie:= td(idp).next;
    while ie /= 0 and then te(ie).id /= ida loop
      iep:= ie; ie:= te(ie).next;
    end loop;
    error:=false;
    if ie /= 0 then error:= true; end if;
    if not error then
      ie:= tb(prof); ie:= ie+1; tb(prof):= ie;
      te(ie).id:= ida; te(ie).d:= da; te(ie).prof:= -1;
      if iep = 0 then td(idp).next:= ie;
      else te(iep).next:= ie;
      end if;
      te(ie).next:= 0;
    end if;
  end put_arg;


  procedure first(ts: in tsimbols; idp: in id_nom; it: out iterador_arg) is
    td: tdescripcio renames ts.td;
  begin
    if td(idp).d.td /= dproc then raise no_es_proc; end if;
    it.ie:= td(idp).next;
  end first;


  procedure next(ts: in tsimbols; it: in out iterador_arg) is
    te: texpansio renames ts.te;
  begin
    if it.ie=0 then raise mal_us; end if;
    it.ie:= te(it.ie).next;
  end next;


  procedure get(ts: in tsimbols; it: in iterador_arg; ida: out id_nom; da: out descripcio) is
    te: texpansio renames ts.te;
  begin
    if it.ie=0 then raise mal_us; end if;
    ida:= te(it.ie).id;
    da:= te(it.ie).d;
  end get;


  function is_valid(it: in iterador_arg) return boolean is
  begin
    return it.ie /= 0;
  end is_valid;



  procedure enter_block(ts: in out tsimbols) is
    tb: tblocks renames ts.tb;
    prof: profunditat renames ts.prof;
    ie: index_expansio;
  begin
    ie:= tb(prof);
    prof:= prof+1;
    tb(prof):= ie;
  end enter_block;


  procedure exit_block(ts: in out tsimbols) is
    td: tdescripcio renames ts.td;
    tb: tblocks renames ts.tb;
    te: texpansio renames ts.te;
    prof: profunditat renames ts.prof;
    ie, il: index_expansio;
    id: id_nom;
  begin
    ie:= tb(prof); prof:= prof-1; il:= tb(prof);
    while ie > il loop
      if te(ie).prof /= -1 then
        id:= te(ie).id;
        td(id).prof:= te(ie).prof; td(id).d:= te(ie).d; td(id).next:= te(ie).next;
      end if;
      ie:= ie-1;
    end loop;
  end exit_block;


  function get_prof(ts: in tsimbols) return profunditat is
  begin
    return ts.prof;
  end get_prof;

  function "<"(prof1, prof2: in profunditat) return boolean is
  begin
    return Integer(prof1) < Integer(prof2);
  end "<";

  function value(prof: in profunditat) return integer is
  begin
    return Integer(prof);
  end value;

end decls.d_tsimbols;
