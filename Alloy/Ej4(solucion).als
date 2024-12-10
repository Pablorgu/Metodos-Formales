module ej4
//signaturas
sig Banda {
	miembros : set Interno
}

sig Interno {
	celda : one Celda
}

sig Celda {}

//hechos
fact{
//a) Un preso no puede pertenecer a más de una banda 
no i: Interno |  #miembros.i>1
//b) Una banda no puede tener 0 miembros
no b: Banda | no b.miembros
//3) seguridad tiene que implicar felicidad
asigSegura implies asigFeliz
}
//predicados
// en una celda no hay internos de diferentes bandas
pred asigSegura(){
all c: Celda |  lone miembros.(celda.c)
}

run asigSegura

//los miembros de una banda comparten celda solo con miembros de su banda
pred asigFeliz(){
all i1: Interno, i2: celda.(i1.celda) | one miembros.i1 implies miembros.i1 = miembros.i2
}

assert seguridadImplicaFelicidad{
	asigSegura implies asigFeliz
}
check seguridadImplicaFelicidad


pred show(){
#Banda >1
#miembros>0
//#Celda = 1
asigSegura
}

run show for 5
