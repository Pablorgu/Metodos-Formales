module ej2
//signaturas
sig Llave {}
sig Cliente {
	llave: lone Llave
}

sig Hotel{
	hab: set Habitacion
}
sig Habitacion{
	llaves: set Llave,
	llaveActual : one Llave,
	ocupacion : lone Cliente
}

//hechos
fact{
//1) cada habitación pertenece a un hotel exactamente
all h: Habitacion | one hab.h 	
//2) las llaves de las habitaciones son dijuntas (las habitaciones no comparten llaves)
all disj h1, h2:Habitacion | no (h1.llaves & h2.llaves )
//3) Todas las habitaciones tienen al menos una llave asociada
all h:Habitacion | some h.llaves
//4) La llave actual de cada habitación es una de sus llaves
all h: Habitacion | h.llaveActual in h.llaves
//5) Cada cliente ocupa a lo sumo una habitación 
all c: Cliente | lone ocupacion.c
//6) Si un cliente ocupa una habitación, entonces su llave es la llaveActual
all c:Habitacion.ocupacion | c.llave = (ocupacion.c).llaveActual
// all c:Cliente | some ocupacion.c implies c.llave = (ocupacion.c).llaveActual
//7) Si un cliente no ocupa una habitación, entonces no tiene llave
all c: Cliente- Habitacion.ocupacion | no c.llave
//all c:Cliente | no ocupacion.c implies no c.llave
}


//predicados


pred show(){}

run show for 5
