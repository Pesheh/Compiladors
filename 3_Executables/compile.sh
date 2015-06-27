#!/bin/bash
gcc -c -m32 stdio.s -o stdio.o
for f in *.kb
do
  x=${f%.kb}
  echo "$x"
  ./main $f
  gcc -c -m32 $x.s -o $x.o
  gcc -m32 -o $x.exe stdio.o $x.o
done
rm *.o *.c3a 
