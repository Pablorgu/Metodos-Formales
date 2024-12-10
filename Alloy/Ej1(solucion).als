module ejercicio1
//signaturas
sig Color {}
sig Objeto {
	color: one Color
}

sig Caja {
	contiene : set Objeto
}
//hechos
fact{
//cada objeto está en una sola caja
all o: Objeto | one contiene.o

}

//predicados

pred show(){}

run show for 5

//1) alguna caja con todos los objetos del mismo color
pred mismoColorCaja(){
	some c:Caja | one (c.contiene).color
}

run mismoColorCaja for 5

//2) alguna caja con más de dos objetos y todos de distinto color
pred distintoColorCaja(c: Caja){
  	#(c.contiene) > 2
	//tiene tantos objetos como colores diferentes
	#c.contiene = #(c.contiene.color)
	//otra opcion para la segunda restricción
	//all disj o1,o2: c.contiene| o1.color!= o2.color
}
run distintoColorCaja
