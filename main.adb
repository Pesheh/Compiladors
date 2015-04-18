with a_lexic; use a_lexic;
with a_sintactic; use a_sintactic;
with decls; use decls;
with decls.d_tnoms; use decls.d_tnoms;
with decls.d_tsimbols; use decls.d_tsimbols;
with semantica; use semantica;
with semantica.c_arbre; use semantica.c_arbre;
with semantica.c_tipus; use semantica.c_tipus;
with semantica.g_codi_int; use semantica.g_codi_int; -- ja inclos a c_tipus. Mentre sigui per compilar, pot estar comentat
procedure main is
begin 
  Open("cp.kb");
  yyparse;
  Close;
  print_arbre;
  posa_entorn_standard;
  gen_codi_int;
end main;
