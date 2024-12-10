module prision
sig Banda{
miembros: set Interno
}
sig Interno {
celda: Celda
}
sig Celda{}

fact{
}

run show
