#define BAJA 0
#define SUBE 1
#define ABRE 0
#define CIERRA 1

chan ctrACabina = [0] of {bit}; // Control de la cabina
chan ctrAPuerta[3] = [0] of {bit}; // Control de cada puerta

byte estadoPuerta[3] = {0, 0, 0}; // Estado de cada puerta (cerrada = 0, abierta = 1)
byte estadoPlanta = 0; // Planta actual de la cabina

// Proceso Puerta
active [3] proctype Puerta() {
    byte planta = _pid; // Planta correspondiente a cada puerta

    do
    :: ctrAPuerta[planta]?ABRE ->
        estadoPuerta[planta] = 1; // La puerta se abre
    :: ctrAPuerta[planta]?CIERRA ->
        estadoPuerta[planta] = 0; // La puerta se cierra
    od
}

// Proceso Cabina
active proctype Cabina() {
    bit movimiento;

    do
    :: ctrACabina?movimiento ->
        if
        :: (movimiento == SUBE && estadoPlanta < 2) -> estadoPlanta = estadoPlanta + 1
        :: (movimiento == BAJA && estadoPlanta > 0) -> estadoPlanta = estadoPlanta - 1
        fi;
    od
}

// Proceso Controlador
active proctype Controlador() {
    byte planta_actual = 0;

    do
    :: planta_actual == 0 ->
        ctrAPuerta[planta_actual]!ABRE;
        ctrAPuerta[planta_actual]!CIERRA;
        ctrACabina!SUBE;
        planta_actual = 1;

    :: planta_actual == 1 ->
        ctrAPuerta[planta_actual]!ABRE;
        ctrAPuerta[planta_actual]!CIERRA;
        if
        :: ctrACabina!SUBE; planta_actual = 2;
        :: ctrACabina!BAJA; planta_actual = 0;
        fi;

    :: planta_actual == 2 ->
        ctrAPuerta[planta_actual]!ABRE;
        ctrAPuerta[planta_actual]!CIERRA;
        ctrACabina!BAJA;
        planta_actual = 1;
    od
}

// Propiedades LTL
ltl solo_una_puerta_abierta {
    [] (!(estadoPuerta[0] && estadoPuerta[1]) && !(estadoPuerta[0] && estadoPuerta[2]) && !(estadoPuerta[1] && estadoPuerta[2]))
}

ltl puerta_cabina_misma_planta {
    [] (!(estadoPuerta[0] && (estadoPlanta != 0)) && !(estadoPuerta[1] && (estadoPlanta != 1)) && !(estadoPuerta[2] && (estadoPlanta != 2)))
}
