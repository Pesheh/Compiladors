#!/bin/bash
aflex -E  pershe.l
gnatchop -w pershe_io.a
gnatchop -w pershe_dfa.a
gnatchop -w pershe.a
gnatmake -P ../../make.gpr
