bool c1 = false, c2 = false;
bool turno = 0;
int enSC = 0;

active proctype P1() {
    do
    :: true ->
       printf ("Seccion no critica 1\n");
       c1 = true;
       turno=1;
       (c2==false || turno == 0);
       enSC++;
       printf ("Seccion critica 1\n");
       assert(enSC==1);
       enSC--;
       c1 = false;
    od
}

active proctype P2() {
    do
    :: true ->
       printf ("Seccion no critica 2\n");
       c2 = true;
       turno=0
       (c1==false || turno == 1);
       enSC++;
       printf ("Seccion critica 2\n");
       assert(enSC==1);
       enSC--;
       c2 = false;
    od
}
