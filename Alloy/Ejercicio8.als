sig Asignatura{
asigEstudiantes: set Estudiante
asigAprobados: set Estudiante
}{
//Restriccion: los aprobados deben ser parte de los estudiantes matriculados
asigAprobados in asigEstudiantes

//Restriccion: como maximo 10 estudiantes pueden estar matriculados
#estudiantes <= 10

}
sig Estudiante{}

fact{
 


}
