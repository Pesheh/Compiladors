#!/bin/bash
../../1_Paquets_i_Eines_Auxiliars/0_Eines_Auxiliars/0_Aflex_Ayacc/0_Aflex/aflex -E  pershe.l
gnatchop -w pershe_io.a
gnatchop -w pershe_dfa.a
gnatchop -w pershe.a
gnatmake -P ../../make.gpr
