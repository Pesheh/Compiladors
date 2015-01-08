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
        desc.tc:= tipus.id;
        --desc.valor:=??

        put(ts,id_const.id,desc,error);
        if error then raise const_error; end if;
    end rs_Decl_Const;
    
    
	procedure rs_Idx(idx: out YYSType; idx_cont: in YYSType; signe: in character) is
    begin
        idx:= new node(nd_idx);
        idx.idx_cont:= idx_cont;
        case signe is
            when '-' => idx.idx_tipus:= negatiu;
            when '+' => idx.idx_tipus:= positiu;
            when others =>
                raise error;
        end case;
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
                --Creo que tenemos que hacer rl para cada uno de los lit ya que sino no sabemos que tsb es
                --desc.dt:= ?? 
                
            when nd_decl_t_cont_record  =>
                desc.dt:= new descr_tipus(tsb_rec);
                --desc.dt.ocup:=??

                put(ts,id,desc,error);
                if error then raise record_error; end if;
                putcamps(decl_cont.dtcont_camps,id);

            when nd_decl_t_cont_arry    =>
                desc.dt:= new descr_tipus(tsb_arr);
                desc.tcomp:= decl_cont.dtcont_tipus.id_id;

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


    --rutines auxiliars 

    procedure putargs(args: in YYSType; idp: id_nom) is
        p: pnode;
        error: boolean;
    begin
        p:= args.arg;
        if p/=null then
            put_arg(ts,idp,p.idarg,p.darg,error);
            if error then raise arg_error; end if;
            putargs(args.args,idp);
        end if;
    end putargs;
	

    
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
