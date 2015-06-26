package semantica.g_codi_ass is

  procedure gen_codi_ass;
  procedure prepara_g_codi_ass(nomf: in String);


private
  type registre is (
    eax,
    ebx,
    ecx,
    edx,
    esi,
    edi,
    ebp,
    esp);
end semantica.g_codi_ass;
