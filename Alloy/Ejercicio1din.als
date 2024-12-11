module ejercicio1din

sig Color {}

sig Objeto {
    var color: one Color
}

sig Caja {
    var contiene: set Objeto
}

//hechos
fact UnObjetoUnaCaja{
	always all o: Objeto | #contiene.o <= 1
}

//predicados

pred show(){}

run show for 5

//1) en alguna caja todos los objetos sean del mismo color
pred mismoColorCaja(){
	some c:Caja | one (c.contiene).color
}

run mismoColorCaja for 5

//2) alguna caja tenga más de dos objetos, y todos los objetos que contienen son de distinto color
pred distintoColorCaja(c: Caja){
	#(c.contiene)>2
	//tiene tantos objetos como colores diferentes
	#c.contiene = #(c.contiene.color)
	//otra opcion para la segunda restricción
	//all disj o1,o2: c.contiene | o1.color!=o2.color
}

run distintoColorCaja

pred colorNoCambiaExcepto(oo: set Objeto){
	all o: Objeto - oo | o.color' = o.color
}

pred contenidoNoCambiaExcepto(cc: set Caja){
	all c: Caja - cc | c.contiene' = c.contiene
}

//dado dos objetos que están en la misma caja y que son de diferente color, intercambia sus colores
pred cambiarColor(o1,o2: Objeto){
	//precond: los objetos estan en la misma caja
	some c:Caja | o1 in c.contiene and  o2 in c.contiene
	//precond: los objetos son de diferente color
	o1.color != o2.color

	//post: los objetos cambian de color
	o1.color' = o2.color and o2.color' = o1.color

	//marco: los demas objetos no cambian
	colorNoCambiaExcepto[o1+o2]
}

pred anadirObjeto(o: Objeto){
	//precond: el objeto no esta en ninguna caja
	#contiene.o = 0
	//postcond: el objeto se ha añadido a una caja
	some c: Caja | o in c.contiene' and
	//marco: los contenidos no cambian excepto el de esa caja
	contenidoNoCambiaExcepto[c]
}

run cambiarColor for 4 but exactly 1 Caja

run anadirObjeto for 4 but exactly 2 Caja
