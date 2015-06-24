with decls.d_descripcio; use decls.d_descripcio;
package semantica.c_tipus is

  procedure comprovacio_tipus (err: out boolean);
  -- valors de true i false a la tv
  procedure posa_entorn_standard (c, f: out num_var);

end semantica.c_tipus;
