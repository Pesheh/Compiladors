with ada.text_io; use ada.text_io;

with decls; use decls;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with semantica.missatges; use semantica.missatges;
package body semantica.c_tipus is

  use Pila_Procediments;

  --DEFINICIONS
  --Declaracions
  procedure ct_decls(nd_decls: in out pnode);
  procedure ct_decl_tipus(decl_tipus: in out pnode);

  procedure ct_decl_var(decl_var: in out pnode);
  procedure ct_lid_var(lid_var: in out pnode; idt: in id_nom);

  procedure ct_decl_const(decl_const: in out pnode);
  procedure ct_lid_const(lid_const: in out pnode; desc: in decls.d_descripcio.descripcio);
  procedure ct_valor(nd_idx: in out pnode; id_tipus: out id_nom; tsb: out decls.d_descripcio.tipus_subjacent; v: out valor; pos: in out posicio);

  procedure ct_rang(decl_rang: in out pnode);

  procedure ct_record(nd_record: in out pnode);
  procedure ct_dcamps(nd_dcamps: in out pnode;idr: in id_nom;desp: in out despl);
  procedure ct_dcamp(nd_dcamp: in out pnode;idr: in id_nom;desp: in out despl);
  procedure ct_dcamp_lid(nd_lid: in out pnode; idt,idr: in id_nom; desp: in out despl;ocup: in despl);

  procedure ct_array(nd_array: in out pnode);
  procedure ct_array_idx(nd_lidx: in out pnode;id_array: in id_nom; num_comp: in out valor; b: in out valor);

  procedure ct_decl_proc(nd_procediment: in out pnode);
  procedure ct_decl_args(nd_args: in out pnode;id_proc: in id_nom; nargs: in out natural);
  procedure ct_decl_arg(nd_lid_arg: in out pnode;id_proc,id_tipus: in id_nom;mode: in tmode; nargs: in out natural);

  --Sentencias
  procedure ct_sents(nd_sents: in out pnode);
  procedure ct_sents_nob(nd_sents_nob: in out pnode);
  procedure ct_sent_iter(nd_sent: in out pnode);
  procedure ct_sent_cond(nd_sent: in out pnode);
  procedure ct_sent_crida(nd_sent: in out pnode);
  procedure ct_sent_assign(nd_sent: in out pnode);

  --Referencias
  procedure ct_ref(nd_ref: in out pnode; id_base: out id_nom; id_tipus: out id_nom; pos: in out posicio);
  procedure ct_qs(nd_qs: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; pos: in out posicio);
  procedure ct_q(nd_q: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; pos: in out posicio);
  procedure ct_qs_proc(nd_qs: in out pnode; id_base: in id_nom; pos: in out posicio);

  procedure ct_lexpr_proc(nd_lexpr: in out pnode; id_base: in id_nom;it: in out iterador_arg; pos: in out posicio);
  procedure ct_lexpr_array(nd_lexpr: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; it: in out iterador_index; pos: in out posicio);
  procedure ct_expr(nd_expr: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);

  --Expressions
  procedure ct_e(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);

  procedure ct_eop(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);
  procedure ct_eop_op_rel(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);
  procedure ct_eop_arit(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio; op: in operand );
  procedure ct_eop_neg_log(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);
  procedure ct_eop_neg_arit(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);

  procedure ct_et(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out  boolean; pos: in out posicio);
  procedure ct_et_lit(nd_lit: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);
  procedure ct_et_ref(nd_ref: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio);

  --Auxiliar
  procedure tipus_compatible(id_tipus1, id_tipus2: in id_nom; tsb1, tsb2: in tipus_subjacent; id_texp: out id_nom; tsb_exp: out tipus_subjacent; error: out boolean);



















  ERROR: boolean:= false;


  procedure comprovacio_tipus (err: out boolean) is
  begin
    buida(pproc);
    ct_decl_proc(root.p);
    err:= ERROR;
  end comprovacio_tipus;


  --S'inicialitzen els tipus basics, altres valors predefinits(true,false)
  --i els procediments d'entrada/sortida

  procedure posa_entorn_standard (c,f: out num_var) is
    idb,idtr,idf, id_arg:id_nom;
    idint,idchar: id_nom;
    idstdio: id_nom;
    desc, desc_arg: descripcio;
    error: boolean;
    prof: profunditat;
    t: num_var;
    p: num_proc;
  begin
    prof:= get_prof(ts);

    --Booleanes
    put(tn, "boolean", idb);
    desc:= (td=>dtipus, dt=>(tsb=>tsb_bool, ocup=>4, linf=>-1, lsup=>0));
    put(ts, idb, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>18, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "true", idtr);
    desc:= (td=>dconst, tc=>idb, vc=>-1);
    put(ts, idtr, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>26, columna=>5), "posa_entorn_standart");
    end if;
    nova_var_const(nv, tv, -1, tsb_ent, c);

    put(tn, "false", idf);
    desc:= (td=>dconst, tc=>idb, vc=>0);
    put(ts, idf, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>35, columna=>5), "posa_entorn_standart");
    end if;
    nova_var_const(nv, tv, 0, tsb_ent, f);

    --Enters
    put(tn, "integer", idint);
    desc:= (td=>dtipus, dt=>(tsb=>tsb_ent, ocup=>4, linf=>valor'First, lsup=>valor'Last));
    put(ts, idint, desc, error);

    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>46, columna=>5), "posa_entorn_standart");
    end if;

    --Caracters
    put(tn, "character", idchar);
    desc:= (td=>dtipus, dt=>(tsb=>tsb_car, ocup=>4, linf=>Character'pos(Character'First), lsup=>Character'pos(Character'Last)));
    put(ts, idchar, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>55, columna=>5), "posa_entorn_standart");
    end if;


    --STDIO
    --putc
    put(tn, "putc", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 1, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>68, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "c", id_arg);
    nova_var(nv, tv, tp, np, ocup_char, t);
    desc_arg:=(td=>dargc, ta=> idchar, na=> t); -- character::{ocup: 4Bytes, despl: 0}
    put_arg(ts, idstdio, id_arg, desc_arg, error);


    --puti
    put(tn, "puti", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 1, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>85, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "n", id_arg);
    nova_var(nv, tv, tp, np, ocup_ent, t);
    desc_arg:=(td=>dargc, ta=> idint, na=> t); -- integer::{ocup: 4Bytes, despl: 0}
    put_arg(ts, idstdio, id_arg, desc_arg, error);



    --puts
    put(tn, "puts", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 1, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>103, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "s", id_arg);
    nova_var(nv, tv, tp, np, ocup_ent, t); -- passam l'ids
    --cuando no tiene tipus es un string
    desc_arg:=(td=>dargc, ta=> null_id, na=> t); -- string::{ocup: 4B, despl: 0}
    put_arg(ts, idstdio, id_arg, desc_arg, error);

    --newline
    put(tn, "new_line", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 0, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>120, columna=>5), "posa_entorn_standart");
    end if;

    --geti
    put(tn, "geti", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 0, p);
    desc:= (td=>dproc, np=> p); -- ocupacio? 0 params?
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>130, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "n", id_arg);
    nova_var(nv, tv, tp, np, ocup_ent, t);
    desc_arg:=(td=>dvar, tv=> idint, nv=> t);
    put_arg(ts, idstdio, id_arg, desc_arg, error);

    --getc -> per caracters de 4 bytes(com es el nostre cas)
    put(tn, "getc", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 0, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>146, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "c", id_arg);
    nova_var(nv, tv, tp, np, ocup_char, t);
    desc_arg:=(td=>dvar, tv=> idchar, nv=> t);
    put_arg(ts, idstdio, id_arg, desc_arg, error);

    --getcc -> per caracters de 1 byte( en cas que lo necessitem)
    put(tn, "getcc", idstdio);
    nou_proc_std(np, tp, idstdio, prof, 0, p);
    desc:= (td=>dproc, np=> p);
    empila(pproc, np);
    put(ts, idstdio, desc, error);
    if error then
      ERROR:= true;
      missatges_ct_error_intern((fila=>162, columna=>5), "posa_entorn_standart");
    end if;

    put(tn, "c", id_arg);
    nova_var(nv, tv, tp, np, ocup_char, t);
    desc_arg:=(td=>dvar, tv=> idchar, nv=> t);
    put_arg(ts, idstdio, id_arg, desc_arg, error);

  end posa_entorn_standard;



  --Declaracions

  procedure ct_decls(nd_decls: in out pnode) is
    nd_decl: pnode;
  begin
    if nd_decls.decls_decls.tn /= nd_null then
      ct_decls(nd_decls.decls_decls);
    end if;
    nd_decl:= nd_decls.decls_decl.decl_real;
    case nd_decl.tn is
      when nd_proc=>
        ct_decl_proc(nd_decl);

      when nd_decl_var=>
        ct_decl_var(nd_decl);

      when nd_decl_t=>
        ct_decl_tipus(nd_decl);

      when nd_decl_const=>
        ct_decl_const(nd_decl);

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>22, columna=>5), "ct_decls");
        return;
    end case;
  end ct_decls;


  procedure ct_decl_tipus(decl_tipus: in out pnode) is

  begin
    case decl_tipus.dt_cont.tn is
      when nd_decl_t_cont_type=>
        ct_rang(decl_tipus);

      when nd_decl_t_cont_record=>
        ct_record(decl_tipus);

      when nd_decl_t_cont_arry=>
        ct_array(decl_tipus);

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>15, columna=>5), "ct_decl_tipus");
        return;
    end case;
  end ct_decl_tipus;


  procedure ct_decl_var(decl_var: in out pnode) is
    id_tipus: id_nom;
    d_tipus: descripcio;
  begin
    id_tipus:= decl_var.dvar_tipus.id_id;
    d_tipus:= get(ts, id_tipus);
    if d_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(decl_var.dvar_tipus.id_pos, id_tipus);
      return;
    end if;
    ct_lid_var(decl_var.dvar_lid, id_tipus);
  end ct_decl_var;


  procedure ct_lid_var(lid_var: in out pnode; idt: in id_nom) is
    id_var: id_nom;
    d_var,desc: descripcio;
    error: boolean;
    t: num_var;
  begin
    if lid_var.lid_seg.tn /= nd_null then
      ct_lid_var(lid_var.lid_seg, idt);
    end if;
    id_var:= lid_var.lid_id.id_id; --L'identificador de la var
    -- GC stuff
    -- BEGIN
    desc:= get(ts, idt);
    -- END
    nova_var(nv, tv, tp, cim(pproc), desc.dt.ocup, t);
    d_var:= (td=>dvar, tv=>idt, nv=> t);
    put(ts, id_var, d_var, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(lid_var.lid_id.id_pos, id_var);
    end if;
  end ct_lid_var;


  procedure ct_decl_const(decl_const: in out pnode) is
    id_tipus: id_nom;
    d_tipus, desc: descripcio;
    id_valor: id_nom;
    v_valor: valor;
    tsb_valor: tipus_subjacent;
    pos_valor: posicio:= (0, 0);
  begin
    id_tipus:= decl_const.dconst_tipus.id_id;
    d_tipus:= get(ts, id_tipus);

    if d_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(decl_const.dconst_tipus.id_pos, id_tipus); 
    end if;

    if d_tipus.dt.tsb > tsb_ent then
      ERROR:= true;
      missatges_operacio_amb_escalar(decl_const.dconst_tipus.id_pos);
      return;
    end if;

    ct_valor(decl_const.dconst_valor, id_valor, tsb_valor, v_valor, pos_valor);
    if ERROR then return; end if;
    if id_valor = null_id and then tsb_valor /= d_tipus.dt.tsb then
      ERROR:= true;
      missatges_tipus_incosistent_lit(pos_valor, id_tipus, tsb_valor);
      return;
    end if;

    if id_valor /= null_id and then id_valor /= id_tipus then
      ERROR:= true;
      missatges_tipus_incosistent_id(pos_valor, id_tipus, id_valor);
      return;
    end if;

    if v_valor < d_tipus.dt.linf or v_valor > d_tipus.dt.lsup then
      ERROR:= true;
      missatges_valor_fora_rang(pos_valor, id_tipus);
    end if;

    desc:= (td=>dconst, tc=>id_tipus, vc=>v_valor);
    ct_lid_const(lid_const=>decl_const.dconst_lid, desc=> desc);
  end ct_decl_const;


  procedure ct_lid_const(lid_const: in out pnode; desc: in descripcio) is
    id_const: id_nom;
    error: boolean;
  begin
    if lid_const.lid_seg.tn /= nd_null then
      ct_lid_const(lid_const.lid_seg, desc);
    end if;
    id_const:= lid_const.lid_id.id_id;
    put(ts, id_const, desc, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(lid_const.lid_id.id_pos, id_const);
    end if;
  end ct_lid_const;


  procedure ct_rang(decl_rang: in out pnode) is
    id_tipus, id_rang: id_nom;
    desc_tipus: descripcio;

    id_valor1, id_valor2: id_nom;
    v_valor1, v_valor2: valor;
    tsb_valor1, tsb_valor2: tipus_subjacent;
    pos_valor1, pos_valor2: posicio:= (0, 0);

    desc:descripcio;
    nd_rang: pnode;
    error: boolean;
  begin
    nd_rang:= decl_rang.dt_cont.dtcont_rang;
    id_rang:= decl_rang.dt_id.id_id;
    id_tipus:= nd_rang.rang_id;
    desc_tipus:= get(ts, id_tipus);

    if desc_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(decl_rang.dt_id.id_pos, id_tipus);
    end if;

    if desc_tipus.dt.tsb > tsb_ent then
      ERROR:= true;
      missatges_operacio_amb_escalar(nd_rang.rang_pos);
      return;
    end if;

    ct_valor(nd_rang.rang_linf, id_valor1, tsb_valor1, v_valor1, pos_valor1);
    if ERROR then return; end if;
    if id_valor1 = null_id and then tsb_valor1 /= desc_tipus.dt.tsb then
      ERROR:= true;
      missatges_tipus_incosistent_lit(pos_valor1, id_tipus, tsb_valor1);
    end if;

    if id_valor1 /= null_id and then id_valor1 /= id_tipus then
      ERROR:= true;
      missatges_tipus_incosistent_id(pos_valor1, id_tipus, id_valor1);
      return;
    end if;

    ct_valor(nd_rang.rang_lsup, id_valor2, tsb_valor2, v_valor2, pos_valor2);
    if id_valor2 = null_id and then tsb_valor2 /= desc_tipus.dt.tsb then
      ERROR:= true;
      missatges_tipus_incosistent_lit(pos_valor2, id_tipus, tsb_valor2);
      return;
    end if;

    if id_valor2 /= null_id and then id_valor2 /= id_tipus then
      ERROR:= true;
      missatges_tipus_incosistent_id(pos_valor2, id_tipus, id_valor2);
    end if;

    if v_valor1 > v_valor2 then
      ERROR:= true;
      missatges_rang_incorrecte(pos_valor1);
    end if;

    if v_valor1 < desc_tipus.dt.linf then
      ERROR:= true;
      missatges_valor_fora_rang(pos_valor1, id_tipus);
    end if;

    if v_valor2 > desc_tipus.dt.lsup then
      ERROR:= true;
      missatges_valor_fora_rang(pos_valor2, id_tipus);
    end if;

    case desc_tipus.dt.tsb is

      when tsb_ent =>
        desc:= (td=>dtipus,
        dt=>(tsb=> tsb_ent, ocup=> desc_tipus.dt.ocup, linf=>v_valor1, lsup=>v_valor2));

      when tsb_car =>
        desc:= (td=>dtipus,
        dt=>(tsb=> tsb_car, ocup=> desc_tipus.dt.ocup, linf=>v_valor1, lsup=>v_valor2));

      when tsb_bool =>
        desc:= (td=>dtipus,
        dt=>(tsb=> tsb_bool, ocup=> desc_tipus.dt.ocup, linf=>v_valor1, lsup=>v_valor2));

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>85, columna=>5), "ct_rang");
    end case;

    put(ts, id_rang, desc, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(decl_rang.dt_id.id_pos, id_rang);
    end if;
  end ct_rang;


  procedure ct_valor(nd_idx: in out pnode; id_tipus: out id_nom; tsb: out decls.d_descripcio.tipus_subjacent; v: out valor; pos: in out posicio) is
    desc, d_tipus: descripcio;
    p: pnode;
  begin
    p:= nd_idx.idx_cont.idxc_valor;
    case p.tn is
      when nd_id =>
        desc:= get(ts, p.id_id);
        if desc.td /= dconst then
          ERROR:= true;
          missatges_assignacio_incorrecta(p.id_pos);
          return; 
        end if;
        d_tipus:= get(ts, desc.tc);

        if nd_idx.idx_tipus = negatiu then
          if d_tipus.dt.tsb /= tsb_ent then
            ERROR:= true;
            missatges_operador_tipus(p.id_pos, d_tipus.dt.tsb, neg_alg);
          end if;

          v:= -desc.vc;
        else
          v:= desc.vc;
        end if;

        id_tipus:= desc.tc;
        tsb:= d_tipus.dt.tsb;
        pos:= p.id_pos;

      when nd_lit =>
        id_tipus:= null_id;
        tsb:= p.lit_tipus;
        if nd_idx.idx_tipus = negatiu then
          if tsb /= tsb_ent then
            ERROR:= true;
            missatges_operador_tipus(p.lit_pos, tsb, neg_alg);
          end if;
          v:= -p.lit_val;
        else
          v:= p.lit_val;
        end if;
        pos:= p.lit_pos;

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>46, columna=>5), "ct_valor");
    end case;

  end ct_valor;


  --RECORD: Primer s'afegeix el record a la ts comprovant que no hi existia, despres s'afegeixen els camps:
  --Per a cada camp es comprova que es un tipus i s'afegeixen un per un els ids de la lid
  procedure ct_record(nd_record: in out pnode) is
    desc_record: descripcio;
    id_record: id_nom;
    error: boolean;
    desp: despl:= 0; --El desplacament dels camps
  begin
    id_record:= nd_record.dt_id.id_id;
    desc_record:= (td=>dtipus, dt=>(tsb=> tsb_rec, ocup=> 0));
    put(ts, id_record, desc_record, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(nd_record.dt_id.id_pos, id_record);
      return;
    end if;

    --processament de camps
    ct_dcamps(nd_record.dt_cont.dtcont_camps, id_record, desp);
    --Actualitzacio de l'ocupacio del record
    desc_record:= (td=>dtipus, dt=>(tsb=> tsb_rec, ocup=> desp));
    update(ts, id_record, desc_record);
  end ct_record;


  procedure ct_dcamps(nd_dcamps: in out pnode;idr: in id_nom;desp: in out despl) is
  begin
    if nd_dcamps.dcamps_dcamps.tn /= nd_null then
      ct_dcamps(nd_dcamps.dcamps_dcamps, idr, desp);
    end if;
    ct_dcamp(nd_dcamps.dcamps_dcamp, idr, desp);
  end ct_dcamps;


  procedure ct_dcamp(nd_dcamp: in out pnode;idr: in id_nom;desp: in out despl) is
    id_tipus: id_nom;
    desc_tipus: descripcio;
  begin
    id_tipus:= nd_dcamp.dcamp_decl.dvar_tipus.id_id;
    desc_tipus:= get(ts, id_tipus);

    if desc_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(nd_dcamp.dcamp_decl.dvar_tipus.id_pos, id_tipus);
      return;
    end if;

    ct_dcamp_lid(nd_dcamp.dcamp_decl.dvar_lid, id_tipus, idr, desp, desc_tipus.dt.ocup);
  end ct_dcamp;


  procedure ct_dcamp_lid(nd_lid: in out pnode; idt, idr: in id_nom; desp: in out despl;ocup: in despl) is
    id_camp: id_nom;
    desc_camp: descripcio;
    error: boolean;
  begin
    if nd_lid.lid_seg.tn /= nd_null then
      ct_dcamp_lid(nd_lid.lid_seg, idt, idr, desp, ocup);
    end if;
    id_camp:= nd_lid.lid_id.id_id;
    desc_camp:= (td=>dcamp, tcmp=>idt, dcmp=>desp);
    put_camp(ts, idr, id_camp, desc_camp, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(nd_lid.lid_id.id_pos, id_camp);
    end if;
    desp:= desp+ocup;
  end ct_dcamp_lid;


  --ARRAY
  procedure ct_array(nd_array: in out pnode) is
    id_array: id_nom;
    desc_array: descripcio;
    id_tipus: id_nom;
    desc_tipus:descripcio;
    num_components: valor:= 0;
    ocup: despl;
    error: boolean;
    ib: valor:= 0;
  begin
    id_array:= nd_array.dt_id.id_id;
    id_tipus:= nd_array.dt_cont.dtcont_tipus.id_id;
    desc_array:= (td=>dtipus, dt=> (tsb=>tsb_arr, ocup=>0, tcomp=>id_tipus, b=>0));
    put(ts, id_array, desc_array, error);

    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(nd_array.dt_id.id_pos, id_array);
      return;
    end if;

    ct_array_idx(nd_array.dt_cont.dtcont_idx, id_array, num_components, ib);

    desc_tipus:= get(ts, id_tipus);
    if desc_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(nd_array.dt_cont.dtcont_tipus.id_pos, id_tipus);
      return;
    end if;

    ocup:= despl(num_components)*desc_tipus.dt.ocup;
    desc_array:= (td=>dtipus, dt=> (tsb=>tsb_arr, ocup=>ocup, tcomp=>id_tipus, b=>ib));
    update(ts, id_array, desc_array);
  end ct_array;


  procedure ct_array_idx(nd_lidx: in out pnode;id_array: in id_nom; num_comp: in out valor; b: in out valor) is
    desc_rang, desc_idx:descripcio;
    id_rang: id_nom;
    lnc,linf: valor;
  begin
    if nd_lidx.lid_seg.tn /= nd_null then
      ct_array_idx(nd_lidx.lid_seg, id_array, num_comp, b);
    end if;

    id_rang:= nd_lidx.lid_id.id_id;
    desc_rang:= get(ts, id_rang);

    if desc_rang.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(nd_lidx.lid_id.id_pos, id_rang);
      return;
    end if;

    if desc_rang.dt.tsb > tsb_ent then
      ERROR:= true;
      missatges_operacio_amb_escalar(nd_lidx.lid_id.id_pos);
      return;
    end if;

    linf:= desc_rang.dt.linf;
    lnc:= desc_rang.dt.lsup - linf + 1;
    b:= b * lnc + linf;

    desc_idx:= (td=>dindx, tind=>id_rang);
    put_index(ts, id_array, desc_idx);
    if num_comp = 0 then
      num_comp:= lnc;
    else
      num_comp:= num_comp * (lnc);
    end if;
  end ct_array_idx;


  procedure ct_decl_proc(nd_procediment: in out pnode) is
    id_proc, id_arg: id_nom;
    desc_proc,desc_arg: descripcio;
    error:boolean;
    it: iterador_arg;
    nargs: natural:= 0;
    despl_args: despl;
    t: num_var;
    p: num_proc;
    e: num_etiq;
  begin
    id_proc:= nd_procediment.proc_cproc.cproc_id.id_id;
    nova_etiq(ne, e);
    -- 0 params i 0 ocupacio temporals
    nou_proc(np, tp, e, get_prof(ts), 0, p);
    desc_proc:= (td=>dproc, np=> p);
    put(ts, id_proc, desc_proc, error);
    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(nd_procediment.proc_cproc.cproc_id.id_pos, id_proc);
      return;
    end if;

    if nd_procediment.proc_cproc.cproc_args.tn /= nd_null then
      ct_decl_args(nd_procediment.proc_cproc.cproc_args, id_proc, nargs);
    end if;

    -- Per simplificar la GC
    nd_procediment.proc_cproc.cproc_np:= desc_proc.np;
    empila(pproc, desc_proc.np);

    enter_block(ts);
    -- el desplaçament del primer argument es bp + antic Disp + @RTN
    -- + ocup_ent * nargs (això es degut a que l'operació pushl no 
    -- funciona exactament com un podria esperar)
    despl_args:= 3 * ocup_ent + ocup_ent * despl(nargs);
    first(ts, id_proc, it);
    while is_valid(it) loop
      -- ho feim aixi perque el càlcul anterior, deixa el punter a 4 posicions mes enllà
      -- d'on caldria
      despl_args:= despl_args - ocup_ent;
      nou_arg(nv, tv, tp, cim(pproc), despl_args, t);
      get(ts, it, id_arg, desc_arg);
      if desc_arg.td = dvar then
        desc_arg.nv:= t;
      else
        desc_arg.na:= t;
      end if;
      put(ts, id_arg, desc_arg, error);
      next(ts, it);
    end loop;
    -- tot i que aixo pot anar abans del desempila(pproc) aixi sembla mes adecuat
    act_proc_args(tp, cim(pproc), nargs);

    if nd_procediment.proc_decls.tn /= nd_null then
      ct_decls(nd_procediment.proc_decls);
    end if;
    if nd_procediment.proc_sents.tn /= nd_null then
      ct_sents(nd_procediment.proc_sents);
    end if;
    exit_block(ts);

    desempila(pproc);
  end ct_decl_proc;


  procedure ct_decl_args(nd_args: in out pnode;id_proc: in id_nom; nargs: in out natural) is
    id_tipus: id_nom;
    desc_tipus: descripcio;

  begin
    if nd_args.args_args.tn /= nd_null then
      ct_decl_args(nd_args.args_args, id_proc, nargs);
    end if;

    id_tipus:= nd_args.args_arg.arg_tipus.id_id;
    desc_tipus:= get(ts, id_tipus);
    if desc_tipus.td /= dtipus then
      ERROR:= true;
      missatges_desc_no_es_tipus(nd_args.args_arg.arg_tipus.id_pos, id_tipus);
    end if;

    ct_decl_arg(nd_args.args_arg.arg_lid, id_proc, id_tipus, nd_args.args_arg.arg_mode, nargs);
  end ct_decl_args;


  procedure ct_decl_arg(nd_lid_arg: in out pnode; id_proc, id_tipus: in id_nom; mode: in tmode; nargs: in out natural) is
    id_arg: id_nom;
    desc_arg,desc: descripcio;
    error: boolean;
  begin
    if nd_lid_arg.lid_seg.tn /= nd_null then
      ct_decl_arg(nd_lid_arg.lid_seg, id_proc, id_tipus, mode, nargs);
    end if;

    nargs:= nargs + 1;

    -- GC stuff
    -- BEGIN
    desc:= get(ts, id_tipus);
    -- END
    case mode is
      when md_in_out => desc_arg:= (td=>dvar, tv=>id_tipus, nv=>null_nv);
      when md_in => desc_arg:= (td=>dargc, ta=>id_tipus, na=> null_nv);
    end case;
    if DEBUG then
      missatges_ct_debugging("ct_decl_arg",tmode'Image(mode)&"::"
      &tipus_descr'Image(desc_arg.td)&"::"
      &id_nom'Image(id_tipus));
    end if;
    id_arg:= nd_lid_arg.lid_id.id_id;
    put_arg(ts, id_proc, id_arg, desc_arg, error);

    if error then
      ERROR:= true;
      missatges_conflictes_declaracio(nd_lid_arg.lid_id.id_pos, id_arg);
    end if;
  end ct_decl_arg;


  --Sentencias

  procedure ct_sents(nd_sents: in out pnode) is
  begin
    if nd_sents.sents_cont.tn = nd_sents_nob then
      ct_sents_nob(nd_sents.sents_cont);
    elsif nd_sents.sents_cont.tn /= nd_null then
      ERROR:= true;
      missatges_sent_buida;
    end if;
  end ct_sents;

  procedure ct_sents_nob(nd_sents_nob: in out pnode) is
  begin
    if nd_sents_nob.snb_snb.tn /= nd_null then
      ct_sents_nob(nd_sents_nob.snb_snb);
    end if;
    if DEBUG then
      missatges_ct_debugging("ct_sent_assign",tnode'Image(nd_sents_nob.snb_sent.sent_sent.tn));
    end if;
    case nd_sents_nob.snb_sent.sent_sent.tn is
      when nd_siter=>
        ct_sent_iter(nd_sents_nob.snb_sent.sent_sent);
      when nd_scond=>
        ct_sent_cond(nd_sents_nob.snb_sent.sent_sent);
      when nd_scrida=>
        ct_sent_crida(nd_sents_nob.snb_sent.sent_sent);
      when nd_sassign=>
        ct_sent_assign(nd_sents_nob.snb_sent.sent_sent);
      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>19, columna=>16), "ct_sents_nob");
    end case;
  end ct_sents_nob;


  procedure ct_sent_iter(nd_sent: in out pnode) is
    id_texpr: id_nom;
    tsb_expr: tipus_subjacent;
    expr_esvar: boolean;
    pos_exp: posicio:= (0, 0);
  begin
    ct_expr(nd_sent.siter_expr, id_texpr, tsb_expr, expr_esvar, pos_exp);
    if tsb_expr /= tsb_bool then
      ERROR:= true;
      missatges_cond_bool(pos_exp, tsb_expr);
    end if;

    if nd_sent.siter_sents.tn /= nd_sents and nd_sent.siter_sents.tn /= nd_null then
      ERROR:= true;
      missatges_sent_buida;
    end if;

    if nd_sent.siter_sents.tn = nd_sents then
      ct_sents(nd_sent.siter_sents);
    end if;

  end ct_sent_iter;


  procedure ct_sent_cond(nd_sent: in out pnode) is
    id_texpr: id_nom;
    tsb_expr: tipus_subjacent;
    expr_esvar: boolean;
    pos_exp: posicio:= (0, 0);
  begin
    ct_expr(nd_sent.scond_expr, id_texpr, tsb_expr, expr_esvar, pos_exp);
    if tsb_expr /= tsb_bool then
      ERROR:= true;
      missatges_cond_bool(pos_exp, tsb_expr);
    end if;

    if nd_sent.scond_sents.tn /= nd_sents and nd_sent.scond_sents.tn /= nd_null then
      ERROR:= true;
      missatges_sent_buida;
    end if;
    if nd_sent.scond_sents.tn = nd_sents then
      ct_sents(nd_sent.scond_sents);
    end if;

    if nd_sent.scond_esents.tn /= nd_null then
      if nd_sent.scond_esents.tn /= nd_sents and nd_sent.scond_esents.tn /= nd_null then
        ERROR:= true;
        missatges_sent_buida;
      end if;
    end if;

    if nd_sent.scond_esents.tn = nd_sents then
      ct_sents(nd_sent.scond_esents);
    end if;
  end ct_sent_cond;


  procedure ct_sent_crida(nd_sent: in out pnode) is
    id_base, id_tipus: id_nom;
    desc_ref: descripcio;
    pos_ref: posicio:= (0, 0);
  begin
    ct_ref(nd_sent.scrida_ref, id_base, id_tipus, pos_ref);
    if ERROR then return; end if;
    desc_ref:= get(ts, id_base);
    if desc_ref.td /= dproc then
      missatges_no_proc(pos_ref);
      ERROR:=true;
      return;
    end if;
  end ct_sent_crida;


  procedure ct_sent_assign(nd_sent: in out pnode) is
    id_ref, id_tipus_ref, id_texpr: id_nom;
    desc_ref, desc_tipus_ref: descripcio;
    tsb_expr: tipus_subjacent;
    expr_esvar: boolean;
    pos_ref, pos_exp: posicio:= (0, 0);
  begin
    ct_ref(nd_sent.sassign_ref, id_ref, id_tipus_ref, pos_ref);
    if DEBUG then
      missatges_ct_debugging("ct_sent_assign",tnode'Image(nd_sent.sassign_ref.ref_id.tn));
    end if;
    desc_ref:= get(ts, id_ref);
    if desc_ref.td /= dvar then
      ERROR:= true;
      missatges_assignacio_incorrecta(pos_ref);
      return;
    end if;

    ct_expr(nd_sent.sassign_expr, id_texpr, tsb_expr, expr_esvar, pos_exp);

    if id_texpr /= null_id then
      --Comprovar que la referencia i l'expressio tenen el mateix tipus
      if id_tipus_ref /= id_texpr then
        ERROR:= true;
        missatges_tipus_incosistent_id(pos_exp, id_tipus_ref, id_texpr);
      end if;
    else
      desc_tipus_ref:= get(ts, id_tipus_ref);
      if desc_tipus_ref.dt.tsb /= tsb_expr then
        ERROR:= true;
        missatges_tipus_incosistent_lit(pos_exp, id_tipus_ref, tsb_expr);
      end if;
    end if;

    if tsb_expr > tsb_ent then
      ERROR:= true;
      missatges_operacio_amb_escalar(pos_exp);
    end if;
  end ct_sent_assign;


  procedure ct_ref(nd_ref: in out pnode; id_base: out id_nom; id_tipus: out id_nom; pos: in out posicio) is
    it: iterador_arg;
    desc_ref, desc_ref_aux: descripcio;
    p: pnode;
  begin
    id_base:= nd_ref.ref_id.id_id;
    pos:= nd_ref.ref_id.id_pos;
    desc_ref:= get(ts, id_base);
    case desc_ref.td is
      when dargc=>
        if nd_ref.ref_qs.tn /= nd_null then
          ct_qs(nd_ref.ref_qs, id_base, desc_ref.ta, pos);
        end if;
        id_tipus:= desc_ref.ta;
        desc_ref_aux:= desc_ref;

        desc_ref:= get(ts, desc_ref.ta);
        if desc_ref.td /= dtipus then
          ERROR:= true;
          missatges_ct_error_intern((fila=>19, columna=>20), "ct_ref::una cosa que ha pasat el test com a tipus, ara ja no ho es");
          return;
        end if;

        if desc_ref.dt.tsb > tsb_ent then
          ERROR:= true;
          missatges_ct_error_intern((fila=>25, columna=>20), "ct_ref::una cosa que ha pasat el test de constant, ara ja no ho es");
          return;
        end if;

        if not ERROR then
          p:= new node(nd_var);
          p.var_nv:= desc_ref_aux.na;
          p.var_ocup:= desc_ref.dt.ocup;
        end if;

      when dvar=>
        if nd_ref.ref_qs.tn /= nd_null then
          ct_qs(nd_ref.ref_qs, id_base, desc_ref.tv, pos);
        end if;
        id_tipus:= desc_ref.tv;

        -- Per simplificar la GC
        if not ERROR then
          p:= new node(nd_var);
          p.var_nv:= desc_ref.nv;
          desc_ref_aux:= get(ts, desc_ref.tv);
          p.var_ocup:= desc_ref_aux.dt.ocup;
        end if;

      when dconst=>
        if nd_ref.ref_qs.tn /= nd_null then
          ct_qs(nd_ref.ref_qs, id_base, desc_ref.tc, pos);
        end if;
        id_tipus:= desc_ref.tc;
        desc_ref_aux:= desc_ref;

        desc_ref:= get(ts, desc_ref.tc);
        if desc_ref.td /= dtipus then
          ERROR:= true;
          missatges_ct_error_intern((fila=>59, columna=>20), "ct_ref::una cosa que ha pasat el test com a tipus, ara ja no ho es");
          return;
        end if;

        if desc_ref.dt.tsb > tsb_ent then
          ERROR:= true;
          missatges_ct_error_intern((fila=>65, columna=>20), "ct_ref::una cosa que ha pasat el test de constant, ara ja no ho es");
          return;
        end if;

        -- Per simplificar la GC
        -- Si discriminam constants i variables a la TV no caldra discriminar entre nd_var i nd_const. Com que ho farem a la
        -- proxima etapa, ja no ens escarrassam massa
        if not ERROR then
          if DEBUG then
            missatges_ct_debugging("ct_ref",tipus_descr'Image(desc_ref_aux.td));
          end if;
          p:= new node(nd_var);
          nova_var_const(nv, tv, desc_ref_aux.vc, desc_ref.dt.tsb, p.var_nv);
          p.var_ocup:= desc_ref.dt.ocup;
          if DEBUG then
            missatges_ct_debugging("ct_ref","invc:"&num_var'Image(p.var_nv));
          end if;
        end if;

      when dproc =>
        --Comprovam si el procediment te arguments
        first(ts, id_base, it);
        if is_valid(it) then
          if nd_ref.ref_qs.tn = nd_null then
            ERROR:= true;
            missatges_menys_arguments_proc(pos, id_base);
            return;
          end if;
          ct_qs_proc(nd_ref.ref_qs, id_base, pos);
        else
          if nd_ref.ref_qs.tn /= nd_null then
            ERROR:= true;
            missatges_massa_arguments_proc(pos, id_base);
            return;
          end if;
        end if;
        id_tipus:= null_id;

        -- Per simplificar la GC
        if not ERROR then
          p:= new node(nd_iproc);
          p.iproc_np:= desc_ref.np;
        end if;



      when others=>
        if DEBUG then
          missatges_ct_debugging("ct_ref",tipus_descr'Image(desc_ref.td));
        end if;
        ERROR:= true;
        missatges_no_definida(pos, id_base);
    end case;

    -- Per simplificar la GC
    if not ERROR then
      nd_ref.ref_id:= p;
      if DEBUG then
        missatges_ct_debugging("ct_ref",tnode'Image(p.tn));
      end if;
    end if;

  end ct_ref;


  procedure ct_qs_proc(nd_qs: in out pnode; id_base: in id_nom; pos: in out posicio) is
    it: iterador_arg;
  begin
    if nd_qs.qs_qs.tn /= nd_null then
      ERROR:= true;
      missatges_proc_mult_parentesis(pos);
    end if;

    first(ts, id_base, it);
    ct_lexpr_proc(nd_qs.qs_q.q_contingut, id_base, it, pos);
    if is_valid(it) then
      ERROR:= true;
      missatges_menys_arguments_proc(pos, id_base);
      return;
    end if;

  end ct_qs_proc;


  procedure ct_lexpr_proc(nd_lexpr: in out pnode; id_base: in id_nom;it: in out iterador_arg; pos: in out posicio) is
    desc_arg, desc_tipus_arg: descripcio;
    tsb_expr: tipus_subjacent;
    id_texpr, id_arg, id_tipus_arg: id_nom;
    esvar: boolean;
  begin
    if nd_lexpr.lexpr_cont.tn /= nd_null then
      ct_lexpr_proc(nd_lexpr.lexpr_cont, id_base, it, pos);
    end if;

    ct_expr(nd_lexpr.lexpr_expr, id_texpr, tsb_expr, esvar, pos);
    if not is_valid(it) then
      ERROR:=true;
      missatges_massa_arguments_proc(pos, id_base);
      return;
    end if;

    get(ts, it, id_arg, desc_arg);
    case desc_arg.td is
      when dvar =>
        if not esvar then
          ERROR:= true;
          missatges_arg_mode(pos, id_arg);
        end if;
        id_tipus_arg:= desc_arg.tv;

      when dargc =>
        id_tipus_arg:= desc_arg.ta;

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>31, columna=>20), "ct_lexpr_proc");
        return;
    end case;

     if id_texpr = null_id then
      if id_tipus_arg /= null_id then
        desc_tipus_arg:= get(ts, id_tipus_arg);
        if desc_tipus_arg.dt.tsb /= tsb_expr then
          ERROR:= true;
          missatges_tipus_incosistent_lit(pos, id_tipus_arg, tsb_expr);
        end if;
      else
        if tsb_expr /= tsb_nul then
          ERROR:=true;
          missatges_tipus_incosistent_lit(pos, id_tipus_arg, tsb_expr);
        end if;
      end if;
    else
      if id_tipus_arg /= id_texpr then
        ERROR:= true;
        missatges_tipus_incosistent_id(pos, id_tipus_arg, id_texpr);
      end if;
    end if;

    next(ts, it);

  end ct_lexpr_proc;


  procedure ct_qs(nd_qs: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; pos: in out posicio) is
  begin
      if nd_qs.qs_qs.tn /= nd_null then
        ct_qs(nd_qs.qs_qs, id_base, id_tipus, pos);
      end if;

      ct_q(nd_qs.qs_q, id_base, id_tipus, pos);
  end ct_qs;


  procedure ct_q(nd_q: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; pos: in out posicio) is
    desc_tipus, desc_camp: descripcio;
    id_camp: id_nom;
    it: iterador_index;
    p: pnode;
  begin
    desc_tipus:= get(ts, id_tipus);

    case nd_q.q_contingut.tn is
      when nd_id => --R.id
        if desc_tipus.dt.tsb /= tsb_rec then
          ERROR:= true;
          missatges_no_record(pos, id_tipus);
          return;
        end if;

        pos:= nd_q.q_contingut.id_pos;
        id_camp:= nd_q.q_contingut.id_id;
        desc_camp:= get_camp(ts, id_tipus, id_camp);
        if desc_camp.td /= dcamp then
          ERROR:= true;
          missatges_camp_no_record(pos, id_tipus, id_camp);
          return;
        end if;
        id_tipus:= desc_camp.tcmp;

        -- Per simplificar la GC
        if not ERROR then
          p:= new node(nd_rec);
          nova_var_const(nv, tv, valor(desc_camp.dcmp), tsb_ent, p.rec_td);
          if DEBUG then
            missatges_ct_debugging("ct_q","invc:"&num_var'Image(p.rec_td));
          end if;
        end if;

      when nd_lexpr => --R(E)
        if desc_tipus.dt.tsb /= tsb_arr then
          ERROR:= true;
          missatges_no_array(pos, id_tipus);
          return;
        end if;
        first(ts, id_tipus, it);
        ct_lexpr_array(nd_q.q_contingut, id_base, id_tipus, it, pos);

        if is_valid(it) then
          missatges_menys_indexos_array(pos, id_tipus);
        end if;
        id_tipus:= desc_tipus.dt.tcomp;

        -- Per simplificar la GC
        if not ERROR then
          p:= new node(nd_arry);
          p.arry_lexpr:= nd_q.q_contingut; -- a ct_lexpr_array haurem anat penjant els nodes modificats.
          nova_var_const(nv, tv, valor(desc_tipus.dt.b), tsb_ent, p.arry_tb);
          if DEBUG then
            missatges_ct_debugging("ct_q","invc:"&num_var'Image(p.arry_tb));
          end if;
          desc_tipus:= get(ts,desc_tipus.dt.tcomp);
          nova_var_const(nv, tv, valor(desc_tipus.dt.ocup), tsb_ent, p.arry_tw);
          if DEBUG then
            missatges_ct_debugging("ct_q","invc:"&num_var'Image(p.arry_tw));
          end if;
        end if;

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=> 66, columna=>20), "ct_q");
    end case;

    -- Per simplificar la GC (& ens carregam el node pont q_contingut)
    if not ERROR then
      nd_q:= p;
      if DEBUG then
        missatges_ct_debugging("ct_q",tnode'Image(nd_q.tn));
      end if;
    end if;

  end ct_q;


  procedure ct_lexpr_array(nd_lexpr: in out pnode; id_base: in id_nom; id_tipus: in out id_nom; it: in out iterador_index; pos: in out posicio) is
    desc_index, desc_tipus_idx: descripcio;
    tsb_expr: tipus_subjacent;
    id_texpr: id_nom;
    esvar: boolean;
    p: pnode;
  begin
    if nd_lexpr.lexpr_cont.tn /= nd_null then
      ct_lexpr_array(nd_lexpr.lexpr_cont, id_base, id_tipus, it, pos);
    end if;

    ct_expr(nd_lexpr.lexpr_expr, id_texpr, tsb_expr, esvar, pos);
    if not is_valid(it) then
      ERROR:= true;
      missatges_massa_indexos_array(pos, id_tipus);
      return;
    end if;

    desc_index:= get(ts, it);
    if id_texpr = null_id then
      desc_tipus_idx:= get(ts, desc_index.tind);
      if desc_tipus_idx.dt.tsb /= tsb_expr then
        ERROR:= true;
        missatges_tipus_incosistent_lit(pos, desc_index.tind, tsb_expr);
      end if;
    else
      if id_texpr /= desc_index.tind then
        ERROR:= true;
        missatges_tipus_incosistent_id(pos, desc_index.tind, id_texpr);
      end if;
    end if;

    next(ts, it);

    -- Per simplificar la GC
    if not ERROR then
      desc_tipus_idx:= get(ts, desc_index.tind); -- mmm WHAT!? a -16 linies teoricament ja feim aixo...
      p:= new node(nd_lexpr_arry);
      p.lexpra_cont:= nd_lexpr.lexpr_cont;
      p.lexpra_expr:= nd_lexpr.lexpr_expr;
      nova_var_const(nv, tv, valor(desc_tipus_idx.dt.lsup - desc_tipus_idx.dt.linf + 1), tsb_ent, p.lexpra_tu);
      if DEBUG then
        missatges_ct_debugging("ct_lexpr_array","invc:"&num_var'Image(p.lexpra_tu));
      end if;

      nd_lexpr:= p;
      if DEBUG then
        missatges_ct_debugging("ct_lexpr_array",tnode'Image(nd_lexpr.tn));
      end if;
    end if;


  end ct_lexpr_array;


  procedure ct_expr(nd_expr: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
  begin
    case nd_expr.expr_e.tn is
      when nd_and | nd_or =>
        ct_e(nd_expr.expr_e, id_texpr, tsb_expr, esvar, pos);

      when nd_eop =>
        ct_eop(nd_expr.expr_e, id_texpr, tsb_expr, esvar, pos);

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>11, columna=>20), "ct_expr");

    end case;
  end ct_expr;


  procedure ct_e(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out  boolean; pos: in out posicio) is
    id_tipus1, id_tipus2: id_nom;
    tsb1, tsb2: tipus_subjacent;
    esvar1, esvar2: boolean;
    pos1, pos2: posicio:= (0, 0);
    error: boolean;
  begin
    if nd_e.e_ope.tn = nd_and or else nd_e.e_ope.tn = nd_or then
      ct_e(nd_e.e_ope, id_tipus1, tsb1, esvar1, pos1);
    else
      ct_eop(nd_e.e_ope, id_tipus1, tsb1, esvar1, pos1);
    end if;
    
    ct_eop(nd_e.e_opd, id_tipus2, tsb2, esvar2, pos2);

    tipus_compatible(id_tipus1, id_tipus2, tsb1, tsb2, id_texpr, tsb_expr, error);
    if error then
      ERROR:= true;
      missatges_expressions_incompatibles(pos1, id_tipus1, id_tipus2, tsb1, tsb2);
    end if;

    if tsb1 /= tsb_bool then
      ERROR:= true;
      missatges_log_operador(pos1, tsb1);
    end if;

    pos:= pos1;
    esvar:= false;
  end ct_e;


  procedure ct_eop(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
  begin
    if DEBUG then
      missatges_ct_debugging("ct_eop",tnode'Image(nd_e.tn)&"::"
      &operand'Image(nd_e.eop_operand)&"::"
      &tnode'Image(nd_e.eop_opd.tn)&"::"
      &tnode'Image(nd_e.eop_ope.tn));
    end if;
  
    case nd_e.eop_operand is
      when major | menor | menorigual | majorigual | igual | diferent  =>
        ct_eop_op_rel(nd_e, id_texpr, tsb_expr, esvar, pos);

      when sum | res | prod | quoci | modul =>
        ct_eop_arit(nd_e, id_texpr, tsb_expr, esvar, pos, nd_e.eop_operand);

      when neg_log =>
        ct_eop_neg_log(nd_e, id_texpr, tsb_expr, esvar, pos);

      when neg_alg =>
        ct_eop_neg_arit(nd_e, id_texpr, tsb_expr, esvar, pos);

      when nul =>
        ct_et(nd_e.eop_opd, id_texpr, tsb_expr, esvar, pos);

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>27, columna=>20), "ct_eop");
    end case;
  end ct_eop;


  procedure ct_eop_op_rel(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
    id_tipus1, id_tipus2: id_nom;
    tsb1, tsb2: tipus_subjacent;
    esvar1, esvar2: boolean;
    pos1, pos2: posicio:= (0, 0);
    error: boolean;
  begin
    ct_eop(nd_e.eop_ope, id_tipus1, tsb1, esvar1, pos1);
    ct_eop(nd_e.eop_opd, id_tipus2, tsb2, esvar2, pos2);

    tipus_compatible(id_tipus1, id_tipus2, tsb1, tsb2, id_texpr, tsb_expr, error);

    if tsb1 > tsb_ent then
      ERROR:= true;
      missatges_operador_tipus(pos1, tsb1, nd_e.eop_operand);
    end if;

    pos:= pos1;
    id_texpr:= null_id;
    tsb_expr:= tsb_bool;
    esvar:= false;
  end ct_eop_op_rel;


  procedure ct_eop_arit(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio; op: in operand ) is
    id_tipus1, id_tipus2: id_nom;
    tsb1, tsb2: tipus_subjacent;
    esvar1, esvar2: boolean;
    pos1, pos2: posicio:= (0, 0);
    error: boolean;
  begin
    
    ct_eop(nd_e.eop_ope, id_tipus1, tsb1, esvar1, pos1);
    ct_eop(nd_e.eop_opd, id_tipus2, tsb2, esvar2, pos2);
    tipus_compatible(id_tipus1, id_tipus2, tsb1, tsb2, id_texpr, tsb_expr, error);
    if error then
      ERROR:= true;
      missatges_expressions_incompatibles(pos1, id_tipus1, id_tipus2,tsb1, tsb2);
    end if;

    if tsb1 /= tsb_ent then
      ERROR:= true;
      missatges_operador_tipus(pos1, tsb1, op);
    end if;

    pos:= pos1;
    esvar:= false;
  end ct_eop_arit;


  procedure ct_eop_neg_log(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
    id_tipus: id_nom;
    tsb: tipus_subjacent;
    esvar1: boolean;
  begin
    ct_et(nd_e.eop_opd, id_tipus, tsb, esvar1, pos);
    if tsb /= tsb_bool then
      ERROR:= true;
      missatges_operador_tipus(pos, tsb, neg_log);
    end if;
    id_texpr:= id_tipus;
    tsb_expr:= tsb;
    esvar:= false;
  end ct_eop_neg_log;


  procedure ct_eop_neg_arit(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
    id_tipus: id_nom;
    tsb: tipus_subjacent;
    esvar1: boolean;
  begin
    ct_et(nd_e.eop_opd, id_tipus, tsb, esvar1, pos);
    if tsb /= tsb_ent then
      ERROR:= true;
      missatges_operador_tipus(pos, tsb, neg_alg);
    end if;
    id_texpr:= id_tipus;
    tsb_expr:= tsb;
    esvar:= false;
  end ct_eop_neg_arit;


  procedure ct_et(nd_e: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out  boolean; pos: in out posicio) is
  begin
    if DEBUG then
      missatges_ct_debugging("ct_et",tnode'Image(nd_e.tn));
      missatges_ct_debugging("ct_et",tnode'Image(nd_e.et_cont.tn));
    end if;
    case nd_e.et_cont.tn is
      when nd_ref =>
        ct_et_ref(nd_e.et_cont, id_texpr, tsb_expr, esvar, pos);

      when nd_expr =>
        ct_expr(nd_e.et_cont, id_texpr, tsb_expr, esvar, pos);

      when nd_lit =>
        ct_et_lit(nd_e.et_cont, id_texpr, tsb_expr, esvar, pos);

      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>18, columna=>16), "ct_et");
    end case;
  end ct_et;


  procedure ct_et_ref(nd_ref: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
    id_ref, id_tipus_ref: id_nom;
    desc_ref, desc_tipus_ref: descripcio;
  begin
    ct_ref(nd_ref, id_ref, id_tipus_ref, pos);

    id_texpr:= id_tipus_ref;

    desc_tipus_ref:= get(ts, id_tipus_ref);
    tsb_expr:= desc_tipus_ref.dt.tsb;

    desc_ref:= get(ts, id_ref);
    case desc_ref.td is
      when dvar => esvar:= true;
      when dconst => esvar:= false;
      when dargc => esvar:= false;
      when others =>
        ERROR:= true;
        missatges_ct_error_intern((fila=>18, columna=>16), "ct_et_ref");
    end case;
  end ct_et_ref;


  procedure ct_et_lit(nd_lit: in out pnode; id_texpr: out id_nom; tsb_expr: out tipus_subjacent; esvar: out boolean; pos: in out posicio) is
  begin
    id_texpr:= null_id;
    pos:= nd_lit.lit_pos;
    tsb_expr:= nd_lit.lit_tipus;
    esvar:= false;
  end ct_et_lit;


  procedure tipus_compatible(id_tipus1, id_tipus2: in id_nom; tsb1, tsb2: in tipus_subjacent;
    id_texp: out id_nom; tsb_exp: out tipus_subjacent; error: out boolean) is
  begin
    error:=false;
    if id_tipus1 = null_id and id_tipus2 = null_id then
      if tsb1 /= tsb2 then error:= true; end if;
      id_texp:= null_id; tsb_exp:= tsb1;

    elsif id_tipus1 /= null_id and id_tipus2 = null_id then
      if tsb1 /= tsb2 then error:= true; end if;
      id_texp:= id_tipus1; tsb_exp:= tsb1;

    elsif id_tipus1 = null_id and id_tipus2 /= null_id then
      if tsb1 /= tsb2 then error:= true; end if;
      id_texp:= id_tipus2; tsb_exp:= tsb2;

    elsif id_tipus1 /= null_id and id_tipus2 /= null_id then
      if tsb1 /= tsb2 then error:= true; end if;
      id_texp:= id_tipus1; tsb_exp:= tsb1;

    end if;
  end tipus_compatible;

end semantica.c_tipus;
