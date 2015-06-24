E 9: NOP
movl  $ 0, %EAX
movl  $ 1, %EAX
E 10: NOP
movl  $ 10, %EBX
cmpl %ebx, %eax
jl  E 14
movl $-1, %ecx
jmp  E 15
E 14: NOP
movl $1, %ecx
E 15: NOP

