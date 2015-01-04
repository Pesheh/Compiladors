#!/usr/bin/bash

../../1_Paquets_i_Eines_Auxiliars/0_Eines_Auxiliars/0_Aflex_Ayacc/1_Ayacc/ayacc pershe.y Off Off On On On

gnatchop -w pershe.a
gnatchop -w pershe_error_report.a
