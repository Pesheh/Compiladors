with a_lexic; use a_lexic;
with a_sintactic; use a_sintactic;
with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with semantica; use semantica;
with semantica.c_arbre; use semantica.c_arbre;
with semantica.c_tipus; use semantica.c_tipus;
with a_sintactic; use a_sintactic;
with a_lexic; use a_lexic;

procedure main is
begin
  Open("file");
  posa_entorn_standard;
  YYParse;
  Close;
  comprovacio_tipus;
  semantica.print_arbre;
  gen_codi_int;
end main;
