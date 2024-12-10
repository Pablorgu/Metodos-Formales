chan papelMesa = [0] of {bit};
chan tabacoMesa = [0] of {bit};
chan cerillasMesa = [0] of {bit};
chan agenteMesa = [0] of {short};

active proctype fumadorPapel() {
    inicio:
    if
    :: papelMesa?1 -> goto fumando;
    fi

    fumando:
    printf("Fumador PAPEL fumando\n");

    terminado:
    papelMesa!0;
    goto inicio;
}

active proctype fumadorCerillas() {
    inicio:
    if
    :: cerillasMesa?1 -> goto fumando;
    fi

    fumando:
    printf("Fumador CERILLAS fumando\n");

    terminado:
    cerillasMesa!0;
    goto inicio;
}

active proctype fumadorTabaco() {
    inicio:
    if
    :: tabacoMesa?1 -> goto fumando;
    fi

    fumando:
    printf("Fumador TABACO fumando\n");

    terminado:
    tabacoMesa!0;
    goto inicio;
}

active proctype mesa() {
    short fumador;
    inicio:
    agenteMesa?fumador;

    mesaLlena:
    if
    ::fumador == 1 -> papelMesa!1;
    ::fumador == 2 -> tabacoMesa!1;
    ::fumador == 3 -> cerillasMesa!1;
    fi

    mesaVacia:
    if
    ::fumador == 1 -> papelMesa?0;
    ::fumador == 2 -> tabacoMesa?0;
    ::fumador == 3 -> cerillasMesa?0;
    fi
    fumador = 0;
    agenteMesa!0;
    goto inicio;
}

active proctype agente() {
    inicio:
    if
    ::agenteMesa!1;
    agtab: skip;
    ::agenteMesa!2;
    agpapel: skip;
    ::agenteMesa!3;
    agcer: skip;
    fi
    agenteMesa?0;
    goto inicio;
}

ltl p1 {[]<>mesa@mesaLlena}

ltl p2 {[]<>(mesa@mesaVacia && (fumadorCerillas@fumando || fumadorCerillas@fumando || fumadorPapel@fumando))}

ltl p3 {[]<>(mesa@mesaLlena && mesa:fumador == 3)}

ltl p4 {([]<> agente@agcer []<> agente@agpapel && []<> agente@agtab) -> []<>(mesa@mesaLlena && mesa:fumador == 3)}