#Compiladors

##Relació codi instrucció-instrucció generada
|       Codi        |       Instrucció                |
|:-----------------:|:-------------------------------:|
|       CP          |       arg1**:=** arg2               |
|     CP_IDX        |       arg1**[**arg2**]:=** arg3         |
|     CONS_IDX      |       arg1**:=** arg2**[**arg3**]**         |
|     SUM           |       arg1**:=** arg2 **+** arg3        |
|     RES           |       arg1**:=** arg2 **-** arg3        |
|     MUL           |       arg1**:=** arg2 * arg3        |
|     DIV           |       arg1**:=** arg2 **/** arg3        |
|     MODUL         |       arg1**:=** arg2 **mod** arg3      |
|     NEG           |       arg1**:=     -**arg2              |
|     OP_NOT        |       arg1**:=** **not** arg2           |
|     OP_AND        |       arg1**:=** arg2 **and** arg3      |
|     OP_OR         |       arg1**:=** arg2 **or** arg3       |
|     ETIQ          |       arg1**: skip**                |
|     GO_TO         |       **goto** arg1                 |
|     IEQ_GOTO      |       **if** arg2 **=** arg3 **goto** arg1  |
|     GT            |       arg1**:=** arg2 **>** arg3        |
|     GE            |       arg1**:=** arg2 **>=** arg3       |
|     EQ            |       arg1**:=** arg2 **=** arg3        |
|     NEQ           |       arg1**:=** arg2 **/=** arg3       |
|     LE            |       arg1**:=** arg2 **<=** arg3       |
|     LT            |       arg1**:=** arg2 **<** arg3        |
|     PMB           |       **pmb** arg1                  |
|     RTN           |       **rtn** arg1                  |
|     PARAMS        |       **params** arg1               |
|     PARAMC        |       **paramc** arg1**[**arg2**]**         |
|     CALL          |       **call** arg1                 |
