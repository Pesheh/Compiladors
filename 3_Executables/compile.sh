#!/bin/bash
gcc -c -m32 stdio.s -o stdio.o
if [ $1 ]; then
  ./main $1
  f=$(echo $1 | sed 's/\.kb$//')
  gcc -c -m32 $f.s -o $f.o
  gcc -m32 -o $f.exe stdio.o $f.o
else
  for f in *.kb
  do
    x=${f%.kb}
    echo "$x"
    ./main $f
    gcc -c -m32 $x.s -o $x.o
    gcc -m32 -o $x.exe stdio.o $x.o
  done
fi
rm *.o *.c3a 
