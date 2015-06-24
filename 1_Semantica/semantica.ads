with Ada.Sequential_IO;
with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with decls.d_arbre; use decls.d_arbre;
with decls.d_c3a; use decls.d_c3a;
with d_pila;

package semantica is

  procedure prepara_analisi(nomf: in String);
  procedure conclou_analisi;

private

  tn: tnoms;
  ts: tsimbols;

  root: pnode;

  nv: num_var;
  np: num_proc;
  ne: num_etiq;

  tv: tvariables;
  tp: tprocediments;

  ERROR: boolean;

  -- Això no em sembla gaire correcte ja que sols la ct i la gc (intermitj
  -- i assemblador) requereixen aquesta pila, però l'alternativa es
  -- reinstanciar cada cop el paquet, cosa encara pitjor.
  package Pila_Procediments is new D_Pila(max_proc, elem => num_proc);

  package Instruccio_IO is new Ada.Sequential_IO(instr_3a_bin);

  pproc: Pila_Procediments.pila;
end semantica;
