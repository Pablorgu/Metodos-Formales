module ej8
sig Estudiante{}
sig Asignatura{
	var matriculados: set Estudiante,
	var aprobados: set Estudiante
}
//hechos
fact{
	//1.Ninguna asignatura puede tener mas de 10 estudiantes matriculados
	always all a:Asignatura |  #a.matriculados <= 10
	
	//2. Los estudiantes aprobados deben esar matriculados en la asignatura
	always all a:Asignatura | a.aprobados in a.matriculados
}
//predicados
pred show(){}

run show for 5 but 6 Int

pred Inicio(){
	one a: Asignatura |
	#a.matriculados = 0 and
	#a.aprobados = 0
}

pred matricular(a: Asignatura, e: Estudiante) {
	//pre
	#a.matriculados <7 and e not in a.matriculados and e not in a.aprobados
	//cambio de estado a futuro
	a.matriculados' = a.matriculados + e 
	a.aprobados' = a.aprobados 
	noCambiaAprobadosResto[a] 
	noCambiaMatriculadosResto[a]
}


pred aprobar(a: Asignatura, e: Estudiante) {
	//pre
	#a.matriculados < 10 and e in a.matriculados and e not in a.aprobados
	//cambio de estado a futuro
	a.aprobados' = a.aprobados + e
	//guarda
	a.matriculados' = a.matriculados
	noCambiaAprobadosResto[a]
	noCambiaMatriculadosResto[a]
}

pred certAprobado(a:Asignatura, e:Estudiante) {
	e in a.aprobados
	a.aprobados' = a.aprobados - e
	a.matriculados'= a.matriculados-e
	noCambiaAprobadosResto[a]
	noCambiaMatriculadosResto[a]
}

pred nocertAprobado(a:Asignatura, e:Estudiante) {
	e not in a.aprobados and e in a.matriculados
	a.aprobados'=a.aprobados
	a.matriculados' = a.matriculados-e
	noCambiaAprobadosResto[a]
	noCambiaMatriculadosResto[a]
}

pred noCambiaAprobadosResto(a:Asignatura) {
	all aa: Asignatura - a | aa.aprobados' = aa.aprobados
}

pred noCambiaMatriculadosResto(a:Asignatura) {
	all aa: Asignatura - a | aa.matriculados' = aa.matriculados
}


run matricular 
run aprobar
run certAprobado 
run nocertAprobado


assert estudianteNoCertificadoSiNoAprobado {
    all a: Asignatura, e: Estudiante |
        nocertAprobado[a, e] implies e in a.aprobados
}

check estudianteNoCertificadoSiNoAprobado

pred Traza{
	Inicio
	always((one a:Asignatura, e:Estudiante | matricular[a,e]) or (one a:Asignatura, e:Estudiante | aprobar[a,e]) or (one a:Asignatura, e:Estudiante | certAprobado[a,e]) or (one a:Asignatura, e:Estudiante | nocertAprobado[a,e]))
}

run Traza

