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
        proc.cproc:= cproc;
        proc.decl:= decls;
        proc.sents:= sents;

        id:= cproc.proc_id.id;
        desc:= new descripcio(dproc);
        --desc.np:=??
        
        put(ts,id,desc,error);
        if error then raise proc_error; end if;
        
        putargs(args,id);
    end rs_Proc;


	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType; args: in YYSType) is
    begin
        cproc:= new node(nd_c_proc);
        cproc.proc_id:= proc_id;
        cproc.args:= args;
    end rs_C_Proc;


	procedure rs_C_Proc(cproc: out YYSType; proc_id: in YYSType) is
    begin
        cproc:= new node(nd_c_proc);
        cproc.proc_id:= proc_id;
        cproc.args:= null;
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
        decls.decls:= decls_seg;
        decls.decl:= decl;
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
        decl.id_const:= id_const;
        decl.const_tipus:= tipus;
        decl.const_valor:= valor;
        
        desc:= new descripcio(dconst);
        desc.tc:= tipus.id;
        --desc.valor:=??

        put(ts,id_const.id,desc,error);
        if error then raise const_error; end if;
    end rs_Decl_Const;
    
    
	procedure rs_Idx(idx: out YYSType; idx_cont: in YYSType; signe: in character) is
    begin
        idx:= new node(nd_idx);
        idx.cidx:= idx_cont;
        case signe is
            when '-' => idx.t:= negatiu;
            when '+' => idx.t:= positiu;
            when others =>
                raise error;
        end case;
    end rs_Idx;


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
end rutines_sintactiques;
