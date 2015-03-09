
package body semantica.c_arbre is

	--Rutines semàntiques auxiliars 

  procedure putvar(list_id: in atribut; id_type: in id_nom) is
      desc: descripcio;
      p,ps: pnode;
      error: boolean;
  begin
      p:= list_id.lid_id;
      ps:= list_id.lid_seg;
      desc:= (td => dvar, tv => id_type, nv => nova_var);
      put(ts,p.id_id,desc,error);
      if error then raise var_error; end if;

      if ps/=null then
          putvar(ps,id_type);
      end if;
  end putvar;


  procedure putcamps(camps: in atribut; idr: in id_nom) is
      desc: descripcio;
      p, ps: pnode;
      error: boolean;
  begin
     -- El zero es temporal <<<< ALERTA
     desc:= (td => dcamp, tcmp => p.dcamp_decl.dvar_tipus.id_id, dcmp => 0);
     
     --Posar tots el camps que estan en la mateixa
     --llista de variables (LID)
     p:=camps.dcamps_dcamp.dcamp_decl.dvar_lid;
     while p/=null loop
         put_camp(ts,idr,p.lid_id.id_id,desc,error);
         if error then raise camp_error; end if;
         p:= p.lid_seg;
     end loop;
     
     --Seguir amb la llista de camps
     ps:= camps.dcamps_dcamps;
     if ps/=null then
         putcamps(ps,idr);
     end if;
  end putcamps;


  procedure putargs(args: in atribut; idp: id_nom) is
      p,ps: pnode;
      error: boolean;
      desc: descripcio;
  begin
      p:= args.args_arg;
      
      case p.arg_mode is
          when md_in  =>
              desc:= (td => dargc, ta => p.arg_tipus.id_id, na => nova_var);

          when md_in_out  =>
              desc:= (td => dvar, tv => p.arg_tipus.id_id, nv => nova_var);
      end case;
     
      p:= p.arg_lid;
      while p/=null loop
         put_arg(ts,idp,p.lid_id.id_id,desc,error);
         if error then raise arg_error; end if;
         p:= p.lid_seg;
      end loop;
      
      ps:= args.args_args;
      if ps/=null then
          putargs(ps,idp);
      end if;
  end putargs;


  procedure putindxs(indxs: in atribut; ida: in id_nom) is
      p, ps: pnode;
      desc: descripcio;
  begin
      p:= indxs.lid_id;
      ps:= indxs.lid_seg;

      desc:= (td => dindx, tind => p.id_id);
      put_index(ts,ida,desc);
      
      if ps/= null then
          putindxs(ps,ida);
      end if;
  end putindxs;
 
  -- Rutina de control
 
  procedure r_atom(a: out atribut) is
  begin
   a:= new node(nd_null); 
  end r_atom;
  

  -- Rutines lèxiques 
  
  procedure rl_identifier(a: out atribut; pos: in posicio; text: in String) is
    id: id_nom;
  begin
    a:= new node(nd_id);
      
    put(tn,text,id);

    a.id_pos:= pos; a.id_id:= id;
  end rl_identifier;


  procedure rl_literal(a: out atribut; pos: in posicio; text: in String) is 
    ids: id_str;
  begin
    a:= new node(nd_lit);

    put(tn,text,ids);

    a.lit_pos:= pos; a.lit_ids:= ids;
  end rl_literal;


  procedure rl_op_menor(a: out atribut) is
  begin
    a:= new node(nd_op_rel);
  -- Substituir atribut per atribut
    a.orel_tipus:= menor; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_menor;
  

  procedure rl_op_major(a: out atribut) is
  begin
    a:= new node(nd_op_rel);

    a.orel_tipus:= major; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_major;
  

  procedure rl_op_menorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);

    a.orel_tipus:= menorigual; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_menorigual;
  

  procedure rl_op_majorigual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);

    a.orel_tipus:= majorigual; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_majorigual;
  

  procedure rl_op_igual(a: out atribut) is
  begin
    a:= new node(nd_op_rel);

    a.orel_tipus:= igual; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_igual;
  

  procedure rl_op_diferent(a: out atribut) is
  begin
    a:= new node(nd_op_rel);

    a.orel_tipus:= diferent; a.orel_ope:= null; a.orel_opd:= null;
  end rl_op_diferent;


  -- Rutines sintàctiques
  
  procedure rs_Proc(proc: out atribut; cproc: in atribut; decls: in atribut; sents: in atribut) is
      desc: descripcio;
      id: id_nom;
      error: boolean;
      p: pnode;
  begin
      proc:= new node(nd_proc);
      proc.proc_cproc:= cproc;
      proc.proc_decls:= decls;
      proc.proc_sents:= sents;

      id:= cproc.cproc_id.id_id;
      desc:= (td => dproc,np => nou_proc);
      
      put(ts,id,desc,error);
      if error then raise proc_error; end if;
      
      putargs(cproc.cproc_args,id);
  end rs_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut; args: in atribut) is
  begin
      cproc:= new node(nd_c_proc);
      cproc.cproc_id:= proc_id;
      cproc.cproc_args:= args;
  end rs_C_Proc;


  procedure rs_C_Proc(cproc: out atribut; proc_id: in atribut) is
  begin
      cproc:= new node(nd_c_proc);
      cproc.cproc_id:= proc_id;
      cproc.cproc_args:= null;
  end rs_C_Proc;


  procedure rs_Args(args: out atribut; args_seg: in atribut; arg: in atribut) is
  begin
      args:= new node(nd_args);
      args.args_args:= args_seg;
      args.args_arg:= arg;
  end rs_Args;


  procedure rs_Args(args: out atribut; arg: in atribut) is
  begin
      args:= new node(nd_args);
      args.args_args:= null;
      args.args_arg:= arg;
  end rs_Args;


  procedure rs_Arg(arg: out atribut;lid: in atribut; mode: in atribut; tipus: in atribut) is
      desc: descripcio;
  begin 
      arg:= new node(nd_arg);
      arg.arg_lid:= lid;
      arg.arg_mode:= mode.mode_tipus;
      arg.arg_tipus:= tipus;
  end rs_Arg;


  procedure rs_Mode(mode: out atribut; tipus: in tmode) is
  begin
    mode:= new node(nd_mode);

    mode.mode_tipus:= tipus;
  end rs_Mode;


  -- Declaracions

  procedure rs_Decls(decls: out atribut; decls_seg: in atribut; decl: atribut) is
  begin
      decls:= new node(nd_decls);
      decls.decls_decls:= decls_seg;
      decls.decls_decl:= decl;
  end rs_Decls;
 
  
  procedure rs_Decl(decl: out atribut; decl_real: in atribut) is
  begin
      decl.decl_real:= decl_real;
  end rs_Decl;


  procedure rs_Decl_Var(decl: out atribut; lista_id: in atribut; tipus: in atribut) is
  begin
      decl:= new node(nd_decl_var);
      decl.dvar_lid:= lista_id;
      decl.dvar_tipus:= tipus;
      putvar(lista_id,tipus.id_id);
  end rs_Decl_Var;
  
 
  -- ALERTA. no se si el put es correcte
  procedure rs_Decl_Const(decl: out atribut; id_const: in atribut; tipus: in atribut; valor: in atribut) is
      desc: descripcio;
      error: boolean;
  begin
      decl:= new node(nd_decl_const);
      decl.dconst_id:= id_const;
      decl.dconst_tipus:= tipus;
      decl.dconst_valor:= valor;
      
      -- El zero es temporal <<<< ALERTA
      desc:= (td => dconst, tc => tipus.id_id, vc => 0);

      put(ts,id_const.id_id,desc,error);
      if error then raise const_error; end if;
  end rs_Decl_Const;
  
  
  procedure rs_Idx(idx: out atribut; idx_cont: in atribut; signe: in tidx) is
  begin
      idx:= new node(nd_idx);
      idx.idx_cont:= idx_cont;
      -- idx.idx_tipus:= signe; -- << comentat a d_atribut
  end rs_Idx;


  procedure rs_Idx_Cont(idx_cont: out atribut; valor: in atribut) is
  begin
      idx_cont:= new node(nd_idx_cont);
      idx_cont.idxc_valor:= valor;
  end rs_Idx_Cont;


  procedure rs_Decl_T(decl: out atribut; id_type: in atribut; decl_cont: in atribut) is
      desc: descripcio;
      id: id_nom;
      error: boolean;
  begin
      decl:= new node(nd_decl_t);
      decl.dt_id:= id_type;
      decl.dt_cont:= decl_cont;

      id:= id_type.id_id;
      
      -- Zero temporal a l'ocupacio <<< ALERTA
      case decl_cont.tn is
          when nd_decl_t_cont_type    =>
              desc:= (td => dtipus, dt => (tsb => tsb_nul, ocup => 0)); --Deberia ser ent/car/bool
              --desc.dt.ocup:=??;
              put(ts,id,desc,error);
              if error then raise type_error; end if;

          when nd_decl_t_cont_record  =>
              desc:= (td => dtipus, dt => (tsb => tsb_rec, ocup => 0));
              --desc.dt.ocup:=??

              put(ts,id,desc,error);
              if error then raise record_error; end if;
              putcamps(decl_cont.dtcont_camps,id);

          when nd_decl_t_cont_arry    =>
              desc:= (td => dtipus, dt => (tsb => tsb_arr, ocup => 0, tcomp => decl_cont.dtcont_tipus.id_id));
              --desc.dt.ocup:= ??;

              put(ts,id,desc,error);
              if error then raise array_error; end if;
              putindxs(decl_cont.dtcont_idx,id);
        when others =>
          null; -- ERROR

      end case;

  end rs_Decl_T;


  procedure rs_Decl_T_Cont(decl: out atribut; info: in atribut) is
  begin
      case info.tn is
          when nd_rang  =>
              decl:= new node(nd_decl_t_cont_type);
              decl.dtcont_rang:= info;

          when nd_dcamps    =>
              decl:= new node(nd_decl_t_cont_record);
              decl.dtcont_camps:= info;
        when others =>
          null; -- ERROR

      end case;
  end rs_Decl_T_Cont;

  
  procedure rs_Decl_T_Cont(decl: out atribut; rang_array: in atribut; tipus_array: in atribut) is
  begin
      decl:= new node(nd_decl_t_cont_arry);
      decl.dtcont_idx:= rang_array;
      decl.dtcont_tipus:= tipus_array;
  end rs_Decl_T_Cont;


  procedure rs_DCamps(camps: out atribut; camp_seg: in atribut; camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);

    camps.dcamps_dcamps:= camp_seg;
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;


  procedure rs_DCamps(camps: out atribut; camp: in atribut) is
  begin
    camps:= new node(nd_dcamps);

    camps.dcamps_dcamps:= null;
    camps.dcamps_dcamp:= camp;
  end rs_DCamps;



  procedure rs_DCamp(camp: out atribut; var: in atribut) is
  begin
    camp:= new node(nd_dcamp);

    camp.dcamp_decl:= var;
  end rs_DCamp;


  -- Sentencia

  procedure rs_Sents(sents: out atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents);

    sents.sents_cont:= sent;
  end rs_Sents;


  procedure rs_Sent_Nob(sents: out atribut; sent_cont: in atribut; sent: in atribut) is
  begin
    sents:= new node(nd_sents_nob);
    
    sents.snb_snb:= sent_cont;
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent_Nob(sents: out atribut; sent: in atribut) is 
  begin
    sents:= new node(nd_sents_nob);

    sents.snb_snb:= null;
    sents.snb_sent:= sent;
  end rs_Sent_Nob;


  procedure rs_Sent(sent: out atribut; stipus: in atribut) is
  begin
    sent:= new node(nd_sent);

    sent.sent_sent:= stipus;
  end rs_Sent;

  
  procedure rs_SIter(sent: out atribut; expr: in atribut; sents: in atribut) is
    begin
        sent:= new node(nd_siter);
        sent.siter_expr:= expr;
        sent.siter_sents:= sents;
    end rs_SIter;


  procedure rs_SCond(sent: out atribut; expr: in atribut; sents: in atribut) is
  begin
    sent:= new node(nd_scond);

    sent.scond_expr:= expr;
    sent.scond_sents:= sents;
    sent.scond_esents:= null;
  end rs_SCond;
  

  procedure rs_SCond(sent: out atribut; expr: in atribut; sents_if: in atribut; sents_else: in atribut) is
  begin
    sent:= new node(nd_scond);

    sent.scond_expr:= expr;
    sent.scond_sents:= sents_if;
    sent.scond_esents:= sents_else;
  end rs_SCond;
  
  
    procedure rs_SCrida(sent: out atribut; ref: in atribut) is
  begin
    sent:= new node(nd_scrida);

    sent.scrida_ref:= ref;
  end rs_SCrida;
  

  procedure rs_SAssign(sent: out atribut; ref: in atribut; expr: in atribut) is 
  begin
    sent:= new node(nd_sassign);

    sent.sassign_ref:= ref;
    sent.sassign_expr:= expr;
  end rs_SAssign;


  -- Expressio

  procedure rs_LExpr(lexpr: out atribut; cont: in atribut; expr: in atribut) is
  begin
    lexpr:= new node(nd_lexpr);

    lexpr.lexpr_cont:= cont;
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_LExpr(lexpr: out atribut; expr: in atribut) is
  begin
    lexpr:= new node(nd_lexpr);

    lexpr.lexpr_cont:= null;
    lexpr.lexpr_expr:= expr;
  end rs_LExpr;


  procedure rs_Expr(expr: out atribut; cont: in atribut) is
  begin
    expr:= new node(nd_expr);

    expr.expr_e:= cont;
  end rs_Expr;


  procedure rs_E0(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e0);

    expr.e_ope:= ee;
    expr.e_opd:= ed;
  end rs_E0;


  procedure rs_E1(expr: out atribut; ee: in atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e1);

    expr.e_ope:= ee;
    expr.e_opd:= ed;
  end rs_E1;


	--Rutines semàntiques auxiliars 

  procedure rs_E2(expr: out atribut; ee: in atribut; op: in operand; ed: in atribut) is
  begin
    expr:= new node(nd_e2);

    expr.e2_ope:= ee;
    expr.e2_opd:= ed;
    expr.e2_operand:= op;
  end rs_E2;


  procedure rs_E2(expr: out atribut; op:in operand; ed: in atribut) is
  begin
    expr:= new node(nd_e2);

    expr.e2_ope:= null;
    expr.e2_opd:= ed;
    expr.e2_operand:= op;
  end rs_E2;


  -- Arreglar!!
  procedure rs_E2(expr: out atribut; ed: in atribut) is
  begin
    expr:= new node(nd_e2);

    expr.e2_ope:= null;
    expr.e2_opd:= ed;
    expr.e2_operand:= null;
  end rs_E2;


  procedure rs_E3(expr: out atribut; e: in atribut) is
  begin
    expr:= new node(nd_e3);

    expr.e3_cont:= e;
  end rs_E3;


  -- Altres

  procedure rs_Lid(lid: out atribut; id_seg: in atribut; id: in atribut) is
  begin
    lid:= new node(nd_lid);

    lid.lid_seg:= id_seg;
    lid.lid_id:= id;
  end rs_Lid;


  procedure rs_Ref(ref: out atribut; ref_id: in atribut; qs: in atribut) is
  begin
      ref:= new node(nd_ref);
      ref.ref_id:= ref_id.id_id;
      ref.ref_qs:= qs;
  end rs_Ref;

procedure rs_Qs(qs: out atribut; qs_in: in atribut; q: in atribut) is
  begin
      qs:= new node(nd_qs);
      qs.qs_qs:= qs_in;
      qs.qs_q:= q;
  end rs_Qs;


  procedure rs_Q(q: out atribut; contingut: in atribut) is
  begin
      q:= new node(nd_q);
      q.q_contingut:= contingut;
  end rs_Q;

end semantica.c_arbre;
