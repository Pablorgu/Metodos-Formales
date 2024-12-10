module ej3
//signaturas
sig Planta {}
sig Ascensor {
	ascPlantas : one Planta,
	ascPersonas: set Persona
}
sig Edificio {
	edifPlantas: some Planta,
	edifAscensores: set Ascensor //puede no tener ascensor?
}
sig Persona {
	edificio : lone Edificio,
	ascensor : lone Ascensor
}

//hechos
fact{
//1) cada planta está exactamente en un edificio
all p: Planta| one edifPlantas.p

//2) Cada ascensor está exactamente en un edificio
all a: Ascensor | one edifAscensores.a 

//3) El número de ascensores de un edificio es estrictamente menor que el número de plantas
all e:Edificio | #e.edifAscensores < #e.edifPlantas

//4) Si un edificio tiene menos de 3 plantas, entonces no tiene ascensores
all e: Edificio | #e.edifPlantas<3 implies no e.edifAscensores

//5) Si un edificio tiene más de 3 plantas entonces tiene algún ascensor
all e: Edificio | #e.edifPlantas >3 implies some e.edifAscensores

//6) Cada ascensor se encuentra en una planta del edificio al que pertenece
all a:Ascensor | a.ascPlantas in (edifAscensores.a).edifPlantas

//7) si una persona está en un ascensor, entonces debe encontrarse también en el edificio de dicho ascensor
all p: Persona | one p.ascensor implies p.edificio = edifAscensores.(p.ascensor)

//8) la realación asctPersonas contiene exactamente a las personas que están en el ascensor
 ascPersonas = ~ascensor
}

//predicados

pred show(){
	//#edifAscensores = 0
	//some e:Edificio | #e.edifPlantas>3
}

run show  for 5 but exactly 2 Edificio

pred enEdificioNoAscensor(p: Persona){
	one p.edificio and no p.ascensor
}

run enEdificioNoAscensor

pred dosEnAscensor(a:Ascensor){
	#a.ascPersonas = 2
}
run dosEnAscensor

pred todosAscEnMismaPlanta(e: Edificio){
	one	(e.edifAscensores).ascPlantas
}

run todosAscEnMismaPlanta

pred todosAscDistintaPlanta(e:Edificio){
	#e.edifAscensores >1 //para que me salgan instancias no triviales
	#(e.edifAscensores.ascPlantas) = #e.edifAscensores
}

run todosAscDistintaPlanta
