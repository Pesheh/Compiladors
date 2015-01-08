use d_atribut; with d_atribut;
use general_defs; with general_defs;
use d_tsimbols; with d_tsimbols;

package body rutines_sintactiques is
    ts: tsimbols; -- Lo mismo que la de nombres!! 


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
        null;
    end rs_Args;


	procedure rs_Args(args: out YYSType; arg: in YYSType) is
    begin
        null;
    end rs_Args;


	procedure rs_Arg(arg: out YYSType; mode: in YYSType; tipus: in YYSType) is
    begin
        null;
    end rs_Arg;


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
        --...
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

	
	procedure rs_DCamps(camps: out YYSType; camp: in YYStype) is
	begin
		camps:= new node(nd_dcamps);

		camps.dcamps_dcamps:= null;
		camps.dcamps_dcamp:= camp;
	end rs_DCamps;

	procedure rs_DCamps(camps: out YYSType; camp_seg: in YYStype; camp: in YYStype) is
	begin
		camps:= new node(nd_dcamps);

		camps.dcamps_dcamps:= camp_seg;
		camps.dcamps_dcamp:= camp;
	end rs_DCamps;

	procedure rs_DCamp(camp: out YYStype; var: in YYStype) is
	begin
		camp:= new node(nd_dcamp);

		camp.dcamp_decl:= var;
	end rsDCamp;


	procedure rs_Lid(lid: out YYStype; id_seg: in YYStype; id: in YYStype) is
	begin
		lid:= new node(nd_lid);

		lid.lid_seg:= id_seg;
		lid.
	end rs_Lid;
	procedure rs_Lid(lid: out YYStype; id: in YYStype);

	
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

    procedure putargs(args: in YYSType; idp: id_nom) is
        p: pnode;
        ps: pnode;
        error: boolean;
    begin
        p:= args.arg;
        ps:= args.args;
        put_arg(ts,idp,p.idarg,p.darg,error);
        if error then raise arg_error; end if;
        if ps/=null then
            putargs(ps,idp);
        end if;
    end putargs;
	
    procedure putvar(list_id: in YYSType; id_type: in id_nom) is
        desc: descripcio;
        p: pnode;
        error: boolean;
    begin
        p:= list_id.lid_id;
        if p/=null
        desc:= new descripcio(dvar);
        desc.tv:= id_type;
        desc.nv:= nova_var;

    end putvar;

    
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
