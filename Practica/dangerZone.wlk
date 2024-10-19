class Empleado{
    var property habilidades = #{}
    var property salud
    const property jefe 

    method incapacitado(){
        return salud < self.saludCritica()
    }
    method saludCritica()

    method poseeHabilidad(unaHabilidad){
      return habilidades.contains(unaHabilidad)
    }
    method puedeUsarHabilidad(unaHabilidad){
      self.poseeHabilidad(unaHabilidad) and not self.incapacitado()
    }
}

class Espia inherits Empleado{
    
    method aprenderHabilidad(nuevaHabilidad){
        habilidades.add(nuevaHabilidad)
    }
    override method saludCritica(){
      return 15
    }
}

class Oficinista inherits Empleado{
    var property estrellas  
    method ganarEstrella() {
     estrellas +=1   
    }
    override method saludCritica(){
      return (40-5*estrellas).max(0)
    }
}

class Equipo {
    var property empleados = []

}