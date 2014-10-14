rem Run aflex and Ayacc and chop the output files 
ayacc %1.y
aflex %2.l
call gnatchop %2_io.a
call gnatchop %2_dfa.a
call gnatchop %2.a
call gnatchop %1.a
gnatmake %3

