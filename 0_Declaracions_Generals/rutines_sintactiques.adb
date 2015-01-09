use d_atribut; with d_atribut;
use general_defs; with general_defs;
use d_tsimbols; with d_tsimbols;

package body rutines_sintactiques is
    ts: tsimbols; -- Lo mismo que la de nombres!! 


	-- Procediment

	procedure rs_Proc(proc: out YYSType; cproc: in YYSType; decls: in YYSType; sents: in YYSType) is
        desc: descripcio;
        id: id_nom;
        error: boolean;
        p: pnode;
    begin
        proc:= new node(nd_proc);
        proc.proc_cproc:= cproc;
        proc.proc_decl:= decls;
        proc.proc_sents:= sents;

        id:= cproc.cproc_id.id_id;
        desc:= new descripcio(dproc);
        desc.np:=nou_proc;
        
        put(ts,id,desc,error);
        if error then raise proc_error; end if;
        
        putargs(args,id);
    end rs_Proc;


	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType; args: in YYSType) is
    begin
        cproc:= new node(nd_c_proc);
        cproc.cproc_id:= proc_id;
        cproc.cproc_args:= args;
    end rs_C_Proc;


	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType) is
    begin
        cproc:= new node(nd_c_proc);
        cproc.cproc_id:= proc_id;
        cproc.cproc_args:= null;
    end rs_C_Proc;


	procedure rs_Args(args: out YYSType; args_seg: in YYSType; arg: in YYSType) is
    begin
        args:= new node(nd_args);
        args.args:= args_seg;
        args.arg:= arg;
    end rs_Args;


	procedure rs_Args(args: out YYSType; arg: in YYSType) is
    begin
        args:= new node(nd_args);
        args.args:= null;
        args.arg:= arg;
    end rs_Args;


	procedure rs_Arg(arg: out YYSType;lid: in YYSType; mode: in YYSType; tipus: in YYSType) is
        desc: descripcio;
    begin 
        arg:= new node(nd_arg);
        arg.lid:= lid;
        arg.arg_mode:= mode.tmode;
        arg.arg_tipus:= tipus;
    end rs_Arg;


    procedure rs_Mode(mode: out YYStype; tipus: in tmode) is
	begin
		mode:= new node(nd_mode);

		mode.mode_tipus:= tipus;
	end rs_Mode;
	

	-- Declaracio

	procedure rs_Decls(decls: out YYSType; decls_seg: in YYSType; decl: YYSType) is
    begin
        decls:= new node(nd_decls);
        decls.decls_decls:= decls_seg;
        decls.decls_decl:= decl;
    end rs_Decls;
   
    
	procedure rs_Decl(decl: out YYSType; decl_real: in YYSType) is
    begin
        decl.decl_real:= decl_real;
    end rs_Decl;

	
    procedure rs_Decl_Var(decl: out YYSType; lista_id: in YYSType; tipus: in YYSType) is
    begin
        decl:= new node(nd_decl_var);
        decl.dvar_lid:= lista_id;
        decl.dvar_tipus:= tipus;
        putvar(lista_id,tipus.id_id);
    end rs_Decl_Var;
    
    
    procedure rs_Decl_Const(decl: out YYSType; id_const: in YYSType; tipus: in YYSType; valor: in YYSType) is
        desc: descripcio;
        error: boolean;
    begin
        decl:= new node(nd_decl_const);
        decl.dconst_id:= id_const;
        decl.dconst_tipus:= tipus;
        decl.dconst_valor:= valor;
        
        desc:= new descripcio(dconst);
        desc.tc:= tipus.id_id;
        --desc.valor:=??

        put(ts,id_const.id,desc,error);
        if error then raise const_error; end if;
    end rs_Decl_Const;
    
    
	procedure rs_Idx(idx: out YYSType; idx_cont: in YYSType; signe: in idx) is
    begin
        idx:= new node(nd_idx);
        idx.idx_cont:= idx_cont;
        idx.idx_tipus:= signe;
    end rs_Idx;


	procedure rs_Idx_Cont(idx_cont: out YYSType; valor: in YYSType) is
    begin
        idx_cont:= new node(nd_idx_cont);
        idx_cont.idxc_valor:= valor;
    end rs_Idx_Cont;


	procedure rs_Decl_T(decl: out YYSType; id_type: in YYSType; decl_cont: in YYSType) is
        desc: descripcio;
        id: id_nom;
        error: boolean;
    begin
        decl:= new node(nd_decl_t);
        decl.dt_id:= id_type;
        decl_dt_cont:= decl_cont;

        id:= id_type.id_id;
        desc:= new descripcio(dtipus);
        
        case decl_cont.tn is
            when nd_decl_t_cont_type    =>
                desc.dt:= new descr_tipus(tsb_null); --Deberia ser ent/car/bool
                --desc.dt.ocup:=??;
                put(ts,id,desc,error);
                if error then raise type_error; end if;

            when nd_decl_t_cont_record  =>
                desc.dt:= new descr_tipus(tsb_rec);
                --desc.dt.ocup:=??

                put(ts,id,desc,error);
                if error then raise record_error; end if;
                putcamps(decl_cont.dtcont_camps,id);

            when nd_decl_t_cont_arry    =>
                desc.dt:= new descr_tipus(tsb_arr);
                desc.tcomp:= decl_cont.dtcont_tipus.id_id;
                --desc.dt.ocup:= ??;

                put(ts,id,desc,error);
                if error then raise array_error; end if;
                putindxs(decl_cont.dtcont_idx,id);

        end case;

    end rs_Decl_T;
  

	procedure rs_Decl_T_Cont(decl: out YYSType; info: in YYSType) is
    begin
        case info.tn is
            when nd_rang  =>
                decl:= new node(nd_decl_t_cont_type);
                decl.dtcont_rang:= info;

            when nd_camps    =>
                decl:= new node(nd_decl_t_cont_record);
                decl.dtcont_camps:= info;

        end case;
    end rs_Decl_T_Cont;

    
    procedure rs_Decl_T_Cont(decl: out YYSType; rang_array: in YYSType; tipus_array: in YYSType) is
    begin
        decl:= new node(nd_decl_t_cont_arry);
        decl.dtcont_idx:= rang_array;
        decl.dtcont_tipus:= tipus_array;
    end rs_Decl_T_Cont;


	procedure rs_DCamps(camps: out YYSType; camp_seg: in YYStype; camp: in YYStype) is
	begin
		camps:= new node(nd_dcamps);

		camps.dcamps_dcamps:= camp_seg;
		camps.dcamps_dcamp:= camp;
	end rs_DCamps;


	procedure rs_DCamps(camps: out YYSType; camp: in YYStype) is
	begin
		camps:= new node(nd_dcamps);

		camps.dcamps_dcamps:= null;
		camps.dcamps_dcamp:= camp;
	end rs_DCamps;



	procedure rs_DCamp(camp: out YYStype; var: in YYStype) is
	begin
		camp:= new node(nd_dcamp);

		camp.dcamp_decl:= var;
	end rsDCamp;


	-- Sentencia

	
	procedure rs_Sents(sents: out YYStype; sent: in YYStype) is
	begin
		sents:= new node(nd_sents);

		sents.sents_cont:= sent;
	end rs_Sents;


	procedure rs_Sent_Nob(sents: out YYStype; sent_cont: in YYSType; sent: in YYStype) is
	begin
		sents:= new node(nd_sents_nob);
		
		sents.snb_snb:= sent_cont;
		sents.snb_sent:= sent;
	end rs_Sent_Nob;


	procedure rs_Sent_Nob(sents: out YYStype; sent: in YYStype) is 
	begin
		sents:= new node(nd_sents_nob);

		sents.snb_snb:= null;
		sents.snb_sent:= sent;
	end rs_Sent_Nob;


	procedure rs_Sent(sent: out YYStype; stipus: in YYStype) is
	begin
		sent:= new node(nd_sent);

		sent.sent_sent:= stipus;
	end rs_Sent;

	
	procedure rs_SIter(sent: out YYStype; expr: in YYStype; sents: in YYStype) is
    begin
        sent:= new node(nd_siter);
        sent.siter_expr:= expr;
        sent.siter_sents:= sents;
    end rs_SIter;


	procedure rs_SCond(sent: out YYStype; expr: in YYStype; sents: in YYStype) is
	begin
		sent:= new node(nd_scond);

		sent.scond_expr:= expr;
		sent.scond_sents:= sents;
		sent.scond_esents:= null;
	end rs_SCond;
	

	procedure rs_SCond(sent: out YYStype; expr: in YYStype; sents_if: in YYStype; sents_else: in YYStype) is
	begin
		sent:= new node(nd_scond);

		sent.scond_expr:= expr;
		sent.scond_sents:= sents_if;
		sent.scond_esents:= sents_else;
	end rs_SCond;
	
	
    procedure rs_SCrida(sent: out YYStype; ref: in YYStype) is
	begin
		sent:= new node(nd_scrida);

		sent.scrida_ref:= ref;
	end rs_SCrida;
	

	procedure rs_SAssign(sent: out YYStype; ref: in YYStype; expr: in YYStype) is 
	begin
		sent:= new node(nd_sassign);

		sent.sassign_ref:= ref;
		sent.sassign_expr:= expr;
	end rs_SAssign;


	-- Expressio

	procedure rs_LExpr(lexpr: out YYStype; cont: in YYStype; expr: in YYStype) is
	begin
		lexpr:= new node(nd_lexpr);

		lexpr.lexpr_cont:= cont;
		lexpr.lexpr_expr:= expr;
	end rs_LExpr;

	
    procedure rs_LExpr(lexpr: out YYStype; expr: in YYStype) is
	begin
		lexpr:= new node(nd_lexpr);

		lexpr.lexpr_cont:= null;
		lexpr.lexpr_expr:= expr;
	end rs_LExpr;

	
    procedure rs_Expr(expr: out YYStype; cont: in YYStype) is
	begin
		expr:= new node(nd_expr);

		expr.expr_e:= cont;
	end rs_Expr;

	
    procedure rs_E0(expr: out YYStype; ee: in YYStype; ed: in YYStype) is
	begin
		expr:= new node(nd_e0);

		expr.e_ope:= ee;
		expr.e_opd:= ed;
	end rs_E0;

	
    procedure rs_E1(expr: out YYStype; ee: in YYStype; ed: in YYStype) is
	begin
		expr:= new node(nd_e1);

		expr.e_ope:= ee;
		expr.e_opd:= ed;
	end rs_E1;

	
    procedure rs_E2(expr: out YYStype; ee: in YYStype; op: in operand; ed: in YYStype) is
	begin
		expr:= new node(nd_e2);

		expr.e2_ope:= ee;
		expr.e2_opd:= ed;
		expr.e2_operand:= op;
	end rs_E2;

	
    procedure rs_E2(expr: out YYStype; op:in operand; ed: in YYStype) is
	begin
		expr:= new node(nd_e2);

		expr.e2_ope:= null;
		expr.e2_opd:= ed;
		expr.e2_operand:= op;
	end rs_E2;

	
    procedure rs_E2(expr: out YYStype; ed: in YYStype) is
	begin
		expr:= new node(nd_e2);

		expr.e2_ope:= null;
		expr.e2_opd:= null;
		expr.e2_operand:= op;
	end rs_E2;

	
    procedure rs_E3(expr: out YYStype; e: in YYStype) is
	begin
		expr:= new node(nd_e3);

		expr.e3_cont:= e;
	end rs_E3;
	
	
	-- Altres
	
	procedure rs_Lid(lid: out YYStype; id_seg: in YYStype; id: in YYStype) is
	begin
		lid:= new node(nd_lid);

		lid.lid_seg:= id_seg;
		lid.lid_id:= id;
	end rs_Lid;

	
    procedure rs_Ref(ref: out YYSType; ref_id: in YYSType; qs: in YYSType) is
    begin
        ref:= new node(nd_ref);
        ref.ref_id:= ref_id.id_id;
        ref.ref_qs:= qs;
    end rs_Ref;

	procedure rs_Qs(qs: out YYSType; qs_in: in YYSType; q: in YYSType) is
    begin
        qs:= new node(nd_qs);
        qs.qs:= qs_in;
        qs.q:= q;
    end rs_Qs;


    procedure rs_Q(q: out YYSType; contingut: in YYSType) is
    begin
        q:= new node(nd_q);
        q.q_contingut:= contingut;
    end rs_Q;

    
	--rutines auxiliars 

    procedure putvar(list_id: in YYSType; id_type: in id_nom) is
        desc: descripcio;
        p,ps: pnode;
        error: boolean;
    begin
        p:= list_id.lid_id;
        ps:= list_id.lid_next
        desc:= new descripcio(dvar);
        desc.tv:= id_type;
        desc.nv:= nova_var;
        put(ts,p.id_id,desc,error);
        if error then raise var_error; end if;

        if ps/=null then
            putvar(ps,id_type);
        end if;
    end putvar;


    procedure putcamps(camps: in YYSType; idr: in id_nom) is
        desc: descripcio;
        p, ps: pnode;
        error: boolean;
    begin
       desc:= new descripcio(dcamp);
       desc.tcmp:= p.dcamp_decl.dvar_tipus.id_id;
       --desc.dcmp:= ??
       
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


    procedure putargs(args: in YYSType; idp: id_nom) is
        p,ps: pnode;
        error: boolean;
        desc: descripcio;
    begin
        p:= args.arg;
        
        case p.arg_mode is
            when md_in  =>
                desc:= new descripcio(dargc);
                desc.ta:= p.arg_tipus.id_id;
                desc.na:= nova_var;

            when md_in_out  =>
                desc:= new descripcio(dvar);
                desc.tv:= p.arg_tipus.id_id;
                desc.nv:= nova_var;
        end case;
       
        p:= p.arg_lid;
        while p/=null loop
           put_arg(ts,idp,p.lid_id.id_id,desc,error);
           if error then raise arg_error; end if;
           p:= p.lid_seg;
        end loop;
        
        ps:= args.args;
        if ps/=null then
            putargs(ps,idp);
        end if;
    end putargs;
	
  
	procedure putindxs(indxs: in YYSType; ida: in id_nom) is
        desc: descripcio;
    begin
        p:= indxs.lid_id;
        ps:= indxs.lid_seg;
        
        id:= p.id_id;
        desc:= new descripcio(dindx);
        desc.tind:= id;
        put_index(ts,ida,desc);
        
        if ps/= null then
            putindxs(ps,ida);
        end if;
    end putindxs;

    
    -- Temporal, a la generacio de codi canvien.
	-- Añadirlos como variables&procs a general_defs?
	nv: num_var:= 0;
	np: num_proc:= 0;

	function nova_var return Num_var is
	begin
		nv:= nv+1;
		return nv;
	end nova_var;

	function nou_proc return Num_proc is
	begin
		np:= np+1;
		return np;
	end nou_proc;

end rutines_sintactiques;
