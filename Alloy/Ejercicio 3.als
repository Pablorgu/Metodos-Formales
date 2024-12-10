sig Planta{}
sig Ascensor{
	ascPlantas: one Planta,
	ascPersonas: set Persona
}
sig Edificio{
	edifPlantas: some Planta,
	edifAscensores: set Ascensor //puede no tener
	
}
sig Persona{
	edificio: lone Edificio,
	ascensor: lone Ascensor
}

fact{
//1)cada planta esta exactamente en un edificio
all p: Planta |  one edifPlantas.p

//2)Cada ascensor esta exactamente en un edificio
all a:Ascensor | one edifAscensores.a

//3)El numero de ascensores de un edificio es estrictamente menor que el numero de plantas del edificio
all e: Edificio | #e.edifPlantas > #e.edifAscensores

//4)Si un edificio tiene menos de 3 plantas entonces no tiene ascensores
all e: Edificio |  #e.edifPlantas < 3 implies no e.edifAscensores

//5)Si un edificio tiene mas de 3 plantas entocnes tiene algún ascensor
all e: Edificio | #e.edifPlantas >3 implies some e. edifAscensores

//6)Cada ascensor se encuentra en una planta del edificio al que pertenece
all a:Ascensor | a.ascPlantas in (edifAscensores.a).edifPlantas

//7)Si una persona está en un ascensor, entonces debe encontrarse tambien en el edificio en el que está dicho ascensor
all p:Persona | one p.ascensor implies p.edificio = edifAscensores.(p.ascensor)

//8)La relacion ascPersonas contiene exactamente a las personas que están en el ascensor
ascPersonas = ~ascensor
}

pred show{}

run show for 5 but exactly 2 Edificio

pred enEdificioNoAscensor(p:Persona){
	one p.edificio and no p.ascensor
}

run enEdificioNoAscensor

pred dosEnAscensor(a:Ascensor) {
	#a.ascPersonas=2
}

run dosEnAscensor

pred todosAscensoresEnUnaPlanta(e:Edificio) {
	one (e.edifAscensores).ascPlantas
}

run todosAscensoresEnUnaPlanta

pred plantaAscensorDiferentes(e:Edificio){
	#e.edifAscensores >1
	#(e.edifAscensores.ascPlantas) = #e.edifAscensores
}

run plantaAscensorDiferentes
