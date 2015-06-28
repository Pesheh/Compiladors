with semantica.missatges;
with semantica.g_codi_int;
with semantica.c_tipus;
with semantica.g_codi_ass;
package body semantica is

  procedure prepara_analisi(nomf: in String) is
    cert, fals: num_var;
  begin

    empty(tn);
    empty(ts);

    nv:= null_nv;
    np:= null_np;
    ne:= null_ne;

    ERROR:= false;

    semantica.c_tipus.posa_entorn_standard(cert, fals);
  -- FALTA DEFINIR::  prepara_missatges(nomf);
    -- guarda el nom del fitxer
    -- per si mes tard s'ha d'emprar
    semantica.g_codi_int.prepara_g_codi_int(nomf, cert, fals);
    semantica.g_codi_ass.prepara_g_codi_ass(nomf);
  end prepara_analisi;

  procedure conclou_analisi is
  begin
    null;
  -- FALTA DEFINIR  conclou_missatges;
  end conclou_analisi;


end semantica;
