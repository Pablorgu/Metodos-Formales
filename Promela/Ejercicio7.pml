mtype = {cLeche, cPuro};   // Tipos de chocolate: con leche o puro
chan monedas = [0] of {int}; // Canal para insertar monedas
chan chocolate = [0] of {mtype}; // Canal para recibir chocolate

active proctype Maquina() {
    int m; // cantidad de dinero insertada

    do
    :: monedas?m ->         // Espera a que el cliente inserte monedas
        if
        :: m == 75 ->       // Si el cliente inserta 75 céntimos
            printf("Vendiendo barrita de chocolate con leche\n");
            chocolate!cLeche;  // Enviar chocolate con leche al cliente
        :: m == 100 ->      // Si el cliente inserta 1 euro
            printf("Vendiendo barrita de chocolate puro\n");
            chocolate!cPuro;   // Enviar chocolate puro al cliente
        :: else ->          // Si el cliente inserta una cantidad inválida
            printf("Cantidad no válida: %d céntimos\n", m);
        fi
    od
}

active proctype Cliente() {
    do
    :: 
        if
        :: monedas!75;   // Cliente inserta 75 céntimos para chocolate con leche
            chocolate?cLeche -> printf("Cliente recibe barrita de chocolate con leche\n")
        :: monedas!100;  // Cliente inserta 1 euro para chocolate puro
            chocolate?cPuro -> printf("Cliente recibe barrita de chocolate puro\n")
        fi
    od
}