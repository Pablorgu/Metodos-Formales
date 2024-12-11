module Ej3Din

sig Planta{}

sig Ascensor{
	var ascPlanta: one Planta,
	var ascPersonas : set Persona
}

sig Edificio{
	edifPlantas: some Planta,
	edifAscensores : set Ascensor
}

sig Persona{
	var edificio: lone Edificio,
	var ascensor: lone Ascensor
}

fact {
	always all p:Planta | one edifPlantas.p
	
	always all a:Ascensor | one edifAscensores.a

	always all e:Edificio | #e.edifAscensores < #e.edifPlantas

	always all e:Edificio | #e.edifPlantas < 3 implies no e.edifAscensores

	always all e:Edificio | #e.edifPlantas > 3 implies some e.edifAscensores

	always all a : Ascensor | a.ascPlantas in (edifAscensores.a).edifPlantas

	always all p: Persona | one p.ascensor implies p.edifcio = edifAscensores.(p.ascensor)

	always ascPersonas = ~ascensor
}
