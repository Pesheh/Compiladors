#!/bin/bash
./aflex -E  kobal.l
gnatchop -w kobal_io.a
gnatchop -w kobal_dfa.a
gnatchop -w kobal.a
