#!/bin/bash
aflex -E example.l
gnatchop -w example_io.a
gnatchop -w  example_dfa.a
gnatchop -w example.a
gnatmake example.adb
