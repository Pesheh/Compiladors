#!/bin/bash
../0_Eines_Auxiliars/0_Aflex_Ayacc/0_Aflex/aflex -E  kobal.l
gnatchop -w kobal_io.a
gnatchop -w kobal_dfa.a
gnatchop -w kobal.a
