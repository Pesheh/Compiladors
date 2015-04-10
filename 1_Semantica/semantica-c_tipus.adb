with semantica; use semantica;
with semantica.g_codi_int; use semantica.g_codi_int;
with decls; use decls;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
package body semantica.c_tipus is

  --Encara no s'han posat els missatges d'error!


  --S'inicialitzen els tipus basics, altres valors predefinits(true,false)
  --i els procediments d'entrada/sortida

  procedure posa_entorn_standard is
    idb,idtr,idf:id_nom;
    idint,idchar: id_nom;
    idstdio: id_nom;
    desc: descripcio;
    error: boolean;
  begin

    --Booleanes
    put(tn,"boolean",idb);
    desc:=(td=>dtipus,dt=>(tsb=>tsb_bool,ocup=>4,linf=>-1,lsup=>0));
    put(ts,idb,desc,error);
    if error then null; end if; --posar missatge d'error

    put(tn,"true",idtr);
    desc:=(td=>dconst,tc=>idtr,vc=>-1);
    put(ts,idtr,desc,error);
    if error then null; end if; --posar missatge d'error

    put(tn,"false",idf);
    desc:=(td=>dconst,tc=>idf,vc=>0);
    put(ts,idf,desc,error);
    if error then null; end if;

    --Enters
    put(tn,"integer",idint);

    desc:=(td=>dtipus,dt=>(tsb=>tsb_ent,ocup=>4,linf=>valor'First,lsup=>valor'Last));
    put(ts,idint,desc,error);
    if error then null; end if; --posar missatge d'error

    --Caracters
    put(tn,"character",idchar);
    desc:=(td=>dtipus,dt=>(tsb=>tsb_car,ocup=>4,linf=>Character'pos(Character'First),lsup=>Character'pos(Character'Last)));
    put(ts,idchar,desc,error);
    if error then null;end if; --posar missatge d'error


    --STDIO
    --putc
    put(tn,"putc",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --puti
    put(tn,"puti",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --puts
    put(tn,"puts",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --newline
    put(tn,"newline",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --geti
    put(tn,"geti",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --getc -> per caracters de 4 bytes(com es el nostre cas)
    put(tn,"getc",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

    --getcc -> per caracters de 1 byte( en cas que lo necessitem)
    put(tn,"getcc",idstdio);
    desc:=(td=>dproc,np=>nou_proc);
    put(ts,idstdio,desc,error);
    if error then null; end if; --posar missatge d'error

  end posa_entorn_standard;

  
  
  --Declaracions

  procedure ct_decls(nd_decls: in pnode) is
    nd_decl: pnode;
  begin
    if nd_decls.decls_decls/=null then
      ct_decls(nd_decls.decls_decls);
    end if;
    nd_decl:=nd_decls.decls_decl.decl_real;
    case nd_decl.tn is
      when nd_proc=> ct_decl_proc(nd_decl); 
      when nd_decl_var=> ct_decl_var(nd_decl);
      when nd_decl_t=> ct_decl_tipus(nd_decl);
      when nd_decl_const=> ct_decl_const(nd_decl);
      when others => null; --posar missatge d'error , no s'hauria d'arribar aqui!
    end case;
  end ct_decls;
 
  procedure ct_decl_tipus(decl_tipus: in pnode) is

  begin 
    case decl_tipus.dt_cont.tn is
      when nd_decl_t_cont_type=> ct_rang(decl_tipus);
      when nd_decl_t_cont_record=> ct_record(decl_tipus);
      when nd_decl_t_cont_arry=> ct_array(decl_tipus);
      when others => null; --posar missatge d'error, no s'hauria d'arribar aqui!
    end case;
  end ct_decl_tipus;
  
  
  
  
  procedure ct_decl_var(decl_var: in pnode) is 
    id_tipus: id_nom;
    d_tipus: descripcio;
  begin
    id_tipus:=decl_var.dvar_tipus.id_id;
    d_tipus:=get(ts,id_tipus);
    if d_tipus.td /= dtipus then null; end if; --posar missatge d'error
    ct_lid_var(decl_var.dvar_lid,id_tipus);   
  end ct_decl_var;


  procedure ct_lid_var(lid_var: in pnode; idt: in id_nom) is
    id_var: id_nom;
    d_var: descripcio;
    error: boolean;
  begin
    if lid_var.lid_seg/=null then
      ct_lid_var(lid_var.lid_seg,idt);
    end if;
    id_var:=lid_var.lid_id.id_id; --L'identificador de la var
    d_var:=(td=>dvar,tv=>idt,nv=>nova_var);
    put(ts,id_var,d_var,error);
    if error then null; end if; --posar missatge d'error
  end ct_lid_var;


  procedure ct_decl_const(decl_const: in pnode) is
    id_tipus: id_nom;
    d_tipus,desc: descripcio;
    id_valor: id_nom;
    v_valor: valor;
    tsb_valor: tipus_subjacent;
  begin 
    id_tipus:=decl_const.dconst_tipus.id_id;
    d_tipus:=get(ts,id_tipus);
    if d_tipus.td /= dtipus then null; end if; --posar missatge d'error
    if d_tipus.dt.tsb > tsb_ent then null; end if; --posar missatge d'error

    ct_valor(decl_const.dconst_valor,id_valor,tsb_valor,v_valor); 

    if id_valor=null_id and then tsb_valor/=d_tipus.dt.tsb then null; end if; --posar missatge d'error
    if id_valor/=null_id and then id_valor/=id_tipus then null; end if; --posar missatge d'error

    if v_valor<d_tipus.dt.linf or v_valor > d_tipus.dt.lsup then null; end if; --posar missatge d'error
    desc:=(td=>dconst,tc=>id_tipus,vc=>v_valor);
    ct_lid_const(lid_const=>decl_const.dconst_lid,desc=> desc);
  end ct_decl_const;

  procedure ct_lid_const(lid_const: in pnode; desc: in descripcio) is
    id_const: id_nom;
    error: boolean;
  begin
    if lid_const.lid_seg/=null then
      ct_lid_const(lid_const.lid_seg,desc);
    end if;
    id_const:=lid_const.lid_id.id_id; 
    put(ts,id_const,desc,error);
    if error then null; end if; --posar missatge d'error
  end ct_lid_const;


  procedure ct_rang(decl_rang: in pnode) is
    id_tipus: id_nom;
    desc_tipus: descripcio;
    id_valor1,id_valor2: id_nom;
    v_valor1,v_valor2: valor;
    tsb_valor1,tsb_valor2: tipus_subjacent;
    desc:descripcio;
    error: boolean;
  begin
    id_tipus:=decl_rang.rang_id;
    desc_tipus:=get(ts,id_tipus);
    if desc_tipus.td /= dtipus then null; end if; -- posar missatge d'error
    if desc_tipus.dt.tsb>tsb_ent then null; end if; --posar missatge d'error 
    ct_valor(decl_rang.rang_linf,id_valor1,tsb_valor1,v_valor1); 
    if id_valor1=null_id and then tsb_valor1/=desc_tipus.dt.tsb then null; end if; --posar missatge d'error
    if id_valor1/=null_id and then id_valor1/=id_tipus then null; end if; --posar missatge d'error

    ct_valor(decl_rang.rang_lsup,id_valor2,tsb_valor2,v_valor2); 
    if id_valor2=null_id and then tsb_valor2/=desc_tipus.dt.tsb then null; end if; --posar missatge d'error
    if id_valor2/=null_id and then id_valor2/=id_tipus then null; end if; --posar missatge d'error

    if v_valor1>v_valor2 then null; end if; --posar missatge d'error
    if v_valor1 < desc_tipus.dt.linf then null; end if; -- posar missatge d'error
    if v_valor2 > desc_tipus.dt.lsup then null; end if; -- posar missatge d'error

    --Se que es chapuza!! Pero el tsb debe ser estatico
    case desc_tipus.dt.tsb is
      when tsb_ent => 
        desc:=(td=>dtipus,
        dt=>(tsb=> tsb_ent,ocup=> desc_tipus.dt.ocup,linf=>v_valor1,lsup=>v_valor2));
      when tsb_car => 
        desc:=(td=>dtipus,
        dt=>(tsb=> tsb_car,ocup=> desc_tipus.dt.ocup,linf=>v_valor1,lsup=>v_valor2));
      when tsb_bool => 
        desc:=(td=>dtipus,
        dt=>(tsb=> tsb_bool,ocup=> desc_tipus.dt.ocup,linf=>v_valor1,lsup=>v_valor2));
      when others => null;
    end case;
    put(ts,id_tipus,desc,error);
    if error then null; end if; -- posar missatge d'error
  end ct_rang;


  procedure ct_valor(nd_idx: in pnode; id_tipus: out id_nom; tsb: out tipus_subjacent; v: out valor) is
    desc,d_tipus: descripcio;
    p: pnode;
  begin
    p:=nd_idx.idx_cont.idxc_valor;
    case p.tn is
      when nd_id =>
        desc:=get(ts,p.id_id);
        if desc.td/=dconst then null; end if; --posar missatge d'error
        d_tipus:=get(ts,desc.tc);

        if nd_idx.idx_tipus=negatiu then
          if d_tipus.dt.tsb/=tsb_ent then null; end if; --posar missatge d'error
          v:=-d_tipus.vc;
        else 
          v:=d_tipus.vc;
        end if;
        id_tipus:=desc.tc;
        tsb:=d_tipus.dt.tsb;

      when nd_lit =>
        id_tipus:=null_id;
        tsb:=p.lit_tipus;
        if nd_idx.idx_tipus=negatiu then
          if tsb/=tsb_ent then null; end if; --posar missatge d'error
          v:=-valor'Value(get(tn,p.lit_ids)); --No he comprobado que este tipo de casting funciona!!!
        else
          v:=valor'Value(get(tn,p.lit_ids));
        end if;
      when others => null; --No es pot donar aquesta opcio
    end case;

  end ct_valor;

  --RECORD: Primer s'afegeix el record a la ts comprovant que no hi existia, despres s'afegeixen els camps:
  --Per a cada camp es comprova que es un tipus i s'afegeixen un per un els ids de la lid
  procedure ct_record(nd_record: in pnode) is
    desc_record: descripcio;
    id_record: id_nom;
    error: boolean;
    desp: despl:=0; --El desplacament dels camps
  begin
    id_record:=nd_record.dt_id.id_id;
    desc_record:=(td=>dtipus,dt=>(tsb=> tsb_rec, ocup=> 0));
    put(ts,id_record,desc_record,error);
    if error then null; end if; --posar missatge d'error

    --processament de camps
    ct_dcamps(nd_record.dt_cont.dtcont_camps,id_record,desp);
    --Actualitzacio de l'ocupacio del record
    desc_record:=(td=>dtipus,dt=>(tsb=> tsb_rec, ocup=> desp));
    update(ts,id_record,desc_record);
  end ct_record;


  procedure ct_dcamps(nd_dcamps: in pnode;idr: in id_nom;desp: in out despl) is
  begin
    if nd_dcamps.dcamps_dcamps/=null then
      ct_dcamps(nd_dcamps.dcamps_dcamps,idr,desp);
    end if;
    ct_dcamp(nd_dcamps.dcamps_dcamp,idr,desp);
  end ct_dcamps;

  procedure ct_dcamp(nd_dcamp: in pnode;idr: in id_nom;desp: in out despl) is
    id_tipus: id_nom;
    desc_tipus: descripcio;
  begin
    id_tipus:=nd_dcamp.dcamp_decl.dvar_tipus.id_id;
    desc_tipus:=get(ts,id_tipus);
    if desc_tipus.td/=dtipus then null; end if; --posar missatge d'error
    ct_dcamp_lid(nd_dcamp.dcamp_decl.dvar_lid,id_tipus,idr,desp,desc_tipus.dt.ocup);
  end ct_dcamp;


  procedure ct_dcamp_lid(nd_lid: in pnode; idt,idr: in id_nom; desp: in out despl;ocup: in despl) is
    --idt: identificador del tipus
    --idr: identificador del record
    --ocup: l'ocupacio de cada element del tipus
    --desp: el desplacament del siguient camp
    id_camp: id_nom;
    desc_camp: descripcio;
    error: boolean;
  begin
    if nd_lid.lid_seg/=null then 
      ct_dcamp_lid(nd_lid.lid_seg,idt,idr,desp,ocup);
    end if;
    id_camp:=nd_lid.lid_id.id_id;
    desc_camp:=(td=>dcamp,tcmp=>idt,dcmp=>desp);
    put_camp(ts,idr,id_camp,desc_camp,error);
    if error then null; end if; --posar missatge d'error
    desp:=desp+ocup;
  end ct_dcamp_lid;


  --ARRAY
  procedure ct_array(nd_array: in pnode) is
    id_array: id_nom;
    desc_array: descripcio;
    id_tipus: id_nom;
    desc_tipus:descripcio;
    num_components: valor:=0; 
    ocup: despl;
    error: boolean;
  begin
    id_array:=nd_array.dt_id.id_id;
    id_tipus:=nd_array.dt_cont.dtcont_tipus.id_id;
    -- El valor 0 de B del tipus array es temporal <<<< ALERTA
    desc_array:=(td=>dtipus,dt=> (tsb=>tsb_arr,b=>0,ocup=>0,tcomp=>id_tipus));
    put(ts,id_array,desc_array,error);
    if error then null; end if; --posar missatge d'error
    ct_array_idx(nd_array.dt_cont.dtcont_idx,id_array,num_components);
    desc_tipus:=get(ts,id_tipus);
    if desc_tipus.td/=dtipus then null; end if; --posar missatge d'error

    --No estic segur si aquesta conversio es correcta!
    ocup:=despl'val(num_components)*desc_tipus.dt.ocup; 
    -- El valor de B del tipus array es temporal <<<< ALERTA
    desc_array:=(td=>dtipus,dt=> (tsb=>tsb_arr,b=>0,ocup=>ocup,tcomp=>id_tipus));
    update(ts,id_array,desc_array);
  end ct_array;

  procedure ct_array_idx(nd_lidx: in pnode;id_array: in id_nom; num_comp: in out valor) is 
    desc_rang,desc_idx:descripcio;
    id_rang: id_nom;
  begin
    if nd_lidx.lid_seg/=null then
      ct_array_idx(nd_lidx.lid_seg,id_array,num_comp);
    end if;
    id_rang:=nd_lidx.lid_id.id_id;
    desc_rang:=get(ts,id_rang);
    if desc_rang.td/=dtipus then null; end if; --posar missatge d'error
    if desc_rang.dt.tsb>tsb_ent then null; end if; --posar missatge d'error
    desc_idx:=(td=>dindx,tind=>id_rang);
    put_index(ts,id_array,desc_idx);
    num_comp:=num_comp+desc_rang.dt.lsup-desc_rang.dt.linf+1;
  end ct_array_idx;


  procedure ct_decl_proc(nd_procediment: in pnode) is
    id_proc: id_nom;
    desc_proc: descripcio;
    error:boolean;
  begin
    id_proc:=nd_procediment.proc_cproc.cproc_id.id_id;
    desc_proc:=(td=>dproc,np=>nou_proc);
    put(ts,id_proc,desc_proc,error);
    if error then null; end if; --posar missatge d'error
    if nd_procediment.proc_cproc.cproc_args/=null then
      ct_decl_args(nd_procediment.proc_cproc.cproc_args,id_proc);
    end if;
    enter_block(ts);
    --!!!En els apunts tenc un comentari en el qual es fa un recorregut del arguments, pero no se perque!!!
    

    exit_block(ts); 
  end ct_decl_proc;

  procedure ct_decl_args(nd_args: in pnode;id_proc: in id_nom) is
    id_tipus: id_nom;
    desc_tipus: descripcio;

  begin
    if nd_args.args_args/=null then
      ct_decl_args(nd_args.args_args, id_proc);
    end if;

    id_tipus:=nd_args.args_arg.arg_tipus.id_id;
    desc_tipus:=get(ts,id_tipus);
    if desc_tipus.td/=dtipus then null; end if; --posar missatge d'error
    ct_decl_arg(nd_args.args_arg.arg_lid, id_proc, id_tipus, nd_args.args_arg.arg_mode);
  end ct_decl_args;

  procedure ct_decl_arg(nd_lid_arg: in pnode;id_proc,id_tipus: in id_nom;mode: in tmode) is
    id_arg: id_nom;
    desc_arg: descripcio;
    error: boolean;
  begin
    if nd_lid_arg.lid_seg/=null then
      ct_decl_arg(nd_lid_arg.lid_seg,id_proc,id_tipus,mode);
    end if;
    case mode is
      when md_in_out => desc_arg:=(td=>dvar,tv=>id_tipus,nv=>nova_var);
      when md_in => desc_arg:=(td=>dargc,ta=>id_tipus,na=>nova_var);
    end case;
    id_arg:=nd_lid_arg.lid_id.id_id;
    put_arg(ts,id_proc,id_arg,desc_arg,error);
    if error then null; end if; --posar missatge d'error
  end ct_decl_arg;

end semantica.c_tipus;
