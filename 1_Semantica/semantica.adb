with Ada.Text_IO; --TMP
with semantica.missatges;
with semantica.g_codi_int;
with semantica.g_codi_ass;
package body semantica is

--procedure print_arbre is
--begin
--  missatges.imprimir_arbre(root);
--end print_arbre;

  procedure prepara_analisi(nomf: in String) is
  begin
  -- FALTA DEFINIR::  prepara_missatges(nomf);
    -- guarda el nom del fitxer
    -- per si mes tard s'ha d'emprar
    semantica.g_codi_int.prepara_g_codi_int(nomf);
    semantica.g_codi_ass.prepara_g_codi_ass(nomf);

    empty(tn);
    empty(ts);

    nv:= null_nv;
    np:= null_np;
    ne:= null_ne;

    ERROR:= false;

  end prepara_analisi;

  procedure conclou_analisi is
  begin
    null;
  -- FALTA DEFINIR  conclou_missatges;
  end conclou_analisi;


end semantica;
