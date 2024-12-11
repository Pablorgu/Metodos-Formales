//familia con alloy 6
abstract sig Persona{
	var hijos :set  Persona, 
	var hermanos: set Persona
}

var sig PersonaViva in Persona {}

fact{
	//1) una persona no puede ser su propio antepasado
	always no p: Persona | p in antepasados[p]
	//2) nadie tiene más de dos progenitores (no es hijo de más de dos personas)
	always all p:Persona |  #progenitores[p] <=2
	//3) Los hermanos son personas distintas que comparten algún progenitor,  en otro caso no tiene hermanos
	always all p: Persona | some progenitores[p] implies 
			p.hermanos = {h:Persona-p |  progenitores[p] = progenitores[h]}
		else no p.hermanos
}

fun progenitores[p: Persona] : set Persona{
	hijos.p
}
fun antepasados[p:Persona] : set Persona{
	p.^(~hijos)
}

pred vivosNoCambiaExcepto(pp: set Persona){
	all p: PersonaViva - pp | p in PersonaViva' // las personas vivas que no están en pp sigue vivas
	all p: Persona - PersonaViva - pp | p not in PersonaViva' // las personas no vivas que no son pp siguen si estar vivas
}

pred hijosNoCambianExcepto(pp: set Persona){
	all p: Persona - pp | p.hijos' = p.hijos
}

pred nacerDeMadre(madre: Persona){
	//pre	
	madre in PersonaViva
	one h: Persona | 

		h not in PersonaViva and 
		no progenitores[h] and
	//pos
		h in PersonaViva' and
		madre.hijos' = madre.hijos + h and // antes ponia madre = hijos'.h y estaba mal porque permitimos que cambien los hijos de madre
	//c.marco
		vivosNoCambiaExcepto[h] and
		hijosNoCambianExcepto[madre]

}

run { #hijos >0 and some m: Persona | nacerDeMadre[m] } for 5
