#define N 5
active proctype ARRAY() {
    int a[N];
    int prod = 1;
    int i = 0;
    int num = 1;
    
    do
    :: i<= 4 ->
        if
        ::num = 1;
        ::num = 2;
        ::num = 3;
        ::num = 4;
        ::num = 5;
        fi
        a[i] = num;
        prod = prod * a[i];
        i++;
    :: i>4 -> break;
    od

    assert (prod> 0);

    i=0;

    do
    :: i<=4 ->
        assert(prod > a[i]);
        i++;
    :: i > 4 ->break;
    od

    assert(prod > 1);

    printf("El producto es: %d \n", prod)
}