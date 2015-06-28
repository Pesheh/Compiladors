with d_queue; use d_queue;
with decls; use decls;
with decls.d_descripcio; use decls.d_descripcio;
with decls.d_tsimbols; use decls.d_tsimbols;


with Ada.text_io; use Ada.text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;

package body semantica.missatges is

    --Podria ser que pondremos el fichero en que se ha producido el error
  procedure missatges_desc_no_es_tipus(pos: in posicio; id: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": """&get(tn, id)&""" no és un tipus.");
  end missatges_desc_no_es_tipus;


  procedure missatges_conflictes_declaracio(pos: in posicio; id: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": """&get(tn, id)&""" està en conflicte amb una altre declaració.");
  end missatges_conflictes_declaracio;

  procedure missatges_operacio_amb_escalar(pos: in posicio) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Operació il·legal=> Aquest tipus d'assignacions sols es poden dur a terme entre escalars.");
  end missatges_operacio_amb_escalar;

  procedure missatges_tipus_incosistent_lit(pos: in posicio; id_tipus: in id_nom;tsb_found: in tipus_subjacent) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Tipus esperat """&get(tn,id_tipus)&"""");
    put(pos.fila'img&":"&pos.columna'img&":");
    case tsb_found is
      when tsb_bool=>
        put_line("S'ha trobat un tipus booleà.");

      when tsb_car=>
        put_line("S'ha trobat un tipus caràcter.");

      when tsb_ent=>
        put_line("S'ha trobat un tipus enter.");

      when tsb_arr=>
        put_line("S'ha trobat un tipus array.");

      when tsb_rec=>
        put_line("S'ha trobat un tipus record.");

      when others=> null;
    end case;
  end missatges_tipus_incosistent_lit;

  procedure missatges_tipus_incosistent_id(pos: in posicio; id_expected, id_found: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Tipus esperat """&get(tn,id_expected)&""".");
    put_line(pos.fila'img&":"&pos.columna'img&": Tipus trobat """&get(tn,id_found)&""".");
  end missatges_tipus_incosistent_id;


  procedure missatges_valor_fora_rang(pos: in posicio; id_tipus: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Valor fora del rang del tipus """&get(tn, id_tipus)&""".");
  end missatges_valor_fora_rang;


  procedure missatges_rang_incorrecte(pos: in posicio) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Rang incorrecte=> El límit inferior ha de ser menor que el límit superior.");
  end missatges_rang_incorrecte;


  procedure missatges_assignacio_incorrecta(pos: in posicio) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Assignació il·legal ");
  end missatges_assignacio_incorrecta;


  procedure missatges_operador_tipus(pos: in posicio; tsb_tipus: in tipus_subjacent; op: in operand) is
  begin
    case op is
      when major | majorigual | igual | diferent | menorigual | menor=>
        put(pos.fila'img&":"&pos.columna'img&": Els operadors relacionals no han estat definits ");

      when sum=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""+"" no està definit ");

      when res=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""-"" no està definit ");

      when prod=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""*"" no està definit ");

      when quoci=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""/"" no està definit ");

      when modul=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""mod"" no està definit ");

      when neg_log=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""not"" no està definit ");

      when neg_alg=>
        put(pos.fila'img&":"&pos.columna'img&": L'operador ""- unari"" no esta definit ");

      when others=> null;
    end case;

    case tsb_tipus is
      when tsb_bool=>
        put_line("per a un tipus booleà.");

      when tsb_car=>
        put_line("per a un tipus caràcter.");

      when tsb_ent=>
        put_line("per a un tipus enter.");

      when tsb_arr=>
        put_line("per a un tipus array.");

      when tsb_rec=>
        put_line("per un tipus record.");

      when others=> null;
    end case;
  end missatges_operador_tipus;

  procedure missatges_log_operador(pos: in posicio; tsb: in tipus_subjacent) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Els operadors llogics or/and no son definits ");

    case tsb is
      when tsb_bool=>
        put_line("per un tipus boolea.");

      when tsb_car=>
        put_line("per un tipus caracter.");

      when tsb_ent=>
        put_line("per un tipus enter.");

      when tsb_arr=>
        put_line("per un tipus array.");

      when tsb_rec=>
        put_line("per un tipus record.");

      when others=> null;
    end case;
  end missatges_log_operador;

  procedure missatges_sent_buida is
  begin
      --Pobablemente se tendria que cambiar para tener en cuenta la posicion!
    put("Sentencia esperada, no s'admeten blocs de senténcies buides, si voleu deixar-los buits empreu la keyword ""null"".");
  end missatges_sent_buida;

  procedure missatges_expressions_incompatibles(pos: in posicio; id_tipus1, id_tipus2: in id_nom; tsb1, tsb2: in tipus_subjacent) is
  begin

    put(pos.fila'img&":"&pos.columna'img&": El tipus """ );     
    if id_tipus1 /= null_id then
      put(get(tn, id_tipus1)); 
    else 
    case tsb1 is
      when tsb_bool=>
        put("boolea");

      when tsb_car=>
        put("caracter");

      when tsb_ent=>
        put("enter");

      when tsb_arr=>
        put("array");

      when tsb_rec=>
        put("record");
      when others=> null;
    end case;

    end if;
    put(""" no es compatible amb el tipus """);
    if id_tipus2 /= null_id then
      put_line(get(tn, id_tipus2)&""".");
    else
    case tsb2 is
      when tsb_bool=>
        put_line("boolea"".");

      when tsb_car=>
        put_line("caracter"".");

      when tsb_ent=>
        put_line("enter"".");

      when tsb_arr=>
        put_line("array"".");

      when tsb_rec=>
        put_line("record"".");
      when others=> null;
    end case;

    end if;


  end missatges_expressions_incompatibles;


  procedure missatges_menys_indexos_array(pos: in posicio; id_array: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Nombre insuficient d'indexos per a l'array """&get(tn, id_array)&""".");
  end missatges_menys_indexos_array;


  procedure missatges_massa_indexos_array(pos: in posicio; id_array: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Nombre major d'indexos que els acceptats al rang de l'array """&get(tn, id_array)&""".");
  end missatges_massa_indexos_array;


  procedure missatges_no_record(pos: in posicio; id: in id_nom) is
  begin
      put_line(pos.fila'img&":"&pos.columna'img&": El tipus """&get(tn, id)&""" no es un record.");
  end missatges_no_record;

procedure missatges_camp_no_record(pos: in posicio; id_rec, id_camp: in id_nom) is
begin
   put_line(pos.fila'img&":"&pos.columna'img&": El record """&get(tn, id_rec)&""" no té cap camp amb el nom """&get(tn, id_camp)&""".");
end missatges_camp_no_record;

  procedure missatges_no_array(pos: in posicio; id: in id_nom) is
  begin
      put_line(pos.fila'img&":"&pos.columna'img&": El tipus """&get(tn, id)&""" no és un array.");
  end missatges_no_array;

 procedure missatges_menys_arguments_proc(pos: in posicio; id_proc: in id_nom) is
 begin
    put_line(pos.fila'img&":"&pos.columna'img&": Nombre insuficient d'arguments pel al procediment """&get(tn, id_proc)&""".");
 end missatges_menys_arguments_proc;

 procedure missatges_massa_arguments_proc(pos: in posicio; id_proc: in id_nom) is
 begin
    put_line(pos.fila'img&":"&pos.columna'img&": Nombre major d'arguments que els acceptats pel procediment """&get(tn, id_proc)&""".");

 end missatges_massa_arguments_proc;


  procedure missatges_arg_mode(pos: in posicio; id: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": L'argument """&get(tn,id)&" no compleix amb el seu mode");
  end missatges_arg_mode;

  procedure missatges_proc_mult_parentesis(pos: in posicio) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Paréntesis no lligats a cap expressió.");
  end missatges_proc_mult_parentesis;

  procedure missatges_cond_bool(pos: in posicio; tsb: in tipus_subjacent) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": Tipus esperat ""Boolean""");
    put(pos.fila'img&":"&pos.columna'img&":");
    case tsb is
      when tsb_bool=>
        put_line("S'ha trobat un tipus booleà.");

      when tsb_car=>
        put_line("S'ha trobat un tipus caràcter.");

      when tsb_ent=>
        put_line("S'ha trobat un tipus enter.");

      when tsb_arr=>
        put_line("S'ha trobat un tipus array.");

      when tsb_rec=>
        put_line("S'ha trobat un tipus record.");

      when others=> null;
    end case;
  end missatges_cond_bool;

  procedure missatges_no_definida(pos: in posicio; id: in id_nom) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": La entitat """&get(tn, id)&""" no està definida.");

  end missatges_no_definida;

  procedure missatges_no_proc(pos: in posicio) is
  begin
    put_line(pos.fila'img&":"&pos.columna'img&": S'espera un procediment, no un array.");
  end missatges_no_proc;















  --Missatges de debugging
  procedure missatges_ct_error_intern(pos: in posicio; proc: in String) is
  begin
    if DEBUG then
      put_line("c_tipus.adb:"&proc&"::"&pos.fila'img&":"&pos.columna'img&": S'ha produit un error intern del compilador.");
    end if;
  end missatges_ct_error_intern;

  procedure missatges_ct_debugging(proc,msg: in String) is
  begin
    if DEBUG then
      put_line("c_tipus.adb:"&proc&"::"&msg);
    end if;
  end missatges_ct_debugging;

  procedure missatges_gc_debugging(proc,msg: in String) is
  begin
    if DEBUG then
      put_line("g_codi_int.adb:"&proc&"::"&msg);
    end if;
  end missatges_gc_debugging;

  procedure missatges_imprimir_desc(proc: in String; d: in descripcio; id: in id_nom; p: in String) is
  begin
    if DEBUG then
      put_line("d_tsimbols.adb:"&proc&"::   ID:"&id'img&"   TD: "&d.td'img&"   PROF:"&p);
    end if;
  end missatges_imprimir_desc;


  procedure missatges_imprimir_id(proc: in String; id: in id_nom; nom: in String ) is
  begin
    if DEBUG then
      put_line("d_tnom:"&proc&"::   ID:"&id'img&"   Nom: "&nom);
    end if;
  end missatges_imprimir_id;


  procedure imprimir_arbre(root: in pnode) is
    q:queue;
    p: pnode;
    i,j: Integer:=0;
    graph: File_Type;
  begin
    if DEBUG then
      Create (File => graph,
            Mode => Out_File,
            Name => "arbre_sintactic.dot");
      put_line(graph,"digraph G{");
      empty(q);
      put(q,root,i);
      while not is_empty(q) loop
        pop(q,p,j);
        if p/=null then
          case p.tn is
            when nd_null =>
              null;

            when nd_root =>
              i:=i+1;
              put_line(graph,"nd_root_"& Trim(j'img, Ada.Strings.Left)&"-> nd_proc_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.p,i);

            when nd_id =>
              i:=i+1;
              put_line(graph,"nd_id_"&Trim(j'img, Ada.Strings.Left)&"->id_"&Trim(i'img, Ada.Strings.Left));

            when nd_lit =>
              i:=i+1;
              put_line(graph,"nd_lit_"&Trim(j'img, Ada.Strings.Left)&" -> lit_"&Trim(i'img, Ada.Strings.Left));

              --      when nd_op_rel =>

            when nd_lid =>
              if p.lid_seg/=null then
                i:=i+1;
                put_line(graph,"nd_lid_"&Trim(j'img, Ada.Strings.Left)& "-> nd_lid_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.lid_seg,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_lid_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.lid_id,i);

            when nd_mode =>
              put_line(graph,"nd_mode_"&Trim(j'img, Ada.Strings.Left)&" -> mode_"&p.mode_tipus'img);

            when nd_c_proc =>
              i:=i+1;
              put_line(graph,"nd_cproc_" &Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.cproc_id,i);
              if p.cproc_args/=null then
                i:=i+1;
                put_line(graph,"nd_cproc_"&Trim(j'img, Ada.Strings.Left)&" -> nd_args_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.cproc_args,i);
              end if;

            when nd_proc =>
              i:=i+1;
              put_line(graph,"nd_proc_"&Trim(j'img, Ada.Strings.Left)&" -> nd_cproc_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.proc_cproc,i);
              i:=i+1;
              put_line(graph,"nd_proc_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decls_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.proc_decls,i);
              i:=i+1;
              put_line(graph,"nd_proc_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.proc_sents,i);

            when nd_args =>
              if p.args_args/=null then
                i:=i+1;
                put_line(graph,"nd_args_"&Trim(j'img, Ada.Strings.Left)&" -> nd_args_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.args_args,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_args_"&Trim(j'img, Ada.Strings.Left)&" -> nd_arg_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.args_arg,i);

            when nd_arg =>
              i:=i+1;
              put_line(graph,"nd_arg_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.arg_tipus,i);
              i:=i+1;
              put_line(graph,"nd_arg_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lid_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.arg_lid,i);
              put_line(graph,"nd_arg_"&Trim(j'img, Ada.Strings.Left)&" -> mode_"&p.arg_mode'img);

            when nd_decls =>
              if p.decls_decls/=null then
                i:=i+1;
                put_line(graph,"nd_decls_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decls_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.decls_decls,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_decls_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.decls_decl,i);

            when nd_decl =>
              i:=i+1;
              case p.decl_real.tn is
                when nd_proc =>
                  put_line(graph,"nd_decl_"&Trim(j'img, Ada.Strings.Left)&" -> nd_proc_"&Trim(i'img, Ada.Strings.Left));
                when nd_decl_const=>
                  put_line(graph,"nd_decl_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_const_"&Trim(i'img, Ada.Strings.Left));
                when nd_decl_var=>
                  put_line(graph,"nd_decl_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_var_"&Trim(i'img, Ada.Strings.Left));
                when nd_decl_t=>
                  put_line(graph,"nd_decl_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_t_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.decl_real,i);

            when nd_dcamps =>
              if p.dcamps_dcamps/=null then
                i:=i+1;
                put_line(graph,"nd_dcamps_"&Trim(j'img, Ada.Strings.Left)&" -> nd_dcamps_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.dcamps_dcamps,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_dcamps_"&Trim(j'img, Ada.Strings.Left)&" -> nd_dcamp_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dcamps_dcamp,i);

            when nd_dcamp =>
              i:=i+1;
              put_line(graph,"nd_decl_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_var_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dcamp_decl,i);

            when nd_decl_var =>
              if p.dvar_lid/=null then
                i:=i+1;
                put_line(graph,"nd_decl_var_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lid_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.dvar_lid,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_decl_var_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dvar_tipus,i);

            when nd_decl_const =>
              null; --No esta completo aun!!!

            when nd_decl_t =>
              i:=i+1;
              put_line(graph,"nd_decl_t_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dt_id,i);
              i:=i+1;
              case p.dt_cont.tn is
                when nd_decl_t_cont_type=>
                  put_line(graph,"nd_decl_t_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_t_cont_type_"&Trim(i'img, Ada.Strings.Left));
                when nd_decl_t_cont_record=>
                  put_line(graph,"nd_decl_t_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_t_cont_record_"&Trim(i'img, Ada.Strings.Left));
                when nd_decl_t_cont_arry=>
                  put_line(graph,"nd_decl_t_"&Trim(j'img, Ada.Strings.Left)&" -> nd_decl_t_cont_arry_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.dt_cont,i);

            when nd_decl_t_cont_type =>
              i:=i+1;
              put_line(graph,"nd_decl_t_cont_type_"&Trim(j'img, Ada.Strings.Left)&" -> nd_rang_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dtcont_rang,i);

            when nd_decl_t_cont_record =>
              i:=i+1;
              put_line(graph,"nd_decl_t_record_"&Trim(j'img, Ada.Strings.Left)&" -> nd_dcamps_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dtcont_camps,i);


            when nd_decl_t_cont_arry =>
              i:=i+1;
              put_line(graph,"nd_decl_t_cont_arry_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lid_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dtcont_idx,i);
              i:=i+1;
              put_line(graph,"nd_decl_t_cont_arry_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.dtcont_tipus,i);


            when nd_rang =>
              null;

            when nd_idx =>
              i:=i+1;
              put_line(graph,"nd_idx_"&Trim(j'img, Ada.Strings.Left)&" -> nd_idx_cont_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.idx_cont,i);

            when nd_idx_cont =>
              i:=i+1;
              if p.idxc_valor.tn=nd_id then
                put_line(graph,"nd_idx_cont_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
              else
                put_line(graph,"nd_idx_cont_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lit_"&Trim(i'img, Ada.Strings.Left));
              end if;
              put(q,p.idxc_valor,i);

            when nd_sents  =>
              i:=i+1;
              put_line(graph,"nd_sents_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_nob_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.sents_cont,i);


            when nd_sents_nob  =>
              if p.snb_snb/=null then
                i:=i+1;
                put_line(graph,"nd_sents_nob_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_nob_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.snb_snb,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_sents_nob_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sent_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.snb_sent,i);

            when nd_sent =>
              i:=i+1;
              case p.sent_sent.tn is
                when nd_siter =>
                  put_line(graph,"nd_sent_"&Trim(j'img, Ada.Strings.Left)&" -> nd_siter_"&Trim(i'img, Ada.Strings.Left));
                when nd_scond =>
                  put_line(graph,"nd_sent_"&Trim(j'img, Ada.Strings.Left)&" -> nd_scond_"&Trim(i'img, Ada.Strings.Left));
                when nd_scrida =>
                  put_line(graph,"nd_sent_"&Trim(j'img, Ada.Strings.Left)&" -> nd_scrida_"&Trim(i'img, Ada.Strings.Left));
                when nd_sassign=>
                  put_line(graph,"nd_sent_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sassign_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.sent_sent,i);

            when nd_siter =>
              i:=i+1;
              put_line(graph,"nd_siter_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.siter_expr,i);
              i:=i+1;
              put_line(graph,"nd_siter_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.siter_sents,i);


            when nd_scond =>
              i:=i+1;
              put_line(graph,"nd_scond_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.scond_expr,i);
              i:=i+1;
              put_line(graph,"nd_scond_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.scond_sents,i);
              if p.scond_esents/=null then
                i:=i+1;
                put_line(graph,"nd_scond_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.scond_esents,i);
              end if;

            when nd_scrida =>
              i:=i+1;
              put_line(graph,"nd_scrida_"&Trim(j'img, Ada.Strings.Left)&" -> nd_ref_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.scrida_ref,i);

            when nd_sassign =>
              i:=i+1;
              put_line(graph,"nd_sassign_"&Trim(j'img, Ada.Strings.Left)&" -> nd_ref_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.sassign_ref,i);
              i:=i+1;
              put_line(graph,"nd_sassign_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.sassign_expr,i);

            when nd_ref =>
              i:=i+1;
              put_line(graph,"nd_ref_"&Trim(j'img, Ada.Strings.Left)&" -> nd_qs_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.ref_qs,i);

            when nd_qs =>
              i:=i+1;
              put_line(graph,"nd_qs_"&Trim(j'img, Ada.Strings.Left)&" -> nd_qs_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.qs_qs,i);
              i:=i+1;
              put_line(graph,"nd_qs_"&Trim(j'img, Ada.Strings.Left)&" -> nd_q_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.qs_q,i);

            when nd_q =>
              i:=i+1;
              case p.q_contingut.tn is
                when nd_lexpr=>
                  put_line(graph,"nd_q_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lexpr_"&Trim(i'img, Ada.Strings.Left));
                when nd_id =>
                  put_line(graph,"nd_q_"&Trim(j'img, Ada.Strings.Left)&" -> nd_id_"&Trim(i'img, Ada.Strings.Left));
                when others => null;
              end case;
              put(q,p.q_contingut,i);


            when nd_expr =>
              i:=i+1;
              case p.expr_e.tn is
                when nd_and =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_and_"&Trim(i'img, Ada.Strings.Left));
                when nd_or =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_or_"&Trim(i'img, Ada.Strings.Left));
                when nd_eop =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
                when others => null;
              end case;
              put(q,p.expr_e,i);

            when nd_and =>
              i:=i+1;
              case p.e_ope.tn is
                when nd_and=>
                  put_line(graph,"nd_and_"&Trim(j'img, Ada.Strings.Left)&" -> nd_and_"&Trim(i'img, Ada.Strings.Left));
                when nd_eop=>
                  put_line(graph,"nd_and_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.e_ope,i);
              i:=i+1;
              put_line(graph,"nd_and_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.e_opd,i);


            when nd_or =>
              i:=i+1;
              case p.e_ope.tn is
                when nd_and=>
                  put_line(graph,"nd_or_"&Trim(j'img, Ada.Strings.Left)&" -> nd_or_"&Trim(i'img, Ada.Strings.Left));
                when nd_eop=>
                  put_line(graph,"nd_or_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.e_ope,i);
              i:=i+1;
              put_line(graph,"nd_or_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.e_opd,i);

            when nd_eop =>
              if p.eop_ope/=null then
                i:=i+1;
                put_line(graph,"nd_eop_"&Trim(j'img, Ada.Strings.Left)&" -> nd_eop_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.eop_ope,i);
              end if;
              if p.eop_operand/=nul then
                i:=i+1;
                put_line(graph,"nd_eop_"&Trim(j'img, Ada.Strings.Left)&" -> nd_op_"&p.eop_operand'img&"_"&Trim(i'img, Ada.Strings.Left));
              end if;
              i:=i+1;
              put_line(graph,"nd_eop_"&Trim(j'img, Ada.Strings.Left)&" -> nd_et_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.eop_opd,i);


            when nd_et =>
              i:=i+1;
              case p.et_cont.tn is
                when nd_ref =>
                  put_line(graph,"nd_et_"&Trim(j'img, Ada.Strings.Left)&" -> nd_ref_"&Trim(i'img, Ada.Strings.Left));
                when nd_expr =>
                  put_line(graph,"nd_et_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
                when nd_lit =>
                  put_line(graph,"nd_et_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lit_"&Trim(i'img, Ada.Strings.Left));
                when others => null;
              end case;
              put(q,p.et_cont,i);


            when nd_lexpr =>
              if p.lexpr_cont /= null then
                i:=i+1;
                put_line(graph,"nd_lexpr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lexpr_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.lexpr_cont,i);
              end if;
              i:=i+1;
              put_line(graph,"nd_lexpr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.lexpr_expr,i);


            when others=>
              null;
          end case;
        end if;
      end loop;
        put_line(graph,"}");
        close(graph);
    end if;
  end imprimir_arbre;
end semantica.missatges;
