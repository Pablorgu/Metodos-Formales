#define BAJA 0
#define SUBE 1
#define ABRE 0
#define CIERRA 1

chan ctrACabina = [0] of {bit}
chan ctrAPuerta[3] = [0] of {bit}

proctype Puerta (int numero){

    CERRADA:
    if
    :: ctrAPuerta[numero]?ABRE -> goto ABIERTA;
    :: ctrAPuerta[numero]?CIERRA -> goto CERRADA;
    fi

    ABIERTA:
    if
    :: ctrAPuerta[numero]?ABRE; goto ABIERTA;
    :: ctrAPuerta[numero]?CIERRA; goto CERRADA;
    fi
    
}

proctype Cabina() {
    P0: 
    printf("Cabina en Planta 0. ")
    do
    :: ctrACabina?SUBE; goto P1;
    :: ctrACabina?BAJA; goto P0;
    od

    P1:
    printf("Cabina en Planta 1. ")
    do
    :: ctrACabina?SUBE;goto P2;
    :: ctrACabina?BAJA;goto P1;
    od

    P2:
    printf("Cabina en Planta 2. ")
    do
    :: ctrACabina?SUBE; goto P2;
    :: ctrACabina?BAJA; goto P1;
    od
}

proctype Controlador(){
    libre0:
    ctrAPuerta[0]!CIERRA;

    ocupada0:
    do
    :: ctrAPuerta[0]!ABRE; goto libre0;
    :: ctrACabina!SUBE;goto ocupada1;
    :: ctrACabina!SUBE; goto _0a2;
    od

    _0a2:
    ctrACabina!SUBE; goto ocupada2;

    libre1:
    ctrAPuerta[1]!CIERRA; goto ocupada1;

    ocupada1:
    do
    ::ctrAPuerta[1]!ABRE; goto libre1;
    ::ctrACabina!SUBE; goto ocupada2;
    ::ctrACabina!BAJA; goto ocupada0;
    od

    _2a0:
    ctrACabina!BAJA; goto ocupada0;

    libre2:
    ctrAPuerta[2]!CIERRA; goto ocupada2;

    ocupada2:
    do
    :: ctrAPuerta[2]!ABRE; goto libre2;
    :: ctrACabina!BAJA; goto ocupada1;
    :: ctrACabina!BAJA; goto _2a0;
    od
}

init{
    run Controlador();
    run Cabina();
    run Puerta(0);
    run Puerta(1);
    run Puerta(2);
}

ltl no_mas_de_una {[]<>!((Puerta[0]@ABIERTA && Puerta[1]@ABIERTA) || (Puerta[1]@ABIERTA && Puerta[2]@ABIERTA) || (Puerta[2]@ABIERTA && Puerta[0]@ABIERTA))}