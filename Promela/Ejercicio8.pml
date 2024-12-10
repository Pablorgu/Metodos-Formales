mtype = {cLeche, cPuro};   // Tipos de chocolate: con leche o puro
chan monedas = [0] of {int}; // Canal para insertar monedas
chan chocolate = [0] of {mtype}; // Canal para recibir chocolate
chan devolver = [0] of {int} ; //Canal para devolver dinero al cliente

int stockLeche = 10; //Stock de barritas de chocolate con leche
int stockPuro = 5; //Stock de barritas de chocolate puro
int caja = 0; //Cantidad de dinero acumulado en la maquina

active proctype Maquina() {
    int m; // cantidad de dinero insertada

    do
    :: monedas?m ->         // Espera a que el cliente inserte monedas
        if
        :: (stockLeche == 0 && stockPuro == 0) ->
            printf("Maquina vacia, no acepta más dinero.\n");
            devolver!m; //Devuelve el dinero si la maquina esta vacia
        :: (m == 75 && stockLeche > 0) ->       // Si el cliente inserta 75 céntimos
            printf("Vendiendo barrita de chocolate con leche\n");
            stockLeche--; //Quita la barrita del stock
            caja = caja + m; //Añade el dinero a la caja
            chocolate!cLeche;  // Enviar chocolate con leche al cliente
        :: (m == 75 && stockLeche == 0) ->
            printf("No hay chocolate con leche, devolviendo %d centimos.\n",m); 
            devolver!m; //Devuelvo el dinero ingresado
        :: (m == 100 && stockPuro > 0) ->      // Si el cliente inserta 1 euro
            printf("Vendiendo barrita de chocolate puro\n");
            stockPuro--; //Quita la barrita del stock
            caja = caja + m; //Añade el dinero a la caja
            chocolate!cPuro;   // Enviar chocolate puro al cliente
        :: (m == 100 && stockPuro == 0) ->
            printf("No hay chocolate puro, devolviendo %d céntimos.\n", m);
            devolver!m; //Devuelvo el dinero ingresado
        :: else ->          // Si el cliente inserta una cantidad inválida
            printf("Cantidad no válida: %d céntimos\n", m);
            devolver!m; //Devuelvo el dinero ingresado
        fi
    od
}

active proctype Cliente() {
    do
    :: 
        if
        :: monedas!75;   // Cliente inserta 75 céntimos para chocolate con leche
            chocolate?cLeche -> printf("Cliente recibe barrita de chocolate con leche\n");
            devolver?75 -> printf("Cliente recibe devolucion de 75 centimos.\n");
        :: monedas!100;  // Cliente inserta 1 euro para chocolate puro
            chocolate?cPuro -> printf("Cliente recibe barrita de chocolate puro\n");
            devolver?100 -> printf("Cliente recibe devolucion de 100 centimos.\n");
        fi
    od
}