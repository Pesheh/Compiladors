with d_queue; use d_queue;
with decls; use decls;
with Ada.text_io; use Ada.text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Fixed;
use Ada.Strings.Fixed;
package body semantica.missatges is
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

            when nd_sents	=>
              i:=i+1;
              put_line(graph,"nd_sents_"&Trim(j'img, Ada.Strings.Left)&" -> nd_sents_nob_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.sents_cont,i);


            when nd_sents_nob	=>
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
                when nd_e0 =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e0_"&Trim(i'img, Ada.Strings.Left));
                when nd_e1 =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e1_"&Trim(i'img, Ada.Strings.Left));
                when nd_e2 =>
                  put_line(graph,"nd_expr_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
                when others => null;
              end case;
              put(q,p.expr_e,i);

            when nd_e0 =>
              i:=i+1;
              case p.e_ope.tn is
                when nd_e0=>
                  put_line(graph,"nd_e0_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e0_"&Trim(i'img, Ada.Strings.Left));
                when nd_e2=>
                  put_line(graph,"nd_e0_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.e_ope,i);
              i:=i+1;
              put_line(graph,"nd_e0_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.e_opd,i); 


            when nd_e1 =>
              i:=i+1;
              case p.e_ope.tn is
                when nd_e0=>
                  put_line(graph,"nd_e1_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e1_"&Trim(i'img, Ada.Strings.Left));
                when nd_e2=>
                  put_line(graph,"nd_e1_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
                when others=> null;
              end case;
              put(q,p.e_ope,i);
              i:=i+1;
              put_line(graph,"nd_e1_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.e_opd,i); 

            when nd_e2 =>
              if p.e2_ope/=null then
                i:=i+1;
                put_line(graph,"nd_e2_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e2_"&Trim(i'img, Ada.Strings.Left));
                put(q,p.e2_ope,i); 
              end if;
              if p.e2_operand/=nul then
                i:=i+1;
                put_line(graph,"nd_e2_"&Trim(j'img, Ada.Strings.Left)&" -> nd_op_"&p.e2_operand'img&"_"&Trim(i'img, Ada.Strings.Left));
              end if;
              i:=i+1;
              put_line(graph,"nd_e2_"&Trim(j'img, Ada.Strings.Left)&" -> nd_e3_"&Trim(i'img, Ada.Strings.Left));
              put(q,p.e2_opd,i); 


            when nd_e3 =>
              i:=i+1;
              case p.e3_cont.tn is
                when nd_ref =>
                  put_line(graph,"nd_e3_"&Trim(j'img, Ada.Strings.Left)&" -> nd_ref_"&Trim(i'img, Ada.Strings.Left));
                when nd_expr =>
                  put_line(graph,"nd_e3_"&Trim(j'img, Ada.Strings.Left)&" -> nd_expr_"&Trim(i'img, Ada.Strings.Left));
                when nd_lit =>
                  put_line(graph,"nd_e3_"&Trim(j'img, Ada.Strings.Left)&" -> nd_lit_"&Trim(i'img, Ada.Strings.Left));
                when others => null;
              end case;
              put(q,p.e3_cont,i);


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
