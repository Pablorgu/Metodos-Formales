active proctype NONDET() {
    do
    :: true -> printf("1\n")
    :: true; printf("2\n")
    :: else -> printf("3\n")
    od
}
